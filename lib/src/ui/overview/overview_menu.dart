import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dismantlorapp/src/blocs/authentication/authentication_bloc.dart';
import 'package:dismantlorapp/src/blocs/authentication/authentication_event.dart';
import 'package:dismantlorapp/src/ui/about/about_screen.dart';
import 'package:dismantlorapp/src/ui/faq/faq_screen.dart';

class OverviewMenu extends StatelessWidget {
  final String _name;

  OverviewMenu({@required String name})
      : assert(name != null),
        this._name = name;

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        ListTile(
          title: Text(this._name),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('About'),
          onTap: () {
            HapticFeedback.vibrate();
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, animation1, animation2) => AboutScreen()
              ),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.help_outline),
          title: Text('FAQ'),
          onTap: () {
            HapticFeedback.vibrate();
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, animation1, animation2) => FaqScreen()
              ),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            HapticFeedback.vibrate();
            BlocProvider.of<AuthenticationBloc>(context).add(
              LoggedOut(),
            );
          },
        ),
      ],
    );
  }
}
