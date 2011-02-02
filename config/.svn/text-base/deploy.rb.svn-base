set :application, "bbadmin"
set :repository,  "http://www.blogbridge.com/svn/bbadmin/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/u/pitosalas/blogbridge.com/tools/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "blogbridge.com"
role :web, "blogbridge.com"
role :db,  "blogbridge.com", :primary => true

ssh_options[:port] = 31313

default_run_options[:pty] = true

load('config/deploy_personal.rb') if File.exists?('config/deploy_personal.rb')

def server_restart
end

mongrel_config_path="/etc/mongrel_cluster/3020_ps_bbadmin.yml"

namespace :deploy do
  task :stop do
    invoke_command "mongrel_rails cluster::stop -C #{mongrel_config_path}"
  end
  
  task :restart do
    invoke_command "mongrel_rails cluster::restart -C #{mongrel_config_path}"
  end
  
  task :start do
    invoke_command "mongrel_rails cluster::start -C #{mongrel_config_path}"
  end
end
