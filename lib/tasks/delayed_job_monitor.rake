require 'open3'

task delayed_job_monitor: :environment do
  stdout, stderr, status = Open3.capture3("RAILS_ENV=#{Rails.env} bundle exec bin/delayed_job status")

  if stderr =~ /delayed_job: no instances running/
    system("RAILS_ENV=#{Rails.env} bundle exec bin/delayed_job start")
  end
end
