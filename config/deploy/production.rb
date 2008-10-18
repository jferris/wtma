# For migrations
set :rails_env, 'production'

# Who are we?
set :application, 'wheresthemilkat'
set :repository, "git@github.com:railsrumble/giant-robots.git"
set :scm, "git"
set :deploy_via, :remote_cache
set :branch, "production"

# Where to deploy to?
role :web, "72.14.181.21"
role :app, "72.14.181.21"
role :db,  "72.14.181.21", :primary => true

# Deploy details
set :user, "#{application}"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false
set :checkout, 'export'

# We need to know how to use mongrel
set :mongrel_rails, '/usr/bin/mongrel_rails'
set :mongrel_cluster_config, "#{deploy_to}/#{current_dir}/config/mongrel_cluster_production.yml"
