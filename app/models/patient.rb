class Patient < ApplicationRecord
  has_many :populations
  has_many :sparc_requests, through: :populations
  has_many :labs

  def protocols
    Protocol.where(id: self.sparc_requests.pluck(:protocol_id))
  end
end
