import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/focus/FocusProvider.dart';
import 'package:forest_focus/ui/page/focus/tag_chip.dart';
import 'package:forest_focus/ui/page/reward_picker/collectible_provider.dart';
import 'package:forest_focus/ui/page/tag/tag_provider.dart';
import 'package:forest_focus/ui/widget/FocusTime.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../util/extension.dart';
import '../reward_picker/collectible_dialog.dart';
import 'focus_setup_sheet.dart';

class FocusSettingView extends StatelessWidget {
  const FocusSettingView();

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FocusProvider>();
    final rewardProvider = context.read<CollectibleProvider>();
    final tagProvider = context.watch<TagProvider>();

    return Column(
      children: [
        Text(
          provider.totalMinute,
          style: const TextStyle(
            fontSize: 32,
          ),
        ),
        SizedBox(
          width: 320,
          height: 320,
          child: Stack(
            alignment: Alignment.center,
            children: [
              FocusTimerWidget(
                initialMinutes: provider.userSetDuration.inMinutes,
                minMinutes: AppConstants.minMinutes,
                maxMinutes: AppConstants.maxMinutes,
                step: AppConstants.step,
                onChanged: provider.updateMinutes,
              ),

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
          provider.userSetDuration.mmss,
          style: const TextStyle(
            fontSize: 64,
          ),
        ),

        ElevatedButton(
          onPressed: provider.start,
          child: const Text("Start"),
        ),
      ],
    );
  }
}
