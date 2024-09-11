import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:safet/utils/constants.dart';

class FAQService {
  final String faqUrl = '${baseUrl}faqs'; // 백엔드 서버 주소

  Future<List<FAQ>> getAllFAQs() async {
    final response = await http.get(
      Uri.parse(faqUrl),
      headers: {'Accept-Charset': 'utf-8'}
    );
    
    if (response.statusCode == 200) {
      //List<dynamic> data = json.decode(response.body);
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => FAQ.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load FAQs');
    }
  }
}

class FAQ {
  final int id;
  final String question;
  final String answer;
  final String date;

  FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.date,
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'],
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
