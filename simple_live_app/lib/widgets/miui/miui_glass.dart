import 'dart:ui';

import 'package:flutter/material.dart';

class MiuiGlass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final double blur;
  final double opacity;
  final Color? tintColor;
  final Border? border;

  const MiuiGlass({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.radius = 28,
    this.blur = 24,
    this.opacity = 0.62,
    this.tintColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseTint = tintColor ?? (isDark ? const Color(0xFF151820) : Colors.white);
    final highlight = isDark ? Colors.white.withAlpha(28) : Colors.white.withAlpha(180);
    final shadow = isDark ? Colors.black.withAlpha(60) : Colors.black.withAlpha(18);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  baseTint.withOpacity(opacity + 0.10 > 1 ? 1 : opacity + 0.10),
                  baseTint.withOpacity(opacity),
                  baseTint.withOpacity(opacity - 0.12 < 0 ? 0 : opacity - 0.12),
                ],
              ),
              border: border ??
                  Border.all(
                    color: isDark ? Colors.white.withAlpha(18) : Colors.white.withAlpha(210),
                    width: 1,
                  ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            highlight,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MiuiGlassTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const MiuiGlassTopBar({
    required this.child,
    super.key,
    this.height = 58,
    this.margin = const EdgeInsets.fromLTRB(12, 8, 12, 8),
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  Size get preferredSize => Size.fromHeight(height + 16);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height + 16,
          child: MiuiGlass(
            margin: margin,
            padding: padding,
            radius: 28,
            blur: 26,
            opacity: Theme.of(context).brightness == Brightness.dark ? 0.56 : 0.66,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class MiuiGlassBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<MiuiGlassNavItem> items;

  const MiuiGlassBottomBar({
    required this.selectedIndex,
    required this.onSelected,
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return SafeArea(
      top: false,
      child: MiuiGlass(
        margin: EdgeInsets.fromLTRB(14, 0, 14, bottom > 0 ? 8 : 14),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        radius: 30,
        blur: 30,
        opacity: Theme.of(context).brightness == Brightness.dark ? 0.58 : 0.70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final selected = selectedIndex == index;
            final colorScheme = Theme.of(context).colorScheme;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => onSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: selected
                          ? colorScheme.primary.withAlpha(34)
                          : Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          size: 22,
                          color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutCubic,
                          child: selected
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Text(
                                    item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class MiuiGlassNavItem {
  final IconData icon;
  final String label;

  const MiuiGlassNavItem({required this.icon, required this.label});
}
