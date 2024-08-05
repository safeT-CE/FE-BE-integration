import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:safet/main.dart';
import 'package:safet/pages/auth_idinfo_check_page.dart';

class IdCamPage extends StatefulWidget {
  final CameraDescription camera;

  IdCamPage({required this.camera});

  @override
  _IdCamPageState createState() => _IdCamPageState();
}

class _IdCamPageState extends State<IdCamPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final textRecognizer = GoogleMlKit.vision.textRecognizer();
  List<String> _recognizedLines = [];
  bool _showWarning = false;
  Timer? _warningTimer;
  Timer? _focusTimer;

  String? dateOfIssue;
  String? dateOfBirth;
  String? licenseNumber;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize().then((_) {
      _controller.setFocusMode(FocusMode.auto);
      _startFocusTimer();
    });
  }

  void _startFocusTimer() {
    _focusTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_controller.value.isInitialized) {
        _controller.setFocusPoint(null);  // 포커스를 재조정하기 위해 초점 재설정
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    textRecognizer.close();
    _warningTimer?.cancel();
    _focusTimer?.cancel();
    super.dispose();
  }

  Future<void> _processImage() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      List<String> recognizedLines = recognizedText.blocks
          .expand((block) => block.lines)
          .map((line) => line.text.trim())
          .toList();

      setState(() {
        _recognizedLines = recognizedLines;
      });

      if (_recognizedLines.isNotEmpty) {
        _extractInfo(_recognizedLines);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IdInfoCheckPage(
              dateOfIssue: dateOfIssue,
              dateOfBirth: dateOfBirth,
              licenseNumber: licenseNumber,
              recognizedLines: _recognizedLines,
            ),
          ),
        );
      } else {
        _showWarningMessage();
      }
    } catch (e) {
      print(e);
      _showWarningMessage();
    }
  }

  void _extractInfo(List<String> lines) {
    RegExp dateRegExp = RegExp(r'\d{4}\.\d{2}\.\d{2}');
    RegExp idRegExp = RegExp(r'\d{6}-\d{7}');
    RegExp licenseRegExp = RegExp(r'\d{2}-\d{2}-\d{6}-\d{2}');

    for (var line in lines) {
      if (dateRegExp.hasMatch(line)) {
        dateOfIssue = dateRegExp.stringMatch(line);
      }
      if (idRegExp.hasMatch(line)) {
        dateOfBirth = idRegExp.stringMatch(line)?.substring(0, 6);
      }
      if (licenseRegExp.hasMatch(line)) {
        licenseNumber = licenseRegExp.stringMatch(line);
      }
    }
  }

  void _showWarningMessage() {
    setState(() {
      _showWarning = true;
    });

    _warningTimer?.cancel();
    _warningTimer = Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showWarning = false;
        });
      }
    });
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
                return CameraPreview(_controller);
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
                  '신분증을 영역 안에 맞추고\n촬영해 주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 30),
                Container(
                  width: 250,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: ListView.builder(
                    itemCount: _recognizedLines.length,
                    itemBuilder: (context, index) {
                      return Text(
                        _recognizedLines[index],
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 200,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF0B0B0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.yellow),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '신분증에 빛이 반사되지 않도록 영역 안에\n조절하여 주세요.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showWarning)
            Positioned(
              bottom: 120,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '텍스트를 인식하지 못했습니다.\n다시 시도해주세요.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: safeTgreen,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: _processImage,
              child: Text(
                '다음',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
