//require the Twilio module and create a REST client
var client = require('../lib')('ACbbb2f0208bf81489c3c497c7ca3cad88', '6aa8522ddf93b0ce14791e864118f94b');

//Send an SMS text message
client.sendSms({

    to:'+16507999828', // Any number Twilio can deliver to
    from: '+16503535255', // A number you bought from Twilio and can use for outbound communication
    body: 'word to your mother.' // body of the SMS message

}, function(err, responseData) { //this function is executed when a response is received from Twilio

    if (!err) { // "err" is an error received during the request, if any

        // "responseData" is a JavaScript object containing data received from Twilio.
        // A sample response from sending an SMS message is here (click "JSON" to see how the data appears in JavaScript):
        // http://www.twilio.com/docs/api/rest/sending-sms#example-1

        console.log(responseData.from); // outputs "+14506667788"
        console.log(responseData.body); // outputs "word to your mother."

    }
});

/*//Place a phone call, and respond with TwiML instructions from the given URL
client.makeCall({

    to:'+14086468223', // Any number Twilio can call
    from: '+16503535255', // A number you bought from Twilio and can use for outbound communication
    url: 'http://www.example.com/twiml.php' // A URL that produces an XML document (TwiML) which contains instructions for the call

}, function(err, responseData) {

    //executed when the call has been initiated.
    console.log(responseData.from); // outputs "+14506667788"

}); */