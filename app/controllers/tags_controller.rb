class TagsController < ApplicationController
  def index
    if params[:query].present?
      sql_query = <<~SQL
        tags.name @@ :query
      SQL
      @tags = Tag.where(sql_query, query: "%#{params[:query]}%")
    else
      @tags = Tag.all
    end
  end
end
