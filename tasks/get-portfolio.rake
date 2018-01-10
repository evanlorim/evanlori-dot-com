require 'cloudinary'
require 'json'

def query_folder(folder)
	max_results = 100
	images = []
	res = Cloudinary::Api.resources(:max_results => max_results, :type => 'upload', :prefix => folder)
	images.push(res['resources'])
	while res.has_key?("next_cursor") do
		res = Cloudinary::Api.resources(:max_results => max_results, :type => 'upload', :next_cursor => res["next_cursor"], :prefix => folder)
		images.push(res['resources'])
	end
	images = images.flatten
	return images
end

def write_json(data, output_path)
	exists = File.exists? File.expand_path(output_path)
	if (not exists)
		FileUtils.mkdir_p File.dirname(output_path)
	end
	File.open(output_path, "w") { |f| f.write(data.to_json) }
end

def get_cloudinary_folder(folder, task_symbol)
  desc "query #{folder} and write it to JSON"

  task task_symbol do
		output_path = File.join('_data/portfolio', folder + ".json")
		data = query_folder(folder)
		write_json(data, output_path)
		puts("wrote #{folder} to JSON")
  end
end

get_cloudinary_folder('logos', 'get_logos')
get_cloudinary_folder('flyers', 'get_flyers')
get_cloudinary_folder('digital', 'get_digital')
get_cloudinary_folder('traditional', 'get_traditional')

task :get_portfolio do
	Rake::Task['get_logos'].execute
	Rake::Task['get_flyers'].execute
	Rake::Task['get_digital'].execute
	Rake::Task['get_traditional'].execute
end
