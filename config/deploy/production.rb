set :deploy_to, '/var/www/fatsquash.ru/rails-app'
set :branch, 'master'
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :keep_releases, 5
set :log_level, :info

set :stage, :production
set :rails_env, :production

set :linked_files, %w(
  database.yml
  secrets.yml
).map { |f| "config/#{f}"}

set :bundle_flags, '--deployment'

set :default_env, { path: "#{fetch(:bundle_binstubs)}:$PATH" }

server '85.143.217.107', user: 'root', roles: %w{web app db}

SSHKit.config.command_map[:rake]  = "/usr/bin/env RAILS_ENV=#{fetch(:rails_env)} bundle exec rake"
