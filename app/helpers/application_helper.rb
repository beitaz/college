module ApplicationHelper
  # 判断给定字符串是否为单数
  def singular?(str)
    str.pluralize != str && str.singularize == str
  end
end
