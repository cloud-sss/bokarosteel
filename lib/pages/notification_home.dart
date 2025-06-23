// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/socketConnectModel.dart';
import 'package:bseccs/widgets/notificationShowWidget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationModel {
  final int slNo;
  final String narration;
  final String sendUserId;
  final String viewFlag;
  final DateTime createdDt;

  NotificationModel({
    required this.slNo,
    required this.narration,
    required this.sendUserId,
    required this.viewFlag,
    required this.createdDt,
  });

  // Factory method to create a NotificationModel from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      slNo: json['SL_NO'],
      narration: json['NARRATION'],
      sendUserId: json['SEND_USER_ID'],
      viewFlag: json['VIEW_FLAG'],
      createdDt: DateTime.parse(json['CREATED_DT']),
    );
  }

  // Method to convert a NotificationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'SL_NO': slNo,
      'NARRATION': narration,
      'SEND_USER_ID': sendUserId,
      'VIEW_FLAG': viewFlag,
      'CREATED_DT': createdDt.toIso8601String(),
    };
  }
}

class NotificationHome extends StatefulWidget {
  const NotificationHome({super.key, required this.notifications});
  final List<NotificationModel> notifications;

  @override
  State<NotificationHome> createState() => _NotificationHomeState();
}

class _NotificationHomeState extends State<NotificationHome> {
  // List<dynamic> notifications = [];
  String? userId = sharedPrefModel.getUserData('phone_no').toString();
  String bankId = sharedPrefModel.getUserData('bank_id');
  // late final StreamController<int> controller;
  var data;
  late final IO.Socket? _socket = ConnectSocket.socket;

  _setNotification(data) async {
    _socket!.emit('redu_noti_cnt', data);
    _socket?.on('redu_noti_cnt', (data) {});
    //print(data);
  }

  @override
  Widget build(BuildContext context) {
    return widget.notifications.isEmpty
        ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'No Notification Yet',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              )
            ],
          )
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            itemCount: widget.notifications.length,
            itemBuilder: (contex, index) {
              var notification = widget.notifications[index];
              return Card(
                color: notification.viewFlag != 'Y'
                    ? Colors.white
                    : Colors.grey.shade200,
                child: ListTile(
                  onTap: () {
                    var messageJson = {
                      "message": notification.slNo,
                      "sendByMe": userId.toString(),
                      "bank_id": bankId
                    };
                    _setNotification(messageJson);
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return ShowNotification(
                              date: DateFormat('d MMM y')
                                  .format(notification.createdDt)
                                  .toString(),
                              narration: notification.narration.toString(),
                              key: UniqueKey());
                        });
                  },
                  leading: Container(
                    height: 45,
                    width: 45,
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[50]),
                    child: const Icon(
                      Icons.notifications_none_outlined,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          notification.narration,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: notification.viewFlag != 'Y'
                                  ? Colors.black
                                  : Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      DateFormat('d MMM y')
                          .format(notification.createdDt)
                          .toString(),
                      style: TextStyle(
                          color: notification.viewFlag != 'Y'
                              ? const Color.fromARGB(237, 9, 79, 159)
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    ),
                  ),
                ),
              );
            });
  }
}
