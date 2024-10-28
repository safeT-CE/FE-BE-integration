import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'package:safet/models/inquiry_check_data.dart';


class InquiryTile extends StatelessWidget {
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


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, 
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // 간격 추가
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // 모서리 둥글게
      ),
      child: ExpansionTile( 
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black, // 주요 컬러 사용
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          _formatDateTime(createdAt), // 날짜 표시
          style: TextStyle(color: Colors.grey),
        ),
        iconColor: safeTgreen, 
        collapsedIconColor: Colors.grey, // 닫힌 상태에서의 아이콘 색상
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content, // 문의 내용
                  style: TextStyle(color: safeTblack),
                ),
                const SizedBox(height: 16),
                if (response != null) // 답변이 있으면 표시
                  Text(
                    '답변: $response',
                    style: TextStyle(color: safeTblack, fontWeight: FontWeight.w500),
                  ),
                if (response == null) // 답변이 없으면 표시
                  Text(
                    '답변 대기 중',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(dateTime); // 날짜 형식
  }
}
