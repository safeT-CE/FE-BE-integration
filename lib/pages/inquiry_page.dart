import 'package:flutter/material.dart';
import 'package:safet/models/inquiry_check_data.dart';

import '../main.dart';
import 'faq_page.dart';
import 'one_on_one_inquiry_page.dart';
import 'personal_inquiry_page.dart';

class InquiryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('문의하기'),
          backgroundColor: Colors.white, 
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            labelColor: safeTgreen,
            unselectedLabelColor: Colors.grey,
            indicatorColor: safeTgreen,
            tabs: [
              Tab(text: '자주하는 문의'),
              Tab(text: '개인 문의'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FAQPage(),
            PersonalInquiryPage(),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => OneOnOneInquiryPage(
        //           initialCategory: Category.etc,
        //           initialTitle: '',
        //         ),
        //       ),
        //     );
        //   },
        //   backgroundColor: safeTgreen,
        //   foregroundColor: Colors.white,
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
