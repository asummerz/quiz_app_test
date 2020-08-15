import 'package:flutter/material.dart';
import 'package:quiz_app_test/model/model_quiz.dart';
import 'package:quiz_app_test/screen/screen_home.dart';

class ResultScreen extends StatelessWidget {
  List<int> answers;
  List<Quiz> quizs;
  // 생성자 호출
  ResultScreen({this.answers, this.quizs});
  // 화면 크기를 MediaQuery로 가져온다.
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    // 퀴즈의 정답을 체크하며 score 계산
    int score = 0;
    for (int i = 0; i < quizs.length; i++) {
      if (quizs[i].answer == answers[i]) {
        score += 1;
      }
    }
    // 아이폰의 기본적인 스와이프 기능이나 안드로이드 백 버튼을 통해
    // 원치 않는 이전 화면으로 돌아가는 기능을 방지하기위해
    // 전체 화면을 다른 위젯으로 얹어 감싸준다.
    //  => WillPopScope 라는 위젯. onWillPop 에 false 를 넣어주면 된다.
    // return SafeArea(
    return WillPopScope(
      // 뒤로가기 버튼 기능이 적용되지않도록 false 로 설정
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Quiz App'),
          backgroundColor: Colors.lightBlue,
          leading: Container(),
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.lightBlue),
              color: Colors.lightBlue,
            ),
            // score를 보여주는 박스(겉)
            width: width * 0.85,
            height: height * 0.55,
            // score를 보여주는 박스(안)
            // 결과보기 버튼 클릭 시 결과보는 화면을 띄우기 위해
            // screen_quiz.dart > onPressed에 ResultScreen을 넣고
            // quizs와 answers를 넣는다.
            // 컬럼 내부에 패딩과 컨테이너를 넣고 컨테이너는 BoxDecoration으로 스타일 적용한다.
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: width * 0.048),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.lightBlue),
                      color: Colors.white),
                  width: width * 0.73,
                  height: height * 0.3,
                  // 결과를 나타내는 텍스트
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(
                            0, // left
                            width * 0.048, //top
                            0, // right
                            width * 0.012 // bottom
                            ),
                        child: Text(
                          '수고하셨습니다!',
                          style: TextStyle(
                            fontSize: width * 0.055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '당신의 점수는',
                        style: TextStyle(
                          fontSize: width * 0.048,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        score.toString() + '/' + quizs.length.toString(),
                        style: TextStyle(
                          fontSize: width * 0.21,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(width * 0.012),
                      )
                    ],
                  ),
                ),
                // 바깥쪽 컬럼 내에
                Expanded(
                  child: Container(),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: width * 0.048),
                  child: ButtonTheme(
                    minWidth: width * 0.73,
                    height: height * 0.05,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        }));
                      },
                      child: Text('홈으로 돌아가기'),
                      color: Colors.white,
                      textColor: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
