function musicbox(key){
  var x=document.getElementById("play_key").value=key;
}
function jukebox(key){
  var song=document.getElementById("apiswf").rdio_play(key);
}

