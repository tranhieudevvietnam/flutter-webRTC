const { meeting } = require("../models/meeting.model");
const { meetingUser } = require("../models/meeting-user.model");

async function getAllMeetingUsers(meetId, callBack) {
  meetingUser
    .find({ meetingId: meetId })
    .then((repo) => {
      return callBack(null, repo);
    })
    .catch((error) => {
      return callBack(error);
    });
}

async function startMeeting(params, callBack) {
  const meetingSchema = new meeting(params);
  meetingSchema
    .save()
    .then((repo) => {
      return callBack(null, repo);
    })
    .catch((error) => {
      return callBack(error);
    });
}

async function joinMeeting(params, callBack) {
  const meetingUserModel = new meetingUser(params);
  meetingUserModel
    .save()
    .then(async (repo) => {
      await meeting.findOneAndUpdate(
        { id: params.meetingId },
        { $addToSet: { meetingUsers: meetingUserModel } }
      );
      return callBack(null, repo);
    })
    .catch((error) => {
      return callBack(error);
    });
}

async function isMeetingPresent(meetingId, callBack) {
  meeting
    .findById(meetingId)
    .populate("meetingUsers", "MeetingUser")
    .then((repo) => {
      // console.log("isMeetingPresent -> success");
      if (!repo) callBack("Invalid Meeting Id");
      else callBack(null, true);
    })
    .catch((error) => {
      return callBack(error, false);
    });
}
async function checkMeetingExists(meetingId, callBack) {
  meeting
    .findById(meetingId)
    .populate("meetingUsers", "MeetingUser")
    .then((repo) => {
      if (!repo) callBack("Invalid Meeting Id");
      else callBack(null, repo);
    })
    .catch((error) => {
      return callBack(error, false);
    });
}
async function getMeetingUser(params, callBack) {
  const { meetingId, userId } = params;

  meetingUser
    .find({ meetingId, userId })
    .then((repo) => {
      return callBack(null, repo[0]);
    })
    .catch((error) => {
      return callBack(error);
    });
}
async function updateMeetingUser(params, callBack) {
  meetingUser
    .updateOne({ userId: params.userId }, { $set: params }, { new: true })
    .then((repo) => {
      return callBack(null, repo);
    })
    .catch((error) => {
      return callBack(error);
    });
}
async function getUserBySocketId(params, callBack) {
  const { meetingId, socketId } = params;

  meetingUser
    .find({ meetingId, socketId })
    .limit(1)
    .then((repo) => {
      return callBack(null, repo);
    })
    .catch((error) => {
      return callBack(error);
    });
}

module.exports = {
  checkMeetingExists,
  getAllMeetingUsers,
  getMeetingUser,
  getUserBySocketId,
  isMeetingPresent,
  joinMeeting,
  startMeeting,
  updateMeetingUser,
};
