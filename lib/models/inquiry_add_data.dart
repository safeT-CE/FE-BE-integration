import 'package:safet/models/inquiry_check_data.dart';

class Inquiry {
  final Category category;
  final String content;
  final String title;

  Inquiry({
    required this.category,
    required this.content,
    required this.title,
  });

  // Inquiry 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'category': _categoryToString(category),
      'content': content,
      'title': title,
    };
  }

  String _categoryToString(Category category) {
    switch (category) {
      case Category.etc:
        return 'etc';
      case Category.payment:
        return 'payment';
      case Category.penalty:
        return 'penalty';
      case Category.userInfo:
        return 'userInfo';
      default:
        return '';
    }
  }
}
