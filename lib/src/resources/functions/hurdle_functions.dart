import 'package:cloud_functions/cloud_functions.dart';

import 'abstract/i_functions.dart';

class HurdleFunctions extends IFunctions {
  Future<HttpsCallableResult> addHurdle(String dreamId, String hurdleTitle) async {
    HttpsCallable callable = super.getFunction('addHurdle');
    return await callable.call(
      <String, dynamic> {
        'dream_id': dreamId,
        'title': hurdleTitle,
      },
    );
  }

  Future<HttpsCallableResult> deleteHurdle(String dreamId, String hurdleId) async {
    HttpsCallable callable = super.getFunction('deleteHurdle');
    return await callable.call(
      <String, dynamic> {
        'dream_id': dreamId,
        'hurdle_id': hurdleId,
      },
    );
  }

  Future<HttpsCallableResult> updateHurdle(String dreamId, String hurdleId, String hurdleTitle) async {
    HttpsCallable callable = super.getFunction('updateHurdle');
    return await callable.call(
      <String, dynamic> {
        'dream_id': dreamId,
        'hurdle_id': hurdleId,
        'title': hurdleTitle,
      },
    );
  }
}