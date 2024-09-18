import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import '../models/inquiry_add_data.dart';
import 'inquiry_tile.dart';
import 'package:safet/models/inquiry_check_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safet/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PersonalInquiryPage extends StatefulWidget {
  @override
  _PersonalInquiryPageState createState() => _PersonalInquiryPageState();
}

class _PersonalInquiryPageState extends State<PersonalInquiryPage> {
  bool _isLoading = true;  // 데이터를 로딩 중임을 나타내는 상태
  late Future<List<InquiryItem>> _inquiries;

  @override
  void initState() {
    super.initState();
    _inquiries = InquiryService().getAllInquiries();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: FutureBuilder<List<InquiryItem>>(
          future: _inquiries,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No Inquiries available.'));
            } else {
              return ListView(
                children: snapshot.data!.map((inquiry) => InquiryTile(
                  title: inquiry.title,
                  content: inquiry.content,
                  createdAt: inquiry.createdAt,
                  response: inquiry.response,
                )).toList(),
              );
            }
          },
        ),
      );
  }
}
