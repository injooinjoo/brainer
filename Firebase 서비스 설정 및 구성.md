# Firebase 서비스 설정 및 구성

## 1. Firebase 프로젝트 생성
1. Firebase 콘솔(console.firebase.google.com)에 접속
2. '프로젝트 추가' 클릭
3. 프로젝트 이름 입력 (예: "LearningApp")
4. Google Analytics 설정 (권장)
5. 프로젝트 생성 완료

## 2. iOS 앱 등록
1. Firebase 콘솔에서 iOS 앱 추가
2. iOS 번들 ID 입력
3. 구성 파일(GoogleService-Info.plist) 다운로드 및 Xcode 프로젝트에 추가
4. Firebase SDK 설치 (CocoaPods 사용 권장)

## 3. 웹 앱 등록
1. Firebase 콘솔에서 웹 앱 추가
2. 앱 닉네임 입력
3. Firebase 구성 객체 복사 및 웹 프로젝트에 추가

## 4. Authentication 설정
1. Firebase 콘솔의 'Authentication' 섹션으로 이동
2. '시작하기' 클릭
3. 이메일/비밀번호 로그인 활성화
4. (선택적) 소셜 로그인 제공업체 설정

## 5. Firestore 데이터베이스 설정
1. Firebase 콘솔의 'Firestore Database' 섹션으로 이동
2. '데이터베이스 만들기' 클릭
3. 보안 규칙 설정 (초기에는 테스트 모드로 시작)

## 6. Realtime Database 설정
1. Firebase 콘솔의 'Realtime Database' 섹션으로 이동
2. '데이터베이스 만들기' 클릭
3. 보안 규칙 설정 (초기에는 테스트 모드로 시작)

## 7. Cloud Functions 설정
1. Firebase CLI 설치: `npm install -g firebase-tools`
2. 프로젝트 디렉토리에서 `firebase init functions` 실행
3. 프로젝트 선택 및 언어 선택 (JavaScript 또는 TypeScript)

## 8. Firebase Hosting 설정
1. Firebase 콘솔의 'Hosting' 섹션으로 이동
2. '시작하기' 클릭
3. Firebase CLI를 사용하여 `firebase init hosting` 실행

## 9. Cloud Messaging 설정
1. Firebase 콘솔의 'Cloud Messaging' 섹션으로 이동
2. iOS 앱의 경우 APNs 인증 키 추가
3. 웹 앱의 경우 웹 푸시 인증서 생성

## 10. 보안 규칙 설정
1. Firestore 및 Realtime Database의 보안 규칙 설정
2. 초기에는 테스트를 위해 모든 읽기/쓰기 허용, 후에 제한적으로 변경
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 11. Firebase 구성 파일 관리
1. iOS: GoogleService-Info.plist 파일을 .gitignore에 추가
2. 웹: Firebase 구성 객체를 환경 변수로 관리

## 12. Firebase SDK 초기화
iOS (Swift):
```swift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
```

웹 (JavaScript):
```javascript
import { initializeApp } from "firebase/app";

const firebaseConfig = {
  // Your web app's Firebase configuration
};

const app = initializeApp(firebaseConfig);
```