import 'package:get/get.dart';
import 'package:couleur/screens/chat/chat_screen.dart';
import 'package:couleur/screens/login/login_screen.dart';
import 'package:couleur/screens/profile/profile_screen.dart';

abstract class Routes {
  static const chat = '/';
  static const login = '/login';
  static const profile = '/profile';
}

final appPages = [
  GetPage(name: Routes.chat, page: () => const ChatScreen()),
  GetPage(name: Routes.login, page: () => const LoginScreen()),
  GetPage(name: Routes.profile, page: () => const ProfileScreen()),
];
