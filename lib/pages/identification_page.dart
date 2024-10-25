import 'dart:async';
import 'dart:io';

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:safet/utils/constants.dart'; // baseUrl 가져오기
import 'package:shared_preferences/shared_preferences.dart';

class IdentificationPage extends StatefulWidget {
  final CameraDescription camera;

  const IdentificationPage({Key? key, required this.camera}) : super(key: key);

  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _initializationFailed = false;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      _controller = CameraController(widget.camera, ResolutionPreset.high);
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;
      setState(() {
        _isCameraInitialized = true;
        _initializationFailed = false;
      });
    } catch (e) {
      setState(() {
        _isCameraInitialized = false;
        _initializationFailed = true;
      });
      Future.delayed(const Duration(seconds: 2), initializeCamera);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureAndSendImage() async {
    try {
      await _initializeControllerFuture;
      final faceImage = await _controller!.takePicture();
      await _sendImageToServer(faceImage);
    } catch (e) {
      _showErrorDialog(context, '사진 촬영에 실패했습니다. 다시 시도해주세요.');
      print('Error capturing image: $e');
    }
  }

  Future<void> _sendImageToServer(XFile image) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        _showErrorDialog(context, '사용자 ID를 불러오는 데 실패했습니다.');
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}kickboard/rent/identify'),
      );
      request.headers['Accept'] = 'application/json';
      request.fields['userId'] = userId;

      var faceImageStream = http.ByteStream(image.openRead());
      var faceImageLength = await image.length();
      request.files.add(
        http.MultipartFile(
          'faceImage',
          faceImageStream,
          faceImageLength,
          filename: p.basename(image.path),
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        _showErrorDialog(context, '이미지 업로드에 실패했습니다.');
      }
    } catch (e) {
      _showErrorDialog(context, '서버로 이미지를 전송하는 데 실패했습니다.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('얼굴 인식 실패'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isCameraInitialized
          ? Stack(
              children: <Widget>[
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Center(
                        child: CameraPreview(_controller!),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 100,
                  child: Column(
                    children: [
                      Text(
                        '얼굴을 영역 안에 맞추고\n촬영해 주세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
                    child: ElevatedButton(
                      onPressed: () async {
                        await _captureAndSendImage();
                      },
                      child: Text('다음'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
