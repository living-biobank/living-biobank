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

    after :build do |sparc_request, evaluator|
      evaluator.line_item_count.times{ sparc_request.line_items << create(:line_item, :without_validations, sparc_request: sparc_request) } if evaluator.line_item_count
    end

    before :create do |sparc_request, evaluator|
      sparc_request.protocol  = evaluator.protocol  ? evaluator.protocol  : create(:sparc_protocol)
      sparc_request.user      = evaluator.user      ? evaluator.user      : create(:user)
      create(:sparc_identity,
        first_name: sparc_request.user.first_name,
        last_name:  sparc_request.user.last_name,
        email:      sparc_request.user.email,
        ldap_uid:   sparc_request.user.net_id
      )
    end
  end
end
