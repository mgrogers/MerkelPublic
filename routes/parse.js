var parse = require('node-parse-api').Parse;
var PARSE_APP_ID = "ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj";
var PARSE_MASTER_KEY = "AAOYtk81wI3iRJiXxgRfwblt1EUHVBlyvpS9m3QO";
var parseApp = new parse(PARSE_APP_ID, PARSE_MASTER_KEY);

exports.test = function(req, res) {
  parseApp.find('User', req.params.objectId, function (err, response) {
    console.log("Parse response for finding user: " + req.params.objectId + " - " + response);
    return res.send(response);
  });
}