class I2B2Base < ActiveRecord::i2b2Base
  self.abstract_class = true

  establish_connection I2B2_DB
end
