$(document).ready(function() 
  { 
    $(".tagName").click(function(event) {
		  $('#tags').val($(event.target).text());	
    });
});
