import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/company.dart';
import 'package:finanzbegleiter/domain/entities/company_request.dart';

abstract class CompanyRepository {
  Stream<Either<DatabaseFailure, Company>> observeCompany(String companyID);
  Future<Either<DatabaseFailure, Unit>> updateCompany(Company company);
  Future<Either<DatabaseFailure, Company>> getCompany(String companyID);
  Future<Either<DatabaseFailure, Unit>> registerCompany(Company company);
  Future<Either<DatabaseFailure, CompanyRequest>> getPendingCompanyRequest(
      String id);
}
