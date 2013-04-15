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

var mongoose_options = {'auto_reconnect':true};
mongoose.connect('mongodb://heroku_app12018585:8la71don2tthmm2ceaahdmhog2@ds045507.mongolab.com:45507/heroku_app12018585', mongoose_options);
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));

// Mongoose schemas - userId corresponds to Parse User Object ID
var calendarSchema = new Schema({
    name: {type: String, default: ""},
    userId: {type: String, default: ""}
});
var eventSchema = new Schema({
    id: {type: String, default: ""},
    name: {type: String, default: ""},
    description: {type: String, default: ""},
    location: {type: String, default: ""},
    start: {
        date: {type: Date, default: null},
        dateTime: {type: Date, default: null},
        timeZone: {type: String, default: ""}
    },
    end: {
        date: {type: Date, default: null},
        dateTime: {type: Date, default: null},
        timeZone: {type: String, default: ""}
    },
    creator: {
        id: {type: String, default: ""}, // refers to google identifier
        email: {type: String, default: ""},
        displayName: {type: String, default: ""},
        self: {type: Boolean, default: false},
    },
    attendees: [{
        id: {type: String, default: ""}, // refers to google identifier
        email: {type: String, default: ""},
        displayName: {type: String, default: ""},
        organizer: {type: Boolean, default: false},
        self: {type: Boolean, default: false},
        resource: {type: Boolean, default: false},
        optional: {type: Boolean, default: false},
        responseStatus: {type: String, default: ""},
        comment: {type: String, default: ""},
        additionalGuests: {type: Number, default: 0}
    }],
    created: {type: Date, default: null},
    updated: {type: Date, default: null},
    calendarId: {type: String, default: ""},
    userId: {type: String, default: ""}
});
var Calendar = mongoose.model('calendar', calendarSchema);
var Event = mongoose.model('event', eventSchema);


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

        var userId = req.params.userId;

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
        var access_token_or_userId;
        if(access_token) {
            access_token_or_userId = access_token;
        } else {
            access_token_or_userId = userId;
        }

        return google_calendar.listCalendarList(access_token_or_userId, function(err, data) {
            if(err) return res.send(500,err);

            var calendars = data.items;
            var queue = [];
            //console.log("Got calendars:",calendars);

            calendars.forEach(function(calendar) {
                //console.log("Pushing onto queue:", calendar.summary);
                queue.push(fetchEvents(google_calendar, access_token_or_userId, calendar, requestedDate, type));
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

                cacheCalendars(calendarList, userId);
                return res.send(200, calendarList);
            });
        });
    }
}

function fetchEvents(google_calendar, access_token_or_userId, calendar, requestedDate, type) {
    var deferred = Q.defer();
    console.log("fetching events for", calendar.summary);

    // Skip unnecessary calendars
    if(contains(CALENDARS_TO_SKIP, calendar.id)){
        console.log("Rejecting", calendar.summary);
        deferred.reject(calendar);
    } else {
        var option = {};
        option.key = GOOGLE_CONSUMER_KEY;
        if(access_token_or_userId) option.access_token = access_token_or_userId;
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
        google_calendar.listEvent(access_token_or_userId, calendar.id, option, function(err, events) {
            //console.log("listing event");

            // Error
            if(err || !events) {
                console.log(err);
                deferred.reject(err);
            } else if(!events.items) {
                console.log("Resolving - no events");
                var tempCalendar = {};
                tempCalendar.id = calendar.id;
                tempCalendar.name = calendar.summary;
                tempCalendar.events = [];
                deferred.resolve(tempCalendar);
            } else {
                var tempCalendar = {};
                tempCalendar.id = calendar.id;
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
                        else calEvent.description = "";

                        if(event.location) calEvent.location = event.location;
                        else calEvent.location = "";

                        if(event.start) {
                            calEvent.start = {
                                date: event.start.date || null,
                                dateTime: event.start.dateTime || null,
                                timeZone: event.start.timeZone || ""
                            };
                        } else {
                            calEvent.start = {};
                        }

                        if(event.end) {
                            calEvent.end = {
                                date: event.end.date || null,
                                dateTime: event.end.dateTime || null,
                                timeZone: event.end.timeZone || ""
                            };
                        } else {
                            calEvent.end = {};
                        }

                        if(event.creator) {
                            calEvent.creator = {
                                id: event.creator.id || "",
                                email: event.creator.email || "",
                                displayName: event.creator.displayName || "",
                                self: event.creator.self || false
                            };
                        } else {
                            calEvent.creator = {};
                        }

                        if(event.attendees) {
                            calEvent.attendees = [];
                            event.attendees.forEach(function(attendee) {
                                calEvent.attendees.push({
                                    id: attendee.id || "",
                                    email: attendee.email || "",
                                    displayName: attendee.displayName || "",
                                    organizer: attendee.organizer || false,
                                    self: attendee.self || false,
                                    resource: attendee.resource || false,
                                    optional: attendee.optional || false,
                                    responseStatus: attendee.responseStatus || "",
                                    comment: attendee.comment || "",
                                    additionalGuests: attendee.additionalGuests || 0
                                });
                            });
                        } else {
                            calEvent.attendees = [];
                        }

                        if(event.created) calEvent.created = event.created;
                        else calEvent.created = "";

                        if(event.updated) calEvent.updated = event.updated;
                        else calEvent.updated = "";

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
        var tempCalendar = {
            id: calendar.id,
            name: calendar.name,
            userId: userId
        };

        // Upsert calendar - update if exists, insert if doesn't
        Calendar.findOneAndUpdate({id: calendar.id}, tempCalendar, {upsert: true}, function(err, data) {
            if(err) {
                console.log("Error saving calendar: " + calendar.name + ", error: " + err + ", data: " + data);
            } else {
                console.log("Upserted calendar: " + calendar.name + ", data: " + data);

                // Cache events in this calendar
                cacheEvents(calendar, userId);
            }
        });
    });
}

/* Caches event results in mongoDB */
function cacheEvents(calendar, userId) {
    calendar.events.forEach(function(event) {

        // Cache event
        var tempEvent = {
            id: event.id,
            name: event.name,
            description: event.description,
            location: event.location,
            start: event.start,
            end: event.end,
            creator: event.creator,
            attendees: event.attendees,
            created: event.created,
            updated: event.updated,
            calendarId: calendar.id,
            userId: userId
        };

        // Upsert event
        Event.findOneAndUpdate({id: event.id}, tempEvent, {upsert: true}, function(err, data) {
            if(err) {
                console.log("Error saving event: " + event.name + ", error: " + err + ", data: " + data);
            } else {
                console.log("Upserted event: " + event.name + ", data: " + data);
            }
        });
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