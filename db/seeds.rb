ActiveRecord::Base.transaction do
  ####################
  ### Create Users ###
  ####################

  kayla = User.where(
    first_name: "Kayla",
    last_name:  "Glick",
    email:      "glickk@musc.edu",
    net_id:     "kyg200@musc.edu"
  ).first_or_create(
    password: "password",
    admin:    true
  )

  ito = User.where(
    first_name: "Ito",
    last_name:  "Eta",
    email:      "iee@musc.edu",
    net_id:     "iee@musc.edu",
  ).first_or_create(
    password: "password",
    admin:    true
  )

  #####################
  ### Create Groups ###
  #####################

  blood_group = Group.where(
    name: "Blood"
  ).first_or_create(
    process_specimen_retrieval:         true,
    process_sample_size:                true,
    display_patient_information:        true,
    notify_when_all_specimens_released: false,
    release_email:                      "Blood specimen released",
    discard_email:                      "Blood specimen discarded"
  )

  microbiome_group = Group.where(
    name: "Microbiome"
  ).first_or_create(
    process_specimen_retrieval:         false,
    process_sample_size:                false,
    display_patient_information:        true,
    notify_when_all_specimens_released: true,
    release_email:                      "Microbiome specimen released",
    discard_email:                      "Microbiome specimen discarded",
    finalize_email_subject:             "Request Finalized",
    finalize_email_to:                  "nobody@musc.edu"
  )

  ######################
  ### Create Sources ###
  ######################

  blood = Source.where(
    group:  blood_group,
    key:    "WHOLE BLOOD-VENOUS",
    value:  "Blood"
  ).first_or_create

  nasal = Source.where(
    group:  microbiome_group,
    key:    "MRSA SURVEILLANCE CULTURE",
    value:  "Nasal Swab"
  ).first_or_create

  perianal = Source.where(
    group:  microbiome_group,
    key:    "VRE SURVEILLANCE CULTURE",
    value:  "Perianal Swab"
  ).first_or_create

  #######################
  ### Create Services ###
  #######################

  ### Microbiome Services

  Service.where(
    group:            microbiome_group,
    sparc_service:    SPARC::Service.find(37778)
  ).first_or_create(
    position:         1,
    status:           'pending',
    condition:        'irb_not_approved'
  )

  Service.where(
    group:            microbiome_group,
    sparc_service:    SPARC::Service.find(8253)
  ).first_or_create(
    position:         2,
    status:           'pending',
    condition:        'irb_approved'
  )

  Service.where(
    group:            microbiome_group,
    sparc_service:    SPARC::Service.find(492)
  ).first_or_create(
    position:         3,
    status:           'in_process'
  )

  Service.where(
    group:            microbiome_group,
    sparc_service:    SPARC::Service.find(26545)
  ).first_or_create(
    position:         4,
    status:           'in_process'
  )

  Service.where(
    group:            microbiome_group,
    sparc_service:    SPARC::Service.find(10216)
  ).first_or_create(
    position:         5,
    status:           'in_process'
  )

  Service.where(
    group:            microbiome_group,
    sparc_service:    SPARC::Service.find(10)
  ).first_or_create(
    position:         6,
    status:           'in_process'
  )

  ### Blood Services

  Service.where(
    group:            blood_group,
    sparc_service:    SPARC::Service.find(37778)
  ).first_or_create(
    position:         1,
    status:           'pending',
    condition:        'irb_not_approved'
  )

  Service.where(
    group:            blood_group,
    sparc_service:    SPARC::Service.find(8253)
  ).first_or_create(
    position:         2,
    status:           'pending',
    condition:        'irb_approved'
  )

  #######################
  ### Create Patients ###
  #######################

  john = Patient.where(
    firstname:  "John",
    lastname:   "Doe",
    identifier: "JD0001",
    mrn:        "111111",
    dob:        Date.today - 30.years
  ).first_or_create

  jane = Patient.where(
    firstname:  "Jane",
    lastname:   "Doe",
    identifier: "JD0002",
    mrn:        "111111",
    dob:        Date.today - 30.years
  ).first_or_create

  ###################
  ### Create Labs ###
  ###################

  lab1 = Lab.where(
    patient:          john,
    source:           blood,
    status:           'available',
  ).first_or_create(
    accession_number: Faker::Number.number(digits: 10).to_s
  )

  lab2 = Lab.where(
    patient:          john,
    source:           nasal,
    status:           'available',
  ).first_or_create(
    accession_number: Faker::Number.number(digits: 10).to_s
  )

  lab3 = Lab.where(
    patient:          john,
    source:           perianal,
    status:           'available',
  ).first_or_create(
    accession_number: Faker::Number.number(digits: 10).to_s
  )

  lab4 = Lab.where(
    patient:          jane,
    source:           blood,
    status:           'available',
  ).first_or_create(
    accession_number: Faker::Number.number(digits: 10).to_s
  )

  lab5 = Lab.where(
    patient:          jane,
    source:           nasal,
    status:           'available',
  ).first_or_create(
    accession_number: Faker::Number.number(digits: 10).to_s
  )

  lab6 = Lab.where(
    patient:          jane,
    source:           perianal,
    status:           'available',
  ).first_or_create(
    accession_number: Faker::Number.number(digits: 10).to_s
  )

  ########################
  ### Create Protocols ###
  ########################

  pi = SPARC::Identity.where(
    first_name: "Sarah",
    last_name:  "Parcinson",
    email:      "sparc@musc.edu",
    ldap_uid:   "sparc@musc.edu"
  ).first_or_create

  protocol_1 = SPARC::Protocol.create(
    type:           'Study',
    title:          Faker::Lorem.sentence,
    short_title:    Faker::Lorem.sentence(word_count: 3),
    funding_status: 'funded',
    funding_source: SPARC::PermissibleValue.get_hash('funding_source').keys.sample,
    start_date:     Date.today,
    end_date:       Date.today + 1.month,
    primary_pi_role_attributes:  {
      identity: pi
    }
  )

  protocol_2 = SPARC::Protocol.create(
    type:           'Study',
    title:          Faker::Lorem.sentence,
    short_title:    Faker::Lorem.sentence(word_count: 3),
    funding_status: 'funded',
    funding_source: SPARC::PermissibleValue.get_hash('funding_source').keys.sample,
    start_date:     Date.today,
    end_date:       Date.today + 1.month,
    primary_pi_role_attributes:  {
      identity: pi
    }
  )

  protocol_3 = SPARC::Protocol.create(
    type:           'Study',
    title:          Faker::Lorem.sentence,
    short_title:    Faker::Lorem.sentence(word_count: 3),
    funding_status: 'funded',
    funding_source: SPARC::PermissibleValue.get_hash('funding_source').keys.sample,
    start_date:     Date.today,
    end_date:       Date.today + 1.month,
    primary_pi_role_attributes:  {
      identity: pi
    }
  )

  ######################
  ### Creat Requests ###
  ######################

  request_1 = SparcRequest.create(
    protocol:     protocol_1,
    requester:    kayla,
    status:       'pending',
    submitted_at: DateTime.now,
    specimen_requests_attributes: {
      0 => {
        source:                         blood,
        query_id:                       kayla.i2b2_queries.first.id,
        minimum_sample_size:            "#{Faker::Number.within(range: 1..9)}mL",
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      },
      1 => {
        source:                         nasal,
        query_id:                       kayla.i2b2_queries.first.id,
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      },
      2 => {
        source:                         perianal,
        query_id:                       kayla.i2b2_queries.first.id,
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      }
    }
  )

  request_1.update_attribute(:status, 'in_process')

  request_2 = SparcRequest.create(
    protocol:     protocol_2,
    requester:    kayla,
    status:       'pending',
    submitted_at: DateTime.now,
    specimen_requests_attributes: {
      0 => {
        source:                         blood,
        query_id:                       kayla.i2b2_queries.first.id,
        minimum_sample_size:            "#{Faker::Number.within(range: 1..9)}mL",
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      },
      1 => {
        source:                         nasal,
        query_id:                       kayla.i2b2_queries.first.id,
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      },
      2 => {
        source:                         perianal,
        query_id:                       kayla.i2b2_queries.first.id,
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      }
    }
  )

  request_2.update_attribute(:status, 'in_process')

  request_3 = SparcRequest.create(
    protocol:     protocol_1,
    requester:    ito,
    status:       'pending',
    submitted_at: DateTime.now,
    specimen_requests_attributes: {
      0 => {
        source:                         blood,
        query_id:                       ito.i2b2_queries.first.id,
        minimum_sample_size:            "#{Faker::Number.within(range: 1..9)}mL",
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      },
      1 => {
        source:                         nasal,
        query_id:                       ito.i2b2_queries.first.id,
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      },
      2 => {
        source:                         perianal,
        query_id:                       ito.i2b2_queries.first.id,
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      }
    }
  )

  request_3.update_attribute(:status, 'in_process')

  request_4 = SparcRequest.create(
    protocol:     protocol_2,
    requester:    ito,
    status:       'pending',
    submitted_at: DateTime.now,
    specimen_requests_attributes: {
      0 => {
        source:                         blood,
        query_id:                       ito.i2b2_queries.first.id,
        minimum_sample_size:            "#{Faker::Number.within(range: 1..9)}mL",
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      },
      1 => {
        source:                         nasal,
        query_id:                       ito.i2b2_queries.first.id,
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      },
      2 => {
        source:                         perianal,
        query_id:                       ito.i2b2_queries.first.id,
        number_of_specimens_requested:  Faker::Number.within(range: 1..9)
      }
    }
  )

  request_4.update_attribute(:status, 'in_process')

  #########################
  ### Creat Populations ###
  #########################

  request_1.specimen_requests.each do |sr|
    Patient.all.each do |p|
      Population.create(patient: p, line_item: sr)
    end
  end

  request_2.specimen_requests.each do |sr|
    Patient.all.each do |p|
      Population.create(patient: p, line_item: sr)
    end
  end

  request_3.specimen_requests.each do |sr|
    Patient.all.each do |p|
      Population.create(patient: p, line_item: sr)
    end
  end

  request_4.specimen_requests.each do |sr|
    Patient.all.each do |p|
      Population.create(patient: p, line_item: sr)
    end
  end
end
