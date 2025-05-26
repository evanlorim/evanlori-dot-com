require 'fileutils'

def copy_files_task_factory(source, target, task_symbol)
  desc "copy #{source.to_s} to #{target}"
  task task_symbol do
		FileUtils.mkdir_p(target)
		FileUtils.cp_r(source, target)
		puts("copied #{source.to_s} to #{target}")
  end
end

# Bulma 

copy_files_task_factory('node_modules/bulma/sass', '_sass/bulma', 'copy_bulma_a')
copy_files_task_factory('node_modules/bulma/bulma.sass', '_sass/bulma', 'copy_bulma_b')

desc "copy bulma libs"
task :copy_bulma do
	Rake::Task['copy_bulma_a']
	Rake::Task['copy_bulma_b']
end

desc "delete bulma files"
task :delete_bulma do
    FileUtils.remove_dir("_sass/bulma")
    FileUtils.remove_file("_sass/bulma.sass")
    puts("deleted _sass/bulma and _/sass/bulma.sass")
end


# FontAwesome

copy_files_task_factory('node_modules/Font-Awesome/css/all.css', 'assets/css', 'copy_font_awesome_a')
copy_files_task_factory('node_modules/Font-Awesome/webfonts', 'assets', 'copy_font_awesome_b')

desc "copy fontawesome libs"
task :copy_font_awesome do
	Rake::Task['copy_font_awesome_a']
	Rake::Task['copy_font_awesome_b']
end

desc "delete font-awesome"
task :delete_fontawesome do
    Dir.glob('assets/webfonts/fa*').each do|f|
        FileUtils.remove_file(f)
    end
    FileUtils.remove_file("assets/css/all.css")
    puts("deleted fa webfonts and assets/css/all.css")
end

# Jquery
copy_files_task_factory('node_modules/jquery/dist/jquery.min.js', 'js', 'copy_jquery')

desc "delete jquery"
task :delete_jquery do
    FileUtils.remove_file("js/jquery.min.js")
    puts ("delete js/jquery.min.js")
end

# Bulma-Divider
copy_files_task_factory('node_modules/bulma-divider/dist/bulma-divider.sass', '_sass/bulma-divider/', 'copy_bulma_divider')

desc "delete bulma-divider"
task :delete_bulma_divider do
    FileUtils.remove_dir("_sass/bulma-divider")
    puts("removed _sass/bulma-divider")
end

# Bulma-Carousel
copy_files_task_factory('node_modules/bulma-carousel/dist/bulma-carousel.sass', '_sass/bulma-carousel/', 'copy_bulma_carousel_css')
copy_files_task_factory('node_modules/bulma-carousel/dist/bulma-carousel.js', 'js', 'copy_bulma_carousel_js')

desc "copy bulma-carousel libs"
task :copy_bulma_carousel do
	Rake::Task['copy_bulma_carousel_css']
	Rake::Task['copy_bulma_carousel_js']
end

desc "delete bulma-carousel"
task :delete_bulma_carousel do
    FileUtils.remove_dir("_sass/bulma-carousel")
    FileUtils.remove_file("js/bulma-carousel.js")
    puts("removed _sass/bulma-carousel and js/bulma-carousel.js")
end

# Open-Color
copy_files_task_factory('node_modules/open-color/open-color.scss', '_sass/open-color', 'copy_open_color')

desc "delete open-color"
task :delete_open_color do
    FileUtils.remove_dir("_sass/open-color")
    puts("removed _sass/open-color")
end

desc "copy all vendor libs"
task :copy_vendor_libs do
	Rake::Task['copy_bulma_a'].execute
	Rake::Task['copy_bulma_b'].execute
	Rake::Task['copy_font_awesome_a'].execute
	Rake::Task['copy_font_awesome_b'].execute
	Rake::Task['copy_jquery'].execute
	Rake::Task['copy_bulma_divider'].execute
	Rake::Task['copy_bulma_carousel_css'].execute
	Rake::Task['copy_bulma_carousel_js'].execute
	Rake::Task['copy_open_color'].execute
end

desc "delete all"
task :delete_vendor_libs do
    Rake::Task['delete_bulma'].execute
    Rake::Task['delete_fontawesome'].execute
    Rake::Task['delete_jquery'].execute
    Rake::Task['delete_bulma_divider'].execute
    Rake::Task['delete_bulma_carousel'].execute
    Rake::Task['delete_open_color'].execute
end