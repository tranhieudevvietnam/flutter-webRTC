class DeviceModel {
  String? socketId;
  String? deviceId;
  String? deviceName;
  String? model;

  DeviceModel({this.socketId, this.deviceId, this.deviceName, this.model});

  DeviceModel.fromJson(Map<String, dynamic> json) {
    socketId = json['socketId'];
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    model = json['model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['socketId'] = socketId;
    data['deviceId'] = deviceId;
    data['deviceName'] = deviceName;
    data['model'] = model;
    return data;
  }
}
