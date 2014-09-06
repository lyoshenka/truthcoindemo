$(function(){

  //because identity is in base
  ocpu.seturl("//public.opencpu.org/ocpu/library/base/R")

  //actual handler
  $("#submitbutton").on("click", function(){

    //arguments
    var mysnippet = new ocpu.Snippet($("#code").val());
    
    //disable button
    $("button").attr("disabled", "disabled");

    //perform the request
    var req = ocpu.call("identity", {
      "x": mysnippet
    }, function(session){
        session.getObject().always(function(data){ 
          console.log(data);
          $("#return").text(data); 
        });
        session.getConsole(function(outtxt){
          $("#output").text(outtxt); 
        });
    });
        
    //if R returns an error, alert the error message
    req.fail(function(){
        alertify.alert("Server error: " + req.responseText);
    });      
    
    req.always(function(){
        $("button").removeAttr("disabled");    
    });
  });

});
