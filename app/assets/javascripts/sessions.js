function pl_option(name) {
  var att = "#" + name;
  var id = "#" + name + "_1"
  $(att).attr("class", "show");
  $(id).attr("onclick", "pl_close(" + "'" + name + "'" + ")");
}

function pl_close(name) {
  var att = "#" + name;
  var id = "#" + name + "_1";
  $(att).attr("class", "hidden");
  $(id).attr("onclick", "pl_option(" + "'" + name + "'" + ")");
}

