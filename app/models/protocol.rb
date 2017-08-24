class Protocol < ApplicationRecord
 establish_connection "sparc_#{Rails.env}".to_sym
 self.inheritance_column = :_type_disabled
end
