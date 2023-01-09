const meetingServices = require("../services/meeting.service");
const { MeetingPayloadEnum } = require("../utils/meeting-payload.enum");

async function joinMeeting(meetingId, socket, payload, meetingServer) {
  const { userId, name } = payload.data;
  // console.log("joinMeeting......");

  meetingServices.isMeetingPresent(meetingId, async (error, results) => {
    if (error && !results) {
      sendMessage(socket, { type: MeetingPayloadEnum.NOT_FOUND });
    }
    if (results) {
      addUser(socket, { meetingId, userId, name }).then((results) => {
        if (results) {
          sendMessage(socket, {
            type: MeetingPayloadEnum.JOINED_MEETING,
            data: {
              userId,
            },
          });

          broadcastUsers(meetingId, socket, meetingServer, {
            type: MeetingPayloadEnum.USER_JOINED,
            data: {
              userId,
              name,
              ...payload.data,
            },
          });
        }
      });
    }
  });
}
function forwardConnectionRequest(meetingId, socket, meetingServer, payload) {
  const { userId, otherUserId, name } = payload.data;
  console.log(`xxxxx ${userId} - ${otherUserId} - ${name}`);

  var model = {
    meetingId: meetingId,
    userId: otherUserId,
  };

  meetingServices.getMeetingUser(model, (error, results) => {
    if (results) {
      var sendPayload = JSON.stringify({
        type: MeetingPayloadEnum.CONNECTION_REQUEST,
        data: {
          userId,
          name,
          ...payload.data,
        },
      });
      meetingServer.to(results.socketId).emit("message", sendPayload);
    }
  });
}
function forwardIceCandidate(meetingId, socket, meetingServer, payload) {
  const { userId, otherUserId, candidate } = payload.data;
  var model = {
    meetingId: meetingId,
    userId: otherUserId,
  };

  meetingServices.getMeetingUser(model, (error, results) => {
    if (results) {
      var sendPayload = JSON.stringify({
        type: MeetingPayloadEnum.ICECANDIDATE,
        data: {
          userId,
          candidate,
        },
      });
      meetingServer.to(results.socketId).emit("message", sendPayload);
    }
  });
}
function forwardOfferSDP(meetingId, socket, meetingServer, payload) {
  const { userId, otherUserId, sdp } = payload.data;
  var model = {
    meetingId: meetingId,
    userId: otherUserId,
  };

  meetingServices.getMeetingUser(model, (error, results) => {
    if (results) {
      var sendPayload = JSON.stringify({
        type: MeetingPayloadEnum.OFFER_SDP,
        data: {
          userId,
          sdp,
        },
      });
      meetingServer.to(results.socketId).emit("message", sendPayload);
    }
  });
}
function forwardAnswerSDP(meetingId, socket, meetingServer, payload) {
  const { userId, otherUserId, sdp } = payload.data;
  var model = {
    meetingId: meetingId,
    userId: otherUserId,
  };

  meetingServices.getMeetingUser(model, (error, results) => {
    if (results) {
      var sendPayload = JSON.stringify({
        type: MeetingPayloadEnum.ANSWER_SDP,
        data: {
          userId,
          sdp,
        },
      });
      meetingServer.to(results.socketId).emit("message", sendPayload);
    }
  });
}
function userLeft(meetingId, socket, meetingServer, payload) {
  const { userId } = payload.data;
  broadcastUsers(meetingId, socket, {
    type: MeetingPayloadEnum.USER_LEFT,
    data: {
      userId: userId,
    },
  });
}
function endMeeting(meetingId, socket, meetingServer, payload) {
  const { userId } = payload.data;
  broadcastUsers(meetingId, socket, {
    type: MeetingPayloadEnum.END_MEETING,
    data: {
      userId: userId,
    },
  });

  meetingServices.getAllMeetingUsers(meetingId, (error, results) => {
    for (let i = 0; i < results.length; i++) {
      const meetingUser = results[i];
      meetingServer.socket.connected[meetingUser.socketId].disconnect();
    }
  });
}
function forwardEvent(meetingId, socket, meetingServer, payload) {
  const { userId } = payload.data;
  broadcastUsers(meetingId, socket, {
    type: payload.type,
    data: {
      userId: userId,
      ...payload.data,
    },
  });
}

async function addUser(socket, { meetingId, userId, name }) {
  // console.log(`addUser: `);

  let promise = new Promise(function (resolve, reject) {
    meetingServices.getMeetingUser({ meetingId, userId }, (error, results) => {
      if (!results) {
        var model = {
          socketId: socket.id,
          meetingId: meetingId,
          userId: userId,
          name: name,
          joined: true,
          isAlive: true,
        };
        // console.log(`addUser: ${model}`);
        meetingServices.joinMeeting(model, (error, results) => {
          if (results) {
            resolve(true);
          }
          if (error) {
            reject(error);
          }
        });
      } else {
        meetingServices.updateMeetingUser(
          { userId: userId, socketId: socket.id },
          (error, results) => {
            if (results) {
              resolve(true);
            }
            if (error) {
              reject(error);
            }
          }
        );
      }
    });
  });
  return promise;
}

function sendMessage(socket, payload) {
  socket.send(JSON.stringify(payload));
}

function broadcastUsers(meetingId, socket, meetingServer, payload) {
  socket.broadcast.emit("message", JSON.stringify(payload));
}

module.exports = {
  joinMeeting,
  forwardConnectionRequest,
  forwardIceCandidate,
  forwardAnswerSDP,
  forwardOfferSDP,
  userLeft,
  endMeeting,
  forwardEvent,
};
