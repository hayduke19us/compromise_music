$( document ).ready (function nav(){
  if ($("#current_page").length > 0){  
    var doc = document.getElementById("current_page").className;
    document.getElementById(doc).className="active";
  }
});
