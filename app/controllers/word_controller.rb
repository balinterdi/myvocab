class WordController < ApplicationController
  layout "standard-layout"

  def new
    @word = Word.new
  end

  def create
  end

  def pair
    #TODO: the Word model should save the other word (the synonym), too.
    # After that (maybe with an after_update, see advanced rails recipe),
    # a meaning has to be created if the name in the first language
    # is not yet present as a meaning
    # That would mean, in fact for the Word model to save synonyms,
    # something a railscast shows us how to do
    user = User.find(:first, current_user_id)
    @first_language = user.first_language
    @default_language = user.default_language
  end

  def create_pair
    sql = ActiveRecord::Base.connection()
    @w1 = Word.new(params[:word1])
    @w2 = Word.new(params[:word2])
    # if request.post?
    if @w1.save
      # since Meaning is totally empty
      # the db row representing it
      # has to be created by hand
      # @m = Meaning.new
      # meaning_id = sql.insert("INSERT INTO meanings values ( nextval('meanings_id_seq') )")
      # sql.commit_db_transaction
      # @w1.update_attribute(:meaning_id, meaning_id)
      # @w2.update_attribute(:meaning_id, meaning_id)
      flash[:notice] = "Word saved"
    end
    redirect_to :action => "pair" # "all"
  end

  def translate
    @word = Word.find(@params['id'])
    @m = @word.meaning
    @meaning_id = @m.id
    # @m = Meaning.find(:first, :conditions => { :id => @params[:meaning_id]} )
    # @m = "HELLO"
  end

  def unfilled
    sql = ActiveRecord::Base.connection()
    @unfilled_words = Word.find_by_sql("SELECT words_en.id, words_en.name  FROM words_en LEFT OUTER JOIN words_hu ON words_en.meaning_id = words_hu.meaning_id WHERE words_hu.name IS NULL ORDER BY words_en.name ASC;")
    # @unfilled_words = Word.find(:all,
    #                       :select => "words_en.name AS en_name",
    #                       :conditions => ["words_hu.name is null"],
    #                       :order => "en_name ASC",
    #                       :joins => "LEFT OUTER JOIN words_hu ON words_hu.meaning_id=words_en.meaning_id")

  end

  def save_unfilled
    @w_from = Word.find_by_id(params[:w_from]["id"])
    @w_to = Word.new(:name => params[:w_to]["name"], :lang => "hu")
    if @w_from.save
      sql = ActiveRecord::Base.connection()
      # since Meaning is totally empty
      # the db row representing it
      # has to be created by hand
      # @m = Meaning.new
      meaning_id = sql.insert("INSERT INTO meanings values ( nextval('meanings_id_seq') )")
      sql.commit_db_transaction
      @w_from.update_attribute(:meaning_id, meaning_id)
      @w_to.update_attribute(:meaning_id, meaning_id)
      flash[:notice] = "Word saved"
    end
    redirect_to :action => "unfilled"
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

  def quiz
    @quiz_status = nil
    @good_answer = nil
    if request.post?
      from_word = Word.find_by_name_and_lang(params[:from_word], get_from_lang)
      to_word = Word.find_by_name_and_lang(params[:to_word], get_to_lang)
      unless to_word.nil?
        if from_word.meaning_id == to_word.meaning_id
          @quiz_status = :success
        else
          @quiz_status = :failed
          @good_answer = Word.find_by_lang_and_meaning_id(get_to_lang, from_word.meaning_id)
        end
      else
          @quiz_status = :failed
          @good_answer = Word.find_by_lang_and_meaning_id(get_to_lang, from_word.meaning_id)
      end
      @to_word_name = params[:to_word]

    else
      from_word = Word.find(:first, :order => "random()", :conditions => { "lang" => get_from_lang } )
      @to_word_name = nil
    end
    @from_word_name = from_word.name
  end

  private
  def count_words(conditions)
    #FIXME: v should only be bordered with apostrophes
    # if it is a string value
    conditions = conditions.collect { |k, v| "#{k} = '#{v}'" }.join(" AND ")
    Word.count(conditions)
  end

  def find_word_pairs(from_lang, to_lang, items_per_page, offset)
    words_from = Word.find_all_by_lang(from_lang, :order => "name", :offset => offset, :limit => items_per_page)
    word_pairs = []
    words_from.each do |w_from|
      w_to = Word.find_by_lang_and_meaning_id(to_lang, w_from.meaning_id)
      word_pairs << { from_lang => w_from, to_lang => w_to }
    end
    return word_pairs
  end
end
