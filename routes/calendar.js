// Libraries
var util = require('util');
var url  = require('url');
var express  = require('express');
var parse = require('node-parse-api').Parse;
var GoogleCalendar = require('google-calendar');

// Constants
var CALENDARS_TO_SKIP = ['en.usa#holiday@group.v.calendar.google.com'];
var GOOGLE_CONSUMER_KEY = "992955494422-u92pvkijf7ll2vmd7qjf2hali813q7pv.apps.googleusercontent.com";
var PARSE_APP_ID = "ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj";
var PARSE_MASTER_KEY = "AAOYtk81wI3iRJiXxgRfwblt1EUHVBlyvpS9m3QO";
var MILLISEC_IN_DAY = 86400000;
var HARD_CODED_GOOGLE_AUTH_TOKEN = "ya29.AHES6ZQEHyo6csgLyOtA5RgBOglxKzGIy3BQwB5iNiu29qTg";

// Initializing variables
var google_calendar = new GoogleCalendar.GoogleCalendar(
  "992955494422-u92pvkijf7ll2vmd7qjf2hali813q7pv.apps.googleusercontent.com",
  "rLkby14J_c-YkVA96KCqeajC",
  'http://localhost:3000/authentication');
var parseApp = new parse(PARSE_APP_ID, PARSE_MASTER_KEY);


/* ----------- API FUNCTIONS -----------*/
/*
 API Call: /api/events/:userId/day/:date - Grabs [userId]'s events happening on [date]
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
  */
exports.eventsDay = function(req, res) {
  return getCalendarEvents(req, res, "day");
};

/*
 API Call: /api/events/:userId/week/:date - Grabs [userId]'s events happening on [date] +7 days
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
  */
exports.eventsWeek = function(req, res) {
  return getCalendarEvents(req, res, "week");
};

/*
 API Call: /api/events/:userId/week/:date - Grabs [userId]'s events happening on [date] +30 days
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
  */
exports.eventsMonth = function(req, res) {
  return getCalendarEvents(req, res, "month");
}


/* Testing function, authenticates with Google, stores auth token in express session */
exports.authentication = function(req, res) {
  if(!req.query.code){

    //Redirect the user to Authentication From
    google_calendar.getGoogleAuthorizeTokenURL(function(err, redirecUrl) {
      if(err) return res.send(500,err);
      return res.redirect(redirecUrl);
    });
    
  }else{
    //Get access_token from the code
    google_calendar.getGoogleAccessToken(req.query, function(err, access_token, refresh_token) {

      if(err) return res.send(500,err);
    
      req.session.access_token = access_token;
      req.session.refresh_token = refresh_token;
      return res.send('<html><body><h1>Google Auth Token stored in Express session.</h1><p>Access Token: "' + access_token + '"</p><p>Refresh Token: "' + refresh_token + '"</p></body></html>');
    });
  }
};


/* ----------- HELPER FUNCTIONS -----------*/
/* Get calendar events based on time constraints of 'type' - day, week, or month */
function getCalendarEvents(req, res, type) {
  var calendars = [];
  var waiting = 0;

  parseApp.find('', req.params.userId, function (err, response) {
    var access_token;
    if(response && response.google_access_token) {
      console.log("Using Parse auth token.");
      access_token = response.google_access_token;
    } else if(req.session.access_token) {
      console.log("Using Express session auth token.");
      access_token = req.session.access_token;
    } else {
      console.log("Using hard-coded auth token.");
      access_token = HARD_CODED_GOOGLE_AUTH_TOKEN;
    }

    // Default to beginning of current date if none provided
    var requestedDate = "";
    if(req.params.date) {
      requestedDate = new Date(req.params.date);
    } else {
      var today = new Date();
      requestedDate = new Date(today.getFullYear(), today.getMonth(), today.getDate());
    }

    console.log("This is a request for the events for userID: '" + req.params.userId +
    "' on date: '" + requestedDate + "' with access token: '" + access_token + "'");

    google_calendar.listCalendarList(access_token, function(err, data) {
      if(err) return res.send(500,err);

      data.items.forEach(function(calendar) {

        // Skip unnecessary calendars
        if(contains(CALENDARS_TO_SKIP, calendar.id)) return returnResponse();

        waiting++;

        console.log("Looping to calendar: " + calendar.summary + ", " + calendar.id);
        var tempCalendar = {};
        tempCalendar.name = "";
        tempCalendar.events = [];

        if(calendar) {
          tempCalendar.name = calendar.summary;

          var option = {};
          option.access_token = access_token;
          option.key = GOOGLE_CONSUMER_KEY;
          option.timeMin = requestedDate.toISOString();

          // Set end time to search based on type of request - day, week, month
          var searchTimeEnd = requestedDate.getTime();
          if(type == "day") searchTimeEnd += MILLISEC_IN_DAY;
          else if (type == "week") searchTimeEnd += MILLISEC_IN_DAY * 7;
          else if (type == "month") searchTimeEnd += MILLISEC_IN_DAY * 30;
          else searchTimeEnd += MILLISEC_IN_DAY;

          option.timeMax = new Date(searchTimeEnd).toISOString();

          // Asynchronously access events
          google_calendar.listEvent(access_token, calendar.id, option, function(err, events) {
            if(!events.items) {
              events = JSON.parse(events);
            }

            if(err || !events || !events.items) {
              console.log(err);
              return res.send(500,err);
              // return returnResponse();
            }

            // Populate relevant fields for events
            events.items.forEach(function(event) {

              // Generate clean JSON calendar object
              if(event.id && event.summary) {
                var calEvent = {};
                calEvent.id = event.id;
                calEvent.name = event.summary;
                if(event.description) calEvent.description = event.description;
                if(event.location) calEvent.location = event.location;
                if(event.start) calEvent.start = event.start;
                if(event.end) calEvent.end = event.end;
                if(event.creator) calEvent.creator = event.creator;
                if(event.attendees) calEvent.attendees = event.attendees;
                if(event.created) calEvent.created = event.created;
                if(event.updated) calEvent.updated = event.updated;

                // Add event to calendar object
                tempCalendar.events.push(calEvent);
              }
            });

            calendars.push(tempCalendar);

            // Return JSON object after all calendars are accessed
            return returnResponse();
          });
        }

      });
    });
  });

  function returnResponse() {
    if(waiting != 0) {
      waiting--;
      return;
    }

    return res.send(calendars);
  }
}

/* Check if object contains a */
function contains(a, obj) {
    var i = a.length;
    while (i--) {
       if (a[i] == obj) {
           return true;
       }
    }
    return false;
}