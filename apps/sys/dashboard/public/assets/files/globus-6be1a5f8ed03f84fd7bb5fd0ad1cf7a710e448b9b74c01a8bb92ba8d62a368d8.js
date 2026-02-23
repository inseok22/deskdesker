// app/javascript/files/globus.js
var globus_endpoints;
$(document).ready(function() {
  globus_endpoints = $("#globus_endpoints").data("globusEndpoints");
});
function getEndpointInfo(directory) {
  for (const endpoint of globus_endpoints) {
    if (directory.startsWith(endpoint["path"])) {
      return endpoint;
    }
  }
}
function getGlobusLink(directory) {
  let info = getEndpointInfo(directory);
  if (info) {
    let origin_path = directory.replace(info.path, info.endpoint_path);
    origin_path = origin_path.replace("//", "/");
    return "https://app.globus.org/file-manager?origin_id=" + info.endpoint + "&origin_path=" + origin_path;
  }
}
function updateGlobusLink(directory, link, wrapper) {
  let info = getEndpointInfo(directory);
  if (info) {
    link.removeClass("disabled");
    wrapper.prop("title", "Open the current directory with Globus");
  } else {
    link.addClass("disabled");
    wrapper.prop("title", "No Globus endpoint associated with this directory");
  }
}
export {
  getGlobusLink,
  updateGlobusLink
};
//# sourceMappingURL=/pun/sys/dashboard/assets/files/globus.js-444341200a59f9361c59ca82597ac553f5cfcf2f81ede2308768a1ef1e5754b1.map
//!
;
