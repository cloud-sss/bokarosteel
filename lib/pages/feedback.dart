import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:bseccs/models/dialogModel.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/models/themeModel.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final ThemeModel _themeModel = ThemeModel();
  double value = 4.0;
  final formKey = GlobalKey<FormState>();
  String userName = sharedPrefModel.getUserData('user_name');

  final TextEditingController _remarks = TextEditingController();

  submitFeedBack(rating, remarks, userName) async {
    var map = <String, dynamic>{};
    map['rating'] = rating;
    map['remarks'] = remarks;
    map['user_id'] = userName;
    var resDt = await MasterModel.globalApiCall(1, '/feedback', map);
    // print(resDt);
    resDt = jsonDecode(resDt.body);

    if (resDt['suc'] != 1) {
      dialogModel.showToast(resDt['msg'].toString());
    } else {
      dialogModel.showToast('We have received your feedback successfully');
    }
  }

  @override
  void dispose() {
    _remarks.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _themeModel.lightPrimaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: 233,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                              bottom: 5, // Space between underline and text
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: _themeModel.lightPrimaryColor,
                              width: 3.0, // Underline thickness
                            ))),
                            child: Text(
                              'Feedback Form',
                              style: TextStyle(
                                fontSize: 23,
                                color: _themeModel.lightIconTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Center(
                                    child: Column(
                                  children: [
                                    const Text(
                                      'Rate Us',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    RatingStars(
                                      value: value,
                                      onValueChanged: (v) {
                                        setState(() {
                                          value = v;
                                        });
                                      },
                                      starBuilder: (index, color) => Icon(
                                        Icons.star,
                                        color: color,
                                        size: 40,
                                      ),
                                      starCount: 5,
                                      starSize: 40,
                                      valueLabelColor: const Color(0xff9b9b9b),
                                      valueLabelTextStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                      valueLabelRadius: 10,
                                      maxValue: 5,
                                      starSpacing: 2,
                                      maxValueVisibility: true,
                                      valueLabelVisibility: true,
                                      animationDuration:
                                          const Duration(milliseconds: 1000),
                                      valueLabelPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 1, horizontal: 8),
                                      valueLabelMargin:
                                          const EdgeInsets.only(right: 8),
                                      starOffColor: const Color(0xffe7e8ea),
                                      starColor: Colors.yellow,
                                    ),
                                  ],
                                )),
                                const SizedBox(
                                  height: 40,
                                ),
                                TextFormField(
                                  controller: _remarks,
                                  enableSuggestions: true,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  minLines: 2,
                                  decoration: const InputDecoration(
                                      labelText: 'Remarks',
                                      border: OutlineInputBorder()),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Remarks";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      await submitFeedBack(value.toString(),
                                          _remarks.text.toString(), userName);
                                    }
                                  },
                                  // style: ButtonStyle(elevation: MaterialStateProperty(12.0 )),
                                  style: ElevatedButton.styleFrom(
                                      // backgroundColor:
                                      //     const Color.fromARGB(237, 9, 79, 159),
                                      elevation: 0.0,
                                      textStyle:
                                          const TextStyle(color: Colors.white),
                                      minimumSize: const Size(150, 40)),
                                  child: const Text('Submit',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
