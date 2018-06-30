# config valid for current version and patch releases of Capistrano
lock "~> 3.10"

set :application, "portal"
set :repo_url, "git@github.com:arpnetworks/portal.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

@deploy = YAML.load(File.read(File.join(File.dirname(__FILE__), 'arp', 'deploy.yml')))

# Default value for :linked_files is []
append :linked_files, "config/database.yml",
                      "config/arp/globals.yml",
                      "config/arp/password_encryption.yml",
                      "config/arp/tender.yml",
                      "config/arp/redis.yml",
                      "config/arp/hosts.yml",
                      "config/arp/iso-files.txt",
                      @deploy['configs']['billing']['gateway'],
                      @deploy['configs']['billing']['gpg'],
                      @deploy['configs']['billing']['paypal_key']

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, "log",
                     "tmp/pids",
                     "tmp/cache",
                     "tmp/sockets",
                     ".bundle"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
set :ssh_options, verify_host_key: :always

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

# Defaults to [:web]
set :assets_roles, [:app]

namespace :deploy do
  desc 'Copy stragglers'
  task :copy_stragglers do
    stragglers = [
      'bin/arp/provisioning/create_new_vps_account.rb',
      'lib/arp/utils.rb'
    ]

    stragglers.each do |straggler|
      `scp #{straggler} foo.example.com:#{release_path}/#{straggler}`
    end
  end

  before 'deploy:assets:precompile', :copy_stragglers
end
