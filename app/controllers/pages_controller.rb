class PagesController < ApplicationController

  def find_pair
    grad1 = Grad.find_by(id: params[:my_id])
    grad2 = Grad.find_by(id: params[:pair_id])

    if !grad1.nil? && grad1 == grad2
      redirect_to :root, alert: "You can't pair with yourself"
      return
    end

    pair = searching_best_pair(grad1, grad2)

    if pair.nil?
      redirect_to :root, alert: "There is no more dev on beach is active!"
    else
      redirect_to kick_off_pair_path(pair)
    end
  end


  def home
    @grads_on_beach = Grad.on_beach
    @pairs_on_working = Pair.working
  end

  private
  def searching_best_pair(grad1, grad2)
    if grad1.nil? && grad2.nil?
      pair = Pair.on_beach.order(:pair_time).first
    elsif grad1.nil?
      pair = grad2.find_dev_pair
    elsif grad2.nil?
      pair = grad1.find_dev_pair
    else
      pair = Pair.where(grad1: [grad1, grad2], grad2: [grad1, grad2]).take
    end
    pair
  end
end
