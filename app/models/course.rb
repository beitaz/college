# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  subject    :string(255)
#  category   :integer
#  grade      :integer
#  teacher    :integer          not null
#  quantity   :integer          default(1), not null
#  price      :integer          default(0), not null
#  status     :integer          default(0)
#  deleted    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Course < ApplicationRecord
  # 0: 语文, 1: 英语, 2: 数学, 3: 物理 , 4: 化学, 5: 历史
  enum category: %i[chinese english math history physics chemistry politics]
  # 0: developing, 1: created, 2: unpublish, 3: published, 4: disabled, 5: full
  enum status: %i[developing created unpublish published disabled full]
end
