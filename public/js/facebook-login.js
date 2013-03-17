Parse.initialize('ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj',
                      'LuF9wF7h9GRzarp6FnYjdGUGHQtOrlxUeoC3CJqM');

function logIn() {
Parse.FacebookUtils.logIn("email", {
  success: function(user) {
    if(!user.existed()) {
      FB.api('/me', function(response) {
        user.set("username", response.username);
        user.set("email", response.email);
        user.set("first_name", response.first_name);
        user.set("last_name", response.last_name);
        user.save();
        window.location = '/home/';
      });
    } else {
    	window.location = '/home/';
    }

    
    
  },
  error: function(user, error) {
    alert("User facebook login didn't complete");
  }
});
}

window.fbAsyncInit = function() {
// init the FB JS SDK
Parse.FacebookUtils.init({
  appId      : '258693340932079', // App ID from the App Dashboard
  channelUrl : '/channel.html', // Channel File for x-domain communication
  status     : true, // check the login status upon init?
  cookie     : true, // set sessions cookies to allow your server to access the session?
  xfbml      : true  // parse XFBML tags on this page?
});

// Additional initialization code such as adding Event Listeners goes here

};

// Load the SDK's source Asynchronously
// Note that the debug version is being actively developed and might 
// contain some type checks that are overly strict. 
// Please report such bugs using the bugs tool.
(function(d, debug){
 var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
 if (d.getElementById(id)) {return;}
 js = d.createElement('script'); js.id = id; js.async = true;
 js.src = "//connect.facebook.net/en_US/all" + (debug ? "/debug" : "") + ".js";
 ref.parentNode.insertBefore(js, ref);
}(document, /*debug*/ false));