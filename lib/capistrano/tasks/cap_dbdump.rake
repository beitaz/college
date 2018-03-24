namespace :cap_db do
  desc 'Dump old database'
  task :backup do
    on roles(:all) do
      info 'Database backup.'
      backup_path = "#{fetch(:deploy_to)}/shared/db"
      file_name = "#{fetch(:datetime)}.dump"
      username = 'root'
      password = '123abc..'
      database = 'college_production'
      execute :mkdir, "-p #{backup_path}"
      execute :mysqldump, "-u #{username} --password=#{password} --databases #{database} > #{deploy_to}/shared/db/#{file_name}"
    end
  end
end

before :deploy, 'cap_db:backup'
