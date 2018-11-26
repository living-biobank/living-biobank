require 'net/http'

class CloverleafMessenger
  def initialize(args)
    @lab = args[:lab]
  end

  def send_message
    raise "CLOVERLEAF_URL must be defined in your .env" unless url = ENV.fetch('CLOVERLEAF_URL')
    uri = URI(url)
    
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(data: self.message)

    begin
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      case response
      when Net::HTTPSuccess, Net::HTTPRedirection
        puts 'Cloverleaf received message successfully'
      else
        puts response.value
      end
    rescue Exception => e
      puts e
    end
  end

  def message
    message ||= [
      message_header,
      patient_identification,
      common_order,
      observation_request
    ].join("\n")
  end

  private

  def message_header
    ["MSH", "^~\\&", "", "EPIC", "", "CERNER", Date.today.to_s, "kgk200", "ORM^001", "8000", processing_id, "2.2", "", "", "", "", "", "", "", "", "", "", ""].join("|")
  end

  def patient_identification
    ["PID", 1, "", "#{@lab.patient.mrn}^^^MRN^MRN", "", "#{@lab.patient.lastname}^#{@lab.patient.firstname}", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""].join("|")
  end

  def common_order
    ["ORC", "NW", "#{@lab.order_id}^EPC", "", "#{@lab.visit_id}", "", "", "", "", Date.today.to_s, "", "", "18508^Lenert^Leslie^^^^^^EPIC^^^^1053492413", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""].join("|")
  end

  def observation_request
    ["OBR", 1, "#{@lab.order_id}^EPC", @lab.accession_number, "10^biobank^bb^^biobank", "", DateTime.now.to_s, "", "", "", "", "Lab Collect", "", "", "", "", "18508^Lenert^Leslie^^^^^^EPIC^^^^1053492413", "", "", "", "", "", "", "", "Lab", "", "", "1^^^#{Date.today}^#{Date.today}^R^^Future^^^^1", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""].join("|")
  end

  def processing_id
    case Rails.env
    when 'production'
      'P'
    when 'testing'
      'D'
    else
      'T'
    end
  end
end
