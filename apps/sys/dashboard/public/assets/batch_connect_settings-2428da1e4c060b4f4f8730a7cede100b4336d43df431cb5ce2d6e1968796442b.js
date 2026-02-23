// app/javascript/config.js
"use strict;";

// app/javascript/utils.js
function showSpinner() {
  $("body").addClass("modal-open");
  $("#full-page-spinner").removeClass("d-none");
}
function bindFullPageSpinnerEvent() {
  $(".full-page-spinner").each((index, element) => {
    const $element = $(element);
    if ($element.is("a")) {
      $element.on("click", showSpinner);
    } else {
      $element.closest("form").on("submit", showSpinner);
    }
  });
}

// app/javascript/batch_connect_settings.js
jQuery(function() {
  bindFullPageSpinnerEvent();
});
//# sourceMappingURL=/pun/sys/dashboard/assets/batch_connect_settings.js-defc4b4fab8d53b8722a8ccaa6937eb3374ca8203b62ad7083d7ba6436971f58.map
//!
;
