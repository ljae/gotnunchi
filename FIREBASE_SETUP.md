# Firebase 설정 가이드

## 1. Firebase 프로젝트 생성

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. "프로젝트 추가" 클릭
3. 프로젝트 이름 입력 (예: gotnunchi)
4. Google Analytics 활성화 (선택사항)
5. 프로젝트 생성 완료

## 2. Flutter 앱에 Firebase 추가

### 방법 1: FlutterFire CLI (권장)

```bash
# Firebase CLI 설치
npm install -g firebase-tools

# Firebase 로그인
firebase login

# FlutterFire CLI 설치
dart pub global activate flutterfire_cli

# Firebase 프로젝트 연결
flutterfire configure
```

선택 옵션:
- 프로젝트 선택: 방금 생성한 프로젝트
- 플랫폼 선택: iOS, Android, macOS, Web (필요한 것 선택)
- 패키지 이름: com.example.gotnunchi (또는 원하는 이름)

이 명령어가 자동으로 생성하는 파일:
- `lib/firebase_options.dart` (자동 생성됨)
- iOS: `ios/Runner/GoogleService-Info.plist`
- Android: `android/app/google-services.json`

### 방법 2: 수동 설정

#### Android
1. Firebase Console에서 "Android 앱 추가"
2. 패키지 이름 입력: `com.example.gotnunchi`
3. `google-services.json` 다운로드
4. 파일을 `android/app/` 폴더에 복사

`android/build.gradle` 수정:
```gradle
buildscript {
    dependencies {
        // ...
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

`android/app/build.gradle` 수정:
```gradle
apply plugin: 'com.google.gms.google-services'
```

#### iOS
1. Firebase Console에서 "iOS 앱 추가"
2. 번들 ID 입력: `com.example.gotnunchi`
3. `GoogleService-Info.plist` 다운로드
4. Xcode에서 Runner 프로젝트에 파일 추가

#### macOS
1. Firebase Console에서 "macOS 앱 추가"
2. 번들 ID 입력: `com.example.gotnunchi`
3. `GoogleService-Info.plist` 다운로드
4. Xcode에서 Runner 프로젝트에 파일 추가
5. `macos/Runner/DebugProfile.entitlements` 수정:
```xml
<key>com.apple.security.network.client</key>
<true/>
```

## 3. Firebase 패키지 설치

```bash
flutter pub get
```

## 4. Firebase 서비스 활성화

### Authentication
1. Firebase Console > Authentication
2. "시작하기" 클릭
3. 로그인 방법 탭에서 "이메일/비밀번호" 활성화
4. (선택) Google 로그인도 활성화

### Firestore Database
1. Firebase Console > Firestore Database
2. "데이터베이스 만들기" 클릭
3. **테스트 모드**로 시작 (개발용)
4. 리전 선택: `asia-northeast3` (서울)

**주의**: 프로덕션에서는 보안 규칙을 반드시 설정해야 합니다!

### Storage (선택사항)
1. Firebase Console > Storage
2. "시작하기" 클릭
3. 테스트 모드로 시작
4. 리전 선택: `asia-northeast3`

## 5. Firestore 보안 규칙 (중요!)

개발 중에는 테스트 모드를 사용하지만, 배포 전 반드시 보안 규칙을 설정해야 합니다.

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Posts collection
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.resource.data.authorId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.authorId == request.auth.uid;
    }

    // Chat rooms
    match /chatRooms/{roomId} {
      allow read, write: if request.auth != null &&
        request.auth.uid in resource.data.participants;
    }

    // Messages (auto-delete after 72 hours)
    match /chatRooms/{roomId}/messages/{messageId} {
      allow read: if request.auth != null &&
        request.auth.uid in get(/databases/$(database)/documents/chatRooms/$(roomId)).data.participants;
      allow create: if request.auth != null &&
        request.auth.uid in get(/databases/$(database)/documents/chatRooms/$(roomId)).data.participants &&
        request.resource.data.expiresAt == request.time + duration.value(72, 'h');
      allow delete: if request.auth != null;
    }
  }
}
```

## 6. 앱 실행

```bash
flutter run
```

## 7. 문제 해결

### iOS 빌드 오류
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
```

### Android 빌드 오류
- `android/app/build.gradle`에서 minSdkVersion을 21 이상으로 설정
- `android/gradle.properties`에 추가:
```
android.useAndroidX=true
android.enableJetifier=true
```

### macOS 권한 오류
`macos/Runner/DebugProfile.entitlements`와 `Release.entitlements`에 네트워크 권한 추가

## 8. Cloud Functions (72시간 자동 삭제)

나중에 Cloud Functions를 사용해서 만료된 메시지를 자동 삭제할 수 있습니다.

```bash
firebase init functions
```

`functions/index.js`:
```javascript
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// 매일 자정에 실행
exports.cleanupExpiredMessages = functions.pubsub
  .schedule('0 0 * * *')
  .timeZone('Asia/Seoul')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();
    const db = admin.firestore();

    // 모든 채팅방의 만료된 메시지 삭제
    const roomsSnapshot = await db.collection('chatRooms').get();

    for (const roomDoc of roomsSnapshot.docs) {
      const messagesRef = roomDoc.ref.collection('messages');
      const expiredMessages = await messagesRef
        .where('expiresAt', '<=', now)
        .get();

      const batch = db.batch();
      expiredMessages.docs.forEach(doc => {
        batch.delete(doc.ref);
      });

      await batch.commit();
      console.log(`Deleted ${expiredMessages.size} expired messages from ${roomDoc.id}`);
    }

    return null;
  });
```

배포:
```bash
firebase deploy --only functions
```

## 완료!

이제 앱에서 Firebase를 사용할 수 있습니다. 🎉
