class Patient < ApplicationRecord
  has_many :labs
  has_many :populations
  has_many :line_items, through: :populations
  has_many :sparc_requests, through: :line_items
  has_many :protocols, through: :sparc_requests, class_name: "SPARC::Protocol"
end
