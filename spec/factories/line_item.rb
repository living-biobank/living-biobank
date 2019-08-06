FactoryBot.define do
  factory :line_item do
    query_name                    { I2b2::QueryName.first }
    minimum_sample_size           { Faker::Measurement.metric_volume }
    number_of_specimens_requested { Faker::Number.number(4) }

    trait :with_source do
      source_id { Source.all.ids.sample }
    end

    trait :without_validations do
      to_create{ |instance| instance.save(validate: false) }
    end

    before :create do |line_item, evaluator|
      line_item.service = evaluator.service ? evaluator.service : create(:sparc_service)
    end
  end
end
