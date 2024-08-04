import 'package:url_launcher/url_launcher.dart';

class LineShareService {
  static Future<void> shareMessage(String message) async {
    final encodedMessage = Uri.encodeComponent(message);
    final lineUrl =
        'https://social-plugins.line.me/lineit/share?text=$encodedMessage';

    if (await canLaunch(lineUrl)) {
      await launch(lineUrl);
    } else {
      throw 'Could not launch $lineUrl';
    }
  }
}
