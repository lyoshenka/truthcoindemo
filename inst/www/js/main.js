$(function(){

  //because identity is in base
  ocpu.seturl("//lyoshenka.ocpu.io/truthcoindemo/R")


  $("#data").handsontable({
    colWidths: 85,
    minSpareRows: 1,
    minSpareCols: 1,
    cells: function (row, col, prop) {
      var cellProperties = {};
      if (row < 5) {
        cellProperties.readOnly = true;
      }
      return cellProperties;
    },
    data: [
      ["Label","QID1","QID2","QID3","QID4","QID5","QID6","QID7","QID8","QID9","QID10"],
      ["Qtext","In the United States, following the 2012 November / elections, was Barack Obama elected US President?","In the United States, following the 2012 November / elections, was Mitt Romney elected US President?","In the United States, following the 2012 November / elections, did the Democratic Party control 51...","In the United States, following the 2012 November / elections, did the Republican Party control 218...","In the United States, following the 2012 November / elections, how many seats in the House of Repre...","During the 2011-2012 United States football season, did the New / England Patriots (AFC) win the 20...","During the 2013-2014 United States football season, did the Denver / Broncos (AFC) win the 2014 Sup...","On June 27th, 2014, was the closing price of the Dow Jones / Industrial Average (INDEXDJX:.DJI) abo...","On June 27th, 2014, was the closing price of the SPDR Gold Trust / (ETF) (NYSEARCA:GLD) above 120?","On July 9th, 2014, what was the closing price of the Dow Jones / Industrial Average (INDEXDJX:.DJI,..."],
      ["Qtype","B","B","B","B","S","B","B","B","B","S"],
      ["Min","0","0","0","0","0","0","0","0","0","8000"],
      ["Max","1","1","1","1","538","1","1","1","1","20000"],
      ["Voter 1","1","0","1","1","242","0","0","1","1","16985.61"],
      ["Voter 2","0","0.5","0.5","","240","0","0","1","0","16985.61"],
      ["Voter 3","1","0","1","1","242","0","0","1","1",""]
    ]
  });

  //actual handler
  $("#submitbutton").on("click", function(){

    var table = $("#data").handsontable('getInstance'),
        data = table.getData(0,0,table.countRows()-2,table.countCols()-2);

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
