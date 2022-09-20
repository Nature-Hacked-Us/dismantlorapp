import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'faq_body.dart';

class FaqScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
          },
        ),
        title: Text('FAQ'),
        centerTitle: true,
      ),
      body: FaqBody(),
    );
  }
}