var PIFJOBID = "";

// Credit: http://www.erichynds.com/javascript/a-recursive-settimeout-pattern/

function rstp(){
  setTimeout(function(){
    $.ajax({
      url: '/welcome/check_pif_update_status?pifs_job_id=' + PIFJOBID,
      success: function( response ){               
        $('#pif_update_status').width(2*response); 
        $('#pif_update_status').html(response+"%");
        if (response == "100")
        {
	        window.location="/welcome/list_pif";
        }
        else 
        {
	        rstp(); // recurse
        };                                  
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
	PIFJOBID = $('#job_key').attr("data-key");
	rstp();
});	