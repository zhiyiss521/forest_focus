import 'package:flutter/cupertino.dart';
import 'package:forest_focus/core/model/focus_record.dart';
import '../../../core/repository/focus_record_repository.dart';

class TimelineProvider extends ChangeNotifier {

  bool loading = true;

  List<FocusRecord> records = [];

  Future<void> load() async {
    loading = true;
    notifyListeners();

    records = await FocusRecordRepository.instance.findAll();

    loading = false;
    notifyListeners();
  }

  Future<void> updateRecord(FocusRecord record) async {
    await FocusRecordRepository.instance.update(record);

    final index = records.indexWhere((e) => e.id == record.id);

    if (index != -1) {
      records[index] = record;
      notifyListeners();
    }
  }

  Future<void> deleteRecord(FocusRecord record) async {
    if (record.id == null) return;

    await FocusRecordRepository.instance.delete(record.id!);

    records.removeWhere((e) => e.id == record.id);

    notifyListeners();
  }
}