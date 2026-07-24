class ActiveVideoManager {
  static Future<void> Function()? currentDispose;

  static Future<void> stopCurrentVideo() async {
    if (currentDispose != null) {
      final disposeFn = currentDispose;
      currentDispose = null;
      try {
        await disposeFn!();
      } catch (_) {}
    }
  }
}