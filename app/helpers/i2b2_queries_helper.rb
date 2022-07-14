module I2b2QueriesHelper
  def musc_tab_status(active_tab, musc_query_id)
    if active_tab == 'musc-tab'
      'active'
    elsif active_tab == '' && musc_query_id.present?
      'active'
    else
      ''
    end
  end

  def shrine_tab_status(active_tab, shrine_query_id)
    if active_tab == 'shrine-tab'
      'active'
    elsif active_tab == '' && shrine_query_id.present?
      'active'
    else
      ''
    end
  end

  def musc_tab_pane_status(active_tab, musc_query_id, shrine_query_id, musc_queries)
    if active_tab == 'musc-tab'
      'show active'
    elsif active_tab == '' && (musc_query_id.present? || musc_query_id.blank? && shrine_query_id.blank? && musc_queries.present?)
      'show active'
    else
      ''
    end
  end

  def shrine_tab_pane_status(active_tab, musc_query_id, shrine_query_id, musc_queries, shrine_queries)
    if active_tab == 'shrine-tab'
      'show active'
    elsif active_tab == '' && (shrine_query_id.present? || musc_query_id.blank? && shrine_query_id.blank? && musc_queries.blank? && shrine_queries.present?)
      'show active'
    else
      ''
    end
  end
end