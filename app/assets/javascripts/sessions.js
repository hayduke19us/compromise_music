$( function(){
 $("#simple").tooltip({trigger: "hover", 
                       placement: "left",
                       title: "Simple Success",
                       delay: {show: 10, hide: 20}
 });
});
$( function(){
 $("#middle").tooltip({trigger: "hover", 
                       placement: "left",
                       title: "Middle of the road",
                       delay: {show: 10, hide: 20}
 });
});
$( function(){
 $("#top_dog").tooltip({trigger: "hover", 
                       placement: "left",
                       title: "Top of the class",
                       delay: {show: 10, hide: 20}
 });
});
$( function(){
 $("#add_track_pop").popover("show")
});
