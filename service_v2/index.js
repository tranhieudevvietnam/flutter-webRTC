const express = require("express");
const app = express();

const http = require("http");
const server = http.createServer(app);
const { initSocketServer } = require("./socket-server");
var os = require("os");
var networkInterfaces = os.networkInterfaces();

initSocketServer(server);

app.use(express.json());
// app.use("/api", require("./routes/app.routes"));
// app.use("/");
server.listen(process.env.port || 4000, function () {
  console.log(
    `Ready to go!!! port: 4000 => http://${networkInterfaces["en1"][1]["address"]}:4000`
  );
});
