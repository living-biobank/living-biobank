class SparcRequestBase < ActiveRecord::Base
  self.abstract_class = true

  establish_connection SPARC_REQUEST_DB
end
