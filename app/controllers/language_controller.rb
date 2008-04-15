class LanguageController < ApplicationController
  layout "standard-layout"

  def new
    @language = Language.new
  end

  def create
    Language.create(params[:language])
    redirect_to home_url
  end

end
