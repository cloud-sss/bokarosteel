// ignore_for_file: file_names, camel_case_types, unused_element, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/pages/login.dart';
import 'package:bseccs/widgets/stf_text_widget.dart';

class dialogModel {
  static void showToast(String narration) async {
    // for (var i = 0; i < 7; i++) {
    SmartDialog.showToast(narration, displayType: SmartToastType.onlyRefresh);
    await Future.delayed(const Duration(milliseconds: 2000));
    // }
  }

  void _show() async {
    SmartDialog.show(builder: (_) {
      return Container(
        height: 80,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: const Text(
          'easy custom dialog',
          style: TextStyle(color: Colors.white),
        ),
      );
    });
  }

  static void showLoading() async {
    SmartDialog.showLoading();
  }

  static void dismissLoading() async {
    SmartDialog.dismiss();
  }

  static Future<dynamic> logOutDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // title: const Text('Enter Your Mobile Number'),
        content: SizedBox(
          height: 95,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Are you sure you want to logout?'),
                // Text((MediaQuery.of(context).size.width / 4)
                //     .toString()),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 2.0,
                        textStyle: const TextStyle(color: Colors.white),
                        minimumSize:
                            Size((MediaQuery.of(context).size.width / 3.5), 40),
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        sharedPrefModel.removeUserData('cust_id');
                        sharedPrefModel.removeUserData('bank_id');
                        sharedPrefModel.removeUserData('view_flag');
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const Login();
                        }), (route) => false);
                        return;
                      },
                      // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(237, 9, 79, 159),
                        elevation: 2.0,
                        textStyle: const TextStyle(color: Colors.white),
                        minimumSize:
                            Size((MediaQuery.of(context).size.width / 3.5), 40),
                      ),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }

  static Future<dynamic> sessionTimeOut(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // title: const Text('Enter Your Mobile Number'),
        content: SizedBox(
          height: 195,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Session Timeout Alert',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(
                  height: 20,
                ),
                const TimerText(),
                // Text((MediaQuery.of(context).size.width / 4)
                //     .toString()),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(237, 9, 79, 159),
                    elevation: 2.0,
                    textStyle: const TextStyle(color: Colors.white),
                    // minimumSize:
                    //     Size((MediaQuery.of(context).size.width / 3.5), 40),
                    fixedSize:
                        Size((MediaQuery.of(context).size.width / 2.5), 40),
                  ),
                  child: const Text('Keep me logged in'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    sharedPrefModel.removeUserData('cust_id');
                    sharedPrefModel.removeUserData('bank_id');
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const Login();
                    }), (route) => false);
                    return;
                  },
                  // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 2.0,
                    textStyle: const TextStyle(color: Colors.white),
                    // minimumSize:
                    //     Size((MediaQuery.of(context).size.width / 3.5), 40),
                    fixedSize:
                        Size((MediaQuery.of(context).size.width / 2.5), 40),
                  ),
                  child: const Text('Logout'),
                ),
              ]),
        ),
      ),
    );
  }
}
