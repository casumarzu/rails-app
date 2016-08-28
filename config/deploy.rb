lock '3.5.0'
set :application, 'rails-app'
set :repo_url, 'git@github.com:casumarzu/rails-app.git'

set :rvm_type, :user

ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :sockets_path, Pathname.new("#{fetch(:deploy_to)}/shared/tmp/sockets/")
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads private}

set :keep_releases, 5

set :log_level, :info
set :format, :pretty
set :pty, true

# PUMA CONFIG
app_dir = '/var/www/fatsuash.ru/rails-app'
shared_dir = "#{app_dir}/shared"
set :puma_user, fetch(:user)
set :puma_rackup, -> { "#{app_dir}/current/config.ru"}
set :puma_state, "#{shared_dir}/tmp/pids/puma.state"
set :puma_pid, "#{shared_dir}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_dir}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_default_control_app, "unix://#{shared_dir}/tmp/sockets/pumactl.sock"
set :puma_conf, "#{shared_dir}/puma.rb"
set :puma_access_log, "#{shared_dir}/log/puma_access.log"
set :puma_error_log, "#{shared_dir}/log/puma_error.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [2, 8]
set :puma_workers, 2
set :puma_worker_timeout, nil
set :puma_init_active_record, false
set :puma_preload_app, false
set :nginx_use_ssl, false

# SSHKit.config.command_map[:rake]  = "/usr/bin/env RAILS_ENV=#{fetch(:rails_env)} bundle exec rake"

namespace :deploy do
  desc 'Deploy app for first time'
  task :cold do
    invoke 'deploy:starting'
    invoke 'deploy:started'
    invoke 'deploy:updating'
    invoke 'bundler:install'
    invoke 'deploy:db_schema_load'
    invoke 'deploy:db_seed'
    invoke 'deploy:compile_assets'
    invoke 'deploy:normalize_assets'
    invoke 'deploy:publishing'
    invoke 'deploy:published'
    invoke 'deploy:finishing'
    invoke 'deploy:finished'
  end

  desc 'Setup database'
  task :db_schema_load do
    on roles(:db) do
      within release_path do
        with rails_env: (fetch(:rails_env) || fetch(:stage)) do
          execute :rake, 'db:schema:load'
        end
      end
    end
  end

  desc 'Seed database'
  task :db_seed do
    on roles(:db) do
      within release_path do
        with rails_env: (fetch(:rails_env) || fetch(:stage)) do
          execute :rake, 'db:seed'
        end
      end
    end
  end
end
