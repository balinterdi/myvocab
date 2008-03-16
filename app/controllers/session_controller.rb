class SessionController < ApplicationController
  layout "standard-layout"
  def set
    if request.post?
      @from_lang = session[:from_lang] = params[:from_lang] == '' ? 'en' : params[:from_lang]
      @to_lang = session[:to_lang] = params[:to_lang] == '' ? 'hu' : params[:to_lang]
    end
  end
end
