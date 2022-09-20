import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dismantlorapp/src/helpers/user_helper.dart';
import 'package:dismantlorapp/src/resources/finding_repository.dart';
import 'package:meta/meta.dart';

import 'findings_event.dart';
import 'findings_state.dart';

class FindingsBloc extends Bloc<FindingsEvent, FindingsState> {
  final FindingRepository _findingRepository;
  StreamSubscription _streamSubscription;

  FindingsBloc({@required String dreamId, @required String hurdleId, FindingRepository findingRepository})
      : _findingRepository = findingRepository ?? new FindingRepository(userId: UserHelper.getUserId(), dreamId: dreamId, hurdleId: hurdleId),
        super(FindingsLoadInProgress()) {
    _initializeStreamSubscription();
  }

  @override
  Stream<FindingsState> mapEventToState(FindingsEvent event) async* {
    if (event is FindingsLoaded) {
      yield* _mapFindingsLoadedToState(event);
    } else if (event is DeleteFindingPressed) {
      yield* _mapFindingDeletedToState(event);
    } else if (event is UpdateFindingPressed) {
      yield* _mapFindingUpdatedToState(event);
    }
  }

  Stream<FindingsState> _mapFindingsLoadedToState(FindingsLoaded event) async* {
    yield FindingsLoadSuccess(findings: event.findings);
  }

  Stream<FindingsState> _mapFindingDeletedToState(DeleteFindingPressed event) async* {
    try {
      HttpsCallableResult result = await _findingRepository.deleteFinding(event.findingId);
      yield FindingsMessage(success: result.data['success'], message: result.data['message']);
    } catch (_) {
      yield FindingsLoadFailure();
    }
  }

  Stream<FindingsState> _mapFindingUpdatedToState(UpdateFindingPressed event) async* {
    try {
      HttpsCallableResult result = await _findingRepository.updateFinding(event.findingId, event.answer);
      yield FindingsMessage(success: result.data['success'], message: result.data['message']);
    } catch (_) {
      yield FindingsLoadFailure();
    }
  }

  void _initializeStreamSubscription() {
    _streamSubscription?.cancel();
    _streamSubscription = _findingRepository.findings.listen(
      (findings) => add(FindingsLoaded(findings: findings)),
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}