var ACCOUNT_SID = 'ACbbb2f0208bf81489c3c497c7ca3cad88';
var AUTH_TOKEN = '6aa8522ddf93b0ce14791e864118f94b';
var TWIML_APP_ID = 'AP361c96431ce7485f8b27da32da715b7d';
var TWILIO_NUMBER = '+16503535255'
var MINIMUM_CONFERENCE_CODE_LENGTH = 10;
var API_VERSION = '2013-04-23'

var twilio = require('twilio');
var SendGrid = require('sendgrid').SendGrid;
var Hashids = require("hashids");
var hashids = new Hashids("dat salt, yo", MINIMUM_CONFERENCE_CODE_LENGTH, "0123456789");

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var mongoose_options = {'auto_reconnect':true};
mongoose.connect(process.env.MONGOLAB_URI || 'mongodb://heroku_app12018585:8la71don2tthmm2ceaahdmhog2@ds045507.mongolab.com:45507/heroku_app12018585', mongoose_options);
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));


// Mixpanel
var Mixpanel = require('mixpanel');
var mixpanel = Mixpanel.init('47eb26b4488113bbb2118b83717c5956');


var Email = require('sendgrid').Email;
var SendGrid = require('sendgrid').SendGrid;
var kSendGridUser = "app12018585@heroku.com";
var kSendGridKey = "xtce2l6u";
//Update this upon app store approval.
var downloadURL = "http://itunes.com/apps/callinapp"  

var conferenceSchema = new Schema({
    conferenceCode: {type: String, default: ""},
    eventId: {type: String, default: ""},
    creatorId: {type: String, default: ""},
    status: {type: String, default: "inactive"},
    title: {type: String, default: ""},
    description: {type: String, default: ""},
    start: {type: Date, default: ""},
    timeZone: {type: String, default: "America/Los_Angeles"},
    sms: {type: Boolean, default: false},
    email: {type: Boolean, default: false} // 'active' or 'inactive'
});

var participantSchema = new Schema({
    phone: {type: String, default: ""},
    email: {type: String, default: ""},
    displayName: {type: String, default: ""},
    conferenceCode: {type: String, default: ""},
    status: {type: String, default: "inactive"} // 'active' or 'inactive'
});

var Conference = db.model('conference', conferenceSchema);
var Participant = db.model('participant', participantSchema);


/* ----- API Calls ----- */
/* API call for "/2013-04-23/conference/capability" to generate a Twilio capability token */
exports.capability = function(req, res) {
    var clientId = req.query.clientId;
    clientId = clientId || 'test';

    var timeout = req.query.timeout;
    timeout = timeout || 600;
    
    var capability = new twilio.Capability(ACCOUNT_SID, AUTH_TOKEN);
    capability.allowClientIncoming(clientId);
    capability.allowClientOutgoing(TWIML_APP_ID);

    var response = {capabilityToken: capability.generate(timeout)};

    mixpanel.track("capability request", {});

    return res.send(response);
};


/*
API Call: "/2013-04-23/conference/create" to generate a new conference, data for new conference will in POST
[Event POST data] example JSON POST can be found in test/fixtures/conference_create.json
*/
exports.create = function(req, res) {
    Conference.find(function(err, conferences) {
        var hash = 0;
        if (!err) {
            var numConferences = conferences.length;
            hash = hashids.encrypt(numConferences);
        } else {
            hash = hashids.encrypt(0);
        }

        var conferenceObject = {};
        var postBody = req.body;

        if (postBody) {
            conferenceObject.conferenceCode = hash;
            conferenceObject.status = "inactive";
            conferenceObject.title = postBody.title || "";
            conferenceObject.description = postBody.description || "";
            if (postBody.start) conferenceObject.start = postBody.start.datetime;
            else conferenceObject.start = "";
            if (postBody.start) conferenceObject.timeZone = postBody.start.timeZone;
            else conferenceObject.timeZone = "";
            if (postBody.inviteMethod) conferenceObject.sms = postBody.inviteMethod.sms;
            else conferenceObject.sms = false;
            if (postBody.inviteMethod) conferenceObject.email = postBody.inviteMethod.email;
            else conferenceObject.email = false;
        } else {
            conferenceObject = {conferenceCode: hash};
        }
        
        // Mixpanel
        mixpanel.track("conference create", {
            conferenceCode: hash,
            conferenceTitle: conferenceObject.title,
            conferenceDescription: conferenceObject.description
        });

        var conference = new Conference(conferenceObject);
        conference.save(function(err) {
            if (!err) {
                var participantsObject = {conferenceCode: conferenceObject.conferenceCode, participants: postBody.attendees}
                addParticipants(participantsObject);
            }
            return res.send(conferenceObject);
        });   
    });
};

