import 'package:flutter/material.dart';

class FaqBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Container(
                height: 30,
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 25.0),
                      _getDescription('If you have any questions, please reach out to naturehackedus@gmail.com'),
                      SizedBox(height: 30.0)
                    ],
                  ),
                )
            ),
          ],
        )
    );
  }

  Container _getDescription(String description) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
          description,
          style: _getTextStyle()
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Container _getSubtitle(String description) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
          description,
          style: _getTextStyle(bold: true)
      ),
      alignment: Alignment.centerLeft,
    );
  }

  TextStyle _getTextStyle({bool bold = false}) {
    return TextStyle(
        letterSpacing: 2.0,
        fontSize: 15.0,
        fontWeight: bold ? FontWeight.w900 : null,
    );
  }
}