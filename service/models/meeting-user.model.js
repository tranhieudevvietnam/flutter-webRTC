const mongoose = require("mongoose");

const meetingUser = mongoose.model(
  "MeetingUser",
  mongoose.Schema(
    {
      socketId: {
        type: String,
      },
      meetingId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Meeting",
      },
      userId: {
        type: String,
        required: true,
      },
      name: {
        type: String,
      },
      joined: {
        type: Boolean,
      },
      isAlive: {
        type: Boolean,
      },
      startTime: {
        type: Date,
      },
    },
    { timestamps: true }
  )
);

module.exports = {
  meetingUser,
};
