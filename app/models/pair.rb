class Pair < ActiveRecord::Base
  class << self
    def generate_pairs
      grads = Grad.all
      grads.each do |grad1|
        grads.each do |grad2|
          begin
            create(grad1: grad1, grad2: grad2)
          rescue Exception => e
          end
        end
      end
    end

    def waiting!(pairs)
      where(id: pairs.map(&:id)).update_all(status: 2)
    end

    def on_beach!(pairs)
      where(id: pairs.map(&:id)).update_all(status: 0)
    end
  end
  before_save :set_pair_name
  before_save :check_grads

  belongs_to :grad1, class_name: 'Grad'
  belongs_to :grad2, class_name: 'Grad'

  enum status: [:on_beach, :working, :waiting]

  def check_in(story)
    return false if grad1.working? || grad2.working?

    waiting_pairs = grad1.pairs + grad2.pairs
    Pair.waiting!(waiting_pairs)
    update(story: story, status: :working, pair_time: pair_time + 1)
  end

  def check_out
    return false if !working?

    gards_on_beach = Grad.on_beach
    pairs_on_beach =
      Pair.where(grad1: grad1, grad2: gards_on_beach) +
      Pair.where(grad1: gards_on_beach, grad2: grad1) +
      Pair.where(grad1: grad2, grad2: gards_on_beach) +
      Pair.where(grad1: gards_on_beach, grad2: grad2) +
      [self]

    Pair.on_beach!(pairs_on_beach)
  end

  private
  def grad_names
    [grad1.name, grad2.name]
  end

  def set_pair_name
    self.pair_name = "#{grad_names.max}/#{grad_names.min}"
  end

  def check_grads
    grad1 == grad2 ? false : true
  end
end
