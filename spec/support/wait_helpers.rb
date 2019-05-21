def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until jquery_defined?
    loop until finished_all_ajax_requests? && finished_all_animations?
  end
end

def jquery_defined?
  page.evaluate_script(%Q{typeof jQuery !== 'undefined'}) && page.evaluate_script(%Q{typeof $ !== 'undefined'})
end

def finished_all_ajax_requests?
  page.evaluate_script('jQuery.active') == 0
end

def finished_all_animations?
  page.evaluate_script('$(":animated").length') == 0
end
