// Libraries
var util = require('util');
var url  = require('url');
var Q = require('q');
var express  = require('express');
var parse = require('node-parse-api').Parse;
var GoogleCalendarParse = require('google-calendar-parse').GoogleCalendarParse;
var GoogleCalendar = require('google-calendar').GoogleCalendar;
var time = require('time');
var GoogleParseAuth = require("google-parse-auth").GoogleParseAuth;

var mongoose = require('mongoose');
var Schema = mongoose.Schema;

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

var mongoose_options = {'user':'bmw', 'pass':'stanfordcs210'}
mongoose.connect('ds033877.mongolab.com:33877/merkel');
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));

// Mongoose schemas - user_id corresponds to Parse User Object ID
var calendar_schema = new Schema({
    name: String,
    user_id: String
});
var event_schema = new Schema({
    name: String,
    description: String,
    location: String,
    start: {
        date: Date,
        dateTime: Date,
        timezone: String
    },
    end: {
        date: Date,
        dateTime: Date,
        timezone: String
    },
    creator: {
        id: String,
        email: String,
        displayName: String,
        self: Boolean,
    },
    attendees: [{
        id: String,
        email: String,
        displayName: String,
        organizer: Boolean,
        self: Boolean,
        resource: Boolean,
        optional: Boolean,
        responseStatus: String,
        comment: String,
        additionalGuests: Number
    }],
    created: Date,
    updated: Date,
    calendar_id: String,
    user_id: String
});
var Calendar = mongoose.model('calendar', calendar_schema);
var Event = mongoose.model('event', event_schema);


/* ----------- API FUNCTIONS -----------*/
/*
 API Call: /api/events/:userId/day/:date?tz=[:tz]&dataType=[:type] - Grabs [userId]'s events happening between beginning of [date] and end of [date], in the timezone supplied by [tz]
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
 [tz] should be in URL encoded timezone format, e.g. "Europe%2FCopenhagen" or "America%2FLos_Angeles"
 [type] should be 'live' or 'cached', corresponding to live requests from the original data source or requests cached in the db
    */
exports.eventsDay = function(req, res) {
    return getCalendarEvents(req, res, "day");
};

/*
 API Call: /api/events/:userId/week/:date?tz=[:tz]&dataType=[:type] - Grabs [userId]'s events happening between beginning of [date] and end of [date] +7 days, in the timezone supplied by [tz]
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
 [tz] should be in URL encoded timezone format, e.g. "Europe%2FCopenhagen" or "America%2FLos_Angeles"
 [type] should be 'live' or 'cached', corresponding to live requests from the original data source or requests cached in the db
    */
exports.eventsWeek = function(req, res) {
    return getCalendarEvents(req, res, "week");
};

/*
 API Call: /api/events/:userId/week/:date?tz=[:tz]&dataType=[:type] - Grabs [userId]'s events happening between beginning of [date] and end of [date] +30 days, in the timezone supplied by [tz]
 [userId] should be whatever their Parse objectId is
 [date] should be in the format "yyyy-mm-dd", if empty defaults to current day
 [tz] should be in URL encoded timezone format, e.g. "Europe%2FCopenhagen" or "America%2FLos_Angeles"
 [type] should be 'live' or 'cached', corresponding to live requests from the original data source or requests cached in the db
    */
exports.eventsMonth = function(req, res) {
    return getCalendarEvents(req, res, "month");
}


