// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/pages/branchInfo.dart';
import 'package:bseccs/pages/dashboard.dart';
import 'package:bseccs/pages/demand.dart';
import 'package:bseccs/pages/deposit_dashboard.dart';
import 'package:bseccs/pages/emi_calculator.dart';
import 'package:bseccs/pages/loan_dashboard.dart';
import 'package:bseccs/pages/more_index_page.dart';
// import 'package:bseccs/pages/notification_home.dart';
import 'package:bseccs/pages/transaction/view.dart';
// import 'package:bseccs/pages/request_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ThemeModel _themeModel = ThemeModel();

  final String _userName = sharedPrefModel.getUserData('user_name');
  final String _custId = sharedPrefModel.getUserData('cust_id');
  final String _lastLogin = sharedPrefModel.getUserData('lastLogin');
  final String _phoneNo = sharedPrefModel.getUserData('phone_no');
  final String _bankId = sharedPrefModel.getUserData('bank_id');
  final String _bankName = sharedPrefModel.getUserData('bank_name');
  final String view_flag = sharedPrefModel.getUserData('view_flag');

  final String first_login_submit =
      sharedPrefModel.getUserData('first_login_submit');

  @override
  void initState() {
    if (int.parse(first_login_submit) > 0) {
      UpdateLoginTime();
      sharedPrefModel.removeUserData('first_login_submit');
      sharedPrefModel.setUserData('first_login_submit', '0');
    }
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  // ignore: non_constant_identifier_names
  Future<void> UpdateLoginTime() async {
    var map = <String, dynamic>{};
    map['phone_no'] = _phoneNo;
    await MasterModel.globalApiCall(1, '/update_login_time', map);
  }

  Widget depositWidget(context) {
    return Container(
      height: 90,
      width: 120,
      decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const DepositDashboard();
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              const AssetImage('assets/deposit.png'),
              size: 50,
              color: _themeModel.lightIconColor,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Deposits',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: _themeModel.lightIconTextColor),
            )
          ],
        ),
      ),
    );
  }

  Widget LoanWidget(context) {
    return Container(
      height: 90,
      width: 120,
      decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const LoanDashboard();
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              const AssetImage('assets/loan.png'),
              size: 50,
              color: _themeModel.lightIconColor,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Loans',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: _themeModel.lightIconTextColor),
            )
          ],
        ),
      ),
    );
  }

  Widget moreWidget(context) {
    return Container(
      height: 90,
      width: 120,
      decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const MoreHome();
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              const AssetImage('assets/more.png'),
              size: 50,
              color: _themeModel.lightIconColor,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'More',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: _themeModel.lightIconTextColor),
            )
          ],
        ),
      ),
    );
  }

  Widget demandWidget(context) {
    return Container(
      height: 90,
      width: 120,
      decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const DemandDetails();
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              const AssetImage('assets/demand.png'),
              size: 50,
              color: _themeModel.lightIconColor,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Demand',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: _themeModel.lightIconTextColor),
            )
          ],
        ),
      ),
    );
  }

  Widget notificationWidget(context) {
    return Container(
      height: 90,
      width: 120,
      decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return Dashboard(
              navSlNo: 2,
            );
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              const AssetImage('assets/ringing.png'),
              size: 50,
              color: _themeModel.lightIconColor,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Notification',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: _themeModel.lightIconTextColor),
            )
          ],
        ),
      ),
    );
  }

  Widget uploadTransactionWidget(context) {
    return Container(
      height: 90,
      width: 120,
      decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const TransactionView();
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              const AssetImage('assets/transaction.png'),
              size: 50,
              color: _themeModel.lightIconColor,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Transaction',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: _themeModel.lightIconTextColor),
            )
          ],
        ),
      ),
    );
  }

  Widget calenderWidget(context) {
    return Container(
      height: 90,
      width: 120,
      decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return Dashboard(
              navSlNo: 1,
            );
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              const AssetImage('assets/calendar.png'),
              size: 50,
              color: _themeModel.lightIconColor,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Calendar',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: _themeModel.lightIconTextColor),
            )
          ],
        ),
      ),
    );
  }

  Widget calculatorWidget(context) {
    return Container(
      height: 115,
      width: 120,
      decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return const EmiCalculator();
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              const AssetImage('assets/calculator.png'),
              size: 50,
              color: _themeModel.lightIconColor,
            ),
            const SizedBox(
              height: 6,
            ),
            Text('TD/RD Calculator',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    color: _themeModel.lightIconTextColor),
                softWrap: true,
                textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }

  Widget bankInfoWidget({context, bankId}) {
    return Container(
      height: 90,
      width: 120,
      decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
        const BoxShadow(
          color: Colors.white,
          offset: Offset(0.0, 0.0),
          blurRadius: 0.0,
          spreadRadius: 0.0,
        ),
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return BranchInfo(bankId: bankId);
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ImageIcon(
            //   const AssetImage('assets/info.jpg'),
            //   size: 50,
            //   color: _themeModel.lightIconColor,
            // ),
            Icon(
              Icons.info_outline_rounded,
              size: 50,
              color: _themeModel.lightIconColor,
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              'Bank Info',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  color: _themeModel.lightIconTextColor),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 1.0;
    return ListView(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                width: c_width,
                decoration: BoxDecoration(color: _themeModel.lightPrimaryColor),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        _bankName,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Hello, ${_userName.toString()}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Last login: ${_lastLogin != "" ? DateFormat('kk:mm, d MMM y').format(DateTime.parse(_lastLogin.toString())) : ''}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      // const Text(
                      //   'App Version - 0.1',
                      //   style: TextStyle(color: Colors.white, fontSize: 15),
                      // )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          depositWidget(context),
                          LoanWidget(context)
                        ]),
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // calenderWidget(context),
                          demandWidget(context),
                          uploadTransactionWidget(context)
                        ]),
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        moreWidget(context),
                        notificationWidget(context)
                        // bankInfoWidget(context: context, bankId: _bankId)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
