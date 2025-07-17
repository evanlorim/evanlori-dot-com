module Jekyll
    module CloudinaryFilters
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

Liquid::Template.register_filter(Jekyll::CloudinaryFilters)