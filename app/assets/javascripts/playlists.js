function musicbox(key){
  var x=document.getElementById("play_key").value=key;
}

function pause_control(){
  var song = document.getElementById("apiswf").rdio_pause();
  var glyph = document.getElementById("pause_glyph");
  var btn = document.getElementById("control_button").setAttribute("onclick", "jukebox();");
  glyph.className="glyphicon glyphicon-play";

}

function jukebox(key){
  var song=document.getElementById("apiswf").rdio_play(key);
  var nav = document.getElementById("hide_nav").className="show";
  document.getElementById("control_button").setAttribute("onclick", "pause_control();")
  document.getElementById("pause_glyph").className="glyphicon glyphicon-pause";
}

function previous(){
  document.getElementById("apiswf").rdio_previous();
}

function next(){
  document.getElementById("apiswf").rdio_next();
}

function hide_nav(){
  $("#open_nav_wrapper").removeClass("hidden").addClass("show");
  $("#hide_nav").removeClass("show").addClass("invisible")
}

function open_nav(){
  $("#hide_nav").removeClass("invisible").addClass("show")
}








