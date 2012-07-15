// Credit: http://www.erichynds.com/javascript/a-recursive-settimeout-pattern/

function checkJobStatus(resqueJobId, checkJobStatusPath, jobDonePath){
  function recursiveCheckJobStatus(){
    // 'response' in the success function is whatever is rendered by the controller 
    setTimeout(function(){
      $.ajax({
        url: checkJobStatusPath + resqueJobId, 
        success: function(response) {
          var pctDone = response.pct; 
          var myStatus = response.mystatus;
            if (!isNaN(pctDone)) {
              // Update the on-screen progress bar
              $('.progress').width(2*pctDone);
              $('.progress').html(pctDone+"%");
              if (myStatus == "completed") {
                window.location=jobDonePath; 
              } else {
                recursiveCheckJobStatus(); // recurse
              };
            } else {
              // If here, pct is not a number
              // just display the response
              $('#messages').html(response);
            };
        }, 
        error: function() {
          // do some error handling. Should 
          // probably adjust the timeout here. 
          recursiveCheckJobStatus();
        } 
      });
    }, 1000); // wait 1000 milliseconds or one second
  }
  recursiveCheckJobStatus();
}

$(document).ready(function(){
  var jobkey = $('#job_key');
  if (jobkey.length > 0) {
    var resqueJobId = jobkey.attr("data-key");
    var checkStatusPath = jobkey.attr("data-checkStatusPath");
    var jobDonePath = jobkey.attr("data-jobDonePath");
    checkJobStatus(resqueJobId, checkStatusPath, jobDonePath);
  }
});
