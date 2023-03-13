class TagsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    if params[:query].present?
      sql_query = <<~SQL
        tags.name @@ :query
      SQL
      @tags = Tag.where(sql_query, query: "%#{params[:query]}%")
    else
      @tags = nil
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end
end
