$.tablesorter.addParser({ 
  id: "digitcomma", 
  is: function(s,table) { 
      var c = table.config; 
      return $.tablesorter.isDigit(s,c); 
  }, 
  format: function(s) { 
     if (s.match(',')) { 
          s = s.replace(/\,/g, ''); 
     }
  return $.tablesorter.formatFloat(s); 
  }, 
  type: "numeric" 
}); 

$(document).ready(function() 
    { 
        $("#myPifs").tablesorter({
          sortList:[[0,1],[1,0],[2,1],[3,0],[4,0]] 
        })
    } 
); 
   