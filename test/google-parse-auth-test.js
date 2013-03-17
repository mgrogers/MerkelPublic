var assert = require("assert");
var sinon = require("sinon");
var nock = require("nock");

var GoogleParseAuth = require("google-parse-auth").GoogleParseAuth;

var GOOGLE_CONSUMER_KEY = "googleconsumerkey";
var GOOGLE_CONSUMER_SECRET = "googleconsumersecret";

describe('GoogleParseAuth', function() {
	describe('refreshAccessToken', function() {
		it("should return the new access token in a callback and save it in parse", function(done) {
			var parseAPI = {
				find: function(){},
				update: function(){}
			};

			var find_stub = sinon.stub(parseAPI, "find", function(clazz, id, callback) {
					console.log("(*) Called find on parse");
					callback(null, {google_refresh_token: 'refreshtoken'});
				});
			var update_stub = sinon.stub(parseAPI, "update", function(clazz, id, data, callback) {
					console.log("(*) called update on parse");
					callback(null, {});
				});

			var response = {access_token: "newtoken",
	            			expires_in:3920,
	            			token_type:"Bearer"
	            			};
			var google = nock('https://accounts.google.com')
					.log(console.log)
	                .post('/o/oauth2/token', "refresh_token=refreshtoken" +
	            							"&client_id=" + GOOGLE_CONSUMER_KEY +
	            							"&client_secret=" + GOOGLE_CONSUMER_SECRET +
	            							"&grant_type=refresh_token")
	                .reply(200, response, {'Content-Type': 'application/json'});

			var google_parse_auth = new GoogleParseAuth(parseAPI, 
														GOOGLE_CONSUMER_KEY, 
														GOOGLE_CONSUMER_SECRET);


			google_parse_auth.refreshAccessToken('myID', function(new_access_token) {
				assert.equal(new_access_token, 'newtoken');
				assert(find_stub.called);
				assert(update_stub.called);
				done();
			});
		});
	});

	describe("retrieveAccessToken", function() {
		it("should retrieve an access token from parse and then call the callback", function(done) {
			var parseAPI = {
				find: function(){},
				update: function(callback){callback()}
			};

			var find_stub = sinon.stub(parseAPI, "find", function(clazz, id, callback) {
					console.log("(*) Called find on parse");
					assert.equal(id, "userId");
					callback(null, {google_refresh_token: 'refreshtoken', google_access_token: 'authtoken'});
				});

			var google_parse_auth = new GoogleParseAuth(parseAPI, 
															GOOGLE_CONSUMER_KEY, 
															GOOGLE_CONSUMER_SECRET);

			google_parse_auth.retrieveAccessToken("userId", function(err, token) {
				assert.equal("authtoken", token);
				done();
			});
		});
	});

	describe("makeAuthenticatedCall", function() {
		var parseAPI;
		var find_stub;

		beforeEach(function() {
			parseAPI = {
				find: function(){},
				update: function(callback){callback()}
			}
		});

		it("should be able to make a call using the access token it gets from parse", function(done) {
			var test_module = {
					test_method: function(token, arg2, callback) {
				}
			}

			find_stub = sinon.stub(parseAPI, "find", function(clazz, id, callback) {
				console.log("(*) Called find on parse");
				callback(null, {google_refresh_token: 'refreshtoken', google_access_token: 'authtoken'});
			});

			var method_stub = sinon.stub(test_module, "test_method", function(token, arg2, callback) {
					console.log("Args length: ", arguments.length);
					assert.equal("authtoken", token);
					assert.equal(2, arg2);
					callback(false, "events");
				});

			var google_parse_auth = new GoogleParseAuth(parseAPI, 
														GOOGLE_CONSUMER_KEY, 
														GOOGLE_CONSUMER_SECRET);

			google_parse_auth.makeAuthenticatedCall("userId", test_module, test_module.test_method, 2, function(err, data) {
				assert.equal(data, "events");
				assert(method_stub.called);
				done();
			});

		}); 

		it("should work on a function with no extra arguments", function(done) {
			var test_module = {
					test_method: function(token, callback) {
				}
			}

			find_stub = sinon.stub(parseAPI, "find", function(clazz, id, callback) {
				console.log("(*) Called find on parse");
				callback(null, {google_refresh_token: 'refreshtoken', google_access_token: 'authtoken'});
			});

			var method_stub = sinon.stub(test_module, "test_method", function(token, callback) {
					console.log("Args length: ", arguments.length);
					assert.equal("authtoken", token);
					callback(false, "events");
				});

			var google_parse_auth = new GoogleParseAuth(parseAPI, 
														GOOGLE_CONSUMER_KEY, 
														GOOGLE_CONSUMER_SECRET);

			google_parse_auth.makeAuthenticatedCall("userId", test_module, test_module.test_method, function(err, data) {
				assert.equal(data, "events");
				assert(method_stub.called);
				done();
			});

		});

		it("should be able to successfully retrieve a refresh token if the access token is bad", function(done) {
			function api_method(token, arg2, callback) {
				if (token == "authtoken") {
					callback(false, "events");
				} else {
					console.log("Oops, old token");
					callback(new Error(), "error, old token");
				}
			}

			var test_module = {
				test_method: api_method
			}

			find_stub = sinon.stub(parseAPI, "find", function(clazz, id, callback) {
				console.log("(*) Called find on parse");
				callback(null, {google_refresh_token: 'refreshtoken', google_access_token: 'oldtoken'});
			});
			var update_stub = sinon.stub(parseAPI, "update", function(clazz, id, data, callback) {
					console.log("(*) called update on parse");
					callback(null, {});
				});

			var response = {access_token: "authtoken",
	            			expires_in:3920,
	            			token_type:"Bearer"
	            			};
			var google = nock('https://accounts.google.com')
					.log(console.log)
	                .post('/o/oauth2/token', "refresh_token=refreshtoken" +
	            							"&client_id=" + GOOGLE_CONSUMER_KEY +
	            							"&client_secret=" + GOOGLE_CONSUMER_SECRET +
	            							"&grant_type=refresh_token")
	                .reply(200, response, {'Content-Type': 'application/json'});

	        var google_parse_auth = new GoogleParseAuth(parseAPI, 
														GOOGLE_CONSUMER_KEY, 
														GOOGLE_CONSUMER_SECRET);

	        function finalCallback(err, data) {
	        	assert.equal(data, "events");
				done();
	        }

	        google_parse_auth.makeAuthenticatedCall("userId", test_module, test_module.test_method, 2, finalCallback);
		});

		it("should just return an error if it can't get a good token", function(done) {
			function api_method(token, arg2, callback) {
				if (token == "authtoken") {
					callback(null, "events");
				} else {
					callback(new Error(), "error, old token");
				}
			}

			var test_module = {
				test_method: api_method
			}

			find_stub = sinon.stub(parseAPI, "find", function(clazz, id, callback) {
				console.log("(*) Called find on parse");
				callback(null, {google_refresh_token: 'refreshtoken', google_access_token: 'oldtoken'});
			});
			var update_stub = sinon.stub(parseAPI, "update", function(clazz, id, data, callback) {
					console.log("(*) called update on parse");
					callback(null, {});
				});

			var response = {access_token: "nope, sorry",
	            			expires_in:3920,
	            			token_type:"Bearer"
	            			};
			var google = nock('https://accounts.google.com')
					.log(console.log)
	                .post('/o/oauth2/token', "refresh_token=refreshtoken" +
	            							"&client_id=" + GOOGLE_CONSUMER_KEY +
	            							"&client_secret=" + GOOGLE_CONSUMER_SECRET +
	            							"&grant_type=refresh_token")
	                .reply(200, response, {'Content-Type': 'application/json'});

	        var google_parse_auth = new GoogleParseAuth(parseAPI, 
														GOOGLE_CONSUMER_KEY, 
														GOOGLE_CONSUMER_SECRET);

	        function finalCallback(err, data) {
	        	assert(err);
				done();
	        }

	        google_parse_auth.makeAuthenticatedCall("userId", test_module, test_module.test_method, 2, finalCallback);
		});
	});
});