class User < ApplicationRecord
  has_many :sparc_requests

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:net_id]

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

  def full_name
    "#{self.first_name} #{self.last_name}".strip
  end

  def display_name
    "#{first_name.try(:humanize)} #{last_name.try(:humanize)} (#{email})".strip
  end
end