exports.phoneConfirmation = function(req, res) {
    if (req.method == 'POST') {
        var postBody = req.body;
        if (postBody.phoneNumber) {
            var toPhone = postBody.phoneNumber;
            var code = Math.floor(Math.random() * 9000) + 1000; // Generate random 4 digit number.
            var message = code + " - your CallIn confirmation code.";
            var client = require('twilio')(ACCOUNT_SID, AUTH_TOKEN);
            client.sendSms({
                to: toPhone,
                from: TWILIO_NUMBER,
                body: message
            }, function(err, responseData) {
                if (!err) {
                    console.log("SMS delivered for " + toPhone);
                    return res.send({phoneNumber: toPhone,
                                     code: code});
                } else {
                    console.log(err);
                    return res.send(400, {error: err,
                                          reqBody: req.body});
                }
            });
        } else {
            return res.send(400, {error: "Missing phone number.",
                                  reqBody: req.body});
        };
    };
};

exports.smsAlert = function(req, res) {
    if (req.method == 'POST') {
        var postBody = req.body;
        console.log(postBody);
        if (postBody.conferenceCode && postBody.toPhoneNumber) {

            var initiator = postBody.initiator || "";
            var conferencePhoneNumber = postBody.phoneNumber || "";
            var conferenceCode = postBody.conferenceCode || "";
            var eventTitle = postBody.title || "";
            var startTime = stringifyTimeObject(postBody.start);
            var messageType = postBody.messageType || "";
            var toPhoneNumber = postBody.toPhoneNumber || "";

            var client = require('twilio')(ACCOUNT_SID, AUTH_TOKEN);
            var message;
            if (messageType == 'invite') {
                message = initiator + " invited you to a conference call via Callin. Download the app " + downloadURL 
                                    + " or dial-in at: " + conferencePhoneNumber + ",,," + conferenceCode + "#";
            } else if (messageType == 'alert') {
                message = "From CallinApp:" + initiator + " is running late to your upcoming conference " + eventTitle;
            } else {
                var response = {"meta": {"code": 404},
                             "message": "Invalid message type"};
                return res.send(response);
            }
            if (toPhoneNumber) {
                client.sendSms({
                    to: toPhoneNumber,
                    from: TWILIO_NUMBER,
                    body: message
                }, function(err, responseData) {
                    if (!err) {
                        var response = {"meta": {"code": 200},
                         "message": "Finished SMS for " + toPhoneNumber};
                        return res.send(response);
                    } else {
                        console.log(err);
                        var response = {"meta": {"code": 404},
                        "message": "Error sending sms"};
                        return res.send(response);
                    }
                });
            } else {
                var response = {"meta": {"code": 404},
                         "message": "Invalid phone number."};
                return res.send(response);
            } 
        } else {
            var err = {message: "Could not invite, did you POST the conferenceCode and phone number?"};
            return res.send(err);
        } 
    } else {
        var err = {message: "This API is POST only, please POST your invitee data"};
        return res.send(err);
    }
}

