import 'package:couleur/utils/segmented_list_shape.dart';
import 'package:flutter/material.dart';

/// Settings row toggling a boolean in place.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.index,
    required this.count,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: segmentedListGap / 2,
      ),
      child: SwitchListTile(
        tileColor: colorScheme.surfaceContainerHigh,
        shape: segmentedListShape(index: index, count: count),
        minTileHeight: 56,
        secondary: Icon(icon),
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
