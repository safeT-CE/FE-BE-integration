import 'package:flutter/material.dart';

import '../main.dart';

class NumberInputPage extends StatefulWidget {
  final VoidCallback onNumberEntered;

  NumberInputPage({required this.onNumberEntered});

  @override
  _NumberInputPageState createState() => _NumberInputPageState();
}

class _NumberInputPageState extends State<NumberInputPage> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: safeTlightgreen,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('번호 입력'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          iconTheme: IconThemeData(color: safeTgreen),
          elevation: 0,

        ),
      body: Container(
        color: Colors.white, // 전체 배경색 지정
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // 여백 추가
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const TextField(
                  style: TextStyle(
                    color: Colors.black, // 입력 텍스트 색상
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '번호를 입력하세요',
                    labelStyle: TextStyle(color: safeTgreen), // 라벨 텍스트 색상
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: safeTgreen), // 입력 필드 외곽선 색상
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: safeTgreen), // 입력 필드 포커스 외곽선 색상
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    widget.onNumberEntered();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: safeTgreen,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('확인'),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
