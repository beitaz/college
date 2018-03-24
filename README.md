# College

Scratch 平台项目。


## 项目初始化 [Rails](https://github.com/rails/rails)

* 创建项目
```shell
$ rails new college -d mysql -B
$ bundle install
$ rubocop --auto-gen-config
$ overcommit -i
$ overcommit --sign
```

* 移除 Turbolinks 
```ruby
# 删除\注释掉 Gemfile 中的引用
gem 'turbolinks'
# 修改 app/views/layouts/application.html.erb 中的设置 "data-turbolinks-track" => "reload" 
<%= stylesheet_link_tag    'application', media: 'all' %>
<%= javascript_include_tag 'application' %>
# 删除 app/assets/javascripts/application.js 中的引用 "data-turbolinks-track" => "reload"
//= require turbolinks
```

* 修改 `.overcommit.yml` 配置：
```ruby
CommitMsg:
  CapitalizedSubject:
    enabled: false

PreCommit:
  AuthorName:
    enabled: false
  RuboCop:
    enabled: true
    command: ['bundle', 'exec', 'rubocop', '-c', '.rubocop.yml']

PrePush:
  RSpec:
    enabled: false
```

---

## [Devise 认证](https://github.com/plataformatec/devise)

* 修改 `Gemfile`：
```ruby
gem 'devise'
```

* 生成 Devise 配置文件：
```shell
$ rails generate devise:install
```

* 修改 Devise 配置：
```ruby
# config/environments/development.rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
# config/environments/production.rb
config.action_mailer.default_url_options = { host: 'production_real_domain' }
```

* 生成 Devise 模型、视图、控制器：
```shell
$ rails generate devise MODEL
$ rails db:migrate
$ rails generate devise:views users
$ rails generate devise:controllers users
```

若生成 `controllers` 时指定 `scope` ，如上述命令，则生成的控制器如下：
```ruby
class Users::SessionsController < Devise::SessionsController
  # 相当于指定了 Module 名称，且目录名称也会变成 'users'
end
```
同时，需要修改 `config/routes.rb` 中的配置：
```ruby
Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }
end
```
**注意：若使用 `rails generate controller users` 生成自定义 `UsersController`，配置路由时，需要将自定义控制器放在 Devise 之下：** 
```ruby
Rails.application.routes.draw do
  devise_for :users, controllers: {
    ...
  }
  resources :users # 在 devise 之前定义会被覆盖
```

* 设置认证过滤器和辅助方法：
```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
end
```
**注意：** Rails 5 之后，需要将 `before_action :authenticate_user!` 设置在 `protect_from_forgery` 之后，否则会导致 **`"Can't verify CSRF token authenticity."`**

* 设置 Devise 健壮参数：
```ruby
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
    def configure_permitted_parameters
    attrs = %i[username mobile email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit(:sign_up, keys: attrs)
    devise_parameter_sanitizer.permit(:sign_in, keys: attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: attrs)
  end
end
```

---

## [Pundit 权限管理](https://github.com/varvet/pundit)

* 修改 `Gemfile`：
```ruby
gem 'pundit'
```

* 在 `app/application_controller.rb` 中引入 Pundit：
```ruby
class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery
end
```

* 生成权限验证器：
```shell
$ rails g pundit:install
```

* 生成指定 Model 的相关 policy：
```shell
$ rails g pundit:policy user
```

* 在需要验证的位置添加权限验证方法 `authorize`

* **开发环境** 中启用 `verify_authorized` 保证所有操作均通过验证。
```ruby
class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized # 可以加 exclude: [:index, :show] 或 only: [:update, :create] 条件修饰符
end
```

* 捕获 Pundit 的 `Pundit::NotAuthorizedError`（未授权异常）
```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

```
或者通过配置 `config/application.rb` 重定向到 403 页面：
```ruby
config.action_dispatch.rescue_responses["Pundit::NotAuthorizedError"] = :forbidden
```

---

## [Figaro 全局配置](https://github.com/laserlemon/figaro)

