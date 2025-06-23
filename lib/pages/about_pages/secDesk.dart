// ignore_for_file: file_names, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';

class SecDesk extends StatefulWidget {
  const SecDesk({Key? key}) : super(key: key);

  @override
  State<SecDesk> createState() => _SecDeskState();
}

class _SecDeskState extends State<SecDesk> {
  final String heroImage = 'assets/sec_desk.svg';
  String bankId = sharedPrefModel.getUserData('bank_id');

  var data;
  Future<void> GetLoanDtls() async {
    var map = <String, dynamic>{};
    map['bank_id'] = bankId;
    var resDt = await MasterModel.globalApiCall(1, '/get_sec_desc', map);
    // print(resDt);
    resDt = jsonDecode(resDt.body);
    if (resDt['suc'] > 0) {
      data = resDt['msg'];
    } else {
      data = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('''Secretary's Desk'''),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[50]),
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 260,
                    child: SvgPicture.asset(
                      heroImage,
                      semanticsLabel: '''Secretary's Desk''',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Card(
                elevation: 1,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 419,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder(
                          future: GetLoanDtls(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // dialogModel.showLoading();
                              return const Column();
                            } else {
                              if (data['msg'] != '') {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '''${data["NARRATION"]}''',
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No data found.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                );
                              }
                            }
                          }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
