import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_funding_source.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_organization.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_product.dart';
import 'package:finanzbegleiter/features/tremendous/domain/tremendous_repository.dart';

part 'tremendous_state.dart';

class TremendousCubit extends Cubit<TremendousState> {
  final TremendousRepository tremendousRepository;
  StreamSubscription<Either<DatabaseFailure, bool>>? _connectionStatusSubscription;

  TremendousCubit(this.tremendousRepository) : super(TremendousInitial());

  Future<void> connect() async {
    emit(TremendousConnectingState());

    final result = await tremendousRepository.getAuthorizationUrl();

    result.fold(
      (failure) => emit(TremendousConnectionFailureState(failure: failure)),
      (authUrl) => emit(TremendousOAuthReadyState(authUrl: authUrl)),
    );
  }

  Future<void> disconnect() async {
    final result = await tremendousRepository.disconnect();

    result.fold(
      (failure) => emit(TremendousConnectionFailureState(failure: failure)),
      (_) => emit(TremendousDisconnectedState()),
    );
  }

  void startObservingConnectionStatus() {
    _connectionStatusSubscription?.cancel();
    _connectionStatusSubscription = null;

    _connectionStatusSubscription =
        tremendousRepository.observeConnectionStatus().listen(
      (result) {
        result.fold(
          (failure) => emit(TremendousConnectionFailureState(failure: failure)),
          (isConnected) {
            if (isConnected) {
              _loadOrganization();
            } else {
              emit(TremendousNotConnectedState());
            }
          },
        );
      },
      onError: (_) {
        emit(TremendousConnectionFailureState(failure: BackendFailure()));
      },
    );
  }

  Future<void> _loadOrganization() async {
    final result = await tremendousRepository.getOrganization();

    result.fold(
      (failure) => emit(TremendousConnectionFailureState(failure: failure)),
      (organization) =>
          emit(TremendousConnectedState(organization: organization)),
    );
  }

  void stopObservingConnectionStatus() {
    _connectionStatusSubscription?.cancel();
    _connectionStatusSubscription = null;
  }

  Future<void> loadCatalog() async {
    emit(TremendousCatalogLoadingState());

    final (productsResult, sourcesResult) = await (
      tremendousRepository.getProductList(),
      tremendousRepository.getFundingSourcesList(),
    ).wait;

    productsResult.fold(
      (f) => emit(TremendousCatalogFailureState(failure: f)),
      (products) => sourcesResult.fold(
        (f) => emit(TremendousCatalogFailureState(failure: f)),
        (sources) => emit(TremendousCatalogSuccessState(
          products: products,
          fundingSources: sources,
        )),
      ),
    );
  }

  void reset() {
    emit(TremendousInitial());
  }

  @override
  Future<void> close() {
    stopObservingConnectionStatus();
    return super.close();
  }
}
