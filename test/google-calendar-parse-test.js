var assert = require("assert");
var sinon = require("sinon");
var nock = require("nock");

var GoogleCalendarParse = require("google-calendar-parse").GoogleCalendarParse;

var GOOGLE_CONSUMER_KEY = "googleconsumerkey";
var GOOGLE_CONSUMER_SECRET = "googleconsumersecret";

describe("GoogleCalendarParse", function() {
    describe("listCalendarList", function() {
        var parseAPI;
        var find_stub;
        var update_stub;

        beforeEach(function() {
            parseAPI = {
                find: function(){},
                update: function(){}
            };

            find_stub = sinon.stub(parseAPI, "find", function(clazz, id, callback) {
                    console.log("(*) Called find on parse");
                    callback(null, {google_refresh_token: 'refreshtoken', google_access_token: "accesstoken"});
                });
            update_stub = sinon.stub(parseAPI, "update", function(clazz, id, data, callback) {
                    console.log("(*) called update on parse");
                    callback(null, {});
                });
        });

        it("Should just make the request like normal if it gets a token from parse", function(done) {
            var google = nock('https://www.googleapis.com')
                    .log(console.log)
                    .get('/calendar/v3/users/me/calendarList?access_token=accesstoken&key=googleconsumerkey')
                    .reply(200, {calendar: 'success'}, {'Content-Type': 'application/json'});

            var google_calendar_parse = new GoogleCalendarParse(parseAPI, GOOGLE_CONSUMER_KEY, GOOGLE_CONSUMER_SECRET);

            google_calendar_parse.listCalendarList("user_id", function(err, data) {
                assert.equal(data.calendar, "success");
                done();
            });
        });

        it("Should just pass through the error if it receives a 401 in response", function(done) {
            var google = nock('https://www.googleapis.com')
                    .log(console.log)
                    .get('/calendar/v3/users/me/calendarList?access_token=accesstoken&key=googleconsumerkey')
                    .reply(401, {calendar: 'faillll'}, {'Content-Type': 'application/json'});

            var google_calendar_parse = new GoogleCalendarParse(parseAPI, GOOGLE_CONSUMER_KEY, GOOGLE_CONSUMER_SECRET);

            google_calendar_parse.listCalendarList("user_id", function(err, data) {
                done();
            });
        });
    });

    describe("listEvent", function() {
        var parseAPI;
        var find_stub;
        var update_stub;

        beforeEach(function() {
            parseAPI = {
                find: function(){},
                update: function(){}
            };

            find_stub = sinon.stub(parseAPI, "find", function(clazz, id, callback) {
                    console.log("(*) Called find on parse");
                    callback(null, {google_refresh_token: 'refreshtoken', google_access_token: "accesstoken"});
                });
            update_stub = sinon.stub(parseAPI, "update", function(clazz, id, data, callback) {
                    console.log("(*) called update on parse");
                    callback(null, {});
                });
        });

        it("Should list the events for a calendar", function(done) {
            var google = nock('https://www.googleapis.com')
                    .log(console.log)
                    .get('/calendar/v3/calendars/1/events?access_token=accesstoken&key=googleconsumerkey')
                    .reply(200, [{summary: 'success'}], {'Content-Type': 'application/json'});

            var google_calendar_parse = new GoogleCalendarParse(parseAPI, GOOGLE_CONSUMER_KEY, GOOGLE_CONSUMER_SECRET);

            google_calendar_parse.listEvent("user_id", 1, {}, function(err, data) {
                assert.equal(data[0].summary, "success");
                done();
            });
        });
    });
});