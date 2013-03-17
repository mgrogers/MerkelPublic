var Parse = require('node-parse-api').Parse;

APP_ID = "ljgVpGcSO3tJlAFRosuoGhLuWElPbWapt4Wy5uoj";
MASTER_KEY = "AAOYtk81wI3iRJiXxgRfwblt1EUHVBlyvpS9m3QO";
var app = new Parse(APP_ID, MASTER_KEY);
/*
 * GET home page.
 */

exports.index = function(req, res){
    res.render('index', { title: 'Express' });
};

exports.home = function(req, res){
    res.render('home', { title: 'Home'});
}