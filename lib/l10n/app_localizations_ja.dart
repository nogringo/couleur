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

  @override
  String get proofOfWorkFilter => 'プルーフ・オブ・ワークフィルター';

  @override
  String minimumDifficulty(int difficulty) {
    return '最小難易度: $difficulty ビット';
  }

  @override
  String get powFilterHint => '0 = フィルターなし、16-20 = 中程度、24+ = 高';

  @override
  String letOthersKnow(String appName) {
    return '$appNameを使用していることを他の人に知らせる';
  }

  @override
  String get sourceCode => 'ソースコード';

  @override
  String get viewOnGitHub => 'GitHubで見る';

  @override
  String get supportAndContact => 'サポートと連絡先';

  @override
  String get donateOrGetInTouch => 'Nostr経由で寄付または連絡';

  @override
  String get roomName => 'ルーム名';

  @override
  String get starred => 'スター付き';

  @override
  String get popular => '人気';

  @override
  String get system => 'システム';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get yesterday => '昨日';

  @override
  String sentFrom(String clientName) {
    return '$clientNameから送信';
  }
}
