module SPARC
  class ProjectRole < SPARC::Base
    belongs_to :protocol, optional: true
    belongs_to :identity

    validates_presence_of :role, :project_rights, unless: Proc.new{|pr| User.current.external? }
    accepts_nested_attributes_for :identity
  end
end
