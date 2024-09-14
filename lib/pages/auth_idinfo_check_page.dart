import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safet/models/user_info.dart';
import 'package:safet/main.dart';
import 'package:safet/pages/auth_face_how_page.dart';

class IdInfoCheckPage extends StatefulWidget {
  final List<String> recognizedLines;
  final File licenseImage;
  final String? dateOfIssue;
  final String? dateOfBirth;
  final String? licenseNumber;

  IdInfoCheckPage({
    required this.recognizedLines,
    required this.licenseImage,
    this.dateOfIssue,
    this.dateOfBirth,
    this.licenseNumber,
  });

  @override
  _IdInfoCheckPageState createState() => _IdInfoCheckPageState();
}

class _IdInfoCheckPageState extends State<IdInfoCheckPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateOfIssueController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  String? _selectedLicenseType;

  @override
  void initState() {
    super.initState();
    _dateOfIssueController.text = widget.dateOfIssue ?? '2024.04.19';
    _dateOfBirthController.text = widget.dateOfBirth ?? '010130';
    _licenseNumberController.text = widget.licenseNumber ?? '00-11-222222-33';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateOfIssueController.dispose();
    _dateOfBirthController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  void _navigateToAuthFaceHow(BuildContext context) {
    final userInfo = UserInfo(
      name: _nameController.text,
      licenseType: _selectedLicenseType ?? '',
      licenseNumber: _licenseNumberController.text,
      dateOfBirth: _dateOfBirthController.text,
      dateOfIssue: _dateOfIssueController.text,
    );

  print('Navigating to FaceHowPage with UserInfo: ${userInfo.toString()}');
  
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaceHowPage(
          userInfo: userInfo,
          licenseImage: widget.licenseImage,
        ),
      ),
    );
  }

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '인식된 신분증 정보를 확인해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            _buildInfoRow('이름', _nameController, '이름을 입력하세요'),
            SizedBox(height: 10),
            _buildDropdownRow(
              label: '면허종류',
              items: [
                '2종 보통',
                '1종 보통',
                '2종 원동기 장치 자전거'
              ],
              value: _selectedLicenseType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLicenseType = newValue;
                });
              },
              hintText: '면허종류를 선택해주세요',
            ),
            SizedBox(height: 10),
            _buildInfoRow('발급일', _dateOfIssueController, '2024.04.19'),
            SizedBox(height: 10),
            _buildInfoRow('생년월일', _dateOfBirthController, '010130'),
            SizedBox(height: 10),
            _buildInfoRow('운전면허 번호', _licenseNumberController, '00-11-222222-33'),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: safeTgreen,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                _navigateToAuthFaceHow(context);
              },
              child: Text(
                '다음',
                style: TextStyle(fontSize: 18,color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: safeTgreen),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: safeTlightgreen),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
      ),
    );
  }

  Widget _buildInfoRow(String label, TextEditingController controller, String hintText) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: controller,
            label: label,
            hintText: hintText,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownRow({
    required String label,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
    required String hintText,
  }) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
              enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: safeTlightgreen, width: 1.0), // 클릭되지 않은 상태의 경계선
            ),
            ),
            hint: Text(hintText),
            value: value,
            onChanged: onChanged,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
