import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

class KakaoShareService {
  static Future<void> shareMessage(String message) async {
    try {
      await ShareClient.instance.shareDefault(
        template: FeedTemplate(
          content: Content(
            title: 'Check this out!',
            description: message,
            imageUrl: Uri.parse('YOUR_IMAGE_URL'),
            link: Link(
              webUrl: Uri.parse('YOUR_WEB_URL'),
              mobileWebUrl: Uri.parse('YOUR_MOBILE_WEB_URL'),
            ),
          ),
        ),
      );
    } catch (error) {
      print('카카오톡 공유 실패: $error');
    }
  }
}
