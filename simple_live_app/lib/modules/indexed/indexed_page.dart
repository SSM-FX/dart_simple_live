import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_live_app/app/app_style.dart';

import 'indexed_controller.dart';

class IndexedPage extends GetView<IndexedController> {
  const IndexedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        return Scaffold(
          body: Row(
            children: [
              Visibility(
                visible: isLandscape,
                child: SafeArea(
                  right: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Obx(
                      () => NavigationRail(
                        selectedIndex: controller.index.value,
                        onDestinationSelected: controller.setIndex,
                        extended: false,
                        minWidth: 72,
                        labelType: NavigationRailLabelType.all,
                        useIndicator: true,
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
                    child: IndexedStack(
                      index: controller.index.value,
                      children: controller.pages,
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Visibility(
            visible: !isLandscape,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, bottomPadding > 0 ? 8 : 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Obx(
                    () => NavigationBar(
                      selectedIndex: controller.index.value,
                      onDestinationSelected: controller.setIndex,
                      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                      destinations: controller.items
                          .map(
                            (item) => NavigationDestination(
                              icon: Icon(item.iconData),
                              label: item.title,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
