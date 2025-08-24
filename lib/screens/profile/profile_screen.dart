import 'package:couleur/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/controllers/theme_controller.dart';
import 'package:nostr_widgets/nostr_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                NUserProfile(
                  ndk: Repository.ndk,
                  onLogout: () {
                    Get.back();
                    AuthController.to.update();
                  },
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => themeController.toggleTheme(),
                  child: Card(
                    margin: EdgeInsets.all(0),
                    child: Obx(
                      () => ListTile(
                        leading: Icon(themeController.themeModeIcon),
                        title: Text('Theme Mode'),
                        subtitle: Text(themeController.themeModeText),
                        trailing: Icon(Icons.chevron_right),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(
                      'https://github.com/nogringo/couleur',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.all(0),
                    child: ListTile(
                      leading: CustomPaint(
                        size: Size(24, 24),
                        painter: GitHubIconPainter(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      title: Text('Source Code'),
                      subtitle: Text('View on GitHub'),
                      trailing: Icon(Icons.open_in_new),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final url = Uri.parse(
                      'https://nosta.me/b22b06b051fd5232966a9344a634d956c3dc33a7f5ecdcad9ed11ddc4120a7f2',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.all(0),
                    child: ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('Support & Contact'),
                      subtitle: Text('Donate or get in touch via Nostr'),
                      trailing: Icon(Icons.open_in_new),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GitHubIconPainter extends CustomPainter {
  final Color color;

  GitHubIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    final scaleX = size.width / 24;
    final scaleY = size.height / 24;

    path.moveTo(12 * scaleX, 1 * scaleY);
    path.cubicTo(
      5.923 * scaleX,
      1 * scaleY,
      1 * scaleX,
      5.923 * scaleY,
      1 * scaleX,
      12 * scaleY,
    );
    path.cubicTo(
      1 * scaleX,
      16.867 * scaleY,
      4.149 * scaleX,
      20.979 * scaleY,
      8.521 * scaleX,
      22.436 * scaleY,
    );
    path.cubicTo(
      9.071 * scaleX,
      22.532 * scaleY,
      9.277 * scaleX,
      22.203 * scaleY,
      9.277 * scaleX,
      21.914 * scaleY,
    );
    path.cubicTo(
      9.277 * scaleX,
      21.652 * scaleY,
      9.264 * scaleX,
      20.786 * scaleY,
      9.264 * scaleX,
      19.865 * scaleY,
    );
    path.cubicTo(
      6.5 * scaleX,
      20.374 * scaleY,
      5.785 * scaleX,
      19.191 * scaleY,
      5.565 * scaleX,
      18.573 * scaleY,
    );
    path.cubicTo(
      5.441 * scaleX,
      18.256 * scaleY,
      4.905 * scaleX,
      17.28 * scaleY,
      4.438 * scaleX,
      17.019 * scaleY,
    );
    path.cubicTo(
      4.053 * scaleX,
      16.812 * scaleY,
      3.502 * scaleX,
      16.304 * scaleY,
      4.424 * scaleX,
      16.29 * scaleY,
    );
    path.cubicTo(
      5.29 * scaleX,
      16.276 * scaleY,
      5.909 * scaleX,
      17.087 * scaleY,
      6.115 * scaleX,
      17.418 * scaleY,
    );
    path.cubicTo(
      7.105 * scaleX,
      19.081 * scaleY,
      8.686 * scaleX,
      18.614 * scaleY,
      9.319 * scaleX,
      18.325 * scaleY,
    );
    path.cubicTo(
      9.415 * scaleX,
      17.61 * scaleY,
      9.704 * scaleX,
      17.129 * scaleY,
      10.02 * scaleX,
      16.854 * scaleY,
    );
    path.cubicTo(
      7.572 * scaleX,
      16.579 * scaleY,
      5.015 * scaleX,
      15.63 * scaleY,
      5.015 * scaleX,
      11.422 * scaleY,
    );
    path.cubicTo(
      5.015 * scaleX,
      10.226 * scaleY,
      5.441 * scaleX,
      9.236 * scaleY,
      6.143 * scaleX,
      8.466 * scaleY,
    );
    path.cubicTo(
      6.032 * scaleX,
      8.191 * scaleY,
      5.647 * scaleX,
      7.064 * scaleY,
      6.253 * scaleX,
      5.551 * scaleY,
    );
    path.cubicTo(
      6.253 * scaleX,
      5.551 * scaleY,
      7.174 * scaleX,
      5.263 * scaleY,
      9.277 * scaleX,
      6.679 * scaleY,
    );
    path.cubicTo(
      10.027 * scaleX,
      6.556 * scaleY,
      10.791 * scaleX,
      6.495 * scaleY,
      11.562 * scaleX,
      6.495 * scaleY,
    );
    path.cubicTo(
      12.333 * scaleX,
      6.495 * scaleY,
      13.097 * scaleX,
      6.556 * scaleY,
      13.847 * scaleX,
      6.679 * scaleY,
    );
    path.cubicTo(
      15.951 * scaleX,
      5.249 * scaleY,
      16.872 * scaleX,
      5.551 * scaleY,
      16.872 * scaleX,
      5.551 * scaleY,
    );
    path.cubicTo(
      17.477 * scaleX,
      7.064 * scaleY,
      17.093 * scaleX,
      8.191 * scaleY,
      16.983 * scaleX,
      8.466 * scaleY,
    );
    path.cubicTo(
      17.684 * scaleX,
      9.236 * scaleY,
      18.11 * scaleX,
      10.213 * scaleY,
      18.11 * scaleX,
      11.422 * scaleY,
    );
    path.cubicTo(
      18.11 * scaleX,
      15.644 * scaleY,
      15.539 * scaleX,
      16.579 * scaleY,
      13.091 * scaleX,
      16.854 * scaleY,
    );
    path.cubicTo(
      13.49 * scaleX,
      17.198 * scaleY,
      13.834 * scaleX,
      17.858 * scaleY,
      13.834 * scaleX,
      18.889 * scaleY,
    );
    path.cubicTo(
      13.834 * scaleX,
      20.36 * scaleY,
      13.82 * scaleX,
      21.543 * scaleY,
      13.82 * scaleX,
      21.914 * scaleY,
    );
    path.cubicTo(
      13.82 * scaleX,
      22.203 * scaleY,
      14.026 * scaleX,
      22.546 * scaleY,
      14.576 * scaleX,
      22.436 * scaleY,
    );
    path.cubicTo(
      18.851 * scaleX,
      20.979 * scaleY,
      22 * scaleX,
      16.854 * scaleY,
      22 * scaleX,
      12 * scaleY,
    );
    path.cubicTo(
      22 * scaleX,
      5.923 * scaleY,
      17.078 * scaleX,
      1 * scaleY,
      11 * scaleX,
      1 * scaleY,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
