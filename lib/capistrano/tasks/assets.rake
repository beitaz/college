namespace :assets do
  desc 'Capistrano assets'
  task :prebuild do
    on roles(:all) do
      info 'Prebuild capistrano assets.'
    end
  end
end

before 'deploy:compile_assets', 'assets:prebuild'
