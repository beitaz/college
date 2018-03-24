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

require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
