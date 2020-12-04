(function($) {
  $.extend($.fn.modal.Constructor.Default, { backdrop: 'static' });

  $(document).ready( function() {
    $(document).on('hide.bs.popover', '[data-toggle="popover"][data-trigger="hover"]', event => {
      var $this = $(event.target);

      if ($(`.popover:hover`).length) {
        event.preventDefault();

        $('.popover').on('mouseleave', event => {
          $this.popover('hide')
        })
      }
    })

    $(document).on('click', '.nav-pills .nav-link:not(.active)', event => {
      $this = $(event.target)
      $this.parents('.nav-pills').find('.nav-link.active').removeClass('active');
      $this.addClass('active');
    })

    $(document).on('click', 'table.table-interactive tbody tr', event => {
      el      = event.target
      $anchor = null

      if (el.tagName == 'tr' && $(el).find('a').length) {
        $anchor = $(el).find('a').first()
      } else if (el.tagName != 'a' && $(el).parents('tr').find('a').length) {
        $anchor = $(el).parents('tr').find('a').first()
      }

      if ($anchor) {
        if ($anchor.data('remote')) {
          $.ajax({
            method:   'GET',
            dataType: 'script',
            url:      $anchor.attr('href')
          })
        } else {
          window.location.href = $anchor.attr('href')
        }
      }
    })
  })
})(jQuery);
