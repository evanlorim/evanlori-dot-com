module Jekyll
  module ImageFilters
    # def image_url_(public_id, type)
    #   site = @context.registers[:site]
    #   config = @context.registers[:site].config
    #   data = @context.registers[:site].data
    #   cloud_name = config['cloud_name']
    #   all_ts = data['images']['transformations']
    #   img_ts = all_ts.select { |item| item['public_id'] == public_id && item['type'] == type }.first
    #   img_t_default = data['default']['transformation'][type]
    #   all_formats = data['images']['formats']
    #   img
    def image_url(public_id, *transformation)
      site = @context.registers[:site]
      cloud_name = site.config['cloud_name']
      file_type="jpeg"
      url = "http://res.cloudinary.com/"
      url += "#{cloud_name}/"
      url += "image/"
      url += "upload/"
      url += "#{transformation.join("/")}/" if transformation
      url += "#{public_id}.#{file_type}"
      url
    end
  end
end

Liquid::Template.register_filter(Jekyll::ImageFilters)