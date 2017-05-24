class WikisController < ApplicationController
  def index
    @wikis = Wikis.all
  end

  def show
  end

  def new
  end

  def edit
  end
end
