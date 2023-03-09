class TagsController < ApplicationController
  before_action :set_user

  def index
    params[:query].present?
      sql_query = <<~SQL
        tags.name @@ :query
      SQL
      @tags = Tag.where(sql_query, query: "%#{params[:query]}%", user: current_user)
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def set_user
    @user = current_user
  end

end
