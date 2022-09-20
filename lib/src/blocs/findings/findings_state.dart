import 'package:dismantlorapp/src/models/finding.dart';
import 'package:equatable/equatable.dart';

class FindingsState extends Equatable {
  const FindingsState();

  @override
  List<Object> get props => [];
}

class FindingsLoadInProgress extends FindingsState {}

class FindingsLoadSuccess extends FindingsState {
  final List<Finding> findings;

  const FindingsLoadSuccess({this.findings});

  @override
  List<Object> get props => [this.findings];

  @override
  String toString() => 'FindingsLoadSuccess { findings: ${ this.findings == null ? 0 : this.findings.length} }';
}

class FindingsLoadFailure extends FindingsState {
  final String message;

  const FindingsLoadFailure({this.message});

  @override
  List<Object> get props => [this.message];

  @override
  String toString() => 'FindingsLoadFailure { message: ${this.message} }';
}

class FindingsMessage extends FindingsState {
  final bool success;
  final String message;

  const FindingsMessage({this.success, this.message});

  @override
  List<Object> get props => [this.success, this.message];

  @override
  String toString() => 'FindingsMessage { success: ${this.success}, message: ${this.message} }';
}