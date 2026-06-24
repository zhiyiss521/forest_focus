import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../../../model/FocusRecord.dart';
import '../../../repository/FocusRecordRepository.dart';

class TimelineProvider extends ChangeNotifier {

  bool loading = true;

  List<FocusRecord> records = [];

  Future<void> load() async {
    loading = true;
    notifyListeners();
    records = await FocusRecordRepository().findAll();
    loading = false;
    notifyListeners();
  }
}