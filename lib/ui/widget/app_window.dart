import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_size.dart';
import 'app_title_bar.dart';

class AppWindow extends StatelessWidget {

  final String title;

  final Widget child;

  final double? width;

  final double? height;

  final VoidCallback? onClose;

  const AppWindow({
    super.key,
    required this.title,
    required this.child,
    this.width,
    this.height,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {

    return Dialog(

      backgroundColor: Colors.transparent,

      elevation: 0,

      insetPadding: const EdgeInsets.all(40),

      child: Center(

        child: Container(

          width: width,

          height: height,

          decoration: BoxDecoration(

            color: AppColors.paper,

            border: Border.all(

              color: AppColors.border,

              width: AppSizes.border * 2,
            ),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTitleBar(
                title: title,
                onClose: onClose ??
                        () {
                      Navigator.pop(context);
                    },
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}