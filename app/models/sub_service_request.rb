class SubServiceRequest < SparcRequestBase
  belongs_to :protocol

  has_many :line_items
end
