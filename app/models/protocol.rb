class Protocol < SparcRequestBase
  self.inheritance_column = nil

  has_one :sparc_request

  has_many :specimen_records

  def identifier
    "#{self.id} - #{self.short_title}"
  end
end
