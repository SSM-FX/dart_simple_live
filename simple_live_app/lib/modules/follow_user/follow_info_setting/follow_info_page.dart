import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'package:simple_live_app/app/app_style.dart';
import 'package:simple_live_app/app/sites.dart';
import 'package:simple_live_app/modules/follow_user/follow_info_setting/follow_info_controller.dart';
import 'package:simple_live_app/widgets/miui/miui_glass.dart';
import 'package:simple_live_app/widgets/settings/settings_menu.dart';

class FollowInfoPage extends GetView<FollowInfoController> {
  const FollowInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final site = Sites.allSites[controller.followUser.value!.siteId]!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MiuiGlassTitleBar(
        title: '关注信息设置',
        actions: [
          Obx(
            () => controller.pageLoadding.value
                ? const IconButton(
                    onPressed: null,
                    icon: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    onPressed: controller.refreshData,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
          ),
        ],
      ),
      body: ListView(
        padding: AppStyle.edgeInsetsA12.copyWith(top: 88),
        children: [
          MiuiGlass(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            radius: 24,
            blur: 22,
            child: Obx(
              () => Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(controller.followUser.value!.face),
                  ),
                  AppStyle.hGap12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.followUser.value!.remark?.isNotEmpty == true
                              ? '${controller.followUser.value!.userName} (${controller.followUser.value!.remark!})'
                              : controller.followUser.value!.userName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AppStyle.vGap4,
                        Row(
                          children: [
                            Image.asset(site.logo, width: 18),
                            AppStyle.hGap8,
                            Flexible(
                              child: Text(
                                '${site.name}  房间号：${controller.followUser.value!.roomId}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withValues(alpha: .7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SettingsMenu<String>(
            title: '标签设置',
            value: controller.selectedTag.value?.tag ?? '全部',
            valueMap: {
              for (final t in controller.tagOptions) t.tag: t.tag,
            },
            onChanged: (value) {
              final target = controller.tagOptions.firstWhere(
                (e) => e.tag == value,
                orElse: () => controller.tagOptions.first,
              );
              controller.changeTag(target);
            },
          ),
          AppStyle.vGap12,
          Obx(
            () => ListTile(
              title: Text('备注设置', style: Theme.of(context).textTheme.bodyLarge),
              shape: RoundedRectangleBorder(borderRadius: AppStyle.radius12),
              contentPadding: AppStyle.edgeInsetsL16.copyWith(right: 8),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.followUser.value?.remark?.isNotEmpty == true
                        ? controller.followUser.value!.remark!
                        : '无',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  AppStyle.hGap4,
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              onTap: () {
                final textController = TextEditingController(
                  text: controller.followUser.value?.remark,
                );
                Get.dialog(
                  AlertDialog(
                    title: const Text('修改备注'),
                    content: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '请输入备注名',
                      ),
                      autofocus: true,
                      onSubmitted: (value) {
                        controller.updateRemark(value.trim());
                        Get.back();
                      },
                    ),
                    actions: [
                      TextButton(onPressed: () => Get.back(), child: const Text('取消')),
                      TextButton(
                        onPressed: () {
                          controller.updateRemark(textController.text.trim());
                          Get.back();
                        },
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          AppStyle.vGap12,
          MiuiGlass(
            padding: const EdgeInsets.all(14),
            radius: 24,
            blur: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Remix.link),
                    SizedBox(width: 8),
                    Text('平台迁移（输入直播链接进行解析）'),
                  ],
                ),
                AppStyle.vGap8,
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.migrationUrlController,
                        decoration: const InputDecoration(
                          hintText: '粘贴主播在新平台的直播间链接，如 https://... ',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        onSubmitted: (_) => controller.parseAndMigrate(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: '粘贴',
                      onPressed: controller.pasteFromClipboard,
                      icon: const Icon(Remix.clipboard_line),
                    ),
                    ElevatedButton.icon(
                      onPressed: controller.parseAndMigrate,
                      icon: const Icon(Remix.arrow_right_line),
                      label: const Text('迁移'),
                    ),
                  ],
                ),
                AppStyle.vGap12,
                Text(
                  'other todo ...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}