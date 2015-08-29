class Grad < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  scope :working, -> { where(id: Pair.working.pluck(:grad1_id, :grad2_id).flatten.uniq) }
  scope :on_beach, -> { where.not(id: Pair.working.pluck(:grad1_id, :grad2_id).flatten.uniq) }
  scope :dev, -> { where(role: 'DEV') }
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

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

  def find_dev_pair
    pairs = Pair.arel_table
    devs_on_beach_ids = Grad.dev.active.on_beach.pluck(:id)

    Pair.where((pairs[:grad1_id].eq(id)
            .and(pairs[:grad2_id].in(devs_on_beach_ids)))
            .or(pairs[:grad2_id].eq(id)
            .and(pairs[:grad1_id].in(devs_on_beach_ids))))
            .order(:pair_time).first
  end
end
