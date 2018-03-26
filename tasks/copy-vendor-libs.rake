require 'fileutils'

def copy_files(source, target, task_symbol)
  desc "copy #{source.to_s} to #{target}"
  task task_symbol do
		FileUtils.mkdir_p(target)
		FileUtils.cp_r(source, target)
		puts("copied #{source.to_s} to #{target}")
  end
end

copy_files('node_modules/bulma/sass', '_sass/bulma', 'cp_bulma_a')
copy_files('node_modules/bulma/bulma.sass', '_sass/bulma', 'cp_bulma_b')
copy_files('node_modules/Font-Awesome/web-fonts-with-css/css/fontawesome-all.css', 'assets/css', 'cp_font_awesome_a')
copy_files('node_modules/Font-Awesome/web-fonts-with-css/webfonts', 'assets', 'cp_font_awesome_b')
copy_files('node_modules/sass-material-colors/sass/.', '_sass/sass-material-colors', 'cp_sass_material_colors')
copy_files('node_modules/lightbox2/dist/js/lightbox-plus-jquery.js', 'js', 'cp_lightbox_js')
copy_files('node_modules/lightbox2/dist/css/lightbox.css', 'assets/css', 'cp_lightbox_css')
copy_files('node_modules/lightbox2/dist/images/', 'assets', 'cp_lightbox_images')
copy_files('node_modules/bulma-divider/dist/bulma-divider.sass', '_sass/bulma-divider/', 'cp_bulma_divider')
copy_files('node_modules/bulma-carousel/dist/bulma-carousel.sass', '_sass/bulma-carousel/', 'cp_bulma_carousel_css')
copy_files('node_modules/bulma-carousel/dist/bulma-carousel.js', 'js', 'cp_bulma_carousel_js')

task :copy_vendor_libs do
	Rake::Task['cp_bulma_a'].execute
	Rake::Task['cp_bulma_b'].execute
	Rake::Task['cp_font_awesome_a'].execute
	Rake::Task['cp_font_awesome_b'].execute
	Rake::Task['cp_sass_material_colors'].execute
	Rake::Task['cp_lightbox_js'].execute
	Rake::Task['cp_lightbox_css'].execute
	Rake::Task['cp_lightbox_images'].execute
	Rake::Task['cp_bulma_divider'].execute
	Rake::Task['cp_bulma_carousel_css'].execute
	Rake::Task['cp_bulma_carousel_js'].execute
end
