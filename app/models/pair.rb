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
  end
  before_save :set_pair_name
  before_save :check_grads

  belongs_to :grad1, class_name: 'Grad'
  belongs_to :grad2, class_name: 'Grad'

  enum status: [:on_beach, :working]

  def check_in(story)
    update(story: story, status: :working, pair_time: pair_time + 1)
  end

  def check_out
    update(story: nil, status: :on_beach)
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
