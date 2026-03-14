// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/core/cloud_functions_service.dart';
import 'package:finanzbegleiter/features/web_logging/domain/web_logging_repository.dart';

class WebLoggingRepositoryImplementation implements WebLoggingRepository {
  final CloudFunctionsService cloudFunctions;

  WebLoggingRepositoryImplementation({required this.cloudFunctions});

  @override
  Future<void> log(LogLevel logLevel, String message, String appVersion,
      String userAgent, StackTrace? stackTrace) async {
    await cloudFunctions.call(
      'log',
      {
        'level': logLevel.name,
        'message': message,
        'appVersion': appVersion,
        'userAgent': userAgent,
        'stackTrace': stackTrace?.toString() ?? 'No stack trace available',
      },
      (_) => unit,
    );
  }
}
