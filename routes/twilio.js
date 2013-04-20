var https = require('https');

var ACCOUNT_SID = 'ACbbb2f0208bf81489c3c497c7ca3cad88';
var AUTH_TOKEN = '6aa8522ddf93b0ce14791e864118f94b';
var TWIML_APP_ID = 'AP361c96431ce7485f8b27da32da715b7d';

var twilio = require('twilio');
var capability = new twilio.Capability(ACCOUNT_SID, AUTH_TOKEN);

exports.capability = function(req, res) {
    var clientId = req.params.clientId;
    if(!clientId) clientId = 'test';

    capability.allowClientIncoming(clientId);
    capability.allowClientOutgoing(TWIML_APP_ID);
    return res.send(capability.generate());
}

exports.voice = function(req, res) {
    return res.send("Nothing here yet");
};