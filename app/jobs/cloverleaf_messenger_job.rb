require 'net/http'

class CloverleafMessengerJob < Struct.new(:lab)
  def before(job)
    raise "CLOVERLEAF_URL must be defined in your .env" unless @url = ENV.fetch('CLOVERLEAF_URL')
    raise "CLOVERLEAF_URL is invalid"                   unless @uri = URI(@url)
  end

  def perform
    http          = Net::HTTP.new(@uri.host, @uri.port)
    request       = Net::HTTP::Post.new(@uri.request_uri)
    request.body  = message
    response      = http.request(request)

    case response
    when Net::HTTPSuccess, Net::HTTPRedirection
    else
      raise "The request was not received by the Cloverleaf server"
    end
  end

  def error(job, exception)
    CloverleafMailer.with(lab: lab, job: job, exception: exception).job_error.deliver
  end

  def failure(job)
    CloverleafMailer.with(lab: lab, job: job).job_failure.deliver
  end

  def destroy_failed_jobs?
    false
  end

  private

  def message
    message ||= [
      message_header,
      patient_identification,
      common_order,
      observation_request
    ].join("\n")
  end

  def message_header
    ["MSH", "^~\\&", "", "EPIC", "", "CERNER", Date.today.to_s, "kgk200", "ORM^001", "8000", processing_id, "2.2", "", "", "", "", "", "", "", "", "", "", ""].join("|")
  end

  def patient_identification
    ["PID", 1, "", "#{lab.patient.mrn}^^^MRN^MRN", "", "#{lab.patient.lastname}^#{lab.patient.firstname}", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""].join("|")
  end

  def common_order
    ["ORC", "NW", "#{lab.order_id}^EPC", "", "#{lab.visit_id}", "", "", "", "", Date.today.to_s, "", "", "18508^Lenert^Leslie^^^^^^EPIC^^^^1053492413", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""].join("|")
  end

  def observation_request
    ["OBR", 1, "#{lab.order_id}^EPC", lab.accession_number, "10^biobank^bb^^biobank", "", DateTime.now.to_s, "", "", "", "", "Lab Collect", "", "", "", "", "18508^Lenert^Leslie^^^^^^EPIC^^^^1053492413", "", "", "", "", "", "", "", "Lab", "", "", "1^^^#{Date.today}^#{Date.today}^R^^Future^^^^1", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""].join("|")
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
