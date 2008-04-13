class SearchController < ApplicationController
  layout "standard-layout"
  # this somehow broke when I upgraded to Rails 2.0.2
  # it is taken from Rails Recipes (Live Search), btw
  # auto_complete_for :word, :name
end
