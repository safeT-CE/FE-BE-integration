import 'package:flutter/material.dart';

import '../main.dart';

class PaymentSelectionPage extends StatefulWidget {
  const PaymentSelectionPage({Key? key}) : super(key: key);

  @override
  _PaymentSelectionPageState createState() => _PaymentSelectionPageState();
}

class _PaymentSelectionPageState extends State<PaymentSelectionPage> {
  static const String kakaoPay = 'Kakao Pay';
  static const String naverPay = 'Naver Pay';

  String _selectedPaymentMethod = kakaoPay; // 초기값 설정

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('결제수단등록'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: safeTgreen),
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: const Text(kakaoPay),
                    leading: Radio<String>(
                      value: kakaoPay,
                      groupValue: _selectedPaymentMethod,
                      activeColor: safeTgreen, 
                      onChanged: (String? value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(naverPay),
                    leading: Radio<String>(
                      value: naverPay,
                      groupValue: _selectedPaymentMethod,
                      activeColor: safeTgreen,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 180), // 버튼과 라디오 버튼 사이의 간격을 추가
                  ElevatedButton(
                    onPressed: () {
                      // 결제 수단 등록 로직 추가
                      _showRentalConfirmationPopup(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: safeTgreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // 버튼 크기 조정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('등록'),
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/image/pic.png', // 광고 이미지 경로
              width: MediaQuery.of(context).size.width, // 화면 너비에 맞추기
              height: 120, // 이미지 높이 설정
              fit: BoxFit.cover, // 이미지가 전체 영역을 덮도록 설정
            ),
          ],
        ),
      ),
    );
  }

  void _showRentalConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('등록 완료'),
          content: const Text('등록이 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
              },
              style: TextButton.styleFrom(
                foregroundColor: safeTgreen, // TextButton의 텍스트 색상을 safeTgreen으로 설정
              ),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
