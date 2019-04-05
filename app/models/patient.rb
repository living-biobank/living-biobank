class Patient < ApplicationRecord
  has_many :labs
  has_many :populations
  has_many :line_items, through: :populations
  has_many :sparc_requests, through: :line_items

  def protocols
    SPARC::Protocol.where(id: self.sparc_requests.pluck(:protocol_id))
  end
end
