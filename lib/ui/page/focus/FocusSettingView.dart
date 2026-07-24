import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/theme/app_colors.dart';
import 'package:forest_focus/ui/widget/ff_button.dart';
import '../../../util/extension.dart';
import 'package:forest_focus/ui/page/focus/tag_chip.dart';
import 'package:forest_focus/ui/page/reward_picker/collectible_provider.dart';
import 'package:forest_focus/ui/page/tag/tag_provider.dart';
import 'package:forest_focus/ui/widget/FocusTime.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../widget/ff_dialog.dart';
import 'focus_Provider.dart';
import 'focus_setup_sheet.dart';
import 'focus_timer_image_w.dart';

class FocusSettingView extends StatelessWidget {
  const FocusSettingView();

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FocusProvider>();
    final tagProvider = context.watch<TagProvider>();

    return Column(
      children: [
        Text(
          provider.totalMinute,
          style: const TextStyle(
            fontSize: 32,
          ),
        ),

        FocusTimerImageW(),

        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TagChip(
                tag: tagProvider.getById(provider.session.currentTagId)!,
                onTap: (){
                  FocusSetupSheet.show(context);
                },
              ),
              if (!provider.isSetting)
                const Icon(
                  Icons.edit,
                  size: 18,
                  color: AppColors.textLight,
                ),
            ],
          ),
        ),

        if (!provider.isFinished)
          Text(
            provider.displayDuration.mmss,
            style: const TextStyle(
              fontSize: 64,
            ),
          ),

        if(provider.isSetting)
          FFButton(
            onPressed: provider.clkStart,
            text: "Start",
            width: 100,
          ),


        if(provider.isRunning || provider.isPaused)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FFButton(
                type: FFButtonType.secondary,
                text: "Cancel",
                onPressed: (){
                  FFDialog.show(
                      context,
                      title: "确定要放弃吗?",
                      message: "放弃不会得到奖励",
                      cancelText: "取消",
                      confirmText: "放弃",
                      onConfirm: () async {
                        Navigator.of(context).pop();
                        await provider.clkCancel();
                      },
                      onCancel: (){
                        Navigator.of(context).pop();
                      }
                  );
                },
                width: 100,
              ),

              const SizedBox(width: 16),

              FFButton(
                text: provider.isRunning ? "Pause" : "Resume",
                onPressed: provider.isRunning ? provider.clkPause : provider.clkResume,
                width: 100,
              )

            ],
          ),


        if(provider.isFinished)
          FFButton(
            onPressed:(){

            },
            text: "休息一下",
            width: 150,
          ),

      ],
    );
  }
}
