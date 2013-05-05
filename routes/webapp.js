/*
 * GET home page.
 */

exports.index = function(req, res){
    res.render("webapp.hbs", {
        "user": "Taylor"
    });
};
