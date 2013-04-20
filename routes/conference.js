var ACCOUNT_SID = 'ACbbb2f0208bf81489c3c497c7ca3cad88';
var AUTH_TOKEN = '6aa8522ddf93b0ce14791e864118f94b';
var TWIML_APP_ID = 'AP361c96431ce7485f8b27da32da715b7d';
var TWILIO_NUMBER = '+16503535255'

var twilio = require('twilio');
var capability = new twilio.Capability(ACCOUNT_SID, AUTH_TOKEN);

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
    eventId: {type: String, default: ""},
    creatorId: {type: String, default: ""},
    code: {type: String, default: ""}
});

var Conference = db.model('conference', conferenceSchema);


/* API call for "/api/conference/capability" to generate a Twilio capability token */
exports.capability = function(req, res) {
    var clientId = req.query.clientId;
    clientId = clientId || 'test';

    var timeout = req.query.timeout;
    timeout = timeout || 600;

    capability.allowClientIncoming(clientId);
    capability.allowClientOutgoing(TWIML_APP_ID);

    var response = {};
    response.capabilityToken = capability.generate(expires=timeout);

    return res.send(response);
}

/* ----- API Calls ----- */
/* API call for "/api/conference/createConference" to generate a new conference */
exports.createConference = function(req, res) {
    Conference.find(function(err, conferences) {
        var hash = 0;
        if (!err) {
            var numConferences = conferences.length;
            hash = hashids.encrypt(numConferences);
        } else {
            hash = hashids.encrypt(0);
        }

        var conferenceObject = { code: hash }
        var conference = new Conference(conferenceObject);
        conference.save();
        return res.send(conferenceObject);
    });
}


/* 
API Call: "/api/conference/twilio" for Twilio to access
[conferenceCode] is the code for the conference to join
 */
exports.twilio = function(req, res) {

    var conferenceCode = req.query.conferenceCode;
    // Generate TWiML to join conference
    if(conferenceCode) {
        var conferenceName = "";
        return res.send("<Response><Dial><Conference>" + conferenceName + "</Conference></Dial></Response><?xml version='1.0' encoding='UTF-8'?>");
    } else {
        return res.send("Something went wrong! Did you pass in the conference code?");
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
}