//add your api here below
var API_ENDPOINT = "https://7icm8d0fvg.execute-api.us-east-1.amazonaws.com/sandbox"
//AJAX PUT REQUEST
document.getElementById("saveprofile").onclick = function(){
  var inputData = {
    "empId":$('#empid').val(),
        "empFirstName":$('#fname').val(),
        "empLastName":$('#lname').val(),
    "empAge":$('#empage').val()           
      };
  $.ajax({
        url: API_ENDPOINT,
        type: 'POST',
        data:  JSON.stringify(inputData)  ,
        contentType: 'application/json; charset=utf-8',
        success: function (response) {
          document.getElementById("profileSaved").innerHTML = "Profile Saved!";
        },
        error: function () {
            alert("error");
        }
    });
}
//AJAX GET REQUEST
document.getElementById("getprofile").onclick = function(){  
  $.ajax({
        url: API_ENDPOINT,
        type: 'GET',
         contentType: 'application/json; charset=utf-8',
         success: function (response) {
          console.log(response); // log the response to the console
          $('#employeeprofile tr').slice(1).remove();
          var responseData = JSON.parse(response.body); // parse the response body
          jQuery.each(responseData, function(i,data) {          
            $("#employeeprofile").append("<tr> \
                <td>" + data['empId'] + "</td> \
                <td>" + data['empFirstName'] + "</td> \
                <td>" + data['empLastName'] + "</td> \
                <td>" + data['empAge'] + "</td> \
                </tr>");
          });
        }
    });
}
