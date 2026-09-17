import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/core/model/FocusState.dart';
import 'package:forest_focus/ui/widget/ff_segment_button.dart';
import 'package:provider/provider.dart';
import '../../drawer/AppDrawer.dart';
import 'focus_Provider.dart';
import 'focus_content_view.dart';
import 'focus_countdown_set_dialog.dart';


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
                  onChanged: (bool ret) async {
                    FocusCountdownSetDialog.show(
                      context,
                      isCountdown: provider.isCountdown,
                      isMultiPlayer: provider.isMultiPlayer,
                      onChanged: (isCountdown, isMultiPlayer) async{
                        await provider.changeCountdownMode(isCountdown);
                        await provider.changeMultiPlayerMode(isMultiPlayer);
                      },
                    );
                  }
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
                        child: const FocusContentView(),
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

