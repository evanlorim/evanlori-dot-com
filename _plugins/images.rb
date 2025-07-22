module Jekyll
  module ImageFilters
    def image_url(public_id, type)
      site = @context.registers[:site]
      config = @context.registers[:site].config
      data = @context.registers[:site].data
      cloud_name = config['cloud_name']
      
      xforms = data['images']['transformations']
      xform_d = data['images']['default']['transformation'][type]
      xform_ovrd = xforms.select { |item| item['public_id'] == public_id && item['type'] == type }.first
      xform = xform_ovrd && xform_ovrd['transformation'] || xform_d

      formats = data['images']['formats']
      format_d = data['images']['default']['format'][type]
      format_ovrd = formats.select { |item| item['public_id'] == public_id && item['type'] == type }.first
      format = format_ovrd && format_ovrd['format'] || format_d
      
      url = "http://res.cloudinary.com/"
      url += "#{cloud_name}/"
      url += "image/"
      url += "upload/"
      url += "#{xform.join("/")}/" if xform
      url += "#{public_id}.#{format}"
      url
    end
  end
end

Liquid::Template.register_filter(Jekyll::ImageFilters)