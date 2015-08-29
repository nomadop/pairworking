class Grad < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  scope :working, -> { where(id: Pair.working.pluck(:grad1_id, :grad2_id).flatten.uniq) }
  scope :on_beach, -> { where.not(id: Pair.working.pluck(:grad1_id, :grad2_id).flatten.uniq) }
  scope :dev, -> { where(role: 'DEV') }

  has_many :pairs_as_grad1, class_name: 'Pair', foreign_key: 'grad1_id'
  has_many :pairs_as_grad2, class_name: 'Pair', foreign_key: 'grad2_id'

  def working?
    Pair.working.pluck(:grad1_id, :grad2_id).flatten.uniq.include?(id)
  end

  def on_beach?
    !working?
  end

  def pairs
    Pair.where(id: pairs_as_grad1_ids + pairs_as_grad2_ids)
  end

  def find_pair
    pairs = Pair.arel_table
    Pair.where(pairs[:grad1_id].eq(id).or(pairs[:grad2_id].eq(id))).order(pair_time: :desc).first
  end
end