/* Testing function, authenticates with Google, stores auth token in express session */
exports.authentication = function(req, res) {
    var appUrl = req.protocol + "://" + req.get('host');
    var google_calendar = new GoogleCalendar(GOOGLE_CONSUMER_KEY, GOOGLE_CONSUMER_SECRET, appUrl + '/authentication');

    if(!req.query.code) {

        //Redirect the user to Authentication From
        google_calendar.getGoogleAuthorizeTokenURL(function(err, redirecUrl) {
            if(err) return res.send(500,err);
            return res.redirect(redirecUrl);
        });
    } else {

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
    var dataType = req.query.dataType;
    var tz = req.query.tz;
    var userId = req.params.userId;

    console.log("This is dataType: " + dataType);

    // If request is for cached data, attempt to get cached data from Mongo, otherwise default to live request
    if(dataType && dataType == 'cached') {

        // Find cached results
        var results = findCachedEvents(req, res, type);
        if(results) {
            return res.send(results);
        } else {

            // Perform live search if no cached results found
            req.query.dataType = 'live';
            return getCalendarEvents(req, res, type);
        }
    } else {
        var appUrl = req.protocol + "://" + req.get('host');

        // Access token fallback - if access token exists in express session, use that, otherwise use Parse access token
        var google_calendar;
        var access_token;
        if(req.session && req.session.access_token) {
            google_calendar = new GoogleCalendar(GOOGLE_CONSUMER_KEY, GOOGLE_CONSUMER_SECRET, appUrl + '/authentication');
            access_token = req.session.access_token;
            console.log("Got access token from express: " + access_token);
        } else {
            google_calendar = new GoogleCalendarParse(parseApp, GOOGLE_CONSUMER_KEY, GOOGLE_CONSUMER_SECRET, appUrl + '/authentication');
        }

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
        if(tz) {
            timezone = decodeURIComponent(tz);
        } else {
            timezone = 'UTC';
        }
        // Change requested date to correct date request based on provided timezone
        requestedDate = new time.Date(requestedDateRaw.getFullYear(), requestedDateRaw.getMonth(), requestedDateRaw.getDate(), timezone);

        console.log("Received a request for the events for userID: '" + req.params.userId + "' on date: '" + requestedDate);
        // Hacky way for auth fallback, TODO: refactor
        var access_token_or_user_id;
        if(access_token) {
            access_token_or_user_id = access_token;
        } else {
            access_token_or_user_id = user_id;
        }

        return google_calendar.listCalendarList(access_token_or_user_id, function(err, data) {
            if(err) return res.send(500,err);

            var calendars = data.items;
            var queue = [];
            //console.log("Got calendars:",calendars);

            calendars.forEach(function(calendar) {
                //console.log("Pushing onto queue:", calendar.summary);
                queue.push(fetchEvents(google_calendar, access_token_or_user_id, calendar, requestedDate, type));
            });

            return Q.allResolved(queue).then(function(promises) {
                var calendarList = []
                promises.forEach(function(promise) {
                    if(promise.isFulfilled()) {
                    var value = promise.valueOf();
                    calendarList.push(value);
                    }
                });
                //console.log("Events:", calendarList);

                cacheCalendars(calendarList);
                return res.send(200, calendarList);
            });
        });
    }
}

function fetchEvents(google_calendar, access_token_or_user_id, calendar, requestedDate, type) {
    var deferred = Q.defer();
    console.log("fetching events for", calendar.summary);

    // Skip unnecessary calendars
    if(contains(CALENDARS_TO_SKIP, calendar.id)){
        console.log("Rejecting", calendar.summary);
        deferred.reject(calendar);
    } else {
        var option = {};
        option.key = GOOGLE_CONSUMER_KEY;
        if(access_token_or_user_id) option.access_token = access_token_or_user_id;
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
        //console.log("Trying to list events");
        google_calendar.listEvent(access_token_or_user_id, calendar.id, option, function(err, events) {
            //console.log("listing event");

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
                //console.log("Resolving:", tempCalendar);
                deferred.resolve(tempCalendar);
            }
        });
    }
    // Return JSON object after all calendars are accessed
    return deferred.promise;
}

/* Caches calendar results in mongoDB */
function cacheCalendars(calendars, userId) {
    calendars.forEach(function(calendar) {
        var tempCalendar = new Calendar({
            'name': calendar.name,
            'user_id': "" + userId
        });

        var options = {};
        options.upsert = true;

        // Upsert calendar - update if exists, insert if doesn't
        tempCalendar.save(function(err, data){
            if(err) {
                console.log("Error saving calendar: " + calendar.name + ", error: " + err + ", data: " + data);
                return;
            } else {
                console.log("Saved calendar: " + data);
            }
        });
        // Cache events
        cacheEvents(calendar.events);
    });
}

/* Caches event results in mongoDB */
function cacheEvents(calendar) {
    calendar.events.forEach(function(event) {

        // cache event
        return;
    });
}

/* Finds cached events based on request */
function findCachedEvents(req, res, type) {
    return;
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