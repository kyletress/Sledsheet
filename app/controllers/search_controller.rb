class SearchController < ApplicationController

  def index
    @results = PgSearch.multisearch(params[:q]).includes(:searchable).page params[:page]
  end

end
