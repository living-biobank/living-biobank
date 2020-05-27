class UpdateAllSparcRequestsToIncludeHumanSubjectInfo < ActiveRecord::Migration[5.2]
  def change
    SparcRequest.where(protocol_id: SPARC::Protocol.all.ids).each do |sr|
      if sr.protocol.research_types_info.present?
        sr.protocol.research_types_info.update(human_subjects: true)
      else
        sr.protocol.create_research_types_info(human_subjects: true)
      end
    end
  end
end
