module Helpers

    def image_url(cloud_name, public_id, file_type="jpeg", *transformations)
        url = "http://res.cloudinary.com/"
        url += "#{cloud_name}/"
        url += "image/"
        url += "upload/"
        url += "#{transformations.join("/")}/" if transformations
        url += "#{public_id}.#{file_type}"
        url
    end
end

Liquid::Template.register_filter(Helpers)