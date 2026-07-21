import 'package:flutter/cupertino.dart';

import '../../../core/repository/focus_record_repository.dart';
import '../../../model/focus_record.dart';

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
}