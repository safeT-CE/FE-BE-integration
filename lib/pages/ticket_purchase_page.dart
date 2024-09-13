import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 추가
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class TicketPurchasePage extends StatefulWidget {
  const TicketPurchasePage({super.key});

  @override
  _TicketPurchasePageState createState() => _TicketPurchasePageState();
}

class _TicketPurchasePageState extends State<TicketPurchasePage> {
  String _selectedDuration = '30분';
  int _paymentAmount = 1000;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('이용권 구매'),
          backgroundColor: Colors.white, // AppBar 배경색을 흰색으로 설정
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: safeTgreen),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('대여시간', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              Wrap(
                spacing: 8.0,
                runSpacing: 15.0,
                children: [
                  _buildDurationButton('30분', 1000),
                  _buildDurationButton('1시간', 2000),
                  _buildDurationButton('2시간', 3000),
                  _buildDurationButton('3시간', 4000),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: safeTlightgreen, 
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('결제금액', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('$_paymentAmount원', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(_selectedDuration, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _showPaymentConfirmationPopup(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: safeTgreen, 
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  foregroundColor: Colors.white, 
                ),
                child: const Text('결제하기', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationButton(String duration, int amount) {
    return Container(
    width: (MediaQuery.of(context).size.width - 64) / 2,  // 화면 크기에 맞춰 2개씩 배치
    child: ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedDuration = duration;
          _paymentAmount = amount;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedDuration == duration ? safeTgreen : safeTlightgreen, 
        foregroundColor: _selectedDuration == duration ? Colors.white : safeTgray, 
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      ),
      child: Text(duration),
    )
    );
  }

  void _showPaymentConfirmationPopup(BuildContext context) async{
    // SharedPreferences에서 userId 가져옴
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if(userId != null){
      // 서버에 post 요청
      var response = await _sendPaymentRequest(userId);

      if(response.statusCode == 200){
        // 결제 성공
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('결제 완료'),
              content: const Text('결제가 완료되었습니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: safeTgreen, 
                  ),
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );    
      } else {
        // 결제 실패
        print('Failed to buy a ticket: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Already bought a ticket')),
        );
      }
    } else {
      // userId가 없을 경우, 로그인 화면으로 이동함
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } 
  }

  Future<http.Response> _sendPaymentRequest(String userId) {
    // API 호출하기
                      // 여기 수정 필요 - 이용권 구매로 변경하기 - http://192.168.219.102:8080/ticket
                  // 수정 코드
                
                  //
    //var url = Uri.parse('http://192.168.219.102:8080/ticket');
    var url = Uri.parse('http://172.30.1.35:8080/ticket');
    var headers = {"Content-Type": "application/json"};
    var body = jsonEncode({
      'userId': userId
    });
    return http.post(url, headers: headers, body: body);
  }
  
}
