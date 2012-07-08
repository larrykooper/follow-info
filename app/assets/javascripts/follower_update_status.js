var JOBID = "";

// Credit: http://www.erichynds.com/javascript/a-recursive-settimeout-pattern/

function rst(){
  setTimeout(function(){
    $.ajax({
      url: '/welcome/check_foller_update_status?follers_job_id=' + JOBID,
      success: function( response ){               
        $('#foller_update_status').width(2*response); 
        $('#foller_update_status').html(response+"%");
        if (response == "100")
        {
	        window.location="/welcome/list_follers";
        }
        else 
        {
	        rst(); // recurse
        };                                  
    },
      error: function(){
               // do some error handling.  you
               // should probably adjust the timeout
               // here. 
               rst(); // recurse, if you'd like.
      }
    });
  }, 1000);
}

$(document).ready(function(){	
	JOBID = $('#job_key').attr("data-key");
	rst();
});	