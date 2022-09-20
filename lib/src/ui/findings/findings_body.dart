import 'package:dismantlorapp/src/blocs/findings/findings_bloc.dart';
import 'package:dismantlorapp/src/blocs/findings/findings_event.dart';
import 'package:dismantlorapp/src/blocs/findings/findings_state.dart';
import 'package:dismantlorapp/src/helpers/string_helper.dart';
import 'package:dismantlorapp/src/models/finding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FindingsBody extends StatefulWidget {
  @override
  State<FindingsBody> createState() => _FindingsBodyState();
}

class _FindingsBodyState extends State<FindingsBody> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  bool _editMode = false;
  TextEditingController _textEditingController = new TextEditingController();
  Finding _currentFinding;
  List<BottomNavigationBarItem> _bottomNavigationBarItems;

  @override
  void initState() {
    super.initState();
    _initBottomNavigationBarItems(11);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FindingsBloc, FindingsState>(
        listenWhen: (previous, current) {
          return current is FindingsMessage
              || current is FindingsLoadFailure;
        },
        listener: (context, state) {
          if (state is FindingsMessage) {
            this._showSnackbar(state.success, state.message);
          }
          if (state is FindingsLoadFailure) {
            this._showSnackbar(false, state.message ?? "Something went terribly wrong");
          }
        },
        buildWhen: (previous, current) {
          return current is FindingsLoadInProgress
              || current is FindingsLoadSuccess;
        },
        builder: (context, state) {
          if (state is FindingsLoadInProgress) {
            return this._getFindingsLoadInProgressContent();
          }
          if (state is FindingsLoadSuccess) {
            return this._getFindingsLoadSuccessContent(context, state);
          }
          return this._getFindingsLoadFailureContent(null);
        }
    );
  }

  Scaffold _getFindingsLoadSuccessContent(BuildContext context, FindingsLoadSuccess state) {
    return Scaffold(
      body: state.findings.isEmpty ? Center(child: Text('No findings have been added yet')) : PageView.builder(
        controller: _pageController,
        onPageChanged: (page) => setState(() => _currentIndex = page),
        physics: _editMode ? NeverScrollableScrollPhysics() : null,
        itemCount: state.findings.length,
        itemBuilder: (context, index) => _getFindingPage(state.findings[index]),
      ),
      bottomNavigationBar: _getBottomNavigationBar(state.findings.length),
    );
  }

  Padding _getFindingPage(Finding finding) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Text(
                finding.question,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900)
              ),
            ),
            Expanded(
              child: InkWell(
                onLongPress: () {
                  HapticFeedback.vibrate();
                  setState(() {
                    _currentFinding = finding;
                    _editMode = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                  child: SingleChildScrollView(child: _getAnswer(finding)),
                  alignment: StringHelper.isBlank(finding.answer) && _editMode == false ? Alignment.center : Alignment.topLeft,
                ),
              )
            ),
          ]
        ),
      ),
    );
  }

  Widget _getAnswer(Finding finding) {
    if (_editMode) {
      _textEditingController.text = finding.answer;
      return TextFormField(
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        maxLines: null,
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: 'Paste your findings here...',
        ),
        style: TextStyle(
          fontSize: 15.0,
          //fontWeight: FontWeight.bold,
        ),
      );
    }
    return StringHelper.isNotBlank(finding.answer) ? Text(
      finding.answer,
      style: TextStyle(
        fontSize: 15.0,
      ),
    ) : Text(
      'Long press to add your findings here',
      style: TextStyle(
        fontSize: 15.0,
        fontStyle: FontStyle.italic,
        color: Theme.of(context).disabledColor,
      ),
    );
  }

  BottomNavigationBar _getBottomNavigationBar(int itemCount) {
    if (_editMode) {
      return BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                HapticFeedback.vibrate();
                BlocProvider.of<FindingsBloc>(context).add(DeleteFindingPressed(findingId: _currentFinding.id));
                setState(() {
                  _textEditingController.text = '';
                  _currentFinding = null;
                  _editMode = false;
                });
              },
            ),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                HapticFeedback.vibrate();
                setState(() {
                  _textEditingController.text = '';
                  _currentFinding = null;
                  _editMode = false;
                });
              },
            ),
            label: ''
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                HapticFeedback.vibrate();
                String editedAnswer = _textEditingController.text.trim();
                if (editedAnswer != _currentFinding.answer) {
                  BlocProvider.of<FindingsBloc>(context).add(UpdateFindingPressed(findingId: _currentFinding.id, answer: editedAnswer));
                }
                setState(() {
                  _textEditingController.text = '';
                  _currentFinding = null;
                  _editMode = false;
                });
              },
            ),
            label: ''
          ),
        ],
      );
    }
    if (_bottomNavigationBarItems == null || _bottomNavigationBarItems.length != itemCount) {
      _initBottomNavigationBarItems(itemCount);
    }
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey[400],
      currentIndex: _currentIndex,
      onTap: (value) {
        _currentIndex = value;
        _pageController.animateToPage(
          value,
          duration: Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn
        );
      },
      items: _bottomNavigationBarItems,
    );
  }

  void _initBottomNavigationBarItems(int itemCount) {
    _bottomNavigationBarItems = new List();
    for (int i = 1; i <= itemCount; i++) {
      _bottomNavigationBarItems.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.circle),
          label: ((i.toDouble() * 100.0) / itemCount.toDouble()).round().toString() + '%',
        )
      );
    }
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

  Center _getFindingsLoadInProgressContent() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Center _getFindingsLoadFailureContent(String message) {
    return Center(
      child: Text(message ?? 'Failed to load findings'),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}