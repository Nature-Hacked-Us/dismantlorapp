import 'package:dismantlorapp/src/resources/user_repository.dart';
import 'package:dismantlorapp/src/ui/register/register_screen.dart';
import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  final UserRepository _userRepository;

  CreateAccountButton({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        'Create an Account',
      ),
      onPressed: () {
        Navigator.of(context).push(
          PageRouteBuilder(pageBuilder: (_, animation1, animation2) {
            return RegisterScreen(userRepository: _userRepository);
          }),
        );
      },
    );
  }
}