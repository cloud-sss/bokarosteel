import 'package:flutter/material.dart';
import 'package:bseccs/models/themeModel.dart';
import 'package:bseccs/pages/about_pages/aboutLoan.dart';
import 'package:bseccs/pages/about_pages/aboutMembership.dart';
import 'package:bseccs/pages/about_pages/aboutSociety.dart';
//import 'package:bseccs/pages/about_pages/holidayHome.dart';
import 'package:bseccs/pages/about_pages/secDesk.dart';
import 'package:bseccs/pages/branchInfo.dart';
import 'package:bseccs/pages/contacts/BordMemberList.dart';
import 'package:bseccs/pages/emi_calculator.dart';
import 'package:bseccs/pages/feedback.dart';
import 'package:bseccs/pages/image_gallery.dart';
import 'package:bseccs/pages/loanCalculator.dart';
//import 'package:bseccs/pages/loan_application/view.dart';
// import 'package:bseccs/pages/member_application/entry.dart';
//import 'package:bseccs/pages/member_application/view.dart';
//import 'package:bseccs/pages/shares_application/view.dart';

class MoreHome extends StatefulWidget {
  const MoreHome({super.key});

  @override
  State<MoreHome> createState() => _MoreHomeState();
}

class _MoreHomeState extends State<MoreHome> {
  final ThemeModel _themeModel = ThemeModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 40,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border:
                          Border.all(width: 1.0, color: Colors.grey.shade300)),
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
                        Image(
                          image: const AssetImage('assets/calculator.png'),
                          height: 60,
                          width: 60,
                          color: _themeModel.lightIconColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'TD/RD Calculator',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: _themeModel.lightIconTextColor,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: _themeModel.lightIconTextColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border:
                          Border.all(width: 1.0, color: Colors.grey.shade300)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const FeedBack();
                      }));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage('assets/feedback.png'),
                          height: 60,
                          width: 60,
                          color: _themeModel.lightIconColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Feedback',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: _themeModel.lightIconTextColor,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: _themeModel.lightIconTextColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          const SizedBox(
            height: 40,
          ),
          // const SizedBox(
          //   height: 40,
          // ),
          // Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Container(
          //         height: 170,
          //         width: 170,
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: const BorderRadius.all(Radius.circular(15)),
          //             border:
          //                 Border.all(width: 1.0, color: Colors.grey.shade300)),
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (BuildContext context) {
          //               return const MembApplicationView();
          //             }));
          //           },
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Image(
          //                 image: const AssetImage('assets/application.png'),
          //                 height: 60,
          //                 width: 60,
          //                 color: _themeModel.lightIconColor,
          //               ),
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //               Text(
          //                 'Membership Application',
          //                 style: TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.w500,
          //                   letterSpacing: 1,
          //                   color: _themeModel.lightIconTextColor,
          //                 ),
          //                 textAlign: TextAlign.center,
          //               ),
          //               const SizedBox(
          //                 height: 6,
          //               ),
          //               Center(
          //                 child: Icon(
          //                   Icons.arrow_right_alt_outlined,
          //                   color: _themeModel.lightIconTextColor,
          //                   size: 30,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       Container(
          //         height: 170,
          //         width: 170,
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: const BorderRadius.all(Radius.circular(15)),
          //             border:
          //                 Border.all(width: 1.0, color: Colors.grey.shade300)),
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (BuildContext context) {
          //               return const GenLoanApplicationView();
          //             }));
          //           },
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Image(
          //                 image: const AssetImage(
          //                     'assets/loan_application_new.png'),
          //                 height: 60,
          //                 width: 60,
          //                 color: _themeModel.lightIconColor,
          //               ),
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //               Text(
          //                 'General Loan Application',
          //                 style: TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.w500,
          //                   letterSpacing: 1,
          //                   color: _themeModel.lightIconTextColor,
          //                 ),
          //                 textAlign: TextAlign.center,
          //               ),
          //               const SizedBox(
          //                 height: 6,
          //               ),
          //               Center(
          //                 child: Icon(
          //                   Icons.arrow_right_alt_outlined,
          //                   color: _themeModel.lightIconTextColor,
          //                   size: 30,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ]),
          // const SizedBox(
          //   height: 40,
          // ),
          // Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Container(
          //         height: 170,
          //         width: 170,
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: const BorderRadius.all(Radius.circular(15)),
          //             border:
          //                 Border.all(width: 1.0, color: Colors.grey.shade300)),
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (BuildContext context) {
          //               return const StockApplicationView();
          //             }));
          //           },
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Image(
          //                 image:
          //                     const AssetImage('assets/share_application.png'),
          //                 height: 60,
          //                 width: 60,
          //                 color: _themeModel.lightIconColor,
          //               ),
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //               Text(
          //                 'Additional Shares Application',
          //                 style: TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.w500,
          //                   letterSpacing: 1,
          //                   color: _themeModel.lightIconTextColor,
          //                 ),
          //                 textAlign: TextAlign.center,
          //               ),
          //               const SizedBox(
          //                 height: 6,
          //               ),
          //               Center(
          //                 child: Icon(
          //                   Icons.arrow_right_alt_outlined,
          //                   color: _themeModel.lightIconTextColor,
          //                   size: 30,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       Container(
          //         height: 170,
          //         width: 170,
          //         decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: const BorderRadius.all(Radius.circular(15)),
          //             border:
          //                 Border.all(width: 1.0, color: Colors.grey.shade300)),
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (BuildContext context) {
          //               return const ImageGallery();
          //             }));
          //           },
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Image(
          //                 image: const AssetImage('assets/image-gallery.png'),
          //                 height: 60,
          //                 width: 60,
          //                 color: _themeModel.lightIconColor,
          //               ),
          //               const SizedBox(
          //                 height: 10,
          //               ),
          //               Text(
          //                 'Image Gallery',
          //                 style: TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.w500,
          //                   letterSpacing: 1,
          //                   color: _themeModel.lightIconTextColor,
          //                 ),
          //                 textAlign: TextAlign.center,
          //               ),
          //               const SizedBox(
          //                 height: 6,
          //               ),
          //               Center(
          //                 child: Icon(
          //                   Icons.arrow_right_alt_outlined,
          //                   color: _themeModel.lightIconTextColor,
          //                   size: 30,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ]),
          // const SizedBox(
          //   height: 40,
          // ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border:
                          Border.all(width: 1.0, color: Colors.grey.shade300)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const AboutMembership();
                      }));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage('assets/about_memb.png'),
                          height: 60,
                          width: 60,
                          color: _themeModel.lightIconColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'About Membership',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: _themeModel.lightIconTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: _themeModel.lightIconTextColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border:
                          Border.all(width: 1.0, color: Colors.grey.shade300)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const AboutSociety();
                      }));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage('assets/about_soci.png'),
                          height: 60,
                          width: 60,
                          color: _themeModel.lightIconColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'About Society',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: _themeModel.lightIconTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: _themeModel.lightIconTextColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          const SizedBox(
            height: 40,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border:
                          Border.all(width: 1.0, color: Colors.grey.shade300)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const AboutLoan();
                      }));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage('assets/about_loan.png'),
                          height: 60,
                          width: 60,
                          color: _themeModel.lightIconColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'About Loan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: _themeModel.lightIconTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: _themeModel.lightIconTextColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   height: 170,
                //   width: 170,
                //   decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: const BorderRadius.all(Radius.circular(15)),
                //       border:
                //           Border.all(width: 1.0, color: Colors.grey.shade300)),
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (BuildContext context) {
                //         return HolidayHomeList();
                //       }));
                //     },
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image(
                //           image: const AssetImage('assets/stilt_house.png'),
                //           height: 60,
                //           width: 60,
                //           color: _themeModel.lightIconColor,
                //         ),
                //         const SizedBox(
                //           height: 10,
                //         ),
                //         Text(
                //           'Holiday Home',
                //           style: TextStyle(
                //             fontSize: 18,
                //             fontWeight: FontWeight.w500,
                //             letterSpacing: 1,
                //             color: _themeModel.lightIconTextColor,
                //           ),
                //           textAlign: TextAlign.center,
                //         ),
                //         const SizedBox(
                //           height: 6,
                //         ),
                //         Center(
                //           child: Icon(
                //             Icons.arrow_right_alt_outlined,
                //             color: _themeModel.lightIconTextColor,
                //             size: 30,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border:
                          Border.all(width: 1.0, color: Colors.grey.shade300)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const ImageGallery();
                      }));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage('assets/image-gallery.png'),
                          height: 60,
                          width: 60,
                          color: _themeModel.lightIconColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Image Gallery',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: _themeModel.lightIconTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: _themeModel.lightIconTextColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          const SizedBox(
            height: 40,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border:
                          Border.all(width: 1.0, color: Colors.grey.shade300)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const BoardMemberList();
                      }));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image:
                              const AssetImage('assets/board_of_directors.png'),
                          height: 60,
                          width: 60,
                          color: _themeModel.lightIconColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Board Member List',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: _themeModel.lightIconTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: _themeModel.lightIconTextColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border:
                          Border.all(width: 1.0, color: Colors.grey.shade300)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const SecDesk();
                      }));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage('assets/sec_desk_icon.png'),
                          height: 60,
                          width: 60,
                          color: _themeModel.lightIconColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '''Secretary's Desk''',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: _themeModel.lightIconTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: _themeModel.lightIconTextColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          const SizedBox(
            height: 40,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 22),
                // Container(
                //   height: 170,
                //   width: 170,
                //   decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: const BorderRadius.all(Radius.circular(15)),
                //       border:
                //           Border.all(width: 1.0, color: Colors.grey.shade300)),
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (BuildContext context) {
                //         return const LoanCalculator();
                //       }));
                //     },
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image(
                //           image: const AssetImage('assets/loan_calc.png'),
                //           height: 60,
                //           width: 60,
                //           color: _themeModel.lightIconColor,
                //         ),
                //         const SizedBox(
                //           height: 10,
                //         ),
                //         Text(
                //           'Loan Calculator',
                //           style: TextStyle(
                //             fontSize: 18,
                //             fontWeight: FontWeight.w500,
                //             letterSpacing: 1,
                //             color: _themeModel.lightIconTextColor,
                //           ),
                //         ),
                //         const SizedBox(
                //           height: 6,
                //         ),
                //         Center(
                //           child: Icon(
                //             Icons.arrow_right_alt_outlined,
                //             color: _themeModel.lightIconTextColor,
                //             size: 30,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border:
                          Border.all(width: 1.0, color: Colors.grey.shade300)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return BranchInfo(
                          bankId: '1',
                        );
                      }));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage('assets/branch.png'),
                          height: 60,
                          width: 60,
                          color: _themeModel.lightIconColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Branch Info',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                            color: _themeModel.lightIconTextColor,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: _themeModel.lightIconTextColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
          const SizedBox(
            height: 40,
          )
        ]),
      ),
    );
  }
}
