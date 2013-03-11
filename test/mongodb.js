var Db = require('mongodb').Db
  , Connection = require('mongodb').Connection
  , Server = require('mongodb').Server
  , format = require('util').format;

//var host = process.env['MONGO_NODE_DRIVER_HOST'] != null ? process.env['MONGO_NODE_DRIVER_HOST'] : 'localhost';
//var port = process.env['MONGO_NODE_DRIVER_PORT'] != null ? process.env['MONGO_NODE_DRIVER_PORT'] : Connection.DEFAULT_PORT;
var host = "ds033877.mongolab.com:33877/merkel";

console.log("Connecting to " + host);
Db.connect(format("mongodb://%s", host), function(err, db) {
  db.dropDatabase(function(err, result) {
    db.collection('test', function(err, collection) {      
      // Erase all records from the collection, if any
      collection.remove({}, function(err, result) {
        // Insert 3 records
        for(var i = 0; i < 3; i++) {
          collection.insert({'a':i}, {w:0});
        }
        
        collection.count(function(err, count) {
          console.log("There are " + count + " records in the test collection. Here they are:");

          collection.find().each(function(err, item) {
            if(item != null) {
              console.dir(item);
              console.log("created at " + new Date(item._id.generationTime) + "\n")
            }

            // Null signifies end of iterator
            if(item == null) {                
              // Destory the collection
              collection.drop(function(err, collection) {
                db.close();
              });
            }
          });
        });
      });      
    });
  });
});