FactoryBot.define do
  factory :sparc_request do
    status { I18n.t(:requests)[:statuses].values.sample }

    trait :draft do
      status { I18n.t(:requests)[:statuses][:draft] } 
    end

    trait :pending do
      status { I18n.t(:requests)[:statuses][:pending] }
    end

    trait :in_process do
      status { I18n.t(:requests)[:statuses][:in_process] }
    end

    trait :completed do
      status { I18n.t(:requests)[:statuses][:completed] }
    end

    trait :cancelled do
      status { I18n.t(:requests)[:statuses][:cancelled] }
    end

    trait :without_validations do
      to_create{ |instance| instance.save(validate: false) }
    end

    transient do
      line_item_count { 0 }
    end

    before :create do |sparc_request, evaluator|
      sparc_request.protocol  = evaluator.protocol  ? evaluator.protocol  : create(:sparc_protocol)
      sparc_request.user      = evaluator.user      ? evaluator.user      : create(:user)

      if evaluator.line_item_count > 0
        evaluator.line_item_count.times{ sparc_request.specimen_requests << create(:line_item, :with_source, :without_validations, sparc_request: sparc_request) }
      else
        sparc_request.specimen_requests << create(:line_item, :with_source, :without_validations, sparc_request: sparc_request)
      end
    end
  end
end
