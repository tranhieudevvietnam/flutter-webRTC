const meetingHelper = require("./utils/meeting-helper");
const { MeetingPayloadEnum } = require("./utils/meeting-payload.enum");

function parserMessage(message) {
  try {
    const payload = JSON.parse(message);
    return payload;
  } catch (error) {
    return { type: MeetingPayloadEnum.UNKNOWN };
  }
}

function listenMessage(meetingId, socket, meetingServer) {
  socket.on("message", (message) =>
    handleMessage(meetingId, socket, message, meetingServer)
  );
}

function handleMessage(meetingId, socket, message, meetingServer) {
  // console.log(`handleMessage - meetingId: ${meetingId}`);

  var payload = "";
  if (typeof message === "string") {
    payload = parserMessage(message);
    // console.log(`handleMessage: ${message}`);
  } else {
    payload = message;
  }

  switch (payload.type) {
    case MeetingPayloadEnum.JOIN_MEETING:
      // console.log("MeetingPayloadEnum.JOINED_MEETING");
      meetingHelper.joinMeeting(meetingId, socket, payload, meetingServer);
      break;
    case MeetingPayloadEnum.CONNECTION_REQUEST:
      meetingHelper.forwardConnectionRequest(
        meetingId,
        socket,
        meetingServer,
        payload
      );
      break;
    case MeetingPayloadEnum.OFFER_SDP:
      meetingHelper.forwardOfferSDP(meetingId, socket, meetingServer, payload);
      break;
    case MeetingPayloadEnum.ANSWER_SDP:
      meetingHelper.forwardAnswerSDP(meetingId, socket, meetingServer, payload);
      break;
    case MeetingPayloadEnum.ICECANDIDATE:
      meetingHelper.forwardIceCandidate(
        meetingId,
        socket,
        meetingServer,
        payload
      );
      break;
    case MeetingPayloadEnum.LEAVE_MEETING:
      meetingHelper.userLeft(meetingId, socket, meetingServer, payload);
      break;
    case MeetingPayloadEnum.END_MEETING:
      meetingHelper.endMeeting(meetingId, socket, meetingServer, payload);
      break;
    case MeetingPayloadEnum.VIDEO_TOGGLE:
    case MeetingPayloadEnum.AUDIO_TOGGLE:
      meetingHelper.forwardEvent(meetingId, socket, meetingServer, payload);
      break;
    case MeetingPayloadEnum.UNKNOWN:
      // meetingHelper.forwardEvent(meetingId, socket, meetingServer, payload);
      break;

    default:
      break;
  }
}

function initMeetingServer(server) {
  const meetingServer = require("socket.io")(server);

  meetingServer.on("connection", (socket) => {
    const meetingId = socket.handshake.query.id;
    console.log("connection socket");
    listenMessage(meetingId, socket, meetingServer);
  });
}

module.exports = {
  initMeetingServer,
};
