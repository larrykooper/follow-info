$.tablesorter.addParser({id:"digitcomma",is:function(e,t){var n=t.config;return $.tablesorter.isDigit(e,n)},format:function(e){return e.match(",")&&(e=e.replace(/\,/g,"")),$.tablesorter.formatFloat(e)},type:"numeric"}),$(document).ready(function(){$("#myPifs").tablesorter({sortList:[[0,1],[1,0],[2,1],[3,0],[4,0]]})});