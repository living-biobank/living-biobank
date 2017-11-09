class Protocol < ApplicationRecord
  self.inheritance_column = nil
  include SparcShard

  has_one :sparc_request
end
