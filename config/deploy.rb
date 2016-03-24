set :application, 'DevpanelWaf'
set :repo_url, 'git@github.com:freeminder/devpanel_waf.git'


set :bundle_without, ["development", "test"]
set :stages, ["staging", "production"]
set :default_stage, "production"
set :passenger_restart_with_touch, true


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/srv/www/devpanel_waf'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/local_env.yml config/secrets.yml db/development.sqlite3}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Migrate DB'
  task :migrate do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'db:migrate'
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :migrate
  after :publishing, :restart

end

