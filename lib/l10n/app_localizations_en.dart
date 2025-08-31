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

  @override
  String get proofOfWorkFilter => 'Proof of Work Filter';

  @override
  String minimumDifficulty(int difficulty) {
    return 'Minimum difficulty: $difficulty bits';
  }

  @override
  String get powFilterHint => '0 = No filter, 16-20 = Moderate, 24+ = High';

  @override
  String letOthersKnow(String appName) {
    return 'Let others know I use $appName';
  }

  @override
  String get sourceCode => 'Source Code';

  @override
  String get viewOnGitHub => 'View on GitHub';

  @override
  String get supportAndContact => 'Support & Contact';

  @override
  String get donateOrGetInTouch => 'Donate or get in touch via Nostr';

  @override
  String get roomName => 'Room Name';

  @override
  String get starred => 'Starred';

  @override
  String get popular => 'Popular';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get yesterday => 'Yesterday';

  @override
  String sentFrom(String clientName) {
    return 'sent from $clientName';
  }
}
