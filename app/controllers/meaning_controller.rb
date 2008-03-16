class MeaningController < ApplicationController
  scaffold :meaning

  def new
    @msg = "Hello world 2"
  end
end
