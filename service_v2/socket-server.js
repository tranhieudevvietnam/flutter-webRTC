function parserMessage(message) {
  try {
    const payload = JSON.parse(message);
    return payload;
  } catch (error) {
    return {};
  }
}

var listDevices = [];

function listenMessage(socketId, socket, socketServer) {
  socket.on("message", (message) => {
    var payload = "";
    console.log(`listenMessage: ${message}`);
    if (typeof message === "string") {
      payload = parserMessage(message);
      console.log(`listenMessage: ${payload}`);
    } else {
      payload = message;
    }

    // sendMessage(socket, payload);
  });
}

function sendMessage(socket, payload) {
  const { socketId } = payload;
  socket.join(socketId);
  // and then later
  socket.to(socketId).emit(JSON.stringify(payload));
  //   socket.send(JSON.stringify(payload));
}

function initSocketServer(server) {
  const socketServer = require("socket.io")(server);
  socketServer.on("connection", async (socket) => {
    // const socketId = socket.handshake.query.id;
    const socketId = socket.id;
    // const socketId = await fetchUserId(socket);
    const { deviceId } = parserMessage(socket.handshake.query);
    console.log(`socket deviceId -> ${deviceId}`);
    console.log(`socket connected -> ${socketId}`);

    listenMessage(socketId, socket, socketServer);
    listDevices.push({
      socketId: socketId,
    });
    console.log(`List devices connect: ${listDevices.length} `);
  });
}

module.exports = {
  initSocketServer,
};
