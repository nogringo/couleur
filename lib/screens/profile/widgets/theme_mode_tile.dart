import 'package:couleur/controllers/theme_controller.dart';
import 'package:couleur/l10n/app_localizations.dart';
import 'package:couleur/utils/segmented_list_shape.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One theme mode choice. The picked row detaches from the group with its own
/// full rounding, so the selection reads without relying on colour alone.
class ThemeModeTile extends StatelessWidget {
  const ThemeModeTile({
    super.key,
    required this.mode,
    required this.index,
    required this.count,
  });

  final ThemeMode mode;
  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final controller = ThemeController.to;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: segmentedListGap / 2,
      ),
      child: Obx(() {
        final isSelected = controller.themeMode == mode;
        return ListTile(
          selected: isSelected,
          tileColor: colorScheme.surfaceContainerHigh,
          selectedTileColor: colorScheme.secondaryContainer,
          selectedColor: colorScheme.onSecondaryContainer,
          shape: segmentedListShape(
            index: index,
            count: count,
            isSelected: isSelected,
          ),
          minTileHeight: 56,
          leading: Icon(switch (mode) {
            ThemeMode.system => Icons.brightness_auto,
            ThemeMode.light => Icons.light_mode,
            ThemeMode.dark => Icons.dark_mode,
          }),
          title: Text(switch (mode) {
            ThemeMode.system => l10n?.system ?? 'System',
            ThemeMode.light => l10n?.light ?? 'Light',
            ThemeMode.dark => l10n?.dark ?? 'Dark',
          }),
          onTap: isSelected ? null : () => controller.setThemeMode(mode),
        );
      }),
    );
  }
}
