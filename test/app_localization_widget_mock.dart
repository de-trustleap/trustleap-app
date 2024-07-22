import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class WidgetMockAppLocalization extends Mock implements AppLocalizations {
  @override
  String get login_title => 'Login';

  @override
  String get login_subtitle => 'Login';

  @override
  String get login_email => 'E-Mail';

  @override
  String get login_password => 'Passwort';

  @override
  String get login_login_buttontitle => 'Anmelden';

  @override
  String get login_password_forgotten_text => 'Haben Sie ihr ';

  @override
  String get login_password_forgotten_linktext => 'Passwort vergessen?';

  @override
  String get login_register_linktitle => 'Jetzt registrieren';

  @override
  String get login_register_text => 'Du hast kein Konto? ';
}
