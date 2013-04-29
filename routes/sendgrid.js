/* --------- API Function ------------ */
/*API call: /api/sendgrid/alert
[type] Message type - single word "invite" or "alert"
[initiator] Person initiating the conference call or an alert that he or she is running late 
[conferenceCode] Unique identifier for a conference call 
*/

exports.emailAlert = function(req, res) {
	var SendGrid = require('sendgrid').SendGrid;
	

	var user, key; 
	if(!process.env.SENDGRID_USERNAME) {
		user = "app12018585@heroku.com";
	} else {
		user = process.env.SENDGRID_USERNAME;
	}
	if(!process.env.SENDGRID_PASSWORD) {
		key = "xtce2l6u";
	} else {
		key = process.env.SENDGRID_PASSWORD;
	}
	var sendgrid = new SendGrid(user, key);
	//var initiator = data.initiator;
  	//var conferenceAttendees = [data.conferenceCode.attendees];

  var Email = require('sendgrid').Email;
  var email = new Email(optionalParams);
  var optionalParams = {
    html: ''
    //"You're receiving this email because [user] has initiated a conference call via CallIn, and has invited you to join!"
  };
  var email = new Email({
    to: ["mjgrogers@gmail.com"],
    from: 'Invite@CallInapp.com',
    subject: 'Mike has invited you to a conference call via CallIn!',
    text: "Bitch bitch, mccbitch"
  });
  sendgrid.send(email, function(success, message) {
  	  if(!success) {
			console.log(message);
			var response = {"meta": {
                               "code": 400
                           	},
      	                    "message": "Invitation delivery failed"
   	                       };
			res.send(400, response);
		} 
		console.log(success);
		var response = {"meta": {
                          "code": 200
                        },
                        "message": "Invite delivered"
                       };
		res.send(response);
  	});
 }

/*	sendgrid.send({
  		to: 'mjgrogers@gmail.com',
  		from: 'Invite@CallInapp.com',
  		subject: '[User] has invited you to a conference call via CallIn!',
  		text: "Hello There! You're receiving this email because [user] has initiated a conference call via CallIn, and has invited you to join!",
  		html: 

	}, function(success, message) {
  	  if(!success) {
			console.log(message);
			var response = {"meta": {
                               "code": 400
                           	},
      	                    "message": "Invitation delivery failed"
   	                       };
			res.send(400, response);
		} 
		console.log(success);
		var response = {"meta": {
                          "code": 200
                        },
                        "message": "Invite delivered"
                       };
		res.send(response);
  	});
} */
