import 'package:equatable/equatable.dart';

class LastViewed extends Equatable {
  final String userID;
  final DateTime viewedAt;
  
  const LastViewed({
    required this.userID,
    required this.viewedAt,
  });
  
  LastViewed copyWith({
    String? userID,
    DateTime? viewedAt,
  }) {
    return LastViewed(
      userID: userID ?? this.userID,
      viewedAt: viewedAt ?? this.viewedAt,
    );
  }
  
  @override
  List<Object?> get props => [userID, viewedAt];
}