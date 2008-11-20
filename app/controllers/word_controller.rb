class WordController < ApplicationController
  layout "standard-layout"
  before_filter :check_authentication

  def new
    #TODO: the Word model should save the other word (the synonym), too.
    # After that (maybe with an after_update, see advanced rails recipe),
    # a meaning has to be created if the name in the first language
    # is not yet present as a meaning
    # That would mean, in fact for the Word model to save synonyms,
    # something a railscast shows us how to do
    @user = User.find(current_user_id)
		@user.add_as_default_language(Language.find_by_code("en")) if @user.default_language.nil?
		@word = Word.new
  end

  def create
		# params[:word].merge!(:language => Language.find(params[:word][:language]))
		# params[:word].merge!(:user => User.find(params[:word][:user]))
		# 		
	  @word = Word.new(params[:word])
		if @word.save
			flash[:notice] = "words successfully created."
			redirect_to words_for_user_path
		else
			render :action => "new"
		end  
  end

  def index
    @words = Word.find(:all, :conditions => [ "user_id = ?", current_user_id])
  end

  def search
    unless params[:query].nil?
      conditions = ["name LIKE ? AND lang='en'", "%#{params[:query]}%"]
      @words = Word.find(:all, :conditions => conditions )
      if request.xml_http_request?
        render :partial => "search_result", :layout => false
      end
    else
      @words = []
    end
  end

  def most_popular
  end

end
