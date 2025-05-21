# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "evanlori-dot-com"
set :repo_url, "git@github.com:evanlorim/evanlori-dot-com"


set :deploy_to, -> { "/var/www/evanlori.com" }

set :ssh_options, { :forward_agent => true }

set :repo_tree, '_site'
