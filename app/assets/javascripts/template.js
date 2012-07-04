// The following Javascript code is standard to the "UCD DSS IT" Twitter Bootstrap template.

// Let Underscore know we'll be using Mustache-style templates
_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};

$(function() {
  // Fix AJAX headers
  $.ajaxSetup({
    beforeSend: function (xhr, settings) {
      xhr.setRequestHeader("accept", '*/*;q=0.5, ' + settings.accepts.script);
    }
  });

  application.initialize();
});

// Template-wide Javascript (setting up tabs, buttons, common callbacks, etc.)
(function (template, $, undefined) {
  template.status_text = function(message) {
    $("div.status_bar").show().html(message);
  }

  template.hide_status = function() {
    $("div.status_bar").hide();
  }
} (window.template = window.template || {}, jQuery));

(function (application, $, undefined) {
  application.current_user_id = null;
  application.impersonate_user = null;

  application.initialize = function() {
    $("#admin-impersonate").click(application.impersonate_dialog);
    $("#admin-unimpersonate").click(function() {
      window.location.href = Routes.admin_ops_unimpersonate_path();
    });

    $("#admin-about").click(application.about_dialog);
  }

  application.impersonate_dialog = function() {
    template.status_text("Loading...");

    $.get(Routes.admin_dialogs_impersonate_path(), function(data) {
      template.hide_status();
      $("#modal_container").empty();
      $("#modal_container").append(data);
      $("#impersonate_modal").modal();
    });
  }

  application.about_dialog = function() {
    template.status_text("Loading...");

    $.get(Routes.about_path(), function(data) {
      template.hide_status();
      $("#modal_container").empty();
      $("#modal_container").append(data);
      $("#about_modal").modal();
    });
  }
} (window.application = window.application || {}, jQuery));
