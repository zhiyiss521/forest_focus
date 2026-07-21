extension DurationExtension on Duration {

  String get mmss {
    final minutes = inSeconds ~/ 60;
    final seconds = inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';

  }

  String get mm {
    final minutes = inSeconds ~/ 60;
    return '${minutes.toString().padLeft(2, '0')}';
  }

}

extension FocusTimeExtension on int {
  String get focusDuration {
    final duration = Duration(seconds: this);

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return "${hours}小时${minutes}分钟";
    }

    if (minutes > 0) {
      return "${minutes}分钟";
    }

    return "${seconds}秒";
  }
}