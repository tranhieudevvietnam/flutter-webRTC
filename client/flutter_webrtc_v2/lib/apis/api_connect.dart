import 'package:socket_io_client/socket_io_client.dart' as IO;

class ApiConnect {
  final String url;
  IO.Socket? socket;
  ApiConnect(this.url);

  connect() async {
    try {
      socket = await _connectForSelfSignedCert(url);
    } catch (e) {
      rethrow;
    }
  }

  Future<IO.Socket> _connectForSelfSignedCert(url) async {
    try {
      IO.Socket socket = IO.io(url, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });
      socket.opts?.addAll({
        "query": {"deviceId": 11}
      });
      socket.onConnect((_) {
        print('connect');
        socket.emit('msg', 'test');
      });
      return socket;
    } catch (e) {
      rethrow;
    }
  }
}
