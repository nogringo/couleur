// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Couleur';

  @override
  String get login => 'Login';

  @override
  String get message => 'Message';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get mention => 'Mention';

  @override
  String get muteUser => 'Mute User';

  @override
  String get cashuToken => 'Cashu Token';

  @override
  String get lightningInvoice => 'Lightning Invoice';

  @override
  String lightningInvoiceWithAmount(String amount) {
    return 'Lightning Invoice: $amount sats';
  }

  @override
  String get addRoom => 'Add Room';

  @override
  String get enterRoomName => 'Enter room name';

  @override
  String get cancel => 'Cancel';

  @override
  String get join => 'Join';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String anonymousUser(String uid) {
    return 'Anon#$uid';
  }

  @override
  String roomPrefix(String room) {
    return '#$room';
  }
}
