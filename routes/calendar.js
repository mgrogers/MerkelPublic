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

exports.eventsDay = function(req, res) {
  console.log("This is a request for today's event for userID: " + req.params.userId);

  var access_token = "ya29.AHES6ZQMREvGK27phlZrKTcLTbXFWxH25oB4cesbcyRgiOdKrsJx-A";
  var output = {};
  output.name = "";

  google_calendar.listCalendarList(access_token, function(err, data) {
    
    if(err) return res.send(500,err);
    
    // Get only first calendar
    var calendar = data.items[0];
    if(calendar) {
      output.name = calendar.summary;

      return res.send('Calendar name: ' + output.name);
    }

    return;
  });
}
