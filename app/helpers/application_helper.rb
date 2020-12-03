module ApplicationHelper
  def application_title
    title = t('site_information.title.base')

    if I18n.exists?("site_information.title.#{controller_name}.#{action_name}")
      object  = instance_variable_get("@#{controller_name.singularize}")
      tab     = params[:tab].present? ? t("#{controller_name}.tabs.#{params[:tab]}") : ""
      title   = t("site_information.title.#{controller_name}.#{action_name}", identifier: object.try(:identifier), tab: tab) + " | " + title
    end

    title
  end

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

