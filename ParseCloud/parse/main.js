//Using Twilio Cloud Module on Parse to send an SMS via Twilio. 

var twilio = require('twilio');
twilio.initialize('ACbbb2f0208bf81489c3c497c7ca3cad88', '6aa8522ddf93b0ce14791e864118f94b');

Parse.Cloud.define("inviteWithTwilio", function(request, response) {
    twilio.sendSMS({
       From: "+16503535255",
       To: "+16507999828",
       Body: "Suck ma bawlZ!"
    }, {
	success: function(httpResponse) {
		console.log(httpResponse);
		response.success("SMS sent!");
	    },
  	error: function(httpResponse) {
		console.error(httpResponse);
		response.error("Uh oh, something went wrong");
	    }
	});
});

Parse.Cloud.define("send-sms", function(request, response) {
	var to = null,
		from = null,
		body = null;
	if (to == null || from == null || body == null) {
		response.error("Incomplete parameters");
	} else {
		twilio.sendSMS({
			From: from,
			To: to,
			Body: body
		}, {
			success: function(httpResponse) {
				response.success(httpResponse);
			},
			error: function(httpResponse) {
				response.error(httpResponse);
			}
		});
	}
});

//call function with the following script in terminal:
/*
curl -X POST \
>   -H "X-Parse-Application-Id: ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj" \
>   -H "X-Parse-REST-API-Key: sgrrNRWRbI4a85J7XRyfHSyEl161kO9EEFinCRac" \
>   -H "Content-Type: application/json" \
>   -d '{"movie":"The Matrix"}' \
>   https://api.parse.com/1/functions/inviteWithTwilio
*/