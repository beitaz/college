# namespace :permission do
#   desc 'Change passenger dog owner'
#   task :change_dog_owner do
#     on roles(:all) do
#       dog_path = '/var/run/passenger-instreg'
#       username = 'bestar'
#       # 需要设置 set :ssh_options, forward_agent: true
#       execute :chown, "-R #{username}: #{dog_path}"
#     end
#   end
# end

# before 'passenger:restart', 'permission:change_dog_owner'
