import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_live_app/app/app_style.dart';
import 'package:simple_live_app/widgets/miui/miui_glass.dart';

import 'indexed_controller.dart';

class IndexedPage extends GetView<IndexedController> {
  const IndexedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        return Scaffold(
          extendBody: true,
          body: Stack(
            children: [
              Row(
                children: [
                  Visibility(
                    visible: isLandscape,
                    child: SafeArea(
                      right: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: Obx(
                          () => MiuiGlass(
                            radius: 30,
                            blur: 28,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: NavigationRail(
                              selectedIndex: controller.index.value,
                              onDestinationSelected: controller.setIndex,
                              extended: false,
                              minWidth: 72,
                              labelType: NavigationRailLabelType.all,
                              useIndicator: true,
                              backgroundColor: Colors.transparent,
                              groupAlignment: -1,
                              destinations: controller.items
                                  .map(
                                    (item) => NavigationRailDestination(
                                      icon: Icon(item.iconData),
                                      label: Text(item.title),
                                      padding: AppStyle.edgeInsetsV8,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        decoration: BoxDecoration(
                          border: Border(
                            left: isLandscape
                                ? BorderSide(
                                    color: Theme.of(context).dividerColor,
                                    width: 1,
                                  )
                                : BorderSide.none,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: isLandscape ? 0 : 86 + MediaQuery.of(context).padding.bottom,
                          ),
                          child: IndexedStack(
                            index: controller.index.value,
                            children: controller.pages,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (!isLandscape)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Obx(
                    () => MiuiGlassBottomBar(
                      selectedIndex: controller.index.value,
                      onSelected: controller.setIndex,
                      items: controller.items
                          .map(
                            (item) => MiuiGlassNavItem(
                              icon: item.iconData,
                              label: item.title,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
