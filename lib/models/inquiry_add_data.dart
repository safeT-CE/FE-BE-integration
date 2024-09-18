import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safet/models/inquiry_check_data.dart';

// 개인 문의 작성 시 들어가는 데이터

class InquiryData extends ChangeNotifier {
  final List<InquiryItem> _inquiries = [];

  List<InquiryItem> get inquiries => _inquiries;

  void addInquiry(int id, Category category, String title, String content, DateTime createdAt, {DateTime? respondedAt, String? response}) {
    _inquiries.add(InquiryItem(
      id: id,
      category: category,
      title: title,
      content: content,
      createdAt: createdAt, // DateFormat('yyyy년 M월 d일 H시 m분').format(createdAt) 
      response: response,
      respondedAt: respondedAt,
    ));
    notifyListeners();
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
}