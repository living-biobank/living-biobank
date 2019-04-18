module SPARC
  class ProjectRole < SPARC::Base
    belongs_to :protocol, optional: true
    belongs_to :identity

    validates_presence_of :role, :project_rights
  end
end
