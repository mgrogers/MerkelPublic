
/*
 * Define behavior of this API here
 * GET calendar list
 */

var GoogleCalendar = require('google-calendar');
var google_calendar = new GoogleCalendar.GoogleCalendar(
  "992955494422.apps.googleusercontent.com", 
  "owOZqTGiK2e59tT9OqRHs5Xt",
  'http://localhost:3000/authentication');

exports.list = function(req, res){
  res.send(json_response);
};


var json_response = {
	  "name": "Merkel",
	  "version": "0.0.1",
	  "data": {
	    "name": "BMW",
	    "packet": "calendar",
	    "private": true
	  }
	};