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

desc "copy all vendor libs"
task :copy_vendors do
    Rake::Task['copy_bulma'].execute
	Rake::Task['copy_opencolor'].execute
end

desc "delete all vendor libs"
task :delete_vendors do
    Rake::Task['delete_bulma'].execute
	Rake::Task['delete_opencolor'].execute
end

desc "post yarn install script"
task :post_install do
	Rake::Task['copy_vendors'].execute
end


desc "post removing all node_modules script"
task :post_uninstall do
	Rake::Task['delete_vendors'].execute
end