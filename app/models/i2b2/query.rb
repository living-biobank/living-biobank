module I2b2
  class Query < I2b2::Base
    self.table_name = "MUSC_I2B2DATA.QT_QUERY_MASTER"

    scope :filtered_for_index, -> (term, sort_by, sort_order) {
      search(term).
      ordered_by(sort_by, sort_order).
      distinct
    }

    scope :search, -> (term) {
      return if term.blank?

      where('lower(name) LIKE ?', "%#{term.downcase}%")
    }

    scope :team_member, -> (netid_array) {
      where(user_id: netid_array)
    }

    scope :ordered_by, -> (sort_by, sort_order) {
      sort_by = sort_by.blank? ? 'create_date' : sort_by
      sort_order = sort_order.blank? ? 'desc' : sort_order

      case sort_by
      when 'name'
        order(name: sort_order)
      when 'date'
        order(create_date: sort_order)
      end
    }
  end
end
