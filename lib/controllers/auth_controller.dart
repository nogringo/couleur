import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:ndk_flutter/ndk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const anonymousPubkeyKey = 'anonymousPubkey';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  static Ndk get ndk => Get.find();
  static NdkFlutter get ndkFlutter => Get.find();

  final SharedPreferences box = Get.find();

  String? get anonymousPubkey => box.getString(anonymousPubkeyKey);

  bool get isAnonymous {
    final pubkey = ndk.accounts.getPublicKey();
    return pubkey != null && pubkey == anonymousPubkey;
  }

  bool get isLoggedIn => ndk.accounts.isLoggedIn && !isAnonymous;

  /// Everyone gets a signing key on arrival, so chatting needs no login.
  Future<void> ensureAccount() async {
    final storedAnonymousPubkey = anonymousPubkey;
    if (storedAnonymousPubkey != null &&
        !ndk.accounts.hasAccount(storedAnonymousPubkey)) {
      await box.remove(anonymousPubkeyKey);
    }

    if (ndk.accounts.isLoggedIn) return;

    final (privateKey, publicKey) = ndk.config.eventSignerFactory
        .generateKeyPair();
    ndk.accounts.loginPrivateKey(pubkey: publicKey, privkey: privateKey);

    await box.setString(anonymousPubkeyKey, publicKey);
    await ndkFlutter.saveAccountsState();

    update();
  }

  Future<void> dropAnonymousAccount() async {
    final pubkey = anonymousPubkey;
    if (pubkey == null) return;

    if (ndk.accounts.hasAccount(pubkey)) {
      ndk.accounts.removeAccount(pubkey: pubkey);
    }
    await box.remove(anonymousPubkeyKey);
    await ndkFlutter.saveAccountsState();
  }
}
