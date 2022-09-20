import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dismantlorapp/src/resources/user_repository.dart';
import 'package:dismantlorapp/src/user/user_config.dart';

import 'src/app.dart';
import 'src/blocs/authentication/authentication_bloc.dart';
import 'src/blocs/authentication/authentication_event.dart';

final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = PrintBlocObserver();
  getIt.registerSingleton<UserConfig>(UserConfig());

  runApp(
      FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final UserRepository userRepository = UserRepository();
            return MultiBlocProvider(
              providers: [
                BlocProvider<AuthenticationBloc>(
                  create: (_) => AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
                ),
              ],
              child: App(userRepository: userRepository),
            );
          }
          return LoadingScreen();
        },
      )
  );
}

class PrintBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stacktrace) {
    super.onError(cubit, error, stacktrace);
    print(error);
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Something went wrong. Please restart the app.'),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}