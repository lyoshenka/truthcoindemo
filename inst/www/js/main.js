$(function(){

  //because identity is in base
  ocpu.seturl("//lyoshenka.ocpu.io/truthcoindemo/R")

  //actual handler
  $("#submitbutton").on("click", function(){

    //disable button
    $("button").attr("disabled", "disabled");

    //perform the request
    var req = $('#plot').rplot("truthcoindemo", {
      "csvdata": $("#data").val()
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
