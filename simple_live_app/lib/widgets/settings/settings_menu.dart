import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_live_app/app/app_style.dart';

class SettingsMenu<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Map<T, String> valueMap;
  final T value;
  final Widget? trailing;

  final Function(T)? onChanged;
  const SettingsMenu({
    required this.title,
    required this.value,
    required this.valueMap,
    this.subtitle,
    this.onChanged,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
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
      contentPadding: AppStyle.edgeInsetsL16.copyWith(right: 12),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: Get.textTheme.bodySmall!.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
      trailing: trailing ?? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            valueMap[value]!.tr,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: colorScheme.onSurfaceVariant),
          ),
          AppStyle.hGap4,
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
      onTap: () => openMenu(context),
    );
  }

  void openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true, //useSafeArea似乎无效
      builder: (_) => SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: RadioGroup(
            groupValue: value,
            onChanged: (e) {
              Get.back();
              onChanged?.call(e as T);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: valueMap.keys
                  .map(
                    (e) => RadioListTile(
                      value: e,
                      title: Text(
                        (valueMap[e]?.tr) ?? "???",
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
