/*
 * GET home page.
 */

exports.index = function(req, res){
    res.render("webapp.hbs", {
        "conferenceCode": req.query['conferenceCode']
    });
};
