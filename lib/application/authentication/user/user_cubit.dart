// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepo;
  UserCubit({
    required this.userRepo,
  }) : super(UserInitial());

  void createUser(CustomUser user) async {
    emit(UserLoading());
    final failureOrSuccess = await userRepo.createUser(user: user);
    failureOrSuccess.fold((failure) => emit(UserFailure(failure: failure)),
        (r) => emit(UserSuccess()));
  }
}
