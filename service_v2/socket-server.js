const { SocketStatusEnum } = require("./socket-status-enum");

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
  socket.on("deviceDisconnect", (message) => {
    var payload = parserMessage(message);
    const { deviceId, deviceName, model } = payload;
    const index = listDevices.findIndex(
      (device) => device.deviceId === deviceId
    );
    listDevices = listDevices.filter(
      (item) => item.deviceId !== listDevices[index].deviceId
    );

    // socket.emit("onDevices", JSON.stringify(listDevices));
    sendListDevices(socketServer);

    // socket.disconnect();
  });
  socket.on("disconnect", () => {
    console.log(`disconnect---> ${socket.id}`); // undefined
    const index = listDevices.findIndex(
      (device) => device.socketId === socket.id
    );
    if (index > -1) {
      listDevices = listDevices.filter(
        (item) => item.deviceId !== listDevices[index].deviceId
      );
      sendListDevices(socketServer);
    }
  });
  socket.on("deviceConnect", (message) => {
    var payload = parserMessage(message);
    const { deviceId, deviceName, model } = payload;
    const index = listDevices.findIndex(
      (device) => device.deviceId === deviceId
    );
    if (index > -1) {
      listDevices[index] = {
        socketId: socketId,
        deviceId: deviceId,
        deviceName: deviceName,
        model: model,
      };
    } else {
      listDevices.push({
        socketId: socketId,
        deviceId: deviceId,
        deviceName: deviceName,
        model: model,
      });
    }
    sendListDevices(socketServer);
  });
  socket.on("onChange", (message) => {
    var payload = parserMessage(message);
    const { type, deviceIdSender, deviceNameSender, deviceId } = payload;
    const itemData = getItemDataByDeviceId(deviceId);
    let count = -1;
    try {
      count = Object.keys(itemData).length;
    } catch (error) {
      console.log("error" + error);
    }
    if (itemData !== null && count >= 0) {
      const { deviceId, socketId } = itemData;

      sendOnChangeByDevice(socketServer, socketId, {
        type: type,
        data: {
          socketId: socketId,
          deviceId: deviceId,
          deviceIdSender: deviceIdSender,
          deviceName: deviceNameSender,
          sessionId: `${deviceIdSender}-${deviceId}`,
        },
      });
    } else {
      const itemData = getItemDataByDeviceId(deviceIdSender);
      const { socketId } = itemData;
      sendOnChangeByDevice(socketServer, socketId, {
        type: SocketStatusEnum.JOIN_FAILED,
        data: {},
      });
    }
  });
}

function getItemDataByDeviceId(deviceId) {
  try {
    const index = listDevices.findIndex(
      (device) => device.deviceId === deviceId
    );
    return listDevices[index];
  } catch (error) {
    return {};
  }
}

function sendListDevices(socketServer) {
  // console.log(`deviceConnect - length: ${listDevices.length}`);
  // console.log(`deviceConnect - length: ${JSON.stringify(listDevices)}`);
  // for (const item of listDevices) {
  //   const { deviceId, socketId, deviceName } = item;
  //   // console.log(`sendListDevices - item -> ${deviceName}`);
  //   socketServer.to(socketId).emit("onDevices", JSON.stringify(listDevices));
  // }
  socketServer.emit("onDevices", JSON.stringify(listDevices));
}

function sendOnChangeByDevice(socketServer, socketId, payload) {
  socketServer.to(socketId).emit("onChange", JSON.stringify(payload));
}

// function sendMessage(socket, payload) {
//   const { socketId } = parserMessage(payload);
//   socket.join(socketId);
//   // and then later
//   socket.to(socketId).emit(JSON.stringify(payload));
//   //   socket.send(JSON.stringify(payload));
// }

function initSocketServer(server) {
  const socketServer = require("socket.io")(server);
  socketServer.on("connection", async (socket) => {
    // const socketId = socket.handshake.query.id;
    const socketId = socket.id;
    listenMessage(socketId, socket, socketServer);
  });
}

module.exports = {
  initSocketServer,
};
