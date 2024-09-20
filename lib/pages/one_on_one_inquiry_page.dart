import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/inquiry_add_data.dart';
import 'package:safet/models/inquiry_check_data.dart';
import 'package:safet/models/inquiry_add_data.dart';

// 개인 문의 작성 폼
class OneOnOneInquiryPage extends StatefulWidget {
  final Category initialCategory; // Category enum 타입으로 변경
  final String initialTitle;

  const OneOnOneInquiryPage({
    super.key,
    required this.initialCategory,
    required this.initialTitle,
  });

  @override
  _OneOnOneInquiryPageState createState() => _OneOnOneInquiryPageState();
}

class _OneOnOneInquiryPageState extends State<OneOnOneInquiryPage> {
  late int id;
  late Category selectedCategory;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    _titleController.text = widget.initialTitle;
  }

  void _submitInquiry() async{
    final String title = _titleController.text;
    final String content = _contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      try{
        await createInquiry(
          Inquiry(
          category: selectedCategory, // Enum 타입으로 전달
          content: content,
          title: title,
          ),
        );
  
        _titleController.clear();
        _contentController.clear();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('문의가 제출되었습니다.'),
        ));

        // 문의 제출 후 페이지 닫기
        Navigator.pop(context);
      } catch(error){
        //에러 처리
        print('Failed to submit inquiry: $error');  // 에러 출력
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('문의 제출에 실패했습니다. 다시 시도해주세요.'),
      ));
      }
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
              DropdownButtonFormField<Category>(
                decoration: InputDecoration(
                  labelText: '문의 분류',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: safeTgreen),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: safeTgreen),
                  ),
                ),
                items: Category.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(_categoryToKorean(category)),
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

  String _categoryToKorean(Category category) {
    switch (category) {
      case Category.etc:
        return '기타';
      case Category.payment:
        return '결제';
      case Category.penalty:
        return '벌점';
      case Category.userInfo:
        return '회원정보';
      default:
        return '';
    }
  }
}