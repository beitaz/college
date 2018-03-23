namespace :cap_assets do
  desc 'Capistrano assets'
  task :prebuild do
    on roles(:all) do
      info 'Prebuild capistrano assets.'
    end
  end
end

before 'deploy:compile_assets', 'cap_assets:prebuild'
