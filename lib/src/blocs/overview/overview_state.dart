import 'package:dismantlorapp/src/models/dream.dart';
import 'package:equatable/equatable.dart';

class OverviewState extends Equatable {
  const OverviewState();

  @override
  List<Object> get props => [];
}

class OverviewLoadInProgress extends OverviewState {}

class OverviewLoadSuccess extends OverviewState {
  final List<Dream> dreams;

  const OverviewLoadSuccess({this.dreams});

  @override
  List<Object> get props => [this.dreams];

  @override
  String toString() => 'OverviewLoadSuccess { dreams: ${ this.dreams == null ? 0 : this.dreams.length} }';
}

class OverviewLoadFailure extends OverviewState {
  final String message;

  const OverviewLoadFailure({this.message});

  @override
  List<Object> get props => [this.message];

  @override
  String toString() => 'OverviewLoadFailure { message: ${this.message} }';
}

class OverviewMessage extends OverviewState {
  final bool success;
  final String message;

  const OverviewMessage({this.success, this.message});

  @override
  List<Object> get props => [this.success, this.message];

  @override
  String toString() => 'OverviewMessage { success: ${this.success}, message: ${this.message} }';
}