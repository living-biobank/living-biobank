module SPARC
  class Service < SPARC::Base
    has_many :sparc_requests
  end
end
