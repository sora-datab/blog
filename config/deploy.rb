# config valid for current version and patch releases of Capistrano
lock "~> 3.15.0"

set :application, "blog"
set :repo_url, "sora@pcanpi.com@example.com:me/my_repo.git"

# Default branch is :master
#set :branch, :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
#
# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

#배포 환경변수 설정
set :use_sudo, false
set :deploy_via, :remote_cache

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 3

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

## [Rails Version 6.0 ~] linked_files 파일을 EC2 서버로 Upload
namespace :deploy do
    namespace :check do
      before :linked_files, :set_master_key do
        on roles(:app), in: :sequence, wait: 10 do
          unless test("[ -f #{shared_path}/config/application.yml ]")
            upload! 'config/application.yml', "#{shared_path}/config/application.yml"
          end
          
          unless test("[ -f #{shared_path}/config/master.key ]")
            upload! 'config/master.key', "#{shared_path}/config/master.key"
          end
          
          unless test("[ -f #{shared_path}/config/database.yml ]")
            upload! 'config/database.yml', "#{shared_path}/config/database.yml"
          end
          
        end
      end
    end
  end