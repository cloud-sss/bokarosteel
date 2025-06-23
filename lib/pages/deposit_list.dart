// ignore_for_file: must_be_immutable, unused_local_variable, unused_field, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/widgets/deposit_ac_dtls_widget.dart';
import 'package:bseccs/widgets/deposit_statement_dtls.dart';
import 'package:bseccs/widgets/deposit_trans_widget.dart';
import 'package:bseccs/widgets/stf_text_widget.dart';

class DepositDtls extends StatefulWidget {
  DepositDtls(
      {super.key,
      required this.acc_num,
      required this.acc_type,
      required this.acc_name,
      required this.curr_bal,
      required this.bank_id,
      required this.ac_flag,
      required this.cust_cd});
  String? acc_num;
  String? acc_type;
  String? acc_name;
  String? curr_bal;
  String? bank_id;
  String? ac_flag;
  String? cust_cd;

  @override
  State<DepositDtls> createState() => _DepositDtlsState();
}

class _DepositDtlsState extends State<DepositDtls>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final ThemeModel _themeModel = ThemeModel();
  final int _currentIndex = 0;
  late TabController _tabController;
  late List<Tab> _tabs;
  late List<Widget> _tabViews;

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 3, vsync: this);
    // _tabController =
    //     TabController(length: widget.ac_flag == 'TF' ? 3 : 2, vsync: this);

    _tabs = [
      const Tab(text: 'Transaction Details'),
      const Tab(text: 'Statement')
    ];

    _tabViews = [
      TransDtls(
        accNum: widget.acc_num,
        accType: widget.acc_type,
        bankId: widget.bank_id,
        ac_flag: widget.ac_flag,
        cust_cd: widget.cust_cd,
      ),
      StatementDtls(
        accNum: widget.acc_num,
        acctype: widget.acc_name,
        acctypeID: widget.acc_type,
        currAmt: widget.curr_bal,
        bankId: widget.bank_id,
        ac_flag: widget.ac_flag,
      ),
    ];
    if (widget.ac_flag == 'D') {
      _tabs.add(
        const Tab(text: 'Account Details'),
      );
      _tabViews.add(
        AccountDtls(
          accNum: widget.acc_num,
          accType: widget.acc_type,
          accTypeName: widget.acc_name,
          bankId: widget.bank_id,
        ),
      );
    }
    // if (widget.ac_flag == 'TF') {
    //   _tabs.add(const Tab(text: 'Statement'));
    // }

    _tabController = TabController(length: _tabs.length, vsync: this);

    WidgetsBinding.instance.addObserver(this);

    // print(widget.acc_num);
    // print(widget.acc_type);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _tabController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      dialogModel.sessionTimeOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double c_width = MediaQuery.of(context).size.width * 1.0;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: _themeModel.lightIconColor)),
      // drawer: const navigationDrawer(),
      body: Column(
        children: [
          Container(
            height: 150,
            width: c_width,
            //decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            decoration: BoxDecoration(color: _themeModel.lightPrimaryColor),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 35, 35, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.acc_name.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          softWrap: true,
                        ),
                      ),
                      StateFulTextWidget(accNum: widget.acc_num.toString()),
                      // Text(
                      //   widget.acc_num.toString(),
                      //   style:
                      //       const TextStyle(color: Colors.white, fontSize: 20),
                      // ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Balance',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.currency_rupee_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                          Text(
                            int.parse(widget.curr_bal.toString())
                                .toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: SizedBox(
                  height: 45,
                  // decoration: BoxDecoration(
                  //     color: Colors.grey[300],
                  //     borderRadius: BorderRadius.circular(25.0)),
                  child: TabBar(
                    controller: _tabController,
                    unselectedLabelColor: Colors.black,
                    unselectedLabelStyle:
                        const TextStyle(fontSize: 10, color: Colors.black),
                    labelStyle: const TextStyle(fontSize: 14),
                    labelColor: _themeModel.lightIconColor,
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    indicatorColor: _themeModel.lightPrimaryColor,
                    tabs: _tabs,
                  ))
              // tabs: [
              //   const Tab(text: 'Transaction Details'),
              //   if (widget.ac_flag == 'D')
              //     const Tab(text: 'Account Details'),
              //   const Tab(text: 'Statement'),
              // ])),
              // tabs: const [
              //   Tab(
              //     text: 'Transaction Details',
              //   ),
              //   Tab(
              //     text: 'Account Details',
              //   ),
              //   Tab(
              //     text: 'Statement',
              //   ),
              // ])),
              ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: TabBarView(controller: _tabController, children: _tabViews
                  //  [
                  //   TransDtls(
                  //     accNum: widget.acc_num,
                  //     accType: widget.acc_type,
                  //     bankId: widget.bank_id,
                  //     ac_flag: widget.ac_flag,
                  //     cust_cd: widget.cust_cd,
                  //   ),
                  //   if (widget.ac_flag == 'D')
                  //     AccountDtls(
                  //       accNum: widget.acc_num,
                  //       accType: widget.acc_type,
                  //       accTypeName: widget.acc_name,
                  //       bankId: widget.bank_id,
                  //     ),
                  //   StatementDtls(
                  //     accNum: widget.acc_num,
                  //     acctype: widget.acc_name,
                  //     acctypeID: widget.acc_type,
                  //     currAmt: widget.curr_bal,
                  //     bankId: widget.bank_id,
                  //   ),
                  // ],
                  )),
        ],
      ),
    );
  }
}
