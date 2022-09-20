import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dismantlorapp/src/blocs/overview/overview_bloc.dart';

import 'overview_body.dart';
import 'overview_menu.dart';

class OverviewScreen extends StatelessWidget {
  final String _name;

  OverviewScreen({Key key, @required name})
      : assert(name != null),
        this._name = name,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OverviewBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dreams'),
          centerTitle: true,
        ),
        endDrawer: new Drawer(
          child: OverviewMenu(name: this._name),
        ),
        body: OverviewBody(),
      ),
    );
  }
}