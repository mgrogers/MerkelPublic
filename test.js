/*
  This example is showing how to access google calendar with OAuth (version 2).
  After successfully login, the example generate a simple webpage that list all of your calendars' name. 
  
  require - express (http://expressjs.com)
*/

var util = require('util');
var url  = require('url');
var express  = require('express');

var GoogleCalendar = require('google-calendar');

var app = express();
app.set('port', process.env.PORT || 3000);
app.use(express.cookieParser());
app.use(express.session({
  secret: "skjghskdjfhbqigohqdiouk"
}));
app.listen(app.get('port'));


//Create OAuth Instance
var google_calendar = new GoogleCalendar.GoogleCalendar(
  "992955494422-u92pvkijf7ll2vmd7qjf2hali813q7pv.apps.googleusercontent.com", 
  "rLkby14J_c-YkVA96KCqeajC",
  'http://localhost:' + app.get('port') + '/authentication');
  // 'http://safe-mountain-5325.herokuapp.com/authentication'); 

//The redirect URL must be matched!!
app.all('/authentication', function(req, res){
  console.log("REQUEST" + req);
  console.log("REQUEST" + req.query);
  console.log("REQUEST" + req.query.code);
  if(!req.query.code){

    //Redirect the user to Authentication From
    google_calendar.getGoogleAuthorizeTokenURL(function(err, redirecUrl) {
      if(err) return res.send(500,err);
      return res.redirect(redirecUrl);
    });
    
  }else{
    //Get access_token from the code
    google_calendar.getGoogleAccessToken(req.query, function(err, access_token, refresh_token) {

      if(err) return res.send(500,err);
      
      req.session.access_token = access_token;
      req.session.refresh_token = refresh_token;
      return res.redirect('/');
    });
  }
});

app.all('/', function(req, res){
  
  var access_token = req.session.access_token;
  
  var output = {};
  output.name = "";
  output.events = [];
  
  if(!access_token)return res.redirect('/authentication');
  
  google_calendar.listCalendarList(access_token, function(err, data) {
    
    if(err) return res.send(500,err);
    
    // Get only first calendar
    var calendar = data.items[0];
    if(calendar) {
      output.name = calendar.summary;

      // Asynchronously access events
      google_calendar.listEvent(access_token, calendar.id, function(err, events) {
        if(err || !events || !events.items) {
          console.log(err);
          return;
        }

        // Populate events
        events.items.forEach(function(event) {
          output.events.push(event);
        });

        // Return JSON object
        return res.send(output);
      });
    }

    return;
  });
  
});