/*
API Call: "/2013-04-23/conference/emailAlert" to send an email for a conference to someone, data will be in POST data
[Invitee POST data] example JSON POST can be found in test/fixtures/conference_invite.json
*/
exports.emailAlert = function(req, res) {
    if(req.method == 'POST') {
        var postBody = req.body;
        console.log(postBody);
        if(postBody.conferenceCode && postBody.attendees) {
            var initiator = postBody.initiator || "";
            var conferencePhoneNumber = postBody.phoneNumber || "";
            var conferenceCode = postBody.conferenceCode || "";
            var eventTitle = postBody.title || "";
            var startTime = stringifyTimeObject(postBody.start);
            var messageType = postBody.messageType || "";

            var user, key; 
            if(!process.env.SENDGRID_USERNAME) {
                user = kSendGridUser
            } else {
               user = process.env.SENDGRID_USERNAME;
            }
            if(!process.env.SENDGRID_PASSWORD) {
                key = kSendGridKey;
            } else {
                key = process.env.SENDGRID_PASSWORD;
            }
            var sendgrid = new SendGrid(user, key);

            var conferenceAttendees = [];
            for (var i = 0; i < postBody.attendees.length; i++) {
                var emailAddress = postBody.attendees[i].email;
                if (emailAddress) {
                    conferenceAttendees.push(emailAddress);
                }                
            } 

            var sender, msgSubject, content;
            if(messageType == 'invite') {
                sender = 'Invite@CallInapp.com';
                msgSubject = "Call-in meeting: " + eventTitle + " at " + startTime;
                content = initiator + " has invited you to join a conference call through CallinApp. To join, download Callin at: " + downloadURL + ".\n\n"  
                    + "You may also dial-in: " + conferencePhoneNumber + ".\n\n" 
                    + "With code: #" + conferenceCode + ".\n";
            } else if (messageType == 'alert') {
                sender = 'Alert@CallInapp.com';
                msgSubject = initiator + " is running late for your call: " + eventTitle + " at " + conferenceCode; 
                content = "Sometimes life throws you curveballs, and it's how you respond that defines you. That's why you're receiving this email: to let you know that " + initiator 
                        + " is running late and will be joining the conference call, " + conferencePhoneNumber + ",,," + conferenceCode + "# as soon as possible.";
            }
            var email = new Email({
                from: sender,
                replyto: initiator,
                subject: msgSubject,
                text: content
            });
            email.addTo(conferenceAttendees);

            sendgrid.send(email, function(success, message) {
                if(!success) {
                    var response = {"meta": {"code": 400},
                                 "message": "Invitation delivery failed. " + message};
                    return res.send(response);
                } else {
                    var response = {"meta": {"code": 200},
                                 "message": "Invite delivered to :" + conferenceAttendees.toString()};    
                    return res.send(response);
                }
            });
        } else {
            var err = {message: "Could not invite, did you POST the conferenceCode and array of invitees?"};
            return res.send(err);
        }
    } else {
        var err = {message: "This API is POST only, please POST your invitee data"};
        return res.send(err);
    }
};

/*
API Call: "/2013-04-23/conference/join" to join a conference
[Digits] conference code of conference to join
*/
exports.join = function(req, res) {
    if(req.query.Digits) {
        var conferenceCode = req.query.Digits;
        var fromPhoneNumber = req.query.From;

        Conference.findOne({'conferenceCode': conferenceCode}, function(err, conference) {
            if(!err && conference) {

                // Change participant designated by "fromPhoneNumber" status to 'active'
                // If participant doesn't exist, add new participant
                Participant.findOne({'conferenceCode': conferenceCode, 'phone': fromPhoneNumber}, function(err_p, participant) {
                    if(!err_p && participant) {
                        participant.status = 'active';
                        participant.save();
                    } else {
                        var participantObject = {phone: fromPhoneNumber, conferenceCode: conferenceCode, status: "active"};
                        participant = new Participant(participantObject);
                        participant.save();
                    }
                });


                // Mixpanel
                mixpanel.track("conference join", {
                    conferenceCode: conferenceCode,
                    phoneNumber: fromPhoneNumber
                });

                var conferenceName = conference.id;
                return res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Say voice='woman' language='en-gb'>You will now be entered into the conference.</Say><Dial><Conference>" + conferenceName + "</Conference></Dial></Response>");
            } else {
                // Prompt for conference code again
                return res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Say voice='woman' language='en-gb'>Sorry, there has been an error.</Say></Response>");
            }
        });
    } else {
        return res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Say voice='woman' language='en-gb'>Sorry, there has been an error.</Say></Response>");
    }
};


/*
API Call: "/2013-04-23/conference/number" to get a Twilio number
*/
exports.number = function(req, res) {
    var response = {number: TWILIO_NUMBER};
    return res.send(response);
};


