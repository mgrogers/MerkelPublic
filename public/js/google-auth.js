var OAUTHURL    =   'https://accounts.google.com/o/oauth2/auth?';
	        var VALIDURL    =   'https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=';
	        var TOKENURL	=	'https://accounts.google.com/o/oauth2/token'
            var API_KEY = 'AIzaSyDL2JezpSKWu9wcwW6o1iwl6tDmm42d5eI';
            var CLIENTID = '992955494422-u92pvkijf7ll2vmd7qjf2hali813q7pv.apps.googleusercontent.com';
            var SCOPE = 'https://www.googleapis.com/auth/calendar'
	        var REDIRECT    =   'http://localhost:5000/google_auth/'
	        var ACCESSTYPE = 'offline'
	        var TYPE        =   'code';
	        var _url        =   OAUTHURL + 'scope=' + SCOPE + '&client_id=' + CLIENTID + '&redirect_uri=' + REDIRECT + '&response_type=' + TYPE + '&access_type=' + ACCESSTYPE + '&approval_prompt=force';
	        var acToken;
	        var tokenType;
	        var expiresIn;
	        var user;
	        var loggedIn    =   false;


	        Parse.initialize('ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj',
                      'LuF9wF7h9GRzarp6FnYjdGUGHQtOrlxUeoC3CJqM');


	        function authorize(callback) {
				var win         =   window.open(_url, "GoogleAuth", 'width=800, height=600'); 

	            var pollTimer   =   window.setInterval(function() { 
	                try {
	                    console.log(win.document.URL);
	                    if (win.document.URL.indexOf(REDIRECT) != -1) {
	                        window.clearInterval(pollTimer);
	                        var url =   win.document.URL;
	                        var access_code =  gup(url, 'code');
	                        //tokenType = gup(url, 'token_type');
	                        //expiresIn = gup(url, 'expires_in');
	                        win.close();
	                        console.log("URL: " + url);
	                        console.log("access_code: " + access_code);
	                        retrieveTokens(access_code, callback);
	                    }
	                } catch(e) {
	                }
	            }, 100);
	        }
	        function retrieveTokens(code, callback) {
	        	$.ajax({
	        		type: 'get',
	                url: '/google_auth/token/',
	                data: {
	                	code: code,
	                },
	                complete: function() {
	                	console.log("Completed");
	                },
	                success: function(data, textStatus, jqXHR){
	                	console.log(data);  
	                    var currentUser = Parse.User.current();
	                    var token = data.access_token;
	                    var refresh_token = data.refresh_token;
					   	currentUser.set("google_access_token", token);
					   	currentUser.set("google_refresh_token", refresh_token);
					   	currentUser.save();
                        callback();
	                },
	                failure: function(data, textStatus, jqXHR) {
	                	console.log("Error: " + responseText);
	                },
	            });
	        }
	        //credits: http://www.netlobo.com/url_query_string_javascript.html
	        function gup(url, name) {
	            name = name.replace(/[[]/,"\[").replace(/[]]/,"\]");
	            var regexS = "[?&]"+name+"=([^&#]*)";
	            var regex = new RegExp( regexS );
	            var results = regex.exec( url );
	            if( results == null )
	                return "";
	            else
	                return results[1];
	        }