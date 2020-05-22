class UpdateAllSparcRequestsToIncludeHumanSubjectInfo < ActiveRecord::Migration[5.2]
  def change
    SparcRequest.all.each do |sr|
      sr.protocol.create_research_types_info(human_subjects: true)
    end
  end
end
