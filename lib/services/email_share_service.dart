import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailShareService {
  static Future<void> sendEmail(
      String subject, String body, List<String> recipients) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: recipients,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('이메일 전송 실패: $error');
    }
  }
}
