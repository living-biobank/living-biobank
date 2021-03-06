# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every :weekday, at: '7am' do
  rake 'email_tasks:daily_specimen_check'
end

every :weekday, at: '6am' do
  rake 'automatic_specimen_discard'
end

every 1.hour do
  rake 'data:clear_refreshed_sparc_data'
end

every 1.hour do
  rake 'delayed_job_monitor'
end
