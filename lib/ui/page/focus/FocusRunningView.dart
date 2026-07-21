import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/FocusState.dart';
import '../../../util/extension.dart';
import '../../widget/forest_dialog.dart';
import '../reward_picker/collectible_provider.dart';
import 'FocusProvider.dart';

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

        AnimatedScale(
          scale: 1.15,
          duration: const Duration(milliseconds: 400),
          child: Image.asset(
            rewardProvider.getById(provider.currentCollectibleItemId)?.assetPath ?? "assets/plant_1.png",
            width: 200,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          provider.remaining.mmss,
          style: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 40),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            OutlinedButton(
              onPressed: () async {

                showDialog(
                  context: context,
                  builder: (_) => ForestDialog(
                    image: rewardProvider.getById(provider.currentCollectibleItemId)?.assetPath ?? "assets/plant_1.png",
                    title: '小树苗还没长大呢',
                    message: '如果现在离开，本次专注将不会获得奖励。',
                    confirmText: '继续专注',
                    cancelText: '结束专注',

                    onConfirm: () {
                      Navigator.of(context).pop();
                    },

                    onCancel: () async {
                      Navigator.of(context).pop();
                      await provider.cancel();
                    },
                  ),
                );

              },
              child: const Text("Cancel"),
            ),

            const SizedBox(width: 16),

            ElevatedButton(
              onPressed: provider.state ==
                  FocusState.running
                  ? provider.pause
                  : provider.resume,
              child: Text(
                provider.state ==
                    FocusState.running
                    ? "Pause"
                    : "Resume",
              ),
            ),
          ],
        ),
      ],
    );
  }
}