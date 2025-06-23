// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
// import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/socketConnectModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/calendar.dart';
import 'package:bseccs/pages/home.dart';
import 'package:bseccs/pages/notification_home.dart';
// import 'package:bseccs/pages/profile.dart';
import 'package:bseccs/widgets/navDrawWidget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Dashboard extends StatefulWidget {
  Dashboard({super.key, required this.navSlNo});
  int navSlNo;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  final ThemeModel _themeModel = ThemeModel();

  int _currentIndex = 0;
  int counter = 0;

  String? userId = sharedPrefModel.getUserData('phone_no').toString();
  String? bankId = sharedPrefModel.getUserData('bank_id').toString();

  List<NotificationModel> notifications = [];

  var pages = [];

  late IO.Socket? _socket = ConnectSocket.socket;
  // ignore: unused_element
  _connectSocket() {
    print(" Trying to connect to socket at http://192.168.1.60:3011");
    _socket = IO.io(Uri.parse(MasterModel.SocketURL), <String, dynamic>{
      "transports": ["websocket"],
      'forceNew': true
    });
    _socket!.connect();
    _socket!.onConnect((data) {
      // print('socket connected');
      _getNotification();
    });
    _socket!.onConnectError(
        (err) => dialogModel.showToast('Connection error $err'));
    _socket!.onDisconnect(
        (data) => dialogModel.showToast('Socket is disconnected'));
  }

  _getNotification() {
    var map = {};
    map['bank_id'] = bankId;
    _socket!.emit('notification', map);
    // Call Api When socket is connected
    _socket!.on('notification', (response) {
      dialogModel.showLoading();
      counter = 0;
      // print(response);
      // late String notiCount = storeLocalStorage.getUserData('notiCount');
      // int nowNotiCount =
      //     response['suc'].toString() == '1' ? response['msg'].length : 0;
      // if (nowNotiCount > 0) {
      if (response["suc"].toString() != '0') {
        if (mounted) {
          setState(() {
            notifications = (response['msg'] as List)
                .map((item) => NotificationModel.fromJson(item))
                .where((notification) =>
                    notification.sendUserId == userId ||
                    notification.sendUserId == 'all')
                .toList();
            print('Updated notifications in Dashboard: $notifications');
          });
        }
        print('Parsed notifications: $notifications');
        response["msg"].forEach((element) {
          // print(element);
          setState(() {
            if ((element['SEND_USER_ID'].toString() == userId ||
                    element['SEND_USER_ID'].toString() == 'all') &&
                element['VIEW_FLAG'] != 'Y') {
              counter += 1;
            }
          });
        });
      }
      // }
      dialogModel.dismissLoading();
    });
  }

  @override
  void initState() {
    _currentIndex = widget.navSlNo;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getNotification();
    // Initialize NotificationService once
    // _notificationService = NotificationService((receivedNotifications) {
    //   // setState(() {
    //     _notifications = receivedNotifications;
    //   // });
    // });
    // setState(() {
    pages = [
      const Home(),
      const Calendar(),
      NotificationHome(
        notifications: notifications,
      )
    ];
    // });
    // FlutterRingtonePlayer.playNotification();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    // Rebuild NotificationHome with the updated notifications list
    pages[2] = NotificationHome(notifications: notifications);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      dialogModel.sessionTimeOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: _themeModel.navLogoImage,
          actions: [
            IconButton(
                onPressed: () {
                  dialogModel.logOutDialog(context);
                },
                icon: Icon(
                  Icons.power_settings_new_rounded,
                  color: _themeModel.lightIconColor,
                ))
          ],
          iconTheme: IconThemeData(color: _themeModel.lightIconColor)),
      drawer: navigationDrawer(),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        selectedItemColor: const Color.fromARGB(255, 255, 153, 0),
        unselectedItemColor: _themeModel.lightIconColor,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home), tooltip: 'Home', label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              tooltip: 'Calendar',
              label: 'Calendar'),
          BottomNavigationBarItem(
              // icon: Icon(Icons.notifications_none),
              icon: Stack(children: [
                const Icon(Icons.notifications_none_outlined),
                if (counter > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(237, 9, 79, 159),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$counter',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ]),
              tooltip: 'Notification',
              label: 'Notification')
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class MountedState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
