import 'package:flutter/material.dart';

import '../main.dart';

class FaqTile extends StatelessWidget {
  final int id;
  final String question;
  final String answer;
  final String date;

  FaqTile({
    required this.id,
    required this.question,
    required this.answer,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(
          color: Colors.black, 
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        date,
        style: TextStyle(
          color: Colors.black, 
        ),
      ),
      iconColor: safeTgreen, 
      collapsedIconColor: Colors.black, 
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(answer),
            ],
          ),
        ),
      ],
    );
  }
}
