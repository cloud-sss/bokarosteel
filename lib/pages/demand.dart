// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';

class DemandDetails extends StatefulWidget {
  const DemandDetails({super.key});

  @override
  State<DemandDetails> createState() => _DemandDetailsState();
}

class _DemandDetailsState extends State<DemandDetails> {
  final ThemeModel _themeModel = ThemeModel();
  String userName = sharedPrefModel.getUserData('user_name');
  String memberId = sharedPrefModel.getUserData('cust_id');
  var data;
  double totalPrincipal = 0;
  double totalInterest = 0;

  Map<String, dynamic> monthList = {
    '1': 'January',
    '2': 'February',
    '3': 'March',
    '4': 'April',
    '5': 'May',
    '6': 'June',
    '7': 'July',
    '8': 'August',
    '9': 'September',
    '10': 'October',
    '11': 'November',
    '12': 'December',
  };

  Future<void> getDemandList() async {
    var map = <String, dynamic>{};
    map['memb_id'] = memberId;
    var resDt = await MasterModel.globalApiCall(1, '/get_demand_dtls', map);
    // print(resDt);
    resDt = jsonDecode(resDt.body);
    //print(resDt);
    if (resDt['suc'] > 0) {
      data = resDt['msg'];
      // for (var item in data) {

      //   totalInterest += double.tryParse(item['INTT_AMT'].toString()) ?? 0;
      // }
    } else {
      data = [];
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
          future: getDemandList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // dialogModel.showLoading();
              return const Column();
            } else {
              return Column(
                children: [
                  Container(
                    height: 150,
                    width: cWidth,
                    decoration:
                        BoxDecoration(color: _themeModel.lightPrimaryColor),
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
                                  userName,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Month',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    data.length > 0
                                        ? (int.parse(data[0]['MONTH']
                                                    .toString()) >
                                                0
                                            ? monthList[
                                                data[0]['MONTH'].toString()]
                                            : '')
                                        : '',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Year',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    data.length > 0
                                        ? data[0]['YEAR'].toString()
                                        : '',
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
                    height: 15,
                  ),
                  Container(
                    //decoration: BoxDecoration(color: Colors.grey[50]),
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      // Wrap everything in SingleChildScrollView
                      child: Column(
                        //color: Color.fromARGB(255, 246, 246, 248),
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 0,
                            color: Theme.of(context).colorScheme.surfaceVariant,

                            // color: Color.fromARGB(255, 246, 246, 248),
                            //color: Colors.grey.shade600,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 2),
                                    SizedBox(
                                      // Wrap ListView.builder inside SizedBox with height constraint
                                      // height:
                                      //     MediaQuery.of(context).size.height *
                                      //         0.6, // Adjust height as needed
                                      // height: 1500,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(), // Ensures scrolling
                                        itemCount: data.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index < data.length) {
                                            totalPrincipal += data[index]
                                                        ['PRN_AMT']
                                                    .toString()
                                                    .isNotEmpty
                                                ? double.parse(data[index]
                                                        ['PRN_AMT']
                                                    .toString())
                                                : 0;
                                            totalInterest += (data[index]
                                                    ['INTT_AMT'] is String)
                                                ? double.tryParse(data[index]
                                                        ['INTT_AMT']) ??
                                                    0
                                                : double.tryParse(data[index]
                                                            ['INTT_AMT']
                                                        .toString()) ??
                                                    0;
                                            return Column(
                                              children: [
                                                Card(
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 182, 182, 224),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 2),
                                                            child: Text(
                                                              data[index][
                                                                  'ACC_TYPE_DESC'],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                    ? Colors
                                                                        .white
                                                                    : _themeModel
                                                                        .lightIconTextColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Container(
                                                            decoration: const BoxDecoration(
                                                                // color: Color
                                                                //     .fromARGB(
                                                                //         255,
                                                                //         246,
                                                                //         246,
                                                                //         248),
                                                                ),
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          6.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          const Text(
                                                                            'Principal: ',
                                                                            style:
                                                                                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                          ),
                                                                          Text(
                                                                            data[index]['PRN_AMT'].toString(),
                                                                            style:
                                                                                const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Text(
                                                                            'Interest: ',
                                                                            style:
                                                                                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                          ),
                                                                          Text(
                                                                            data[index]['INTT_AMT'].toString(),
                                                                            style:
                                                                                const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Divider(thickness: 0.6),
                                                const SizedBox(height: 2),
                                              ],
                                            );
                                          } else {
                                            // ✅ Total row
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 9.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 182, 182, 224),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // const Text(
                                                    //   'Total',
                                                    //   style: TextStyle(
                                                    //     fontSize: 18,
                                                    //     fontWeight:
                                                    //         FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'THRIFT CONTRIBUTION: ',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Text(
                                                              data[0]['THRIFT_CONTRIBUTION']
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),

                                                    const SizedBox(height: 6),
                                                    const Divider(
                                                        thickness: 0.6),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'TOTAL AMOUNT: ',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Text(
                                                              (totalPrincipal +
                                                                      totalInterest +
                                                                      data[0][
                                                                          'THRIFT_CONTRIBUTION'])
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
