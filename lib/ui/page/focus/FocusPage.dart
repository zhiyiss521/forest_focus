import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/focus/FocusSettingView.dart';
import 'package:forest_focus/ui/widget/ff_segment_button.dart';
import 'package:provider/provider.dart';
import '../../../model/FocusState.dart';
import '../../drawer/AppDrawer.dart';
import 'focus_Provider.dart';


class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<FocusProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            drawer: const AppDrawer(),
            appBar: provider.state == FocusState.setting ? AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: SizedBox(
                width: 120,
                child: FFSegmentButton<bool>(
                    items: [
                      FFSegmentItem(
                        title: "倒",
                        value: true,
                      ),
                      FFSegmentItem(
                        title: "正",
                        value: false,
                      ),
                    ],
                    selected: provider.isCountdown,
                    onChanged: provider.changeCountdownMode
                ),
              ),
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
                        child: const FocusSettingView(),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
    );
  }
}

