import 'package:equatable/equatable.dart';

class AppRemoteConfigState extends Equatable {
  final bool tremendousEnabled;

  const AppRemoteConfigState({required this.tremendousEnabled});

  @override
  List<Object> get props => [tremendousEnabled];
}
