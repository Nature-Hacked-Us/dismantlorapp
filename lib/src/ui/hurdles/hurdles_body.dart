import 'package:dismantlorapp/src/blocs/hurdles/hurdles_bloc.dart';
import 'package:dismantlorapp/src/blocs/hurdles/hurdles_event.dart';
import 'package:dismantlorapp/src/blocs/hurdles/hurdles_state.dart';
import 'package:dismantlorapp/src/models/dream.dart';
import 'package:dismantlorapp/src/models/hurdle.dart';
import 'package:dismantlorapp/src/ui/findings/findings_screen.dart';
import 'package:dismantlorapp/src/validators/name_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'hurdle_tile.dart';

class HurdlesBody extends StatefulWidget {
  final Dream _dream;

  HurdlesBody({Key key, @required Dream dream})
    : assert(dream != null),
      _dream = dream,
      super(key: key);

  @override
  State<HurdlesBody> createState() => _HurdlesBodyState(_dream);
}

class _HurdlesBodyState extends State<HurdlesBody> {
  Dream _dream;

  _HurdlesBodyState(Dream dream) : _dream = dream;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HurdlesBloc, HurdlesState>(
        listenWhen: (previous, current) {
          return current is HurdlesMessage
              || current is HurdlesLoadFailure;
        },
        listener: (context, state) {
          if (state is HurdlesMessage) {
            this._showSnackbar(state.success, state.message);
          }
          if (state is HurdlesLoadFailure) {
            this._showSnackbar(false, state.message ?? "Something went terribly wrong");
          }
        },
        buildWhen: (previous, current) {
          return current is HurdlesLoadInProgress
              || current is HurdlesLoadSuccess;
        },
        builder: (context, state) {
          if (state is HurdlesLoadInProgress) {
            return this._getHurdlesLoadInProgressContent();
          }
          if (state is HurdlesLoadSuccess) {
            return this._getHurdlesLoadSuccessContent(context, state);
          }
          return this._getHurdlesLoadFailureContent(null);
        }
    );
  }

  Scaffold _getHurdlesLoadSuccessContent(BuildContext context, HurdlesLoadSuccess state) {
    return Scaffold(
      body: state.hurdles.isEmpty ? Center(
        child: Text(
          'No hurdles have been added yet',
          style: TextStyle(fontStyle: FontStyle.italic, color: Theme.of(context).disabledColor)
        )
      ) : ListView.builder(
        itemCount: state.hurdles.length,
        itemBuilder: (context, index) => HurdleTile(hurdle: state.hurdles[index], onTab: () => _onTab(state.hurdles[index]), onLongPressed: () => _onLongPress(state.hurdles[index])),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: _onAddPressed,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showSnackbar(bool success, String message) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(message, overflow: TextOverflow.fade), Icon(success ? Icons.check : Icons.error)],
          ),
          backgroundColor: success ? Colors.green : Colors.red,),
      );
  }

  Center _getHurdlesLoadInProgressContent() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Center _getHurdlesLoadFailureContent(String message) {
    return Center(
      child: Text(message ?? 'Failed to load hurdles'),
    );
  }

  void _onTab(Hurdle hurdle) {
    HapticFeedback.vibrate();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation1, animation2) => BlocProvider.value(
          value: BlocProvider.of<HurdlesBloc>(context),
          child: FindingsScreen(dream: _dream, hurdle: hurdle),
        ),
      ),
    );
  }

  void _onLongPress(Hurdle hurdle) {
    HapticFeedback.vibrate();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _getHurdleAlertDialog(hurdle);
      }
    );
  }

  AlertDialog _getHurdleAlertDialog(Hurdle hurdle) {
    return AlertDialog(
      title: Text("Delete or edit Hurdle"),
      actions: <Widget>[
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.delete),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
            _onDeletePressed(hurdle);
          },
        ),
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.edit),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
            _onUpdatePressed(hurdle);
          },
        ),
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.clear),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _onAddPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _getAddHurdleAlertDialog();
      }
    );
  }

  void _onDeletePressed(Hurdle hurdle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _getDeleteHurdleAlertDialog(hurdle);
      }
    );
  }

  void _onUpdatePressed(Hurdle hurdle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _getUpdateHurdleAlertDialog(hurdle);
      }
    );
  }

  AlertDialog _getAddHurdleAlertDialog() {
    TextEditingController controller = new TextEditingController();
    return AlertDialog(
      title: Text("ADD HURDLE"),
      content: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'title',
        ),
        validator: (_) {
          return NameValidator.isValidNameOrEmpty(controller.text)
              ? null
              : 'Invalid title';
        },
      ),
      actions: <Widget>[
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.check),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
            BlocProvider.of<HurdlesBloc>(context).add(AddHurdlePressed(title: controller.text.trim()));
          },
        ),
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.clear),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  AlertDialog _getDeleteHurdleAlertDialog(Hurdle hurdle) {
    return AlertDialog(
      title: Text("DELETE HURDLE"),
      content: Text("Are you really sure you want to DELETE the hurdle?"),
      actions: <Widget>[
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.delete),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
            BlocProvider.of<HurdlesBloc>(context).add(DeleteHurdlePressed(hurdleId: hurdle.id));
          },
        ),
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.clear),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  AlertDialog _getUpdateHurdleAlertDialog(Hurdle hurdle) {
    TextEditingController controller = new TextEditingController();
    controller.text = hurdle.title;
    return AlertDialog(
      title: Text("UPDATE HURDLE"),
      content: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'title',
        ),
        validator: (_) {
          return NameValidator.isValidNameOrEmpty(controller.text)
              ? null
              : 'Invalid title';
        },
      ),
      actions: <Widget>[
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.check),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
            if (hurdle.title != controller.text.trim()) {
              BlocProvider.of<HurdlesBloc>(context).add(UpdateHurdlePressed(hurdleId: hurdle.id, title: controller.text.trim()));
            }
          },
        ),
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.clear),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}