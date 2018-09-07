class Patient < ApplicationRecord
  has_many :populations
  has_many :specimen_requests, through: :populations
  has_many :labs

  def protocols
    Protocol.where(id: self.specimen_requests.pluck(:protocol_id))
  end
end
