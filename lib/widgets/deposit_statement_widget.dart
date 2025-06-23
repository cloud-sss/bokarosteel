// ignore_for_file: must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bseccs/models/themeModel.dart';

final ThemeModel _themeModel = ThemeModel();

class generateDemandAccType extends StatefulWidget {
  generateDemandAccType(
      {Key? key,
      required this.accType,
      required this.acctypeID,
      required this.accNum,
      required this.currAmt,
      required this.userName,
      required this.frmDt,
      required this.toDt,
      required this.custId,
      required this.data,
      required this.bankName})
      : super(key: key);
  String? accType;
  String? acctypeID;
  String? accNum;
  String? currAmt;
  String? userName;
  String? frmDt;
  String? toDt;
  String? custId;
  dynamic data;
  dynamic bankName;

  @override
  State<generateDemandAccType> createState() => _generateDemandAccTypeState();
}

class _generateDemandAccTypeState extends State<generateDemandAccType> {
  final columns = [
    'Opening Date',
    'Maturity Date',
    'Period',
    'Interest Rate',
    'Principal',
    'Lock Mode'
  ];
  // final users = widget.data;
  int? sortColumnIndex = 0;
  bool isAccending = false;

  get accountTypeID => widget.acctypeID;
  // print(accountTypeID) {
  //   // TODO: implement print
  //   throw UnimplementedError();
  // }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  List<DataRow> getRows(List<dynamic> users) => users.map((item) {
        if (accountTypeID == "5") {
          final cell = [
            DateFormat('d MMM y').format(DateTime.parse(item['OPENING_DT'])
                .add(const Duration(days: 1))),
            DateFormat('d MMM y').format(
                DateTime.parse(item['MAT_DT']).add(const Duration(days: 1))),
            item['DEP_PERIOD'].toString(),
            item['INTT_RT'].toString() != 'null'
                ? item['INTT_RT'].toStringAsFixed(2)
                : 0,
            item['PRN_AMT'].toString() != 'null'
                ? item['PRN_AMT'].toStringAsFixed(2)
                : 0,
            item['LOCK_MODE'].toString()
          ];
          return DataRow(cells: getCells(cell));
        } else {
          final cell = [
            DateFormat('d MMM y').format(DateTime.parse(item['OPENING_DT'])
                .add(const Duration(days: 1))),
            DateFormat('d MMM y').format(
                DateTime.parse(item['MAT_DT']).add(const Duration(days: 1))),
            item['DEP_PERIOD'].toString(),
            item['INTT_RT'].toString() != 'null'
                ? item['INTT_RT'].toStringAsFixed(2)
                : 0,
            item['BALANCE'].toString() != 'null'
                ? item['BALANCE'].toStringAsFixed(2)
                : 0,
            item['LOCK_MODE'].toString()
          ];
          return DataRow(cells: getCells(cell));
        }
      }).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.data.sort((data1, data2) => compareString(
          ascending,
          DateFormat('d MMM y').format(
              DateTime.parse(data1['OPENING_DT']).add(const Duration(days: 1))),
          DateFormat('d MMM y').format(DateTime.parse(data2['OPENING_DT'])
              .add(const Duration(days: 1)))));
    }
    setState(() {
      sortColumnIndex = columnIndex;
      isAccending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: _themeModel.lightIconColor)),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Center(
              //   child: Container(
              //     padding: const EdgeInsets.all(8.0),
              //     height: 72,
              //     child: const Image(image: AssetImage('assets/logo-bg.png')),
              //   ),
              // ),
              Center(
                child: Text(widget.bankName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Center(
                child: Text('Account Statement',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Center(
                  child: Text(
                      "From ${DateFormat('d MMM y').format(DateTime.parse(widget.frmDt.toString())).toString()} To ${DateFormat('d MMM y').format(DateTime.parse(widget.toDt.toString())).toString()}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ))),
              const SizedBox(height: 10),
              DataTable(
                headingTextStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                // for Heading Text Style
                dataTextStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                sortAscending: isAccending,
                sortColumnIndex: 0,
                columns: getColumns(columns),
                rows: getRows(widget.data),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class generateDailyDeposit extends StatefulWidget {
  generateDailyDeposit(
      {Key? key,
      required this.accType,
      required this.acctypeID,
      required this.accNum,
      required this.currAmt,
      required this.userName,
      required this.frmDt,
      required this.toDt,
      required this.custId,
      required this.data,
      required this.bankName})
      : super(key: key);
  String? accType;
  String? acctypeID;
  String? accNum;
  String? currAmt;
  String? userName;
  String? frmDt;
  String? toDt;
  String? custId;
  dynamic data;
  String? bankName;

  @override
  State<generateDailyDeposit> createState() => _generateDailyDepositState();
}

class _generateDailyDepositState extends State<generateDailyDeposit> {
  final columns = [
    'Date',
    'Remarks',
    'Paid',
    'Balance',
  ];
  // final users = widget.data;
  int? sortColumnIndex = 0;
  bool isAccending = false;

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  List<DataRow> getRows(List<dynamic> users) => users.map((item) {
        final cell = [
          DateFormat('d MMM y').format(
              DateTime.parse(item['PAID_DT']).add(const Duration(days: 1))),
          item['TRANS_TYPE'].toString() == 'D' ? 'Deposit' : 'Withdrawal',
          item['PAID_AMT'].toString() != 'null'
              ? item['PAID_AMT'].toStringAsFixed(2)
              : 0,
          item['BALANCE_AMT'].toString() != 'null'
              ? item['BALANCE_AMT'].toStringAsFixed(2)
              : 0,
        ];
        return DataRow(cells: getCells(cell));
      }).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.data.sort((data1, data2) => compareString(
          ascending,
          DateFormat('d MMM y').format(
              DateTime.parse(data1['PAID_DT']).add(const Duration(days: 1))),
          DateFormat('d MMM y').format(
              DateTime.parse(data2['PAID_DT']).add(const Duration(days: 1)))));
    }
    setState(() {
      sortColumnIndex = columnIndex;
      isAccending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: _themeModel.lightIconColor)),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Center(
              //   child: Container(
              //     padding: const EdgeInsets.all(8.0),
              //     height: 72,
              //     child: const Image(image: AssetImage('assets/logo-bg.png')),
              //   ),
              // ),
              Center(
                child: Text(widget.bankName.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Center(
                child: Text('Account Statement',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Center(
                  child: Text(
                      "From ${DateFormat('d MMM y').format(DateTime.parse(widget.frmDt.toString())).toString()} To ${DateFormat('d MMM y').format(DateTime.parse(widget.toDt.toString())).toString()}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ))),
              const SizedBox(height: 10),
              DataTable(
                headingTextStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                // for Heading Text Style
                dataTextStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                sortAscending: isAccending,
                sortColumnIndex: 0,
                columns: getColumns(columns),
                rows: getRows(widget.data),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class generateDemand extends StatefulWidget {
  generateDemand(
      {Key? key,
      required this.accType,
      required this.acctypeID,
      required this.accNum,
      required this.currAmt,
      required this.userName,
      required this.frmDt,
      required this.toDt,
      required this.custId,
      required this.data,
      required this.bankName})
      : super(key: key);
  String? accType;
  String? acctypeID;
  String? accNum;
  String? currAmt;
  String? userName;
  String? frmDt;
  String? toDt;
  String? custId;
  dynamic data;
  String bankName;

  @override
  State<generateDemand> createState() => _generateDemandState();
}

class _generateDemandState extends State<generateDemand> {
  final columns = [
    'Date',
    'Remarks',
    'DR',
    'CR',
    'Balance',
  ];
  // final users = widget.data;
  int? sortColumnIndex = 0;
  bool isAccending = false;

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  List<DataRow> getRows(List<dynamic> users) => users.map((item) {
        final cell = [
          DateFormat('d MMM y').format(
              DateTime.parse(item['TRANS_DT']).add(const Duration(days: 1))),
          item['PARTICULARS'],
          item['DR_AMT'].toString() != 'null'
              ? item['DR_AMT'].toStringAsFixed(2)
              : 0,
          item['CR_AMT'].toString() != 'null'
              ? item['CR_AMT'].toStringAsFixed(2)
              : 0,
          item['BALANCE'].toString() != 'null'
              ? item['BALANCE'].toStringAsFixed(2)
              : 0
        ];
        return DataRow(cells: getCells(cell));
      }).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      widget.data.sort((data1, data2) => compareString(
          ascending,
          DateFormat('d MMM y').format(
              DateTime.parse(data1['TRANS_DT']).add(const Duration(days: 1))),
          DateFormat('d MMM y').format(
              DateTime.parse(data2['TRANS_DT']).add(const Duration(days: 1)))));
    }
    setState(() {
      sortColumnIndex = columnIndex;
      isAccending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          iconTheme: IconThemeData(color: _themeModel.lightIconColor)),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Center(
              //   child: Container(
              //     padding: const EdgeInsets.all(8.0),
              //     height: 72,
              //     child: const Image(image: AssetImage('assets/logo-bg.png')),
              //   ),
              // ),
              Center(
                child: Text(widget.bankName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Center(
                child: Text('Account Statement',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Center(
                  child: Text(
                      "From ${DateFormat('d MMM y').format(DateTime.parse(widget.frmDt.toString())).toString()} To ${DateFormat('d MMM y').format(DateTime.parse(widget.toDt.toString())).toString()}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ))),
              const SizedBox(height: 10),
              DataTable(
                headingTextStyle: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                // for Heading Text Style
                dataTextStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                sortAscending: isAccending,
                sortColumnIndex: 0,
                columns: getColumns(columns),
                rows: getRows(widget.data),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
