// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/dashboard.dart';
import 'package:bseccs/pages/deposit_dashboard.dart';
import 'package:bseccs/pages/loan_dashboard.dart';
import 'package:bseccs/pages/profile.dart';

class navigationDrawer extends StatelessWidget {
  navigationDrawer({super.key});
  final ThemeModel _themeModel = ThemeModel();

  final String view_flag = sharedPrefModel.getUserData('view_flag');

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                ),
                ListTile(
                  iconColor: _themeModel.lightIconColor,
                  textColor: _themeModel.lightTextColor,
                  leading: Icon(Icons.home,
                      size: 35, color: _themeModel.lightIconColor),
                  title: Text('Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        // color: _themeModel.lightIconTextColor
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : _themeModel.lightIconTextColor,
                      )),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      // sim -> SEND TO NEXT PAGE
                      return Dashboard(
                        navSlNo: 0,
                      );
                    }));
                  },
                ),
                const Divider(
                  color: Colors.black54,
                ),
                if (view_flag == 'A' || view_flag == 'D')
                  ListTile(
                    iconColor: _themeModel.lightIconColor,
                    textColor: _themeModel.lightIconTextColor,
                    leading: const ImageIcon(
                      AssetImage('assets/deposit.png'),
                      size: 35,
                    ),
                    title: Text('Deposit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : _themeModel.lightIconTextColor,
                        )),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        // sim -> SEND TO NEXT PAGE
                        return const DepositDashboard();
                      }));
                    },
                  ),
                if (view_flag == 'A' || view_flag == 'D')
                  const Divider(
                    color: Colors.black54,
                  ),
                if (view_flag == 'A' || view_flag == 'L')
                  ListTile(
                    iconColor: _themeModel.lightIconColor,
                    textColor: _themeModel.lightIconTextColor,
                    leading: const ImageIcon(
                      AssetImage('assets/loan.png'),
                      size: 35,
                    ),
                    title: Text('Loan',
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : _themeModel.lightIconTextColor,
                            fontWeight: FontWeight.w400)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        // sim -> SEND TO NEXT PAGE
                        return const LoanDashboard();
                      }));
                    },
                  ),
                if (view_flag == 'A' || view_flag == 'L')
                  const Divider(
                    color: Colors.black54,
                  ),
                ListTile(
                  iconColor: _themeModel.lightIconColor,
                  textColor: _themeModel.lightIconTextColor,
                  leading: Icon(
                    Icons.calendar_month_outlined,
                    size: 35,
                    color: _themeModel.lightIconColor,
                  ),
                  title: Text('Holiday Calendar',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : _themeModel.lightIconTextColor,
                          fontWeight: FontWeight.w400)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      // sim -> SEND TO NEXT PAGE
                      return Dashboard(
                        navSlNo: 1,
                      );
                    }));
                  },
                ),
                const Divider(
                  color: Colors.black54,
                ),
                ListTile(
                  iconColor: _themeModel.lightIconColor,
                  textColor: _themeModel.lightIconTextColor,
                  leading: Icon(
                    Icons.manage_accounts_outlined,
                    size: 35,
                    color: _themeModel.lightIconColor,
                  ),
                  title: Text('Profile Settings',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : _themeModel.lightIconTextColor,
                          fontWeight: FontWeight.w400)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      // sim -> SEND TO NEXT PAGE
                      return const Profile();
                    }));
                  },
                ),
                const Divider(
                  color: Colors.black54,
                ),
                // ListTile(
                //   iconColor: _themeModel.lightIconColor,
                //   textColor: _themeModel.lightIconTextColor,
                //   leading: Icon(
                //     Icons.notifications_none_outlined,
                //     size: 35,
                //     color: _themeModel.lightIconColor,
                //   ),
                //   title: const Text(
                //     'Notification',
                //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                //   ),
                //   onTap: () {
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (BuildContext context) {
                //       // sim -> SEND TO NEXT PAGE
                //       return Dashboard(
                //         navSlNo: 2,
                //       );
                //     }));
                //   },
                // ),
              ]),
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: [
                    const Divider(),
                    ListTile(
                        // leading: Icon(Icons.settings),
                        title: Text(
                      'App Version - 1.0',
                      style: TextStyle(color: _themeModel.lightIconTextColor),
                    )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
