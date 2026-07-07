import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/focus/FocusSettingView.dart';
import 'package:provider/provider.dart';
import '../../../model/FocusState.dart';
import '../../drawer/AppDrawer.dart';
import './FocusProvider.dart';
import 'FocusFinishedView.dart';
import 'FocusRunningView.dart';


class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FocusProvider(),
      child:Consumer<FocusProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            drawer: const AppDrawer(),
            appBar: provider.state == FocusState.setting
                ? AppBar(
              elevation: 0,
            ) : null,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        minWidth: constraints.maxWidth,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: switch (provider.state) {
                          FocusState.setting => const FocusSettingView(),
                          FocusState.running || FocusState.paused => const FocusRunningView(),
                          FocusState.finished => const FocusFinishedView(),
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      )
    );
  }
}

