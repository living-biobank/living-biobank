module SPARC
  class LineItem < SPARC::Base
    belongs_to :service_request
    belongs_to :sub_service_request
    belongs_to :service

    has_many :bb_line_items, class_name: "::LineItem", foreign_key: :sparc_id
  end
end
