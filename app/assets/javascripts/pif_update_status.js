var PIFJOBID = "";

// Credit: http://www.erichynds.com/javascript/a-recursive-settimeout-pattern/

function rstp(){
	// 'response' in the success function is whatever is rendered by the controller
  setTimeout(function(){
    $.ajax({
      url: '/welcome/check_pif_update_status?pifs_job_id=' + PIFJOBID,
      success: function(response){
	      //console.log("response:"+response);
	      if (!isNaN(response)) {
          $('#pif_update_status').width(2*response);
          $('#pif_update_status').html(response+"%");
          if (response == "100") {
	          window.location="/welcome/list_pif";
          } else {
	          rstp(); // recurse
          };
        } else {
        // just display the message
        $('#messages').html(response);
      }          
    },
      error: function(){
               // do some error handling.  you
               // should probably adjust the timeout
               // here. 
               rstp(); // recurse, if you'd like.
      }
    });
  }, 1000);
}

$(document).ready(function(){
  var jobkey = $('#job_key');
  if (jobkey) {
    var page = jobkey.attr("data-page");
    if (page == "check_pif_update_status") {
      PIFJOBID = jobkey.attr("data-key");
      rstp();
    }
  }
});	