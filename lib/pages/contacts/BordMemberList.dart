// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';
import 'package:bseccs/widgets/member_card_widget.dart';

class BoardMemberList extends StatefulWidget {
  const BoardMemberList({Key? key}) : super(key: key);

  @override
  State<BoardMemberList> createState() => _BoardMemberListState();
}

class _BoardMemberListState extends State<BoardMemberList> {
  // final String heroImage = 'assets/board_member_list.svg';
  late String bankId = sharedPrefModel.getUserData('bank_id');
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  List<dynamic> data = [];
  Future<void> GetMembFormDtls() async {
    var map = <String, dynamic>{};
    map['bank_id'] = bankId;
    var resDt =
        await MasterModel.globalApiCall(1, '/get_board_member_list', map);
    // print(resDt);
    resDt = jsonDecode(resDt.body);
    if (resDt['suc'] > 0) {
      // data = resDt['msg'];
      setState(() {
        data = resDt['msg'].map((json) => Member.fromJson(json)).toList();
      });
    } else {
      data = [];
    }
  }

  // final List<Member> members = [
  //   Member(
  //     name: 'Robert Langdon',
  //     designation: 'Professor of Symbology',
  //     address: '15 Eagle Way, AL10 8RD',
  //     imageUrl: 'https://via.placeholder.com/150',
  //     membership: 'Gold Member',
  //     details: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  //   ),
  //   // Add more members here
  //   Member(
  //     name: 'Sophie Neveu',
  //     designation: 'Cryptologist',
  //     address: '10 Harvard Lane, AL8 6RD',
  //     imageUrl: 'https://via.placeholder.com/150',
  //     membership: 'Silver Member',
  //     details: 'Vestibulum ante ipsum primis in faucibus orci luctus et.',
  //   ),
  //   // Add more members here
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetMembFormDtls();
  }

  void _onNextCard() {
    if (_currentIndex < data.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPreviousCard() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Board Members'),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: data.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return MemberCard(member: data[index]);
            },
          ),
          if (_currentIndex > 0)
            Positioned(
              left: 16,
              top: MediaQuery.of(context).size.height / 2 - 30,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: _onPreviousCard,
              ),
            ),
          if (_currentIndex < data.length - 1)
            Positioned(
              right: 16,
              top: MediaQuery.of(context).size.height / 2 - 30,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: _onNextCard,
              ),
            ),
        ],
      ),
    );
  }
}

class Member {
  final String name;
  final String designation;
  final String address;
  final String imageUrl;
  final String membership;
  final String details;
  final String phone;
  final String email;

  Member({
    required this.name,
    required this.designation,
    required this.address,
    required this.imageUrl,
    required this.membership,
    required this.details,
    required this.phone,
    required this.email,
  });

  factory Member.fromJson(Map<String, dynamic> dt) {
    String baseUrl = MasterModel.BaseUrl.toString();
    return Member(
      name: dt['MEMB_NAME'] != '' ? dt['MEMB_NAME'].toString() : '',
      designation: dt['DESIG'] != '' ? dt['DESIG'].toString() : '',
      address:
          dt['OFFICE_ADDRESS'] != '' ? dt['OFFICE_ADDRESS'].toString() : '',
      imageUrl: dt['PROFILE_IMG'] != ''
          ? '$baseUrl/${dt['PROFILE_IMG'].toString()}'
          : '',
      membership: dt['MEMB_ID'] != '' ? dt['MEMB_ID'].toString() : '',
      details: dt['ABOUT'] != '' ? dt['ABOUT'].toString() : '',
      phone: dt['PHONE_NO'] != '' ? dt['PHONE_NO'].toString() : '',
      email: dt['EMAIL_ID'] != '' ? dt['EMAIL_ID'].toString() : '',
    );
  }
}
