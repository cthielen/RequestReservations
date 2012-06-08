jQuery(function($) {
  // For the "Static IP" / "Firewall Exemption" radio buttons
  // Credit: http://dan.doezema.com/2012/03/twitter-bootstrap-radio-button-form-inputs/
  $('div.btn-group[data-toggle-name=*]').each(function(){
    var group   = $(this);
    var form    = group.parents('form').eq(0);
    var name    = group.attr('data-toggle-name');
    var hidden  = $('input[name="' + name + '"]', form);
    $('button', group).each(function(){
      var button = $(this);
      button.live('click', function(){
          hidden.val($(this).val());
          hidden.change(); // $.val() doesn't fire a change event, so do it manually
      });
      if(button.val() == hidden.val()) {
        button.addClass('active');
      }
    });
  });
  
  // Show/hide the port field depending on the radio button state
  $('input[name="reservation[type]"]').on('change', function(e) {
    if(e.target.value == 1) {
      $('div#reservation-port-field').slideDown();
    } else {
      $('div#reservation-port-field').slideUp();
    }
  });
  
  // For auto-tabbing the IP address
  $('#ip_field_1').autotab({ target: $('#ip_field_2') });
  $('#ip_field_2').autotab({ target: $('#ip_field_3') });
  $('#ip_field_3').autotab({ target: $('#ip_field_4') });
});
