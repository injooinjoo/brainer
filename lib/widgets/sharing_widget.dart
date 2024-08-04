import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../services/facebook_share_service.dart';
import '../services/twitter_share_service.dart';
import '../services/kakao_share_service.dart';
import '../services/line_share_service.dart';
import '../services/instagram_share_service.dart';
import '../services/email_share_service.dart';

class SharingWidget extends StatelessWidget {
  final String content;
  final String url;

  const SharingWidget({
    Key? key,
    required this.content,
    required this.url,
  }) : super(key: key);

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.share),
              title: Text('일반 공유'),
              onTap: () {
                Share.share('$content\n$url');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.facebook),
              title: Text('Facebook에 공유'),
              onTap: () {
                FacebookShareService.shareContent(content, url);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.flutter_dash),
              title: Text('Twitter에 공유'),
              onTap: () {
                TwitterShareService.shareContent(content, url);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.chat_bubble),
              title: Text('카카오톡에 공유'),
              onTap: () {
                KakaoShareService.shareMessage(content);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.linear_scale),
              title: Text('LINE에 공유'),
              onTap: () {
                LineShareService.shareMessage(content);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Instagram에 공유'),
              onTap: () {
                InstagramShareService.shareToStory(url); // Instagram에 공유
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('이메일로 공유'),
              onTap: () {
                _sendEmail(context); // 이메일 전송 다이얼로그 호출
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _sendEmail(BuildContext context) {
    final subjectController = TextEditingController();
    final bodyController = TextEditingController();
    final recipientsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('이메일 보내기'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: InputDecoration(labelText: '제목'),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: '내용'),
                maxLines: 3,
              ),
              TextField(
                controller: recipientsController,
                decoration: InputDecoration(labelText: '수신자 (쉼표로 구분)'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final subject = subjectController.text;
                final body = bodyController.text;
                final recipients = recipientsController.text.split(',');

                EmailShareService.sendEmail(subject, body, recipients);
                Navigator.pop(context);
              },
              child: Text('보내기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.share),
      onPressed: () => _showShareOptions(context),
    );
  }
}
