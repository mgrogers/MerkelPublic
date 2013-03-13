var kue = require('kue')
 , jobs = kue.createQueue();

exports.sendsms = function (req, res) {
    var data = req.query;
    data.title = "SMS to: " + data.to;
    console.log(data);
    var timedelay = parseInt(data.delay);
    timedelay = (timedelay > 0) ? timedelay : 0;
    console.log(timedelay);
    var job = jobs.create('sms', data);
    if (timedelay > 0) {
        job.delay(timedelay);
        if (req.query.to != null && req.query.body != null) {
            var response = {"meta": {
                                "code": 200
                                },
                            "data": data,
                            "message": "SMS scheduled " + timedelay + " ms from " + new Date()
                            };
            res.send(response);
        } else {
            var response = {"meta": {
                                "code": 400,
                                "error_message": "Insufficient parameters for delayed SMS."
                                },
                            "data": data
                            };
            res.send(400, response);
        }
    } else {
      console.log("less than 0");
        job.on('complete', function(){
          console.log("Job complete: " + job);
          var response = {"meta": {
                            "code": 200
                            },
                        "data": data,
                        "message": "SMS delivered"
                        };
          res.send(response);
        }).on('failed', function(){
          console.log("Job failed: " + job);
          var response = {"meta": {
                            "code": 400,
                            "error_message": "Insufficient parameters for SMS."
                            },
                        "data": data
                        };
          res.send(400, data);
        });
    }
    job.save();
}

exports.sendsms_helper = function (data) {
    data.title = "SMS to: " + data.to;
    console.log(data);
    var timedelay = parseInt(data.delay);
    timedelay = (timedelay > 0) ? timedelay : 0;
    console.log(timedelay);
    var job = jobs.create('sms', data);
    if (timedelay > 0) {
        job.delay(timedelay);
        if (req.query.to != null && req.query.body != null) {
            var response = {"meta": {
                                "code": 200
                                },
                            "data": data,
                            "message": "SMS scheduled " + timedelay + " ms from " + new Date()
                            };
            res.send(response);
        } else {
            var response = {"meta": {
                                "code": 400,
                                "error_message": "Insufficient parameters for delayed SMS."
                                },
                            "data": data
                            };
            res.send(400, response);
        }
    } else {
      console.log("less than 0");
        job.on('complete', function(){
          console.log("Job complete: " + job);
          var response = {"meta": {
                            "code": 200
                            },
                        "data": data,
                        "message": "SMS delivered"
                        };
          res.send(response);
        }).on('failed', function(){
          console.log("Job failed: " + job);
          var response = {"meta": {
                            "code": 400,
                            "error_message": "Insufficient parameters for SMS."
                            },
                        "data": data
                        };
          res.send(400, data);
        });
    }
    job.save();
}
