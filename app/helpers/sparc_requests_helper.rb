module SparcRequestsHelper
  def request_time_estimate(sr)
    if sr.time_estimate == '>2 years'
      fa_icon 'exclamation-circle', text: sr.time_estimate, class: 'text-warning'
    else
      sr.time_estimate
    end
  end
end
