var kue = require('kue')
  , url = require('url')
  , redis = require('kue/node_modules/redis');

var parse = require('node-parse-api').Parse;
var PARSE_APP_ID = "ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj";
var PARSE_MASTER_KEY = "AAOYtk81wI3iRJiXxgRfwblt1EUHVBlyvpS9m3QO";
var parseApp = new parse(PARSE_APP_ID, PARSE_MASTER_KEY);
 
// make sure we use the Heroku Redis To Go URL
// (put REDISTOGO_URL=redis://localhost:6379 in .env for local testing)
 
kue.redis.createClient = function() {
    var redisUrl = url.parse(process.env.REDISTOGO_URL)
      , client = redis.createClient(redisUrl.port, redisUrl.hostname);
    if (redisUrl.auth) {
        client.auth(redisUrl.auth.split(":")[1]);
    }
    return client;
};
 
var jobs = kue.createQueue();
 
// see https://github.com/learnBoost/kue/ for how to do more than one job at a time
jobs.process('crawl', function(job, done) {
  console.log(job.data);
  done();
});

jobs.process('sms', 20, function(job, done) {
  var data = {"to": job.data.to,
              "from": job.data.from,
              "body": job.data.body};
  Parse.Cloud.run('send-sms', data, {
    success: function(response) {
      console.log("success");
      console.log(response);
      done();
    },
    error: function(error) {
      done(error);
    }
  });
});
