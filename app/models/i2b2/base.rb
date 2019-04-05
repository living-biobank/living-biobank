module I2b2
  class Base < ActiveRecord::Base
    self.abstract_class = true

    establish_connection I2B2_DB
  end
end
