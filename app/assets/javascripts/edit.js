$(document).ready(function()
  {
    $(".tagName").click(function(event) {
		  $('#tag').val($(event.target).text());
    });
});