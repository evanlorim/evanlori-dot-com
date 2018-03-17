# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "evanlori-dot-com"
set :repo_url, "git@example.com:apathinwalking/evanlori-dot-com"


set :deploy_to, -> { "/var/www/evanlori.com" }

set :ssh_options, { :forward_agent => true }

set :repo_tree, '_site'
