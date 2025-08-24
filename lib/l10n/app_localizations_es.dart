// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Couleur';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get message => 'Mensaje';

  @override
  String get viewProfile => 'Ver perfil';

  @override
  String get mention => 'Mencionar';

  @override
  String get muteUser => 'Silenciar usuario';

  @override
  String get cashuToken => 'Token Cashu';

  @override
  String get lightningInvoice => 'Factura Lightning';

  @override
  String lightningInvoiceWithAmount(String amount) {
    return 'Factura Lightning: $amount sats';
  }

  @override
  String get addRoom => 'Agregar sala';

  @override
  String get enterRoomName => 'Ingrese el nombre de la sala';

  @override
  String get cancel => 'Cancelar';

  @override
  String get join => 'Unirse';

  @override
  String get themeMode => 'Modo de tema';

  @override
  String anonymousUser(String uid) {
    return 'Anon#$uid';
  }

  @override
  String roomPrefix(String room) {
    return '#$room';
  }
}
