module SPARC
  class ServiceProvider < SPARC::Base
    belongs_to :organization
    belongs_to :identity
  end
end
