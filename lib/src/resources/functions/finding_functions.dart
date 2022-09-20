import 'package:cloud_functions/cloud_functions.dart';

import 'abstract/i_functions.dart';

class FindingFunctions extends IFunctions {
  Future<HttpsCallableResult> deleteFinding(String dreamId, String hurdleId, String findingId) async {
    // the finding won't be actually deleted
    // only the content (answer) will be emptied
    HttpsCallable callable = super.getFunction('removeFinding');
    return await callable.call(
      <String, dynamic> {
        'dream_id': dreamId,
        'hurdle_id': hurdleId,
        'finding_id': findingId,
      },
    );
  }

  Future<HttpsCallableResult> updateFinding(String dreamId, String hurdleId, String findingId, String answer) async {
    HttpsCallable callable = super.getFunction('updateFinding');
    return await callable.call(
      <String, dynamic> {
        'dream_id': dreamId,
        'hurdle_id': hurdleId,
        'finding_id': findingId,
        'answer': answer,
      },
    );
  }
}