part of 'company_image_bloc.dart';

sealed class CompanyImageState extends Equatable {
  const CompanyImageState();
  
  @override
  List<Object> get props => [];
}

final class CompanyImageInitial extends CompanyImageState {}

final class CompanyImageUploadSuccessState extends CompanyImageState {
  final String imageURL;

  const CompanyImageUploadSuccessState({required this.imageURL});
}

final class CompanyImageUploadLoadingState extends CompanyImageState {}

final class CompanyUploadCancelledState extends CompanyImageState {}

final class CompanyImageUploadFailureState extends CompanyImageState {
  final StorageFailure failure;

  const CompanyImageUploadFailureState({required this.failure});
}

final class CompanyImageExceedsFileSizeLimitFailureState
    extends CompanyImageState {}

final class CompanyImageIsNotValidFailureState extends CompanyImageState {}

final class CompanyImageOnlyOneAllowedFailureState extends CompanyImageState {}

final class CompanyImageUploadNotFoundFailureState extends CompanyImageState {}