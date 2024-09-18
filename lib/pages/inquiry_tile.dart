import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'package:safet/models/inquiry_check_data.dart';


class InquiryTile extends StatelessWidget {
  //final InquiryItem inquiry; // OneOnOneInquiry 객체를 직접 받습니다.

  // InquiryTile({
  //   required this.inquiry,
  // });


  final String title;  // Inquiry title
  final String content;  // Inquiry content
  final DateTime createdAt;  // Creation date
  final String? response;  // Optional response

  InquiryTile({
    required this.title,
    required this.content,
    required this.createdAt,
    this.response,  // This field is optional
  });

  // 이부분 수정 필요
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(content),
          SizedBox(height: 4),
          Text(
            _formatDateTime(createdAt),
            style: TextStyle(color: Colors.grey),
          ),
          if (response != null) ...[
            SizedBox(height: 8),
            Text(
              '응답: $response',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}년 ${dateTime.month}월 ${dateTime.day}일 ${dateTime.hour}시 ${dateTime.minute}분';
  }
}