import 'package:cloud_functions/cloud_functions.dart';

abstract class IFunctions {
  final String _region = 'europe-west3';

  HttpsCallable getFunction(String functionName) {
    return FirebaseFunctions.instanceFor(region: _region).httpsCallable(
      functionName,
      options: HttpsCallableOptions(timeout: Duration(seconds: 30))
    );
  }
}