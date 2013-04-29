// Created for demo purposes of showcasing RESTAPI usage in Node.js and Express.
// API URLs are defined below. Resources can be found in ./routes
// For each API, create a new route file, write the logic in javascript, and export the function. This file will bind the functions to URLs

/**
 * Module dependencies.
 */
var express = require('express'),
    routes = require('./routes'),
    http = require('http'),
    url = require('url'),
    path = require('path'),
    newrelic = require('newrelic'),
    calendar = require('./routes/calendar'),
    sms = require('./routes/sms'),
    conference = require('./routes/conference'),
    redis = require('kue/node_modules/redis');

var app = express();

var API_VERSION = '2013-04-23';

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
// GET
app.get('/', routes.index);
app.get('/' + API_VERSION + '/sms/send', sms.sendsms);
app.get('/' + API_VERSION + '/conference/capability', conference.capability);
app.get('/' + API_VERSION + '/conference/:conferenceCode', conference.get);
app.get('/' + API_VERSION + '/conference/create', conference.create);
app.get('/' + API_VERSION + '/conference/invite', conference.invite);
app.get('/' + API_VERSION + '/conference/join', conference.join);
app.get('/' + API_VERSION + '/conference/number', conference.number);
app.get('/' + API_VERSION + '/conference/twilio', conference.twilio);

// POST
app.post('/' + API_VERSION + '/conference/create', conference.create);
app.post('/' + API_VERSION + '/conference/invite', conference.invite);

/* Depricated routes
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
app.get('/api/conference/join', conference.join);
app.get('/api/conference/twilio', conference.twilio);
app.post('/api/conference', conference.create);
app.get('/api/conference', conference.list);
app.get('/api/conference/:name', conference.read);
app.get('/conference', conference.form);*/

app.listen(app.get('port'));
console.log("Callin app server listening on port " + app.get('port'));
