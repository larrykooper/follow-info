var JOBID = "";

// Credit: http://www.erichynds.com/javascript/a-recursive-settimeout-pattern/

function rst(){
   setTimeout(function(){
       $.ajax({
           url: '/welcome/check_foller_update_status?follers_job_id=' + JOBID,
           success: function( response ){
               $('#pctcom').html(response); 
               rst(); // recurse
           },
           error: function(){
               // do some error handling.  you
               // should probably adjust the timeout
               // here. 
               rst(); // recurse, if you'd like.
           }
       });
   }, 1500);
}

$(document).ready(function(){	
	JOBID = $('#job_key').attr("data-key");
	rst();
});	