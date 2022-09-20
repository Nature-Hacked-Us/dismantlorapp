import 'package:carousel_slider/carousel_slider.dart';
import 'package:dismantlorapp/src/blocs/authentication/authentication_bloc.dart';
import 'package:dismantlorapp/src/blocs/authentication/authentication_event.dart';
import 'package:dismantlorapp/src/blocs/login/login_bloc.dart';
import 'package:dismantlorapp/src/blocs/login/login_event.dart';
import 'package:dismantlorapp/src/blocs/login/login_state.dart';
import 'package:dismantlorapp/src/resources/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_account_button.dart';
import 'google_login_button.dart';
import 'login_button.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int _currentIndex = 0;

  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(state.isEmailVerified ? 'Login Failure' : 'Email not yet verified'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
                    child: _getSlider(),
                  ),
                  _getIndicator(),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Invalid Password' : null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(
                          onPressed: isLoginButtonEnabled(state)
                            ? _onFormSubmitted
                            : null,
                        ),
                        GoogleLoginButton(),
                        CreateAccountButton(userRepository: _userRepository),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  CarouselSlider _getSlider() {
    return CarouselSlider(
      items: _getItems(),
      options: CarouselOptions(
        height: 200,
        aspectRatio: 9/16,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 8),
        autoPlayAnimationDuration: Duration(milliseconds: 400),
        enlargeCenterPage: true,
        onPageChanged: (index, reason) => setState(() => _currentIndex = index),
        scrollDirection: Axis.horizontal,
      )
    );
  }

  List<Widget> _getItems() {
    return <Widget>[
      Card(
        child: Image.asset('assets/dismantlor.png', fit: BoxFit.cover),
      ),
      Card(
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: ListTile(
          title: Center(
            child: Text(
              "1. Add your dream",
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 25.0,
              ),
            )
          ),
        ),
      ),
      Card(
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: ListTile(
          title: Center(
            child: Text(
              "       2. Add the\nassociated hurdles",
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: 25.0,
              ),
            )
          ),
        ),
      ),
      Card(
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        child: ListTile(
          title: Center(
              child: Text(
                "3. Dismantle the hurdles\n       by answering the\ncorresponding questions",
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 25.0,
                ),
              )
          ),
        ),
      ),
    ];
  }

  Widget _getIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: map<Widget>(_getItems(), (index, element) {
        return Container(
          width: _currentIndex == index ? 10.0 : 8.0,
          height: _currentIndex == index ? 10.0 : 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == index
                ? Theme.of(context).primaryColor
                : Colors.grey[400],
          ),
        );
      }),
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}