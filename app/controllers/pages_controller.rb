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
      redirect_to :root, alert: "There is no more grad on beach!"
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
    pairs = Pair.arel_table
    devs_on_beach_ids = Grad.dev.on_beach.pluck(:id)
    if grad1.nil? && grad2.nil?
      pair = Pair.on_beach.order(:pair_time).first
    elsif grad1.nil?
      pair = Pair.where((pairs[:grad1_id].eq(grad2.id).and(pairs[:grad2_id].in(devs_on_beach_ids)))
                            .or(pairs[:grad2_id].eq(grad2.id).and(pairs[:grad1_id].in(devs_on_beach_ids)))).order(:pair_time).first
    elsif grad2.nil?
      pair = Pair.where((pairs[:grad1_id].eq(grad1.id).and(pairs[:grad2_id].in(devs_on_beach_ids)))
                            .or(pairs[:grad2_id].eq(grad1.id).and(pairs[:grad1_id].in(devs_on_beach_ids)))).order(:pair_time).first
    else
      pair = Pair.where(grad1: [grad1, grad2], grad2: [grad1, grad2]).take
    end
    pair
  end
end
