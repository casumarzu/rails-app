require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

set :domain, '85.143.217.107'
set :user, 'root'
set :deploy_to, '/var/www/fatsquash.ru/rails-app'
set :repository, 'git@github.com:casumarzu/rails-app.git'
set :branch, 'master'

set :term_mode, nil

set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'config/puma.rb', 'log']

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/puma"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/puma"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/puma.rb"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml', 'secrets.yml' and puma.rb."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
  end
end
