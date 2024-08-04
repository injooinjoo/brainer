import 'package:flutter_sms/flutter_sms.dart';

class SmsShareService {
  static Future<void> sendSMS(
      {required String message, required List<String> recipients}) async {
    try {
      await sendSMS(message: message, recipients: recipients);
    } catch (error) {
      print('SMS 전송 실패: $error');
    }
  }
}
