var mongoose = require('mongoose');
var options = {'user':'bmw', 'pass':'stanfordcs210'}
mongoose.connect('ds033877.mongolab.com:33877/merkel');
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function callback () {
  // yay!
  console.log('Connected!');
  var kittySchema = mongoose.Schema({
    name: String
  });
  kittySchema.methods.speak = function () {
    var greeting = this.name
      ? "Meow name is " + this.name
      : "I don't have a name"
    console.log(greeting);
  }

  var Kitten = mongoose.model('Kitten', kittySchema);
  var fluffy = new Kitten({ name: 'fluffy' });
  fluffy.speak() // "Meow name is fluffy"
});
db.close(function() {
  console.log("Connection closed");
});