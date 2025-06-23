import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('''Privacy & Policy'''),
      ),
      body: const SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          // elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '''Introduction''',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationColor: Colors.black38),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '''Our privacy policy at Synergic Softek Pvt. Ltd. is committed to protecting our customer’s information on https://adminbs.synergicbanking.in/. This privacy policy goes only for the customers who get the services including web and mobile software development services, web designing, mobile app development services, digital marketing services, cloud computing services, and e-commerce marketing services or products including core banking and billing machines which are all controlled by Synergic Softek. You are able to access and connect with the personal information which you share with us. Please, read our privacy policy carefully. Recently we updated our page and maybe we will update our page in future. So, please check our page regularly to make sure you can keep up with our updates.''',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
