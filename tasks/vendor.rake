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

desc "copy pico"
task :copy_pico do
  FileUtils.mkdir_p("_sass/pico")
  FileUtils.cp_r("node_modules/@picocss/pico/scss", "_sass/pico")
  puts("copied pico to _sass/pico")
end

desc "delete pico"
task :delete_pico do
  FileUtils.remove_dir("_sass/pico")
  puts("deleted _sass/pico")
end

desc "copy all vendor libs"
task :copy_vendors do
	Rake::Task['copy_bulma'].execute
  Rake::Task['copy_pico'].execute
end

desc "delete all vendor libs"
task :delete_vendors do
    Rake::Task['delete_bulma'].execute
    Rake::Task['delete_pico'].execute
end