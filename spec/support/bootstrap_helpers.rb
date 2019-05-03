def bootstrap_select(selector, option=nil)
  find("select#{selector} + .dropdown-toggle").click
  if option
    find('.dropdown-menu.show:not(.inner)').first('.dropdown-item span.text', text: option).click
  else
    find('.dropdown-menu.show:not(.inner)').first('.dropdown-item:not(.selected) span.text').click
  end
end

def bootstrap_typeahead(selector, text)
  find("input#{selector}.typeahead").send_keys(text)
  find('.tt-menu.tt-open').first('.tt-suggestion').click
end
