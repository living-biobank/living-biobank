class User < ApplicationRecord
  include DirtyAssociations

  has_and_belongs_to_many :groups, join_table: :lab_honest_brokers,
    after_add: :dirty_create,
    after_remove: :dirty_delete

  has_many :honest_broker_labs, through: :groups, source: :labs
  has_many :honest_broker_requests, through: :groups, source: :sparc_requests

  has_many :sources, through: :groups

  has_many :sparc_requests
  has_many :i2b2_queries, class_name: "I2b2::Query", foreign_key: :user_id, primary_key: :net_id

  has_many :labs

  before_destroy :check_for_admin
  after_update :send_permissions_email

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, authentication_keys: [:net_id]

  scope :admins, -> { where(admin: true) }
  scope :data_honest_brokers, -> { where(data_honest_broker: true) }

  scope :filtered_for_index, -> (term, privileges, groups, sort_by, sort_order) {
    search(term).
    with_privileges(privileges).
    with_groups(groups).
    ordered_by(sort_by, sort_order).
    distinct
  }

  scope :search, -> (term) {
    return if term.blank?

    where(User.arel_table[:first_name].matches("%#{term}%")
    ).or(
      where(User.arel_table[:last_name].matches("%#{term}%"))
    ).or(
      where(User.arel_full_name.matches("%#{term}%"))
    ).or(
      where(User.arel_full_name.matches("%#{term}%"))
    ).or(
      where(User.arel_table[:net_id].matches("%#{term}"))
    ).or(
      where(User.arel_table[:email].matches("%#{term}%"))
    )
  }

  scope :with_privileges, -> (privileges) {
    privileges = privileges.blank? ? 'any' : privileges
    return if privileges == 'any'

    case privileges
    when 'user'
      left_outer_joins(:groups).where(groups: { id: nil }).where(admin: [nil, false], data_honest_broker: [nil, false])
    when 'admin'
      admins
    when 'lhb'
      joins(:groups)
    when 'dhb'
      data_honest_brokers
    end
  }

  scope :with_groups, -> (groups) {
    groups = groups.blank? ? 'any' : groups
    return if groups == 'any'

    joins(:groups).where(Group.arel_table[:name].eq(groups))
  }

  scope :ordered_by, -> (sort_by, sort_order) {
    sort_by     = sort_by.blank? ? 'name' : sort_by
    sort_order  = sort_order.blank? ? 'desc' : sort_order

    case sort_by
    when 'user', 'name'
      order('first_name' => sort_order, 'last_name' => sort_order, 'email' => sort_order)
    else
      order(sort_by => sort_order)
    end
  }

  def self.find_or_create(id)
    Directory.find_or_create(id)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if net_id = conditions.delete(:net_id)
      where(conditions.to_hash).where(["lower(net_id) = :value", { value: net_id.downcase }]).first
    elsif conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

  def self.find_for_shibboleth_oauth(auth, signed_in_resource=nil)
    unless user = User.where(net_id: auth.uid).first
      email = auth.info.email.blank? ? auth.uid : auth.info.email # in case shibboleth doesn't return the required parameters
      user = User.create(net_id: auth.uid, first_name: auth.info.first_name, last_name: auth.info.last_name, email: email, password: Devise.friendly_token[0,20])
    end
    user
  end

  def self.arel_full_name
    User.arel_table[:first_name].concat(Arel::Nodes.build_quoted(' ')).concat(User.arel_table[:last_name])
  end

  def full_name
    "#{self.first_name} #{self.last_name}".strip
  end

  def display_name
    "#{first_name.try(:humanize)} #{last_name.try(:humanize)} (#{email})".strip
  end

  def lab_honest_broker?
    self.groups.any?
  end 

  def eligible_requests
    if self.admin? || self.data_honest_broker?
      SparcRequest.all
    else
      requests_with_access = SparcRequest.where(protocol_id: SPARC::Protocol.joins(project_roles: :identity).where(
        identities: { ldap_uid: self.net_id },
        project_roles: { project_rights: %w(approve view) }
      ).ids)
     if self.lab_honest_broker?
        requests_with_access.or(SparcRequest.where(id: self.honest_broker_requests))
      else
        requests_with_access
      end.distinct
    end
  end

  def can_edit_request?(request)
    self.admin? || self.data_honest_broker? ||
      if request.protocol.project_roles.loaded?
        request.protocol.project_roles.detect{ |pr| %w(approve).include?(pr.project_rights) && pr.identity.ldap_uid == self.net_id }
      else
        request.protocol.project_roles.joins(:identity).where(project_rights: %w(request approve), identities: { ldap_uid: self.net_id })
      end
  end

  private

  def check_for_admin
    unless User.where(admin: true).count > 1
      self.errors.add(:base, :last)
      throw(:abort)
    end
  end

  def send_permissions_email
    if self.saved_changes[:admin].present? || self.saved_changes[:data_honest_broker].present? || self.saved_changes[:group].present?
      UserPermissionsMailer.permissions_changed(self, self.saved_changes).deliver_now
    end
  end
end
