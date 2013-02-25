var https = require('https');
var qs = require('querystring');

var api = 'ACbbb2f0208bf81489c3c497c7ca3cad88';
var auth = '6aa8522ddf93b0ce14791e864118f94b';

var postdata = qs.stringify({
    'From' : '+16503535255',
    'To' : '+15103647987',
    'Url' : 'http://safe-mountain-5325.herokuapp.com/call'
});

var options = {
    host: 'api.twilio.com',
    path: '/2010-04-01/Accounts/ACbbb2f0208bf81489c3c497c7ca3cad88/Calls.xml',
    port: 443,
    method: 'POST',
    headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
        'Content-Length' : postdata.length
    },
    auth: api + ':' + auth
};

var request = https.request(options, function(res){
    res.setEncoding('utf8');
    res.on('data', function(chunk){
        console.log('Response: ' + chunk);
    })
})

request.write(postdata);
request.end();