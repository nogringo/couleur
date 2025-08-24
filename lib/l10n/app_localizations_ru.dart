// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Couleur';

  @override
  String get login => 'Войти';

  @override
  String get message => 'Сообщение';

  @override
  String get viewProfile => 'Просмотр профиля';

  @override
  String get mention => 'Упомянуть';

  @override
  String get muteUser => 'Заглушить пользователя';

  @override
  String get cashuToken => 'Токен Cashu';

  @override
  String get lightningInvoice => 'Lightning счёт';

  @override
  String lightningInvoiceWithAmount(String amount) {
    return 'Lightning счёт: $amount сатоши';
  }

  @override
  String get addRoom => 'Добавить комнату';

  @override
  String get enterRoomName => 'Введите название комнаты';

  @override
  String get cancel => 'Отмена';

  @override
  String get join => 'Присоединиться';

  @override
  String get themeMode => 'Режим темы';

  @override
  String anonymousUser(String uid) {
    return 'Аноним#$uid';
  }

  @override
  String roomPrefix(String room) {
    return '#$room';
  }
}
