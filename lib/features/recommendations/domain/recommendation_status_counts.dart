import 'package:equatable/equatable.dart';

class RecommendationStatusCounts extends Equatable {
  final int linkClicked;
  final int contactFormSent;
  final int appointment;
  final int successful;
  final int failed;

  const RecommendationStatusCounts({
    this.linkClicked = 0,
    this.contactFormSent = 0,
    this.appointment = 0,
    this.successful = 0,
    this.failed = 0,
  });

  @override
  List<Object?> get props => [
        linkClicked,
        contactFormSent,
        appointment,
        successful,
        failed,
      ];
}
