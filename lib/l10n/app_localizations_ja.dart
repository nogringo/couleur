// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Couleur';

  @override
  String get login => 'ログイン';

  @override
  String get message => 'メッセージ';

  @override
  String get viewProfile => 'プロフィールを見る';

  @override
  String get mention => 'メンション';

  @override
  String get muteUser => 'ユーザーをミュート';

  @override
  String get cashuToken => 'Cashuトークン';

  @override
  String get lightningInvoice => 'Lightning請求書';

  @override
  String lightningInvoiceWithAmount(String amount) {
    return 'Lightning請求書: $amount サトシ';
  }

  @override
  String get addRoom => 'ルームを追加';

  @override
  String get enterRoomName => 'ルーム名を入力';

  @override
  String get cancel => 'キャンセル';

  @override
  String get join => '参加';

  @override
  String get themeMode => 'テーマモード';

  @override
  String anonymousUser(String uid) {
    return '匿名#$uid';
  }

  @override
  String roomPrefix(String room) {
    return '#$room';
  }
}
