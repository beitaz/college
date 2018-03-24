namespace :cap_chown do
  desc 'Change passenger dog owner'
  task :change_owner do
    on roles(:all) do
      dog_path = '/var/run/passenger-instreg'
      username = 'bestar'
      # 需要设置 set :ssh_options, forward_agent: true
      execute :sudo, "chown -R #{username}: #{dog_path}"
    end
  end
end

before 'passenger:restart', 'cap_chown:change_owner'
