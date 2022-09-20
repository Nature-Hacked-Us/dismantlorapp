import 'package:dismantlorapp/src/models/hurdle.dart';
import 'package:flutter/material.dart';

class HurdleTile extends StatelessWidget {
  final Hurdle _hurdle;
  final VoidCallback _onTab;
  final VoidCallback _onLongPressed;

  HurdleTile({@required Hurdle hurdle, @required VoidCallback onTab, @required VoidCallback onLongPressed})
      : assert(hurdle != null),
        this._onTab = onTab,
        this._onLongPressed = onLongPressed,
        this._hurdle = hurdle;

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
            title: Text(_hurdle.title, overflow: TextOverflow.fade),
          )
        ),
      ),
    );
  }
}