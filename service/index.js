// const express = require("express");
// const app = express();
// const mongoose = require("mongoose");
// const { MONGO_DB_CONFIG } = require("./configs/app_config");

// const http = require("http");
// const server = http.createServer(app);

// const { initMeetingServer } = require("./meeting-server");

// initMeetingServer(server);
// //meeting-server
// //initMeetingServer(server)
// mongoose.set("strictQuery", false);
// mongoose.Promise = global.Promise;
// mongoose
//   .connect(MONGO_DB_CONFIG.DB, {
//     useNewUrlParser: true,
//     useUnifiedTopology: true,
//   })
//   .then(
//     () => {
//       console.log("Database Connected");
//     },
//     (error) => {
//       console.log("Database can't be connected");
//     }
//   );

// app.use(express.json());
// app.use("/api", require("./routes/app.routes"));
// server.listen(process.env.port || 4000, function () {
//   console.log(`Ready to go!!! port: 4000`);
// });
const express = require("express");
const app = express();
const mongoose = require("mongoose");
const { MONGO_DB_CONFIG } = require("./configs/app_config");

const http = require("http");
const server = http.createServer(app);

const { initMeetingServer } = require("./meeting-server");

const uri =
  "mongodb+srv://admin:Admin123@cluster0.uihgu.mongodb.net/?retryWrites=true&w=majority";

initMeetingServer(server);
//meeting-server
//initMeetingServer(server)

mongoose.set("strictQuery", false);
mongoose.Promise = global.Promise;
mongoose
  .connect(uri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(
    () => {
      console.log("Database Connecting");
    },
    (error) => {
      console.log(error);
      console.log("Database can't be connected");
    }
  );

mongoose.connection.on("connected", () => {
  console.log("Database Connected");
});

app.use(express.json());
app.use("/api", require("./routes/app.routes"));
server.listen(process.env.port || 4000, function () {
  console.log(`Ready to go!!! port: 4000`);
});
