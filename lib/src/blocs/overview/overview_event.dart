import 'package:dismantlorapp/src/models/dream.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object> get props => [];
}

class OverviewLoaded extends OverviewEvent {
  final List<Dream> dreams;

  const OverviewLoaded({@required this.dreams});

  @override
  List<Object> get props => [this.dreams];

  @override
  String toString() => 'OverviewLoaded { dreams: ${this.dreams == null ? 0 : this.dreams.length} }';
}

class AddDreamPressed extends OverviewEvent {
  final String title;

  const AddDreamPressed({@required this.title});

  @override
  List<Object> get props => [this.title];

  @override
  String toString() => 'AddDreamPressed { title: ${this.title} }';
}

class DeleteDreamPressed extends OverviewEvent {
  final String dreamId;

  const DeleteDreamPressed({@required this.dreamId});

  @override
  List<Object> get props => [this.dreamId];

  @override
  String toString() => 'DeleteDreamPressed { dreamId: ${this.dreamId} }';
}

class UpdateDreamPressed extends OverviewEvent {
  final String dreamId;
  final String title;

  const UpdateDreamPressed({@required this.dreamId, @required this.title});

  @override
  List<Object> get props => [this.dreamId, this.title];

  @override
  String toString() => 'UpdateDreamPressed { dreamId: ${this.dreamId}, title: ${this.title} }';
}