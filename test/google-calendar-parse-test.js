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
        })
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
    });
});