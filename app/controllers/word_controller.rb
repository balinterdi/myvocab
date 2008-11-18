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
    @word = Word.new
    @user = User.find(:first, current_user_id)
		@user.add_as_default_language(Language.find_by_code("en")) if @user.default_language.nil?		
  end

  def create
    sql = ActiveRecord::Base.connection()
    @w1 = Word.new(params[:word1])
    @w2 = Word.new(params[:word2])
    # if request.post?
    if @w1.save
    end
    redirect_to :action => "new"
  end

  def index
    ##FIXME: Paginator is removed from Rails 2.0.2, so another solution must be found
    # paginator described here:
    # http://www.nullislove.com/2007/05/24/pagination-in-rails/
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
