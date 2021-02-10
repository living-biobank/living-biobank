class GroupsSource < ApplicationRecord
  belongs_to :source
  belongs_to :group

  has_many :line_items

  validates_presence_of :name

  validates :discard_age, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 10000 }

  # See https://stackoverflow.com/questions/16719463/adding-errors-to-model-in-rails-is-not-working
  # The error added by this validation is removed when the source is
  # automatically validated, so we have to call this validation in the
  # controller.
  # validate :unique_source?

  accepts_nested_attributes_for :source

  scope :active, -> { where(deprecated: false) }
  scope :inactive, -> { where(deprecated: true) }

  scope :filtered_for_index, -> (term, sort_by, sort_order) {
    search(term).
    ordered_by(sort_by, sort_order).
    distinct
  }

  scope :search, -> (term) {
    return if term.blank?

    where(GroupsSource.arel_table[:name].matches("%#{term}")
    ).or(
      GroupsSource.arel_table[:description].matches("%#{term}")
    ).or(
      Source.arel_table[:key].matches("%#{term}")
    ).or(
      Source.arel_table[:value].matches("%#{term}")
    )
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_by     = sort_by.blank? ? 'name' : sort_by
    sort_order  = sort_order.blank? ? 'asc' : sort_order

    case sort_by
    when 'key', 'value'
      order(Source.arel_table[sort_by].send(sort_order))
    else
      order(sort_by => sort_order)
    end
  }

  def formatted_discard_age
    "#{self.discard_age} #{I18n.t('groups.sources.discard_age_suffix')}"
  end

  def unique_source?
    if taken = self.group.sources.where.not(id: self.source_id).where(key: self.source.key).any?
      self.source.errors.add(:key, :taken)
    end
    !taken
  end
end
