import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dismantlorapp/src/models/dream.dart';
import 'package:dismantlorapp/src/models/hurdle.dart';
import 'package:meta/meta.dart';
import 'constants/repository_structure.dart';
import 'functions/hurdle_functions.dart';

class HurdleRepository {
  final String _dreamId;
  final HurdleFunctions _functions;

  HurdleRepository({@required String userId, @required String dreamId, HurdleFunctions functions})
      : _dreamId = dreamId,
        _functions = functions ?? new HurdleFunctions();

  Stream<List<Hurdle>> get hurdles {
    return FirebaseFirestore.instance.collection(RepositoryStructure.DREAMS)
      .doc(_dreamId)
      .collection(RepositoryStructure.HURDLES)
      .orderBy(RepositoryStructure.TITLE_LOWER)
      .snapshots()
      .map(_hurdlesFromSnapshot);
  }

  List<Hurdle> _hurdlesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Hurdle(
        id: doc.reference.id,
        title: doc.data()[Dream.TITLE] ?? '',
      );
    }).toList();
  }

  Future<HttpsCallableResult> addHurdle(String hurdleTitle) async {
    return await _functions.addHurdle(_dreamId, hurdleTitle);
  }

  Future<HttpsCallableResult> deleteHurdle(String hurdleId) async {
    return await _functions.deleteHurdle(_dreamId, hurdleId);
  }

  Future<HttpsCallableResult> updateHurdle(String hurdleId, String hurdleTitle) async {
    return await _functions.updateHurdle(_dreamId, hurdleId, hurdleTitle);
  }
}