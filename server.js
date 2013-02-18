var http = require("http");

function onRequest(request, response) {
  response.writeHead(200, {"Content-Type":
"text/plain"});
  response.write("Hello World");
  response.end();
}

var port = process.env.PORT || 8888

http.createServer(onRequest).listen(port);