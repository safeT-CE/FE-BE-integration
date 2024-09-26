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
