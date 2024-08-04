import 'package:url_launcher/url_launcher.dart';

class LinkedInShareService {
  static Future<void> shareContent(String url) async {
    final encodedUrl = Uri.encodeFull(url);
    final linkedInUrl =
        'https://www.linkedin.com/sharing/share-offsite/?url=$encodedUrl';

    if (await canLaunch(linkedInUrl)) {
      await launch(linkedInUrl);
    } else {
      throw 'Could not launch $linkedInUrl';
    }
  }
}
