import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_live_app/app/app_style.dart';

class ShadowCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final Function()? onTap;
  final Function()? onLongPress;
  const ShadowCard({
    required this.child,
    this.radius = 8.0,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final borderRadius = BorderRadius.circular(radius);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: isDark ? Colors.white.withAlpha(14) : Colors.black.withAlpha(10),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                  color: Colors.black.withAlpha(10),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onLongPress: onLongPress,
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
