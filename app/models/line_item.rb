class LineItem < ApplicationRecord
  include SparcShard
  belongs_to :sub_service_request
  belongs_to :service

  def self.submitted_line_items(service_id)
    joins(:sub_service_request)
      .where(sub_service_requests: { status: 'submitted' } )
      .where(service_id: service_id)
  end

  def questionnaire
    Questionnaire.where(questionable: service, active: true).first
  end

  def submission
    Submission.where(questionnaire_id: questionnaire.id, protocol_id: sub_service_request.protocol_id).first
  end

  def i2b2_query
    submission.questionnaire_responses.where(item_id: ENV.fetch('ITEM_ID')).first.content
  end
end
