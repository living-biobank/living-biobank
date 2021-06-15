module Shrine 
  class Base < ActiveRecord::Base
    self.abstract_class = true

    establish_connection SHRINE_DB
  end
end
