import 'package:dismantlorapp/src/models/hurdle.dart';
import 'package:equatable/equatable.dart';

class HurdlesState extends Equatable {
  const HurdlesState();

  @override
  List<Object> get props => [];
}

class HurdlesLoadInProgress extends HurdlesState {}

class HurdlesLoadSuccess extends HurdlesState {
  final List<Hurdle> hurdles;

  const HurdlesLoadSuccess({this.hurdles});

  @override
  List<Object> get props => [this.hurdles];

  @override
  String toString() => 'HurdlesLoadSuccess { hurdles: ${ this.hurdles == null ? 0 : this.hurdles.length} }';
}

class HurdlesLoadFailure extends HurdlesState {
  final String message;

  const HurdlesLoadFailure({this.message});

  @override
  List<Object> get props => [this.message];

  @override
  String toString() => 'HurdlesLoadFailure { message: ${this.message} }';
}

class HurdlesMessage extends HurdlesState {
  final bool success;
  final String message;

  const HurdlesMessage({this.success, this.message});

  @override
  List<Object> get props => [this.success, this.message];

  @override
  String toString() => 'HurdlesMessage { success: ${this.success}, message: ${this.message} }';
}