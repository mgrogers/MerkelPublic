// Libraries
var util = require('util');
var url  = require('url');
var express  = require('express');
var parse = require('node-parse-api').Parse;
var GoogleCalendar = require('google-calendar');
var time = require('time');

// Constants
var CALENDARS_TO_SKIP = ['en.usa#holiday@group.v.calendar.google.com'];
var GOOGLE_CONSUMER_KEY = "992955494422-u92pvkijf7ll2vmd7qjf2hali813q7pv.apps.googleusercontent.com";
var GOOGLE_CONSUMER_SECRET = "rLkby14J_c-YkVA96KCqeajC";
var PARSE_APP_ID = "ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj";
var PARSE_MASTER_KEY = "AAOYtk81wI3iRJiXxgRfwblt1EUHVBlyvpS9m3QO";
var MILLISEC_IN_DAY = 86400000;
var MILLISEC_IN_HOUR = 3600000;
var HARD_CODED_GOOGLE_AUTH_TOKEN = "ya29.AHES6ZRYphizlByPNZxKxwes30IISt81sJd6QrjxAzhMEt0";

// Initializing variables
var parseApp = new parse(PARSE_APP_ID, PARSE_MASTER_KEY);


/* ----------- API FUNCTIONS -----------*/
/*
 API Call: /api/events/:userId/day/:date - Grabs [userId]'s events happening on [date]
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
 [tz] should be in the format "[+/-]HH", e.g. +08 for PST, if empty defaults to +00 UTC
  */
exports.eventsDay = function(req, res) {
  return getCalendarEvents(req, res, "day");
};

/*
 API Call: /api/events/:userId/week/:date - Grabs [userId]'s events happening on [date] +7 days
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd-hh", if empty defaults to current day
 [tz] should be in the format "[+/-]HH", e.g. +08 for PST, if empty defaults to +00 UTC
  */
exports.eventsWeek = function(req, res) {
  return getCalendarEvents(req, res, "week");
};

/*
 API Call: /api/events/:userId/week/:date - Grabs [userId]'s events happening on [date] +30 days
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd-hh", if empty defaults to current day
 [tz] should be in the format "[+/-]HH", e.g. +08 for PST, if empty defaults to +00 UTC
  */
exports.eventsMonth = function(req, res) {
  return getCalendarEvents(req, res, "month");
}


/* Testing function, authenticates with Google, stores auth token in express session */
exports.authentication = function(req, res) {
  var appUrl = req.protocol + "://" + req.get('host');
  var google_calendar = new GoogleCalendar.GoogleCalendar(GOOGLE_CONSUMER_KEY, GOOGLE_CONSUMER_SECRET, appUrl + '/authentication');

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
  var appUrl = req.protocol + "://" + req.get('host');
  var google_calendar = new GoogleCalendar.GoogleCalendar(GOOGLE_CONSUMER_KEY, GOOGLE_CONSUMER_SECRET, appUrl + '/authentication');
  var calendars = [];
  var calendarCount = 0;

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

      // Need to convert date manually since new Date() internationalizes
      var requestedDateArray = req.params.date.split('-');
      requestedDate = new time.Date(parseInt(requestedDateArray[0]), parseInt(requestedDateArray[1]) - 1, parseInt(requestedDateArray[2]));
    } else {
      var today = new time.Date();
      requestedDate = new Date(today.getFullYear(), today.getMonth(), today.getDate());
    }

    if(req.params.date && req.params.tz) {
      requestedDate.setTimezone(decodeURIComponent(req.params.tz));
      // if TZ is improperly formatted or not provided, use UTC
    } else {
      requestedDate.setTimezone('UTC');
    }

    console.log("Received a request for the events for userID: '" + req.params.userId + "' on date: '" + requestedDate + "' with access token: '" + access_token + "'");

    google_calendar.listCalendarList(access_token, function(err, data) {
      if(err) return res.send(500,err);

      calendarCount = data.items.length;

      data.items.forEach(function(calendar) {

        // Skip unnecessary calendars
        if(contains(CALENDARS_TO_SKIP, calendar.id)) return returnResponse();

        var option = {};
        option.access_token = access_token;
        option.key = GOOGLE_CONSUMER_KEY;
        option.timeZone = "UTC";
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

          // Error
          if(err || !events) {
            console.log(err);
            return res.send(500,err);
          }
          // No matching items in this calendar
          if(!events.items) {
            return returnResponse();
          }

          var tempCalendar = {};
          tempCalendar.name = calendar.summary;
          tempCalendar.events = [];

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
      });
    });
  });

  function returnResponse() {
    if(calendarCount != 0) {
      calendarCount--;
    }

    if(calendarCount == 0) {
      return res.send(calendars);
    } else {
      return;
    }
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

/* Convert date to UTC a */
function convertDateToUTC(date) { 
  return new Date(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds()); 
}