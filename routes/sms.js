var kue = require('kue')
 , jobs = kue.createQueue();

exports.sendsms = function (data, delay) {
	var timedelay = (delay > 0) ? delay : 0;
	var job = jobs.create('sms', data).delay(timedelay).save();
	job.on('complete', function(){
	  console.log("Job complete: " + job);
	}).on('failed', function(){
	  console.log("Job failed: " + job);
	})
}
