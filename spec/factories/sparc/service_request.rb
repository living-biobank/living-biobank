FactoryBot.define do
  factory :sparc_service_request, class: "SPARC::ServiceRequest" do
    status { 'draft' }
  end
end
