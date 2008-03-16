class Meaning < ActiveRecord::Base
  # it would belong to the two models of the
  # relationship (e.g category and product)
  # belongs_to :category, belongs_to :product
  # but in my case both models are the same (Word)
  # so what do I write?
  # belongs_to :word - that's not correct

  # a self-referencing assocition is the solution, explained here:
  # http://railsforum.com/viewtopic.php?id=6613
  belongs_to :word
  belongs_to :synonym, :foreign_key => 'synonym_word_id', :class_name => 'Word'

end
