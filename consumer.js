var kue = require('kue')
  , url = require('url')
  , redis = require('kue/node_modules/redis')
  , newrelic = require('newrelic');

var Parse = require('parse').Parse;
var PARSE_APP_ID = "ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj";
var PARSE_JAVASCRIPT_KEY = "LuF9wF7h9GRzarp6FnYjdGUGHQtOrlxUeoC3CJqM";
Parse.initialize(PARSE_APP_ID, PARSE_JAVASCRIPT_KEY);
 
// make sure we use the Heroku Redis To Go URL
// (put REDISTOGO_URL=redis://localhost:6379 in .env for local testing)
 
kue.redis.createClient = function() {
    var redisUrl = url.parse(process.env.REDISTOGO_URL || "redis://localhost:6379")
      , client = redis.createClient(redisUrl.port, redisUrl.hostname);
    if (redisUrl.auth) {
        client.auth(redisUrl.auth.split(":")[1]);
    }
    return client;
};
 
var jobs = kue.createQueue();

var delayCheck = 1000;
 
// see https://github.com/learnBoost/kue/ for how to do more than one job at a time
jobs.process('crawl', function(job, done) {
  console.log(job.data);
  done();
});

jobs.process('sms', 20, function(job, done) {
  console.log(job.data);
  var data = {"to": job.data.to,
              "body": job.data.body};
  Parse.Cloud.run('sendsms', data, {
    success: function(response) {
      job.log("success");
      console.log(response);
      done();
    },
    error: function(error) {
      job.log(error);
      done(error);
    }
  });
});

jobs.promote(delayCheck);
