import 'package:flutter/material.dart';
import 'dart:async';

import 'package:safet/main.dart';

class PhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;

  PhoneVerificationPage({required this.phoneNumber});

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  Timer? _timer;
  int _start = 180;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void startTimer() {
    _start = 180;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _resendCode() {
    startTimer();
  }

  void _submitCode() {
    String code = _controllers.map((controller) => controller.text).join();
    print('인증번호: $code');//유저가 입력한 인증 번호 터미널에 출력->추후에 백이랑 연결 했을때 비교에 이용
    Navigator.pushNamed(context, '/auth_id_how');
  }

  @override
  Widget build(BuildContext context) {
    String displayPhoneNumber = '0${widget.phoneNumber}'; 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('휴대폰 인증'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '휴대폰 번호 인증',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '아래 번호로 인증 번호가 전송 되었습니다.\n인증 번호를 입력해주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 32),
              Text(
                displayPhoneNumber,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return Container(
                    width: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: safeTgreen),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: safeTgreen),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: safeTgreen),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(timerText),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _resendCode,
                  child: Text(
                    '인증번호 새로 받기',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _submitCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: safeTgreen,
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text(
            '확인',
            style: TextStyle(color: Colors.white),
            ),
        ),
      ),
    );
  }
}
