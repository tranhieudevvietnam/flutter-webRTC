const mongoose = require("mongoose");

const meeting = mongoose.model(
  "Meeting",
  mongoose.Schema(
    {
      hostId: {
        type: String,
        required: true,
      },
      hostName: {
        type: String,
      },
      startTime: {
        type: Date,
      },
      meetingUsers: [
        {
          type: mongoose.Schema.Types.ObjectId,
          ref: "MeetingUser",
        },
      ],
    },
    {
      toJSON: {
        transform: function (doc, ret) {
          ret.id = ret._id.toString();
          delete ret.id;
          delete ret._id;
          delete ret.__v;
        },
      },
    },
    { timestamps: true }
  )
);

module.exports = {
  meeting,
};
