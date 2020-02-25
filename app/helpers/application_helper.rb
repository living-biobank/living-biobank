module ApplicationHelper
  def errors_controller?
    controller_name == 'errors'
  end

  def bootstrap_alert(type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }.stringify_keys[type.to_s]
  end

  def format_date(date)
    date.strftime("%m/%d/%Y") if date
  end
end

