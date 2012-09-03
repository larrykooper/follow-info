$(document).ready(function() 
  { 
    $(".tagName").click(function(event) {
      var thetag = $(event.target);
		  $('#tag').val(thetag.text());
		  if (thetag.hasClass('published')) {
		    $('#is_tag_pub').html('yes');
		  } else {
		     $('#is_tag_pub').html('no');
		  }
    });
});
