FactoryBot.define do
  factory :sparc_sub_service_request, class: "SPARC::SubServiceRequest" do
    status { 'draft' }
  end
end
