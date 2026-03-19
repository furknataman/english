import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewHelper {
  static const String _launchCountKey = 'review_launch_count';
  static const String _lastReviewKey = 'review_last_shown';
  static const int _launchThreshold = 5; // Her 5 kullanımda bir sor

  static Future<void> incrementAndCheck() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(_launchCountKey) ?? 0;
    count++;
    await prefs.setInt(_launchCountKey, count);

    if (count % _launchThreshold == 0) {
      final lastShown = prefs.getInt(_lastReviewKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      final daysSinceLastReview = (now - lastShown) / (1000 * 60 * 60 * 24);

      // En az 30 gün arayla sor
      if (daysSinceLastReview > 30) {
        await _requestReview();
        await prefs.setInt(_lastReviewKey, now);
      }
    }
  }

  static Future<void> _requestReview() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    }
  }

  /// Quiz veya Flashcard bitince çağır
  static Future<void> checkAfterStudy() async {
    await incrementAndCheck();
  }
}
