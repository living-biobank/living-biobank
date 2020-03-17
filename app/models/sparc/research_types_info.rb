module SPARC
  class ResearchTypesInfo < SPARC::Base
    self.table_name = 'research_types_info'

    belongs_to :protocol
  end
end
