import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dismantlorapp/src/models/finding.dart';
import 'package:meta/meta.dart';
import 'constants/repository_structure.dart';
import 'functions/finding_functions.dart';

class FindingRepository {
  final String _dreamId;
  final String _hurdleId;
  final FindingFunctions _functions;

  FindingRepository({@required String userId, @required String dreamId, @required String hurdleId, FindingFunctions functions})
      : _dreamId = dreamId,
        _hurdleId = hurdleId,
        _functions = functions ?? new FindingFunctions();

  Stream<List<Finding>> get findings {
    return FirebaseFirestore.instance.collection(RepositoryStructure.DREAMS)
      .doc(_dreamId)
      .collection(RepositoryStructure.HURDLES)
      .doc(_hurdleId)
      .collection(RepositoryStructure.FINDINGS)
      .orderBy(RepositoryStructure.RANKING)
      .snapshots()
      .map(_findingsFromSnapshot);
  }

  List<Finding> _findingsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Finding(
        id: doc.reference.id,
        question: doc.data()[Finding.QUESTION] ?? '',
        answer: doc.data()[Finding.ANSWER] ?? '',
      );
    }).toList();
  }

  Future<HttpsCallableResult> deleteFinding(String findingId) async {
    return await _functions.deleteFinding(_dreamId, _hurdleId, findingId);
  }

  Future<HttpsCallableResult> updateFinding(String findingId, String answer) async {
    return await _functions.updateFinding(_dreamId, _hurdleId, findingId, answer);
  }
}