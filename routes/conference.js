var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var mongoose_options = {'user':'bmw', 'pass':'stanfordcs210', 'auto_reconnect': true}
var db = mongoose.createConnection('ds033877.mongolab.com:33877/merkel', mongoose_options);
db.on('error', console.error.bind(console, 'connection error:'));

var TWILIO_NUMBER = '+16503535255'

var conference_schema = new Schema({
    name: String,
    dial: String
});

var Conference = db.model('conferences', conference_schema);

exports.create = function(req, res) {
    var conference = new Conference({name: randomConferenceName(),
                                    dial: TWILIO_NUMBER + ",,," + randomCode() + "#"});

    conference.save();
    res.send(conference);
}

exports.read = function(req, res) {
    var name = req.params.name;

    Conference.findOne({'name': name}, 'name dial', function(err, conference) {
        if(err) {
            res.send(err.message);
        } else {
            res.send(conference);
        }
    });
}

exports.form = function(req, res) {
    res.send("<html><body><form method='post' action='/api/conference/'><input type='submit' value='create' /></form></body></html>");
}

exports.list = function(req, res) {
    Conference.find(function(err, conferences) {
        if (err) {
            res.send(err.message);
        } else {
            res.send(conferences);
        }
    });
}

exports.join = function(req, res) {
    if (req.query['Digits']) {
        var digits = req.query['Digits'];
        Conference.findOne({'dial': TWILIO_NUMBER + ",,," + digits + "#"}, 'name dial', function(err, conference) {
            if(err) {
                res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Say>Oops, there has been an error.</Say></Response>");
            } else {
                res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Dial><Conference>"+ conference.name + "</Conference></Dial></Response>");
            }
        });
    } else {
        res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Say>Oops, there has been an error.</Say></Response>");
    }
}

exports.twilio = function(req, res) {
    res.send("<?xml version='1.0' encoding='UTF-8'?><Response><Gather method='post' action='/api/conference/join' timeout='20' finishOnKey='#'><Say>Code</Say></Gather></Response>");
}

function randomConferenceName() {
    var chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var length = 10;
    return randomString(length, chars);
}

function randomCode() {
    var chars = '0123456789';
    var length = 10;
    return randomString(length, chars);
}

function randomString(length, chars) {
    var result = '';
    for (var i = length; i > 0; --i) result += chars[Math.round(Math.random() * (chars.length - 1))];
    return result;
}
