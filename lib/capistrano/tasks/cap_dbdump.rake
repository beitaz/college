namespace :cap_dbdump do
  desc 'Dump old database'
  task :dbdump do
    on roles(:all) do
      execute "mysqldump -u root -p 123abc.. college_production > #{deploy_to}/shared/db/#{fetch(:datetime)}.dump"
    end
  end
end

before :deploy, 'cap_dbdump:dbdump'
