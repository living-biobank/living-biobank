class Protocol < ApplicationRecord
  self.inheritance_column = nil
  include SparcShard
end
