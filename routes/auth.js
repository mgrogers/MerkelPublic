var request = require('request');
var parse = require('node-parse-api')


exports.index = function(req, res) {
	res.render('index', {
		title: 'Home',
		text: "we're authing"
	});
};

exports.login = function(req, res) {
	res.render('login', {});
};

exports.google_auth = function(req, res) {
	res.send("");
}

exports.google_auth_token = function(req, res) {
	var access_code = req.query['code'];

	var CLIENTID = '992955494422-u92pvkijf7ll2vmd7qjf2hali813q7pv.apps.googleusercontent.com';
    var CLIENTSECRET = 'rLkby14J_c-YkVA96KCqeajC';
    console.log(access_code);

	request.post({
		url: 'https://accounts.google.com/o/oauth2/token',
		form: {
			code: access_code,
			client_id: CLIENTID,
	    	client_secret: CLIENTSECRET,
	    	redirect_uri: 'http://localhost:5000/google_auth/',
	    	grant_type: 'authorization_code',
		}},
		function(error, response, body) {
			console.log(error);
			console.log(body);
			console.log(response.statusCode);
			res.contentType('json');
			res.send(body);
			console.log("sent");
		}
	);
}