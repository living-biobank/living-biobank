namespace :data do
  desc "Create a new Group with Sources, Services, and Variables"
  task add_group: :environment do
    ActiveRecord::Base.transaction do
      group_name  = nil
      group_valid = false
      while !group_valid
        print "Please enter a name for this group: "
        group_name = STDIN.gets.chomp

        if Group.where(name: group_name).any?
          puts "There's already a group named #{group_name}.\n\n"
        else
          group_valid = true
        end
      end

      process_specimen_retrieval  = nil
      process_specimens_valid     = false
      while !process_specimens_valid
        print "Should #{group_name} track whether specimens have been retrieved or discarded? [y/n]: "
        process_specimen_retrieval_input = STDIN.gets.chomp.downcase.strip

        if ['y', 'yes'].include?(process_specimen_retrieval_input)
          process_specimens_valid = true
          process_specimens_retrieval = true
        elsif ['n', 'no'].include?(process_specimen_retrieval_input)
          process_specimens_valid = true
          process_specimens_retrieval = false
        else
          puts "The value you entered was invalid. Accepted values are [y/n].\n\n"
        end
      end

      process_sample_size  = nil
      process_sample_valid     = false
      while !process_sample_valid
        print "Should #{group_name} track whether sample is of a given size? [y/n]: "
        process_sample_size_input = STDIN.gets.chomp.downcase.strip

        if ['y', 'yes'].include?(process_sample_size_input)
          process_sample_valid = true
          process_sample_size = true
        elsif ['n', 'no'].include?(process_sample_size_input)
          process_sample_valid = true
          process_sample_size = false
        else
          puts "The value you entered was invalid. Accepted values are [y/n].\n\n"
        end
      end

      group = Group.create(name: group_name, process_specimen_retrieval: process_specimen_retrieval, process_sample_size: process_sample_size)

      puts "\nNow you will be asked to enter Specimen Sources that will be handled by #{group_name}."
      sources_done = false
      while !sources_done
        print "Do you want to add another Source? [y/n]: "
        input = STDIN.gets.chomp.downcase.strip
        if ['y', 'yes'].include?(input)
          source_key        = nil
          source_key_valid  = false
          while !source_key_valid
            print "\nPlease enter a key for this Source. This should be the source's name in Epic: "
            source_key = STDIN.gets.chomp

            if group.sources.where(key: source_key).none?
              source_key_valid = true
            else
              puts "\n#{group_name} already has a Source with the key \"#{source_key}\".\n"
            end
          end

          print "Please enter a value for this Source. This will be the text displayed to users: "
          source_value = STDIN.gets.chomp

          group.sources.create(key: source_key, value: source_value)
          puts "\nAdded the Source \"#{source_value}\" (#{source_key}) to #{group_name}.\n\n"
        elsif ['n', 'no'].include?(input)
          sources_done = true
        else
          puts "The value you entered was invalid. Accepted values are [y/n].\n\n"
        end
      end

      puts "\nNow you will be asked to enter Services that will be added to requests for #{group_name} specimens. There Services will be added when the request is finalized."
      services_done = false
      while !services_done
        print "Do you want to add another Service? [y/n]: "
        input = STDIN.gets.chomp.downcase.strip
        if ['y', 'yes'].include?(input)
          service           = nil
          service_id        = nil
          service_id_valid  = false
          while !service_id_valid
            print "\nPlease enter the Service's ID in SPARCRequest: "
            service_id = STDIN.gets.chomp

            if (service = SPARC::Service.where(id: service_id).first)
              print "Found Service \"#{service_id} - #{service.name}\" from the #{service.process_ssrs_organization.type} \"#{service.process_ssrs_organization.name}\". Is this correct? [y/n]: "
              input = STDIN.gets.chomp.downcase.strip

              if ['y', 'yes'].include?(input)
                if group.services.where(sparc_id: service_id).any?
                  puts "\n#{group_name} already has the Service \"#{service_id} - #{service.name}\".\n"
                else
                  service_id_valid = true
                end
              end
            else
              puts "Could not find Service #{service_id} in SPARCRequest.\n"
            end
          end

          group.services.create(sparc_id: service_id)
          puts "\nAdded Service \"#{service_id} - #{service.name}\" to #{group_name}.\n\n"
        elsif ['n', 'no'].include?(input)
          services_done = true
        else
          puts "The value you entered was invalid. Accepted values are [y/n].\n\n"
        end
      end

      puts "\nNow you will be asked to enter additional Variables that will be asked for requests for #{group_name} specimens."
      variables_done = false
      while !variables_done
        print "Do you want to add another Variable? [y/n]: "
        input = STDIN.gets.chomp.downcase.strip
        if ['y', 'yes'].include?(input)
          variable_name = nil
          variable_name_valid = false
          while !variable_name_valid
            print "\nPlease enter the Variable's name: "
            variable_name = STDIN.gets.chomp

            if group.variables.where(name: variable_name).any?
              puts "\n#{group_name} already has a Variable called \"#{variable_name}\".\n"
            else
              variable_name_valid = true
            end
          end

          service           = nil
          service_id        = nil
          service_id_valid  = false
          while !service_id_valid
            print "Please enter the Variable's Service ID in SPARCRequest: "
            service_id = STDIN.gets.chomp

            if (service = SPARC::Service.where(id: service_id).first)
              print "Found Service \"#{service_id} - #{service.name}\" from the #{service.process_ssrs_organization.type} \"#{service.process_ssrs_organization.name}\". Is this correct? [y/n]: "
              input = STDIN.gets.chomp.downcase.strip

              if ['y', 'yes'].include?(input)
                service_id_valid = true
              end
            else
              puts "Could not find Service #{service_id} in SPARCRequest.\n"
            end
          end

          group.variables.create(name: variable_name, service_id: service_id)
          puts "\nAdded Variable \"#{variable_name} / #{service_id} - #{service.name} (#{service.process_ssrs_organization.name})\" to #{group_name}.\n\n"
        elsif ['n', 'no'].include?(input)
          variables_done = true
        else
          puts "The value you entered was invalid. Accepted values are [y/n].\n\n"
        end
      end

      puts "Finished creating #{group_name}."
      puts "Sources:"
      group.sources.each{ |s| puts "- #{s.value} (#{s.key})" }
      puts "\nServices:"
      group.services.each{ |s| puts "- #{s.sparc_service.id} - #{s.sparc_service.name} (#{s.sparc_service.process_ssrs_organization.name})" }
      puts "\nVariables:"
      group.variables.each{ |v| puts "- #{v.name} / #{v.service.id} - #{v.service.name} (#{v.service.process_ssrs_organization.name})" }
    end
  end
end
