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

  @override
  String get proofOfWorkFilter => '工作量证明过滤器';

  @override
  String minimumDifficulty(int difficulty) {
    return '最小难度：$difficulty 位';
  }

  @override
  String get powFilterHint => '0 = 无过滤，16-20 = 中等，24+ = 高';

  @override
  String letOthersKnow(String appName) {
    return '让其他人知道我在使用 $appName';
  }

  @override
  String get sourceCode => '源代码';

  @override
  String get viewOnGitHub => '在 GitHub 上查看';

  @override
  String get supportAndContact => '支持与联系';

  @override
  String get donateOrGetInTouch => '通过 Nostr 捐赠或联系';

  @override
  String get roomName => '房间名称';

  @override
  String get starred => '已加星标';

  @override
  String get popular => '热门';

  @override
  String get system => '系统';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get yesterday => '昨天';

  @override
  String sentFrom(String clientName) {
    return '发送自 $clientName';
  }
}
