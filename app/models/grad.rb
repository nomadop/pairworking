class Grad < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  scope :working, -> { where(id: Pair.working.pluck(:grad1_id, :grad2_id).flatten.uniq) }
  scope :on_beach, -> { where.not(id: Pair.working.pluck(:grad1_id, :grad2_id).flatten.uniq) }

  has_many :pairs_as_grad1, class_name: 'Pair', foreign_key: 'grad1_id'
  has_many :pairs_as_grad2, class_name: 'Pair', foreign_key: 'grad2_id'

  def working?
    pairs_as_grad1.any?(&:working?)
    pairs_as_grad2.any?(&:working?)
  end

  def find_pair
    pairs = Pair.arel_table
    Pair.where(pairs[:grad1_id].eq(id).or(pairs[:grad2_id].eq(id))).order(pair_time: :desc).first
  end
end
