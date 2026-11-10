// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get commonCancel => '취소';

  @override
  String get commonOk => '확인';

  @override
  String get commonRemove => '제거';

  @override
  String get commonUnlock => '잠금 해제';

  @override
  String get commonTurnOff => '끄기';

  @override
  String get commonNotNow => '나중에';

  @override
  String get commonNext => '다음';

  @override
  String get commonDone => '완료';

  @override
  String get commonDeny => '거부';

  @override
  String get commonAllow => '허용';

  @override
  String get commonTryAgain => '다시 시도';

  @override
  String get commonStop => '중지';

  @override
  String get commonShare => '공유';

  @override
  String get commonOpen => '열기';

  @override
  String get commonCopy => '복사';

  @override
  String get commonContinueLabel => '계속';

  @override
  String get commonClear => '지우기';

  @override
  String get commonBack => '뒤로';

  @override
  String get commonAdd => '추가';

  @override
  String get commonSave => '저장';

  @override
  String get commonDelete => '삭제';

  @override
  String get commonClose => '닫기';

  @override
  String get commonEdit => '편집';

  @override
  String get commonYes => '예';

  @override
  String get commonNo => '아니요';

  @override
  String get commonSeePremium => 'Premium 보기';

  @override
  String get commonPremiumBadge => 'Premium';

  @override
  String get commonAppName => 'Tanooki Auth';

  @override
  String get googleMigrationUnreadable =>
      '이 Google Authenticator 코드를 읽을 수 없어요.';

  @override
  String get googleMigrationDamaged => '이 Google Authenticator 코드가 손상되었어요.';

  @override
  String get googleMigrationEmpty => '이 Google Authenticator 코드에는 계정이 없어요.';

  @override
  String get googleMigrationNoSecret => '이 코드에 비밀 키가 없는 계정이 있어요.';

  @override
  String get googleMigrationMd5 =>
      '이 코드에 MD5를 쓰는 계정이 있는데, Tanooki Auth는 MD5를 지원하지 않아요.';

  @override
  String get googleCantTakeSteam => 'Steam 코드';

  @override
  String googleCantTakeDigits(int digits) {
    return '$digits자리 코드';
  }

  @override
  String googleCantTakePeriod(int seconds) {
    return '$seconds초마다 바뀌는 코드';
  }

  @override
  String get otpauthNotALink => 'otpauth:// 링크가 아니에요.';

  @override
  String get otpauthNoSecret => '링크에 비밀 키가 없어요.';

  @override
  String otpauthUnsupportedType(String type) {
    return '지원하지 않는 코드 유형이에요: \"$type\"';
  }

  @override
  String otpauthUnsupportedAlgorithm(String algorithm) {
    return '지원하지 않는 알고리즘이에요: \"$algorithm\"';
  }

  @override
  String get otpauthBadDigits => '자릿수는 6, 7, 8 중 하나여야 해요.';

  @override
  String get otpauthBadPeriod => '주기는 0보다 큰 숫자여야 해요.';

  @override
  String get otpauthBadCounter => '카운터는 0 이상이어야 해요.';

  @override
  String get phoneLinkNotAPairingCode => 'Tanooki Auth 브라우저 연결 코드가 아니에요.';

  @override
  String phoneLinkNotSavedFor(String host) {
    return '이 계정은 $host용으로 저장되어 있지 않아요.';
  }

  @override
  String get phoneLinkPushNotSetUp =>
      'Tanooki Auth 서버에 아직 알림이 설정되지 않아서, 앱이 열려 있을 때만 요청이 표시돼요.';

  @override
  String phoneLinkPushFailed(int status) {
    return '알림을 켤 수 없어요 (HTTP $status).';
  }

  @override
  String get qrImageNotAPicture => '이 앱에서 읽을 수 있는 사진 파일이 아니에요.';

  @override
  String get qrImageNoQr => '사진에서 QR 코드를 찾지 못했어요.';

  @override
  String relayBadAnswer(int status) {
    return '동기화 서버가 앱이 이해할 수 없는 응답을 보냈어요 (HTTP $status).';
  }

  @override
  String get relayUnreachable => '동기화 서버에 연결할 수 없어요. 인터넷 연결을 확인해 주세요.';

  @override
  String get relayTimeout => '동기화 서버가 제때 응답하지 않았어요. 인터넷 연결을 확인해 주세요.';

  @override
  String get relayInsecure => '동기화 서버와 보안 연결을 만들 수 없어요.';

  @override
  String relaySaidNo(int status) {
    return '동기화 서버가 요청을 거부했어요 (HTTP $status).';
  }

  @override
  String get shareNotAShare => 'Tanooki Auth로 공유된 계정이 아니에요.';

  @override
  String get shareExpired => '이 공유는 만료되었어요 (24시간 동안만 유효해요). 새로 공유해 달라고 요청하세요.';

  @override
  String get shareWrongCode => '코드가 틀렸거나 공유가 손상되었어요. 6자리 숫자를 확인하고 다시 시도해 주세요.';

  @override
  String get storeServerUnreachable =>
      'Tanooki Auth 서버에 연결할 수 없어요. 인터넷 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get storeBadKey => '서버가 이 앱에서 받을 수 없는 라이선스 키를 보냈어요.';

  @override
  String storeReportedProblem(String problem) {
    return '스토어에서 문제를 알려 왔어요: $problem';
  }

  @override
  String get storeGooglePlayUnavailable =>
      '이 기기에서는 Google Play를 쓸 수 없어서 여기서 Premium을 구매할 수 없어요. 다른 곳에서 Premium을 구매했다면 아래에 라이선스 키를 입력하세요.';

  @override
  String get storeAppStoreUnavailable =>
      '지금은 App Store를 사용할 수 없어요. 인터넷 연결을 확인하고 다시 시도해 주세요.';

  @override
  String storeNotListed(String store) {
    return '$store에서 지금 Premium을 불러오지 못했어요. 잠시 후 다시 시도해 주세요.';
  }

  @override
  String storeNotListedWithError(String store, String problem) {
    return '$store에서 지금 Premium을 불러오지 못했어요 ($problem). 잠시 후 다시 시도해 주세요.';
  }

  @override
  String storePricesFailed(String problem) {
    return '스토어에서 가격을 불러오지 못했어요: $problem';
  }

  @override
  String storePurchaseCouldNotStart(String problem) {
    return '구매를 시작할 수 없어요: $problem';
  }

  @override
  String storeNothingToRestore(String store) {
    return '이 $store 계정으로 구매한 Premium을 찾지 못했어요.';
  }

  @override
  String storeRestoreFailed(String problem) {
    return '구매 항목을 복원하지 못했어요: $problem';
  }

  @override
  String get storePending => '결제 승인을 기다리고 있어요. 승인되면 바로 Premium이 잠금 해제돼요.';

  @override
  String get storeCanceled => '구매가 취소되었어요. 요금은 청구되지 않았어요.';

  @override
  String storeFailed(String problem) {
    return '구매가 완료되지 않았어요: $problem. 요금은 청구되지 않았어요.';
  }

  @override
  String get storeFailedNoReason =>
      '구매가 완료되지 않았어요. 스토어에서 이유를 알려 주지 않았어요. 요금은 청구되지 않았어요.';

  @override
  String get storeUnlocked => 'Premium이 잠금 해제되었어요. 정말 고마워요!';

  @override
  String get storeUnlockedWithKey =>
      'Premium이 잠금 해제되었어요. 컴퓨터에서 쓸 라이선스 키는 아래에 있어요.';

  @override
  String storeUnlockedKeyFailed(String problem) {
    return '이 기기에서 Premium이 잠금 해제되었어요. 컴퓨터용 키는 아직 만들지 못했어요: $problem 나중에 \'구매 항목 복원\'을 탭해서 다시 시도해 주세요.';
  }

  @override
  String storeServerSaidNo(int status) {
    return '서버가 요청을 거부했어요 (HTTP $status).';
  }

  @override
  String get syncGroupExists =>
      '이 암호 문구를 쓰는 동기화 그룹이 이미 있어요. 이미 동기화 중인 기기에서 \"기기 추가\"를 탭하고 그 코드를 대신 스캔하세요.';

  @override
  String get syncNotASyncCode =>
      'Tanooki Auth 동기화 코드가 아니에요. 이미 동기화 중인 기기에서 설정 > 동기화 > 기기 추가를 여세요.';

  @override
  String get syncWrongPassphrase =>
      '다른 기기에서 쓰는 암호 문구와 맞지 않아요. 확인하고 다시 시도해 주세요.';

  @override
  String get syncICloudOtherPassphrase =>
      '다른 Apple 기기는 다른 암호 문구로 동기화하고 있어요. 그 암호 문구를 입력하거나, 이 암호 문구로 새로 시작하세요.';

  @override
  String get syncErrorRemoved =>
      '다른 기기에서 이 기기를 동기화에서 제거했어요. 다시 참여하려면 동기화를 껐다가 다시 켜세요.';

  @override
  String get syncErrorTurnedOff =>
      '다른 기기에서 동기화를 껐어요. 여기서도 끈 다음 다시 켜서 새로 시작하세요.';

  @override
  String get syncErrorTooOften => '동기화를 너무 자주 하고 있어요. 몇 분 뒤에 다시 시도할게요.';

  @override
  String get syncErrorLimit => '동기화 한도(삭제한 계정 포함 2,000개)에 도달했어요.';

  @override
  String syncErrorICloud(String problem) {
    return 'iCloud Drive에 문제가 생겼어요: $problem.';
  }

  @override
  String syncErrorUnexpected(String problem) {
    return '예상치 못한 문제로 동기화가 멈췄어요: $problem';
  }

  @override
  String get syncICloudAppleOnly => 'iCloud는 iPhone, iPad, Mac에서만 쓸 수 있어요.';

  @override
  String get syncICloudSignedOut =>
      '이 기기에서 iCloud Drive가 꺼져 있어요. 사용하려면 설정에서 iCloud에 로그인하고 iCloud Drive를 켜세요.';

  @override
  String get syncICloudNotInBuild =>
      '이 버전의 Tanooki Auth에서는 아직 iCloud 동기화가 켜져 있지 않아요. 지금은 Tanooki 릴레이를 사용하세요. 모든 기기에서 작동해요.';

  @override
  String get teamKeyUnopenable =>
      '이 기기로 보낸 팀 키를 열 수 없어요. 팀 관리자에게 이 기기를 제거하고 다시 초대해 달라고 요청하세요.';

  @override
  String get teamNotAnInvite =>
      'Tanooki Auth 팀 초대가 아니에요. 팀 관리자에게 새 초대 링크나 QR 코드를 요청하세요.';

  @override
  String get teamNotInTeam => '이 기기는 팀에 속해 있지 않아요.';

  @override
  String get teamDeletedByAdmin => '관리자가 이 팀을 삭제했어요.';

  @override
  String get teamDeviceRemoved => '이 기기가 팀에서 제거되었어요.';

  @override
  String get teamAlreadyInTeam => '이 기기는 이미 팀에 속해 있어요.';

  @override
  String get teamNotALicense =>
      '팀 라이선스가 아니에요. 팀 라이선스는 TT1.로 시작하고, 구독한 뒤 Stripe가 보여 주는 페이지에서 받을 수 있어요.';

  @override
  String get teamAlreadyInTeamLeaveFirst => '이 기기는 이미 팀에 속해 있어요. 먼저 팀에서 나가세요.';

  @override
  String get teamGone => '그 팀은 더 이상 없어요. 팀 관리자에게 새 초대를 요청하세요.';

  @override
  String get teamInviteUsed =>
      '이미 사용했거나 만료된 초대예요 (초대는 7일 동안 한 번만 쓸 수 있어요). 팀 관리자에게 새 초대를 요청하세요.';

  @override
  String get teamFull => '팀이 가득 찼어요 (10명). 관리자가 먼저 누군가를 제거해야 해요.';

  @override
  String get aboutTitle => 'Maddie 소개';

  @override
  String get aboutP1 =>
      '저는 Maddie예요. 작은 부분까지 제대로 만드는 데 마음을 쓰는, 어쩌면 조금 지나치게 신경 쓰는 자폐인 개발자예요.';

  @override
  String get aboutP2 =>
      '저는 개인정보 보호가 정말 중요하다고 믿어요. 계정을 지켜 주는 키는 가장 개인적인 데이터라서, Tanooki Auth는 이 키를 내 기기에 암호화해서 보관해요. 회원 가입도, 광고도, 추적도 없고, 저에게 전송되는 것도 전혀 없어요.';

  @override
  String get aboutP3 =>
      'Tanooki Auth는 무료이고, 앞으로도 무료로 두고 싶어요. 여러분의 후원 덕분에 이런 무료 개인정보 보호 앱을 계속 만들 수 있어요. Tanooki Auth가 마음에 든다면 다른 앱도 마음에 드실 거예요. madilynthomas.com에 있어요.';

  @override
  String get aboutP4 =>
      '그래서 진심을 담아 말할게요. 고마워요. 여러분은 그냥 앱을 쓰는 게 아니라, 이런 삶의 방식 전체를 가능하게 해 주고 있어요.';

  @override
  String get aboutSupportAddress => '후원하기: tanookistudios.com/support';

  @override
  String get aboutSupport => '후원하기';

  @override
  String get aboutCredits => '크레딧';

  @override
  String get aboutCreditsBody =>
      'QR 코드는 브라우저 확장 프로그램에서는 jsQR(Apache 2.0)로, 앱에서는 ZXing으로 읽어요. Google, Twilio, Authy와는 관련이 없어요. Google Authenticator는 Google LLC의 상표예요.';

  @override
  String get addFromBrowserOne => '브라우저에서 추가할까요?';

  @override
  String addFromBrowserMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '브라우저에서 계정 $count개를 추가할까요?',
    );
    return '$_temp0';
  }

  @override
  String get addFromGoogleTransfer => 'Google Authenticator 내보내기 코드에서:';

  @override
  String addCount(int count) {
    return '$count개 추가';
  }

  @override
  String get addNoColor => '색상 없음';

  @override
  String addColorName(String name) {
    return '$name 색상';
  }

  @override
  String get addServiceLabel => '서비스 (예: GitHub)';

  @override
  String get addAccountLabel => '계정 (예: 이메일 주소)';

  @override
  String get addWebsiteLabel => '웹사이트 (선택)';

  @override
  String get addWebsiteHelp => '예: github.com. 브라우저 확장 프로그램은 이 사이트에서만 코드를 채워요.';

  @override
  String get addTagsLabel => '태그 (선택)';

  @override
  String get addTagsHelp => '예: 업무, 게임. 쉼표로 구분하세요.';

  @override
  String get addFolderLabel => '폴더 (선택)';

  @override
  String get addFolderHelp => '예: 업무. 폴더에 넣지 않으려면 비워 두세요.';

  @override
  String get addPickFolder => '폴더 선택';

  @override
  String get addNoFolder => '폴더 없음';

  @override
  String get addNotesLabel => '메모 (선택)';

  @override
  String get addColorLabel => '색상 (선택)';

  @override
  String get addEmojiLabel => '이모지 (선택)';

  @override
  String get addEmojiHelp => '여기와 위젯, 워치에서 로고 대신 표시돼요.';

  @override
  String addUseEmoji(String emoji) {
    return '$emoji 사용';
  }

  @override
  String addRequireAuth(String proof) {
    return '이 코드를 보여 주기 전에 $proof 요구';
  }

  @override
  String get addRequireAuthHelp =>
      '목록에서 코드가 숨겨지고, 위젯, 워치, 빠른 선택에서는 절대 표시되지 않아요.';

  @override
  String get addTravelHide => '여행 모드에서 숨기기';

  @override
  String get addTravelHidePremium => '여행 모드에서 숨기기 (Premium)';

  @override
  String get addTravelHideHelp =>
      '여행 모드가 켜져 있으면(설정) 이 계정이 앱에서 사라지고, 끄면 다시 나타나요.';

  @override
  String get addTravelNeedsPremium =>
      '여행 모드는 Premium 기능이에요. 설정 > Premium 받기에서 받을 수 있어요.';

  @override
  String get addAdvanced => '고급';

  @override
  String get addAdvancedExisting =>
      '웹사이트에서 바꾸라고 안내한 경우에만 바꾸세요. 설정이 틀리면 코드도 틀리고, 웹사이트에서 거부해요.';

  @override
  String get addAdvancedNew =>
      '대부분의 웹사이트는 기본 설정을 써요. 웹사이트에서 바꾸라고 안내한 경우에만 바꾸세요.';

  @override
  String get addType => '유형';

  @override
  String get addTypeTotp => '시간 기반 (기본)';

  @override
  String get addTypeHotp => '카운터 기반 (요청할 때 새 코드)';

  @override
  String get addDigits => '자릿수';

  @override
  String get addAlgorithm => '알고리즘';

  @override
  String get addSha1Normal => 'SHA-1 (기본)';

  @override
  String get addPeriod => '새 코드 주기';

  @override
  String addSeconds(int seconds) {
    return '$seconds초';
  }

  @override
  String get addCounter => '카운터';

  @override
  String get addCounterHelp => '지금까지 사용한 코드 개수';

  @override
  String get addNotASharedFile =>
      'Tanooki Auth로 공유된 계정 파일이 아니에요. 보낸 사람에게 다시 공유해 달라고 요청하세요.';

  @override
  String addAlreadyInList(String name) {
    return '$name은(는) 이미 목록에 있어요.';
  }

  @override
  String get addThisAccount => '이 계정을 추가할까요?';

  @override
  String get addNoCameraWindows =>
      'Windows에서는 Tanooki Auth가 카메라를 쓸 수 없어요. 대신 QR 코드 사진을 열거나 설정 링크를 붙여 넣으세요.';

  @override
  String get addFromGoogle => 'Google Authenticator에서 옮기기';

  @override
  String get addFromGoogleSteps =>
      'Google Authenticator가 있는 기기에서:\n\n1. Google Authenticator를 여세요.\n2. 메뉴(☰ 또는 ⋮)를 탭하고 \"계정 이전\", \"계정 내보내기\"를 차례로 탭하세요.\n3. 계정을 선택하고 \'다음\'을 탭하면 QR 코드가 표시돼요.\n\n그다음 여기서 그 QR 코드를 스캔하세요. QR 코드가 여러 개 표시되면 하나씩 모두 스캔하세요.';

  @override
  String get addScan => '스캔';

  @override
  String get addOpenPicture => '사진 열기';

  @override
  String get addLookingOnScreen => '화면에서 QR 코드를 찾고 있어요…';

  @override
  String get addScreenNoQr =>
      '화면에서 QR 코드를 찾지 못했어요. 코드 전체가 보이고 다른 창에 가려지지 않았는지 확인한 다음 다시 시도해 주세요.';

  @override
  String get addScreenUnsupported =>
      '화면 스캔은 macOS 14(Sonoma) 이상이 필요해요. 스크린샷을 찍고 \"QR 코드 사진 열기\"를 대신 사용하세요.';

  @override
  String get addScreenFailed =>
      '화면을 캡처하지 못했어요. 스크린샷을 찍고 \"QR 코드 사진 열기\"를 대신 사용하세요.';

  @override
  String get addScreenWrongQr => '화면에서 QR 코드를 찾았지만, 2단계 인증 설정 코드가 아니에요.';

  @override
  String get addScreenPermissionTitle => 'Tanooki Auth가 화면을 볼 수 있게 허용하기';

  @override
  String get addScreenPermissionSteps =>
      '화면에서 QR 코드를 읽으려면 Mac에서 Tanooki Auth가 화면을 캡처할 수 있게 허용해야 해요. Tanooki Auth는 \"내 화면 스캔\"을 눌렀을 때만 화면을 보고, 캡처한 이미지는 이 Mac 밖으로 나가지 않아요.\n\n1. 시스템 설정을 여세요 (Dock의 톱니바퀴 아이콘, 또는 Apple 메뉴 > 시스템 설정).\n2. 왼쪽 목록에서 \"개인정보 보호 및 보안\"을 클릭하세요.\n3. \"화면 및 시스템 오디오 녹음\"을 클릭하세요.\n4. Tanooki Auth 옆의 스위치를 켜세요. 목록에 없으면 +를 클릭하고 응용 프로그램에서 Tanooki Auth를 선택한 다음 켜세요.\n5. Mac에서 Tanooki Auth를 종료하라고 물어봐요. \"종료 후 다시 열기\"를 클릭한 다음 \"내 화면 스캔\"을 다시 누르세요.';

  @override
  String get addPasteLinksTitle => '설정 링크 붙여 넣기';

  @override
  String get addPasteLinksHint =>
      'otpauth://totp/...\n한 줄에 링크 하나씩. 여러 개를 한 번에 붙여 넣을 수 있어요.';

  @override
  String addManyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개를 추가할까요?',
    );
    return '$_temp0';
  }

  @override
  String addManyBadLines(int count) {
    return '$count줄은 사용할 수 없어요. 어떤 줄인지는 나중에 보여 드릴게요.';
  }

  @override
  String get addEnterKey => '설정 키 입력';

  @override
  String get addSetupKey => '설정 키';

  @override
  String get addSetupKeyHelp => '웹사이트에 표시된 문자와 숫자';

  @override
  String get addBadKey => '올바른 설정 키가 아니에요. A–Z 문자와 2–7 숫자만 들어 있어야 해요.';

  @override
  String get addTitle => '계정 추가';

  @override
  String get addScanQr => 'QR 코드 스캔';

  @override
  String get addScanQrHelp => '웹사이트에 표시된 코드에 카메라를 맞추세요';

  @override
  String addNoCameraOn(String platform) {
    return '$platform에서는 카메라를 지원하지 않아요';
  }

  @override
  String get addScanScreen => '내 화면 스캔';

  @override
  String get addScanScreenHelp => '화면 어디에 있든 QR 코드를 읽어요';

  @override
  String get addScanScreenLinux => 'Linux에서는 아직 쓸 수 없어요. 대신 QR 코드 스크린샷을 여세요.';

  @override
  String get addFromPhotos => '사진에서 QR 코드 스캔';

  @override
  String get addFromPicture => 'QR 코드 사진 열기';

  @override
  String get addFromPhotosHelp => '설정 페이지의 스크린샷을 선택하세요';

  @override
  String get addFromPictureHelp => '설정 페이지의 스크린샷도 돼요';

  @override
  String get addPasteLink => '설정 링크 붙여 넣기';

  @override
  String get addPasteLinkHelp => 'otpauth://로 시작하는 링크, 하나 또는 여러 개';

  @override
  String get addOpenShared => '공유된 계정 열기';

  @override
  String addOpenSharedHelp(String extension) {
    return '누군가 보내 준 .$extension 파일';
  }

  @override
  String get addFromGoogleHelp => '모든 계정을 한 번에 가져와요';

  @override
  String get addFromOtherApp => '다른 앱에서 옮기기';

  @override
  String get addFromOtherAppHelp =>
      'Aegis, 2FAS, Authy, Bitwarden, 1Password, Apple 암호, Microsoft';

  @override
  String get addEnterKeyHelp => '\"코드를 스캔할 수 없나요?\" 아래에 표시된 키를 입력하세요';

  @override
  String get addWrongQr => '2단계 인증 설정용 QR 코드가 아니에요.';

  @override
  String get addCameraDenied =>
      'Tanooki Auth가 카메라를 사용할 수 없어요. 기기의 설정에서 Tanooki Auth의 카메라 접근을 켜거나, 뒤로 가서 사진이나 설정 키를 대신 사용하세요.';

  @override
  String addCameraFailed(String problem) {
    return '카메라를 시작할 수 없어요 ($problem). 뒤로 가서 사진이나 설정 키를 대신 사용하세요.';
  }

  @override
  String get helpNew030a =>
      '인기 사이트 40곳에서 2FA를 켜는 단계별 가이드. 가이드가 있는 계정을 추가하거나 편집하면 가이드 링크가 표시돼요.';

  @override
  String get helpNew030b => '앱을 처음 열 때 보여 주는 짧은 환영 투어. 설정 > 도움말에서 다시 볼 수 있어요.';

  @override
  String get helpNew030c => '설정 > 도움말에서 의견을 보낼 수 있어요. 계정이나 코드는 절대 포함되지 않아요.';

  @override
  String get helpNew030d => '지금 보고 있는 \'새로운 기능\' 페이지.';

  @override
  String get helpNew030e =>
      'Apple 암호에서 가져오기, 그리고 Aegis, 2FAS, Google Authenticator로 계정 옮기기.';

  @override
  String get helpNew030f =>
      'Steam Guard 코드, \"다음 코드\" 버튼이 있는 카운터 기반 코드, 그리고 실시간 미리보기가 있는 고급 코드 설정.';

  @override
  String get helpNew030g =>
      '폴더, 여러 계정 한 번에 선택하기, 가나다순 또는 최근 사용순 정렬, 그리고 \"계정 이름 정리\".';

  @override
  String get helpNew030h => '계정의 QR 코드를 보여 줘서(Face ID나 암호 확인 후) 다른 기기로 옮기기.';

  @override
  String get helpNew030i =>
      '최신 iPhone, Mac, Windows PC에서 YubiKey 같은 보안 키로 잠금 해제 (Premium).';

  @override
  String get helpNew030j =>
      '코드를 보여 주기 전에 Face ID나 암호가 필요한 \"먼저 확인\" 계정, 그리고 선택한 계정을 숨기는 여행 모드 (Premium).';

  @override
  String get helpNew030k =>
      '활동 기록 (Premium), \"코드가 안 맞나요?\" 시계 확인, 백업 테스트, 잠자기 시 잠금, 백업 알림.';

  @override
  String get helpNew030l =>
      '긴급 접근: 믿을 수 있는 사람이 계정을 요청할 수 있고, 내가 거절할 수 있는 기간이 며칠 주어져요.';

  @override
  String get helpNew030m =>
      'Spotlight 검색, 복사한 코드의 실시간 현황과 워치 페이스 컴플리케이션 (Premium), 열 때 복사, Mac의 \"한 번 붙여 넣으면 지우기\".';

  @override
  String get helpNew030n =>
      '카운트다운 스타일, 계정별 색상이나 이모지, 소리 내어 읽기, 읽기 쉬운 글꼴, 더 나아진 화면 읽기 프로그램 지원.';

  @override
  String get helpNew030o => '큰 창을 위한 넓은 레이아웃, 그리고 계절별 Premium 아이콘.';

  @override
  String get helpNew030p => 'iPhone과 Android 앱 안에서 Premium 구매, 선물하기, 친구 초대하기.';

  @override
  String get helpNew030q => '최대 10명과 코드를 공유하는 팀 보관함. 팀 요금제는 곧 나와요.';

  @override
  String get helpNew030r => '가족 요금제는 곧 나와요.';

  @override
  String get helpNew030s => '이제 데스크톱 앱이 Linux에서도 실행돼요. Linux 다운로드는 곧 나와요.';

  @override
  String get helpNew020a => '기기 간 동기화, 브라우저 확장 프로그램용 휴대폰 연결, 계정 하나를 안전하게 공유하기.';

  @override
  String get helpNew020b => '암호, 자동 잠금, 긴급 삭제, 가짜 암호, 스크린샷 차단, 보안 점검, 유출 알림.';

  @override
  String get helpNew020c =>
      '위젯, Apple Watch와 Wear OS 앱, Mac 메뉴 막대와 Windows 트레이, 자동 암호화 백업 (Premium).';

  @override
  String get helpNew020d =>
      'Aegis, 2FAS, Authy, Bitwarden, 1Password에서 가져오기, 그리고 즐겨찾기, 태그, 메모, 복구 코드, 휴지통.';

  @override
  String get helpNew010a =>
      '첫 번째 버전: 계정 스캔 또는 붙여 넣기, 코드 보기, 암호화 백업, 브라우저 확장 프로그램.';

  @override
  String helpNoBrowser(String url) {
    return '웹 브라우저를 열 수 없어요. 페이지 주소는 $url';
  }

  @override
  String helpGuideFor(String name) {
    return '$name에서 2FA를 켜는 방법';
  }

  @override
  String get helpTourWelcome => 'Tanooki Auth에 오신 걸 환영해요';

  @override
  String get helpTourWelcomeBody =>
      '많은 웹사이트에서 비밀번호와 함께 6자리 코드를 요구할 수 있어요. 이걸 2단계 인증, 또는 2FA라고 해요. Tanooki Auth는 바로 이 기기에서 그 코드를 만들어 주기 때문에, 누군가 비밀번호만 알아서는 로그인할 수 없어요.';

  @override
  String get helpTourAdd => '첫 계정 추가하기';

  @override
  String get helpTourAddBody =>
      '웹사이트의 보안 설정에서 2FA를 켜세요. QR 코드가 표시되면 여기서 스캔하거나, 설정 링크를 복사해서 붙여 넣으세요. 이미 다른 인증 앱을 쓰고 있나요? 계정을 한 번에 가져올 수 있어요.';

  @override
  String get helpTourScanOrPaste => 'QR 코드 스캔 또는 링크 붙여 넣기';

  @override
  String get helpTourImport => '다른 앱에서 가져오기';

  @override
  String get helpTourPopular => '먼저 보호하면 좋은 인기 사이트';

  @override
  String get helpTourPopularBody =>
      '이메일, 소셜 미디어, 그리고 돈과 관련된 곳이 가장 중요해요. 단계별 가이드에서 각 사이트의 2FA 설정 위치를 알려 드려요.';

  @override
  String get helpAllGuides => '모든 2FA 가이드';

  @override
  String helpTourStep(int step, int total) {
    return '$total단계 중 $step단계';
  }

  @override
  String get helpTourSkip => '투어 건너뛰기';

  @override
  String get helpWhatsNew => '새로운 기능';

  @override
  String helpVersion(String version) {
    return '버전 $version';
  }

  @override
  String helpVersionThis(String version) {
    return '버전 $version (현재 버전)';
  }

  @override
  String get helpFeedbackEmpty => '먼저 메시지를 입력하세요.';

  @override
  String get helpFeedbackSent => '보냈어요. 고마워요! Maddie가 모든 메시지를 읽어요.';

  @override
  String get helpFeedbackTooLong => '너무 길어서 보낼 수 없어요. 조금 줄여 주세요 (최대 약 4,000자).';

  @override
  String get helpFeedbackTooMany => '지난 1시간 동안 의견을 많이 보냈어요. 1시간 뒤에 다시 시도해 주세요.';

  @override
  String get helpFeedbackOffline =>
      '인터넷에 연결할 수 없어요. 연결을 확인하고 다시 시도해 주세요. 메시지는 그대로 남아 있어요.';

  @override
  String get helpFeedbackServerError =>
      '의견 서버에 문제가 생겨서 메시지를 받지 못했어요. 나중에 다시 시도해 주세요. 메시지는 그대로 남아 있어요.';

  @override
  String get helpFeedbackTitle => '의견 보내기';

  @override
  String get helpFeedbackIntro =>
      '버그를 찾았거나 앱에 바라는 기능이 있나요? 여기서 Maddie에게 알려 주세요.';

  @override
  String get helpFeedbackMessage => '메시지';

  @override
  String get helpFeedbackEmail => '이메일 (선택)';

  @override
  String get helpFeedbackEmailHelp => '답장을 받고 싶을 때만 입력하세요.';

  @override
  String get helpFeedbackDevice => '앱 버전과 기기 종류 포함';

  @override
  String get helpFeedbackDeviceHelp =>
      '예: \"0.3.0\", \"iOS\". 버그를 찾는 데 도움이 돼요.';

  @override
  String get helpFeedbackNeverSent =>
      '절대 보내지 않는 것: 계정, 계정 이름, 코드, 설정 키, 태그, 메모, 그 밖에 앱 안의 모든 것.';

  @override
  String get helpFeedbackSend => '보내기';

  @override
  String get phoneUiPushAndroid =>
      'Android에서는 아직 알림이 설정되지 않아서, Tanooki Auth가 열려 있을 때 요청이 표시돼요.';

  @override
  String get phoneUiPushThisDevice => '이 기기는 Tanooki Auth가 열려 있을 때 요청을 받아요.';

  @override
  String get phoneUiPushNoToken => 'iPhone에서 앱에 알림 토큰을 주지 않았어요.';

  @override
  String get phoneUiPushDenied =>
      'Tanooki Auth의 알림이 꺼져 있어요. 앱이 닫혀 있을 때도 요청을 받으려면 iPhone 설정 앱의 \'알림\'에서 켜세요.';

  @override
  String phoneUiPushFailed(String problem) {
    return '알림을 켤 수 없어요: $problem. Tanooki Auth가 열려 있을 때는 계속 요청이 표시돼요.';
  }

  @override
  String get phoneUiPushNotInBuild =>
      '이 빌드에서는 알림을 쓸 수 없어요. Tanooki Auth가 열려 있을 때 요청이 표시돼요.';

  @override
  String get phoneUiPushChecking => '알림이 작동하는지 확인하고 있어요…';

  @override
  String get phoneUiRequest => '로그인 코드 요청';

  @override
  String get phoneUiNoAccount =>
      '이 웹사이트용으로 저장된 계정이 없어서 보낼 코드가 없어요. 계정이 있을 거라고 생각했다면, 진짜 사이트인 척하는 가짜 사이트일 수도 있어요.';

  @override
  String get phoneUiWantsCode =>
      '연결된 브라우저에서 이 웹사이트의 코드를 원해요. 지금 로그인하는 중일 때만 승인하세요.';

  @override
  String get phoneUiApprove => '승인';

  @override
  String phoneUiApproveAccount(String name) {
    return '승인: $name';
  }

  @override
  String get phoneUiScanTitle => '브라우저의 코드 스캔';

  @override
  String get phoneUiScanWrong =>
      '브라우저 연결 코드가 아니에요. 브라우저에서 Tanooki Auth 확장 프로그램을 클릭한 다음 \"대신 내 휴대폰 사용\"을 클릭하세요.';

  @override
  String get phoneUiPasteTitle => '연결 링크 붙여 넣기';

  @override
  String get phoneUiPair => '연결';

  @override
  String get phoneUiPaired => '연결되었어요. 그 브라우저에서 코드를 요청하면 여기에 표시돼요.';

  @override
  String get phoneUiExpired => '코드가 만료되었어요. 브라우저에서 새 코드를 만들고 다시 스캔하세요.';

  @override
  String get phoneUiPremium => '휴대폰과 브라우저 함께 쓰기는 Premium 기능이에요';

  @override
  String get phoneUiIntro =>
      'Tanooki Auth 앱이 없는 컴퓨터에서도, 어떤 컴퓨터의 브라우저에서든 코드를 채울 수 있어요. 브라우저 확장 프로그램이 요청하면 여기서 \'승인\'을 탭하면 돼요. 코드는 종단 간 암호화되어 전달되고, 각 계정이 저장된 웹사이트에만 보내져요.';

  @override
  String get phoneUiPairBrowser => '브라우저 연결';

  @override
  String get phoneUiPairHelp =>
      '브라우저에서 Tanooki Auth 확장 프로그램을 클릭한 다음 \"대신 내 휴대폰 사용\"을 클릭하면 코드가 표시돼요.';

  @override
  String get phoneUiPairedBrowsers => '연결된 브라우저';

  @override
  String get phoneUiNoneYet => '아직 없음';

  @override
  String get phoneUiBrowser => '브라우저';

  @override
  String phoneUiPairedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString에 연결됨';
  }

  @override
  String get phoneUiUnpair => '연결 해제';

  @override
  String get phoneUiPushOn => '알림 켜짐';

  @override
  String get phoneUiPushOff => '앱이 열려 있을 때 요청 표시';

  @override
  String get phoneUiPushOnHelp => 'Tanooki Auth가 닫혀 있어도 요청마다 알림을 받아요.';

  @override
  String phoneUiSendCodeFor(String name) {
    return '$name의 코드 보내기';
  }

  @override
  String get phoneUiActivityWhere => '브라우저, 이 휴대폰을 통해';

  @override
  String get premiumFiveOnce => '한 번만 \$5';

  @override
  String get premiumPayOnce => '한 번만 결제';

  @override
  String get premiumCheckoutSoon =>
      '결제는 아직 열리지 않았어요. 곧 열려요. Tanooki Auth를 후원하고 싶어 해 줘서 고마워요!';

  @override
  String get premiumEnterKeyTitle => '라이선스 키 입력';

  @override
  String get premiumEnterKeyHint => 'TA1.…  (구매 이메일에 있어요)';

  @override
  String get premiumBadKey =>
      '올바른 라이선스 키가 아니에요. 구매 이메일에서 키 전체를 복사해서 다시 시도해 주세요.';

  @override
  String premiumInvitesNowFamily(int count) {
    return '친구 $count명이 내 링크로 Premium을 구매해서, 이제 내 키가 최대 5명이 쓸 수 있는 가족 키가 되었어요. 이 기기에는 이미 설치되었어요. 아래 새 키를 복사해서 다른 기기에도 입력하세요.';
  }

  @override
  String premiumInvitesAlreadyFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '친구 $count명이 내 링크로 Premium을 구매했어요. 내 키는 이미 가족 키예요.',
    );
    return '$_temp0';
  }

  @override
  String premiumInvitesProgress(int count, int needed, int left) {
    return '친구 $needed명 중 $count명이 내 링크로 Premium을 구매했어요. $left명만 더 구매하면 내 키가 가족 키가 돼요.';
  }

  @override
  String get premiumInviteLinkCopied => '초대 링크를 복사했어요.';

  @override
  String get premiumKeyCopied => '라이선스 키를 복사했어요.';

  @override
  String premiumJustMe(String price) {
    return '나만 — $price';
  }

  @override
  String premiumFamilyPrice(String price) {
    return '가족 (최대 5명) — $price';
  }

  @override
  String get premiumFamilyApple =>
      '가족: 가족 공유를 통해 Apple 가족과 공유되고, 어떤 기기에서든 최대 5명이 쓸 수 있는 라이선스 키도 함께 받아요.';

  @override
  String get premiumFamilyKey => '가족: 라이선스 키 하나를 최대 4명과 함께 써요.';

  @override
  String get premiumYourKey => '내 라이선스 키';

  @override
  String get premiumYourKeyHelp =>
      '다른 기기에서 입력하세요: 설정 → Premium 받기 → \"이미 구매했나요? 라이선스 키 입력\".';

  @override
  String get premiumCopyKey => '키 복사';

  @override
  String get premiumInviteFriends => '친구 초대';

  @override
  String get premiumInviteHelp => '친구는 20% 할인을 받아요. 친구 3명이 구매하면 내 키가 가족 키가 돼요.';

  @override
  String get premiumGetInvite => '내 초대 링크 받기';

  @override
  String get premiumCheckInvites => '내 초대 확인';

  @override
  String get premiumYouHave => 'Premium을 쓰고 있어요';

  @override
  String get premiumTitle => 'Tanooki Auth Premium';

  @override
  String get premiumOwnedFamily =>
      '가족 요금제: 라이선스 키를 최대 4명과 함께 쓸 수 있어요 (모두 5명). Tanooki Auth를 후원해 줘서 고마워요.';

  @override
  String get premiumOwnedThanks => 'Tanooki Auth를 후원해 줘서 고마워요.';

  @override
  String get premiumPitchStripe => '한 번만 \$5, 또는 가족 모두를 위해 \$10. 평생 내 것이에요.';

  @override
  String get premiumPitchStore =>
      '나를 위해 한 번, 또는 가족 모두를 위해 한 번만 결제하세요. 평생 내 것이에요.';

  @override
  String get premiumPerkThemes => '모든 Premium 테마';

  @override
  String premiumPerkThemesBody(int count) {
    return '파스텔 핑크, 파스텔 블루 외 $count가지, 저절로 바뀌는 계절 테마, 직접 만든 테마 최대 3개, 그리고 앞으로 추가될 모든 테마.';
  }

  @override
  String get premiumPerkIcons => '앱 아이콘';

  @override
  String premiumPerkIconsBody(int count) {
    return 'iPhone과 Android에서 홈 화면 아이콘 $count개 중에서 고르세요. 색상, 기념일, 프라이드 깃발이 있어요. Mac에서는 앱이 열려 있는 동안 Dock 아이콘이 바뀝니다.';
  }

  @override
  String get premiumPerkSync => '기기 간 동기화';

  @override
  String get premiumPerkSyncBody =>
      '한 기기에서 계정을 추가하면 모든 기기에서 볼 수 있어요. 종단 간 암호화돼요. Apple 기기끼리는 iCloud로, 여러 종류의 기기를 함께 쓴다면 Tanooki 릴레이로 동기화해요.';

  @override
  String get premiumPerkApprove => '휴대폰에서 코드 승인';

  @override
  String get premiumPerkApproveBody =>
      '어떤 컴퓨터에서든 브라우저 확장 프로그램을 써 보세요. 휴대폰에 요청이 오면 \'승인\'을 탭하고, 코드가 채워져요.';

  @override
  String get premiumPerkBreach => '유출 알림';

  @override
  String get premiumPerkBreachBody =>
      '계정이 있는 웹사이트가 알려진 데이터 유출에 포함되면 알려 드려요. 기기에서 확인하고, 내 정보는 전혀 전송되지 않아요.';

  @override
  String get premiumPerkShare => '계정 안전하게 공유하기';

  @override
  String get premiumPerkShareBody =>
      '믿을 수 있는 사람에게 QR 코드와 6자리 코드로 계정 하나를 넘겨주세요. 잠겨 있고, 24시간 뒤 만료되고, 서버를 거치지 않아요.';

  @override
  String get premiumPerkFamily => '가족 요금제';

  @override
  String get premiumPerkFamilyStripe =>
      '\$5 대신 \$10이면 키 하나로 최대 5명이 Premium을 쓸 수 있어요. 가족에게 키를 보내면 나와 똑같이 입력하면 돼요.';

  @override
  String get premiumPerkFamilyStore =>
      '가족용으로 한 번 구매하면 최대 5명이 Premium을 쓸 수 있어요. 라이선스 키를 보내면 나와 똑같이 입력하면 돼요.';

  @override
  String get premiumPerkFuture => '앞으로 나올 모든 Premium 기능';

  @override
  String get premiumPerkFutureBody =>
      '한 번만 결제하면 Premium이 앞으로 커지는 만큼 모두 받을 수 있어요. 구독은 절대 없어요.';

  @override
  String get premiumPerkFree => '개인정보 보호 앱을 무료로 지켜 줘요';

  @override
  String get premiumPerkFreeStripe => '여러분의 \$5 덕분에 추적하지 않는 무료 앱을 계속 만들 수 있어요.';

  @override
  String get premiumPerkFreeStore =>
      'Premium을 구매해 주시는 덕분에 추적하지 않는 무료 앱을 계속 만들 수 있어요.';

  @override
  String get premiumFreeForever =>
      'Premium이 있든 없든 평생 무료: 무제한 계정, 스캔, 백업, 브라우저 확장 프로그램, 앱 잠금.';

  @override
  String get premiumFamilySoon => '가족 요금제는 곧 나와요';

  @override
  String get premiumFamilyKeyEach =>
      '가족: 라이선스 키 하나를 최대 4명과 함께 써요. 각자 자기 Tanooki Auth에 입력하면 돼요.';

  @override
  String get premiumRestore => '구매 항목 복원';

  @override
  String get premiumAlreadyBought => '이미 구매했나요? 라이선스 키 입력';

  @override
  String get premiumDesktopKeySoon =>
      'Android에서 구매한 경우 데스크톱 키는 곧 나와요. 지금 이 휴대폰에서는 Premium이 잠금 해제되었고, 컴퓨터용 라이선스 키는 이후 업데이트에서 여기에 표시돼요.';

  @override
  String premiumGift(String price) {
    return 'Premium 선물하기 — $price';
  }

  @override
  String premiumGiftFamily(String price) {
    return '가족 요금제 선물하기 — $price';
  }

  @override
  String get premiumGiftHelp => '결제하면 받는 사람용 키가 담긴 인쇄용 기프트 카드를 받아요.';

  @override
  String get settingsIconFailed => '앱 아이콘을 바꾸지 못했어요. 다시 시도하거나 앱을 다시 시작하세요.';

  @override
  String settingsIconFailedWhy(String problem) {
    return '앱 아이콘을 바꾸지 못했어요 ($problem). 다시 시도하거나 앱을 다시 시작하세요.';
  }

  @override
  String settingsIconSemantic(String name) {
    return '$name 앱 아이콘';
  }

  @override
  String settingsIconSemanticPremium(String name) {
    return '$name 앱 아이콘, Premium';
  }

  @override
  String get settingsAppIcon => '앱 아이콘';

  @override
  String get settingsAppIconPremium => '앱 아이콘 (Premium)';

  @override
  String get settingsAppIconIos => '홈 화면에 있는 아이콘이에요.';

  @override
  String get settingsAppIconAndroid =>
      '홈 화면에 있는 아이콘이에요. 휴대폰이 아이콘을 바꾸는 동안 잠깐 사라질 수 있어요.';

  @override
  String get settingsAppIconMac =>
      'Tanooki Auth가 열려 있는 동안 Dock 아이콘이 바뀌어요. Mac은 앱을 종료한 뒤에는 다른 아이콘을 유지할 수 없어서, Finder와 Launchpad에는 파란색 아이콘이 그대로 남아요.';

  @override
  String get settingsAppIconOther => '앱 아이콘은 iPhone과 Android에서 바꿀 수 있어요.';

  @override
  String get settingsLockNameMac => 'Touch ID 또는 Mac 암호';

  @override
  String get settingsLockNamePhone => 'Face ID, 지문 또는 암호';

  @override
  String settingsNoLockSetUp(String lock) {
    return '이 기기에 $lock이(가) 설정되어 있지 않아서 앱을 잠글 수 없어요. 먼저 시스템 설정에서 설정하세요.';
  }

  @override
  String get settingsLockReasonOn => '앱 잠금 켜기';

  @override
  String get settingsLockReasonOff => '앱 잠금 끄기';

  @override
  String get settingsSetPasscode => '앱 암호 설정';

  @override
  String get settingsSetPasscodeIntro =>
      'Tanooki Auth를 열 때 이 암호를 입력해요. Face ID나 지문이 안 될 때도 쓸 수 있어요. 잊어버리면 백업으로만 다시 들어올 수 있어요.';

  @override
  String get settingsPasscodeOn => '앱 암호가 켜졌어요.';

  @override
  String get settingsPasscode => '앱 암호';

  @override
  String get settingsChangePasscode => '암호 변경';

  @override
  String get settingsPasscodeOff => '암호 끄기';

  @override
  String get settingsNewPasscode => '새 앱 암호';

  @override
  String get settingsPasscodeChanged => '암호를 바꿨어요.';

  @override
  String get settingsPasscodeIsOff => '앱 암호가 꺼졌어요.';

  @override
  String get settingsRemoveDecoyTitle => '가짜 암호를 제거할까요?';

  @override
  String get settingsRemoveDecoyBody => '가짜 계정은 지워져요. 진짜 계정은 그대로예요.';

  @override
  String get settingsSetDecoy => '가짜 암호 설정';

  @override
  String get settingsSetDecoyIntro =>
      '누군가 Tanooki Auth를 열라고 강요하면 이 암호를 대신 입력하세요. 따로 분리된 빈 계정 목록이 열리고, 화면 어디에도 진짜가 아니라는 표시가 없어요. 쓰던 것처럼 보이도록 무해한 계정을 몇 개 추가해 두세요.\n\n진짜 암호를 입력하면 계속 진짜 계정이 열려요.';

  @override
  String get settingsDecoySet => '가짜 암호를 설정했어요.';

  @override
  String settingsWipeTitle(int count) {
    return '암호를 $count번 틀리면 모두 지울까요?';
  }

  @override
  String settingsWipeBody(int count) {
    return '누군가 앱 암호를 연속으로 $count번 틀리면, Tanooki Auth가 이 기기의 모든 계정을 지워요. 되돌릴 수 없고, 한번 시작되면 멈출 수도 없어요.';
  }

  @override
  String get settingsWipeSureTitle => '정말 괜찮아요?';

  @override
  String get settingsWipeSureBody =>
      '휴대폰을 가지고 노는 아이나, 컨디션이 나쁜 날의 나도 이걸 실행시킬 수 있어요. 지워진 뒤에는 백업 파일로만 되돌릴 수 있어요. 백업이 없으면 이 코드를 쓰는 모든 웹사이트에 로그인하지 못할 수도 있어요.';

  @override
  String get settingsWipeTurnOn => '긴급 삭제 켜기';

  @override
  String get settingsTravelOffReason => '여행 모드 끄기';

  @override
  String get settingsTravelOnNone =>
      '여행 모드가 켜졌지만, 아직 \"여행 모드에서 숨기기\"로 표시한 계정이 없어요. 먼저 ⋯ > 편집에서 표시하세요.';

  @override
  String settingsTravelOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '여행 모드가 켜졌어요. 계정 $count개가 숨겨졌어요.',
    );
    return '$_temp0';
  }

  @override
  String get settingsTravelOff => '여행 모드가 꺼졌어요. 모든 계정이 다시 나타났어요.';

  @override
  String get settingsCheckingClock => '시계를 확인하고 있어요…';

  @override
  String get settingsClockRight =>
      '시계는 정확해요. 그러니 원인은 시계가 아니에요. 계정 설정(⋯ > 편집 > 고급)이 웹사이트에서 안내한 내용과 같은지 확인하세요.';

  @override
  String settingsClockFailed(String problem) {
    return '시계를 확인하지 못했어요: $problem';
  }

  @override
  String get settingsLockApp => '앱 잠금';

  @override
  String settingsLockAppHelp(String lock) {
    return '앱을 열 때 $lock 요구';
  }

  @override
  String get settingsPasscodeOnHelp => '켜짐. 탭해서 바꾸거나 끄세요.';

  @override
  String settingsPasscodeOffHelp(String lock) {
    return '꺼짐. $lock 대신 또는 함께, 앱을 열 때 입력하는 숫자예요.';
  }

  @override
  String get settingsLockAgain => '다시 잠금';

  @override
  String settingsLockAgainHelp(String time) {
    return '백그라운드에서 $time 후';
  }

  @override
  String get settingsLockFirst => '먼저 잠금이나 암호를 켜세요';

  @override
  String get settingsDecoy => '가짜 암호';

  @override
  String get settingsDecoyOn => '켜짐. 따로 분리된 계정 목록이 열려요. 탭해서 제거하세요.';

  @override
  String get settingsDecoyOff => '따로 분리된 빈 계정 목록을 여는 두 번째 암호';

  @override
  String settingsWipe(int count) {
    return '암호를 $count번 틀리면 지우기';
  }

  @override
  String get settingsWipeHelp => '긴급 삭제. 최근 30일 안에 만든 백업이 필요해요.';

  @override
  String get settingsLockOnSleep => '컴퓨터가 잠자기 상태가 되면 잠금';

  @override
  String get settingsLockOnSleepHelp => '화면이 잠기거나 잠시 로그아웃할 때도 잠겨요';

  @override
  String get settingsLockOnSleepNeedsLock =>
      '잠글 대상이 있도록 먼저 \"앱 잠금\"이나 앱 암호를 켜세요.';

  @override
  String get settingsTravel => '여행 모드';

  @override
  String get settingsTravelPremium => '여행 모드 (Premium)';

  @override
  String get settingsTravelOnHelp =>
      '켜짐. \"여행 모드에서 숨기기\"로 표시한 계정은 끌 때까지 이 기기의 화면, 위젯, 워치, 확장 프로그램, 내보내기에서 사라져요. 삭제되는 건 아니에요.';

  @override
  String settingsTravelOffHelp(String proof) {
    return '국경을 넘기 전에: \"여행 모드에서 숨기기\"로 표시한 계정(⋯ > 편집)을 숨겨요. 끌 때는 $proof이(가) 필요해요.';
  }

  @override
  String get settingsKeys => '보안 키';

  @override
  String get settingsKeysPremium => '보안 키 (Premium)';

  @override
  String get settingsKeysHelp => 'YubiKey 같은 보안 키로 잠금 해제';

  @override
  String get settingsActivity => '활동 기록';

  @override
  String get settingsActivityPremium => '활동 기록 (Premium)';

  @override
  String get settingsActivityHelp =>
      '어떤 코드를 언제 복사, 채우기, 입력, 내보냈는지 보여 줘요. 이 기기에만 저장돼요.';

  @override
  String get settingsEmergency => '긴급 접근';

  @override
  String get settingsEmergencyPremium => '긴급 접근 (Premium)';

  @override
  String get settingsEmergencyHelp =>
      '나에게 무슨 일이 생기면 믿을 수 있는 한 사람이 내 계정을 받을 수 있어요. 7일 대기 기간 동안 내가 멈출 수 있어요';

  @override
  String get settingsTeamHelp => '최대 10명과 로그인 코드를 종단 간 암호화로 공유해요';

  @override
  String get settingsMonthly => '월간 요약 알림';

  @override
  String get settingsMonthlyPremium => '월간 요약 알림 (Premium)';

  @override
  String get settingsMonthlyHelp =>
      '매달 1일에 요약 카드를 보라고 알려 드려요. 계정에 관한 내용은 절대 담지 않아요.';

  @override
  String get settingsBlockShots => '스크린샷 차단';

  @override
  String get settingsBlockShotsDesktop => '스크린샷, 화면 녹화, 화면 공유에서 이 창을 숨겨요';

  @override
  String get settingsBlockShotsPhone => '스크린샷, 화면 녹화, 앱 전환기에 코드가 나오지 않게 해요';

  @override
  String get settingsCheckup => '보안 점검';

  @override
  String get settingsCheckupHelp => '고치면 좋은 점, 그리고 복구 키트';

  @override
  String get settingsBreachPremium => '유출 알림 (Premium)';

  @override
  String get settingsBreachOn => '켜짐. 매주 공개 유출 목록을 확인해요.';

  @override
  String get settingsBreachOff => '꺼짐. 켜면 일주일에 한 번 공개 유출 목록을 내려받아요.';

  @override
  String settingsThemeSemantic(String name) {
    return '$name 테마';
  }

  @override
  String settingsThemeSemanticPremium(String name) {
    return '$name 테마, Premium';
  }

  @override
  String get settingsPremiumThanks => 'Premium: 고마워요!';

  @override
  String get settingsGetPremium => 'Premium 받기';

  @override
  String get settingsPremiumThanksHelp => '모든 테마와 앞으로 나올 Premium 기능이 모두 내 거예요.';

  @override
  String settingsGetPremiumHelp(String payOnce) {
    return '$payOnce: 모든 테마, 기기 간 동기화 등.';
  }

  @override
  String get settingsAppearance => '모양';

  @override
  String get settingsCountdown => '카운트다운 스타일';

  @override
  String get settingsCountdownHelp => '각 코드의 남은 시간을 보여 주는 방식';

  @override
  String get settingsEasyFont => '읽기 쉬운 글꼴';

  @override
  String get settingsEasyFontHelp =>
      'Atkinson Hyperlegible: 문자와 숫자를 헷갈리지 않도록 Braille Institute에서 만든 글꼴';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageSystem => '시스템';

  @override
  String get settingsAccountsList => '계정 목록';

  @override
  String get settingsCompact => '작은 카드';

  @override
  String get settingsCompactHelp => '카드를 작게 해서 화면에 계정을 더 많이 표시해요';

  @override
  String get settingsSort => '계정 정렬';

  @override
  String settingsSortHelp(String sort) {
    return '$sort. 즐겨찾기는 항상 맨 위에 와요.';
  }

  @override
  String get settingsSortCustom => '직접 정한 순서. 카드를 길게 누른 다음 끌어서 옮기세요.';

  @override
  String get settingsSortRecent => '방금 코드를 복사한 계정이 맨 위로 올라가요';

  @override
  String get settingsSortName => '서비스 이름순';

  @override
  String get settingsTidyHelp =>
      '\"google.com:you@gmail.com\" 같은 이름을 \"Google\"로 바꿔요. 바뀌는 내용을 먼저 모두 보여 드려요.';

  @override
  String get settingsHideCodes => '탭할 때까지 코드 숨기기';

  @override
  String get settingsHideCodesHelp => '코드 대신 점을 보여 줘서 주변 사람이 읽을 수 없어요';

  @override
  String get settingsShareCodes => '위젯과 워치에 코드 표시';

  @override
  String get settingsShareCodesHelp =>
      '즐겨찾기한 계정의 코드가 이 앱을 열지 않아도 홈 화면, 잠금 화면, 워치에 표시돼요. 그래서 잠금 해제된 휴대폰이나 워치를 든 사람은 누구나 코드를 볼 수 있어요. 계정에 별표를 하면 즐겨찾기가 돼요.';

  @override
  String get settingsAutofill => '자동 완성으로 코드 채우기';

  @override
  String get settingsAutofillHelpIos =>
      '웹사이트나 앱에서 2FA 코드를 요청하면 iPhone이 키보드 위에 코드를 제안해 줘서 복사할 필요가 없어요. 먼저 확인하는 계정은 채우기 전에 Face ID가 필요해요. 여행 모드에서 숨긴 계정은 절대 제안되지 않아요.';

  @override
  String get settingsAutofillHelpAndroid =>
      '앱이나 웹사이트에서 2FA 코드를 요청하면 휴대폰이 작은 팝업으로 코드를 제안해 줘서 복사할 필요가 없어요. Android는 한 번에 앱 하나만 자동 완성을 할 수 있어서, 이 기능을 켜면 비밀번호 관리자의 자동 완성을 대신하게 돼요. 비밀번호 관리자에 의존하고 있다면 이 기능은 꺼 두세요.';

  @override
  String get settingsAutofillStepsTitle => '자동 완성 켜기';

  @override
  String get settingsAutofillStepsIos =>
      'iOS 18 이상이 필요해요.\n\n1. 설정 앱(회색 톱니바퀴 아이콘)을 여세요.\n2. 일반을 탭한 다음 자동 완성 및 암호를 탭하세요.\n3. 자동 완성을 쓸 수 있는 앱 목록에서 Tanooki Auth 옆의 스위치를 켜세요.\n\n스위치가 초록색이면 된 거예요. 다음에 웹사이트나 앱에서 코드를 요청하면 코드 입력란을 탭하고, 키보드 위의 Tanooki Auth 제안을 탭하세요.';

  @override
  String get settingsAutofillStepsAndroid =>
      '1. 아래의 \'설정 열기\'를 탭하세요. 자동 완성 앱 목록이 열려요.\n2. Tanooki Auth를 탭하고, 휴대폰이 물어보면 확인을 탭하세요.\n\n목록이 열리지 않으면: 설정 앱을 열고 \"자동 완성 서비스\"를 검색해서 탭한 다음 Tanooki Auth를 선택하세요.\n\nTanooki Auth가 자동 완성 서비스로 표시되면 된 거예요. 다음에 앱이나 웹사이트에서 코드를 요청하면 코드 입력란을 탭하고 팝업에서 Tanooki Auth를 선택하세요.\n\nAndroid는 한 번에 앱 하나만 자동 완성을 할 수 있어요. Tanooki Auth를 선택하면 비밀번호 관리자(Google, Bitwarden, 1Password 등)가 비밀번호를 채우지 않게 돼요. 되돌리려면 같은 곳에서 다시 선택하세요.';

  @override
  String get settingsAutofillOpen => '설정 열기';

  @override
  String get settingsTrash => '휴지통';

  @override
  String settingsTrashCount(int count) {
    return '휴지통 ($count)';
  }

  @override
  String get settingsTrashHelp => '삭제한 계정은 30일 동안 여기에 보관돼요';

  @override
  String get settingsWatchFace => '워치 페이스 즐겨찾기';

  @override
  String get settingsWatchFacePremium => '워치 페이스 즐겨찾기 (Premium)';

  @override
  String get settingsWatchFaceNoFavorites =>
      '먼저 메인 목록에서 계정에 별표를 하세요. 즐겨찾기만 워치 페이스에 넣을 수 있어요.';

  @override
  String get settingsNone => '없음';

  @override
  String get settingsCopying => '복사 및 바로 가기';

  @override
  String get settingsCopyOnOpen => '열 때 복사';

  @override
  String get settingsCopyOnOpenHelp =>
      '앱을 열거나 잠금 해제하면 마지막으로 사용한 계정의 코드를 복사해요. 코드를 보여 주기 전에 먼저 확인하는 계정은 건너뛰어요.';

  @override
  String get settingsPasteOnce => '한 번 붙여 넣으면 지우기';

  @override
  String get settingsPasteOnceHelp =>
      '복사한 코드는 한 번만 붙여 넣을 수 있고, 그다음 클립보드가 비워져요. 클립보드 기록 앱이 그 한 번을 쓸 수도 있어요. Windows에서는 대신 30초 뒤에 코드가 지워져요.';

  @override
  String get settingsSpotlight => 'Spotlight에 계정 표시';

  @override
  String get settingsSpotlightHelp =>
      '어디서든 계정 이름을 검색해서 바로 이동할 수 있어요. 이름만 공유되고 코드는 절대 공유되지 않아요.';

  @override
  String get settingsLiveActivity => '복사 후 잠금 화면에 코드 표시';

  @override
  String get settingsLiveActivityPremium => '복사 후 잠금 화면에 코드 표시 (Premium)';

  @override
  String get settingsLiveActivityHelp =>
      '코드를 복사하면 잠금 화면과 Dynamic Island에 만료될 때까지 카운트다운과 함께 표시돼요.';

  @override
  String get settingsWatchFaceHelp =>
      'Apple Watch 페이스에 코드를 표시할 즐겨찾기 하나를 선택하세요. \"위젯과 워치에 코드 표시\"가 켜져 있어야 해요.';

  @override
  String settingsWatchFaceChosen(String name) {
    return '$name. 보려면 워치 페이스에 Tanooki Auth 컴플리케이션을 추가하세요.';
  }

  @override
  String get settingsBrowserSection => '브라우저 확장 프로그램 및 런처';

  @override
  String get settingsBridgeOff => '실행 중 아님';

  @override
  String get settingsBridgeOn => '브라우저 확장 프로그램 사용 준비 완료';

  @override
  String settingsBridgeOffHelp(String first, String last) {
    return '$first–$last 포트를 모두 다른 프로그램이 쓰고 있어서 확장 프로그램이 연결할 수 없어요. 컴퓨터를 다시 시작하고 다시 시도해 주세요.';
  }

  @override
  String settingsBridgeOnHelp(String port) {
    return '이 컴퓨터에서만 연결을 받아요 (127.0.0.1:$port). Tanooki Auth가 열려 있는 동안 작동해요.';
  }

  @override
  String settingsPairedClient(String name) {
    return '연결됨: $name';
  }

  @override
  String get settingsPairedBrowser => '연결된 브라우저';

  @override
  String settingsExtensionId(String id) {
    return '확장 프로그램 $id';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsSecurity => '보안';

  @override
  String get settingsBackup => '백업';

  @override
  String get settingsExport => '백업 내보내기';

  @override
  String get settingsExportHelp => '직접 정한 암호 문구로 잠그는 암호화 파일';

  @override
  String get settingsImport => '백업 가져오기';

  @override
  String get settingsImportHelp => '백업 파일에서 계정을 추가해요. 이미 있는 계정은 건너뛰어요';

  @override
  String get settingsTestBackup => '백업 테스트';

  @override
  String get settingsTestBackupHelp =>
      '백업 파일이 내 암호 문구로 열리는지 확인해요. 아무것도 바꾸지 않아요.';

  @override
  String get settingsMoveOut => '다른 앱으로 옮기기';

  @override
  String get settingsMoveOutHelp =>
      'Aegis, 2FAS, Google Authenticator 또는 일반 설정 링크';

  @override
  String get settingsPaper => '종이 백업 인쇄';

  @override
  String get settingsPaperHelp => '잠긴 곳에 보관할 QR 코드와 복구 코드 PDF';

  @override
  String get settingsHelp => '도움말';

  @override
  String get settingsGuidesHelp => '인기 사이트에서 2FA를 켜는 단계별 도움말 (웹사이트)';

  @override
  String get settingsTour => '환영 투어 보기';

  @override
  String get settingsFeedbackHelp =>
      'Maddie에게 버그나 아이디어를 알려 주세요. 계정이나 코드는 절대 포함되지 않아요.';

  @override
  String get settingsAbout => '정보';

  @override
  String get settingsAboutMaddieHelp => 'Tanooki Auth를 만든 사람이 전하는 글';

  @override
  String get settingsCodesNotWorking => '코드가 안 맞나요?';

  @override
  String settingsCodesNotWorkingHelp(String time) {
    return '기기 시간 $time. 코드는 시계에 따라 달라져요. 탭해서 인터넷 시간과 비교해 보세요.';
  }

  @override
  String shareUiConfirmTitle(String name) {
    return '$name을(를) 공유할까요?';
  }

  @override
  String get shareUiConfirmBody =>
      '공유받은 사람은 모든 권한을 갖게 돼요. 그 사람이 계정을 갖고 있는 동안, 그 사람의 휴대폰은 내 것과 똑같은 코드를 만들어요. 가족처럼 완전히 믿을 수 있는 사람과만 공유하세요.\n\n나중에 내 목록에서 제거해도 상대방에게서 회수되지 않아요. 접근을 끊으려면 웹사이트에서 2단계 인증을 껐다가 다시 켜세요.';

  @override
  String get shareUiConfirmButton => '이해했어요, 공유할게요';

  @override
  String get shareUiLocking => '공유를 잠그고 있어요…';

  @override
  String shareUiTitle(String name) {
    return '$name 공유';
  }

  @override
  String get shareUiInstructions =>
      '상대방의 기기에서: Tanooki Auth를 열고 \'계정 추가\'를 탭한 다음 \"QR 코드 스캔\"(파일이면 \"공유된 계정 열기\")을 탭하세요. 그다음 이 코드를 입력하면 돼요:';

  @override
  String get shareUiTellCode => '코드는 직접 알려 주세요. 말로 하거나, 파일과는 다른 앱으로 보내세요.';

  @override
  String get shareUiSendFile => '대신 파일로 보내기';

  @override
  String get shareUiCopyLink => '링크로 복사';

  @override
  String get shareUiCopied => '복사했어요. 상대방은 \"설정 링크 붙여 넣기\"로 붙여 넣으면 돼요.';

  @override
  String get shareUiWorksFor => '24시간 동안, 이 코드가 있어야만 쓸 수 있어요. 서버를 전혀 거치지 않아요.';

  @override
  String get shareUiOpenTitle => '공유된 계정';

  @override
  String get shareUiOpenBody => '공유한 사람이 알려 준 6자리 코드를 입력하세요.';

  @override
  String get shareUiUnlocking => '잠금 해제 중…';

  @override
  String get signatureLabel => 'Maddie 드림';

  @override
  String get syncUiQrCode => 'QR 코드';

  @override
  String get syncUiNotYet => '아직 안 됨';

  @override
  String get syncUiJustNow => '방금';

  @override
  String syncUiMinutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String syncUiHoursAgo(int hours) {
    return '$hours시간 전';
  }

  @override
  String syncUiDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get syncUiThisDevice => '이 기기';

  @override
  String get syncUiAnotherDevice => '다른 기기';

  @override
  String syncUiAdded(String when) {
    return '$when 추가됨';
  }

  @override
  String syncUiThisDeviceNamed(String name) {
    return '이 기기 ($name)';
  }

  @override
  String syncUiLastSyncedAgo(String when) {
    return '마지막 동기화: $when';
  }

  @override
  String get syncUiWhere => '기기를 어디서 동기화할까요?';

  @override
  String get syncUiICloudHelp => 'iPhone, iPad, Mac 전용. 내 iCloud Drive를 사용해요.';

  @override
  String get syncUiRelay => 'Tanooki 릴레이';

  @override
  String get syncUiRelayHelp =>
      'Android와 Windows를 포함해 모든 기기에서 작동해요. 서버에는 알아볼 수 없게 암호화된 데이터만 저장돼요.';

  @override
  String get syncUiStartFreshTitle => '새로 시작할까요?';

  @override
  String get syncUiStartFreshBody =>
      '다른 Apple 기기에서 쓰는 암호 문구를 잊어버렸다면, 이 암호 문구로 새 동기화를 시작할 수 있어요. 그러면 다른 기기에서는 동기화를 껐다가 새 암호 문구로 다시 켜야 해요.';

  @override
  String get syncUiStartFresh => '새로 시작';

  @override
  String get syncUiOn => '동기화가 켜졌어요.';

  @override
  String get syncUiScanTitle => '동기화 코드 스캔';

  @override
  String get syncUiScanWrong => '동기화 코드가 아니에요. 다른 기기에서 설정 > 동기화 > 기기 추가를 여세요.';

  @override
  String get syncUiNowSyncing => '이제 이 기기가 동기화되고 있어요.';

  @override
  String get syncUiPasteTitle => '동기화 링크 붙여 넣기';

  @override
  String get syncUiPasteHint => 'tanookiauth://sync?…  (다른 기기의 \'기기 추가\'에서)';

  @override
  String get syncUiAddApple => 'Apple 기기 추가';

  @override
  String get syncUiAddAppleBody =>
      '다른 iPhone, iPad, Mac(같은 Apple ID로 로그인하고 iCloud Drive가 켜져 있어야 해요)에서 Tanooki Auth를 열고 설정 > 동기화로 가서 \"동기화 켜기\"를 탭한 다음, iCloud를 선택하고 같은 동기화 암호 문구를 입력하세요.\n\nAndroid 휴대폰이나 Windows PC를 추가하고 싶나요? 모든 기기에서 동기화를 끈 다음 Tanooki 릴레이로 다시 켜세요.';

  @override
  String get syncUiAddDevice => '기기 추가';

  @override
  String get syncUiAddDeviceBody =>
      '새 기기에서 Tanooki Auth를 열고 설정 > 동기화로 가서 \"다른 기기에서 참여\"를 탭하세요. 이 코드를 스캔한 다음, 거기서 동기화 암호 문구를 입력하세요.';

  @override
  String get syncUiAddDeviceNote =>
      '24시간 동안 한 번만 쓸 수 있어요. 이 코드만 가진 사람은 암호 문구 없이는 아무것도 읽을 수 없어요.';

  @override
  String get syncUiLinkCopied => '링크를 복사했어요. 새 기기에 붙여 넣으세요.';

  @override
  String get syncUiCopyLink => '대신 링크 복사';

  @override
  String get syncUiRemoveTitle => '이 기기를 동기화에서 제거할까요?';

  @override
  String get syncUiRemoveBody =>
      '이 기기는 더 이상 변경 사항을 받지 않아요. 기기를 잃어버렸거나 도난당했다면 동기화 암호 문구도 바꾸세요. 잃어버린 기기가 예전 암호 문구를 아직 알고 있으니, 모든 기기에서 동기화를 끈 다음 새 암호 문구로 다시 켜세요.';

  @override
  String get syncUiTurnOffTitle => '이 기기에서 동기화를 끌까요?';

  @override
  String get syncUiTurnOffBody =>
      '계정은 이 기기에 그대로 남아요. 변경 사항을 주고받는 것만 멈춰요. 다른 기기끼리는 계속 동기화돼요.';

  @override
  String get syncUiOff => '이 기기에서 동기화가 꺼졌어요.';

  @override
  String get syncUiPremium => '동기화는 Premium 기능이에요';

  @override
  String syncUiPremiumBody(String payOnce) {
    return '한 기기에서 계정을 추가하면 모든 기기에 나타나요. 종단 간 암호화돼요. $payOnce, 구독 없음.';
  }

  @override
  String get syncUiIntro =>
      '동기화하면 모든 기기의 계정이 똑같이 유지돼요. 이 기기를 떠나기 전에 모든 데이터가 동기화 암호 문구로 잠기기 때문에, iCloud나 저희 서버에는 알아볼 수 없게 암호화된 데이터만 저장돼요. 저희를 포함해 아무도 읽을 수 없어요.';

  @override
  String get syncUiTurnOn => '동기화 켜기';

  @override
  String get syncUiJoin => '다른 기기에서 참여';

  @override
  String get syncUiJoinHelp => '다른 기기가 이미 Tanooki 릴레이로 동기화 중일 때 \"참여\"를 사용하세요.';

  @override
  String get syncUiSyncingRelay => 'Tanooki 릴레이로 동기화 중';

  @override
  String get syncUiSyncingICloud => 'iCloud로 동기화 중';

  @override
  String get syncUiSyncingNow => '지금 동기화 중…';

  @override
  String syncUiSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '동기화된 항목 $count개를 읽을 수 없어요',
    );
    return '$_temp0';
  }

  @override
  String get syncUiSkippedHelp =>
      '다른 사람이 바꿨거나 다른 암호 문구로 만들어졌을 수 있어요. 이 항목 때문에 삭제된 건 없어요.';

  @override
  String get syncUiDevices => '기기';

  @override
  String get syncUiLoading => '불러오는 중…';

  @override
  String get syncUiAddDeviceRelay => '새 기기에서 스캔할 코드를 보여 줘요';

  @override
  String get syncUiAddDeviceApple => '다른 iPhone, iPad 또는 Mac';

  @override
  String get syncUiTurnOffButton => '이 기기에서 동기화 끄기';

  @override
  String get syncUiPassphraseNoteRelay =>
      '동기화 암호 문구는 복구할 수 없어요. 잊어버리면 모든 기기에서 동기화를 끄고 새 암호 문구로 다시 시작하세요. 계정은 그대로 남아요.';

  @override
  String get syncUiPassphraseNoteICloud =>
      '동기화에 내 iCloud Drive를 사용해요. 동기화 암호 문구는 복구할 수 없어요. 잊어버리면 새 암호 문구로 새로 시작하세요. 계정은 그대로 남아요.';

  @override
  String get syncUiTitle => '동기화';

  @override
  String get syncUiTooShort => '10자 이상 입력하세요. 아무 단어나 몇 개 이어 쓰면 좋아요.';

  @override
  String get syncUiMismatch => '두 암호 문구가 일치하지 않아요.';

  @override
  String get syncUiChoosePassphrase => '동기화 암호 문구 정하기';

  @override
  String get syncUiTypePassphrase => '동기화 암호 문구 입력';

  @override
  String get syncUiChooseHelp =>
      '기기를 추가할 때마다 각 기기에서 한 번씩 입력해요. 계정이 이 기기를 떠나기 전에 이 암호 문구로 잠가요.\n\n안전한 곳에 적어 두세요. 나도 저희도 복구하거나 재설정할 수 없어요.';

  @override
  String get syncUiTypeHelp => '처음 기기에서 동기화를 켤 때 정한 암호 문구와 같은 것을 입력하세요.';

  @override
  String get syncUiPassphrase => '동기화 암호 문구';

  @override
  String get syncUiTypeAgain => '한 번 더 입력';

  @override
  String get syncUiSectionTitle => '동기화 및 휴대폰';

  @override
  String get syncUiTitlePremium => '동기화 (Premium)';

  @override
  String get syncUiOnRelay => '켜짐, Tanooki 릴레이 사용';

  @override
  String get syncUiOnICloud => '켜짐, iCloud 사용';

  @override
  String get syncUiOffHelp => '모든 기기의 계정을 똑같이 유지해요';

  @override
  String get syncUiBrowser => '브라우저와 함께 쓰기';

  @override
  String get syncUiBrowserPremium => '브라우저와 함께 쓰기 (Premium)';

  @override
  String get syncUiBrowserHelp => '어떤 컴퓨터의 브라우저든 이 휴대폰에서 코드를 승인해요';

  @override
  String get teamUiCreateTitle => '팀 만들기';

  @override
  String get teamUiCreateHint => 'TT1.…  (구독한 뒤 나오는 페이지에 있어요)';

  @override
  String get teamUiCreateButton => '팀 만들기';

  @override
  String get teamUiReady => '팀이 준비되었어요. \"초대하기\"로 사람들을 초대하세요.';

  @override
  String get teamUiScanTitle => '팀 초대 스캔';

  @override
  String get teamUiScanWrong =>
      '팀 초대가 아니에요. 팀 관리자에게 설정 > 팀 보관함 > 초대하기를 열어 달라고 요청하세요.';

  @override
  String get teamUiJoinTitle => '팀 참여';

  @override
  String get teamUiJoinHint => 'tanookiauth://team?…  (팀 관리자가 보낸 초대 링크)';

  @override
  String get teamUiJoinButton => '참여';

  @override
  String get teamUiJoinedTeam =>
      '팀에 들어왔어요. 관리자의 앱이 이 기기와 팀 키를 공유하면 팀 계정이 나타나요.';

  @override
  String get teamUiInvite => '초대하기';

  @override
  String get teamUiInviteHelp =>
      '상대방의 기기에서: 설정 > 팀 보관함으로 가서 \"초대 QR 코드 스캔\" 또는 \"초대 링크 붙여 넣기\"를 선택하세요. 초대는 한 번만 쓸 수 있고 7일 동안 유효해요.';

  @override
  String get teamUiRemovePersonTitle => '이 사람을 제거할까요?';

  @override
  String get teamUiRemovePersonBody =>
      '그 사람은 바로 접근 권한을 잃고, 팀은 새 키를 받기 때문에 앞으로 추가하거나 바꾼 내용은 읽을 수 없어요. 이미 볼 수 있었던 코드는 복사해 뒀을 수 있으니, 중요한 계정은 2단계 인증 설정을 바꾸세요.';

  @override
  String get teamUiRemoved => '제거했어요. 팀에 새 키가 생겼어요.';

  @override
  String get teamUiDeleteTitle => '팀을 삭제할까요?';

  @override
  String get teamUiLeaveTitle => '팀에서 나갈까요?';

  @override
  String get teamUiDeleteBody => '팀의 모든 사람에게서 팀 계정이 모두 삭제돼요. 각자의 개인 계정은 그대로예요.';

  @override
  String get teamUiLeaveBody => '이 기기에서 팀 계정이 사라져요. 내 개인 계정은 그대로예요.';

  @override
  String get teamUiDeleteButton => '팀 삭제';

  @override
  String get teamUiLeaveButton => '나가기';

  @override
  String get teamUiDeleted => '팀을 삭제했어요.';

  @override
  String get teamUiLeft => '팀에서 나왔어요.';

  @override
  String get teamUiAddFirst => '먼저 Tanooki Auth에 계정을 추가한 다음, 여기서 팀으로 복사하세요.';

  @override
  String get teamUiCopyInTitle => '내 계정 하나를 팀으로 복사';

  @override
  String teamUiCopiedIn(String name) {
    return '$name이(가) 이제 팀에 있어요. 내 계정은 원래 자리에 그대로 있어요.';
  }

  @override
  String get teamUiRenameTitle => '팀 계정 이름 바꾸기';

  @override
  String get teamUiRenameHint => '이름 (예: AWS)';

  @override
  String teamUiRemoveAccountTitle(String name) {
    return '$name을(를) 팀에서 제거할까요?';
  }

  @override
  String get teamUiRemoveAccountBody => '팀의 모든 사람에게서 사라져요.';

  @override
  String get teamUiIntro =>
      '팀 보관함은 1년에 \$20로 최대 10명과 로그인 코드를 공유해요. 팀원은 누구나 팀 계정을 보고, 추가하고, 바꿀 수 있어요. 팀 계정은 팀만 가진 키로 기기에서 암호화되기 때문에 저희 서버도 읽을 수 없어요. 팀 계정은 별도의 \'팀\' 섹션에 있어서 내 개인 계정과 섞이지 않아요.';

  @override
  String get teamUiStart => '팀 시작하기';

  @override
  String get teamUiBuy => '팀 요금제 구매 — 1년에 \$20';

  @override
  String get teamUiPlanSoon => '팀 요금제는 곧 나와요';

  @override
  String get teamUiHaveLicense => '팀 라이선스가 있어요: 팀 만들기';

  @override
  String get teamUiJoinHelp => '팀 관리자에게 초대를 요청하세요. 참여는 무료예요.';

  @override
  String get teamUiScanInvite => '초대 QR 코드 스캔';

  @override
  String get teamUiPasteInvite => '초대 링크 붙여 넣기';

  @override
  String get teamUiYouRun => '내가 관리하는 팀이에요';

  @override
  String get teamUiYoureIn => '팀에 속해 있어요';

  @override
  String teamUiPeopleCount(int count, int max) {
    return '$max명 중 $count명';
  }

  @override
  String teamUiLastSynced(String when) {
    return '마지막 동기화: $when';
  }

  @override
  String teamUiPaidUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString까지 결제됨';
  }

  @override
  String get teamUiSyncNow => '지금 동기화';

  @override
  String get teamUiWaitingForKey =>
      '팀 관리자의 앱이 이 기기와 팀 키를 공유하기를 기다리고 있어요. 관리자가 다음에 Tanooki Auth를 열 때 공유돼요.';

  @override
  String get teamUiAccounts => '팀 계정';

  @override
  String get teamUiAddMine => '내 계정 추가';

  @override
  String get teamUiNoAccounts => '아직 팀 계정이 없어요.';

  @override
  String get teamUiChange => '변경';

  @override
  String get teamUiRename => '이름 바꾸기';

  @override
  String get teamUiRemoveFromTeam => '팀에서 제거';

  @override
  String get teamUiPeople => '사람';

  @override
  String get teamUiThisDevice => '이 기기 (관리자)';

  @override
  String teamUiDevice(String id) {
    return '기기 $id';
  }

  @override
  String teamUiJoined(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString에 참여';
  }

  @override
  String teamUiJoinedGettingKey(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString에 참여 · 팀 키 받는 중';
  }

  @override
  String get teamUiDeleteTeam => '팀 삭제';

  @override
  String get teamUiLeaveTeam => '팀에서 나가기';

  @override
  String get teamUiTitle => '팀 보관함';

  @override
  String teamUiCopiedCode(String name) {
    return '$name 코드를 복사했어요. 30초 뒤에 클립보드가 지워져요.';
  }

  @override
  String teamUiSection(int count) {
    return '팀 · $count';
  }

  @override
  String get teamUiWaitingShort => '팀 관리자가 이 기기와 팀 키를 공유하기를 기다리고 있어요.';

  @override
  String get teamUiNoAccountsHint => '아직 팀 계정이 없어요. 설정 > 팀 보관함에서 추가하세요.';

  @override
  String get themeAuto => '자동';

  @override
  String get themeDark => '다크';

  @override
  String get themeLight => '라이트';

  @override
  String get themePink => '파스텔 핑크';

  @override
  String get themeBlue => '파스텔 블루';

  @override
  String get themeLavender => '라벤더';

  @override
  String get themeMint => '민트';

  @override
  String get themeMidnight => '미드나잇';

  @override
  String get themeSunset => '선셋';

  @override
  String get themePeach => '피치';

  @override
  String get themeForest => '포레스트';

  @override
  String get themeOcean => '오션';

  @override
  String get themeMono => '모노';

  @override
  String get tidyNoName => '(이름 없음)';

  @override
  String tidyDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '이름 $count개를 정리했어요.',
    );
    return '$_temp0';
  }

  @override
  String get tidyTitle => '계정 이름 정리';

  @override
  String get tidyNothing => '계정 이름이 모두 이미 깔끔해요.';

  @override
  String get tidyIntro =>
      '이 이름들에는 웹사이트 주소나 불필요한 부분이 들어 있어요. 그대로 두고 싶은 이름은 체크를 해제한 다음 \'적용\'을 탭하세요. 코드는 바뀌지 않아요.';

  @override
  String tidyWas(String name) {
    return '이전: $name';
  }

  @override
  String get tidyNothingTicked => '선택한 항목 없음';

  @override
  String tidyApply(int count) {
    return '$count개 적용';
  }

  @override
  String get emergencyNotContactCode =>
      'Tanooki Auth 연락처 코드가 아니에요. 상대방에게 Tanooki Auth를 열고 설정 > 긴급 접근으로 가서 연락처 코드를 공유해 달라고 요청하세요.';

  @override
  String get emergencyCopyWontOpen =>
      '이 기기의 키로 긴급 사본을 열 수 없어요. 다른 기기용으로 만들어졌거나 손상되었어요.';

  @override
  String get emergencyGone => '이 긴급 사본은 더 이상 없어요. 소유자가 제거했어요.';

  @override
  String get emergencyWaitNotOver => '7일 대기 기간이 아직 끝나지 않았어요.';

  @override
  String get emergencyNotOwnerOrContact => '이 기기는 그 긴급 사본의 소유자도 연락처도 아니에요.';

  @override
  String get emergencyNoRequestToDeny => '거부할 요청이 더 이상 없어요.';

  @override
  String get emergencyAskFirst => '먼저 접근을 요청하세요.';

  @override
  String get emergencyTooBig =>
      '계정 데이터가 너무 커서 긴급 사본으로 남길 수 없어요 (한도는 약 500KB예요).';

  @override
  String get emergencyTooManyTries =>
      '1분 안에 너무 많이 시도했어요. 1분 기다린 다음 다시 시도해 주세요.';

  @override
  String emergencyServerSaidNo(String status) {
    return '동기화 서버가 요청을 거부했어요 (HTTP $status).';
  }

  @override
  String emergencyServerSaidNoWhy(String status, String reason) {
    return '동기화 서버가 요청을 거부했어요 (HTTP $status: $reason).';
  }

  @override
  String get emergencyNotEmergencyCode =>
      'Tanooki Auth 긴급 코드가 아니에요. 나를 선택한 사람에게 설정 > 긴급 접근에서 다시 보내 달라고 요청하세요.';

  @override
  String get emergencyLessThanMinute => '1분 미만';

  @override
  String emergencyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count일',
    );
    return '$_temp0';
  }

  @override
  String emergencyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count시간',
    );
    return '$_temp0';
  }

  @override
  String emergencyMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count분',
    );
    return '$_temp0';
  }

  @override
  String emergencyDaysHours(int days, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days일',
    );
    String _temp1 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours시간',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get emergencyUiExplainer =>
      '믿을 수 있는 사람 한 명을 선택하세요. 나에게 무슨 일이 생기면 그 사람이 내 계정을 요청할 수 있어요. 그러면 내 기기에 알림이 오고, 7일 안에 거절할 수 있어요. 아무도 거절하지 않으면 그 사람이 사본을 받아요.\n\nTanooki Auth 서버는 7일 대기 기간만 관리해요. 사본은 그 사람의 기기만 가진 키로 잠겨 있어서, 서버도 읽을 수 없고 서버에 침입한 사람도 읽을 수 없어요.';

  @override
  String emergencyUiPushNotWorking(String reason) {
    return '알림이 아직 작동하지 않아요 ($reason). Tanooki Auth를 열 때마다 요청이 있는지 확인해요.';
  }

  @override
  String get emergencyUiScanTheirQr => '상대방의 QR 코드 스캔';

  @override
  String get emergencyUiPasteCode => '상대방이 보낸 코드 붙여 넣기';

  @override
  String get emergencyUiWrongCode => '올바른 코드가 아니에요.';

  @override
  String get emergencyUiCopiedCode =>
      '복사했어요. 원하는 방법으로 보내 주세요. 비밀 정보는 들어 있지 않아요.';

  @override
  String get emergencyUiCopyAsText => '텍스트로 복사';

  @override
  String get emergencyUiTheirContactCode => '상대방의 연락처 코드';

  @override
  String get emergencyUiNotContactCodeShort => 'Tanooki Auth 연락처 코드가 아니에요.';

  @override
  String get emergencyUiMakeThemContact => '이 사람을 긴급 연락처로 지정할까요?';

  @override
  String emergencyUiMakeNamedContact(String name) {
    return '$name님을 긴급 연락처로 지정할까요?';
  }

  @override
  String get emergencyUiCopyLeftOnServer =>
      '모든 계정의 사본이 상대방의 기기에서만 열리도록 잠긴 채 Tanooki Auth 서버에 보관돼요. 계정을 바꾸면 사본도 업데이트돼요.';

  @override
  String get emergencyUiYourNameWhose => '내 이름 (누구의 사본인지 알 수 있게)';

  @override
  String get emergencyUiDoneGiveCode => '완료했어요. 이제 이 화면의 코드를 상대방에게 알려 주세요.';

  @override
  String get emergencyUiStopTitle => '긴급 접근을 중지할까요?';

  @override
  String get emergencyUiStopBody => '서버에서 사본이 삭제되고, 상대방은 더 이상 요청할 수 없어요.';

  @override
  String get emergencyUiChooseContact => '긴급 연락처 선택';

  @override
  String get emergencyUiChooseContactPremium => '긴급 연락처 선택 (Premium)';

  @override
  String get emergencyUiChooseContactHow =>
      '상대방이 자기 기기에서 Tanooki Auth를 열고 설정 > 긴급 접근으로 가서 연락처 코드를 보여 주면 돼요.';

  @override
  String get emergencyUiYourContact => '내 긴급 연락처';

  @override
  String get emergencyUiChecking => '서버에서 확인하고 있어요…';

  @override
  String get emergencyUiIdleJustNow => '아무도 요청하지 않았어요. 사본은 방금 업데이트되었어요.';

  @override
  String emergencyUiIdleUpdated(String day) {
    return '아무도 요청하지 않았어요. 사본은 $day에 마지막으로 업데이트되었어요.';
  }

  @override
  String emergencyUiWaiting(String who, String day, String left) {
    return '$who님이 $day에 요청했어요. 거부하지 않으면 $left 후에 사본을 열 수 있어요.';
  }

  @override
  String emergencyUiReleased(String who) {
    return '$who님이 요청했고 대기 기간이 끝났어요. 이제 사본을 열 수 있어요. 막으려면 거부하세요.';
  }

  @override
  String emergencyUiContactIs(String who) {
    return '긴급 연락처: $who';
  }

  @override
  String get emergencyUiDenied =>
      '거부했어요. 상대방은 내 계정을 열 수 없어요. 나중에 다시 요청할 수는 있어요.';

  @override
  String get emergencyUiCopyUpdated => '사본을 업데이트했어요.';

  @override
  String get emergencyUiCouldntUpdate => '사본을 업데이트하지 못했어요.';

  @override
  String get emergencyUiUpdateNow => '지금 사본 업데이트';

  @override
  String emergencyUiGiveCode(String who) {
    return '$who님에게 이 코드를 알려 주세요. 상대방은 Tanooki Auth에서 설정 > 긴급 접근 > \"받은 코드 추가\"로 가면 돼요.';
  }

  @override
  String get emergencyUiCodeTheyGave => '상대방이 알려 준 코드';

  @override
  String get emergencyUiNotEmergencyCodeShort => 'Tanooki Auth 긴급 코드가 아니에요.';

  @override
  String get emergencyUiAddedTheir => '추가했어요. 필요할 때 여기서 상대방의 계정을 요청할 수 있어요.';

  @override
  String emergencyUiAddedNamed(String name) {
    return '추가했어요. 필요할 때 여기서 $name님의 계정을 요청할 수 있어요.';
  }

  @override
  String get emergencyUiTheOwner => '소유자';

  @override
  String get emergencyUiAskTitle => '긴급 접근을 요청할까요?';

  @override
  String emergencyUiAskBody(String who) {
    return '$who에게 알림이 가고, 7일 안에 거절할 수 있어요. 거절하지 않으면 여기서 그 사람의 계정 사본을 열 수 있어요. 정말 필요할 때만 요청하세요.';
  }

  @override
  String get emergencyUiAsk => '요청';

  @override
  String get emergencyUiAsked => '요청했어요. 7일 대기 기간이 시작되었어요.';

  @override
  String emergencyUiAddTheirAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '상대방의 계정 $count개를 추가할까요?',
    );
    return '$_temp0';
  }

  @override
  String emergencyUiAddNamedAccounts(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name님의 계정 $count개를 추가할까요?',
    );
    return '$_temp0';
  }

  @override
  String get emergencyUiSomeone => '누군가';

  @override
  String get emergencyUiCheckingShort => '확인 중…';

  @override
  String get emergencyUiNotAsked => '아직 요청하지 않았어요.';

  @override
  String get emergencyUiRequestAccess => '접근 요청';

  @override
  String emergencyUiOpensIn(String left, String day) {
    return '요청했어요. 상대방이 거절하지 않으면 $left 후($day)에 열려요.';
  }

  @override
  String get emergencyUiWaitOver => '대기 기간이 끝났어요.';

  @override
  String get emergencyUiOpenCopy => '긴급 사본 열기';

  @override
  String emergencyUiPersonAccounts(String who) {
    return '$who의 계정';
  }

  @override
  String get emergencyUiYourContactCode => '내 연락처 코드';

  @override
  String get emergencyUiShowThis =>
      '누군가 나를 긴급 연락처로 지정하고 싶어 하면 이걸 보여 주세요. 비밀 정보는 들어 있지 않아요.';

  @override
  String get emergencyUiYourNameItsYou => '내 이름 (나인 걸 알 수 있게)';

  @override
  String get emergencyUiShowMyCode => '내 연락처 코드 보기';

  @override
  String get emergencyUiLetThemScan =>
      '상대방이 Tanooki Auth에서 이걸 스캔하게 하거나, 복사해서 보내 주세요.';

  @override
  String get emergencyUiAddCodeGiven => '받은 코드 추가';

  @override
  String get emergencyUiAddCodeGivenHow =>
      '상대방이 나를 선택하면 그 사람의 앱에 나를 위한 코드가 표시돼요';

  @override
  String get emergencyUiTitle => '긴급 접근';

  @override
  String get emergencyUiYourEmergencyContact => '내 긴급 연락처';

  @override
  String get emergencyUiPeopleWhoChoseYou => '나를 선택한 사람';

  @override
  String get securityUiProofWindows => 'Windows Hello';

  @override
  String get securityUiProofMac => 'Touch ID 또는 암호';

  @override
  String get securityUiProofIos => 'Face ID 또는 암호';

  @override
  String get securityUiProofOther => '지문 또는 PIN';

  @override
  String securityUiPasscodeAtLeast(int count) {
    return '암호 (숫자 $count개 이상)';
  }

  @override
  String get securityUiTypeAgain => '한 번 더 입력';

  @override
  String get securityUiPasscodesDontMatch => '두 암호가 일치하지 않아요.';

  @override
  String get securityUiPickDifferent => '다른 암호와 다른 걸로 정하세요.';

  @override
  String get securityUiEnterPasscode => '앱 암호 입력';

  @override
  String get securityUiPasscode => '암호';

  @override
  String get securityUiWrongPasscode => '암호가 틀렸어요.';

  @override
  String get securityUiCheckupTitle => '보안 점검';

  @override
  String get securityUiAllGood => '모두 좋아요';

  @override
  String get securityUiAllGoodBody => '앱이 잠겨 있고, 최근 백업이 있고, 모든 계정에 복구 코드가 있어요.';

  @override
  String get securityUiLockOffTitle => '앱이 잠겨 있지 않아요';

  @override
  String get securityUiLockOffBody =>
      '잠금 해제된 기기를 집어 든 사람은 누구나 코드를 볼 수 있어요. 설정에서 \"앱 잠금\"이나 앱 암호를 켜세요.';

  @override
  String get securityUiNoPasscodeTitle => '앱 암호 없음';

  @override
  String get securityUiNoPasscodeBody =>
      '암호가 있으면 Face ID나 지문이 작동하지 않을 때도 Tanooki Auth를 열 수 있어요. 설정에서 정하세요.';

  @override
  String get securityUiAutoBackupFailed => '자동 백업 실패';

  @override
  String get securityUiOpenAutoBackups => '자동 백업 열기';

  @override
  String get securityUiNoBackupTitle => '최근 30일 동안 백업 없음';

  @override
  String get securityUiNoBackupBody =>
      '이 기기를 잃어버리거나 고장 나면, 백업만이 계정을 되찾는 유일한 방법이에요.';

  @override
  String get securityUiMakeBackupNow => '지금 백업하기';

  @override
  String securityUiNoRecoveryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개에 복구 코드가 없어요',
    );
    return '$_temp0';
  }

  @override
  String securityUiNoRecoveryBody(String names) {
    return '복구 코드가 있으면 이 앱을 잃어버려도 웹사이트에 로그인할 수 있어요. 각 사이트의 보안 설정에서 찾은 다음, 계정의 ⋯ > 복구 코드에서 추가하세요.\n\n$names';
  }

  @override
  String get securityUiRecoveryKit => '복구 키트';

  @override
  String get securityUiRecoveryKitSub => '백업, 복구 코드, 종이 사본을 단계별로';

  @override
  String securityUiBreachSnack(String sites) {
    return '$sites에서 데이터 유출이 있었어요. 거기서 비밀번호를 바꾸세요.';
  }

  @override
  String get securityUiBreachDownloadFailed =>
      '유출 목록을 내려받지 못했어요. 인터넷 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get securityUiBreachAlerts => '유출 알림';

  @override
  String get securityUiBreachAlertsPremium => '유출 알림 (Premium)';

  @override
  String get securityUiBreachAlertsSub =>
      '일주일에 한 번, 내가 쓰는 웹사이트에서 데이터 유출이 있었는지 알려 줘요';

  @override
  String get securityUiBreachHow =>
      '작동 방식: Tanooki Auth는 haveibeenpwned.com에서 알려진 유출 사고의 공개 목록을 내려받아, 이 기기에서 저장된 웹사이트와 비교해요. 나나 내 계정에 관한 정보는 전혀 전송되지 않아요. 누구나 똑같은 파일을 내려받아요. 동기화와 Premium 구매를 빼면, 앱이 인터넷에 연결하는 건 이때뿐이에요.';

  @override
  String securityUiNoWebsite(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개에 저장된 웹사이트가 없어서 확인할 수 없어요. ⋯ > 편집에서 추가하세요.',
    );
    return '$_temp0';
  }

  @override
  String get securityUiCheckNow => '지금 확인';

  @override
  String get securityUiNoBreaches => '저장된 웹사이트에 알려진 유출이 없어요.';

  @override
  String get securityUiBreached => '유출됨. 그전에 비밀번호를 만들었다면 거기서 바꾸세요.';

  @override
  String securityUiBreachedOn(String date) {
    return '$date에 유출됨. 그전에 비밀번호를 만들었다면 거기서 바꾸세요.';
  }

  @override
  String securityUiBreachedLeaked(String data) {
    return '유출됨. 유출된 정보: $data. 그전에 비밀번호를 만들었다면 거기서 바꾸세요.';
  }

  @override
  String securityUiBreachedOnLeaked(String date, String data) {
    return '$date에 유출됨. 유출된 정보: $data. 그전에 비밀번호를 만들었다면 거기서 바꾸세요.';
  }

  @override
  String get securityUiKitIntro =>
      '이 기기를 잃어버렸을 때 계정에 다시 들어가는 방법이에요. 각각 1분이면 돼요. 아직 계정을 추가하지 않았다면 먼저 추가한 다음, 설정 > 보안 점검에서 다시 여기로 오세요.';

  @override
  String get securityUiKitBackupTitle => '백업 만들기';

  @override
  String get securityUiKitBackupBody =>
      '직접 정한 암호 문구로 잠그는 암호화 파일이에요. iCloud Drive, Google Drive, USB 메모리처럼 이 기기가 아닌 곳에 보관하세요.';

  @override
  String get securityUiKitBackupButton => '백업 만들기';

  @override
  String get securityUiKitCodesTitle => '복구 코드 저장하기';

  @override
  String get securityUiKitCodesBody =>
      '2단계 로그인을 켜면 대부분의 웹사이트에서 일회용 복구 코드 목록을 줘요. 계정마다 ⋯ > 복구 코드에서 추가하면 백업에도 함께 들어가요.';

  @override
  String get securityUiKitPaperTitle => '종이 백업 인쇄하기';

  @override
  String get securityUiKitPaperBody =>
      '선택 사항이에요. QR 코드를 인쇄한 종이는 모든 기기가 없어져도 쓸 수 있어요. 잠긴 곳에 보관하세요. 이 종이를 가진 사람은 누구나 내 코드를 만들 수 있어요.';

  @override
  String get securityUiKitPaperButton => '종이 백업 인쇄';

  @override
  String get securityUiSkipForNow => '지금은 건너뛰기';

  @override
  String get securityExtrasPrivacy =>
      '회원 가입도, 추적도 없어요. 설정 키는 이 기기에 암호화되어 저장돼요. 앱이 인터넷에 연결하는 경우는 다음뿐이에요: 시계 확인(화면에 코드가 표시되는 동안 최대 1시간에 한 번, 그리고 \"코드가 안 맞나요?\"를 탭할 때 Tanooki Auth 서버에 시간을 물어봐요. 나나 내 계정에 관한 정보는 전송되지 않아요), 켰을 때의 유출 알림(공개 유출 목록을 내려받아요), 설정했을 때의 동기화, 휴대폰 연결, 긴급 접근(서버가 읽을 수 없는 암호화 데이터만 주고받아요), Premium 구매, 그리고 직접 보내는 의견(메시지, 입력했다면 이메일, 체크해 두었다면 앱 버전과 기기 종류. 계정, 코드 등 앱 안의 다른 정보는 절대 보내지 않아요). 2FA 가이드는 웹 브라우저에서 열려요.';

  @override
  String get securityExtrasMonthlyBody =>
      '월간 보안 요약이 준비되었어요. Tanooki Auth를 열어서 확인하세요.';

  @override
  String get securityExtrasNotificationsOffIos =>
      'Tanooki Auth의 알림이 꺼져 있어요. iPhone 설정 앱의 \'알림\'에서 켠 다음 다시 시도해 주세요.';

  @override
  String get securityExtrasNotificationsOffMac =>
      'Tanooki Auth의 알림이 꺼져 있어요. 시스템 설정의 \'알림\'에서 켠 다음 다시 시도해 주세요.';

  @override
  String securityExtrasReminderFailed(String reason) {
    return '알림을 설정하지 못했어요 ($reason).';
  }

  @override
  String get securityExtrasRemindersUnavailable => '이 기기에서는 아직 알림을 쓸 수 없어요.';

  @override
  String securityExtrasDayTime(String day, String time) {
    return '$day $time';
  }

  @override
  String get securityExtrasClearTitle => '활동 기록을 지울까요?';

  @override
  String get securityExtrasClearBody => '이 기기에서 모든 기록이 삭제돼요. 계정은 그대로예요.';

  @override
  String get securityExtrasActivityTitle => '활동 기록';

  @override
  String securityExtrasActivityPitch(int count) {
    return '활동 기록은 Premium 기능이에요. 코드를 복사하거나, 웹사이트에 채우거나, 입력하거나, QR 코드로 보여 주거나, 내보낸 최근 $count번의 기록을 이 기기에만 남겨요.';
  }

  @override
  String get securityExtrasNothingYet =>
      '아직 기록이 없어요. 복사, 채우기, 입력, QR 코드 보기, 내보내기를 하면 여기에 표시돼요.';

  @override
  String get securityExtrasAllAccounts => '모든 계정';

  @override
  String get securityExtrasDeletedAccount => '삭제된 계정';

  @override
  String securityExtrasActivityLine(String kind, String what) {
    return '$kind: $what';
  }

  @override
  String get securityExtrasGetPremium => 'Premium 받기';

  @override
  String get securityExtrasAddKey => '보안 키 추가';

  @override
  String get securityExtrasAddKeyPremium => '보안 키 추가 (Premium)';

  @override
  String get securityExtrasAddKeyIos =>
      '다음으로, 안내가 나오면 키를 iPhone 윗부분에 대거나 연결하세요. 두 번 터치해야 할 수도 있어요.';

  @override
  String get securityExtrasAddKeyOther =>
      '다음으로, 키를 연결하고 깜빡이면 터치하세요. 두 번 터치해야 할 수도 있고, PIN이 있다면 입력해야 해요.';

  @override
  String get securityExtrasKeyName => '이름 (키를 구분할 수 있게)';

  @override
  String securityExtrasKeyAdded(String name) {
    return '\"$name\"을(를) 추가했어요. 이제 이 기기에서 이 키로 Tanooki Auth를 잠금 해제할 수 있어요.';
  }

  @override
  String securityExtrasKeyRemoved(String name) {
    return '\"$name\"을(를) 제거했어요. 이제 이 키로 Tanooki Auth를 잠금 해제할 수 없어요.';
  }

  @override
  String get securityExtrasKeysTitle => '보안 키';

  @override
  String securityExtrasKeysIntro(String usual) {
    return '보안 키(YubiKey 등)로 $usual 대신 Tanooki Auth를 잠금 해제할 수 있어요. 보안 키 안에는 절대 밖으로 나가지 않는 비밀 정보가 있고, 앱은 이걸로 계정 키를 잠가 둬요. 보안 키를 잃어버려도 평소 방법으로 잠금 해제할 수 있어요.';
  }

  @override
  String securityExtrasKeyAddedOn(String day) {
    return '$day에 추가됨';
  }

  @override
  String get securityExtrasLockOffNote =>
      '앱 잠금이 꺼져 있어서 앱이 묻지 않고 열려요. 키를 쓰려면 설정에서 \"앱 잠금\"이나 암호를 켜세요.';

  @override
  String get securityExtrasLockWordWindows => 'Windows Hello 또는 암호';

  @override
  String get securityExtrasLockWordMac => 'Touch ID 또는 암호';

  @override
  String get securityExtrasLockWordOther => 'Face ID 또는 암호';

  @override
  String get securityLockImmediately => '즉시';

  @override
  String get securityLockAfter30s => '30초 후';

  @override
  String get securityLockAfter1m => '1분 후';

  @override
  String get securityLockAfter5m => '5분 후';

  @override
  String get securityNumbersOnly => '숫자만 사용하세요.';

  @override
  String securityAtLeastNumbers(int count) {
    return '숫자를 $count개 이상 사용하세요.';
  }

  @override
  String get securitySameNumber => '같은 숫자를 반복해서 쓰지 마세요.';

  @override
  String get securityNumbersInRow => '123456처럼 연속된 숫자는 쓰지 마세요.';

  @override
  String get securityPanicNeedsPasscode =>
      '먼저 앱 암호를 설정하세요. 긴급 삭제는 틀린 암호 횟수를 세요.';

  @override
  String get securityPanicNeedsBackup =>
      '먼저 백업을 만드세요 (설정 > 백업 내보내기). 긴급 삭제는 모든 계정을 지우기 때문에, 최근 30일 안에 백업을 만든 경우에만 켤 수 있어요.';

  @override
  String get securityKeyDefaultName => '보안 키';

  @override
  String get securityKeyNotYours => '이 기기의 Tanooki Auth에 추가한 보안 키가 아니에요.';

  @override
  String get securityKeyNotAvailable => '이 기기에서는 아직 쓸 수 없어요.';

  @override
  String get securityKeyWindowsTooOld =>
      '이 버전의 Windows에서는 아직 쓸 수 없어요. 최신 Windows 11 업데이트를 설치하세요.';

  @override
  String get securityKeyIosTooOld =>
      'iOS 26.4 이상이 필요해요. 설정 앱에서 업데이트한 다음 다시 시도해 주세요.';

  @override
  String get securityKeyMacTooOld =>
      'macOS 26.4 이상이 필요해요. 설정 앱에서 업데이트한 다음 다시 시도해 주세요.';

  @override
  String get securityKeyDidntWork => '보안 키가 작동하지 않았어요. 다시 시도해 주세요.';

  @override
  String securityKeyDidntWorkWhy(String reason) {
    return '보안 키가 작동하지 않았어요 ($reason). 다시 시도해 주세요.';
  }

  @override
  String get securityKeyCanceled => '취소했어요. 바뀐 건 없어요.';

  @override
  String get securityKeyNoPrf =>
      '이 보안 키는 이런 방식으로 앱을 잠금 해제할 수 없어요 (\"hmac-secret\" 기능이 없어요). YubiKey 5 시리즈와 최근 몇 년 사이에 나온 대부분의 FIDO2 키는 이 기능이 있어요.';

  @override
  String get securityKeyNotAllowed =>
      '보안 키가 응답하지 않았거나, 여기에 추가한 키가 아니에요. 키를 연결하고(또는 휴대폰 윗부분에 대고) 깜빡이면 터치하세요.';

  @override
  String get securityKeyNotAssociated =>
      '이 Tanooki Auth는 아직 보안 키를 쓸 수 없어요. Apple에서 먼저 앱을 auth.tanookistudios.com과 연결해야 해요. 이건 저희 쪽 문제이고, 내 잘못이 아니에요.';

  @override
  String get securityKeyExists => '이 보안 키는 이미 추가되어 있어요.';

  @override
  String get securityKeyPin =>
      '보안 키에 PIN이 필요한데 입력되지 않았어요. 다시 시도하고, 안내가 나오면 키의 PIN을 입력하세요.';

  @override
  String get securityKeyVaultKeyMissing =>
      '계정을 잠금 해제하는 키가 없어서 보안 키를 추가할 수 없어요.';

  @override
  String get securityKeyNoneAdded => '이 기기에 추가된 보안 키가 없어요.';

  @override
  String get securityKeyBeforeReset =>
      '이 보안 키는 계정이 초기화되기 전에 추가되어서 계정을 열 수 없어요. 제거한 다음 다시 추가하세요.';

  @override
  String get backupUiChoosePassphrase => '백업 암호 문구 정하기';

  @override
  String get backupUiPassphraseTitle => '백업 암호 문구';

  @override
  String get backupUiPassphraseWarning =>
      '백업을 복원할 때 필요해요. 잊어버리면 저희를 포함해 아무도 복구할 수 없어요. 안전한 곳에 적어 두세요.';

  @override
  String get backupUiPassphrase => '암호 문구';

  @override
  String get backupUiTypeAgain => '한 번 더 입력';

  @override
  String get backupUiTooShort => '8자 이상 입력하세요. 아무 단어나 몇 개 이어 쓰면 좋아요.';

  @override
  String get backupUiNoMatch => '두 암호 문구가 일치하지 않아요.';

  @override
  String get backupUiTypePassphrase => '암호 문구를 입력하세요.';

  @override
  String get backupUiNothingToBackUp => '아직 백업할 계정이 없어요.';

  @override
  String get backupUiEncrypting => '백업을 암호화하는 중…';

  @override
  String backupUiSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개를 백업했어요.',
    );
    return '$_temp0';
  }

  @override
  String get backupUiNotABackup => 'Tanooki Auth 백업 파일이 아니에요.';

  @override
  String get backupUiUnlocking => '백업을 잠금 해제하는 중…';

  @override
  String backupUiImported(int count) {
    return '$count개를 가져왔어요.';
  }

  @override
  String backupUiImportedSkipped(int added, int skipped) {
    return '$added개를 가져오고, $skipped개를 건너뛰었어요.';
  }

  @override
  String backupUiImportedSkippedAlready(int added, int skipped) {
    return '$added개를 가져오고, 이미 목록에 있는 $skipped개를 건너뛰었어요.';
  }

  @override
  String backupUiAdded(int count) {
    return '$count개를 추가했어요.';
  }

  @override
  String backupUiAddedSkipped(int added, int skipped) {
    return '$added개를 추가하고, $skipped개를 건너뛰었어요.';
  }

  @override
  String backupUiAddedSkippedAlready(int added, int skipped) {
    return '$added개를 추가하고, 이미 목록에 있는 $skipped개를 건너뛰었어요.';
  }

  @override
  String backupUiAlreadyInList(int count) {
    return '• $count개는 이미 목록에 있어요';
  }

  @override
  String get backupUiImport => '가져오기';

  @override
  String backupUiImportFromGoogle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Google Authenticator에서 $count개를 가져올까요?',
    );
    return '$_temp0';
  }

  @override
  String get backupUiGoogleMoreCodes =>
      'Google Authenticator에 QR 코드가 여러 개 표시됐다면 하나씩 모두 스캔하세요.';

  @override
  String get backupUiNothingToExport => '아직 내보낼 계정이 없어요.';

  @override
  String get backupUiPlainWhat => '다른 인증 앱으로 옮길 수 있도록 모든 설정 키를 일반 텍스트로 저장해요.';

  @override
  String get backupUiPlainTitle => '암호화하지 않고 내보낼까요?';

  @override
  String backupUiPlainBody(String what) {
    return '$what 이 파일을 손에 넣은 사람은 누구나 내 로그인 코드를 만들 수 있어요. 가져온 다음 바로 삭제하세요. 일반 백업이 필요하면 \"백업 내보내기\"를 사용하세요.';
  }

  @override
  String get backupUiUnderstandExport => '이해했어요, 내보낼게요';

  @override
  String get backupUiNothingToPrint => '아직 인쇄할 계정이 없어요.';

  @override
  String get backupUiPaperTitle => '종이 백업을 인쇄할까요?';

  @override
  String get backupUiPaperBody =>
      '모든 계정의 QR 코드와 사용하지 않은 복구 코드가 담긴 PDF를 만들어요. 그 종이를 보거나 사진을 찍은 사람은 누구나 내 휴대폰이나 비밀번호 없이 영원히 내 로그인 코드를 만들 수 있어요.\n\n인쇄한 다음 PDF는 삭제하세요. 종이는 금고나 중요한 서류와 함께, 잠긴 곳에 보관하세요. 이메일로 보내거나 공유 폴더에 저장하지 마세요.';

  @override
  String get backupUiUnderstandPdf => '이해했어요, PDF 만들기';

  @override
  String get backupUiMakingPdf => 'PDF를 만드는 중…';

  @override
  String get backupUiPdfReady => 'PDF가 준비되었어요. 인쇄한 다음 파일을 삭제하세요.';

  @override
  String get backupUiWorksTitle => '백업이 정상이에요';

  @override
  String backupUiWorksBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '이 백업은 잘 열리고 계정이 $count개 들어 있어요. 추가되거나 바뀐 건 없어요.',
    );
    return '$_temp0';
  }

  @override
  String get backupWrongVersion =>
      '이 백업은 더 새로운 버전의 Tanooki Auth로 만들어졌어요. 앱을 업데이트하고 다시 시도해 주세요.';

  @override
  String get backupWrongPassphrase => '암호 문구가 틀렸거나 백업 파일이 손상되었어요.';

  @override
  String get backupDamaged => '백업은 잠금 해제됐지만 내용이 손상되었어요.';

  @override
  String get paperBackupTitle => 'Tanooki Auth 종이 백업';

  @override
  String paperBackupHeader(String date) {
    return 'Tanooki Auth 종이 백업, $date';
  }

  @override
  String get paperBackupWarning =>
      '절대 남에게 보여 주지 마세요. 이 종이를 가진 사람은 누구나 내 로그인 코드를 만들 수 있어요. 잠긴 곳에 보관하고, 새로 만들면 이 종이는 파쇄하세요. 복원 방법: 아무 인증 앱에서 \"QR 코드 스캔\"을 선택하고 아래 코드를 하나씩 스캔하세요.';

  @override
  String paperBackupSetupKey(String key) {
    return '설정 키: $key';
  }

  @override
  String get paperBackupRecoveryCodes => '복구 코드 (각각 한 번만 쓸 수 있어요):';

  @override
  String get autoBackupUiChooseFolderDialog => '자동 백업 폴더 선택';

  @override
  String autoBackupUiToday(String time) {
    return '오늘 $time';
  }

  @override
  String autoBackupUiYesterday(String time) {
    return '어제 $time';
  }

  @override
  String autoBackupUiOnDay(String date, String time) {
    return '$date $time';
  }

  @override
  String get autoBackupUiBackingUp => '백업하는 중…';

  @override
  String autoBackupUiBackedUp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개를 백업했어요.',
    );
    return '$_temp0';
  }

  @override
  String get autoBackupUiCouldntUseFolder => '그 폴더를 사용할 수 없어요.';

  @override
  String autoBackupUiCouldntUseFolderWhy(String reason) {
    return '그 폴더를 사용할 수 없어요. $reason';
  }

  @override
  String get autoBackupUiTurnOffTitle => '자동 백업을 끌까요?';

  @override
  String get autoBackupUiTurnOffBody =>
      '폴더에 있는 백업은 그대로 남아요. 백업 암호 문구는 잊히기 때문에, 다시 켜면 새로 정해야 해요.';

  @override
  String get autoBackupUiTitle => '자동 백업';

  @override
  String get autoBackupUiTitlePremium => '자동 백업 (Premium)';

  @override
  String autoBackupUiIntro(int count) {
    return 'Tanooki Auth가 하루에 한 번, 직접 고른 폴더에 암호화된 백업을 저장해요. iCloud Drive, Google Drive, Dropbox 폴더를 고르면 백업이 이 기기 밖에도 보관돼요. 가장 최근 백업 $count개만 남기고, 오래된 백업은 삭제해요.\n\n복원하려면 설정 > 백업 가져오기에서 백업 암호 문구를 입력하세요.';
  }

  @override
  String get autoBackupUiLastFailed => '마지막 자동 백업이 실패했어요';

  @override
  String get autoBackupUiChooseFolder => '폴더 선택';

  @override
  String get autoBackupUiBackupFolder => '백업 폴더';

  @override
  String get autoBackupUiNoBackupYet => '아직 백업 없음';

  @override
  String autoBackupUiLastBackup(String when) {
    return '마지막 백업: $when';
  }

  @override
  String get autoBackupUiBackUpNow => '지금 백업';

  @override
  String get autoBackupUiChangeFolder => '폴더 변경';

  @override
  String get autoBackupUiOffSubtitle =>
      '꺼짐. 매일 iCloud Drive, Google Drive, Dropbox 또는 원하는 폴더에 암호화된 백업을 저장해요.';

  @override
  String autoBackupUiOnNoBackup(String folder) {
    return '켜짐, $folder에 저장. 아직 백업 없음.';
  }

  @override
  String autoBackupUiOnLast(String folder, String when) {
    return '켜짐, $folder에 저장. 마지막 백업: $when.';
  }

  @override
  String get autoBackupFolderGone =>
      '백업 폴더가 없어졌어요. 삭제되었거나, 앱 밖에서 이름이 바뀌었거나, 드라이브 연결이 끊겼을 수 있어요. 폴더를 다시 선택하세요.';

  @override
  String get autoBackupPermissionLost =>
      'Tanooki Auth가 더 이상 백업 폴더에 쓸 수 없어요. 폴더를 다시 선택해서 권한을 다시 주세요.';

  @override
  String get autoBackupDiskFull =>
      '백업 폴더가 있는 드라이브가 가득 찼어요. 공간을 확보한 다음 \'지금 백업\'을 탭하세요.';

  @override
  String get autoBackupOther => '백업을 저장하지 못했어요. \'지금 백업\'을 탭해서 다시 시도하세요.';

  @override
  String autoBackupOtherWhy(String reason) {
    return '백업을 저장하지 못했어요 ($reason). \'지금 백업\'을 탭해서 다시 시도하세요.';
  }

  @override
  String get importUiDeleteNote =>
      '다 끝나면 내보낸 파일을 삭제하세요. 이 파일을 손에 넣은 사람은 누구나 내 코드를 만들 수 있어요.';

  @override
  String get importUiStepsAegis =>
      'Android 휴대폰의 Aegis에서:\n\n1. ⋮를 탭하고 설정, \"가져오기 및 내보내기\"를 차례로 탭하세요.\n2. \"내보내기\"를 탭하고 \"Aegis (.JSON)\"를 선택하세요.\n3. 원하면 \"보관함 암호화\"를 켠 채로 두세요. 그 비밀번호를 여기서 입력하게 돼요.\n4. 이 기기에서 열 수 있는 곳에 파일을 저장하세요 (예: Google Drive, 또는 나에게 이메일로 보내기).\n\n그다음 여기서 그 파일을 선택하세요.';

  @override
  String get importUiStepsTwoFas =>
      '2FAS에서:\n\n1. 설정을 열고 \"2FAS 백업\"을 탭하세요.\n2. \"파일로 내보내기\"를 탭하세요. 비밀번호를 물어보면, 같은 비밀번호를 여기서 입력하게 돼요.\n3. 이 기기에서 열 수 있는 곳에 .2fas 파일을 저장하세요.\n\n그다음 여기서 그 파일을 선택하세요.';

  @override
  String get importUiStepsAuthy =>
      'Authy에는 내보내기 버튼이 없고, 컴퓨터용 Authy는 2024년에 서비스가 종료되었어요.\n\n\"authy-export\" 같은 도구로 이미 계정을 꺼냈다면, 그 도구가 만든 파일(.json 파일이나 otpauth:// 링크가 담긴 .txt 목록)을 선택하세요.\n\n그렇지 않다면 계정을 하나씩 옮기는 게 안전해요. 각 웹사이트에 로그인해서 2단계 로그인을 껐다가 다시 켜고, 새 QR 코드를 Tanooki Auth로 스캔하세요. 모든 계정이 여기서 작동할 때까지 Authy는 지우지 마세요.';

  @override
  String get importUiStepsBitwarden =>
      'Bitwarden(웹사이트 또는 데스크톱 앱)에서:\n\n1. 도구로 가서 \"보관함 내보내기\"를 선택하세요.\n2. \".json\" 또는 \".csv\"를 선택하세요. \"암호화됨\"은 선택하지 마세요.\n3. 파일을 저장하세요.\n\n그다음 여기서 그 파일을 선택하세요. 인증 키가 있는 로그인만 가져오고, 비밀번호는 무시해요.';

  @override
  String get importUiStepsOnePassword =>
      'Mac 또는 Windows용 1Password 앱에서:\n\n1. 파일, 내보내기를 차례로 클릭한 다음 계정을 선택하세요.\n2. 형식으로 \"CSV\"를 선택하고 저장하세요.\n\n그다음 여기서 그 파일을 선택하세요. 일회용 비밀번호가 있는 항목만 가져오고, 비밀번호는 무시해요.';

  @override
  String get importUiStepsApple =>
      '이 작업에는 Mac이 필요해요. iPhone에서는 파일을 저장할 수 없어요.\n\nmacOS Sequoia 이상인 Mac에서:\n1. 암호 앱을 여세요.\n2. 메뉴 막대에서 파일을 클릭한 다음 \"모든 암호 내보내기…\"를 클릭하세요.\n3. \"암호 내보내기\"를 클릭하고, 물어보면 Mac 암호를 입력한 다음 파일을 저장하세요.\n\n이전 Mac에서는: Safari를 열고 Safari > 설정 > 암호로 가서 ⋯ 버튼을 클릭하고 \"모든 암호 내보내기…\"를 선택하세요.\n\n그다음 여기서 그 파일을 선택하세요. 확인 코드가 있는 항목만 가져오고, 비밀번호는 무시해요.';

  @override
  String get importUiStepsMicrosoft =>
      'Microsoft Authenticator는 계정을 내보낼 수 없어서 한 번에 옮길 수 없어요.\n\n계정마다:\n1. 컴퓨터에서 그 웹사이트에 로그인하세요.\n2. 보안 또는 2단계 인증 설정을 찾으세요.\n3. 2단계 로그인을 껐다가 다시 켜세요 (또는 \"새 인증 앱 추가\"를 선택하세요).\n4. 새 QR 코드를 Tanooki Auth로 스캔하고, 표시되는 코드를 입력해서 마무리하세요.\n\n모든 계정이 Tanooki Auth에서 작동할 때까지 Microsoft Authenticator는 지우지 마세요. Microsoft 계정 자체도 Tanooki Auth를 쓸 수 있어요. account.microsoft.com의 보안에서 추가하세요.';

  @override
  String get importUiTitle => '다른 앱에서 옮기기';

  @override
  String get importUiCantExport => '내보낼 수 없어요: 계정을 하나씩 옮기는 방법';

  @override
  String get importUiFromExportFile => '내보낸 파일에서';

  @override
  String importUiMoveFrom(String app) {
    return '$app에서 옮기기';
  }

  @override
  String get importUiGotIt => '알겠어요';

  @override
  String get importUiPickFile => '파일 선택';

  @override
  String get importUiCouldntRead => '그 파일을 읽을 수 없어요.';

  @override
  String importUiReading(String app) {
    return '$app에서 내보낸 파일을 읽는 중…';
  }

  @override
  String get importUiNoAccountsInFile => '그 파일에는 2단계 인증 계정이 없어요.';

  @override
  String importUiImportFrom(int count, String app) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$app에서 $count개를 가져올까요?',
    );
    return '$_temp0';
  }

  @override
  String importUiExportPassword(String app) {
    return '$app 내보내기 비밀번호';
  }

  @override
  String get importUiPasswordHint => '내보낼 때 정한 비밀번호';

  @override
  String importersNotAnExport(String app) {
    return '$app에서 내보낸 파일이 아니에요.';
  }

  @override
  String importersLine(String line, String problem) {
    return '$line번째 줄: $problem';
  }

  @override
  String get importersEmpty => '파일이 비어 있어요.';

  @override
  String get importersNotAuthy => 'Authy에서 내보낸 파일이 아니에요.';

  @override
  String get importersAnAccount => '어떤 계정';

  @override
  String importersQuoted(String name) {
    return '\"$name\"';
  }

  @override
  String importersProblemColon(String name, String problem) {
    return '$name: $problem';
  }

  @override
  String importersProblem(String name, String problem) {
    return '$name: $problem';
  }

  @override
  String get importersAegisPassword => '이 Aegis 내보내기 파일은 비밀번호로 보호되어 있어요.';

  @override
  String get importersAegisBiometricOnly =>
      '이 Aegis 내보내기 파일은 파일을 만든 휴대폰에서 지문으로만 열 수 있어요. Aegis에서 다시 내보내고 비밀번호를 선택하세요.';

  @override
  String get importersAegisWrongPassword => '이 Aegis 내보내기 파일의 비밀번호가 틀렸어요.';

  @override
  String get importersAegisDamaged => 'Aegis 내보내기 파일은 잠금 해제됐지만 내용이 손상되었어요.';

  @override
  String get importersNotAegis => 'Aegis에서 내보낸 파일이 아니에요.';

  @override
  String importersUnsupportedType(String type) {
    return 'Tanooki Auth가 지원하지 않는 $type 코드를 사용해요';
  }

  @override
  String get importersNotTwoFas => '2FAS 백업 파일이 아니에요.';

  @override
  String get importersTwoFasPassword => '이 2FAS 백업은 비밀번호로 보호되어 있어요.';

  @override
  String get importersTwoFasDamaged => '이 2FAS 백업이 손상되었어요.';

  @override
  String get importersTwoFasWrongPassword => '이 2FAS 백업의 비밀번호가 틀렸어요.';

  @override
  String get importersBitwardenEncrypted =>
      '이 Bitwarden 내보내기 파일은 암호화되어 있어요. Bitwarden에서 다시 내보내고 \".json\" 형식을 선택하세요 (\"암호화됨\" 아님).';

  @override
  String get importersOnePux =>
      '1Password .1pux 파일인 것 같아요. 1Password에서 다시 내보내고 CSV를 선택하세요.';

  @override
  String importersNoCodeColumn(String app) {
    return '이 파일에는 일회용 코드 열이 없어서, 코드가 들어 있는 $app 내보내기 파일이 아니에요.';
  }

  @override
  String importersCantReadCode(String reason) {
    return 'Tanooki Auth가 읽을 수 없는 일회용 코드가 있어요 ($reason)';
  }

  @override
  String get importersNoSecret => '비밀 키가 없어요';

  @override
  String get importersBadSecret => '비밀 키가 올바르지 않아요';

  @override
  String importersUnsupportedDigits(int count) {
    return 'Tanooki Auth가 지원하지 않는 $count자리 코드를 사용해요';
  }

  @override
  String get importersBadPeriod => '시간 주기가 잘못되었어요';

  @override
  String importersUnsupportedAlgorithm(String algorithm) {
    return 'Tanooki Auth가 지원하지 않는 $algorithm 알고리즘을 사용해요';
  }

  @override
  String get exportUiTitle => '다른 앱으로 옮기기';

  @override
  String get exportUiAegisLocked => 'Aegis, 비밀번호 사용';

  @override
  String get exportUiAegisLockedSub => '가장 안전해요. 가져올 때 Aegis가 비밀번호를 물어봐요.';

  @override
  String get exportUiAegisPlain => 'Aegis, 암호화 안 함';

  @override
  String get exportUiAegisPlainSub => 'Aegis 파일은 읽지만 잠긴 파일은 열지 못하는 앱용이에요.';

  @override
  String get exportUiTwoFasSub => '비밀번호 없는 .2fas 파일이에요.';

  @override
  String get exportUiGoogleSub => 'Google Authenticator로 스캔할 QR 코드예요.';

  @override
  String get exportUiLinks => '설정 링크 (일반 텍스트)';

  @override
  String get exportUiLinksSub => '한 줄에 otpauth:// 링크 하나씩. 다른 어떤 앱에서든 쓸 수 있어요.';

  @override
  String get exportUiConfirmReason => '계정 내보내기';

  @override
  String get exportUiEncryptingAegis => 'Aegis용으로 암호화하는 중…';

  @override
  String get exportUiAegisPlainWhat => '모든 설정 키를 암호화하지 않은 Aegis 파일에 저장해요.';

  @override
  String get exportUiTwoFasWhat => '모든 설정 키를 비밀번호 없는 2FAS 파일에 저장해요.';

  @override
  String get exportUiGoogleTitle => 'Google Authenticator용 QR 코드를 보여 줄까요?';

  @override
  String get exportUiGoogleBody =>
      '다음 화면에 모든 설정 키가 담긴 QR 코드가 표시돼요. 이걸 보거나 사진을 찍은 사람은 누구나 내 로그인 코드를 만들 수 있어요. 남이 보지 않는 곳에서 하세요.\n\nGoogle Authenticator에서: +를 탭하고 \"QR 코드 스캔\"을 탭한 다음, 코드를 하나씩 차례로 스캔하세요.';

  @override
  String get exportUiShowCodes => '코드 보기';

  @override
  String exportUiExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개를 내보냈어요. 다른 앱에서 파일을 가져온 다음 삭제하세요.',
    );
    return '$_temp0';
  }

  @override
  String get exportUiNoneForGoogle => 'Google Authenticator로 옮길 수 있는 계정이 없어요.';

  @override
  String get exportUiScanThisCode => '이 코드를 스캔하세요';

  @override
  String exportUiCodeOf(int n, int total) {
    return '$total개 중 $n번째 코드';
  }

  @override
  String get exportUiNextCode => '다음 코드';

  @override
  String exportUiLeftOut(int count) {
    return '제외됨 ($count). Google Authenticator는 이 코드를 만들 수 없으니 다른 앱에 추가하세요:';
  }

  @override
  String get appIconClassic => '오리지널 블루';

  @override
  String get appIconPink => '파스텔 핑크';

  @override
  String get appIconBlue => '파스텔 블루';

  @override
  String get appIconSpooky => '핼러윈';

  @override
  String get appIconCozy => '겨울';

  @override
  String get appIconSpring => '부활절';

  @override
  String get serverBrowserExtension => '브라우저 확장 프로그램';

  @override
  String get serverBadRequest => 'Tanooki Auth가 그 요청을 이해하지 못했어요.';

  @override
  String get serverLocked => 'Tanooki Auth가 잠겨 있어요. 잠금 해제한 다음 다시 시도해 주세요.';

  @override
  String get serverNotPaired => '이 앱은 Tanooki Auth와 연결되어 있지 않아요.';

  @override
  String get serverNotFound => '그 계정은 더 이상 Tanooki Auth에 없어요.';

  @override
  String get serverRateLimited => '요청이 너무 많아요.';

  @override
  String get serverDenied =>
      '허용되지 않음: 이 계정은 먼저 확인하는 계정인데, Tanooki Auth가 이 계정을 위해 잠금 해제되지 않았어요.';

  @override
  String get serverUnknownScreen => '알 수 없는 화면이에요.';

  @override
  String get serverNoWebsite => '웹사이트가 지정되지 않았어요.';

  @override
  String serverUnknownRequest(String type) {
    return '알 수 없는 요청이에요: \"$type\"';
  }

  @override
  String get serverPairingTimedOut => '연결 시간이 초과되었거나 연결이 닫혔어요. 다시 연결을 시작하세요.';

  @override
  String get serverThreeWrongCodes => '코드를 세 번 틀렸어요. 다시 연결을 시작하세요.';

  @override
  String get serverWrongCode => '코드가 맞지 않아요. Tanooki Auth에 표시된 코드를 확인하세요.';

  @override
  String get serverNoLink => 'otpauth:// 링크를 받지 못했어요.';

  @override
  String get serverAlreadyThere => '그 계정은 이미 Tanooki Auth에 있어요.';

  @override
  String get serverAlreadyThereMany => '그 계정들은 이미 Tanooki Auth에 있어요.';

  @override
  String get autoBackupNotSupported => '이 기기에서는 지원되지 않아요';

  @override
  String homeProveCopy(String name) {
    return '$name의 코드 복사';
  }

  @override
  String homeProveReadAloud(String name) {
    return '$name의 코드 소리 내어 읽기';
  }

  @override
  String homeProveEdit(String name) {
    return '$name 편집';
  }

  @override
  String homeProveShare(String name) {
    return '$name 공유';
  }

  @override
  String homeProveRecoveryCodes(String name) {
    return '$name의 복구 코드 보기';
  }

  @override
  String homeCopied(String name) {
    return '$name 코드를 복사했어요. 30초 뒤에 클립보드가 지워져요.';
  }

  @override
  String get homeEditAccount => '계정 편집';

  @override
  String homeShowQrFor(String name) {
    return '$name의 QR 코드 보기';
  }

  @override
  String homeMovedToTrash(String name) {
    return '$name을(를) 휴지통으로 옮겼어요. 30일 동안 설정에서 복원할 수 있어요.';
  }

  @override
  String get homeUndo => '실행 취소';

  @override
  String homeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개',
    );
    return '$_temp0';
  }

  @override
  String homeAddTagTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개에 태그 추가',
    );
    return '$_temp0';
  }

  @override
  String get homeTagHint => '태그 (예: 업무)';

  @override
  String get homeAddTag => '태그 추가';

  @override
  String homeTagged(int count, String tag) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개에 \"$tag\" 태그를 달았어요.',
    );
    return '$_temp0';
  }

  @override
  String homeMoveToFolderTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개를 폴더로 옮기기',
    );
    return '$_temp0';
  }

  @override
  String get homeNoFolder => '폴더 없음';

  @override
  String get homeNewFolderHint => '또는 새 폴더 (예: 업무)';

  @override
  String get homeMoveToNewFolder => '새 폴더로 옮기기';

  @override
  String homeTookOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개를 폴더에서 꺼냈어요.',
    );
    return '$_temp0';
  }

  @override
  String homeMovedTo(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개를 $folder(으)로 옮겼어요.',
    );
    return '$_temp0';
  }

  @override
  String homeAddedToFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개를 즐겨찾기에 추가했어요.',
    );
    return '$_temp0';
  }

  @override
  String homeRemovedFromFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개를 즐겨찾기에서 제거했어요.',
    );
    return '$_temp0';
  }

  @override
  String homeBulkTrashed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '계정 $count개를 휴지통으로 옮겼어요. 30일 동안 설정에서 복원할 수 있어요.',
    );
    return '$_temp0';
  }

  @override
  String get homeDoneSelecting => '선택 완료';

  @override
  String get homeTapToSelect => '탭해서 계정 선택';

  @override
  String homeSelectedCount(int count) {
    return '$count개 선택됨';
  }

  @override
  String get homeSelectNone => '선택 해제';

  @override
  String get homeSelectAll => '모두 선택';

  @override
  String get homeAddATag => '태그 추가';

  @override
  String get homeMoveToFolder => '폴더로 옮기기';

  @override
  String get homeRemoveFromFavorites => '즐겨찾기에서 제거';

  @override
  String get homeAddToFavorites => '즐겨찾기에 추가';

  @override
  String get homeMoveToTrash => '휴지통으로 옮기기';

  @override
  String get homeSelectFirst => '먼저 목록에서 계정을 탭해서 선택하세요.';

  @override
  String homeSectionOpen(String name, String accounts) {
    return '$name, $accounts, 탭해서 접기';
  }

  @override
  String homeSectionClosed(String name, String accounts) {
    return '$name, $accounts, 탭해서 펼치기';
  }

  @override
  String get homeSearchHint => '계정 또는 웹사이트 검색…';

  @override
  String get homeAllTags => '전체';

  @override
  String get homeNoAccountsYet => '아직 계정이 없어요.\n계정을 추가해서 설정 QR 코드를 스캔하세요.';

  @override
  String get homeNoTagMatches => '이 태그가 달린 계정이 없어요.';

  @override
  String get homeNoSearchMatches => '검색과 일치하는 계정이 없어요.';

  @override
  String get homeSelectAccounts => '계정 선택';

  @override
  String get homeSettings => '설정';

  @override
  String get homeAddAccount => '계정 추가';

  @override
  String get homeAccounts => '계정';

  @override
  String get homeYourAccounts => '내 계정';

  @override
  String get homeSelect => '선택';

  @override
  String get homeKeysTouch => '탭 (복사) · Enter (복사) · 화살표 (이동)';

  @override
  String get homeKeysClick => '클릭 (복사) · Enter (복사) · 화살표 (이동)';

  @override
  String get homePickOnLeft => '왼쪽에서 계정을 선택하면 여기에 표시돼요.';

  @override
  String homeQrFor(String name) {
    return '$name의 QR 코드';
  }

  @override
  String get homeQrWarning =>
      '다른 인증 앱으로 이걸 스캔하면 그 앱에도 같은 계정이 추가돼요. 이걸 보거나 사진을 찍은 사람은 누구나 내 코드를 만들 수 있으니, 남에게 보여 주지 마세요.';

  @override
  String homeVersionNote(Object version) {
    return 'v$version · 이 기기에만 저장돼요';
  }

  @override
  String homeSelectName(String name) {
    return '$name 선택';
  }

  @override
  String get homeMore => '더 보기';

  @override
  String get homeRecoveryCodes => '복구 코드';

  @override
  String homeRecoveryCodesLeft(int count) {
    return '복구 코드 ($count개 남음)';
  }

  @override
  String get homeShareSecurely => '안전하게 공유';

  @override
  String get homeShowQr => 'QR 코드 보기';

  @override
  String get homeMoveEarlier => '앞으로 옮기기';

  @override
  String get homeMoveLater => '뒤로 옮기기';

  @override
  String homeNextCodeShort(String code) {
    return '다음 $code';
  }

  @override
  String get homeNextCode => '다음 코드';

  @override
  String get homeFavorite => '즐겨찾기';

  @override
  String get homeCodeHiddenAsk => '본인 확인 전까지 코드가 숨겨져 있어요';

  @override
  String get homeCodeHidden => '코드 숨겨짐';

  @override
  String homeNextCodeSpoken(String code) {
    return '다음 코드 $code';
  }

  @override
  String homeKindTotp(int count, int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count자리',
    );
    return 'TOTP · $_temp0 · $seconds초';
  }

  @override
  String homeKindSteam(int seconds) {
    return 'Steam · 5자 · $seconds초';
  }

  @override
  String homeKindHotp(int count, String counter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count자리',
    );
    return 'HOTP · $_temp0 · #$counter';
  }

  @override
  String get homeAccountHeading => '계정';

  @override
  String get homeHintUnselect => '선택 해제';

  @override
  String get homeHintSelect => '선택';

  @override
  String get homeHintCopy => '코드 복사';

  @override
  String get homeReadCodeAloud => '코드 소리 내어 읽기';

  @override
  String get homeMoreOptions => '더 많은 옵션';

  @override
  String get mainPairRaycastTitle => 'Raycast와 연결';

  @override
  String get mainPairRaycastBody => 'Raycast에 이 코드를 입력하세요:';

  @override
  String get mainPairRaycastWarning => '방금 직접 Raycast에서 연결을 시작한 경우에만 진행하세요.';

  @override
  String get mainPairAlfredTitle => 'Alfred와 연결';

  @override
  String get mainPairAlfredBody => 'Alfred에 2fa-pair와 이 코드를 입력하세요:';

  @override
  String get mainPairAlfredWarning => '방금 직접 Alfred에 2fa-pair를 입력한 경우에만 진행하세요.';

  @override
  String get mainPairPowerToysTitle => 'PowerToys와 연결';

  @override
  String get mainPairPowerToysBody => 'PowerToys 명령 팔레트에 이 코드를 입력하세요:';

  @override
  String get mainPairPowerToysWarning =>
      '방금 직접 PowerToys에서 연결을 시작한 경우에만 진행하세요.';

  @override
  String get mainPairBrowserTitle => '브라우저와 연결';

  @override
  String get mainPairBrowserBody => 'Tanooki Auth 브라우저 확장 프로그램에 이 코드를 입력하세요:';

  @override
  String get mainPairBrowserWarning =>
      '방금 직접 확장 프로그램에서 \"연결\"을 클릭한 경우에만 진행하세요.';

  @override
  String mainSendCodeTo(String name, String client) {
    return '$name의 코드를 $client(으)로 보내기';
  }

  @override
  String mainWrongPasscodeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '암호가 틀렸어요. $count번 더 틀리면 모두 지워져요.',
    );
    return '$_temp0';
  }

  @override
  String get mainWrongPasscode => '암호가 틀렸어요.';

  @override
  String get mainBiometricWindows => 'Windows Hello';

  @override
  String get mainBiometricMac => 'Touch ID';

  @override
  String get mainBiometricOther => 'Face ID 또는 지문';

  @override
  String get mainLockTitle => 'Tanooki Auth를 잠글까요?';

  @override
  String get mainLockBody =>
      '앱을 열 때 얼굴, 지문 또는 암호를 요구해서, 잠금 해제된 휴대폰을 든 사람이 코드를 볼 수 없게 해요. 나중에 설정에서 바꿀 수 있어요.';

  @override
  String get mainTurnOnLock => '잠금 켜기';

  @override
  String get mainUnlockReason => 'Tanooki Auth 잠금 해제';

  @override
  String get mainStartOverTitle => '비어 있는 새 보관함으로 시작할까요?';

  @override
  String get mainStartOverBody =>
      '이전 계정 중 남아 있는 것을 영구적으로 대체해요. 복원할 백업이 없거나, 그 사이트에서 이미 2단계 로그인을 끈 경우에만 진행하세요.';

  @override
  String get mainEraseStartOver => '지우고 새로 시작';

  @override
  String get mainRestoreFromBackup => '백업에서 복원';

  @override
  String get mainStartNewVault => '비어 있는 새 보관함으로 시작';

  @override
  String get mainLocked => 'Tanooki Auth가 잠겨 있어요';

  @override
  String mainUseBiometric(String method) {
    return '$method 사용';
  }

  @override
  String get mainUseSecurityKey => '보안 키 사용';

  @override
  String homeHidesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count초 후 숨겨짐',
    );
    return '$_temp0';
  }

  @override
  String homeCardsMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      'm1': '1월',
      'm2': '2월',
      'm3': '3월',
      'm4': '4월',
      'm5': '5월',
      'm6': '6월',
      'm7': '7월',
      'm8': '8월',
      'm9': '9월',
      'm10': '10월',
      'm11': '11월',
      'm12': '12월',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String homeCardsDay(String month, String day) {
    return '$month $day일';
  }

  @override
  String get homeCardsDenied =>
      '거부했어요. 상대방은 내 계정을 열 수 없어요. 나중에 다시 요청할 수 있고, 그러면 다시 물어볼게요.';

  @override
  String get homeCardsClockRight => '이제 시계가 정확해요. 코드가 잘 작동할 거예요.';

  @override
  String get homeCardsCheckAgain => '다시 확인';

  @override
  String get homeCardsYourContact => '내 긴급 연락처';

  @override
  String homeCardsEmergencyWaiting(String who, String left, String day) {
    return '$who님이 내 계정에 대한 긴급 접근을 요청했어요. 거부하지 않으면 $left 후($day)에 사본을 열 수 있어요.';
  }

  @override
  String homeCardsEmergencyReleased(String who) {
    return '$who님이 긴급 접근을 요청했고 7일 대기 기간이 끝나서, 이제 내 계정 사본을 열 수 있어요. 막으려면 거부하세요.';
  }

  @override
  String get homeCardsBackupNudge =>
      '마지막 백업 이후 계정이 바뀌었어요. 이 기기를 잃어버리면 백업 파일로 계정을 되찾을 수 있어요.';

  @override
  String get homeCardsBackUpNow => '지금 백업';

  @override
  String homeCardsSummaryNew(int count, String month) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$month 요약: 새 계정 $count개.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryNoBackup => '아직 백업이 없어요.';

  @override
  String homeCardsSummaryLastBackup(String day) {
    return '마지막 백업: $day.';
  }

  @override
  String get homeCardsSummaryAllCodes => '모든 계정에 복구 코드가 있어요.';

  @override
  String homeCardsSummaryMissingCodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '복구 코드가 없는 계정 $count개.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryCheckupGood => '보안 점검: 모두 좋아요.';

  @override
  String homeCardsSummaryCheckupFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '보안 점검: 고칠 점 $count개.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsOpenCheckup => '점검 열기';

  @override
  String get quickPickSelf =>
      'Tanooki Auth가 아직 맨 앞에 있어서 아무것도 입력하지 않았어요. 채우고 싶은 입력란을 클릭한 다음, 메뉴 막대 아이콘을 다시 사용하세요.';

  @override
  String quickPickTypeFailed(String reason) {
    return '코드를 입력하지 못했어요 ($reason). 대신 복사하세요.';
  }

  @override
  String get quickPickTypeUnavailable => '이 컴퓨터에서는 코드 입력을 쓸 수 없어요. 대신 복사하세요.';

  @override
  String quickPickUseCodeFor(String name) {
    return '$name의 코드 사용';
  }

  @override
  String get quickPickAllowTitle => 'Tanooki Auth가 입력할 수 있게 허용하기';

  @override
  String get quickPickAllowBody =>
      '다른 앱에 코드를 입력하려면 Mac에서 Tanooki Auth가 대신 키를 누를 수 있게 허용해야 해요.\n\n1. 아래의 \"시스템 설정 열기\"를 클릭하세요.\n2. 손쉬운 사용이라는 목록이 보여요. Tanooki Auth를 찾아서 스위치를 켜세요(파란색).\n3. Mac에서 암호나 Touch ID를 요청하면 입력하세요.\n4. 여기로 돌아와서 \'입력\'을 다시 클릭하세요.\n\nTanooki Auth는 \'입력\'을 클릭했을 때만 키를 누르고, 코드만 입력해요.';

  @override
  String get quickPickOpenSystemSettings => '시스템 설정 열기';

  @override
  String get quickPickTitle => '빠른 선택';

  @override
  String get quickPickSearch => '계정 검색';

  @override
  String get quickPickLinuxNote =>
      'Linux에서는 다른 앱에 코드를 입력할 수 없어요. 계정을 클릭하면 코드가 복사돼요.';

  @override
  String get quickPickNoMatches => '일치하는 계정 없음';

  @override
  String get quickPickAsksFirst => '••• •••  (먼저 확인)';

  @override
  String get quickPickHiddenAsks => '코드 숨겨짐, 먼저 확인';

  @override
  String get quickPickType => '입력';

  @override
  String get codeViewRing => '원형';

  @override
  String get codeViewBar => '막대';

  @override
  String get codeViewNumber => '숫자';

  @override
  String codeViewSpoken(String code) {
    return '코드 $code';
  }

  @override
  String codeViewSpokenLeft(int count, String code) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '코드 $code, $count초 남음',
    );
    return '$_temp0';
  }

  @override
  String get codeViewReadAloud => '코드 소리 내어 읽기';

  @override
  String codeViewSecondsShort(int count) {
    return '$count초';
  }

  @override
  String get codeViewColorBlue => '파란색';

  @override
  String get codeViewColorPurple => '보라색';

  @override
  String get codeViewColorPink => '분홍색';

  @override
  String get codeViewColorRed => '빨간색';

  @override
  String get codeViewColorOrange => '주황색';

  @override
  String get codeViewColorGold => '금색';

  @override
  String get codeViewColorGreen => '초록색';

  @override
  String get codeViewColorTeal => '청록색';

  @override
  String get codeViewColorGray => '회색';

  @override
  String trashRestored(String name) {
    return '$name이(가) 목록으로 돌아왔어요.';
  }

  @override
  String trashDeleteTitle(String name) {
    return '$name을(를) 완전히 삭제할까요?';
  }

  @override
  String get trashDeleteBody =>
      '되돌릴 수 없어요. 삭제하기 전에 그 웹사이트에서 2단계 로그인을 끄거나 복구 코드가 있는지 확인하세요. 그렇지 않으면 로그인하지 못할 수도 있어요.';

  @override
  String get trashDeleteForGood => '완전히 삭제';

  @override
  String get trashTitle => '휴지통';

  @override
  String get trashEmpty => '휴지통이 비어 있어요.\n삭제한 계정은 30일 동안 여기에 보관돼요.';

  @override
  String get trashNote => '삭제한 계정은 30일 동안 여기에 보관된 다음 완전히 삭제돼요.';

  @override
  String get trashRemovedNextOpen => '다음에 앱을 열 때 삭제돼요';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count일 남음',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => '복원';

  @override
  String get recoveryAddTitle => '복구 코드 추가';

  @override
  String get recoveryPasteHint => '웹사이트에서 받은 코드를 한 줄에 하나씩 붙여 넣으세요';

  @override
  String get recoveryNoneNew => '붙여 넣은 내용에서 새 코드를 찾지 못했어요.';

  @override
  String recoveryAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '코드 $count개를 추가했어요.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryCopiedUsed =>
      '복사했어요. 참고로, 이 코드는 사용함으로 표시해 두어서 다시 작동하지 않을 수 있어요.';

  @override
  String get recoveryCopied => '복사했어요. 30초 뒤에 클립보드가 지워져요. 로그인한 다음 사용함으로 표시하세요.';

  @override
  String get recoveryRemoveTitle => '이 코드를 제거할까요?';

  @override
  String recoveryRemoveBody(String code) {
    return '$code\n\n웹사이트에서 더 이상 받지 않는 경우에만 제거하세요.';
  }

  @override
  String recoveryTitle(String name) {
    return '$name 복구 코드';
  }

  @override
  String get recoveryAddCodes => '코드 추가';

  @override
  String get recoveryIntro =>
      '2단계 로그인을 켜면 대부분의 웹사이트에서 백업 코드 목록도 함께 줘요. 이 앱을 잃어버렸을 때 코드 하나로 한 번 로그인할 수 있어요. 여기에 붙여 넣으면 계정과 함께 안전하게 보관돼요.';

  @override
  String recoveryUnusedOf(String unused, int total) {
    return '$total개 중 $unused개 미사용. 코드를 탭하면 복사되고, 사용한 다음에는 체크하세요.';
  }

  @override
  String get recoveryUsed => '사용함';

  @override
  String get detailsEditAccount => '계정 편집';

  @override
  String get detailsCopyCode => '코드 복사';

  @override
  String get detailsReadAloud => '소리 내어 읽기';

  @override
  String get detailsFolderAndTags => '폴더 및 태그';

  @override
  String get detailsWebsites => '웹사이트';

  @override
  String get detailsNotes => '메모';

  @override
  String get detailsNotesHidden => '본인 확인 전까지 숨겨져 있어요.';

  @override
  String get detailsNoNotes => '메모가 없어요. \'편집\'에서 추가하세요.';

  @override
  String get accountSortCustom => '사용자 지정 (끌어서 정렬)';

  @override
  String get accountSortRecent => '최근 사용순';

  @override
  String get accountSortName => '가나다순';

  @override
  String get activityCopied => '복사함';

  @override
  String get activityFilled => '채움';

  @override
  String get activityTyped => '입력함';

  @override
  String get activityShownQr => 'QR 코드 보여 줌';

  @override
  String get activityExported => '내보냄';

  @override
  String get activityPlaceThisApp => '이 앱';

  @override
  String get activityPlaceBackupFile => '백업 파일';

  @override
  String get activityPlaceSetupLinks => '설정 링크 파일';

  @override
  String get activityPlacePaperBackup => '종이 백업 PDF';

  @override
  String get activityPlaceGoogleQr => 'Google Authenticator QR 코드';

  @override
  String totpBadCharacter(String char) {
    return '올바른 base32 비밀 키가 아니에요 (잘못된 문자 \"$char\")';
  }

  @override
  String get totpEmpty => '비밀 키가 비어 있어요';

  @override
  String get vaultFileMissing =>
      '계정 파일이 없어요. 백업이 있다면 복원하세요. 없다면 비어 있는 새 보관함으로 시작할 수 있어요.';

  @override
  String get vaultKeyMissing =>
      '계정을 잠금 해제하는 키가 이 기기의 보안 저장소에 없어요. 계정을 되찾으려면 백업을 복원하세요.';

  @override
  String get vaultDecryptFailed =>
      '계정 파일을 잠금 해제할 수 없어요. 손상되었거나 앱 밖에서 바뀌었을 수 있어요. 백업을 복원하세요.';

  @override
  String get vaultBadJson => '계정 파일은 잠금 해제됐지만 내용이 손상되었어요. 백업을 복원하세요.';

  @override
  String clockCheckBadAnswer(String status) {
    return '시간 서버가 앱이 이해할 수 없는 응답을 보냈어요 (HTTP $status).';
  }

  @override
  String clockCheckOff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '기기 시계가 약 $count분 틀려서 코드가 작동하지 않아요. 설정에서 자동 시간 설정을 켜세요.',
    );
    return '$_temp0';
  }

  @override
  String backupUiBullet(String item) {
    return '• $item';
  }

  @override
  String backupUiAccountWithLabel(String title, String label) {
    return '$title ($label)';
  }

  @override
  String exportUiLeftOutLine(String account, String reason) {
    return '• $account: $reason';
  }

  @override
  String get keysTitle => '키보드 단축키';

  @override
  String get keysWhere => '계정 목록과 빠른 선택에서 쓸 수 있어요.';

  @override
  String get keysMove => '목록에서 위아래로 이동';

  @override
  String get keysEnter => 'Enter';

  @override
  String get keysCopy => '선택한 코드 복사';

  @override
  String get keysAnyLetter => '아무 글자';

  @override
  String get keysSearch => '검색 시작';

  @override
  String get keysEsc => 'Esc';

  @override
  String get keysClear => '검색 지우기';

  @override
  String get keysShowList => '이 목록 보기';

  @override
  String get settingsKeysShortcutMac => '어디서든 ⌘/를 누르면 볼 수 있어요';

  @override
  String get settingsKeysShortcutOther => '어디서든 Ctrl+/를 누르면 볼 수 있어요';

  @override
  String trayTooltip(String name, int seconds) {
    return 'Tanooki Auth: $name, $seconds초 남음';
  }

  @override
  String get settingsTrayCountdownMac => '메뉴 막대에 카운트다운 표시';

  @override
  String get settingsTrayCountdownMacHelp =>
      '첫 번째 즐겨찾기의 남은 시간(초)을 메뉴 막대 아이콘 옆에 보여 줘요. 코드 자체는 절대 표시하지 않아요.';

  @override
  String get settingsTrayCountdownWindows => '트레이 아이콘에 카운트다운 표시';

  @override
  String get settingsTrayCountdownWindowsHelp =>
      '시계 옆의 Tanooki Auth 아이콘에 마우스를 올리면 첫 번째 즐겨찾기의 남은 시간(초)을 볼 수 있어요. 코드 자체는 절대 표시하지 않아요.';

  @override
  String get unusedTitle => '쓰지 않는 계정';

  @override
  String get settingsUnusedHelp => '6개월 이상 코드를 복사하지 않은 계정';

  @override
  String get unusedIntro =>
      '이 계정들은 6개월 이상 이 앱에서 코드를 복사하지 않았어요. 더 이상 그 웹사이트를 쓰지 않는다면, 먼저 거기서 2단계 로그인을 끈 다음 여기서 정리하세요. 휴지통에 30일 동안 보관돼요.';

  @override
  String get unusedNone => '모든 계정을 최근 6개월 안에 사용했어요. 정리할 게 없어요.';

  @override
  String unusedLastUsed(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '마지막 사용: $dateString';
  }

  @override
  String unusedNeverUsed(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '여기서 한 번도 사용하지 않음. $dateString에 추가됨';
  }

  @override
  String get unusedPickFirst => '먼저 계정을 하나 이상 체크하세요.';

  @override
  String get unusedTagSuggestion => '안 씀';

  @override
  String checkupUnusedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '쓰지 않는 계정 $count개',
    );
    return '$_temp0';
  }

  @override
  String get checkupUnusedBody =>
      '6개월 이상 코드를 복사하지 않았어요. 잊어버린 오래된 계정은 누가 침입해도 알아차리기 어려워요.';

  @override
  String get checkupUnusedReview => '살펴보기';

  @override
  String get halvesTitle => '두 부분으로 나눈 종이 백업';

  @override
  String get settingsHalvesHelp => '두 묶음의 페이지. 한쪽만으로는 아무것도 알 수 없어요';

  @override
  String get halvesRestoreTitle => '두 부분에서 복원';

  @override
  String get settingsHalvesRestoreHelp => '종이 백업 두 부분의 코드를 모두 스캔하세요';

  @override
  String get halvesExplain =>
      '암호화된 백업을 A 부분과 B 부분, 두 묶음의 페이지로 나눠서 인쇄해요.\n\n한쪽만으로는 그냥 무작위 데이터일 뿐이라서, 암호 문구가 있어도 아무것도 알아낼 수 없어요. 복원하려면 두 부분과 암호 문구가 모두 필요해요.\n\n두 부분은 서로 다른 곳에 보관하세요. 예를 들어 하나는 집에, 하나는 믿을 수 있는 사람에게 맡기세요.';

  @override
  String get halvesHalfA => 'A 부분 (2개 중)';

  @override
  String get halvesHalfB => 'B 부분 (2개 중)';

  @override
  String halvesPart(String which, int part, int parts) {
    return '$which 부분 · $parts개 중 $part번째';
  }

  @override
  String halvesPdfHeader(String date) {
    return 'Tanooki Auth 종이 백업, $date에 만듦';
  }

  @override
  String get halvesPdfExplain =>
      '이 부분만으로는 쓸모가 없어요. 복원하려면: Tanooki Auth에서 설정 > 두 부분에서 복원을 열고, 두 부분의 코드를 모두 스캔한 다음 백업 암호 문구를 입력하세요. 두 부분은 서로 다른 곳에 보관하세요.';

  @override
  String halvesPdfPage(String half, int page, int pages) {
    return '$half, $pages페이지 중 $page페이지';
  }

  @override
  String get halvesNowB => '이제 B 부분을 저장하세요';

  @override
  String get halvesNowBBody =>
      'A 부분을 저장했어요. B 부분은 나머지 반쪽이에요. 이것도 인쇄해서 다른 곳에 보관하세요.';

  @override
  String get halvesSaveB => 'B 부분 저장';

  @override
  String get halvesOnlyA =>
      'A 부분만 저장되었어요. A 부분만으로는 아무것도 복원할 수 없으니, 준비되면 두 부분을 다시 만드세요.';

  @override
  String get halvesReady => '두 부분이 모두 준비되었어요. 인쇄해서 서로 다른 곳에 보관하세요.';

  @override
  String get halvesRestoreIntro =>
      '두 부분의 코드를 순서와 상관없이 모두 스캔하세요. 둘 다 완료되면 백업을 만들 때 정한 암호 문구를 입력하세요.';

  @override
  String halvesNotStarted(String half) {
    return '$half: 아직 스캔한 코드 없음';
  }

  @override
  String halvesProgress(String half, int have, int total) {
    return '$half: $total개 중 $have개';
  }

  @override
  String get halvesScan => '코드 스캔';

  @override
  String get halvesScanTitle => '두 부분 모두 스캔';

  @override
  String get halvesPictures => '코드 사진 열기';

  @override
  String halvesSomeUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '사진 $count장에서 읽을 수 있는 코드가 없었어요. 코드 하나를 더 가까이에서 찍어 보세요.',
    );
    return '$_temp0';
  }

  @override
  String get halvesNotAHalf => '두 부분 종이 백업의 코드가 아니에요.';

  @override
  String get halvesOtherSet => '다른 종이 백업의 코드예요. 같은 인쇄본의 두 부분을 사용하세요.';

  @override
  String get halvesAlreadyHave => '이미 스캔한 코드예요. 다음 코드로 넘어가세요.';

  @override
  String get halvesDontFit =>
      '두 부분이 서로 맞지 않아요. 코드를 잘못 읽었거나, 서로 다른 백업의 부분일 수 있어요. 처음부터 다시 스캔하세요.';

  @override
  String get halvesRestoreNow => '두 부분 스캔 완료: 복원';

  @override
  String get healthTitle => '상태 확인';

  @override
  String get settingsHealthHelp => '동기화, 백업, 시계, 잠금, 복구 코드를 한 화면에서';

  @override
  String get healthIntro =>
      '초록색은 괜찮다는 뜻이에요. 노란색은 살펴볼 필요가 있고, 버튼을 누르면 고칠 수 있어요.';

  @override
  String get healthGood => '괜찮음';

  @override
  String get healthLook => '살펴보기';

  @override
  String get healthSync => '동기화';

  @override
  String get healthSyncOff => '설정 안 됨. 동기화하면 모든 기기의 계정이 똑같이 유지돼요.';

  @override
  String healthSyncOk(String when) {
    return '마지막 동기화: $when';
  }

  @override
  String healthSyncStale(String when) {
    return '마지막 동기화: $when. 꽤 오래됐어요. 동기화를 열어서 무엇이 문제인지 확인하세요.';
  }

  @override
  String get healthOpenSync => '동기화 열기';

  @override
  String get healthSetUp => '설정';

  @override
  String get healthOpen => '열기';

  @override
  String get healthBackup => '백업';

  @override
  String get healthBackupNever => '아직 백업이 없어요. 이 기기를 잃어버리면 계정도 함께 사라져요.';

  @override
  String healthBackupOk(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '마지막 백업: $dateString';
  }

  @override
  String healthBackupOld(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '마지막 백업: $dateString. 30일이 넘었어요. 새로 만드세요.';
  }

  @override
  String get healthClock => '시계';

  @override
  String get healthClockNotChecked => '아직 확인하지 않았어요. 코드는 이 기기의 시계가 정확해야만 작동해요.';

  @override
  String healthClockOk(String when) {
    return '시계가 정확해요 ($when에 확인).';
  }

  @override
  String get healthCheckNow => '지금 확인';

  @override
  String get healthPhoneLink => '휴대폰 연결';

  @override
  String healthPhoneLinkOk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '브라우저 $count개와 연결됨',
    );
    return '$_temp0';
  }

  @override
  String get healthPhoneLinkOff =>
      '연결 안 됨. 컴퓨터의 브라우저를 연결하면 이 휴대폰에서 로그인 코드를 승인할 수 있어요.';

  @override
  String get healthLock => '잠금';

  @override
  String get healthLockOn => '켜짐. 코드를 보여 주기 전에 본인 확인을 해요.';

  @override
  String get healthLockOff => '꺼짐. 이 기기를 집어 든 사람은 누구나 코드를 볼 수 있어요.';

  @override
  String get healthGoToSettings => '잠금 스위치로 이동';

  @override
  String get healthRecovery => '복구 코드';

  @override
  String healthRecoveryCount(int count, int total) {
    return '계정 $total개 중 $count개에 복구 코드가 저장되어 있어요.';
  }

  @override
  String get healthRecoveryNoAccounts => '아직 계정이 없어요.';

  @override
  String get healthAddCodes => '코드 추가';

  @override
  String get syncErrorWiped =>
      '다른 기기에서 이 기기의 Tanooki Auth를 지웠어요. 이 기기의 모든 데이터가 삭제되었고 동기화에서 빠졌어요.';

  @override
  String get syncUiEraseDevice => '이 기기 지우기';

  @override
  String get syncUiEraseTitle => '이 기기를 지울까요?';

  @override
  String get syncUiEraseBody =>
      '그 기기가 다음에 온라인 상태가 되면, 그 기기의 Tanooki Auth가 계정, 설정, 위젯, 검색 항목 등 모든 것을 삭제해요. 동기화에서도 완전히 빠져요. 되돌릴 수 없어요. 이 기기나 다른 기기에서는 아무것도 바뀌지 않아요.';

  @override
  String get syncUiEraseButton => '지우기';

  @override
  String get syncUiErased => '완료했어요. 그 기기는 다음에 온라인 상태가 되면 스스로 지워져요.';

  @override
  String syncUiClashes(int count) {
    return '동기화 충돌 ($count)';
  }

  @override
  String get syncUiClashesHelp => '동기화되기 전에 두 기기에서 계정이 바뀌었어요. 남길 버전을 선택하세요.';

  @override
  String get syncUiClashTitle => '동기화 충돌';

  @override
  String get syncUiClashIntro =>
      '아래 계정은 동기화되기 전에 두 기기에서 각각 바뀌었어요. 동기화는 나중에 바뀐 내용을 사용했어요. 다른 버전을 원한다면 그 아래의 \'이걸로 유지\'를 탭하세요.';

  @override
  String get syncUiClashNone => '충돌이 없어요. 선택할 게 없어요.';

  @override
  String get syncUiClashInUse => '현재 사용 중';

  @override
  String get syncUiClashOther => '다른 버전';

  @override
  String get syncUiClashKeep => '이걸로 유지';

  @override
  String get syncUiClashKept => '완료했어요. 다른 기기는 다음 동기화 때 이 버전을 받아요.';

  @override
  String syncUiClashEdited(String when) {
    return '$when에 변경됨';
  }

  @override
  String get syncUiClashName => '이름';

  @override
  String get syncUiClashAccount => '계정';

  @override
  String get syncUiClashFolder => '폴더';

  @override
  String get syncUiClashNotes => '메모';

  @override
  String get syncUiClashInTrash => '휴지통에 있음';

  @override
  String get syncUiClashSecret => '설정 키';

  @override
  String get syncUiClashSecretDifferent => '다름';

  @override
  String get syncUiClashYes => '예';

  @override
  String get syncUiClashNo => '아니요';

  @override
  String get syncUiClashOtherDiffers => '모양, 웹사이트, 복구 코드 같은 다른 설정도 달라요.';

  @override
  String get teamRoleAdmin => '관리자';

  @override
  String get teamRoleMember => '멤버';

  @override
  String get teamRoleViewer => '보기 전용';

  @override
  String get teamRoleOwner => '소유자';

  @override
  String get teamUiMakeAdmin => '관리자로 지정';

  @override
  String get teamUiMakeMember => '멤버로 지정';

  @override
  String get teamUiMakeViewer => '보기 전용으로 지정';

  @override
  String get teamUiRoleChanged => '역할을 바꿨어요.';

  @override
  String get teamUiInviteRole => '참여 역할';

  @override
  String get teamUiRoleHelp =>
      '관리자는 사람을 초대하거나 제거하고 활동 기록을 볼 수 있어요. 멤버는 팀 계정을 사용하고 바꿀 수 있어요. 보기 전용 사용자는 계정을 사용할 수는 있지만 바꿀 수는 없어요.';

  @override
  String get teamUiInviteEmailLabel => '상대방의 이메일 (선택)';

  @override
  String get teamUiInviteEmailHint => 'name@example.com';

  @override
  String get teamUiInviteMake => '초대 만들기';

  @override
  String teamUiInviteEmailed(String email) {
    return '$email(으)로 초대를 보냈어요.';
  }

  @override
  String get teamUiEmailNotSetUp =>
      '이메일 보내기가 아직 설정되지 않았어요. 아래 링크를 복사해서 직접 보내 주세요.';

  @override
  String teamUiEmailFailed(String reason) {
    return '이메일을 보내지 못했어요 ($reason). 아래 링크를 복사해서 직접 보내 주세요.';
  }

  @override
  String get teamUiYoureAdmin => '이 팀의 관리자예요';

  @override
  String get teamUiYoureViewer => '팀에 속해 있어요 (보기 전용)';

  @override
  String get teamUiViewOnly => '이 계정들을 사용할 수 있지만, 바꿀 수 있는 건 관리자와 멤버뿐이에요.';

  @override
  String get teamUiActivity => '활동';

  @override
  String get teamUiActivityTitle => '팀 활동';

  @override
  String get teamUiActivityHelp =>
      '누가 언제 팀 계정을 복사하거나 바꿨는지 보여 줘요. 관리자만 볼 수 있어요. 90일 동안, 최근 2,000개 항목까지 보관돼요.';

  @override
  String get teamUiActivityEmpty => '아직 기록이 없어요. 팀 계정의 복사와 변경 내용이 여기에 표시돼요.';

  @override
  String teamActCopy(String name) {
    return '$name의 코드를 복사함';
  }

  @override
  String teamActFill(String name) {
    return '$name의 코드를 채움';
  }

  @override
  String teamActAdd(String name) {
    return '$name 추가함';
  }

  @override
  String teamActEdit(String name) {
    return '$name 변경함';
  }

  @override
  String teamActDelete(String name) {
    return '$name 제거함';
  }

  @override
  String get teamUiBuyBusiness => '비즈니스 요금제: 1인당 1년에 \$3';

  @override
  String get teamUiBusinessSoon =>
      '10명이 넘는 팀을 위한 비즈니스 요금제(1인당 1년에 \$3): 곧 나와요.';

  @override
  String themeCustom(int n) {
    return '내 테마 $n';
  }

  @override
  String get themeMakeOwn => '직접 만들기';

  @override
  String get themeMakeOwnPremium => '테마 직접 만들기, Premium';

  @override
  String get themeEditOwn => '이 테마 편집';

  @override
  String get themeEditorTitle => '내 테마';

  @override
  String get themeEditorAccent => '강조 색상';

  @override
  String get themeEditorBackground => '배경';

  @override
  String get themeEditorCard => '카드';

  @override
  String get themeEditorText => '텍스트';

  @override
  String get themeEditorHue => '색조';

  @override
  String themeEditorSwatch(String hex) {
    return '색상 $hex';
  }

  @override
  String get themeEditorPreview => '미리보기';

  @override
  String get themeEditorSample => '예시 계정';

  @override
  String get themeEditorSampleHint => '탭해서 복사';

  @override
  String get themeEditorSave => '테마 저장';

  @override
  String get themeEditorDelete => '테마 삭제';

  @override
  String get themeEditorAdjusted => '텍스트와 버튼이 잘 읽히도록 일부 색상을 조정했어요.';

  @override
  String get themeEditorUnreadable =>
      '이 색상들로는 읽기 쉽게 만들 수 없어요. 카드 색상을 배경에 더 가깝게 해 보세요.';

  @override
  String get themeEditorFull => '이미 테마가 3개 있어요. 새로 만들려면 하나를 삭제하세요.';

  @override
  String get settingsSeasonal => '계절에 따라 바꾸기';

  @override
  String get settingsSeasonalPremium => '계절에 따라 바꾸기 (Premium)';

  @override
  String get settingsSeasonalHelp =>
      '가을에는 으스스, 겨울에는 포근, 봄에는 봄 테마로 바뀌고, 여름에는 내가 고른 테마를 써요. 계절 앱 아이콘도 함께 바뀌어요.';

  @override
  String get helpNew040a => 'iPhone과 Android에서 자동 완성으로 코드를 입력하세요.';

  @override
  String get helpNew040b => 'QR 이미지를 앱으로 공유해 계정을 추가하세요. Mac에서는 창에 끌어다 놓으면 됩니다.';

  @override
  String get helpNew040c =>
      '컴퓨터에서 화살표 키, Enter, 단축키 목록(⌘/ 또는 Ctrl+/), 메뉴 막대 카운트다운을 쓸 수 있어요.';

  @override
  String get helpNew040d => '쓰지 않는 계정을 찾고, 종이 백업을 두 부분으로 나눠 인쇄하세요.';

  @override
  String get helpNew040e => '새로운 상태 점검 화면.';

  @override
  String get helpNew040f => '잃어버린 기기를 다른 기기에서 지우고, 동기화 충돌을 해결하세요.';

  @override
  String get helpNew040g => '팀 역할, 팀 활동 기록, 이메일 초대, 비즈니스 요금제(곧 제공).';

  @override
  String get helpNew040h => '나만의 테마, 계절 테마, Apple Watch 스마트 스택 위젯.';

  @override
  String get helpNew040i => '언어 5개 추가: 포르투갈어, 이탈리아어, 한국어, 중국어, 네덜란드어.';

  @override
  String get appIconGroupColors => '색상';

  @override
  String get appIconGroupHolidays => '기념일';

  @override
  String get appIconGroupPride => '프라이드';

  @override
  String get appIconHotpink => '핑크';

  @override
  String get appIconRed => '레드';

  @override
  String get appIconOrange => '오렌지';

  @override
  String get appIconGold => '골드';

  @override
  String get appIconGreen => '그린';

  @override
  String get appIconCyan => '시안';

  @override
  String get appIconPurple => '퍼플';

  @override
  String get appIconMonochrome => '모노크롬';

  @override
  String get appIconBlackgold => '블랙 앤 골드';

  @override
  String get appIconSummer => '여름';

  @override
  String get appIconThanksgiving => '추수감사절';

  @override
  String get appIconChristmas => '크리스마스';

  @override
  String get appIconValentines => '밸런타인데이';

  @override
  String get appIconStpatricks => '성 패트릭의 날';

  @override
  String get appIconIndependence => '독립기념일';

  @override
  String get appIconRainbow => '레인보우';

  @override
  String get appIconProgress => '프로그레스';

  @override
  String get appIconTransgender => '트랜스젠더';

  @override
  String get appIconLesbian => '레즈비언';

  @override
  String get appIconBisexual => '바이섹슈얼';

  @override
  String get appIconPansexual => '팬섹슈얼';

  @override
  String get appIconNonbinary => '논바이너리';

  @override
  String get appIconAsexual => '무성애';

  @override
  String get appIconGenderfluid => '젠더플루이드';

  @override
  String get homeCardsIphoneOnMac =>
      '지금 Mac에서 실행 중인 것은 iPhone용 Tanooki Auth라서 브라우저 확장 프로그램이 연결할 수 없어요. 대신 Mac용을 설치하세요. 이 Mac에서 TestFlight를 열고 Tanooki Auth를 고른 뒤 macOS를 선택하면 됩니다.';
}
