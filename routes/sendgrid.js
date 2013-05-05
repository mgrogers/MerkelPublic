/* --------- API Function ------------ */
/*API call: /api/sendgrid/alert
[messageType] Message type - single word "invite" or "alert"
[initiator] Person initiating the conference call or an alert that he or she is running late 
[attendees] Unique identifier for a conference call. //e.g. ["mjgrogers@gmail.com", "bossmobilewunderkinds@lists.stanford.edu", .....]
[phoneNumber] Phone number of conference call
[conferenceCode] Conference code for call
[event] event json object  {'name': 'event name', 'start':{'datetime': date time object, 'timezone':'Pacific'}  }
*/
var Email = require('sendgrid').Email;
var SendGrid = require('sendgrid').SendGrid;

exports.emailAlert = function(req, res) {
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


    var messageType = req.body.messageType;
    var initiator = req.body.initiator;
    var conferenceAttendees = req.body.attendees;
    var conferencePhoneNumber = req.body.phoneNumber;
    var conferenceCode = req.body.conferenceCode;
    var event = req.body.event;

    var startTime = stringifyTimeObject(event);
 

    var sender, msgSubject, body;
    if(messageType == 'invite') {
        sender = 'Invite@CallInapp.com';
        msgSubject = "Call invite from: " + initiator + " for " + event.name " at " + startTime;
        body = "You're receiving this email because " + initiator + " has initiated a conference call with CallIn, and would like you to join!";
    } else if (messageType == 'alert') {
        sender = 'Alert@CallInapp.com';
        msgSubject = initiator + " has sent you an alert regarding your upcoming conference call";
        body = "Sometimes life throws you curveballs, and it's how you respond that defines you. That's why you're receiving this email: to let you know that " + initiator + " is running late and will be joining the conference call as soon as possible.";
    }
    var email = new Email({
        // to: conferenceAttendees, 
        from: sender,
        subject: msgSubject,
        text: body
    });
    email.addTo(conferenceAttendees);

    sendgrid.send(email, function(success, message) {
        if(!success) {
            var response = {"meta": {"code": 400},
      	                 "message": "Invitation delivery failed. " + message};
            res.send(400, response);
		} else {
            var response = {"meta": {"code": 200},
                         "message": "Invite delivered to :" + conferenceAttendees};    
            res.send(response);
        }
    });
 }

function stringifyTimeObject(timeObject) {
    var date = new Date(timeObject.dateTime);
    //need to write additional logic here to format the readable string according to recipient timezone
    return date.toString();
 }
