// Functions

// function getAll(selector) {
//   return Array.prototype.slice.call(document.querySelectorAll(selector), 0);
// }

// // Modals

// var rootEl = document.documentElement;
// var $modals = getAll(".modal");
// var $modalButtons = getAll(".modal-button");
// var $modalCloses = getAll(
//   ".modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button"
// );

// if ($modalButtons.length > 0) {
//   $modalButtons.forEach(function ($el) {
//     $el.addEventListener("click", function () {
//       var target = $el.dataset.target;
//       openModal(target);
//     });
//   });
// }

// if ($modalCloses.length > 0) {
//   $modalCloses.forEach(function ($el) {
//     $el.addEventListener("click", function () {
//       closeModals();
//     });
//   });
// }

// function openModal(target) {
//   var $target = document.getElementById(target);
//   rootEl.classList.add("is-clipped");
//   $target.classList.add("is-active");
// }

// function closeModals() {
//   rootEl.classList.remove("is-clipped");
//   $modals.forEach(function ($el) {
//     $el.classList.remove("is-active");
//   });
// }

document.addEventListener("keydown", function (event) {
  var e = event || window.event;
  if (e.keyCode === 27) {
    $(".modal-close").parent().removeClass("is-active");

    // closeModals();
    // closeDropdowns();
  }
});

$(function () {
  // $("#mylauncher").click(function () {
  //   $("#mymodal").toggleClass("is-active");
  // });
  $(".modal-button").click(function () {
    // alert('hi')
    //$("#mymodal").toggleClass("is-active");
    var target = $(this).data("target");
    $("html").addClass("is-clipped");
    $(target).addClass("is-active");
    // $(target).toggleClass("is-active");
  });

  $.each([".modal-close", ".modal-background"], function (index, element) {
    $(element).click(function () {
      $("html").removeClass("is-clipped");
      $(this).parent().removeClass("is-active");
    });
  });
});
