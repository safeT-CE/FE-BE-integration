import 'package:flutter/material.dart';
import 'package:safet/main.dart';

class AgreementPage extends StatefulWidget {
  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool _allAgree = false;
  List<bool> _agreeList = List<bool>.generate(7, (_) => false);

  // 약관 항목의 제목 리스트
  final List<String> _agreeTitles = [
    '111111',
    '222',
    '33',
    '4444',
    '555555',
    '66666',
    '777777',
  ];

  // 각 항목의 상세 내용 리스트
  final List<String> _agreeContents = [
    '111111의 상세 내용입니다.',
    'aaaaa의 상세 내용입니다.',
    'bbbbb의 상세 내용입니다.',
    '약관 항목 4의 상세 내용입니다.',
    '약관 항목 5의 상세 내용입니다.',
    '약관 항목 6의 상세 내용입니다.',
    '약관 항목 7의 상세 내용입니다.',
  ];

  void _navigateToDetailPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgreementDetailPage(
          title: _agreeTitles[index],
          content: _agreeContents[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('약관에 동의해 주세요.'),
        centerTitle: true, // title 중앙정렬
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
        actions:[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: Text('약관 전체 동의'),
              value: _allAgree,
              onChanged: (bool? value) {
                setState(() {
                  _allAgree = value!;
                  for (int i = 0; i < _agreeList.length; i++) {
                    _agreeList[i] = _allAgree;
                  }
                });
              },
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _agreeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_agreeTitles[index]),
                    trailing: Checkbox(
                      value: _agreeList[index],
                      onChanged: (bool? value) {
                        setState(() {
                          _agreeList[index] = value!;
                          _allAgree = _agreeList.every((bool agree) => agree);
                        });
                      },
                    ),
                    onTap: () {
                      _navigateToDetailPage(index);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _agreeList.every((bool agree) => agree)
                  ? () {
                      // 다음 페이지로 이동 또는 약관 동의 처리
                      Navigator.pushNamed(context, '/auth_phonenumber');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('동의하고 진행'),
            ),
          ],
        ),
      ),
    );
  }
}

class AgreementDetailPage extends StatelessWidget {
  final String title;
  final String content;

  AgreementDetailPage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: safeTgray), // Set title color here
        ),
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(content),
      ),
    );
  }
}
