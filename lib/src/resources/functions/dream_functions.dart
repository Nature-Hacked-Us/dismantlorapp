import 'package:cloud_functions/cloud_functions.dart';

import 'abstract/i_functions.dart';

class DreamFunctions extends IFunctions {
  Future<HttpsCallableResult> addDream(String dreamTitle) async {
    HttpsCallable callable = super.getFunction('addDream');
    return await callable.call(
      <String, dynamic> {
        'title': dreamTitle,
      },
    );
  }

  Future<HttpsCallableResult> deleteDream(String dreamId) async {
    HttpsCallable callable = super.getFunction('deleteDream');
    return await callable.call(
      <String, dynamic> {
        'dream_id': dreamId,
      },
    );
  }

  Future<HttpsCallableResult> updateDream(String dreamId, String dreamTitle) async {
    HttpsCallable callable = super.getFunction('updateDream');
    return await callable.call(
      <String, dynamic> {
        'dream_id': dreamId,
        'title': dreamTitle,
      },
    );
  }
}