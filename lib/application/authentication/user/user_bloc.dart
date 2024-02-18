// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepo;

  UserBloc({
    required this.userRepo,
  }) : super(UserInitial()) {
    on<CreateUserEvent>((event, emit) async {
      final failureOrSuccess = await userRepo.createUser(user: event.user);
      failureOrSuccess.fold((failure) => emit(UserFailure(failure: failure)),
          (r) => emit(UserSuccess()));
    });
  }
}
