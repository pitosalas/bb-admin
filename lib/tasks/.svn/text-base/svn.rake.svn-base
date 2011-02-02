namespace :svn do

   desc "Configure a new project for subversion"
   task :configure do
     FileUtils.mv 'config/database.yml', 'config/database.example.yml'
     system "svn propset svn:ignore 'database.yml' config"
     system "svn add . --force"
     system "svn remove log/* --force"
     system "svn propset svn:ignore '*' log"
     system "svn remove tmp/* --force"
     system "svn propset svn:ignore '*' tmp"
     FileUtils.cp 'config/database.example.yml', 'config/database.yml'
     FileUtils.chmod 0755, %w(log/ public/dispatch.rb public/dispatch.cgi public/dispatch.fcgi)
     system "svn propset svn:executable ON public/dispatch.* script/process/*"
   end

end