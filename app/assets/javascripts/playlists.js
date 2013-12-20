function musicbox(key){
  var x=document.getElementById("play_key").value=key;
  document.getElementById("hide_nav").className="visible"
}
function jukebox(key){
  var song=document.getElementById("apiswf").rdio_play(key);
}

