/* ------------------------ */
/* NEW SERVICE CONFIGURATOR */
/* ------------------------ */

function populateIpAddresses(location_code) {
  $.ajax({
    dataType: "json",
    url: "/provisioning/ip_address",
    data: "location=" + location_code,
    success: function (data) {
      ips = data["ips"];

      options = "<option>" + data["caption"] + "</option>";

      $.each(ips, function (k, v) {
        options += '<option value="' + v["ip_address"] + '"';
        options += (v["assigned"] ? " disabled" : "") + ">";
        options += v["ip_address"];

        if (v["assigned"]) {
          options += " (" + v["assignment"] + ")";
        }

        options += "</option>";
      });

      element = $("#ipv4_address_selector");
      element.html(options);
      element.parent().removeClass("is-loading");
    },
    error: function (data) {
      alert(
        "Could not retrieve IP addresses.\nPlease try again later."
      );
    },
  });
}

function resetSSHKeyDialogForm() {
  $.each(["input", "textarea"], function (index, element) {
    $("#ssh_key_dialog_form " + element).each(function (index) {
      $(this).val("");
    });
  });
}

$(function () {
  /* Change the IP address drop-down based on the chosen location */
  $("#new_vps_with_os input[name=location]").change(function () {
    if ($(this).is(":checked")) {
      $("#ipv4_address_selector").parent().addClass("is-loading");
      populateIpAddresses($(this).val());
    }
  });

  // Let us add a new key on-the-fly
  $("#ssh_key_selector").change(function () {
    if ($(this).val() == "add") {
      $("#ssh_key_dialog").addClass("is-active");
      $("html").addClass("is-clipped");

      $(this).val("none");
    }
  });

  $("#ssh_key_dialog_form").on("submit", function (e) {
    $.ajax({
      type: "POST",
      url: this.action,
      data: $(this).serialize(),
      success: function (response) {
        closeModals();
        resetSSHKeyDialogForm();
      },
      error: function (response) {
        alert(response["errors"]);
      },
    });
    e.preventDefault();
  });

  // ---------- //
  // Navigation //
  // ---------- //

  // Check for click events on the navbar burger icon
  $(".navbar-burger").click(function () {
    // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
    $(".navbar-burger").toggleClass("is-active");
    $(".navbar-menu").toggleClass("is-active");
  });
});
