import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dismantlorapp/src/models/dream.dart';
import 'package:meta/meta.dart';
import 'constants/repository_structure.dart';
import 'functions/dream_functions.dart';

class DreamRepository {
  final DreamFunctions _functions;

  DreamRepository({@required String userId, DreamFunctions functions})
      : _functions = functions ?? new DreamFunctions();

  Stream<List<Dream>> get dreams {
    return FirebaseFirestore.instance.collection(RepositoryStructure.DREAMS)
      .orderBy(RepositoryStructure.TITLE_LOWER)
      .snapshots()
      .map(_dreamsFromSnapshot);
  }

  List<Dream> _dreamsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Dream(
          id: doc.reference.id,
          title: doc.data()[Dream.TITLE] ?? '',
      );
    }).toList();
  }

  Future<HttpsCallableResult> addDream(String dreamTitle) async {
    return await _functions.addDream(dreamTitle);
  }

  Future<HttpsCallableResult> deleteDream(String dreamId) async {
    return await _functions.deleteDream(dreamId);
  }

  Future<HttpsCallableResult> updateDream(String dreamId, String dreamTitle) async {
    return await _functions.updateDream(dreamId, dreamTitle);
  }
}