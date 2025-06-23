import 'package:bseccs/models/masterModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ConnectSocket {
  static IO.Socket? socket;
  static initConnection() {
    socket =
        IO.io(Uri.parse(MasterModel.SocketURL).toString(), <String, dynamic>{
      "transports": ["websocket"],
      'forceNew': true
    });
    socket!.connect();
    socket!.onConnect((data) => print('socket connected'));
  }

  static socketEmit(String event) async {
    socket!.emit(event, '');
  }

  static Future<dynamic> socketOn(String event) async {
    var data;
    socket!.on(event, (result) async {
      data = await result['suc'] > 0 ? result['msg'] : [];
      return data;
    });
  }
}
