desc "copy bulma"
task :copy_bulma do
	FileUtils.mkdir_p("_sass/bulma")
	FileUtils.cp_r("node_modules/bulma/sass", "_sass/bulma")
	FileUtils.cp("node_modules/bulma/bulma.scss", "_sass/bulma")
	puts("copied bulma to _sass/bulma")
end

desc "delete bulma"
task :delete_bulma do
	FileUtils.remove_dir("_sass/bulma")
	puts("deleted _sass/bulma")
end

desc "copy open color"
task :copy_opencolor do
	FileUtils.cp_r("node_modules/open-color", "_sass")
	puts("copied open color to _sass/open-color")
end

desc "delete open color"
task :delete_opencolor do
	FileUtils.remove_dir("_sass/open-color")
end

desc "copy simple icons"
task :copy_simpleicons do
	FileUtils.mkdir_p("assets/fonts/simple-icons")
	FileUtils.cp("node_modules/simple-icons-font/font/simple-icons.css", "assets/fonts/simple-icons")
	FileUtils.cp("node_modules/simple-icons-font/font/simple-icons.json", "assets/fonts/simple-icons")
	FileUtils.cp("node_modules/simple-icons-font/font/SimpleIcons.eot", "assets/fonts/simple-icons")
	FileUtils.cp("node_modules/simple-icons-font/font/SimpleIcons.ttf", "assets/fonts/simple-icons")
	FileUtils.cp("node_modules/simple-icons-font/font/SimpleIcons.woff", "assets/fonts/simple-icons")
	FileUtils.cp("node_modules/simple-icons-font/font/SimpleIcons.woff2", "assets/fonts/simple-icons")
	puts("copied simple icons to assets/fonts/simple-icons")
end

desc "delete simple icons"
task :delete_simpleicons do
	FileUtils.remove_dir("assets/fonts/simple-icons")
end

desc "copy remix icons"
task :copy_remixicons do
	FileUtils.mkdir_p("assets/fonts/remix-icons")
	FileUtils.cp("node_modules/remixicon/fonts/remixicon.css", "assets/fonts/remix-icons")
  FileUtils.cp("node_modules/remixicon/fonts/remixicon.eot", "assets/fonts/remix-icons")
  FileUtils.cp("node_modules/remixicon/fonts/remixicon.glyph.json", "assets/fonts/remix-icons")
  FileUtils.cp("node_modules/remixicon/fonts/remixicon.ttf", "assets/fonts/remix-icons")
  FileUtils.cp("node_modules/remixicon/fonts/remixicon.woff", "assets/fonts/remix-icons")
  FileUtils.cp("node_modules/remixicon/fonts/remixicon.woff2", "assets/fonts/remix-icons")
	puts("copied remix icons to assets/fonts/remix-icons")
end

desc "delete remix icons"
task :delete_remixicons do
	FileUtils.remove_dir("assets/fonts/remix-icons")
end

desc "copy all vendor libs"
task :copy_vendors do
	Rake::Task['copy_bulma'].execute
	Rake::Task['copy_simpleicons'].execute
  	Rake::Task['copy_remixicons'].execute
end

desc "delete all vendor libs"
task :delete_vendors do
	Rake::Task['delete_bulma'].execute
	Rake::Task['delete_simpleicons'].execute
	Rake::Task['delete_remixicons'].execute
end

desc "post yarn install script"
task :post_install do
	Rake::Task['copy_vendors'].execute
end

desc "post removing all node_modules script"
task :post_uninstall do
	Rake::Task['delete_vendors'].execute
end
