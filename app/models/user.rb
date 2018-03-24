# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(50)       default(""), not null
#  mobile                 :string(20)       default(""), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  role                   :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#

class User < ApplicationRecord
  # nomarl 普通用户， student 学生， patriarch 家长， teacher 教师， agent 代理商， enterprise 机构， admin 管理员
  enum role: %i[normal student patriarch teacher agent enterprise admin]
  has_paper_trail on: [:update, :destroy], only: %w[username email mobile password role]
  # Include default devise modules. Others available are: :lockable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :notifications, foreign_key: :recipient_id
  after_initialize :set_default_role, if: :new_record?
  after_create :set_username_mobile
  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' },
                             content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] },
                             default_url: ->(_attachment) { ActionController::Base.helpers.asset_path('missing.jpg') },
                             processors: [:cropper]
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  # after_update :reprocess_avatar, :if => :cropping?

  def set_default_role
    self.role ||= :normal
  end

  def set_username_mobile
    tmp = email.strip
    self.username = username.presence || tmp.slice(0, 50)
    self.mobile = mobile.presence || tmp.slice(0, 20)
  end

  def role?(role_name)
    self.role == role_name.to_s
  end

  def admin?
    role?(:admin)
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  end

  def reprocess_avatar
    avatar.reprocess!
  end
end
