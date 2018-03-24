# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "\n======    Initializing...    ======\n\n"
admin = User.create(email: 'admin@example.com', password: '123abc..', role: User.roles[:admin], confirmed_at: Time.zone.now)
admin.save
normal = User.create(email: 'normal@example.com', password: '123abc..', confirmed_at: Time.zone.now)
normal.save

# 根据不同环境，初始化数据
if Rails.env.development?
  puts 'Initialize development data.'
  # 初始化开发环境数据
elsif Rails.env.production?
  puts 'Initialize production data.'
  # 初始化生产环境数据
else
  puts 'Initialize test data.'
  # 初始化测试环境数据
  # require "#{Rails.root}/db/init/test/user"
end

puts "\n====== All data initialized. ======\n\n"
