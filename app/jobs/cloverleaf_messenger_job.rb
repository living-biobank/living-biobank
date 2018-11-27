require 'net/http'

class CloverleafMessengerJob < Struct.new(:lab)
  def before(job)
    raise "CLOVERLEAF_URL must be defined in your .env" unless @url = ENV.fetch('CLOVERLEAF_URL')
    raise "CLOVERLEAF_URL is invalid"                   unless @uri = URI(@url)
  end

  def perform
    begin
      socket = TCPSocket.open(@uri.host, @uri.port)
      socket.write(message.to_llp)
      puts socket.recv(1024)
      socket.close
    rescue Exception => e
      raise e
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

  def message
    @msg ||= SimpleHL7::Message.new
    
    generate_message_header
    generate_patient_identification
    generate_common_order
    generate_observation_request

    @msg
  end

  private

  def generate_message_header
    @msg.msh[4]     = 'EPIC'
    @msg.msh[6]     = 'CERNER'
    @msg.msh[7]     = format_date(Date.today)
    @msg.msh[8]     = 'kgk200'
    @msg.msh[9][1]  = 'ORM'
    @msg.msh[9][2]  = '001'
    @msg.msh[10]    = '8000'
    @msg.msh[11]    = processing_id
    @msg.msh[12]    = '2.2'
  end

  def generate_patient_identification
    @msg.pid[1]     = '1'
    @msg.pid[3][1]  = lab.patient.mrn
    @msg.pid[3][4]  = 'MRN'
    @msg.pid[3][5]  = 'MRN'
    @msg.pid[5][1]  = lab.patient.lastname
    @msg.pid[5][2]  = lab.patient.firstname
  end

  def generate_common_order
    @msg.orc[1]       = 'NW'
    @msg.orc[2][1]    = lab.order_id
    @msg.orc[2][2]    = 'EPC'
    @msg.orc[4]       = lab.visit_id
    @msg.orc[9]       = format_date(Date.today)
    @msg.orc[12][1]   = '18508'
    @msg.orc[12][2]   = 'Lenert'
    @msg.orc[12][3]   = 'Leslie'
    @msg.orc[12][9]   = 'EPIC'
    @msg.orc[12][13]  = '1053492413'
  end

  def generate_observation_request
    @msg.obr[1]       = '1'
    @msg.obr[2][1]    = lab.order_id
    @msg.obr[2][2]    = 'EPC'
    @msg.obr[3]       = lab.accession_number
    @msg.obr[4][1]    = '10'
    @msg.obr[4][2]    = 'biobank'
    @msg.obr[4][3]    = 'bb'
    @msg.obr[4][5]    = 'biobank'
    @msg.obr[6]       = format_datetime(DateTime.now)
    @msg.obr[11]      = 'Lab Collect'
    @msg.obr[16][1]   = '18508'
    @msg.obr[16][2]   = 'Lenert'
    @msg.obr[16][3]   = 'Leslie'
    @msg.obr[16][9]   = 'EPIC'
    @msg.obr[16][13]  = '1053492413'
    @msg.obr[24]      = 'Lab'
    @msg.obr[27][1]   = '1'
    @msg.obr[27][4]   = format_date(Date.today)
    @msg.obr[27][5]   = format_date(Date.today)
    @msg.obr[27][6]   = 'R'
    @msg.obr[27][8]   = 'Future'
    @msg.obr[27][12]  = '1'
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

  def format_date(date)
    date.strftime('%Y%m%d')
  end

  def format_datetime(datetime)
    datetime.strftime('%Y%m%d%H%M%S%z')
  end
end
