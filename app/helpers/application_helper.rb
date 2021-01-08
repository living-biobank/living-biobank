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

  def table_search(id)
    content_tag(:div, class: 'flex-fill') do
      content_tag(:div, class: 'input-group') do
        label_tag(id, icon('fas', 'search text-muted'), class: 'input-group-icon') +
        text_field_tag(id, params[:term], class: 'form-control form-control-lg table-search', placeholder: t('actions.search'))
      end
    end
  end
end

