// Created for demo purposes of showcasing RESTAPI usage in Node.js and Express.
// API URLs are defined below. Resources can be found in ./routes
// For each API, create a new route file, write the logic in javascript, and export the function. This file will bind the functions to URLs

/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , calendar = require('./routes/calendar')
  , twilio = require('./routes/twilio')
  , http = require('http')
  , path = require('path');

var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

//Define API URLS and destinations here.
app.get('/', routes.index);
app.get('/calendar', calendar.list);
app.get('/twilio', twilio.twilio);

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
