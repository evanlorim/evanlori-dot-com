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
copy_files('node_modules/font-awesome/scss/.', '_sass/font-awesome', 'cp_font_awesome')
copy_files('node_modules/sass-material-colors/sass/.', '_sass/sass-material-colors', 'cp_sass_material_colors')
copy_files('node_modules/lightbox2/dist/js/lightbox-plus-jquery.js', 'js', 'cp_lightbox_js')
copy_files('node_modules/lightbox2/dist/css/lightbox.css', 'assets/css', 'cp_lightbox_css')

task :copy_vendor_libs do
	Rake::Task['cp_bulma_a'].execute
	Rake::Task['cp_bulma_b'].execute
	Rake::Task['cp_font_awesome'].execute
	Rake::Task['cp_sass_material_colors'].execute
	Rake::Task['cp_lightbox_js'].execute
	Rake::Task['cp_lightbox_css'].execute
end
