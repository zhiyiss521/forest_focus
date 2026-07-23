import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/theme/app_colors.dart';
import 'package:forest_focus/theme/app_size.dart';
import 'package:forest_focus/ui/page/focus/FocusSettingView.dart';
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
            backgroundColor: AppColors.background,
            extendBody: true,
            extendBodyBehindAppBar: true,
            drawer: const AppDrawer(),
            appBar: provider.state == FocusState.setting ? AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: SegmentedButton<bool>(
                showSelectedIcon: false,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.primary;
                    }
                    return AppColors.backgroundSecondary;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    return AppColors.textLight;
                  }),
                  side: WidgetStateProperty.all(BorderSide.none),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.buttonCornerRadius),
                    ),
                  ),
                ),
                segments: const [
                  ButtonSegment(
                    value: true,
                    icon: Icon(Icons.hourglass_top),
                  ),
                  ButtonSegment(
                    value: false,
                    icon: Icon(Icons.timer),
                  ),
                ],
                selected: {provider.session.isCountdown},
                onSelectionChanged: (value) {
                  provider.changeCountdownMode(value.first);
                },
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

