import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:safet/main.dart';
import 'package:safet/models/user_info.dart';
import 'package:safet/pages/auth_done_page.dart';
import 'package:safet/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class IdentificationPage extends StatefulWidget {
  final CameraDescription frontCamera;
  final File registeredFaceImage; // 등록된 얼굴 이미지
  final UserInfo userFaceInfo;

  IdentificationPage({
    required this.frontCamera,
    required this.registeredFaceImage,
    required this.userFaceInfo, required Type UserFaceInfo,

  });

  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}


class _IdentificationPageState extends State<IdentificationPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.frontCamera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final faceImage = File(image.path);
      String response = await _compareFaces(faceImage); // 비교 로직 호출

      _showResponseDialog(response);
    } catch (e) {
      print('Error taking picture: $e');
      _showResponseDialog('사진 촬영 중 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  Future<String> _compareFaces(File faceImage) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

    /* if (userId == null) {
        _showErrorDialog(context, '사용자 ID를 불러오는 데 실패했습니다.');
        return;
      }
*/
      // 이미지 비교를 위한 multipart request 생성
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}face/compare'), // 새로운 비교 API 엔드포인트
      );

      // 사용자 아이디 추가
      request.fields['userId'] = userId ?? '';

      // 등록된 얼굴 사진 추가
      var registeredFaceImageStream = http.ByteStream(widget.registeredFaceImage.openRead());
      var registeredFaceImageLength = await widget.registeredFaceImage.length();
      request.files.add(
        http.MultipartFile(
          'registeredFaceImage',
          registeredFaceImageStream,
          registeredFaceImageLength,
          filename: p.basename(widget.registeredFaceImage.path),
        ),
      );

      // 촬영한 얼굴 사진 추가
      var faceImageStream = http.ByteStream(faceImage.openRead());
      var faceImageLength = await faceImage.length();
      request.files.add(
        http.MultipartFile(
          'faceImage',
          faceImageStream,
          faceImageLength,
          filename: p.basename(faceImage.path),
        ),
      );

      // 요청 전송 및 응답 처리
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      if (responseBody.statusCode != 200) {
        return '서버와의 통신에 실패했습니다. 다시 시도해주세요.';
      }

      print('Response Body: ${responseBody.body}');

      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = jsonDecode(responseBody.body);
      } catch (e) {
        print('JSON parsing error: $e');
        return '응답 형식이 잘못되었습니다. 다시 시도해주세요.';
      }

      String same = jsonResponse['samePerson']; // 서버에서 받은 결과

      if (same == "success") {
        return '등록된 얼굴 사진과 동일인입니다.';
      } else if (same == "not same") {
        return '동일인이 아닙니다. 본인의 얼굴로만 대여가 가능합니다.';
      } else {
        return "얼굴을 인식할 수 없습니다. 다시 시도해주세요.";
      }
    } catch (e) {
      print('Error comparing faces: $e');
      return '얼굴 비교 중 오류가 발생했습니다. 다시 시도해주세요.';
    }
  }

  void _showResponseDialog(String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('동일인 여부'),
          content: Text(response),
          actions: [
            if (response == "등록된 얼굴 사진과 동일인입니다.") ...[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 팝업 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthDonePage(userInfo: widget.userFaceInfo),
                    ),
                  );
                },
                child: Text('다음'),
              ),
            ] else ...[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 팝업 닫기
                  // 동일인이 아닐 경우 다시 얼굴 촬영 시도
                },
                child: Text('다시 촬영'),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  '얼굴을 영역 안에 맞추고\n촬영해 주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 30),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: FloatingActionButton(
                  backgroundColor: safeTgreen,
                  onPressed: _takePicture,
                  child: Icon(Icons.camera_alt, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
