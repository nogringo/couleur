// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Couleur';

  @override
  String get login => 'Se connecter';

  @override
  String get message => 'Message';

  @override
  String get viewProfile => 'Voir le profil';

  @override
  String get mention => 'Mentionner';

  @override
  String get muteUser => 'Rendre muet l\'utilisateur';

  @override
  String get cashuToken => 'Jeton Cashu';

  @override
  String get lightningInvoice => 'Facture Lightning';

  @override
  String lightningInvoiceWithAmount(String amount) {
    return 'Facture Lightning : $amount sats';
  }

  @override
  String get addRoom => 'Ajouter une salle';

  @override
  String get enterRoomName => 'Entrez le nom de la salle';

  @override
  String get cancel => 'Annuler';

  @override
  String get join => 'Rejoindre';

  @override
  String get themeMode => 'Mode thème';

  @override
  String anonymousUser(String uid) {
    return 'Anonyme#$uid';
  }

  @override
  String roomPrefix(String room) {
    return '#$room';
  }
}
