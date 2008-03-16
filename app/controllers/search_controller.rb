class SearchController < ApplicationController
  layout "standard-layout"
  auto_complete_for :word, :name
end
