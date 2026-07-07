import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/focus/FocusProvider.dart';
import 'package:forest_focus/ui/widget/FocusTime.dart';
import 'package:provider/provider.dart';

import '../../../util/extension.dart';
import '../reward_picker/collectible_dialog.dart';

class FocusSettingView extends StatelessWidget {
  const FocusSettingView();

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FocusProvider>();

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
                maxMinutes: 100,
                onChanged: provider.updateMinutes,
              ),

              GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return const CollectibleDialog();
                    },
                  );
                },
                child: Image.asset(
                  provider.plantName,
                  width: 150,
                ),
              )
            ],
          ),
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