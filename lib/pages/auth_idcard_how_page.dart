import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safet/main.dart';

class IdHowPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '가지고 계신 원동기 면허증을\n준비해 주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 60),
              Image.asset(
                'assets/image/auth_idcard.png',
                width: 260,
              ),
              SizedBox(height: 60), // Spacer 대신 크기를 조정해 줌
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: safeTgreen,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  // Next button action
                  Navigator.pushNamed(context, '/auth_id_cam');
                },
                child: Text(
                  '다음',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
