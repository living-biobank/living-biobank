module Shrine 
  class Query < Shrine::Base
    # self.table_name = "I2B2NCATSDATA.QT_QUERY_MASTER"
    self.table_name = "SHRINE_QUERY"

    scope :filtered_for_index, -> (term, sort_by, sort_order) {
      search(term).
      ordered_by(sort_by, sort_order).
      distinct
    }

    scope :search, -> (term) {
      return if term.blank?

      where('lower(query_name) LIKE ?', "%#{term.downcase}%")
    }

    scope :ordered_by, -> (sort_by, sort_order) {
      sort_by = sort_by.blank? ? 'date_created' : sort_by
      sort_order = sort_order.blank? ? 'desc' : sort_order

      case sort_by
      when 'name'
        order(query_name: sort_order)
      when 'date'
        order(date_created: sort_order)
      end
    }
  end
end
