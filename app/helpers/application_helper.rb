module ApplicationHelper
  def bootstrap_alert(type)
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }.stringify_keys[type.to_s]
  end
end

