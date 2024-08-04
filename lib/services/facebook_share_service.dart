import 'package:url_launcher/url_launcher.dart';

class FacebookShareService {
  static Future<void> shareContent(String message, String url) async {
    final encodedMessage = Uri.encodeComponent(message);
    final encodedUrl = Uri.encodeComponent(url);
    final fbUrl =
        'https://www.facebook.com/sharer/sharer.php?u=$encodedUrl&quote=$encodedMessage';

    if (await canLaunch(fbUrl)) {
      await launch(fbUrl);
    } else {
      throw 'Could not launch $fbUrl';
    }
  }
}