/*
API Call: "/2013-04-23/conference/get/:conferenceCode" to get a conference object
[conferenceCode] is the conference code of the conference object to get
*/
exports.get = function(req, res) {
    var conferenceCode = req.params.conferenceCode;

    getConferenceObject(conferenceCode, function(result) {
        res.send(JSON.stringify(result));
    });
};

/*
API Call: "/2013-04-23/conference/get/:conferenceCode/attendees" to get a conference object
[conferenceCode] is the conference code of the conference object to get
*/
exports.attendees = function(req, res) {
    var conferenceCode = req.params.conferenceCode;

    Participant.find({'conferenceCode': conferenceCode}, function(err_p, participants) {
        if(!err_p && participants) {
            return res.send(JSON.stringify(participants));
        } else {
            return res.send({message: "Couldn't find the participants, some error occurred."});
        }
    });
}


/* 
API Call: "/2013-04-23/conference/twilio" for Twilio to access. If [conferenceCode] is passed, that will be the code. Otherwise grab code from phone input.
[conferenceCode] conference code of conference to access
 */
exports.twilio = function(req, res) {
    var conferenceCode = req.query.conferenceCode;

    // Generate TWiML to join conference
    if(conferenceCode) {
        return res.redirect("/" + API_VERSION + "/conference/join?Digits=" + conferenceCode);
    } else {
        if(req.query.From) {
            return res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Gather method='get' action='/" + API_VERSION + "/conference/join?From=" + req.query.From + "' timeout='20' finishOnKey='#'><Say voice='woman' language='en-gb'>Welcome to Call In. Please enter the conference code, followed by the pound key.</Say></Gather></Response>");
        } else {
            return res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Gather method='get' action='/" + API_VERSION + "/conference/join' timeout='20' finishOnKey='#'><Say voice='woman' language='en-gb'>Welcome to Call In. Please enter the conference code, followed by the pound key.</Say></Gather></Response>");
        }
    }
};


/* ----- Helper Functions ----- */
/* Add participants mongoDB, participantsObject includes conferenceCode and array of participants */
function addParticipants(participantsObject) {
    console.log(participantsObject);
    if(participantsObject) {
        var conferenceCode = participantsObject.conferenceCode;

        // Make sure conference exists
        Conference.findOne({'conferenceCode': conferenceCode}, function(err, conference) {
            if(!err && conference) {

                // Add participants to conference
                if(participantsObject.participants) {
                    for(var i = 0; i < participantsObject.participants.length; i++) {
                        p = participantsObject.participants[i];
                        console.log(p);
                        var participantObject = {
                            phone: p.phone,
                            email: p.email,
                            displayName: p.displayName,
                            conferenceCode: conferenceCode,
                            status: "inactive"
                        };

                        var participant = new Participant(participantObject);
                        participant.save();
                    }
                }
                
            } else {
                console.log(conference);
            }
        });
    }
};

function getConferenceObject(conferenceCode, callback) {
    Conference.findOne({'conferenceCode': conferenceCode}, function(err, conference) {
        if(!err && conference) {
            conference_result = JSON.parse(JSON.stringify(conference));
            // Find attendees to the conference
            Participant.find({'conferenceCode': conferenceCode}, function(err_p, participants) {
                if(!err_p && participants) {
                    conference_result.attendees = JSON.parse(JSON.stringify(participants));
                }
                
                callback(conference_result);
            });
        } else {
            var response = {message: "Couldn't find the specified conference."};
            callback(response);
        }
    });
}


/* Generate a unique code for conference */
function generateConferenceCode() {
    Conference.find(function(err, conferences) {
        if (err) {
            db.close();
            return hashids.encrypt(0);
        } else {
            var numConferences = conferences.length;
            db.close();
            return hashids.encrypt(numConferences);
        }
    });
};

/*todo: helper function fwrite additional logic here to format the readable string according */
function stringifyTimeObject(timeObject) {
    if(timeObject) {
        var date = new Date(timeObject.dateTime);
        return date.toString();
    } else {
        return "";
    }    
 }



 // take in phone number, generate 4 digit code. respond with code.
 // text it as well

