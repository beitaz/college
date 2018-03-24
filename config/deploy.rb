# config valid for current version and patch releases of Capistrano
# lock '~> 3.10.1'

set :application, 'college'
set :repo_url, 'git@github.com:beitaz/college.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# 设置远程仓库缓存，每次部署时使用 git pull 而不是 git clone
set :repository_cache, 'git_cache'
set :deploy_via, :remote_cache

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/college'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Set RVM's ruby version (Must same as `Gemfile` ruby version)
set :rvm_ruby_version, '2.4.1'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'public/images'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :paperclip do
  desc 'build missing paperclip styles'
  task :build_missing_styles do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'paperclip:refresh:missing_styles'
        end
      end
    end
  end
end

after('deploy:compile_assets', 'paperclip:build_missing_styles')
