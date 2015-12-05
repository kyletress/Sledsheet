class Api::V1::EntriesController < ApplicationController

  def index
    @entries = Entry.includes(:athlete).all
  end

  def show
    @entry = Entry.find(params[:id])
  end

end
