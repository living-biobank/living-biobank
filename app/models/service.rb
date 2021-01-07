class Service < ApplicationRecord
  belongs_to :group
  belongs_to :sparc_service, class_name: "SPARC::Service", foreign_key: :sparc_id

  has_one :organization, through: :sparc_service, class_name: "SPARC::Organization"

  delegate :name, to: :sparc_service

  acts_as_list scope: :group

  validates_uniqueness_of :sparc_id, scope: :group_id
  validates_presence_of :status, :condition

  scope :filtered_for_index, -> (term, status, condition, sort_by, sort_order) {
    search(term).
    with_status(status).
    with_condition(condition).
    ordered_by(sort_by, sort_order).
    distinct
  }

  scope :search, -> (term) {
    return if term.blank?

    queried_sparc_ids = SPARC::Service.where(id: pluck(:sparc_id)).where(SPARC::Service.arel_table[:name].lower.matches("%#{term}%")).ids
    queried_status_ids = self.select{ |s| s.human_status.include?(term) }.map(&:id)
    queried_condition_ids = self.select{ |s| s.human_condition.include?(term) }.map(&:id)

    where(sparc_id: queried_sparc_ids
    ).or(
      where(id: queried_status_ids + queried_condition_ids)
    )
  }

  scope :with_status, -> (status) {
    status = status.blank? ? 'any' : status

    if status == 'any'
      return
    elsif status == 'none'
      where(status: nil)
    else
      where(status: status)
    end
  }

  scope :with_condition, -> (condition) {
    condition = condition.blank? ? 'any' : condition

    if condition == 'any'
      return
    elsif condition == 'none'
      where(condition: nil)
    else
      where(condition: condition)
    end
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_by     = sort_by.blank? ? 'position' : sort_by
    sort_order  = sort_order.blank? ? 'asc' : sort_order

    case sort_by
    when 'name'
      sparc_ids = SPARC::Service.where(id: pluck(:sparc_id)).order(SPARC::Service.arel_table[sort_by].send(sort_order)).ids
      order(Service.send(:sanitize_sql_array, ['FIELD(sparc_id, ?)', sparc_ids])).where(sparc_id: sparc_ids)
    when 'organization'
      sparc_ids = SPARC::Service.where(id: pluck(:sparc_id)).sort_by{ |s| s.organization.org_tree_display }.map(&:id)
      sparc_ids.reverse if sort_order == 'desc'
      order(Service.send(:sanitize_sql_array, ['FIELD(sparc_id, ?)', sparc_ids])).where(sparc_id: sparc_ids)
    else
      order(sort_by => sort_order)
    end
  }

  def human_condition
    self.condition ? I18n.t("groups.services.conditions.#{condition}") : I18n.t('constants.na')
  end

  def human_status
    I18n.t("requests.statuses.#{self.status}")
  end
end
