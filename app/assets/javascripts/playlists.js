$(function (){
  $("#query").focus();
  $("#option_track").click(function(){
    $("#query").attr('placeholder', "'to ramona'").focus();
    $("#search_type").html("Track")
  })
  $("#option_artist").click(function(){
    $("#query").attr('placeholder', "'bob dylan'").focus();
    $("#search_type").html("Artist")
  })
  $("#option_album").click(function(){
    $("#query").attr('placeholder', "'freewheeling'").focus();
    $("#search_type").html("Album")
  })
})

function show_search(artist_key_id){
  var tag = "#" + artist_key_id
  $(tag).removeClass("hidden").addClass("show");
}

function show_play(key_id){
  var tag = "#" + key_id;
  $(tag).removeClass("invisible").addClass("show");
}

function hide_play(key_id){
  var tag = "#" + key_id;
  $(tag).removeClass("show").addClass("invisible");
}

function musicbox(key){
  var x=document.getElementById("play_key").value=key;
}

function pause_control(){
  var song = document.getElementById("apiswf").rdio_pause();
  var glyph = document.getElementById("pause_glyph");
  var btn = document.getElementById("control_button").setAttribute("onclick", "jukebox();");
  glyph.className="glyphicon glyphicon-play";
  $("#equalizer").fadeOut('slow');
}

function jukebox(key){
  var nav = document.getElementById("hide_nav").className="show";
  var song=document.getElementById("apiswf").rdio_play(key);
  document.getElementById("control_button").setAttribute("onclick", "pause_control();")
  document.getElementById("pause_glyph").className="glyphicon glyphicon-pause";
  $("#graph").attr("class", "hide")
  $("#equalizer").fadeIn("slow");
  $("#freq").css("height", "50px");
}

function previous(){
  document.getElementById("apiswf").rdio_previous();
}

function next(){
  document.getElementById("apiswf").rdio_next();
}

function hide_nav(){
  $("#open_nav_wrapper").removeClass("hidden").addClass("show");
  $("#hide_nav").removeClass("show").addClass("invisible");
}

function open_nav(){
  $("#hide_nav").removeClass("invisible").addClass("show");
}

function plTag(tag){
  var value = $("#new-pl-tag").val()
  if(value)
    $("#new-pl-tag").val(value + ", " + tag);
  else
    $("#new-pl-tag").val(tag);
}

