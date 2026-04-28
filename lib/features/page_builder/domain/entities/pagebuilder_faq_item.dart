import 'package:equatable/equatable.dart';

class PagebuilderFAQItem extends Equatable {
  final String? question;
  final String? answer;

  const PagebuilderFAQItem({
    required this.question,
    required this.answer,
  });

  PagebuilderFAQItem copyWith({String? question, String? answer}) {
    return PagebuilderFAQItem(
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  @override
  List<Object?> get props => [question, answer];
}
