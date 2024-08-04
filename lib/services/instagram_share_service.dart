import 'package:url_launcher/url_launcher.dart';

class InstagramShareService {
  static Future<void> shareToStory(String imageUrl) async {
    final url = 'instagram-stories://share?source_application=your_app_id';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Instagram app is not installed';
    }
  }
}
