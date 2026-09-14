import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/core/repository/focus_record_repository.dart';
import 'package:forest_focus/core/util/extension.dart';
import 'package:forest_focus/ui/widget/ff_button.dart';
import 'package:forest_focus/ui/widget/focus_record_edit_sheet.dart';
import '../../../l10n/app_localizations.dart';
import 'package:forest_focus/ui/page/focus/tag_chip.dart';
import 'package:forest_focus/ui/page/tag/tag_provider.dart';
import 'package:provider/provider.dart';
import '../../widget/ff_dialog.dart';
import 'focus_Provider.dart';
import 'focus_setup_sheet.dart';
import 'focus_timer_image_w.dart';

class FocusSettingView extends StatelessWidget {
  const FocusSettingView();

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FocusProvider>();
    final tagProvider = context.watch<TagProvider>();
    final tag = tagProvider.getById(provider.session.currentTagId)!;

    return Column(
      children: [
        Text(
          provider.totalMinute,
          style: const TextStyle(
            fontSize: 32,
          ),
        ),

        FocusTimerImageW(),

        Container(
          decoration: BoxDecoration(
            color: Color(tag.color).withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TagChip(
                tag: tag,
                onTap: () async{
                  if(provider.isSetting){
                    FocusSetupSheet.show(context);
                  }else{
                    final record = await FocusRecordRepository.instance.findById(provider.session.recordId!);
                    FocusRecordEditSheet.show(
                      context,
                      record!,
                      onSave: (record) async{
                        await provider.updateCurrentRecord(record);
                      }
                    );
                  }
                },
              ),
              if (!provider.isSetting)
                Icon(
                  Icons.edit,
                  size: 18,
                  color: Theme.of(context).cardColor,
                ),
            ],
          ),
        ),

        const SizedBox(height: 20,),

        if (!provider.isFinished)
          Text(
            provider.displayDuration.mmss,
            style: const TextStyle(
              fontSize: 64,
            ),
          ),

        if(provider.isSetting)
          FFButton(
            onPressed: provider.clkStart,
            text: AppLocalizations.of(context)!.start,
            width: 100,
          ),


        if(provider.isRunning || provider.isPaused)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FFButton(
                type: FFButtonType.secondary,
                text: AppLocalizations.of(context)!.cancel,
                onPressed: (){
                  FFDialog.show(
                    context,
                    title: AppLocalizations.of(context)!.alert_cancel_title,
                    message: AppLocalizations.of(context)!.alert_cancel_desc,
                    cancelText: AppLocalizations.of(context)!.cancel,
                    confirmText: AppLocalizations.of(context)!.give_up,
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
                text: provider.isRunning ? AppLocalizations.of(context)!.pause : AppLocalizations.of(context)!.resume,
                onPressed: provider.isRunning ? provider.clkPause : provider.clkResume,
                width: 100,
              )

            ],
          ),


        if(provider.isFinished)
          FFButton(
            onPressed:(){
              provider.clkBack();
            },
            text: "休息一下",
            width: 150,
          ),

      ],
    );
  }
}
