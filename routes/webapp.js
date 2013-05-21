/* ----- API call ----- */
 /* API call: bossmobilewunderkinds.herokuapp.com/webapp/?conferenceCode= 
 [conferenceCode] active conference code for an event 
 */

var twilio = require('twilio');
var capability = new twilio.Capability('ACbbb2f0208bf81489c3c497c7ca3cad88', '6aa8522ddf93b0ce14791e864118f94b');
capability.allowClientOutgoing('AP361c96431ce7485f8b27da32da715b7d');

exports.index = function(req, res){
    var token = capability.generate();
    res.render("webapp.hbs", {
        "conferenceCode": req.query['conferenceCode'],
        "token": token
    });
};
