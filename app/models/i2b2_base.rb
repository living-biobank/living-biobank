class I2b2Base < ActiveRecord::Base
  self.abstract_class = true

  establish_connection I2B2_DB
end
