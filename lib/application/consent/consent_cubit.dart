import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/consent_preference.dart';
import 'package:finanzbegleiter/domain/repositories/consent_repository.dart';

part 'consent_state.dart';

class ConsentCubit extends Cubit<ConsentState> {
  final ConsentRepository consentRepo;

  static const String currentPolicyVersion = '1.0';
  bool _hasCheckedStatus = false;

  ConsentCubit(this.consentRepo) : super(ConsentInitial());

  void checkConsentStatus() {
    // Nur einmal prüfen, nicht bei jedem Build
    if (_hasCheckedStatus) {
      return;
    }

    _hasCheckedStatus = true;

    final hasDecision = consentRepo.hasConsentDecision();

    if (!hasDecision) {
      emit(ConsentRequiredState());
      return;
    }

    final isOutdated = consentRepo.isConsentOutdated(currentPolicyVersion);
    if (isOutdated) {
      emit(ConsentRequiredState());
      return;
    }

    final preferences = consentRepo.getConsentPreferences();
    emit(ConsentLoadedState(preference: preferences));
  }

  void acceptAll() async {
    emit(ConsentSavingState());

    final preference = ConsentPreference.acceptAll(currentPolicyVersion);
    final result = await consentRepo.saveConsentPreference(preference);

    result.fold(
      (failure) => emit(ConsentSaveFailureState(failure: failure)),
      (_) => emit(ConsentSaveSuccessState(preference: preference)),
    );
  }

  void rejectAll() async {
    emit(ConsentSavingState());

    final preference = ConsentPreference.rejectAll(currentPolicyVersion);
    final result = await consentRepo.saveConsentPreference(preference);

    result.fold(
      (failure) => emit(ConsentSaveFailureState(failure: failure)),
      (_) => emit(ConsentSaveSuccessState(preference: preference)),
    );
  }

  void saveCustomConsent(Set<ConsentCategory> categories) async {
    emit(ConsentSavingState());

    final preference = ConsentPreference(
      categories: categories,
      method: ConsentMethod.custom,
      policyVersion: currentPolicyVersion,
      timestamp: DateTime.now(),
    );

    final result = await consentRepo.saveConsentPreference(preference);

    result.fold(
      (failure) => emit(ConsentSaveFailureState(failure: failure)),
      (_) => emit(ConsentSaveSuccessState(preference: preference)),
    );
  }

  void revokeConsent() async {
    emit(ConsentSavingState());

    final result = await consentRepo.revokeConsent(currentPolicyVersion);

    result.fold(
      (failure) => emit(ConsentSaveFailureState(failure: failure)),
      (_) {
        final preference = ConsentPreference.rejectAll(currentPolicyVersion);
        emit(ConsentSaveSuccessState(preference: preference));
      },
    );
  }

  bool hasConsent(ConsentCategory category) {
    return consentRepo.hasConsent(category);
  }

  ConsentPreference getCurrentPreferences() {
    return consentRepo.getConsentPreferences();
  }
}
