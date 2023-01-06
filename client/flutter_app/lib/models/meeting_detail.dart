class MeetingDetail {
  final String? id;
  final String? hostId;
  final String? hostName;

  MeetingDetail({this.id, this.hostId, this.hostName});

  factory MeetingDetail.fromJson(dynamic json) {
    return MeetingDetail(
        id: json["id"], hostId: json["hostId"], hostName: json["hostName"]);
  }
}
