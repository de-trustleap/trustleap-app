import 'package:bloc/bloc.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/repositories/web_logging_repository.dart';

class WebLoggingCubit extends Cubit<String?> {
  final WebLoggingRepository webLoggingRepo;
  WebLoggingCubit({required this.webLoggingRepo}) : super(null);

  void reportWebCrash(
      String message, StackTrace? stack, String? browser) async {
    await webLoggingRepo.reportWebCrash(message, stack, browser);
  }

  void log(String message, String userAgent, String appVersion,
      LogLevel logLevel, StackTrace? stackTrace) async {
    await webLoggingRepo.log(
        logLevel, message, appVersion, userAgent, stackTrace);
  }
}
