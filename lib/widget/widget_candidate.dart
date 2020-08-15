import 'package:flutter/material.dart';

class CandWidget extends StatefulWidget {
  // VoidCallback은 CandWidget을 사용하는 부모위젯인
  // screen_quiz.dart에서 지정한 onTap을 전달해주는 기능을 한다.
  // onTap은 아래_CandWidgetState 클래스 > child: InkWell 내에 위치함
  VoidCallback tap;
  String text;
  int index;
  double width;
  bool answerState;
  // 생성자 선언
  CandWidget({this.tap, this.index, this.width, this.text, this.answerState});
  _CandWidgetState createState() => _CandWidgetState();
}

// 상태 관리 선언
class _CandWidgetState extends State<CandWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.8,
      height: widget.width * 0.1,
      padding: EdgeInsets.fromLTRB(
        widget.width * 0.048, // left
        widget.width * 0.024, // top
        widget.width * 0.048, // right
        widget.width * 0.024, // bottom
      ),
      // Container에 BoxDecoration을 적용한다.
      // 선택한 보기 : lightBlue, 나머지 보기 : white
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.lightBlue),
          color: widget.answerState ? Colors.lightBlue : Colors.white),
      // 선택한 보기의 텍스트 : white, 나머지 보기의 텍스트 : lightBlue
      child: InkWell(
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.width * 0.035,
            color: widget.answerState ? Colors.white : Colors.lightBlue,
          ),
        ),
        onTap: () {
          setState(() {
            widget.tap();
            widget.answerState = !widget.answerState;
          });
        },
      ),
    );
  }
}
