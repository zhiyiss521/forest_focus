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
          onPressed: provider.clkStart,
          text: "Start",
          width: 100,
        ),
      ],
    );
  }
}
