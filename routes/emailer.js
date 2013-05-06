/* --------- API Function ------------ */
/*API call: /api/sendgrid/alert

Sample Invite object for post request

{
    "conferenceCode": "9351579103",
    "phoneNumber": "4086468223",
    "title": "Scrum",
    "attendees": [
        "wes.k.leung@gmail.com"
    ],
    "messageType": "invite",
    "initiator": "wes.k.leung@gmail.com",
    "start": {
        "dateTime": "2012-04-23T18:25:43.511Z",
        "timeZone": "America/Los_Angeles"
    }
}
*/

var Email = require('sendgrid').Email;
var SendGrid = require('sendgrid').SendGrid;

//Update this upon app store approval.
var downloadURL = "http://itunes.com/apps/callinapp"  

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
    var eventTitle = req.body.title;
    var startTime = stringifyTimeObject(req.body.start);
 
    var sender, msgSubject, body;
    if(messageType == 'invite') {
        sender = 'Invite@CallInapp.com';
        msgSubject = eventTitle + " Call: " + initiator + " on " + startTime;
        body = initiator + " has invited you to join a conference call through CallinApp. To join, download Callin at: " + downloadURL + ".\n\n"  
            + "You may also dial-in: " + conferencePhoneNumber + ".\n\n" 
            + "With code: " + conferenceCode + ".\n";
    } else if (messageType == 'alert') {
        sender = 'Alert@CallInapp.com';
        msgSubject = initiator + " is running late for your call: " + eventTitle + "at " + conferenceCode; 
        body = "Sometimes life throws you curveballs, and it's how you respond that defines you. That's why you're receiving this email: to let you know that " + initiator + " is running late and will be joining the conference call as soon as possible.";
    }
    var email = new Email({
        from: sender,
        replyto: initiator,
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

//todo: write additional logic here to format the readable string according
function stringifyTimeObject(timeObject) {
    if(timeObject) {
        var date = new Date(timeObject.dateTime);
        return date.toString();
    } else {
        return "";
    }    
 }
