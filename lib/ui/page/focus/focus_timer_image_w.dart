import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../widget/FocusTime.dart';
import '../reward_picker/collectible_provider.dart';
import 'focus_Provider.dart';
import 'focus_setup_sheet.dart';

class FocusTimerImageW extends StatelessWidget {
  const FocusTimerImageW({ super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FocusProvider>();
    final rewardProvider = context.read<CollectibleProvider>();

    final screenWidth = MediaQuery.of(context).size.width;
    final focusWidgetW = screenWidth * 0.8;
    final focusProgressRadiusFactor = AppConstants.kFocusProgressRadiusFactor;
    final focusProgressThickness = AppConstants.kFocusProgressThickness;

    return Container(
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
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color:Theme.of(context).colorScheme.secondary,
                width: focusWidgetW * focusProgressRadiusFactor * focusProgressThickness * 0.5,
              ),
            ),
          ),
          provider.isCountdown && provider.isSetting ? FocusTimerWidget(
            radiusFactor: focusProgressRadiusFactor,
            thickness: focusProgressThickness,
            initialMinutes: provider.userSetDuration.inMinutes,
            minMinutes: AppConstants.minMinutes,
            maxMinutes: AppConstants.maxMinutes,
            step: AppConstants.step,
            onChanged: provider.changeTargetMinutes,
            progressColor: Theme.of(context).colorScheme.primary,
          ) : const SizedBox.shrink(),

          GestureDetector(
            onTap: () async {
              if (provider.isSetting ){
                FocusSetupSheet.show(context);
              }
            },
            child: Image.asset(
              rewardProvider.getById(provider.currentCollectibleItemId).assetPath,
              width: 150,
            ),
          )
        ],
      ),
    );
  }
}