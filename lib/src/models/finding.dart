import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Finding extends Equatable {
  static const String ID = 'id';
  static const String QUESTION = 'question';
  static const String ANSWER = 'answer';

  final String id;
  final String question;
  final String answer;

  Finding({
    @required this.id,
    @required this.question,
    @required this.answer,
  });

  @override
  List<Object> get props => [this.id, this.question, this.answer];

  @override
  String toString() => 'Finding { id: ${this.id}, question: ${this.question}, answer: ${this.answer} }';
}
