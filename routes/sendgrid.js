/* --------- API Function ------------ */
/*API call: /api/sendgrid/alert
[msgType] Message type - single word "invite" or "alert"
[initiator] Person initiating the conference call or an alert that he or she is running late 
[attendees] Unique identifier for a conference call 
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
	var data = req.body;
    console.log("data attendees" + data);
    var messageType = data.msgType;
    var initiator = data.initiator;
    var conferenceAttendees = data.attendees;
    var sender, msgSubject, body;

    var Email = require('sendgrid').Email;
    var email = new Email(optionalParams);
    var optionalParams = {
        html: ''
    };

    if(messageType == 'invite') {
        sender = 'Invite@CallInapp.com';
        msgSubject = initiator + " has invited you to a conference call with CallIn!";
        body = "You're receiving this email because " + initiator + " has initiated a conference call with CallIn, and would like you to join!";
    } else {
        sender = 'Alert@CallInapp.com';
        msgSubject = initiator + " has sent you an alert regarding your upcoming conference call";
        body = "Sometimes life throws you curveballs, and it's how you respond that defines you. That's why you're receiving this email: to let you know that " + initiator + " is running lateand will be joining the conference call as soon as possible.";
     }
    var email = new Email({
        // to: conferenceAttendees, //e.g. ["mjgrogers@gmail.com", "bossmobilewunderkinds@lists.stanford.edu", .....]
        from: sender,
        subject: msgSubject,
        text: body
    });
    email.addTo(conferenceAttendees);
    sendgrid.send(email, function(success, message) {
        if(!success) {
            console.log("failed" + message);
            var response = {"meta": {"code": 400},
      	                 "message": "Invitation delivery failed"};
            res.send(400, response);
		} else {
            console.log("succeed" + success);
            var response = {"meta": {"code": 200},
                         "message": "Invite delivered"};    
            res.send(response);
        }
    });
 }
