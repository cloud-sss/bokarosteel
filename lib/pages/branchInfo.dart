// ignore_for_file: must_be_immutable, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';

class BranchInfo extends StatefulWidget {
  BranchInfo({super.key, required this.bankId});
  String bankId;

  @override
  State<BranchInfo> createState() => _BranchInfoState();
}

class _BranchInfoState extends State<BranchInfo> {
  var branchList;
  List<Widget> brWidgets = [];

  @override
  void initState() {
    // getBranchList(widget.bankId);
    super.initState();
  }

  Future getBranchList() async {
    var map = <String, dynamic>{};
    map['bank_id'] = widget.bankId;

    var response = await MasterModel.globalApiCall(1, '/get_branch_list', map);
    branchList = jsonDecode(response.body);
    // print(branchList);
    if (branchList['suc'] > 0) {
      branchList = branchList['msg'];
    } else {
      branchList = [];
      dialogModel.showToast(branchList['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white, //const Color.fromARGB(237, 9, 79, 159),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[50]),
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 135,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder(
                        future: getBranchList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Column();
                          } else if (branchList != 'No Data Found') {
                            return ListView.builder(
                                itemCount: branchList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            bottom:
                                                5, // Space between underline and text
                                          ),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                            // color: MainApp.textColor,
                                            width: 3.0, // Underline thickness
                                          ))),
                                          child: Text(
                                            branchList[index]['BRANCH_NAME'],
                                            style: const TextStyle(
                                              fontSize: 23,
                                              // color: MainApp.textColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_sharp,
                                            color: Colors.grey,
                                            size: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  78,
                                              child: Text(
                                                branchList[index]
                                                    ['BRANCH_ADDR'],
                                                style: const TextStyle(
                                                    fontSize: 17),
                                                softWrap: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            color: Colors.grey,
                                            size: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              branchList[index]['BRANCH_PHONE'],
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.email,
                                            color: Colors.grey,
                                            size: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              branchList[index]['BRANCH_EMAIL']
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            top: 0,
                                            right: 0,
                                            bottom: 0),
                                        child: Divider(
                                          thickness: 0.8,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  );
                                });
                          } else {
                            return const Column();
                          }
                        }),
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
