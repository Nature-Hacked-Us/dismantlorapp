import 'package:dismantlorapp/src/models/dream.dart';
import 'package:flutter/material.dart';

class OverviewTile extends StatelessWidget {
  final Dream _dream;
  final VoidCallback _onTab;
  final VoidCallback _onLongPressed;

  OverviewTile({@required Dream dream, @required VoidCallback onTab, @required VoidCallback onLongPressed})
      : assert(dream != null),
        this._onTab = onTab,
        this._onLongPressed = onLongPressed,
        this._dream = dream;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: InkWell(
          onTap: _onTab,
          onLongPress: _onLongPressed,
          child: ListTile(
            title: Text(_dream.title, overflow: TextOverflow.fade),
          )
        ),
      ),
    );
  }
}