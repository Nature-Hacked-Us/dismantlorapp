import 'package:dismantlorapp/src/models/hurdle.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HurdlesEvent extends Equatable {
  const HurdlesEvent();

  @override
  List<Object> get props => [];
}

class HurdlesLoaded extends HurdlesEvent {
  final List<Hurdle> hurdles;

  const HurdlesLoaded({@required this.hurdles});

  @override
  List<Object> get props => [this.hurdles];

  @override
  String toString() => 'HurdlesLoaded { hurdles: ${this.hurdles == null ? 0 : this.hurdles.length} }';
}

class AddHurdlePressed extends HurdlesEvent {
  final String title;

  const AddHurdlePressed({@required this.title});

  @override
  List<Object> get props => [this.title];

  @override
  String toString() => 'AddHurdlePressed { title: ${this.title} }';
}

class DeleteHurdlePressed extends HurdlesEvent {
  final String hurdleId;

  const DeleteHurdlePressed({@required this.hurdleId});

  @override
  List<Object> get props => [this.hurdleId];

  @override
  String toString() => 'DeleteHurdlePressed { hurdleId: ${this.hurdleId} }';
}

class UpdateHurdlePressed extends HurdlesEvent {
  final String hurdleId;
  final String title;

  const UpdateHurdlePressed({@required this.hurdleId, @required this.title});

  @override
  List<Object> get props => [this.hurdleId, this.title];

  @override
  String toString() => 'UpdateHurdlePressed { hurdleId: ${this.hurdleId}, title: ${this.title} }';
}