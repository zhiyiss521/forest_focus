import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/reward_picker/collectible_provider.dart';
import 'package:provider/provider.dart';
import 'focus_Provider.dart';

class FocusFinishedView extends StatelessWidget {
  const FocusFinishedView();

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FocusProvider>();
    final rewardProvider = context.read<CollectibleProvider>();

    return Column(
      key: const ValueKey('finished'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.asset(
          rewardProvider.getById(provider.currentCollectibleItemId).assetPath,
          width: 200,
        ),

        const SizedBox(height: 24),

        const Text(
          "Congratulations 🎉",
        ),

        ElevatedButton(
          onPressed: provider.cancel,
          child: const Text("Again"),
        ),
      ],
    );
  }
}