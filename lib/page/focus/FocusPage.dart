import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/page/focus/FocusProvider.dart';
import 'package:forest_focus/util/extension.dart';
import 'package:provider/provider.dart';
import '../../model/FocusState.dart';
import '../../widget/FocusTime.dart';


class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FocusProvider(),
      child:Consumer<FocusProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: const Color(0xFF4CAF93),
            body: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: switch (provider.state) {
                  FocusState.setting =>
                  const _SettingView(),

                  FocusState.running ||
                  FocusState.paused =>
                  const _RunningView(),

                  FocusState.finished =>
                  const _FinishedView(),
                },
              ),
            ),
          );
        }
      )
    );
  }
}

class _SettingView extends StatelessWidget {
  const _SettingView();

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FocusProvider>();

    return Column(
      key: const ValueKey('setting'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

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

              Image.asset(
                provider.plantName,
                width: 150,
              ),
            ],
          ),
        ),

        Text(
          provider.userSetDuration.mmss,
          style: const TextStyle(
            fontSize: 64,
            color: Colors.white,
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

class _RunningView extends StatelessWidget {
  const _RunningView();

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FocusProvider>();

    return Column(
      key: const ValueKey('running'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        AnimatedScale(
          scale: 1.15,
          duration: const Duration(milliseconds: 400),
          child: Image.asset(
            provider.plantName,
            width: 200,
          ),
        ),

        const SizedBox(height: 24),

        Text(
          provider.remaining.mmss,
          style: const TextStyle(
            fontSize: 72,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 40),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            OutlinedButton(
              onPressed: provider.cancel,
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

class _FinishedView extends StatelessWidget {
  const _FinishedView();

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FocusProvider>();

    return Column(
      key: const ValueKey('finished'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.asset(
          provider.plantName,
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