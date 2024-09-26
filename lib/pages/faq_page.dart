import 'package:flutter/material.dart';
import '../models/faq_data.dart'; // FAQService import
import 'faq_tile.dart';
import 'package:safet/back/faq.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  late Future<List<FAQ>> _faqs;

  @override
  void initState() {
    super.initState();
    _faqs = FAQService().getAllFAQs();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Scaffold(
        body: FutureBuilder<List<FAQ>>(
          future: _faqs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No FAQs available.'));
            } else {
              return ListView(
                children: snapshot.data!.map((faq) => FaqTile(
                  id: faq.id,
                  question: faq.question,
                  answer: faq.answer,
                  date: faq.date,
                )).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
