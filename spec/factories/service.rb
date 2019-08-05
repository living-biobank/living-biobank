FactoryBot.define do
  factory :service do
    before :create do |service, evaluator|
      service.sparc_service = evaluator.sparc_service ? evaluator.sparc_service : create(:sparc_service)
    end
  end
end
