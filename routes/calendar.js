
/*
 * Define behavior of this API here
 * GET calendar list
 */

exports.list = function(req, res){
  res.send(json_response);
};


var json_response = {
	  "name": "Merkel",
	  "version": "0.0.1",
	  "data": {
	    "name": "BMW",
	    "packet": "calendar",
	    "private": true
	  }
	};