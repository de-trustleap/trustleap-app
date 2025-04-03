import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/company_request.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

abstract class CompanyRepository {
  Stream<Either<DatabaseFailure, Company>> observeCompany(String companyID);
  Stream<Either<DatabaseFailure, List<CompanyRequest>>>
      observeCompanyRequests();
  Future<Either<DatabaseFailure, Unit>> updateCompany(
      Company company, bool avvAccepted);
  Future<Either<DatabaseFailure, Company>> getCompany(String companyID);
  Future<Either<DatabaseFailure, Unit>> registerCompany(
      Company company, bool avvAccepted);
  Future<Either<DatabaseFailure, CompanyRequest>> getPendingCompanyRequest(
      String id);
  Future<Either<DatabaseFailure, List<CustomUser>>>
      getAllUsersForPendingCompanyRequests(List<String> ids);
  Future<Either<DatabaseFailure, Unit>> processCompanyRequest(
      String id, String userID, bool accepted);
  Future<Either<DatabaseFailure, String>> getAVVDownloadURL(
      Company company, bool isPreview);
}
