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
    user = User.find(:first, current_user_id)
    @first_language = user.first_language
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

  def all
    # "en" and "hu" should be substituted by from_lang and to_lang
    # but then it should be done in the view, too
    @from_lang = get_from_lang
    @to_lang = get_to_lang

    ##FIXME: Paginator is removed from Rails 2.0.2, so another solution must be found
    # paginator described here:
    # http://www.nullislove.com/2007/05/24/pagination-in-rails/
    page = (params[:page] ||= 1).to_i
    items_per_page = 10
    offset = (page - 1) * items_per_page


    item_count = count_words({:lang => @from_lang})
    # @word_pages = Paginator.new(self, item_count, items_per_page, page)
    # @word_items = find_words(items_per_page, offset)
    @word_items = Word.find(:all) # find_word_pairs(@from_lang, @to_lang, items_per_page, offset)
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

end
