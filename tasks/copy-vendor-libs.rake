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
copy_files('node_modules/jquery/dist/jquery.min.js', 'js', 'cp_jquery')
copy_files('node_modules/bulma-divider/dist/bulma-divider.sass', '_sass/bulma-divider/', 'cp_bulma_divider')
copy_files('node_modules/bulma-carousel/dist/bulma-carousel.sass', '_sass/bulma-carousel/', 'cp_bulma_carousel_css')
copy_files('node_modules/bulma-carousel/dist/bulma-carousel.js', 'js', 'cp_bulma_carousel_js')
copy_files('node_modules/open-color/open-color.scss', '_sass/open-color', 'cp_open_color')
# rewrite these lines later vvv
# copy_files('node_modules/font-mfizz/dist/font-mfizz.css', 'assets/css/font-mfizz', 'cp_font_mfizz_a')
# copy_files('node_modules/font-mfizz/dist/font-mfizz.eot', 'assets/css/font-mfizz', 'cp_font_mfizz_b')
# copy_files('node_modules/font-mfizz/dist/font-mfizz.svg', 'assets/css/font-mfizz', 'cp_font_mfizz_c')
# copy_files('node_modules/font-mfizz/dist/font-mfizz.ttf', 'assets/css/font-mfizz', 'cp_font_mfizz_d')
# copy_files('node_modules/font-mfizz/dist/font-mfizz.woff', 'assets/css/font-mfizz', 'cp_font_mfizz_e')

task :copy_vendor_libs do
	Rake::Task['cp_bulma_a'].execute
	Rake::Task['cp_bulma_b'].execute
	Rake::Task['cp_font_awesome_a'].execute
	Rake::Task['cp_font_awesome_b'].execute
	Rake::Task['cp_sass_material_colors'].execute
	Rake::Task['cp_jquery'].execute
	Rake::Task['cp_bulma_divider'].execute
	Rake::Task['cp_bulma_carousel_css'].execute
	Rake::Task['cp_bulma_carousel_js'].execute
	Rake::Task['cp_open_color'].execute
	# Rake::Task['cp_font_mfizz_a'].execute
	# Rake::Task['cp_font_mfizz_b'].execute
	# Rake::Task['cp_font_mfizz_c'].execute
	# Rake::Task['cp_font_mfizz_d'].execute
	# Rake::Task['cp_font_mfizz_e'].execute
end
