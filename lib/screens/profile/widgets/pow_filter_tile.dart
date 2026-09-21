import 'package:couleur/l10n/app_localizations.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/utils/segmented_list_shape.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_tile_label.dart';

/// Segmented row whose control is a slider, so it stands taller than a
/// [ListTile] but keeps the group's surface and shape.
class PowFilterTile extends StatelessWidget {
  const PowFilterTile({super.key, required this.index, required this.count});

  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: segmentedListGap / 2,
      ),
      child: Material(
        color: theme.colorScheme.surfaceContainerHigh,
        shape: segmentedListShape(index: index, count: count),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsTileLabel(
                icon: Icons.security,
                label: l10n?.proofOfWorkFilter ?? 'Proof of Work Filter',
              ),
              const SizedBox(height: 4),
              Obx(
                () => Slider(
                  value: Repository.to.minimumPowDifficulty.value.toDouble(),
                  min: 0,
                  max: 32,
                  divisions: 32,
                  label: Repository.to.minimumPowDifficulty.value.toString(),
                  onChanged: (value) =>
                      Repository.to.setMinimumPowDifficulty(value.round()),
                ),
              ),
              Obx(
                () => Text(
                  l10n?.minimumDifficulty(
                        Repository.to.minimumPowDifficulty.value,
                      ) ??
                      'Minimum difficulty: ${Repository.to.minimumPowDifficulty.value} bits',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n?.powFilterHint ??
                    '0 = No filter, 16-20 = Moderate, 24+ = High',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
