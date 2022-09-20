import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Hurdle extends Equatable {
  static const String ID = 'id';
  static const String TITLE = 'title';

  final String id;
  final String title;

  Hurdle({
    @required this.id,
    @required this.title,
  });

  @override
  List<Object> get props => [this.id, this.title];

  @override
  String toString() => 'Hurdle { id: ${this.id}, title: ${this.title} }';
}
