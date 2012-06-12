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
  $('input[name="reservation[reservation_type]"]').on('change', function(e) {
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
  
  // For keeping the IP address hidden field up-to-date
  $('#ip_field_1, #ip_field_2, #ip_field_3, #ip_field_4').change(function() { 
    var ip_address = $('#ip_field_1').val() + '.' + $('#ip_field_2').val() + '.' + $('#ip_field_3').val() + '.' + $('#ip_field_4').val(); 
    $('#reservation_ip_address').val(ip_address);
  });
  
  // If the hidden IP address field is set, it means the form data was pre-populated.
  // We need to break apart the hidden IP field and set the 4 inputs that represent the IP address
  if($("input#reservation_ip_address").length) {
    if($("input#reservation_ip_address").val() !== "") {
      // populate the IP address fields
      var fields = $("input#reservation_ip_address").val().split(".");
      $('#ip_field_1').val(fields[0]);
      $('#ip_field_2').val(fields[1]);
      $('#ip_field_3').val(fields[2]);
      $('#ip_field_4').val(fields[3]);
    }
  }
});
