import 'package:bloc/bloc.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepo;

  ProfileBloc({required this.userRepo}) : super(ProfileInitial()) {
    on<UpdateProfileEvent>((event, emit) async {
      if (event.user == null) {
        emit(ProfileShowValidationState());
      } else {
        emit(ProfileLoadingState());
        final failureOrSuccess = await userRepo.updateUser(user: event.user!);
        failureOrSuccess.fold(
            (failure) => emit(ProfileFailureState(failure: failure)),
            (r) => emit(ProfileSuccessState()));
      }
    });
  }
}
