import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:dismantlorapp/src/helpers/user_helper.dart';
import 'package:dismantlorapp/src/resources/user_repository.dart';

import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository, super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final name = await _userRepository.getUserEmail();
        final userId = await _userRepository.getUserId();
        UserHelper.setUserId(userId);
        yield Authenticated(name);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final userId = await _userRepository.getUserId();
    UserHelper.setUserId(userId);
    yield Authenticated(await _userRepository.getUserEmail());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    UserHelper.setUserId(null);
    yield Unauthenticated();
    _userRepository.signOut();
  }
}