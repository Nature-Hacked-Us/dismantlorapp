import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Dream extends Equatable {
  static const String ID = 'id';
  static const String TITLE = 'title';

  final String id;
  final String title;

  Dream({
    @required this.id,
    @required this.title,
  });

  @override
  List<Object> get props => [this.id, this.title];

  @override
  String toString() => 'Dream { id: ${this.id}, title: ${this.title} }';
}
