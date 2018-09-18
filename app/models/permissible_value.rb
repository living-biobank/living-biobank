class PermissibleValue < ApplicationRecord
  include SparcShard

  default_scope -> {
    order(:sort_order)
  }

  scope :available, -> {
    where(is_available: true)
  }
  
  def self.get_value(category, key)
    PermissibleValue.where(category: category, key: key).first.try(:value)
  end
  
  def self.get_hash(category, default=nil)
    unless default.nil?
      Hash[PermissibleValue.available.where(category: category, default: default).pluck(:key, :value)]
    else
      Hash[PermissibleValue.available.where(category: category).pluck(:key, :value)]
    end
  end

  def self.get_inverted_hash(category, default=nil)
    unless default.nil?
      Hash[PermissibleValue.available.where(category: category, default: default).pluck(:value, :key)]
    else
      Hash[PermissibleValue.available.where(category: category).pluck(:value, :key)]
    end
  end
end
