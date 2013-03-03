var util = require('util');
var url  = require('url');
var express  = require('express');
var GoogleCalendar = require('google-calendar');
var google_calendar = new GoogleCalendar.GoogleCalendar(
  "992955494422-u92pvkijf7ll2vmd7qjf2hali813q7pv.apps.googleusercontent.com",
  "rLkby14J_c-YkVA96KCqeajC",
  'http://localhost:3000/authentication');

/*
 * Define behavior of this API here
 * GET calendar list
 */

exports.list = function(req, res) {
  var access_token = req.session.access_token;
  
  var output = {};
  output.name = "";
  output.events = [];
  
  if(!access_token)return res.redirect('/authentication');
  
  google_calendar.listCalendarList(access_token, function(err, data) {
    
    if(err) return res.send(500,err);
    
    // Get only first calendar
    var calendar = data.items[0];
    if(calendar) {
      output.name = calendar.summary;

      // Asynchronously access events
      google_calendar.listEvent(access_token, calendar.id, function(err, events) {
        if(err || !events || !events.items) {
          console.log(err);
          return;
        }

        // Populate events
        events.items.forEach(function(event) {
          output.events.push(event);
        });

        // Return JSON object
        return res.send(output);
      });
    }

    return;
  });
};

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

      // Grab auth token in log
      console.log("This is my auth token: " + access_token);

      req.session.refresh_token = refresh_token;
      return res.redirect('/calendar');
    });
  }
};

/*
 API Call: /api/events/:userId/day/:date - Grabs [userId]'s events on [date]
 [userId] should be whatever their Parse userId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current
  */
exports.eventsDay = function(req, res) {
  console.log("This is a request for the events for userID: " + req.params.userId +
    " on date: " + req.params.date);

  // TODO: Grab access token from parse from user with userId: req.params.userId
  var access_token = "ya29.AHES6ZQLyn3BF7FEXRIBFsDIzVb8WB-I_imawZjHk956Zg";
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
    var tempCal = data.items[0];
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

          // Only consider events happening on req.params.date
          if(eventStartDate.getTime() <= requestedDate.getTime() &&
              requestedDate.getTime() <= eventEndDate.getTime()) {
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
}