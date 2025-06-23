// ignore_for_file: unused_field, must_be_immutable

import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/widgets/loan_ac_dtls_widget.dart';
import 'package:bseccs/widgets/loan_statement_dtls.dart';
import 'package:bseccs/widgets/loan_trans_widget.dart';
import 'package:bseccs/widgets/stf_text_widget.dart';

class LoanDtls extends StatefulWidget {
  LoanDtls(
      {super.key,
      required this.loanId,
      required this.acctype,
      required this.accNum,
      required this.prinAmt,
      required this.intAmt,
      required this.bankId});
  String? loanId;
  String? acctype;
  String? accNum;
  String? prinAmt;
  String? intAmt;
  String? bankId;

  @override
  State<LoanDtls> createState() => _LoanDtlsState();
}

class _LoanDtlsState extends State<LoanDtls>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final ThemeModel _themeModel = ThemeModel();
  final int _currentIndex = 0;
  late TabController _tabController;
  String? _showAccNum;
  String? _actualAccNum;
  final bool _showAccNumFlag = false;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
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
    double cWidth = MediaQuery.of(context).size.width * 1.0;
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
            width: cWidth,
            decoration: BoxDecoration(color: _themeModel.lightPrimaryColor),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 20, right: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
                      child: Text(
                        widget.acctype.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                        softWrap: true,
                        maxLines: 3,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                        width: (size.width - 90) * 0.7,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: StateFulTextWidget(accNum: widget.loanId))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 15, right: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
                      child: const Text(
                        'Closing Balance',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        softWrap: true,
                        maxLines: 3,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                        width: (size.width - 90) * 0.6,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.currency_rupee_outlined,
                              size: 15,
                              color: Colors.white,
                            ),
                            Text(
                              int.parse(widget.prinAmt.toString())
                                  .toStringAsFixed(2),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 15, right: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.4,
                      child: const Text(
                        'Interest',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        softWrap: true,
                        maxLines: 3,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                        width: (size.width - 90) * 0.6,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.currency_rupee_outlined,
                              size: 15,
                              color: Colors.white,
                            ),
                            Text(
                              widget.intAmt.toString() != 'null'
                                  ? int.parse(widget.intAmt.toString())
                                      .toStringAsFixed(2)
                                  : '0',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: SizedBox(
                height: 45,
                child: TabBar(
                    controller: _tabController,
                    unselectedLabelColor: Colors.black,
                    unselectedLabelStyle:
                        const TextStyle(fontSize: 10, color: Colors.black),
                    labelStyle: const TextStyle(fontSize: 14),
                    labelColor: _themeModel.lightIconTextColor,
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    indicatorColor: _themeModel.lightPrimaryColor,
                    tabs: const [
                      Tab(
                        text: 'Transaction Details',
                      ),
                      Tab(
                        text: 'Account Details',
                      ),
                      Tab(
                        text: 'View Statement',
                      ),
                    ])),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: TabBarView(
            controller: _tabController,
            children: [
              TransDtls(
                LoanId: widget.loanId,
                bankId: widget.bankId,
              ),
              AccountDtls(
                loanId: widget.loanId,
                accId: widget.accNum,
                bankId: widget.bankId,
              ),
              StatementDtls(
                loanId: widget.loanId,
                accNum: widget.accNum,
                acctype: widget.acctype,
                intAmt: widget.intAmt,
                prinAmt: widget.prinAmt,
                bankId: widget.bankId,
              )
            ],
          )),
        ],
      ),
    );
  }
}
