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
import 'focus_Provider.dart';
import 'focus_setup_sheet.dart';

class FocusSettingView extends StatelessWidget {
  const FocusSettingView();

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FocusProvider>();
    final rewardProvider = context.read<CollectibleProvider>();
    final tagProvider = context.watch<TagProvider>();

    final screenWidth = MediaQuery.of(context).size.width;
    final focusWidgetW = screenWidth * 0.8;
    final focusProgressRadiusFactor = AppConstants.kFocusProgressRadiusFactor;
    final focusProgressThickness = AppConstants.kFocusProgressThickness;

    return Column(
      children: [
        Text(
          provider.totalMinute,
          style: const TextStyle(
            fontSize: 32,
          ),
        ),
        Container(
          width: focusWidgetW,
          height: focusWidgetW,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: focusWidgetW * focusProgressRadiusFactor ,
                height: focusWidgetW * focusProgressRadiusFactor,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundSecondary,
                  border: Border.all(
                    color: AppColors.secondary,
                    width: focusWidgetW * focusProgressRadiusFactor * focusProgressThickness * 0.5,
                  ),
                ),
              ),
              provider.session.isCountdown ? FocusTimerWidget(
                radiusFactor: focusProgressRadiusFactor,
                thickness: focusProgressThickness,
                initialMinutes: provider.userSetDuration.inMinutes,
                minMinutes: AppConstants.minMinutes,
                maxMinutes: AppConstants.maxMinutes,
                step: AppConstants.step,
                onChanged: provider.updateMinutes,
              ) : const SizedBox.shrink(),

              GestureDetector(
                onTap: () async {
                  FocusSetupSheet.show(context);
                },
                child: Image.asset(
                  rewardProvider.getById(provider.currentCollectibleItemId).assetPath,
                  width: 150,
                ),
              )
            ],
          ),
        ),

        TagChip(
          tag: tagProvider.getById(provider.session.currentTagId)!,
          onTap: (){
            FocusSetupSheet.show(context);
          },
        ),

        Text(
          provider.isCountdown ? provider.userSetDuration.mmss : Duration.zero.mmss,
          style: const TextStyle(
            fontSize: 64,
          ),
        ),

        FFButton(
          onPressed: provider.start,
          text: "Start",
          width: 100,
        ),
      ],
    );
  }
}
