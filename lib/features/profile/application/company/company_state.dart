// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'company_cubit.dart';

sealed class CompanyState {}

final class CompanyInitial extends CompanyState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class CompanyShowValidationState extends CompanyState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class CompanyUpdateContactInformationLoadingState extends CompanyState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class CompanyUpdateContactInformationFailureState extends CompanyState
    with EquatableMixin {
  final DatabaseFailure failure;

  CompanyUpdateContactInformationFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

class CompanyUpdateContactInformationSuccessState extends CompanyState
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class GetCompanyLoadingState extends CompanyState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class GetCompanyFailureState extends CompanyState with EquatableMixin {
  final DatabaseFailure failure;

  GetCompanyFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

class GetCompanySuccessState extends CompanyState with EquatableMixin {
  final Company company;

  GetCompanySuccessState({
    required this.company,
  });

  @override
  List<Object?> get props => [company];
}

class CompanyRegisterLoadingState extends CompanyState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class CompanyRegisterFailureState extends CompanyState with EquatableMixin {
  final DatabaseFailure failure;

  CompanyRegisterFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

class CompanyRegisterSuccessState extends CompanyState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class CompanyGetCurrentUserSuccessState extends CompanyState
    with EquatableMixin {
  final User? user;

  CompanyGetCurrentUserSuccessState({
    required this.user,
  });

  @override
  List<Object?> get props => [];
}

class CompanyGetAVVPDFLoadingState extends CompanyState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class CompanyGetAVVPDFFailureState extends CompanyState with EquatableMixin {
  final DatabaseFailure failure;

  CompanyGetAVVPDFFailureState({
    required this.failure,
  });

  @override
  List<Object?> get props => [failure];
}

class CompanyGetAVVPDFSuccessState extends CompanyState with EquatableMixin {
  final String downloadURL;

  CompanyGetAVVPDFSuccessState({
    required this.downloadURL,
  });

  @override
  List<Object?> get props => [downloadURL];
}
