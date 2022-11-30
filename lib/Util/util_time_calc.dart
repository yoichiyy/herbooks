class UtilTimeCalc {
  String fromAtNow(DateTime date) {
    final Duration difference = date.difference(DateTime.now());
    final int sec = difference.inSeconds;

    if (sec >= 60 * 60 * 24) {
      return '${difference.inDays.toString()} days';
    } else if (sec >= 60 * 60) {
      return '${difference.inHours.toString()} hours';
    } else if (sec >= 60) {
      return '${difference.inMinutes.toString()} minutes';
    } else if (sec >= 0) {
      return 'in $sec sec';
    } else {
      return "over due";
    }
  }
}
