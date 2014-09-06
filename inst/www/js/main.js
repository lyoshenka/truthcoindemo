$(function(){

  //because identity is in base
  ocpu.seturl("//lyoshenka.ocpu.io/truthcoindemo/R")


  $("#data").handsontable({
    colWidths: 85,
    minSpareRows: 1,
    cells: function (row, col, prop) {
      var cellProperties = {};
      if (row < 5) {
        cellProperties.readOnly = true;
      }
      return cellProperties;
    },
    data: [
      ["Label","QID1","QID2","QID3","QID4","QID5","QID6","QID7","QID8","QID9","QID10"],
      ["Qtext","2012 Obama Won","2012 Romney Won","2012 Dem Majority","2012 Rep Majority","2012 Rep Seats","2012 Patriots Superbowl","2014 Broncos Superbowl","06/27/2014 DJIA Price","06/27/2014 GLD 120+","07/09/2014 DJIA Price"],
      ["Qtype","B","B","B","B","S","B","B","B","B","S"],
      ["Min","0","0","0","0","0","0","0","0","0","8000"],
      ["Max","1","1","1","1","538","1","1","1","1","20000"],
      ["Voter 1","1","0","1","1","242","0","0","1","1","16985.61"],
      ["Voter 2","0","0.5","0.5","","240","0","0","1","0","16985.61"],
      ["Voter 3","1","0","1","1","242","0","0","1","1",""]
    ]
  });
  
//  $('#data table').addClass('table'); // add bootstrap styles to table

  //actual handler
  $("#submitbutton").on("click", function(){

    var table = $("#data").handsontable('getInstance'),
        data = table.getData(0,0,table.countRows()-2,table.countCols()-1);

    //disable button
    $("button").attr("disabled", "disabled");

    //perform the request
    var req = $('#plot').rplot("truthcoindemo", {
      "csvdata": Papa.unparse(data)
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
