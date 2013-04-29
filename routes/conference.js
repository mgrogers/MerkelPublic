var ACCOUNT_SID = 'ACbbb2f0208bf81489c3c497c7ca3cad88';
var AUTH_TOKEN = '6aa8522ddf93b0ce14791e864118f94b';
var TWIML_APP_ID = 'AP361c96431ce7485f8b27da32da715b7d';
var TWILIO_NUMBER = '+16503535255'
var MINIMUM_CONFERENCE_CODE_LENGTH = 10;
var API_VERSION = '2013-04-23'

var twilio = require('twilio');
var Hashids = require("hashids");
var hashids = new Hashids("dat salt, yo", MINIMUM_CONFERENCE_CODE_LENGTH, "0123456789");

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var mongoose_options = {'auto_reconnect':true};
mongoose.connect(process.env.MONGOLAB_URI || 'mongodb://heroku_app12018585:8la71don2tthmm2ceaahdmhog2@ds045507.mongolab.com:45507/heroku_app12018585', mongoose_options);
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));

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

        if(postBody) {
            conferenceObject.conferenceCode = hash;
            conferenceObject.status = "inactive";
            conferenceObject.title = postBody.title || "";
            conferenceObject.description = postBody.description || "";
            if(postBody.start) conferenceObject.start = postBody.start.datetime;
            else conferenceObject.start = "";
            if(postBody.start) conferenceObject.timeZone = postBody.start.timeZone;
            else conferenceObject.timeZone = "";
            if(postBody.inviteMethod) conferenceObject.sms = postBody.inviteMethod.sms;
            else conferenceObject.sms = false;
            if(postBody.inviteMethod) conferenceObject.email = postBody.inviteMethod.email;
            else conferenceObject.email = false;
        } else {
            conferenceObject = {conferenceCode: hash};
        }
        
        var conference = new Conference(conferenceObject);
        conference.save();

        var participantsObject = {conferenceCode: conferenceObject.conferenceCode, participants: postBody.attendees}
        addParticipants(participantsObject);
        return res.send(conferenceObject);
    });
};


/*
API Call: "/2013-04-23/conference/invite" to send an invite for a conference to someone, data will be in POST data
[Invitee POST data] example JSON POST can be found in test/fixtures/conference_invite.json
*/
exports.invite = function(req, res) {
    if(req.method == 'POST') {
        var postBody = req.body;

        if(postBody.conferenceCode && postBody.attendees) {
            // Add participants to db
            var participantsObject = {conferenceCode: postBody.conferenceCode, participants: postBody.attendees}
            addParticipants(participantsObject);

            // Send invite to participants
            // invite blah blah

            return res.send(participantsObject);
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
    if(req.query['Digits']) {
        var conferenceCode = req.query['Digits'];

        Conference.findOne({'conferenceCode': conferenceCode}, function(err, conference) {
            if(!err && conference) {
                var conferenceName = conference.id;
                return res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Dial><Conference>" + conferenceName + "</Conference></Dial></Response>");
            } else {
                // Prompt for conference code again
                return res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Say>Sorry, there has been an error.</Say></Response>");
            }
        });
    } else {
        return res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Say>Sorry, there has been an error.</Say></Response>");
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

    Conference.findOne({'conferenceCode': conferenceCode}, function(err, conference) {
        if(!err && conference) {
            return res.send(conference);
        } else {
            var response = {message: "Couldn't find the specified conference."};
            return res.send(response);
        }
    });
};


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
        return res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Gather method='get' action='/" + API_VERSION + "/conference/join' timeout='20' finishOnKey='#'><Say>Please enter the conference code.</Say></Gather></Response>");
    }
};


/* ----- Helper Functions ----- */
/* Add participants mongoDB, participantsObject includes conferenceCode and array of participants */
function addParticipants(participantsObject) {
    if(participantsObject) {
        var conferenceCode = participantsObject.conferenceCode;

        // Make sure conference exists
        Conference.findOne({'conferenceCode': conferenceCode}, function(err, conference) {
            if(!err && conference) {
                // Add participants to conference
                for(var p in participantsObject.participants) {
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
        });
    }
};


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
