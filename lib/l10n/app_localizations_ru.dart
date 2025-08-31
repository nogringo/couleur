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

  @override
  String get proofOfWorkFilter => 'Фильтр доказательства работы';

  @override
  String minimumDifficulty(int difficulty) {
    return 'Минимальная сложность: $difficulty бит';
  }

  @override
  String get powFilterHint => '0 = Без фильтра, 16-20 = Средний, 24+ = Высокий';

  @override
  String letOthersKnow(String appName) {
    return 'Сообщить другим, что я использую $appName';
  }

  @override
  String get sourceCode => 'Исходный код';

  @override
  String get viewOnGitHub => 'Посмотреть на GitHub';

  @override
  String get supportAndContact => 'Поддержка и контакты';

  @override
  String get donateOrGetInTouch => 'Пожертвовать или связаться через Nostr';

  @override
  String get roomName => 'Название комнаты';

  @override
  String get starred => 'Избранное';

  @override
  String get popular => 'Популярное';

  @override
  String get system => 'Система';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Темная';

  @override
  String get yesterday => 'Вчера';

  @override
  String sentFrom(String clientName) {
    return 'отправлено из $clientName';
  }
}
