import 'package:flutter/material.dart';
import 'package:simple_live_app/app/app_style.dart';

class SettingsCard extends StatelessWidget {
  final Widget child;
  const SettingsCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? const Color(0xFF1A1D24) : Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppStyle.miuiRadius),
        side: BorderSide(
          color: isDark ? Colors.white.withAlpha(14) : Colors.black.withAlpha(10),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppStyle.miuiRadius),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    color: Colors.black.withAlpha(8),
                  ),
                ],
        ),
        child: child,
      ),
    );
  }
}
