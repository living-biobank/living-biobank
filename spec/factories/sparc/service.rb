FactoryBot.define do
  factory :sparc_service, class: "SPARC::Service" do
    before :create do |service, evaluator|
      service.organization = evaluator.organization ? evaluator.organization : create(:sparc_program)
    end
  end
end