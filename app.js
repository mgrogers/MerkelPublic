// Created for demo purposes of showcasing RESTAPI usage in Node.js and Express.
// API URLs are defined below. Resources can be found in ./routes
// For each API, create a new route file, write the logic in javascript, and export the function. This file will bind the functions to URLs

/**
 * Module dependencies.
 */

var express = require('express'),
  	routes = require('./routes'),
  	calendar = require('./routes/calendar'),
  	sms = require('./routes/sms'),
  	http = require('http'),
  	path = require('path'),
  	kue = require('kue'),
  	url = require('url'),
  	redis = require('kue/node_modules/redis');

var app = express();

app.set('port', process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.cookieParser());
app.use(express.session({
  secret: "merkelmerkelmerkel"
}));
app.use(app.router);
app.use(express.errorHandler());
app.use(express.static(path.join(__dirname, 'public')));

//Define API URLS and destinations here.
app.get('/', routes.index);
app.get('/authentication', calendar.authentication);
app.get('/api/events/:userId/day', calendar.eventsDay);
app.get('/api/events/:userId/day/:date', calendar.eventsDay);
app.get('/api/events/:userId/day/:date/:tz', calendar.eventsDay);
app.get('/api/events/:userId/week', calendar.eventsWeek);
app.get('/api/events/:userId/week/:date', calendar.eventsWeek);
app.get('/api/events/:userId/week/:date/:tz', calendar.eventsWeek);
app.get('/api/events/:userId/month', calendar.eventsMonth);
app.get('/api/events/:userId/month/:date', calendar.eventsMonth);
app.get('/api/events/:userId/month/:date/:tz', calendar.eventsMonth);
app.get('/api/sms/send', sms.sendsms);

kue.redis.createClient = function() {
    var redisUrl = url.parse("redis://redistogo:8b3171477ccaa37c8ee4e988b9c99fb2@viperfish.redistogo.com:9462/")
      , client = redis.createClient(redisUrl.port, redisUrl.hostname);
	// if (process.env.REDISTOGO_URL == null) {
	// 	redisUrl = url.parse("redis://localhost:6379");
	// }
	console.log("redis url: " + redisUrl);
    if (redisUrl.auth) {
        client.auth(redisUrl.auth.split(":")[1]);
    }
    return client;
};

var jobs = kue.createQueue();

// wire up Kue (see /active for queue interface)
app.use(kue.app);
if (process.env.REDISTOGO_URL == null) kue.app.listen(8888);

app.listen(app.get('port'));
console.log("Express server listening on port " + app.get('port'));
