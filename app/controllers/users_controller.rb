class UsersController < ApplicationController
  # skip_before_action :authenticate_user!, only: %i[login signin]
  before_action :set_user, only: %i[logout show destroy]

  def index
    @users = User.all
    authorize @users
  end

  def home
    @user = current_user
    authorize @user
  end

  def profile
    @user = current_user
    authorize @user
  end

  def setting
    @user = current_user
    authorize @user
    if @user.update(user_params)
      @user.reprocess_avatar
      redirect_to profile_path
    else
      render :profile
    end
  end

  def show
  end

  def destroy
    @user.destroy
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email, :mobile, :password, :password_confirmation, :rememeber_me, :avatar,
                                   :crop_x, :crop_y, :crop_w, :crop_h)
    end
end
