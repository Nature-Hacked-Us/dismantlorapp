import 'package:dismantlorapp/src/blocs/overview/overview_event.dart';
import 'package:dismantlorapp/src/models/dream.dart';
import 'package:dismantlorapp/src/ui/hurdles/hurdles_screen.dart';
import 'package:dismantlorapp/src/validators/name_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dismantlorapp/src/blocs/overview/overview_bloc.dart';
import 'package:dismantlorapp/src/blocs/overview/overview_state.dart';

import 'overview_tile.dart';


class OverviewBody extends StatefulWidget {
  @override
  State<OverviewBody> createState() => _OverviewBodyState();
}

class _OverviewBodyState extends State<OverviewBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OverviewBloc, OverviewState>(
        listenWhen: (previous, current) {
          return current is OverviewMessage
              || current is OverviewLoadFailure;
        },
        listener: (context, state) {
          if (state is OverviewMessage) {
            this._showSnackbar(state.success, state.message);
          }
          if (state is OverviewLoadFailure) {
            this._showSnackbar(false, state.message ?? "Something went terribly wrong");
          }
        },
        buildWhen: (previous, current) {
          return current is OverviewLoadInProgress
              || current is OverviewLoadSuccess;
        },
        builder: (context, state) {
          if (state is OverviewLoadInProgress) {
            return this._getOverviewLoadInProgressContent();
          }
          if (state is OverviewLoadSuccess) {
            return this._getOverviewLoadSuccessContent(context, state);
          }
          return this._getOverviewLoadFailureContent(null);
        }
    );
  }

  Scaffold _getOverviewLoadSuccessContent(BuildContext context, OverviewLoadSuccess state) {
    return Scaffold(
      body: state.dreams.isEmpty ? Center(
        child: Text(
          'No dreams have been added yet',
          style: TextStyle(fontStyle: FontStyle.italic, color: Theme.of(context).disabledColor)
        )
      ) : ListView.builder(
        itemCount: state.dreams.length,
        itemBuilder: (context, index) => OverviewTile(dream: state.dreams[index], onTab: () => _onTab(state.dreams[index]), onLongPressed: () => _onLongPress(state.dreams[index])),
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

  Center _getOverviewLoadInProgressContent() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Center _getOverviewLoadFailureContent(String message) {
    return Center(
      child: Text(message ?? 'Failed to load dreams'),
    );
  }

  void _onTab(Dream dream) {
    HapticFeedback.vibrate();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation1, animation2) => BlocProvider.value(
          value: BlocProvider.of<OverviewBloc>(context),
          child: HurdlesScreen(dream: dream),
        ),
      ),
    );
  }

  void _onLongPress(Dream dream) {
    HapticFeedback.vibrate();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _getDreamAlertDialog(dream);
      }
    );
  }

  AlertDialog _getDreamAlertDialog(Dream dream) {
    return AlertDialog(
      title: Text("Delete or edit Dream"),
      actions: <Widget>[
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.delete),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
            _onDeletePressed(dream);
          },
        ),
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.edit),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
            _onUpdatePressed(dream);
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
          return _getAddDreamAlertDialog();
        }
    );
  }

  void _onDeletePressed(Dream dream) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _getDeleteDreamAlertDialog(dream);
        }
    );
  }

  void _onUpdatePressed(Dream dream) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _getUpdateDreamAlertDialog(dream);
        }
    );
  }

  AlertDialog _getAddDreamAlertDialog() {
    TextEditingController controller = new TextEditingController();
    return AlertDialog(
      title: Text("ADD DREAM"),
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
            BlocProvider.of<OverviewBloc>(context).add(AddDreamPressed(title: controller.text.trim()));
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

  AlertDialog _getDeleteDreamAlertDialog(Dream dream) {
    return AlertDialog(
      title: Text("DELETE DREAM"),
      content: Text("Are you really sure you want to DELETE the dream?"),
      actions: <Widget>[
        IconButton(
          color: Theme.of(context).primaryColorDark,
          icon: Icon(Icons.delete),
          onPressed: () {
            HapticFeedback.vibrate();
            Navigator.of(context).pop();
            BlocProvider.of<OverviewBloc>(context).add(DeleteDreamPressed(dreamId: dream.id));
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

  AlertDialog _getUpdateDreamAlertDialog(Dream dream) {
    TextEditingController controller = new TextEditingController();
    controller.text = dream.title;
    return AlertDialog(
      title: Text("UPDATE DREAM"),
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
            if (dream.title != controller.text.trim()) {
              BlocProvider.of<OverviewBloc>(context).add(UpdateDreamPressed(dreamId: dream.id, title: controller.text.trim()));
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