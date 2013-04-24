var ACCOUNT_SID = 'ACbbb2f0208bf81489c3c497c7ca3cad88';
var AUTH_TOKEN = '6aa8522ddf93b0ce14791e864118f94b';
var TWIML_APP_ID = 'AP361c96431ce7485f8b27da32da715b7d';
var TWILIO_NUMBER = '+16503535255'

var twilio = require('twilio');

var MINIMUM_CONFERENCE_CODE_LENGTH = 10;

var Hashids = require("hashids");
var hashids = new Hashids("dat salt, yo", MINIMUM_CONFERENCE_CODE_LENGTH, "0123456789");

var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var mongoose_options = {'auto_reconnect':true};
mongoose.createConnection(process.env.MONGOLAB_URI || 'mongodb://heroku_app12018585:8la71don2tthmm2ceaahdmhog2@ds045507.mongolab.com:45507/heroku_app12018585', mongoose_options);
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));

var conferenceSchema = new Schema({
    conferenceCode: {type: String, default: ""},
    eventId: {type: String, default: ""},
    creatorId: {type: String, default: ""},
    status: {type: String, default: "inactive"} // 'active' or 'inactive'
});

var participantSchema = new Schema({
    phoneNumber: {type: String, default: ""},
    email: {type: String, default: ""},
    muted: {type: Boolean, default: false},
    conferenceCode: {type: String, default: ""},
    status: {type: String, default: "absent"} // 'present' or 'absent'
});

var Conference = db.model('conference', conferenceSchema);
var Participant = db.model('participant', participantSchema);


/* ----- API Calls ----- */
/* API call for "/api/conference/capability" to generate a Twilio capability token */
exports.capability = function(req, res) {
    var clientId = req.query.clientId;
    clientId = clientId || 'test';

    var timeout = req.query.timeout;
    timeout = timeout || 600;
    
    var capability = new twilio.Capability(ACCOUNT_SID, AUTH_TOKEN);
    capability.allowClientIncoming(clientId);
    capability.allowClientOutgoing(TWIML_APP_ID);

    var response = {};
    response.capabilityToken = capability.generate(timeout);

    return res.send(response);
};


/*
API Call: "/api/conference/create" to generate a new conference 
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

        var conferenceObject = { conferenceCode: hash, status: "active" }
        var conference = new Conference(conferenceObject);
        conference.save();
        return res.send(conferenceObject);
    });
};


/*
API Call: "/api/conference/remove" to remove a conference specified by [conferenceCode]. This should change the status of the conference to 'inactive' and remove the participants.
[conferenceCode] conference code of conference to remove
*/
exports.remove = function(req, res) {
    // find conference
    // label conference 'inactive'
    // declare all participants 'absent'
};


/* 
API Call: "/api/conference/twilio" for Twilio to access. If [conferenceCode] is passed, that will be the code. Otherwise grab code from phone input.
[conferenceCode] conference code of conference to access
 */
exports.twilio = function(req, res) {

    var conferenceCode = req.query.conferenceCode;
    // Generate TWiML to join conference
    if(conferenceCode) {
        return res.redirect("/api/conference/join?Digits=" + conferenceCode);
    } else {
        return res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Gather method='get' action='/api/conference/join' timeout='20' finishOnKey='#'><Say>Please enter the conference code.</Say></Gather></Response>");
    }
};


/*
API Call: "/api/conference/join" to join a conference
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
        res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Say>Sorry, there has been an error.</Say></Response>");
    }
};


/* 
API Call: "/api/conference/addParticipant" to add a participant with number [phoneNumber] to the specified [conferenceCode]
[phoneNumber] required, number of participant to add
[email] email of participant to add
[muted] whether participant to add should join muted
[conferenceCode] required, conference to add participant to
*/
exports.addParticipant = function(req, res) {
    if(req.query['participantNumber'] && req.query['conferenceCode']) {
        var conferenceCode = req.query['conferenceCode'];

        Conference.findOne({'conferenceCode': conferenceCode}, function(err, conference) {
            if(!err && conference) {
                // Add participant to conference, specified by phoneNumber, email, status is 'absent' until confirmed in call
            } else {
                // Didn't find conference
                var err = {message: "Couldn't find conference specified by conferenceCode"};
                res.send(500, err);
            }
        });

    } else {
        var err = {message: "Please supply both participantNumber and conferenceCode"};
        res.send(500, err);
    }
};

/* ----- Helper Functions ----- */
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