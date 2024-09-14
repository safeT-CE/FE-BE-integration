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
    '서비스 이용약관',
    '위치 기반 서비스 이용약관',
    '개인정보 수집이용 동의',
    '전자금융거래 이용약관 동의',
    '전동킥보드 임대약관',
    '카메라 사용 및 개인정보',
    'SMS 수신동의',
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
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: safeTlightgreen, // 기본 색상 설정
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '약관에 동의해 주세요.',
            style: TextStyle(color: safeTblack),
          ),
          centerTitle: true, // title 중앙정렬
          automaticallyImplyLeading: false, // 뒤로 가기 버튼 제거
          backgroundColor: Colors.white,
          elevation: 0, // 그림자 제거
          actions: [
            IconButton(
              icon: Icon(Icons.close, color: safeTgray),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        backgroundColor: Colors.white, // Scaffold 배경색 흰색으로 설정
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: safeTlightgreen, // 체크되지 않은 상태의 테두리 색상
                    ),
                    child:Checkbox(
                      value: _allAgree,
                      onChanged: (bool? value) {
                        setState(() {
                          _allAgree = value!;
                          for (int i = 0; i < _agreeList.length; i++) {
                            _agreeList[i] = _allAgree;
                          }
                        });
                      },
                      activeColor: safeTgreen,
                      checkColor: Colors.white,
                    ),
                  ),
                  Text('약관 전체 동의'),
                ],
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _agreeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Checkbox(
                        value: _agreeList[index],
                        onChanged: (bool? value) {
                          setState(() {
                            _agreeList[index] = value!;
                            _allAgree = _agreeList.every((bool agree) => agree);
                          });
                        },
                        activeColor: safeTgreen,
                        checkColor: Colors.white,
                      ),
                      title: Text(_agreeTitles[index]),
                      trailing: Icon(Icons.arrow_forward_ios, color: safeTlightgreen),
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return safeTlightgreen; // 비활성화 상태의 색상 설정
                      }
                      return safeTgreen; // 기본 상태의 색상 설정
                    },
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                ),
                child: Text(
                  '동의하고 진행',
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
          style: TextStyle(color: safeTblack), // Set title color here
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: safeTgray),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // Scaffold 배경색 흰색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(16.0),

      ),
    );
  }
}
