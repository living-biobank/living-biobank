class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.per_page = 10

  def self.table_name_prefix
    Rails.configuration.database_configuration[Rails.env]['database'] + '.'
  end
end
