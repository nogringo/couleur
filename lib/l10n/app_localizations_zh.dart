// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Couleur';

  @override
  String get login => '登录';

  @override
  String get message => '消息';

  @override
  String get viewProfile => '查看资料';

  @override
  String get mention => '提及';

  @override
  String get muteUser => '屏蔽用户';

  @override
  String get cashuToken => 'Cashu代币';

  @override
  String get lightningInvoice => '闪电发票';

  @override
  String lightningInvoiceWithAmount(String amount) {
    return '闪电发票：$amount 聪';
  }

  @override
  String get addRoom => '添加房间';

  @override
  String get enterRoomName => '输入房间名称';

  @override
  String get cancel => '取消';

  @override
  String get join => '加入';

  @override
  String get themeMode => '主题模式';

  @override
  String anonymousUser(String uid) {
    return '匿名#$uid';
  }

  @override
  String roomPrefix(String room) {
    return '#$room';
  }
}
