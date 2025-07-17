require 'cloudinary'
require 'cloudinary/api'
require 'json'
require 'fileutils'
require 'set'
require 'csv'

IMAGES_FILE = "_data/images.csv"
TRANSFORMATIONS_FILE = "_data/transformations.csv"

FOLDERS = %w[
	portfolio
]

TRANSFORMATIONS = {
	thumb: [
		{
			width: 512,
			height: 512,
			crop: 'auto',
			gravity: 'auto'
		}
	]
}

def _config
	if Cloudinary.config.api_key.nil? || Cloudinary.config.api_key.strip.empty?
		require './config'
	end
end

desc "Fetch image metadata and write to _data/images.csv"
task :init_images do
	begin
		_config()
		all_images = []

		FOLDERS.each do |folder|
			next_cursor = nil
			begin
				response = Cloudinary::Api.resources(
					type: 'upload',
					prefix: "#{folder}/",
					max_results: 100,
					next_cursor: next_cursor
				)

				response['resources'].each do |res|
					all_images << {
						public_id: res['public_id'],
						format: res['format'],
						width: res['width'],
						height: res['height'],
						url: res['secure_url']
					}
				end

				next_cursor = response['next_cursor']
			end while next_cursor
		end

		CSV.open(IMAGES_FILE, 'w', headers: %w[public_id format width height url], write_headers: true) do |csv|
			all_images.each do |img|
				csv << img.values_at(:public_id, :format, :width, :height, :url)
			end
		end

		puts "Fetched metadata for #{all_images.size} images into #{IMAGES_FILE}"
	rescue => e
		puts "Error: #{e.message}"
	end
end

desc "Update _data/images.csv with new images from Cloudinary (no duplicates)"
task :update_images do
	begin
		_config()

		existing_images = []
		existing_ids = Set.new

		if File.exist?(IMAGES_FILE)
			CSV.foreach(IMAGES_FILE, headers: true) do |row|
				existing_images << row.to_h
				existing_ids.add(row['public_id'])
			end
		end

		new_images = []

		FOLDERS.each do |folder|
			next_cursor = nil
			begin
				response = Cloudinary::Api.resources(
					type: 'upload',
					prefix: "#{folder}/",
					max_results: 100,
					next_cursor: next_cursor
				)

				response['resources'].each do |res|
					unless existing_ids.include?(res['public_id'])
						image_data = {
							public_id: res['public_id'],
							format: res['format'],
							width: res['width'],
							height: res['height'],
							url: res['secure_url']
						}
						new_images << image_data
						existing_ids.add(res['public_id'])
					end
				end

				next_cursor = response['next_cursor']
			end while next_cursor
		end

		all_images = existing_images + new_images

		CSV.open(IMAGES_FILE, 'w', headers: %w[public_id format width height url], write_headers: true) do |csv|
			all_images.each do |img|
				csv << img.values_at('public_id', 'format', 'width', 'height', 'url')
			end
		end

		puts "Added #{new_images.size} new images. Total images now: #{all_images.size}."
	rescue => e
		puts "Error: #{e.message}"
	end
end

desc "Write transformation entries per image and type to _data/transformations.csv"
task :init_transformations do
	begin
		_config()

		unless File.exist?(IMAGES_FILE)
			puts "#{IMAGES_FILE} does not exist. Run init_images task first."
			exit 1
		end

		images = CSV.read(IMAGES_FILE, headers: true)

		CSV.open(TRANSFORMATIONS_FILE, 'w', headers: %w[public_id type transformation url], write_headers: true) do |csv|
			images.each do |image|
				TRANSFORMATIONS.each do |type, chain|
					csv << [
						image['public_id'],
						type.to_s,
						chain.to_json,
						'' # placeholder for URL
					]
				end
			end
		end

		puts "Wrote transformation entries to #{TRANSFORMATIONS_FILE}"
	rescue => e
		puts "Error: #{e.message}"
	end
end

desc "Update _data/transformations.csv by adding missing transformation entries"
task :update_transformations do
	begin
		_config()

		unless File.exist?(IMAGES_FILE)
			puts "#{IMAGES_FILE} does not exist. Run init_images task first."
			exit 1
		end

		images = CSV.read(IMAGES_FILE, headers: true)

		existing = []
		existing_pairs = Set.new

		if File.exist?(TRANSFORMATIONS_FILE)
			existing = CSV.read(TRANSFORMATIONS_FILE, headers: true)
			existing.each do |row|
				existing_pairs.add([row['public_id'], row['type']])
			end
		end

		new_entries = []

		images.each do |image|
			TRANSFORMATIONS.each do |type, chain|
				pair = [image['public_id'], type.to_s]
				unless existing_pairs.include?(pair)
					new_entries << {
						public_id: image['public_id'],
						type: type.to_s,
						transformation: chain.to_json,
						url: ''
					}
					existing_pairs.add(pair)
				end
			end
		end

		all_entries = existing.map(&:to_h) + new_entries

		CSV.open(TRANSFORMATIONS_FILE, 'w', headers: %w[public_id type transformation url], write_headers: true) do |csv|
			all_entries.each do |row|
				csv << row.values_at('public_id', 'type', 'transformation', 'url')
			end
		end

		puts "Added #{new_entries.size} new entries. Total entries now: #{all_entries.size}."
	rescue => e
		puts "Error: #{e.message}"
	end
end

desc "Generate transformed URLs and update only the 'url' column in _data/transformations.csv"
task :generate_transformation_urls do
	begin
		_config()

		unless File.exist?(TRANSFORMATIONS_FILE)
			puts "#{TRANSFORMATIONS_FILE} does not exist. Run init_transformations or update_transformations first."
			exit 1
		end

		rows = CSV.table(TRANSFORMATIONS_FILE)

		rows.each do |row|
			public_id = row[:public_id]
			transformation_chain = JSON.parse(row[:transformation])

			symbolized_chain = transformation_chain.map { |step| step.transform_keys(&:to_sym) }

			url = Cloudinary::Utils.cloudinary_url(public_id, transformation: symbolized_chain)
			row[:url] = url
		end

		CSV.open(TRANSFORMATIONS_FILE, 'w', headers: rows.headers, write_headers: true) do |csv|
			rows.each { |row| csv << row }
		end

		puts "Updated 'url' for #{rows.size} transformation entries."
	rescue => e
		puts "Error: #{e.message}"
	end
end
