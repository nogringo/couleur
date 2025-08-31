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

  @override
  String get proofOfWorkFilter => 'Filtro de Prueba de Trabajo';

  @override
  String minimumDifficulty(int difficulty) {
    return 'Dificultad mínima: $difficulty bits';
  }

  @override
  String get powFilterHint => '0 = Sin filtro, 16-20 = Moderado, 24+ = Alto';

  @override
  String letOthersKnow(String appName) {
    return 'Dejar que otros sepan que uso $appName';
  }

  @override
  String get sourceCode => 'Código Fuente';

  @override
  String get viewOnGitHub => 'Ver en GitHub';

  @override
  String get supportAndContact => 'Soporte y Contacto';

  @override
  String get donateOrGetInTouch =>
      'Donar o ponerse en contacto a través de Nostr';

  @override
  String get roomName => 'Nombre de Sala';

  @override
  String get starred => 'Destacado';

  @override
  String get popular => 'Popular';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get yesterday => 'Ayer';

  @override
  String sentFrom(String clientName) {
    return 'enviado desde $clientName';
  }
}
