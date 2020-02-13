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
    process_specimen_retrieval:   false,
    process_sample_size:          true,
    display_patient_information:  false
  )

  microbiome_group = Group.where(
    name: "Microbiome"
  ).first_or_create(
    process_specimen_retrieval:   true,
    process_sample_size:          false,
    display_patient_information:  true
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

  Service.where(
    group:          microbiome_group,
    sparc_service:  SPARC::Service.find(26545)
  ).first_or_create

  Service.where(
    group:          microbiome_group,
    sparc_service:  SPARC::Service.find(10216)
  ).first_or_create

  Service.where(
    group:          microbiome_group,
    sparc_service:  SPARC::Service.find(10)
  ).first_or_create

  ########################
  ### Create Variables ###
  ########################

  Variable.where(
    name:       "QI",
    group:      microbiome_group,
    service:    SPARC::Service.find(37778),
    condition:  "irb.blank?"
  ).first_or_create

  Variable.where(
    name:       "IRB Approved Research",
    group:      microbiome_group,
    service:    SPARC::Service.find(8253),
    condition:  "irb.present?"
  ).first_or_create

  #######################
  ### Create Patients ###
  #######################

  john = Patient.where(
    firstname:  "John",
    lastname:   "Doe",
    identifier: "JD0001",
    mrn:        "111111"
  ).first_or_create

  jane = Patient.where(
    firstname:  "Jane",
    lastname:   "Doe",
    identifier: "JD0002",
    mrn:        "111111"
  ).first_or_create

  ###################
  ### Create Labs ###
  ###################

  lab1 = Lab.where(
    patient:          john,
    source:           blood,
    status:           I18n.t(:labs)[:statuses][:available],
  ).first_or_create(
    accession_number: Faker::Number.number(digits: 10).to_s
  )

  lab2 = Lab.where(
    patient:          john,
    source:           nasal,
    status:           I18n.t(:labs)[:statuses][:available],
  ).first_or_create(
    accession_number: Faker::Number.number(digits: 10).to_s
  )

  lab3 = Lab.where(
    patient:          john,
    source:           perianal,
    status:           I18n.t(:labs)[:statuses][:available],
  ).first_or_create(
    accession_number: Faker::Number.number(digits: 10).to_s
  )

  lab4 = Lab.where(
    patient:          jane,
    source:           blood,
    status:           I18n.t(:labs)[:statuses][:available],
  ).first_or_create(
    accession_number: Faker::Number.number(digits: 10).to_s
  )

  lab5 = Lab.where(
    patient:          jane,
    source:           nasal,
    status:           I18n.t(:labs)[:statuses][:available],
  ).first_or_create(
    accession_number: Faker::Number.number(digits: 10).to_s
  )

  lab6 = Lab.where(
    patient:          jane,
    source:           perianal,
    status:           I18n.t(:labs)[:statuses][:available],
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
    title:                  Faker::Lorem.sentence,
    short_title:            Faker::Lorem.sentence(word_count: 3),
    funding_status:         'funded',
    funding_source:         SPARC::PermissibleValue.get_hash('funding_source').keys.sample,
    start_date:             Date.today,
    end_date:               Date.today + 1.month,
    primary_pi_role_attributes:  {
      identity: pi
    }
  )

  protocol_2 = SPARC::Protocol.create(
    title:                  Faker::Lorem.sentence,
    short_title:            Faker::Lorem.sentence(word_count: 3),
    funding_status:         'funded',
    funding_source:         SPARC::PermissibleValue.get_hash('funding_source').keys.sample,
    start_date:             Date.today,
    end_date:               Date.today + 1.month,
    primary_pi_role_attributes:  {
      identity: pi
    }
  )

  protocol_3 = SPARC::Protocol.create(
    title:                  Faker::Lorem.sentence,
    short_title:            Faker::Lorem.sentence(word_count: 3),
    funding_status:         'funded',
    funding_source:         SPARC::PermissibleValue.get_hash('funding_source').keys.sample,
    start_date:             Date.today,
    end_date:               Date.today + 1.month,
    primary_pi_role_attributes:  {
      identity: pi
    }
  )

  ######################
  ### Creat Requests ###
  ######################

  request_1 = SparcRequest.create(
    protocol: protocol_1,
    user:     kayla,
    status:   I18n.t(:requests)[:statuses][:pending],
    specimen_requests_attributes: {
      0 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         blood,
        query_name:                     kayla.i2b2_queries.first.name,
        minimum_sample_size:            "#{Faker::Number.number(digits: 1)}mL",
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      },
      1 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         nasal,
        query_name:                     kayla.i2b2_queries.first.name,
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      },
      2 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         perianal,
        query_name:                     kayla.i2b2_queries.first.name,
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      }
    }
  )

  request_1.update_attribute(:status, I18n.t(:requests)[:statuses][:in_process])

  request_2 = SparcRequest.create(
    protocol: protocol_2,
    user:     kayla,
    status:   I18n.t(:requests)[:statuses][:pending],
    specimen_requests_attributes: {
      0 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         blood,
        query_name:                     kayla.i2b2_queries.first.name,
        minimum_sample_size:            "#{Faker::Number.number(digits: 1)}mL",
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      },
      1 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         nasal,
        query_name:                     kayla.i2b2_queries.first.name,
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      },
      2 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         perianal,
        query_name:                     kayla.i2b2_queries.first.name,
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      }
    }
  )

  request_2.update_attribute(:status, I18n.t(:requests)[:statuses][:in_process])

  request_3 = SparcRequest.create(
    protocol: protocol_1,
    user:     ito,
    status:   I18n.t(:requests)[:statuses][:pending],
    specimen_requests_attributes: {
      0 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         blood,
        query_name:                     ito.i2b2_queries.first.name,
        minimum_sample_size:            "#{Faker::Number.number(digits: 1)}mL",
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      },
      1 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         nasal,
        query_name:                     ito.i2b2_queries.first.name,
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      },
      2 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         perianal,
        query_name:                     ito.i2b2_queries.first.name,
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      }
    }
  )

  request_3.update_attribute(:status, I18n.t(:requests)[:statuses][:in_process])

  request_4 = SparcRequest.create(
    protocol: protocol_2,
    user:     ito,
    status:   I18n.t(:requests)[:statuses][:pending],
    specimen_requests_attributes: {
      0 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         blood,
        query_name:                     ito.i2b2_queries.first.name,
        minimum_sample_size:            "#{Faker::Number.number(digits: 1)}mL",
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      },
      1 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         nasal,
        query_name:                     ito.i2b2_queries.first.name,
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      },
      2 => {
        service:                        SPARC::Service.find(ENV.fetch('SERVICE_ID')),
        source:                         perianal,
        query_name:                     ito.i2b2_queries.first.name,
        number_of_specimens_requested:  Faker::Number.number(digits: 1)
      }
    }
  )

  request_4.update_attribute(:status, I18n.t(:requests)[:statuses][:in_process])

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
