import 'package:flutter/material.dart';
import 'auth_phonenum_verificate_page.dart'; // PhoneVerificationPage가 정의된 파일을 import
import 'package:safet/main.dart';

class PhoneNumberInputPage extends StatefulWidget {
  @override
  _PhoneNumberInputPageState createState() => _PhoneNumberInputPageState();
}

class _PhoneNumberInputPageState extends State<PhoneNumberInputPage> {
  final TextEditingController _phoneController = TextEditingController();

  void _navigateToVerificationPage() {
    if (_phoneController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneVerificationPage(
            phoneNumber: _phoneController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: safeTgray),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '휴대폰 번호를 입력해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('휴대폰 번호'),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 30),
              decoration: InputDecoration(
                prefix: Text('+82 '),
                hintText: '00-0000-0000',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: safeTgreen, width: 2.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: safeTgray, width: 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _navigateToVerificationPage,
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
