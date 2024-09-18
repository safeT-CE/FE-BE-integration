import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safet/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// 개인 문의 조회
enum Category {
  etc,        // 기타
  payment,    // 결제
  penalty,    // 벌점
  userInfo    // 회원정보
}

class InquiryService {
  Future<List<InquiryItem>> getAllInquiries() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      if (userId == null) {
        throw Exception('User ID not found');
      }

      final String inquiryUrl = '${baseUrl}inquiries?userId=${userId}';
    
    final response = await http.get(
      Uri.parse(inquiryUrl),
      headers: {'Accept-Charset': 'utf-8'}
    );
    
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => InquiryItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load FAQs');
    }
  }
}

class InquiryItem {
  final int id;
  final Category category;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? response;
  final DateTime? respondedAt;

  InquiryItem({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.createdAt,
    this.response,
    this.respondedAt
  });

  factory InquiryItem.fromJson(Map<String, dynamic> json) {
    return InquiryItem(
      id: json['id'],
      category: _categoryFromString(json['category']),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      response: json['response'] ?? '',
      respondedAt: json['respondedAt'] != null ? DateTime.parse(json['respondedAt']) : null,
    );
  }

  static Category _categoryFromString(String categoryString) {
    switch (categoryString) {
      case '기타':
        return Category.etc;
      case '결제':
        return Category.payment;
      case '벌점':
        return Category.penalty;
      case '회원정보':
        return Category.userInfo;
      default:
        throw Exception('Unknown category: $categoryString');
    }
  }
}