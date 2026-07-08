import 'package:flutter/material.dart';
import 'package:simple_live_app/app/app_style.dart';

class SettingsSwitch extends StatelessWidget {
  final bool value;
  final String title;
  final String? subtitle;
  final Function(bool) onChanged;
  const SettingsSwitch({
    required this.value,
    required this.title,
    this.subtitle,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SwitchListTile(
      minTileHeight: 58,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyle.miuiSmallRadius),
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      contentPadding: AppStyle.edgeInsetsL16.copyWith(right: 12),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: colorScheme.onSurfaceVariant),
            )
          : null,
      value: value,
      onChanged: onChanged,
    );
  }
}
