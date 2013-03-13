//Libraries
var util = require('util');
var url  = require('url');
var express  = require('express');
var parse = require('node-parse-api').Parse;
var Imap = require('imap');
var inspect = require('util').inspect;

//Constants
var PARSE_APP_ID = "ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj";
var PARSE_MASTER_KEY = "AAOYtk81wI3iRJiXxgRfwblt1EUHVBlyvpS9m3QO";
var parseApp = new parse(PARSE_APP_ID, PARSE_MASTER_KEY);
var HARD_CODED_GOOGLE_AUTH_TOKEN = "ya29.AHES6ZQb8hnA8RdLag_JzKkMFNZfhECQ23QlAMHlPOJoPcsiSXcg"
var HARD_CODED_TEST_ATTENDEE = "notifications@github.com";
var HARD_CODED_TEST_EMAIL = "wes.k.leung@gmail.com";

// API NEEDS:
// Gracefully recover from having nothing to fetch
// Get email address of user
// Get email address of event correspondant
// Get most recent access token

// user=wes.k.leung@gmail.comauth=Bearer ya29.AHES6ZTIQmrRzQ3R3ksCGQAlXtfD9W7qRgm_9jGVGEps2FFAtdvL
//Takes email address and access_token to generate IMAP OAuth2 base64 string
function generateOAuth2String(username, access_token) {
  var authData = [
        "user=" + (username || ""),
        "auth=Bearer " + access_token,
        "",
        ""];
  var auth =  new Buffer(authData.join("\x01"), "utf-8").toString("base64");
  console.log("Encoded auth message: " + auth);
  var decode = new Buffer(auth, 'base64').toString('ascii');
  console.log("Original decoded auth message " + decode);
  return auth;
}

exports.mail = function(req, res) {
  parseApp.find('', req.params.userId, function (err, response) {
    var access_token;
    var user_email;

    if(response && response.google_access_token) {
      console.log("Using Parse auth token.");
      access_token = response.google_access_token;
      user_email = response.email;
    } else if(req.session.access_token) {
      console.log("Using Express session auth token.");
      access_token = req.session.access_token;
      user_email = HARD_CODED_TEST_EMAIL;
    } else {
      console.log("Using hard-coded auth token.");
      access_token = HARD_CODED_GOOGLE_AUTH_TOKEN;
      user_email = HARD_CODED_TEST_EMAIL;
    }

    var event_attendee_email_address = HARD_CODED_TEST_ATTENDEE;      
    var imap = new Imap({
          xoauth2: generateOAuth2String(user_email, access_token),
          host: 'imap.gmail.com', 
          port: 993, 
          secure: true
        });

    function show(obj) {
      return inspect(obj, false, Infinity);
    }

    function die(err) {
      console.log('Error: ' + err);
      return;
    }

    function openInbox(cb) {
      imap.connect(function(err) {
        if (err) die(err);
        imap.openBox('INBOX', true, cb);
      });
    }

    openInbox(function(err, mailbox) {
      if (err) die(err);
      var options = [ 'UNSEEN', ['FROM', event_attendee_email_address]];
      imap.search(options, function(err, results) {
        var response = [];

        if (err) die(err);
        imap.fetch(results,
          { headers: ['from', 'to', 'subject', 'date'],
            cb: function(fetch) {
 
              fetch.on('message', function(msg) {
                msg.on('headers', function(hdrs) {
                  response.push(show(hdrs));
                });
              });
            }
          }, function(err) {
            if (err) throw err;
            console.log("Number of emails fetched: " + response.length);
            console.log('Done fetching all messages!');
            imap.logout();
            return res.send({"emails": response});
          });
      });
    });
  });
};
