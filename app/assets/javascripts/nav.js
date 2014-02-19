$(function () {

  $("#playlist_pg").click(function () {
    $("#analytics_pg").attr("class", "");
    $("#home_pg").attr("class", "");
    $("#playlist_pg").attr("class", "active");
  });

  $("#analytics_pg").click(function () {
    $("#playlist_pg").attr("class", "");
    $("#home_pg").attr("class", "");
    $("#analytics_pg").attr("class", "active");
  });

});
