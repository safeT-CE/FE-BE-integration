import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'inquiry_data.dart';

class OneOnOneInquiryPage extends StatefulWidget {
  final String initialCategory;
  final String initialTitle;
  final String? fromPenaltyDate;
  final String? imagePath;

  const OneOnOneInquiryPage({
    super.key,
    required this.initialCategory,
    required this.initialTitle,
    this.fromPenaltyDate,
    this.imagePath,
  });

  @override
  _OneOnOneInquiryPageState createState() => _OneOnOneInquiryPageState();
}

class _OneOnOneInquiryPageState extends State<OneOnOneInquiryPage> {
  late String selectedCategory;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    _titleController.text = widget.initialTitle;
  }

  void _submitInquiry() {
    final String title = _titleController.text;
    final String content = _contentController.text;

    if (selectedCategory.isNotEmpty && title.isNotEmpty && content.isNotEmpty) {
      Provider.of<InquiryData>(context, listen: false).addInquiry(
        selectedCategory,
        title,
        content,
        fromPenaltyDate: widget.fromPenaltyDate,
        imagePath: widget.imagePath,
      );

      _titleController.clear();
      _contentController.clear();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('문의가 제출되었습니다.'),
      ));

      Navigator.pop(context); // 문의 제출 후 페이지 닫기
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('모든 필드를 입력해주세요.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: safeTgreen, 
            ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: safeTgreen, 
          selectionColor: safeTgreen.withOpacity(0.5), 
          selectionHandleColor: safeTgreen, 
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('1:1 문의하기'),
          backgroundColor: Colors.white, // AppBar 배경색 흰색으로 설정
          foregroundColor: Colors.black, // AppBar 텍스트 색상 검정으로 설정
          iconTheme: IconThemeData(color: Colors.black), // AppBar 아이콘 색상 검정으로 설정
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.white, // 전체 배경색 흰색으로 설정
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '문의 분류',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: safeTgreen),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: safeTgreen),
                  ),
                ),
                items: ['기타', '결제', '벌점', '회원정보'].map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                value: selectedCategory,
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '제목을 입력해주세요',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: safeTgreen),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: safeTgreen),
                  ),
                ),
                style: TextStyle(color: Colors.black),
              ),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: '내용을 입력해주세요',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: safeTgreen),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: safeTgreen),
                  ),
                ),
                maxLines: 5,
                maxLength: 200,
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitInquiry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: safeTgreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('제출'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
