import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'about_body.dart';

class AboutScreen extends StatelessWidget {
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
        title: Text('About'),
        centerTitle: true,
      ),
      body: AboutBody(),
    );
  }
}