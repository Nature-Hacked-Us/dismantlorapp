import 'package:dismantlorapp/src/models/finding.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FindingsEvent extends Equatable {
  const FindingsEvent();

  @override
  List<Object> get props => [];
}

class FindingsLoaded extends FindingsEvent {
  final List<Finding> findings;

  const FindingsLoaded({@required this.findings});

  @override
  List<Object> get props => [this.findings];

  @override
  String toString() => 'FindingsLoaded { findings: ${this.findings == null ? 0 : this.findings.length} }';
}

class DeleteFindingPressed extends FindingsEvent {
  final String findingId;

  const DeleteFindingPressed({@required this.findingId});

  @override
  List<Object> get props => [this.findingId];

  @override
  String toString() => 'DeleteFindingPressed { findingId: ${this.findingId} }';
}

class UpdateFindingPressed extends FindingsEvent {
  final String findingId;
  final String answer;

  const UpdateFindingPressed({@required this.findingId, @required this.answer});

  @override
  List<Object> get props => [this.findingId, this.answer];

  @override
  String toString() => 'UpdateFindingPressed { findingId: ${this.findingId}, answer: ${this.answer} }';
}