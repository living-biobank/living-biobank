def bootstrap_select(selector, option=nil)
  find("select#{selector} + .dropdown-toggle").click
  if option
    find('.dropdown-menu.show:not(.inner)').first('.dropdown-item span.text', text: option).click
  else
    find('.dropdown-menu.show:not(.inner)').first('.dropdown-item:not(.selected) span.text').click
  end
end

def bootstrap_typeahead(selector, text)
  field = find("input#{selector}.typeahead")
  field.send_keys(text)
  wait_for_ajax
  expect(page).to have_selector('.tt-suggestion', visible: false)
  field.send_keys :down
  find('.tt-menu.tt-open').first('.tt-suggestion').click
  wait_for_ajax
end
