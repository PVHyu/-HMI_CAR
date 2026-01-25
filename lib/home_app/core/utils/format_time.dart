class TimeUtils {
  static String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${d.inMinutes}:${twoDigits(d.inSeconds.remainder(60))}";
  }
}
