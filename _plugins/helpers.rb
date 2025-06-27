module Helpers
    
    def regex_match(input, pattern)
        !!(input =~ Regexp.new(pattern))
    end
    
    def regex_remove(input, pattern)
        input.gsub(Regexp.new(pattern), '')
    end

    def breadcrumb_paths(input)
        category = input.match(%r{/category/([^/]+)})
        tag_components = input.match(%r{/tags/([^/]+)/([^/]+)})
        page = input.match(%r{/page([0-9]+)})
        
        results = []
        results.append("portfolio")
        if category
            results.append("category/" + category[1])
        end
        if tag_components
            results.append(tag_components[1] + "/" + tag_components[2])
        end
        if page
            results.append("page" + page[1])
        end
        results
    end

    def breadcrumb_titles(input)
        category = input.match(%r{/category/([^/]+)})
        tag_components = input.match(%r{/tags/([^/]+)/([^/]+)})
        page = input.match(%r{/page([0-9]+)})

        results = []
        results.append("Portfolio")
        if category
            results.append("Category: " + category[1].capitalize)
        end
        if tag_components
            results.append("Tag: " + tag_components[1].capitalize + " - " + tag_components[2].capitalize)
        end
        if page
            results.append("Page " + page[1])
        end
        results
    end

    def thumb_url(image_id, cloud_name)
        w = "512"
        h = "512"
        url = "http://res.cloudinary.com/"
        url = url + cloud_name + "/"
        url = url + "image" + "/"
        url = url + "upload" + "/"
        url = url + "w_" + w + ","
        url = url + "h_" + h + "/"
        url = url + image_id + ".jpeg"
        url
    end

    def image_url(image_id, cloud_name)
        url = "http://res.cloudinary.com/"
        url = url + cloud_name + "/"
        url = url + "image" + "/"
        url = url + "upload" + "/"
        url = url + image_id + ".jpeg"
        url
    end
end

Liquid::Template.register_filter(Helpers)