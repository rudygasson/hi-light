class UsersController < ApplicationController
  before_action :set_highlight, only: ['destroy', 'update']
  before_action :set_user, only: ['follow', 'show', 'friends_profile', 'edit', 'update']

  def show
  end

  def friends_profile
  end

  def index
    if params[:query].present?
      sql_query = <<~SQL
        users.first_name @@ :query
        OR users.last_name @@ :query
      SQL
      @users = User.where(sql_query, query: "%#{params[:query]}%")
    else
    @users = User.all
    end
  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  def follow
    if current_user.favorited?(@user)
      current_user.unfavorite(@user)
    else
      current_user.favorite(@user)
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :encrypted_password, :photo)
  end
end
