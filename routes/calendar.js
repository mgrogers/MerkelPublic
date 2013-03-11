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

// Initializing variables
var google_calendar = new GoogleCalendar.GoogleCalendar(
  "992955494422-u92pvkijf7ll2vmd7qjf2hali813q7pv.apps.googleusercontent.com",
  "rLkby14J_c-YkVA96KCqeajC",
  'http://localhost:3000/authentication');
var parseApp = new parse(PARSE_APP_ID, PARSE_MASTER_KEY);


/*
 API Call: /api/events/:userId/day/:date - Grabs [userId]'s events on [date]
 [userId] should be whatever their Parse userId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
  */
exports.eventsDay = function(req, res) {
  var calendars = [];
  var waiting = 0;

  parseApp.find('', req.params.userId, function (err, response) {
    //var access_token = response.google_access_token;
    var access_token = 'ya29.AHES6ZQEHyo6csgLyOtA5RgBOglxKzGIy3BQwB5iNiu29qTg';

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
          option.timeMax = new Date(requestedDate.getTime() + MILLISEC_IN_DAY).toISOString();

          // Asynchronously access events
          google_calendar.listEvent(access_token, calendar.id, option, function(err, events) {
            if(!events.items) {
              events = JSON.parse(events);
            }

            if(err || !events || !events.items) {
              console.log(err);
              return returnResponse();
            }

            // Populate relevant fields for events
            events.items.forEach(function(event) {

              if(event.id && event.summary) {

              /*
              if(tempCalendar.name == "LFE") {
                console.log("This is the event: " + event.summary + " this is eventStartDate: " + eventStartDate.getTime() + " this is eventEndDate: " +  eventEndDate.getTime() + " this is requestedDate: " + requestedDate.getTime());
              } */

                // Generate clean JSON calendar object
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
            console.log("Adding calendar: " + tempCalendar.name);

            calendars.push(tempCalendar);

            // Return JSON object
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
};

/*
 API Call: /api/events/:userId/week/:date - Grabs [userId]'s events during the week including [date]
 WARNING: not 100% accurate
 [userId] should be whatever their Parse userId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
  */
exports.eventsWeek = function(req, res) {
  console.log("This is a request for the events for userID: " + req.params.userId +
    " during week with day: " + req.params.date);

  // TODO: Grab access token from parse from user with userId: req.params.userId
  var access_token = "ya29.AHES6ZQEHyo6csgLyOtA5RgBOglxKzGIy3BQwB5iNiu29qTg";
  var calendar = {};
  calendar.name = "";
  calendar.events = [];

  // Default to current date if none provided
  var requestedDate = "";
  if(req.params.date) {
    requestedDate = new Date(req.params.date);
  } else {
    requestedDate = new Date();
  }

  google_calendar.listCalendarList(access_token, function(err, data) {
    
    if(err) return res.send(500,err);
    
    // Get only first calendar, TODO: grab all calendars
    //var tempCal = data.items[4];
    if(tempCal) {
      calendar.name = tempCal.summary;

      // Asynchronously access events
      google_calendar.listEvent(access_token, tempCal.id, function(err, events) {
        if(err || !events || !events.items) {
          console.log(err);
          return res.send(err);
        }

        // Populate relevant fields for events
        events.items.forEach(function(event) {
          var eventStartDate = new Date(event.start.date);
          var eventEndDate = new Date(event.end.date);

          var weekStartTime = requestedDate.getTime() - requestedDate.getDay() * MILLISEC_IN_DAY;
          var weekEndTime = requestedDate.getTime() + (7-requestedDate.getDay()) * MILLISEC_IN_DAY;
          requestedDate.getDay();

          // Only consider events happening on same week as req.params.date
          if((eventStartDate <= weekStartTime && eventEndDate >= weekStartTime) ||
              (eventStartDate <= weekEndTime && eventEndDate >= weekEndTime) ||
              (eventStartDate <= weekStartTime && eventEndDate >= weekEndTime) ||
              (eventStartDate >= weekStartTime && eventEndDate <= weekEndTime)) {
            var calEvent = {};
            calEvent.id = event.id;
            calEvent.name = event.summary;
            calEvent.description = event.description;
            calEvent.location = event.location;
            calEvent.start = event.start;
            calEvent.end = event.end;
            calEvent.creator = event.creator;
            calEvent.attendees = event.attendees;
            calEvent.created = event.created;
            calEvent.updated = event.updated;

            // Add event to calendar object
            calendar.events.push(calEvent);
          }
        });

        // Return JSON object
        return res.send(calendar);
      });
    }
  });
};

function contains(a, obj) {
    var i = a.length;
    while (i--) {
       if (a[i] == obj) {
           return true;
       }
    }
    return false;
}