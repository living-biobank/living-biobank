class Group < ApplicationRecord
  has_many :lab_honest_brokers
  has_many :groups_sources
  has_many :active_groups_sources, -> { active }, class_name: "GroupsSource"
  has_many :sources, through: :groups_sources

  has_many :services, dependent: :destroy

  has_many :labs,                     through: :sources
  has_many :line_items,               through: :groups_sources
  has_many :sparc_requests,           through: :line_items
  has_many :lab_honest_broker_users,  through: :lab_honest_brokers, source: :user

  has_rich_text :release_email
  has_rich_text :discard_email
  has_rich_text :finalize_email

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :release_email
  validates_presence_of :discard_email, if: :process_specimen_retrieval?

  validates_inclusion_of :process_specimen_retrieval,             in: [true, false]
  validates_inclusion_of :notify_when_all_specimens_released,     in: [true, false]
  validates_inclusion_of :process_sample_size,                    in: [true, false]

  validates_format_of :finalize_email_to, with: /\A([^\s\@]+@[A-Za-z0-9.-]+)(,[ ]?[^\s\@]+@[A-Za-z0-9.-]+)*\Z/, allow_blank: true

  scope :filtered_for_index, -> (term, sort_by, sort_order) {
    search(term).
    ordered_by(sort_by, sort_order).
    distinct
  }

  scope :search, -> (term) {
    return if term.blank?

    queried_service_ids = SPARC::Service.where(SPARC::Service.arel_table[:name].matches("%#{term}%")).ids

    eager_load(:sources, :services).where(Group.arel_table[:name].matches("%#{term}%")
    ).or(
      eager_load(:sources, :services).where(Source.arel_table[:key].matches("%#{term}%"))
    ).or(
      eager_load(:sources, :services).where(Source.arel_table[:value].matches("%#{term}%"))
    ).or(
      eager_load(:sources, :services).where(Service.arel_table[:sparc_id].in(queried_service_ids))
    )
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_by     = sort_by.blank? ? 'name' : sort_by
    sort_order  = sort_order.blank? ? 'desc' : sort_order
    
    order(sort_by => sort_order)
  }

  def identifier
    self.name
  end
end
