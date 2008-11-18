class Language < ActiveRecord::Base
  has_many :learnings
  has_many :users, :through => :learnings

  has_many :words
  # belongs_to :user
  validates_presence_of :name, :code
  
  def self.get_or_create_default_language
    default_code = "en"; default_name = "english"
    default_language = Language.find_by_code(default_code)
    return default_language unless default_language.nil?
    return Language.create( :name => default_name, :code => default_code )
  end
  
end
