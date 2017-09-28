User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')
10.times do
  patient = Patient.create(mrn: Faker::Lorem.characters(10),
                           preference_date: Faker::Date.between_except(
                             1.year.ago, 1.year.from_now, Date.today),
                           contact_pref: Faker::Lorem.characters(10),
                           bio_bank_pref: Faker::Lorem.characters(10)
                          )
  lab = Lab.create(patient_id: patient.id,
                   specimen_date: Faker::Date.between_except(
                     1.year.ago, 1.year.from_now, Date.today),
                   order_id: Faker::Number.between(1, 10),
                   specimen_source: Faker::Lorem.characters(10)
                  )

  sr = SpecimenRequest.create(
    i2b2_query_name: Faker::Lorem.characters(10),
    sparc_protocol_id: Protocol.where(type: 'Study').sample.id,
    sparc_line_item_id: LineItem.where.not(id: nil).sample.id,
    query_cnt: Faker::Number.between(1, 10)
  )

  Specimen.create(
    lab_id: lab.id,
    specimen_request_id: sr.id
  )

  Population.create(
    specimen_request_id: sr.id,
    patient_id: patient.id,
    identified_date: Faker::Date.between_except(
      1.year.ago, 1.year.from_now, Date.today
    )
  )
end
