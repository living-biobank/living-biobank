class Protocol < SparcRequestBase
  self.inheritance_column = nil

  has_one :sparc_request
end
