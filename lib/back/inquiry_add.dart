import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safet/utils/constants.dart';
import 'package:safet/models/inquiry_add_data.dart';

// 개인 문의 작성 시 들어가는 데이터
Future<void> createInquiry(Inquiry inquiry) async {
  // API 엔드포인트 설정
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  if (userId == null) {
    throw Exception('User ID not found');
  }
  
  final url = Uri.parse('${baseUrl}inquiries?userId=${userId}');
  
  // 요청 본문을 JSON 형식으로 변환
  final body = jsonEncode(inquiry.toJson());

  // HTTP POST 요청 전송
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: body,
  );

  // 응답 처리
  if (response.statusCode == 201) {
    print('Inquiry created successfully!');
  } else {
    print('Failed to create inquiry. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}