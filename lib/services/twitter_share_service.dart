import 'package:twitter_login/twitter_login.dart';
import 'package:url_launcher/url_launcher.dart';

class TwitterShareService {
  static Future<void> shareContent(String message, String url) async {
    final twitterUrl =
        'https://twitter.com/intent/tweet?text=${Uri.encodeFull(message)}&url=${Uri.encodeFull(url)}';

    if (await canLaunch(twitterUrl)) {
      await launch(twitterUrl);
    } else {
      throw 'Could not launch $twitterUrl';
    }
  }
}
