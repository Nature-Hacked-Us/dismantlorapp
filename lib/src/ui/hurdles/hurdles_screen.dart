import 'package:dismantlorapp/src/blocs/hurdles/hurdles_bloc.dart';
import 'package:dismantlorapp/src/models/dream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'hurdles_body.dart';

class HurdlesScreen extends StatelessWidget {
  final Dream _dream;

  HurdlesScreen({Key key, @required dream})
      : assert(dream != null),
        this._dream = dream,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HurdlesBloc(dreamId: _dream.id),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              HapticFeedback.vibrate();
              Navigator.of(context).pop();
            },
          ),
          title: Text('Hurdles'),
          centerTitle: true,
        ),
        body: HurdlesBody(dream: _dream),
      ),
    );
  }
}