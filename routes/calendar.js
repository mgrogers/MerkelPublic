// Libraries
var util = require('util');
var url  = require('url');
var Q = require('q');
var express  = require('express');
var parse = require('node-parse-api').Parse;
var GoogleCalendarParse = require('google-calendar-parse').GoogleCalendarParse;
var time = require('time');
var GoogleParseAuth = require("google-parse-auth").GoogleParseAuth;

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
var googleParseAuth = new GoogleParseAuth(parseApp, GOOGLE_CONSUMER_KEY, GOOGLE_CONSUMER_SECRET);

/* ----------- API FUNCTIONS -----------*/
/*
 API Call: /api/events/:userId/day/:date - Grabs [userId]'s events happening between beginning of [date] and end of [date], in the timezone supplied by [tz]
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
 [tz] should be in URL encoded timezone format, e.g. "Europe%2FCopenhagen" or "America%2FLos_Angeles"
  */
exports.eventsDay = function(req, res) {
  return getCalendarEvents(req, res, "day");
};

/*
 API Call: /api/events/:userId/week/:date - Grabs [userId]'s events happening between beginning of [date] and end of [date] +7 days, in the timezone supplied by [tz]
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
 [tz] should be in URL encoded timezone format, e.g. "Europe%2FCopenhagen" or "America%2FLos_Angeles"
  */
exports.eventsWeek = function(req, res) {
  return getCalendarEvents(req, res, "week");
};

/*
 API Call: /api/events/:userId/week/:date - Grabs [userId]'s events happening between beginning of [date] and end of [date] +30 days, in the timezone supplied by [tz]
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
 [tz] should be in URL encoded timezone format, e.g. "Europe%2FCopenhagen" or "America%2FLos_Angeles"
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
    var google_calendar = new GoogleCalendarParse(parseApp, GOOGLE_CONSUMER_KEY, GOOGLE_CONSUMER_SECRET, appUrl + '/authentication');

    var assembled_calendars = [];
    var calendarCount = 0;

    var user_id = req.params.userId;

    var requestedDateRaw;
    var requestedDate = new time.Date();
    var timezone;

    // Default to beginning of current date if none provided
    if(req.params.date) {
      var requestedDateArray = req.params.date.split('-');
      requestedDateRaw = new time.Date(parseInt(requestedDateArray[0]), parseInt(requestedDateArray[1]) - 1, parseInt(requestedDateArray[2]));
    } else {
      requestedDateRaw = new time.Date();
    }

    // Default to UTC if timezone not provided or improperly formatted
    if(req.params.date && req.params.tz) {
      timezone = decodeURIComponent(req.params.tz);
    } else {
      timezone = 'UTC';
    }

    // Change requested date to correct date request based on provided timezone
    requestedDate = new time.Date(requestedDateRaw.getFullYear(), requestedDateRaw.getMonth(), requestedDateRaw.getDate(), timezone);

    console.log("Received a request for the events for userID: '" + req.params.userId + "' on date: '");

    return google_calendar.listCalendarList(user_id, function(err, data) {
        if(err) return res.send(500,err);

        var calendars = data.items;
        var queue = [];
        console.log("Got calendars:",calendars);

        calendars.forEach(function(calendar) {
            console.log("Pushing onto queue:", calendar.summary);
            queue.push(fetchEvents(google_calendar, user_id, calendar, requestedDate, type));
        });

        return Q.allResolved(queue).then(function(promises) {
            eventsList = []
            promises.forEach(function(promise) {
                if(promise.isFulfilled()) {
                    var value = promise.valueOf();
                    eventsList.push(value);
                }
            });
            console.log("Events:", eventsList);
            return res.send(200, eventsList);
        });
    });
}

function fetchEvents(google_calendar, user_id, calendar, requestedDate, type) {
    var deferred = Q.defer();
    console.log("fetching events for", calendar.summary);

    // Skip unnecessary calendars
    if(contains(CALENDARS_TO_SKIP, calendar.id)){
        console.log("Rejecting", calendar.summary);
        deferred.reject(calendar);
    } else {

        var option = {};
        option.key = GOOGLE_CONSUMER_KEY;
        
        option.timeZone = "UTC";
        option.timeMin = requestedDate.toISOString();

        // Set end time to search based on type of request - day, week, month
        var searchTimeEnd = requestedDate.getTime();
        if(type == "day") searchTimeEnd += MILLISEC_IN_DAY;
        else if (type == "week") searchTimeEnd += MILLISEC_IN_DAY * 7;
        else if (type == "month") searchTimeEnd += MILLISEC_IN_DAY * 30;
        else searchTimeEnd += MILLISEC_IN_DAY;
        option.timeMax = new time.Date(searchTimeEnd).toISOString();
        // Asynchronously access events
        console.log("Trying to list events");
        google_calendar.listEvent(user_id, calendar.id, option, function(err, events) {
            console.log("listing event");
            // Error
            if(err || !events) {
                console.log(err);
                deferred.reject(err);
            } else if(!events.items) {
                console.log("Resolving - no events");
                var tempCalendar = {};
                tempCalendar.name = calendar.summary;
                tempCalendar.events = [];
                deferred.resolve(tempCalendar);
            } else {
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
                console.log("Resolving:", tempCalendar);
                deferred.resolve(tempCalendar);
            }
        });
    }
    // Return JSON object after all calendars are accessed
    return deferred.promise;
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