class User < ApplicationRecord
  belongs_to :honest_broker, class_name: "Group", foreign_key: :honest_broker_id, optional: true

  has_many :sparc_requests

  has_many :labs

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, authentication_keys: [:net_id]

  scope :honest_brokers, -> {
    where(honest_broker: true)
  }

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
      user = User.create(net_id: auth.uid, first_name: auth.info.first_name, last_name: auth.info.last_name, email: email, password: Devise.friendly_token[0,20], approved: true)
    end
    user
  end

  def full_name
    "#{self.first_name} #{self.last_name}".strip
  end

  def display_name
    "#{first_name.try(:humanize)} #{last_name.try(:humanize)} (#{email})".strip
  end

  def honest_broker?
    self.honest_broker_id.present?
  end
end
