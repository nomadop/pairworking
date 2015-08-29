class PagesController < ApplicationController

  def home
    @grads_on_beach = Grad.on_beach
    @pairs_on_working = Pair.working
  end
end
