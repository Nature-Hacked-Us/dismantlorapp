import 'package:dismantlorapp/src/blocs/findings/findings_bloc.dart';
import 'package:dismantlorapp/src/models/dream.dart';
import 'package:dismantlorapp/src/models/hurdle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'findings_body.dart';

class FindingsScreen extends StatelessWidget {
  final Dream _dream;
  final Hurdle _hurdle;

  FindingsScreen({Key key, @required Dream dream, @required Hurdle hurdle})
      : assert(dream != null),
        assert(hurdle != null),
        this._dream = dream,
        this._hurdle = hurdle,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FindingsBloc(dreamId: _dream.id, hurdleId: _hurdle.id),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              HapticFeedback.vibrate();
              Navigator.of(context).pop();
            },
          ),
          title: Text('Findings'),
          centerTitle: true,
        ),
        body: FindingsBody(),
      ),
    );
  }
}