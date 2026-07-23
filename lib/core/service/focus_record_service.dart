import '../../model/focus_record.dart';
import '../repository/focus_record_repository.dart';

class FocusRecordService {
  FocusRecordService._();
  static final instance = FocusRecordService._();

  Future<int> insert(FocusRecord record) => FocusRecordRepository.instance.insert(record);

  Future<int> update(FocusRecord record) => FocusRecordRepository.instance.update(record);

  Future<int> delete(int id) => FocusRecordRepository.instance.delete(id);

  Future<void> deleteAll() => FocusRecordRepository.instance.deleteAll();

  Future<FocusRecord?> findById(int id) => FocusRecordRepository.instance.findById(id);

  Future<List<FocusRecord>> findAll() => FocusRecordRepository.instance.findAll();

  Future<List<FocusRecord>> findByDateRange({required DateTime start, required DateTime end}) {
    return FocusRecordRepository.instance.findByDateRange(start: start, end: end);
  }

  Future<List<FocusRecord>> _records({DateTime? start, DateTime? end}) {
    if (start != null && end != null) {
      return findByDateRange(start: start, end: end);
    }
    return findAll();
  }

  Future<int> getRecordCount({DateTime? start, DateTime? end}) async {
    return (await _records(start: start, end: end)).length;
  }

  Future<int> getCompletedCount({DateTime? start, DateTime? end}) async {
    return (await _records(start: start, end: end)).where((e) => e.completed).length;
  }

  Future<int> getFailedCount({DateTime? start, DateTime? end}) async {
    return (await _records(start: start, end: end)).where((e) => !e.completed).length;
  }

  // Future<int> getTotalFocusSeconds({DateTime? start, DateTime? end}) async {
  //   return (await _records(start: start, end: end)).where((e) => e.completed).fold(0, (sum, e) => sum + e.actualSeconds);
  // }

  Future<int> getAverageFocusSeconds({DateTime? start, DateTime? end}) async {
    final records = (await _records(start: start, end: end)).where((e) => e.completed).toList();
    if (records.isEmpty) return 0;
    return records.fold(0, (sum, e) => sum + e.actualSeconds) ~/ records.length;
  }

  Future<double> getCompletionRate({DateTime? start, DateTime? end}) async {
    final records = await _records(start: start, end: end);
    if (records.isEmpty) return 0;
    return records.where((e) => e.completed).length / records.length;
  }
}