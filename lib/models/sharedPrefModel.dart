// ignore_for_file: file_names, library_prefixes, avoid_print, prefer_typing_uninitialized_variables

import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// ignore: camel_case_types
class sharedPrefModel {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserData(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  static String getUserData(String key) =>
      _preferences!.getString(key).toString();

  static Future removeUserData(String key) async {
    await _preferences?.remove(key);
  }

  // static Future getUserData(String key) async {
  //   await _preferences?.getString(key);
  // }
}

// class ConnectSocket {
//   static IO.Socket? socket;
//   static initConnection() {
//     socket = IO.io("https://app.synergicbanking.in:3000", <String, dynamic>{
//       "transports": ["websocket"],
//       'forceNew': true
//     });
//     socket!.connect();
//     socket!.onConnect((data) => print('socket connected'));
//   }

//   static socketEmit(String event) async {
//     socket!.emit(event, '');
//   }

//   static Future<dynamic> socketOn(String event) async {
//     var data;
//     socket!.on(event, (result) async {
//       data = await result['suc'] > 0 ? result['msg'] : [];
//       return data;
//     });
//   }
// }
