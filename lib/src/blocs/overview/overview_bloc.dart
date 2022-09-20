import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dismantlorapp/src/helpers/user_helper.dart';
import 'package:dismantlorapp/src/resources/dream_repository.dart';

import 'overview_event.dart';
import 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final DreamRepository _dreamRepository;
  StreamSubscription _streamSubscription;

  OverviewBloc({DreamRepository dreamRepository})
      : _dreamRepository = dreamRepository ?? new DreamRepository(userId: UserHelper.getUserId()),
        super(OverviewLoadInProgress()) {
    _initializeStreamSubscription();
  }

  @override
  Stream<OverviewState> mapEventToState(OverviewEvent event) async* {
    if (event is OverviewLoaded) {
      yield* _mapOverviewLoadedToState(event);
    } else if (event is AddDreamPressed) {
      yield* _mapDreamAddedToState(event);
    } else if (event is DeleteDreamPressed) {
      yield* _mapDreamDeletedToState(event);
    } else if (event is UpdateDreamPressed) {
      yield* _mapDreamUpdatedToState(event);
    }
  }

  Stream<OverviewState> _mapOverviewLoadedToState(OverviewLoaded event) async* {
    yield OverviewLoadSuccess(dreams: event.dreams);
  }

  Stream<OverviewState> _mapDreamAddedToState(AddDreamPressed event) async* {
    try {
      HttpsCallableResult result = await _dreamRepository.addDream(event.title);
      yield OverviewMessage(success: result.data['success'], message: result.data['message']);
    } catch (_) {
      yield OverviewLoadFailure();
    }
  }

  Stream<OverviewState> _mapDreamDeletedToState(DeleteDreamPressed event) async* {
    try {
      HttpsCallableResult result = await _dreamRepository.deleteDream(event.dreamId);
      yield OverviewMessage(success: result.data['success'], message: result.data['message']);
    } catch (_) {
      yield OverviewLoadFailure();
    }
  }

  Stream<OverviewState> _mapDreamUpdatedToState(UpdateDreamPressed event) async* {
    try {
      HttpsCallableResult result = await _dreamRepository.updateDream(event.dreamId, event.title);
      yield OverviewMessage(success: result.data['success'], message: result.data['message']);
    } catch (_) {
      yield OverviewLoadFailure();
    }
  }

  void _initializeStreamSubscription() {
    _streamSubscription?.cancel();
    _streamSubscription = _dreamRepository.dreams.listen(
      (dreams) => add(OverviewLoaded(dreams: dreams)),
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}