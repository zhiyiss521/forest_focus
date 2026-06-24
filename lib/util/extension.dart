extension DurationExtension on Duration {

  String get mmss {
    final minutes = inSeconds ~/ 60;
    final seconds = inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';

  }
}