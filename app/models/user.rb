class User < ApplicationRecord
  include DirtyAssociations
  has_and_belongs_to_many :groups, join_table: :lab_honest_brokers,
    after_add: :dirty_create,
    after_remove: :dirty_delete

  has_many :honest_broker_labs, through: :groups, source: :labs
  has_many :honest_broker_requests, through: :groups, source: :sparc_requests

  has_many :sources, through: :groups

  has_many :sparc_requests
  has_many :i2b2_queries, class_name: "I2b2::QueryName", foreign_key: :user_id, primary_key: :net_id

  has_many :labs

  before_destroy :check_for_admin
  validate :admin_presence, on: [:update]
  after_update :send_permissions_email

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, authentication_keys: [:net_id]

  scope :data_honest_brokers, -> { where(data_honest_broker: true) }

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

  private

  def check_for_admin
    unless User.where(admin: true).count > 1
      errors.add(:user, I18n.t(:errors)[:user][:user_delete])
      throw(:abort)
    end
  end

  def admin_presence
    if admin_changed?(from: true, to: false) && User.where(admin: true).count < 2
      self.clear_changes_information
      errors.add(:admin, I18n.t(:errors)[:user][:admin_change])
    end
  end

  def send_permissions_email
    if self.saved_changes[:admin].present? || self.saved_changes[:data_honest_broker].present? || self.saved_changes[:group].present?
      UserPermissionsMailer.permissions_changed(self, self.saved_changes).deliver_now
    end
  end
end