* 修改 `Gemfile`：
```ruby
gem 'figaro'
```

* 安装并生成配置文件：
```shell
$ bundle exec figaro install
```
**注意：** 安装命令默认将 `config/application.yml` 添加到 `.gitignore` 文件中，需要提交时请手动修改，建议复制后提交 `config/application.example.yml` 文件。

## [PaperTrail 操作记录](https://github.com/airblade/paper_trail)

* 修改 `Gemfile`：
```ruby
gem 'paper_trail'
```

* 生成 PaperTrail 配置文件：
```shell
$ bundle exec rails generate paper_trail:install
$ bundle exec rake db:migrate
```

* 需要记录操作的 Model 中添加 PaperTrail 配置：
```ruby
class Model < ActiveRecord::Base
  has_paper_trail
end
```

* 如果 controllers 有 `current_user` 方法，记录操作者：
```ruby
class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit
end
```

## [Capistrano 自动部署](https://github.com/capistrano/capistrano)

* 修改 `Gemfile`：
```ruby
group :development do
  gem 'capistrano', '~> 3.10'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  ...
end
```

* 安装并生成 `Capistrano` 配置文件：
```shell
$ bundle install
$ bundle exec cap install
```
所有可用的命令：
```shell
$ bundle exec cap -T  # list all available tasks
$ bundle exec cap staging deploy  # deploy to the staging environment
$ bundle exec cap production deploy  # deploy to the production environment
$ bundle exec cap production deploy --dry-run  # simulate deploying to the production environment does not actually do anything
$ bundle exec cap production deploy --prereqs  # list task dependencies
$ bundle exec cap production deploy --trace  # trace through task invocations
$ bundle exec cap production deploy --print-config-variables  # lists all config variable before deployment tasks
```

* 自动部署前，需要手动安装 `PaperClip` 需要的 `ImageMagick`：

```SHELL
$ sudo yum update && sudo yum install -y ImageMagick.x86_64
```

## 使用 Yarn 添加第三方 Javascript 库
* [可选]修改 `Gemfile`
```ruby
# gem 'font-awesome-sass', '~> 5.0.6' # 使用 yarn 方式添加第三方库，移除或注释此行
```

* 将添加的库放到 `APP_NAME/vendor/assets/components` 中：
```shell
$ yarn add font-awesome --modules-folder ./vendor/assets/components/
```

* 修改 `config/initializers/assets.rb` 添加如下配置 Rails 资源解析路径 & 字体预编译：

```ruby
Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "components")
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
```

* 创建 `app/assets/stylesheets/font-awesome.scss` 以复写 `$fa-font-path`
```javascript
// 也可覆盖其他 sass-rails 预定义样式。
// 此处的 font-awesome 对应 vendor/assets/components/font-awesome
$fa-font-path: "font-awesome/fonts/";
@import "font-awesome/scss/font-awesome";
```

* 在 `app/assets/stylesheets/application.scss` （注意是 SCSS）中引入样式：
```scss
/*
 *= require font-awesome
 * require_tree .
 * require_self
 */

// 或者使用如下方式
@import "jquery/dist/jquery";
@import "font-awesome";
```

## 静态资源

* 将第三方资源库加入到 `vendor/assets/` 目录下，同时修改 `*.css` => `*.css.scss` 并将 `url('*')` 修改为 `url(asset_path('*'))`：
```SHELL
$ mv vendor/stylesheets/jquery.Jcrop.min.css vendor/stylesheets/jquery.Jcrop.min.css.scss
```

* 修改 url('Jcrop.gif')
```CSS
.jcrop-vline,.jcrop-hline{background:#FFF url(asset_path('Jcrop.gif'));font-size:0;position:absolute;}
```

* PaperClip 默认头像问题（将 default_url: 'images/:style/missing.png' 改为 `asset_path('missing.png')` 方式）：
```RUBY
class User < ApplicationRecord
  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' },
                             content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] },
                             default_url: ->(_attachment) { ActionController::Base.helpers.asset_path('missing.jpg') },
                             processors: [:cropper]
end
```
