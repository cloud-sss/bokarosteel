// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';

class BoardMemberList extends StatefulWidget {
  const BoardMemberList({Key? key}) : super(key: key);

  @override
  State<BoardMemberList> createState() => _BoardMemberListState();
}

class _BoardMemberListState extends State<BoardMemberList> {
  // final String heroImage = 'assets/board_member_list.svg';
  String bankId = sharedPrefModel.getUserData('bank_id');
  var data;
  Future<void> GetMembFormDtls() async {
    var map = <String, dynamic>{};
    map['bank_id'] = bankId;
    var resDt =
        await MasterModel.globalApiCall(1, '/get_board_member_list', map);
    // print(resDt);
    resDt = jsonDecode(resDt.body);
    if (resDt['suc'] > 0) {
      data = resDt['msg'];
    } else {
      data = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Board Members'),
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
                      height: 240,
                      child: Image.asset(
                        'assets/board_member_list.png',
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 405,
                  child: FutureBuilder(
                      future: GetMembFormDtls(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // dialogModel.showLoading();
                          return const Column();
                        } else {
                          // dialogModel.dismissLoading();
                          if (data.length > 0) {
                            return ListView.builder(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                itemCount: data.length,
                                itemBuilder: (contex, index) =>
                                    SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _setLine(
                                                data[index]['MEMB_NAME'],
                                                data[index]['PHONE_NO'],
                                                data[index]['EMAIL_ID'],
                                                data[index]['OFFICE_NAME'],
                                                data[index]['OFFICE_ADDRESS']),
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
                                          ]),
                                    ));
                          } else {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
            ],
          ),
        ),
      ),
    );
  }

  _setLine(membName, membPhone, membEmail, membOffice, membOffAddr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            membName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.phone_android_outlined,
              color: Colors.grey,
              size: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 78,
                child: Text(
                  membPhone,
                  style: const TextStyle(fontSize: 17),
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            const Icon(
              Icons.email_outlined,
              color: Colors.grey,
              size: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 78,
                child: Text(
                  membEmail,
                  style: const TextStyle(fontSize: 17),
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            const Icon(
              Icons.home_work_outlined,
              color: Colors.grey,
              size: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 78,
                child: Text(
                  membOffice,
                  style: const TextStyle(fontSize: 17),
                  softWrap: true,
                ),
              ),
            ),
          ],
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
              padding: const EdgeInsets.only(left: 8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 78,
                child: Text(
                  membOffAddr,
                  style: const TextStyle(fontSize: 17),
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
