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
    gmail = require('./routes/gmail'),
    auth = require('./routes/auth'),
    http = require('http'),
    path = require('path'),
    kue = require('kue'),
    url = require('url');
    redis = require('kue/node_modules/redis'),
    newrelic = require('newrelic');

var app = express();

app.set('port', process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.engine('hbs', require('hbs').__express);
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

// Define API URLS and destinations here.
app.get('/', routes.index);
app.get('/home/', routes.home);
app.get('/auth/', auth.index);
app.get('/login/', auth.login);
app.get('/google_auth/', auth.google_auth);
app.get('/google_auth/token/', auth.google_auth_token);

app.get('/authentication', calendar.authentication);
app.get('/api/events/:userId/day', calendar.eventsDay);
app.get('/api/events/:userId/day/:date', calendar.eventsDay);
app.get('/api/events/:userId/week', calendar.eventsWeek);
app.get('/api/events/:userId/week/:date', calendar.eventsWeek);
app.get('/api/events/:userId/month', calendar.eventsMonth);
app.get('/api/events/:userId/month/:date', calendar.eventsMonth);
app.get('/api/sms/send', sms.sendsms);
app.get('/api/mail', gmail.mail);

kue.redis.createClient = function() {
    var redisUrl = url.parse(process.env.REDISTOGO_URL || "redis://localhost:6379"), client = redis.createClient(redisUrl.port, redisUrl.hostname);
    if (redisUrl.auth) {
        client.auth(redisUrl.auth.split(":")[1]);
    }
    
    return client;
};

// wire up Kue (see /active for queue interface)
app.use(kue.app);
if (process.env.REDISTOGO_URL == null) kue.app.listen(8888);

app.listen(app.get('port'));
console.log("Express server listening on port " + app.get('port'));
