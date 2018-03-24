class ApplicationController < ActionController::Base
  layout :full_or_partial
  include Pundit
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller? # 健壮参数
  # 必须在 authenticate_user! 认证之前存储 “访问历史”，因为存储行为会打乱正常的跳转流程，防止认证错误
  before_action :store_user_location!, if: :storable_location?
  # 将认证设置在 protect_from_forgery 之后才不会报错 “Can't verify CSRF token authenticity”
  before_action :authenticate_user! # 设置 Devise 认证
  before_action :set_paper_trail_whodunnit # 设置 paper_trail 使用 current_user 记录调用
  after_action :verify_authorized, unless: :static_devise_controller? # 开发环境强制要求每个 action 均有权限验证
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

    def after_sign_in_path_for(resource)
      current_user.admin? ? home_path : stored_location_for(resource) || super
    end

    def after_sign_out_path_for(resource)
      stored_location_for(resource) || super
    end

    def configure_permitted_parameters
      attrs = %i[username mobile email password password_confirmation remember_me]
      devise_parameter_sanitizer.permit(:sign_up, keys: attrs)
      devise_parameter_sanitizer.permit(:sign_in, keys: attrs)
      devise_parameter_sanitizer.permit(:account_update, keys: attrs)
    end

  private

    def full_or_partial
      need_full_layout? ? 'fullayout' : 'application'
    end

    # 在下列情况时判断所访问的 URL 是否可存储是非常重要的：
    # - 该请求不是 GET 方法 (non idempotent)
    # - 该请求由 Devise 控制器（如Devise :: SessionsController）处理，可能导致无限重定向循环
    # - 该请求是一个 Ajax 请求，可能会导致非常意外的行为
    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
    end

    def store_user_location!
      store_location_for(:user, request.fullpath)
    end

    def user_not_authorized(exception)
      # flash[:alert] = 'You are not authorized to perform this action.'
      # 一些浏览器不支持 HTTP referer header （即不支持 request.referer 方式），所以只能用 Devise 内建的 store_location_for
      # redirect_to(request.referrer || root_path) # 重定向到请求前的 URL 或者 根路径

      # 自定义异常信息（默认 pundit.default = 'You are not authorized to perform this action.'）
      policy_name = exception.policy.class.to_s.underscore
      flash[:error] = t("#{policy_name}.#{exception.query}", scope: 'pundit', default: :default)
      redirect_to(request.referrer || root_path)
    end

    # 需要跳过权限验证的控制器 static、devise
    def static_devise_controller?
      skip_authenticate = ['static']
      skip_authenticate.include?(controller_name) || devise_controller?
    end

    def need_full_layout?
      # TODO: 管理员需要特别处理
      # 需要全版面布局的 controller 和 actions
      full_layout = { users: %w[home profile] }
      flag = false
      full_layout.each_pair do |controller, actions|
        if controller_name == controller.to_s && actions.include?(action_name)
          flag = true
          break
        end
      end
      static_devise_controller? || flag
    end
end
