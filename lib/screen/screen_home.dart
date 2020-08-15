import 'package:flutter/material.dart';
import 'package:quiz_app_test/model/model_quiz.dart';
import 'package:quiz_app_test/screen/screen_quiz.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 퀴즈 더미 데이터 생성
  // 퀴즈 더미 데이터는 API 연동과 관련이 있다.
  // 퀴즈 API를 언제 호출하느냐에 따라 앱 구조를 다르게 작성할 수 있다.
  // 1. 앱이 처음 로드(실행)되었을 때 퀴즈를 가져오는 방식
  // 2. 퀴즈 풀기 버튼을 눌렀을 때 가져오는 방식
  //  => 해당 프로젝트에서는 2번 방식을 사용하여 퀴즈를 랜덤으로 가져오도록 한다.
  //  => 즉, HomeScreen에서 QuizScreen으로 넘어갈 때 퀴즈 데이터를 넘겨줌
  //     List형 퀴즈 더미 데이터를 생성한 후 QuizScrreen으로 넘겨줌
  //  => 실제 API를 호출할 영역인 _HomeScreenState 내부에 퀴즈 더미 데이터를 만듦
  // model > model_quiz.dart를 자동으로 import
  List<Quiz> quizs = [
    Quiz.fromMap({
      'title': 'test',
      'candidates': ['a', 'b', 'c', 'd'],
      'answer': 0
    }),
    Quiz.fromMap({
      'title': 'test',
      'candidates': ['a', 'b', 'c', 'd'],
      'answer': 0
    }),
    Quiz.fromMap({
      'title': 'test',
      'candidates': ['a', 'b', 'c', 'd'],
      'answer': 0
    }),
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    // SafeArea는 기기의 상단 노티 바 부분, 하단 영역을 침범하지 않는
    // 안전한 영역을 잡아주는 위젯이다.
    // return SafeArea(
    // screen_result.dart와 마찬가지로 기본적인 뒤로가기 버튼 기능을 방지하기위해
    // => WillPopScope 라는 위젯. onWillPop 에 false 를 넣어준다.
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
          backgroundColor: Colors.lightBlue,
          leading: Container(), // 앱 상단바 좌측 뒤로가기 기능 등 편집가능
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                'images/quiz.jpeg',
                width: width * 0.5,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.024),
            ),
            Text(
              '플러터를 이용한 퀴즈 앱',
              style: TextStyle(
                  fontSize: width * 0.065, fontWeight: FontWeight.bold),
            ),
            Text(
              '퀴즈를 풀기 전 안내사항입니다.\n꼼꼼히 읽고 퀴즈 풀기를 눌러주세요.',
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.all(width * 0.048)),
            _buildStep(width, '1. 랜덤으로 나오는 퀴즈 3개를 풀어보세요.'),
            _buildStep(width, '2. 문제를 잘 읽고 정답을 고른 뒤\n다음 문제 버튼을 눌러주세요.'),
            _buildStep(width, '3. 만점을 향해 도전해보세요!.'),
            Padding(
              padding: EdgeInsets.all(width * 0.048),
            ),
            // 퀴즈풀기 버튼
            Container(
              padding: EdgeInsets.only(bottom: width * 0.036),
              child: Center(
                child: ButtonTheme(
                  minWidth: width * 0.8,
                  height: height * 0.08,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: RaisedButton(
                    child: Text(
                      '지금 퀴즈 풀기',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.lightBlue,
                    // 버튼 누르면 문제가 나오는 QuizScreen이 뜨도록 설정
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            quizs: quizs,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // width, title을 인자로 받음
  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        width * 0.048, // left
        width * 0.024, //top
        width * 0.048, // right
        width * 0.024, // bottom
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.check_box,
            size: width * 0.04,
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.024),
          ),
          Text(title),
        ],
      ),
    );
  }
}
