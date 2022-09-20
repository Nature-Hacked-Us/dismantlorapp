import 'dart:async';
import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dismantlorapp/src/helpers/user_helper.dart';
import 'package:dismantlorapp/src/resources/hurdle_repository.dart';
import 'package:meta/meta.dart';

import 'hurdles_event.dart';
import 'hurdles_state.dart';

class HurdlesBloc extends Bloc<HurdlesEvent, HurdlesState> {
  final HurdleRepository _hurdleRepository;
  StreamSubscription _streamSubscription;

  HurdlesBloc({@required String dreamId, HurdleRepository hurdleRepository})
      : _hurdleRepository = hurdleRepository ?? new HurdleRepository(userId: UserHelper.getUserId(), dreamId: dreamId),
        super(HurdlesLoadInProgress()) {
    _initializeStreamSubscription();
  }

  @override
  Stream<HurdlesState> mapEventToState(HurdlesEvent event) async* {
    if (event is HurdlesLoaded) {
      yield* _mapHurdlesLoadedToState(event);
    } else if (event is AddHurdlePressed) {
      yield* _mapHurdleAddedToState(event);
    } else if (event is DeleteHurdlePressed) {
      yield* _mapHurdleDeletedToState(event);
    } else if (event is UpdateHurdlePressed) {
      yield* _mapHurdleUpdatedToState(event);
    }
  }

  Stream<HurdlesState> _mapHurdlesLoadedToState(HurdlesLoaded event) async* {
    yield HurdlesLoadSuccess(hurdles: event.hurdles);
  }

  Stream<HurdlesState> _mapHurdleAddedToState(AddHurdlePressed event) async* {
    try {
      HttpsCallableResult result = await _hurdleRepository.addHurdle(event.title);
      yield HurdlesMessage(success: result.data['success'], message: result.data['message']);
    } catch (_) {
      yield HurdlesLoadFailure();
    }
  }

  Stream<HurdlesState> _mapHurdleDeletedToState(DeleteHurdlePressed event) async* {
    try {
      HttpsCallableResult result = await _hurdleRepository.deleteHurdle(event.hurdleId);
      yield HurdlesMessage(success: result.data['success'], message: result.data['message']);
    } catch (_) {
      yield HurdlesLoadFailure();
    }
  }

  Stream<HurdlesState> _mapHurdleUpdatedToState(UpdateHurdlePressed event) async* {
    try {
      HttpsCallableResult result = await _hurdleRepository.updateHurdle(event.hurdleId, event.title);
      yield HurdlesMessage(success: result.data['success'], message: result.data['message']);
    } catch (_) {
      yield HurdlesLoadFailure();
    }
  }

  void _initializeStreamSubscription() {
    _streamSubscription?.cancel();
    _streamSubscription = _hurdleRepository.hurdles.listen(
      (hurdles) => add(HurdlesLoaded(hurdles: hurdles)),
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}