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
  var nav = document.getElementById("hide_nav").className="show";
  var song=document.getElementById("apiswf").rdio_play(key);
  document.getElementById("control_button").setAttribute("onclick", "pause_control();")
  document.getElementById("pause_glyph").className="glyphicon glyphicon-pause";  
}





