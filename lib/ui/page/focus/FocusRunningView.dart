import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/ui/widget/ff_button.dart';
import 'package:provider/provider.dart';

import '../../../model/FocusState.dart';
import '../../../util/extension.dart';
import '../../widget/ff_dialog.dart';
import '../reward_picker/collectible_provider.dart';
import 'focus_Provider.dart';
import 'focus_timer_image_w.dart';

class FocusRunningView extends StatelessWidget {
  const FocusRunningView();

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FocusProvider>();
    final rewardProvider = context.read<CollectibleProvider>();

    return Column(
      key: const ValueKey('running'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        FocusTimerImageW(),

        const SizedBox(height: 24),

        Text(
          provider.displayDuration.mmss,
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 40),

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
              text: provider.state == FocusState.running ? "Pause" : "Resume",
              onPressed: provider.state == FocusState.running ? provider.clkPause : provider.clkResume,
              width: 100,
            )

          ],
        ),
      ],
    );
  }
}