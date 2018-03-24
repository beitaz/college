namespace :cap_db do
  desc 'Dump old database'
  task :backup do
    on roles(:db) do
      username = 'root'
      password = '123abc..'
      database = 'college_production'
      execute :mysqldump, "-u #{username} --password #{password} --databases #{database} > \
                          #{deploy_to}/shared/db/#{fetch(:datetime)}.dump"
    end
  end
end

before :deploy, 'cap_db:backup'
