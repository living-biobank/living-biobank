module SPARC
  class Base < ActiveRecord::Base
    self.abstract_class = true

    establish_connection(SPARC_REQUEST_DB)

    def self.inherited(child)
      child.establish_connection(SPARC_REQUEST_DB)
      super
    end

    def self.table_name_prefix
      SPARC_REQUEST_DB['database'] + '.'
    end
  end
end
