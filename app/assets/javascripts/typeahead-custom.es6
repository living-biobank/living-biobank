(function($) {
  $(document).ready( function() {
    $(document).on('typeahead:asyncrequest', '.tt-input', event => {
      NProgress.start();
    }).on('typeahead:asyncreceive', '.tt-input', event => {
      NProgress.done();
    })
  })
})(jQuery);
