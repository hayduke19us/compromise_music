$(function() {
  $("#flow").hover( function(){
    $("#flow_example").attr("src", "http://i.imgur.com/fSKOAt7.png?1");
  });
  $("#share").hover( function(){
    $("#flow_example").attr("src", "http://i.imgur.com/uKAda1l.png?1");
  });
  $("#vote").hover( function(){
    $("#flow_example").attr("src", "http://i.imgur.com/Z99Helb.png?1");
  });
});

function closeModal(trackId){
  $("#" + trackId).modal('hide');
};

