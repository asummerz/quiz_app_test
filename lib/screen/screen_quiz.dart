import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:quiz_app_test/model/model_quiz.dart';
import 'package:quiz_app_test/screen/screen_result.dart';
import 'package:quiz_app_test/widget/widget_candidate.dart';

class QuizScreen extends StatefulWidget {
  List<Quiz> quizs;
  // 생성자 선언(호출)
  // 생성자를 통해 이전 화면으로부터 퀴즈 데이터를 넘겨받음
  QuizScreen({this.quizs});
  // 상태 관리 선언
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

// _QuizScreenState에서는 문제수만큼 상태 정보가 필요하다.
// 1. 각 퀴즈별 사용자의 정답을 담아 놓을 _answers 리스트 => 초기값 = -1
// 2. _answerState는 퀴즈 하나에 대하여 각 보기가 선택되었는지 보기개수만큼 boolean형으로 기록하는 리스트 => 초기값 = false
// 3. 현재 보고있는 문제가 몇 번째인지에 대한 _currentIndex
class _QuizScreenState extends State<QuizScreen> {
  List<int> _answers = [-1, -1, -1];
  List<bool> _answerState = [false, false, false, false];
  int _currentIndex = 0;
  SwiperController _controller = SwiperController();

  // MediaQuery로 사이즈 정보를 가져온다.
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    // 화면 구성
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.lightBlue),
            ),
            // 퀴즈 카드의 너비
            width: width * 0.85,
            // 퀴즈 카드의 높이
            height: height * 0.65,
            // pubspec.yaml 에서 swiper 패키지를 설치한 후 자동 import한다.
            child: Swiper(
              controller: _controller,
              // NeverScrollableScrollPhysics : 해당 옵션을 적용하면 swipe 모션을 통해 강제로 넘어가지 않는다.
              // 즉, 현재 퀴즈를 풀어야지만 다음 페이지로 넘어갈 수 있다. 퀴즈 스킵 못 함
              physics: NeverScrollableScrollPhysics(),
              loop: false,
              itemCount: widget.quizs.length,
              // itemBuilder는 새로운 함수 형태로 작성한다.
              // 해당 함수는 _QuizScreenState 내에도 작성한다.
              itemBuilder: (BuildContext context, int index) {
                return _buildQuizCard(widget.quizs[index], width, height);
              },
            ),
          ),
        ),
      ),
    );
  }

  // 퀴즈 문제, 보기
  Widget _buildQuizCard(Quiz quiz, double width, double height) {
    return Container(
      decoration: BoxDecoration(
          // 퀴즈 카드 테두리 라운딩 처리
          borderRadius: BorderRadius.circular(30),
          // 퀴즈 카드 테두리 색상
          border: Border.all(color: Colors.white),
          // 퀴즈 카드 테두리 안 색상
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
                0, // left
                width * 0.024, // top
                0, // right
                width * 0.024 //bottom
                ),
            // 최초 퀴즈 인덱스값 = 0 이므로 1씩 증가한다.
            child: Text(
              'Q' + (_currentIndex + 1).toString() + '.',
              style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: width * 0.8,
            padding: EdgeInsets.only(top: width * 0.012),
            child: AutoSizeText(
              // 퀴즈의 타이틀 길이는 항상 동일하도록 디폴트값이 없으므로
              // 제약이 없을 시 보기 영역을 넘어설 수 있기때문에
              // 텍스트의 길이를 자동으로 줄여주는 기능이 필요하다.
              // => auto_size_text 라는 패키지를 pubspec.yaml 에 설치하고 사용한다.
              quiz.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                  fontSize: width * 0.048, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          // 퀴즈 선택지(보기)
          Column(
            children: _buildCandidates(width, quiz),
          ),
          Container(
            padding: EdgeInsets.all(width * 0.024),
            child: Center(
              child: ButtonTheme(
                minWidth: width * 0.5,
                height: height * 0.05,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                // 퀴즈 카드 하단 버튼 생성
                // 현재 인덱스가 마지막 퀴즈를 가리킨다면 결과보기
                // 아닐 경우엔 다음 문제가 나오도록 설정한다.
                child: RaisedButton(
                  child: _currentIndex == widget.quizs.length - 1
                      ? Text('결과보기')
                      : Text('다음문제'),
                  textColor: Colors.white,
                  color: Colors.lightBlue,
                  // _answers == -1 : 아직 정답 체크가 되지 않은 초기의 상태
                  // 즉, _answers 배열의 값들이 초기값 그대로 있다는 뜻
                  //  => onPressed를 null로 설정하여 다음 문제로 못 넘어가도록 설정
                  // _answers != -1
                  //  => 마지막 문제인지 확인후 마지막이면 결과보기로 설정
                  //  => 마지막이 아닌 경우, _answerState를 초기화시키고 _currentIndex을 증가함
                  // 다음 문제로 넘어가려면 Swiper의 controller를 선언해줘야 한다.
                  //  => _QuizScreenState 내에 선언해야됨
                  onPressed: _answers[_currentIndex] == -1
                      ? null
                      : () {
                          // 현재 문제가 마지막 문제인가?
                          if (_currentIndex == widget.quizs.length - 1) {
                            // 결과보기 버튼 클릭 시 보여지는 화면 구성 설정
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultScreen(
                                        answers: _answers,
                                        quizs: widget.quizs)));
                          } else {
                            _answerState = [false, false, false, false, false];
                            _currentIndex += 1;
                            _controller.next();
                          }
                        },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 퀴즈 선택지(보기)
  // _QuizScreenState 클래스 내에 메서드 선언
  List<Widget> _buildCandidates(double width, Quiz quiz) {
    List<Widget> _children = [];
    for (int i = 0; i < 4; i++) {
      // 각각의 보기 위젯은 따로 위젯파일로 클래스를 만들어 활용한다.
      // widget 폴더 > widget_candidate.dart 파일이다.
      _children.add(
        CandWidget(
          index: i,
          text: quiz.candidates[i],
          width: width,
          answerState: _answerState[i],
          tap: () {
            setState(() {
              // 반복문을 통해 전체 보기를 확인하며 현재 보기의
              // answerState를 true로 변경해주며 answer에 기록한다.
              // 만약 아닐 경우, false로 설정한다.
              for (int j = 0; j < 4; j++) {
                if (j == i) {
                  _answerState[j] = true;
                  _answers[_currentIndex] = j;
                  // 인덱스 제대로 선택되는지 debug console에서 로그확인
                  // print(_answers[_currentIndex]);
                  // flutter를 이용한 시뮬레이터 너비값 확인
                  // print(width);
                } else {
                  _answerState[j] = false;
                }
              }
            });
          },
        ),
      );
      _children.add(
        Padding(
          padding: EdgeInsets.all(width * 0.024),
        ),
      );
    }
    return _children;
  }
}
