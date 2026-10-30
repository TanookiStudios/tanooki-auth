// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRemove => '削除';

  @override
  String get commonUnlock => 'ロック解除';

  @override
  String get commonTurnOff => 'オフにする';

  @override
  String get commonNotNow => '今はしない';

  @override
  String get commonNext => '次へ';

  @override
  String get commonDone => '完了';

  @override
  String get commonDeny => '拒否';

  @override
  String get commonAllow => '許可';

  @override
  String get commonTryAgain => 'もう一度試す';

  @override
  String get commonStop => '停止';

  @override
  String get commonShare => '共有';

  @override
  String get commonOpen => '開く';

  @override
  String get commonCopy => 'コピー';

  @override
  String get commonContinueLabel => '続ける';

  @override
  String get commonClear => 'クリア';

  @override
  String get commonBack => '戻る';

  @override
  String get commonAdd => '追加';

  @override
  String get commonSave => '保存';

  @override
  String get commonDelete => '削除';

  @override
  String get commonClose => '閉じる';

  @override
  String get commonEdit => '編集';

  @override
  String get commonYes => 'はい';

  @override
  String get commonNo => 'いいえ';

  @override
  String get commonSeePremium => 'Premiumを見る';

  @override
  String get commonPremiumBadge => 'Premium';

  @override
  String get commonAppName => 'Tanooki Auth';

  @override
  String get googleMigrationUnreadable =>
      'このGoogle Authenticatorのコードを読み取れませんでした。';

  @override
  String get googleMigrationDamaged => 'このGoogle Authenticatorのコードは壊れています。';

  @override
  String get googleMigrationEmpty =>
      'このGoogle Authenticatorのコードにはアカウントが入っていません。';

  @override
  String get googleMigrationNoSecret => 'このコード内のアカウントにシークレットキーがありません。';

  @override
  String get googleMigrationMd5 =>
      'このコード内のアカウントはMD5を使っていますが、Tanooki Authは対応していません。';

  @override
  String get googleCantTakeSteam => 'Steamのコード';

  @override
  String googleCantTakeDigits(int digits) {
    return '$digits桁のコード';
  }

  @override
  String googleCantTakePeriod(int seconds) {
    return '$seconds秒ごとに変わるコード';
  }

  @override
  String get otpauthNotALink => 'これはotpauth://リンクではありません。';

  @override
  String get otpauthNoSecret => 'このリンクにはシークレットキーがありません。';

  @override
  String otpauthUnsupportedType(String type) {
    return '対応していないコードの種類です:「$type」';
  }

  @override
  String otpauthUnsupportedAlgorithm(String algorithm) {
    return '対応していないアルゴリズムです:「$algorithm」';
  }

  @override
  String get otpauthBadDigits => '桁数は6、7、8のいずれかにしてください。';

  @override
  String get otpauthBadPeriod => '間隔は正の数にしてください。';

  @override
  String get otpauthBadCounter => 'カウンターは0以上にしてください。';

  @override
  String get phoneLinkNotAPairingCode => 'これはTanooki Authのブラウザ連携コードではありません。';

  @override
  String phoneLinkNotSavedFor(String host) {
    return 'このアカウントは$host用に保存されていません。';
  }

  @override
  String get phoneLinkPushNotSetUp =>
      'Tanooki Authのサーバーで通知がまだ設定されていないため、リクエストはアプリを開いている間だけ表示されます。';

  @override
  String phoneLinkPushFailed(int status) {
    return '通知をオンにできませんでした(HTTP $status)。';
  }

  @override
  String get qrImageNotAPicture => 'このファイルはアプリで読み込める画像ではありません。';

  @override
  String get qrImageNoQr => 'この画像にQRコードが見つかりませんでした。';

  @override
  String relayBadAnswer(int status) {
    return '同期サーバーからアプリが理解できない応答が返りました(HTTP $status)。';
  }

  @override
  String get relayUnreachable => '同期サーバーに接続できません。インターネット接続を確認してください。';

  @override
  String get relayTimeout => '同期サーバーが時間内に応答しませんでした。インターネット接続を確認してください。';

  @override
  String get relayInsecure => '同期サーバーと安全な接続ができませんでした。';

  @override
  String relaySaidNo(int status) {
    return '同期サーバーに拒否されました(HTTP $status)。';
  }

  @override
  String get shareNotAShare => 'これはTanooki Authで共有されたアカウントではありません。';

  @override
  String get shareExpired => 'この共有は期限切れです(有効期間は24時間です)。新しいものを頼んでください。';

  @override
  String get shareWrongCode => 'コードが違うか、共有データが壊れています。6桁の数字を確認して、もう一度お試しください。';

  @override
  String get storeServerUnreachable =>
      'Tanooki Authのサーバーに接続できません。インターネット接続を確認して、もう一度お試しください。';

  @override
  String get storeBadKey => 'サーバーから、このアプリでは使えないライセンスキーが届きました。';

  @override
  String storeReportedProblem(String problem) {
    return 'ストアから問題が報告されました: $problem';
  }

  @override
  String get storeGooglePlayUnavailable =>
      'この端末ではGoogle Playが使えないため、ここではPremiumを購入できません。ほかで購入した場合は、下にライセンスキーを入力してください。';

  @override
  String get storeAppStoreUnavailable =>
      '現在App Storeを利用できません。インターネット接続を確認して、もう一度お試しください。';

  @override
  String storeNotListed(String store) {
    return '$storeに今はPremiumが表示されませんでした。しばらくしてからもう一度お試しください。';
  }

  @override
  String storeNotListedWithError(String store, String problem) {
    return '$storeに今はPremiumが表示されませんでした($problem)。しばらくしてからもう一度お試しください。';
  }

  @override
  String storePricesFailed(String problem) {
    return 'ストアから価格を読み込めませんでした: $problem';
  }

  @override
  String storePurchaseCouldNotStart(String problem) {
    return '購入を開始できませんでした: $problem';
  }

  @override
  String storeNothingToRestore(String store) {
    return 'この$storeアカウントにはPremiumの購入が見つかりませんでした。';
  }

  @override
  String storeRestoreFailed(String problem) {
    return '購入を復元できませんでした: $problem';
  }

  @override
  String get storePending => '支払いの承認を待っています。承認されるとすぐにPremiumのロックが解除されます。';

  @override
  String get storeCanceled => '購入をキャンセルしました。請求はされていません。';

  @override
  String storeFailed(String problem) {
    return '購入できませんでした: $problem。請求はされていません。';
  }

  @override
  String get storeFailedNoReason => '購入できませんでした(ストアから理由は示されませんでした)。請求はされていません。';

  @override
  String get storeUnlocked => 'Premiumのロックが解除されました。本当にありがとうございます!';

  @override
  String get storeUnlockedWithKey =>
      'Premiumのロックが解除されました。パソコン用のライセンスキーは下にあります。';

  @override
  String storeUnlockedKeyFailed(String problem) {
    return 'この端末ではPremiumのロックが解除されました。パソコン用のキーはまだ作れませんでした: $problem あとで「購入を復元」をタップして、もう一度お試しください。';
  }

  @override
  String storeServerSaidNo(int status) {
    return 'サーバーに拒否されました(HTTP $status)。';
  }

  @override
  String get syncGroupExists =>
      'このパスフレーズの同期グループはすでにあります。同期中のデバイスで「デバイスを追加」をタップし、そのコードをスキャンしてください。';

  @override
  String get syncNotASyncCode =>
      'これはTanooki Authの同期コードではありません。同期中のデバイスで「設定」>「同期」>「デバイスを追加」を開いてください。';

  @override
  String get syncWrongPassphrase =>
      'このパスフレーズはほかのデバイスのものと一致しません。確認して、もう一度お試しください。';

  @override
  String get syncICloudOtherPassphrase =>
      'ほかのAppleデバイスは別のパスフレーズで同期しています。そちらを入力するか、このパスフレーズで最初からやり直してください。';

  @override
  String get syncErrorRemoved =>
      'このデバイスは別のデバイスから同期を外されました。同期をオフにしてから再びオンにすると、もう一度参加できます。';

  @override
  String get syncErrorTurnedOff =>
      '同期は別のデバイスでオフにされました。ここでもオフにしてから再びオンにすると、最初からやり直せます。';

  @override
  String get syncErrorTooOften => '同期の回数が多すぎます。数分後にもう一度試します。';

  @override
  String get syncErrorLimit => '同期の上限(削除済みを含めて2,000アカウント)に達しました。';

  @override
  String syncErrorICloud(String problem) {
    return 'iCloud Driveで問題が起きました: $problem。';
  }

  @override
  String syncErrorUnexpected(String problem) {
    return '予期しない問題のため同期が止まりました: $problem';
  }

  @override
  String get syncICloudAppleOnly => 'iCloudはiPhone、iPad、Macでのみ使えます。';

  @override
  String get syncICloudSignedOut =>
      'このデバイスではiCloud Driveがオフになっています。使うには、iCloudにサインインして設定でiCloud Driveをオンにしてください。';

  @override
  String get syncICloudNotInBuild =>
      'このバージョンのTanooki AuthではiCloud同期がまだオンになっていません。当面はTanookiリレーを使ってください。どのデバイスでも使えます。';

  @override
  String get teamKeyUnopenable =>
      'このデバイスに送られたチームキーを開けませんでした。チームの管理者に、このデバイスを外してもう一度招待するよう頼んでください。';

  @override
  String get teamNotAnInvite =>
      'これはTanooki Authのチーム招待ではありません。チームの管理者に新しい招待リンクかQRコードを頼んでください。';

  @override
  String get teamNotInTeam => 'このデバイスはチームに入っていません。';

  @override
  String get teamDeletedByAdmin => 'このチームは管理者によって削除されました。';

  @override
  String get teamDeviceRemoved => 'このデバイスはチームから外されました。';

  @override
  String get teamAlreadyInTeam => 'このデバイスはすでにチームに入っています。';

  @override
  String get teamNotALicense =>
      'これはチームライセンスではありません。チームライセンスはTT1.で始まり、登録後にStripeが表示するページに載っています。';

  @override
  String get teamAlreadyInTeamLeaveFirst =>
      'このデバイスはすでにチームに入っています。先にそのチームを抜けてください。';

  @override
  String get teamGone => 'そのチームはもうありません。チームの管理者に新しい招待を頼んでください。';

  @override
  String get teamInviteUsed =>
      'その招待は使用済みか期限切れです(有効期間は7日間、使えるのは1回だけです)。チームの管理者に新しい招待を頼んでください。';

  @override
  String get teamFull => 'そのチームは満員です(10人)。先に管理者が誰かを外す必要があります。';

  @override
  String get aboutTitle => 'Maddieについて';

  @override
  String get aboutP1 =>
      'Maddieです。自閉スペクトラム症の開発者で、細かいところをきちんと仕上げることに、たぶん少しこだわりすぎています。';

  @override
  String get aboutP2 =>
      '私はプライバシーをとても大切に考えています。アカウントを守るキーは、これ以上ないほど個人的なデータです。だからTanooki Authは、それをあなた自身のデバイスに暗号化して保存します。アカウント登録も広告も追跡もなく、私に何かが送られることもありません。';

  @override
  String get aboutP3 =>
      'Tanooki Authは無料で、これからも無料のままにしたいと思っています。あなたの応援があるから、こうした無料のプライバシーアプリを作り続けられます。Tanooki Authが気に入ったら、ほかのアプリもぜひ。madilynthomas.comにあります。';

  @override
  String get aboutP4 =>
      'だから、私からあなたへ。ありがとう。あなたはただアプリを使っているだけではなく、この生き方そのものを支えてくれています。';

  @override
  String get aboutSupportAddress => '応援はこちら: tanookistudios.com/support';

  @override
  String get aboutSupport => '応援する';

  @override
  String get aboutCredits => 'クレジット';

  @override
  String get aboutCreditsBody =>
      'QRコードは、ブラウザ拡張機能ではjsQR(Apache 2.0)、アプリではZXingで読み取っています。Google、Twilio、Authyとは関係ありません。Google AuthenticatorはGoogle LLCの商標です。';

  @override
  String get addFromBrowserOne => 'ブラウザから追加しますか?';

  @override
  String addFromBrowserMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ブラウザから$count件のアカウントを追加しますか?',
    );
    return '$_temp0';
  }

  @override
  String get addFromGoogleTransfer => 'Google Authenticatorの移行コードから:';

  @override
  String addCount(int count) {
    return '$count件を追加';
  }

  @override
  String get addNoColor => '色なし';

  @override
  String addColorName(String name) {
    return '$name色';
  }

  @override
  String get addServiceLabel => 'サービス(例: GitHub)';

  @override
  String get addAccountLabel => 'アカウント(例: メールアドレス)';

  @override
  String get addWebsiteLabel => 'ウェブサイト(任意)';

  @override
  String get addWebsiteHelp => '例: github.com。ブラウザ拡張機能はこのサイトでだけコードを入力します。';

  @override
  String get addTagsLabel => 'タグ(任意)';

  @override
  String get addTagsHelp => '例: 仕事, ゲーム。カンマで区切ります。';

  @override
  String get addFolderLabel => 'フォルダ(任意)';

  @override
  String get addFolderHelp => '例: 仕事。フォルダに入れない場合は空欄のままにします。';

  @override
  String get addPickFolder => 'フォルダを選ぶ';

  @override
  String get addNoFolder => 'フォルダなし';

  @override
  String get addNotesLabel => 'メモ(任意)';

  @override
  String get addColorLabel => '色(任意)';

  @override
  String get addEmojiLabel => '絵文字(任意)';

  @override
  String get addEmojiHelp => 'ロゴの代わりに、ここやウィジェット、ウォッチに表示されます。';

  @override
  String addUseEmoji(String emoji) {
    return '$emojiを使う';
  }

  @override
  String addRequireAuth(String proof) {
    return 'このコードを表示する前に$proofを求める';
  }

  @override
  String get addRequireAuthHelp =>
      'コードはリストで隠れたままになり、ウィジェット、ウォッチ、クイックピックにも表示されません。';

  @override
  String get addTravelHide => 'トラベルモードで隠す';

  @override
  String get addTravelHidePremium => 'トラベルモードで隠す(Premium)';

  @override
  String get addTravelHideHelp =>
      'トラベルモード(設定)がオンの間、このアカウントはオフにするまでアプリから見えなくなります。';

  @override
  String get addTravelNeedsPremium =>
      'トラベルモードはPremiumの機能です。「設定」>「Premiumを入手」から入手できます。';

  @override
  String get addAdvanced => '詳細設定';

  @override
  String get addAdvancedExisting =>
      'サイトから指示があったときだけ変更してください。設定が違うと正しくないコードになり、サイトに拒否されます。';

  @override
  String get addAdvancedNew => 'ほとんどのサイトは標準の設定を使います。サイトから指示があったときだけ変更してください。';

  @override
  String get addType => '種類';

  @override
  String get addTypeTotp => '時間ベース(標準)';

  @override
  String get addTypeHotp => 'カウンターベース(必要なときに新しいコード)';

  @override
  String get addDigits => '桁数';

  @override
  String get addAlgorithm => 'アルゴリズム';

  @override
  String get addSha1Normal => 'SHA-1(標準)';

  @override
  String get addPeriod => '新しいコードの間隔';

  @override
  String addSeconds(int seconds) {
    return '$seconds秒';
  }

  @override
  String get addCounter => 'カウンター';

  @override
  String get addCounterHelp => 'これまでに使ったコードの数';

  @override
  String get addNotASharedFile =>
      'このファイルはTanooki Authの共有アカウントではありません。もう一度共有してもらってください。';

  @override
  String addAlreadyInList(String name) {
    return '$nameはすでにリストにあります。';
  }

  @override
  String get addThisAccount => 'このアカウントを追加しますか?';

  @override
  String get addNoCameraWindows =>
      'WindowsではTanooki Authでカメラを使えません。QRコードの画像を開くか、設定リンクを貼り付けてください。';

  @override
  String get addFromGoogle => 'Google Authenticatorから移行';

  @override
  String get addFromGoogleSteps =>
      'Google Authenticatorが入っているデバイスで:\n\n1. Google Authenticatorを開きます。\n2. メニュー(☰ または ⋮)をタップし、「アカウントを移行」、「アカウントをエクスポート」の順にタップします。\n3. アカウントを選んで「次へ」をタップすると、QRコードが表示されます。\n\nそのQRコードをここでスキャンしてください。QRコードが複数ある場合は、すべてスキャンしてください。';

  @override
  String get addScan => 'スキャン';

  @override
  String get addOpenPicture => '画像を開く';

  @override
  String get addLookingOnScreen => '画面上のQRコードを探しています…';

  @override
  String get addScreenNoQr =>
      '画面にQRコードが見つかりませんでした。コード全体が表示され、ほかのウィンドウで隠れていないことを確認して、もう一度お試しください。';

  @override
  String get addScreenUnsupported =>
      '画面のスキャンにはmacOS 14(Sonoma)以降が必要です。スクリーンショットを撮って「画像を開く」を使ってください。';

  @override
  String get addScreenFailed => '画面を撮影できませんでした。スクリーンショットを撮って「画像を開く」を使ってください。';

  @override
  String get addScreenWrongQr => '画面にQRコードがありましたが、2段階認証の設定コードではありません。';

  @override
  String get addScreenPermissionTitle => 'Tanooki Authに画面の読み取りを許可';

  @override
  String get addScreenPermissionSteps =>
      '画面のQRコードを読み取るには、MacでTanooki Authによる画面の撮影を許可する必要があります。Tanooki Authが画面を見るのは「画面をスキャン」を押したときだけで、画像がこのMacの外に出ることはありません。\n\n1. システム設定を開きます(Dockの歯車アイコン、またはAppleメニュー > システム設定)。\n2. 左の列で「プライバシーとセキュリティ」をクリックします。\n3. 「画面収録とシステムオーディオ録音」をクリックします。\n4. Tanooki Authの横のスイッチをオンにします。リストにない場合は+をクリックし、アプリケーションからTanooki Authを選んでオンにします。\n5. MacからTanooki Authを終了するよう求められます。「終了して再度開く」をクリックしてから、もう一度「画面をスキャン」を押してください。';

  @override
  String get addPasteLinksTitle => '設定リンクを貼り付け';

  @override
  String get addPasteLinksHint => 'otpauth://totp/...\n1行に1つのリンク。まとめて貼り付けられます。';

  @override
  String addManyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のアカウントを追加しますか?',
    );
    return '$_temp0';
  }

  @override
  String addManyBadLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count行は使えません。どの行かはあとで表示されます。',
    );
    return '$_temp0';
  }

  @override
  String get addEnterKey => '設定キーを入力';

  @override
  String get addSetupKey => '設定キー';

  @override
  String get addSetupKeyHelp => 'サイトに表示される英数字';

  @override
  String get addBadKey => 'この設定キーは正しくありません。使えるのはA〜Zの文字と2〜7の数字だけです。';

  @override
  String get addTitle => 'アカウントを追加';

  @override
  String get addScanQr => 'QRコードをスキャン';

  @override
  String get addScanQrHelp => 'サイトに表示されたコードにカメラを向けてください';

  @override
  String addNoCameraOn(String platform) {
    return '$platformではカメラを使えません';
  }

  @override
  String get addScanScreen => '画面をスキャン';

  @override
  String get addScanScreenHelp => '画面のどこかに表示されたQRコードを読み取ります';

  @override
  String get addScanScreenLinux => 'Linuxではまだ使えません。QRコードのスクリーンショットを開いてください。';

  @override
  String get addFromPhotos => '写真からQRコードをスキャン';

  @override
  String get addFromPicture => 'QRコードの画像を開く';

  @override
  String get addFromPhotosHelp => '設定ページのスクリーンショットを選んでください';

  @override
  String get addFromPictureHelp => '設定ページのスクリーンショットでも大丈夫です';

  @override
  String get addPasteLink => '設定リンクを貼り付け';

  @override
  String get addPasteLinkHelp => 'otpauth://で始まるリンク(1つでも複数でも)';

  @override
  String get addOpenShared => '共有アカウントを開く';

  @override
  String addOpenSharedHelp(String extension) {
    return '誰かから送られてきた.$extensionファイル';
  }

  @override
  String get addFromGoogleHelp => 'すべてのアカウントを一度に移行します';

  @override
  String get addFromOtherApp => '別のアプリから移行';

  @override
  String get addFromOtherAppHelp =>
      'Aegis、2FAS、Authy、Bitwarden、1Password、Appleのパスワード、Microsoft';

  @override
  String get addEnterKeyHelp => '「コードをスキャンできない場合」の下に表示されるキーを入力します';

  @override
  String get addWrongQr => 'このQRコードは2段階認証の設定コードではありません。';

  @override
  String get addCameraDenied =>
      'Tanooki Authにカメラの使用が許可されていません。デバイスの設定でTanooki Authのカメラへのアクセスをオンにするか、戻って画像か設定キーを使ってください。';

  @override
  String addCameraFailed(String problem) {
    return 'カメラを起動できませんでした($problem)。戻って画像か設定キーを使ってください。';
  }

  @override
  String get helpNew030a =>
      '人気の40サイトで2段階認証をオンにする手順ガイド。ガイドがあるアカウントを追加・編集すると、ガイドへのリンクが表示されます。';

  @override
  String get helpNew030b => 'アプリを初めて開いたときの短い紹介ツアー。「設定」>「ヘルプ」からもう一度見られます。';

  @override
  String get helpNew030c => '「設定」>「ヘルプ」からフィードバックを送れます。アカウントやコードが含まれることはありません。';

  @override
  String get helpNew030d => 'この「新機能」ページ。';

  @override
  String get helpNew030e =>
      'Appleのパスワードから読み込み、Aegis・2FAS・Google Authenticatorへアカウントを移せるようになりました。';

  @override
  String get helpNew030f =>
      'Steam Guardのコード、「次のコード」ボタン付きのカウンター式コード、ライブプレビュー付きのコード詳細設定。';

  @override
  String get helpNew030g => 'フォルダ、複数アカウントの一括選択、A〜Z順や最近使った順での並べ替え、「アカウント名を整理」。';

  @override
  String get helpNew030h =>
      'アカウントのQRコードを表示して(Face IDまたはパスコードのあとで)、別のデバイスに移せます。';

  @override
  String get helpNew030i =>
      '新しめのiPhone、Mac、Windows PCで、YubiKeyなどのセキュリティキーによるロック解除(Premium)。';

  @override
  String get helpNew030j =>
      'コードを表示する前にFace IDかパスコードを求める「先に確認」アカウントと、選んだアカウントを隠すトラベルモード(Premium)。';

  @override
  String get helpNew030k =>
      'アクティビティ履歴(Premium)、「コードが使えない?」の時計チェック、バックアップのテスト、スリープ時のロック、バックアップのリマインダー。';

  @override
  String get helpNew030l => '緊急アクセス: 信頼できる人があなたのアカウントを申請でき、あなたには断るための日数があります。';

  @override
  String get helpNew030m =>
      'Spotlight検索、コピーしたコードのライブアクティビティと文字盤のコンプリケーション(Premium)、開いたときにコピー、Macの「1回貼り付けたら消去」。';

  @override
  String get helpNew030n =>
      'カウントダウンのスタイル、アカウントごとの色や絵文字、読み上げ、読みやすいフォント、スクリーンリーダー対応の改善。';

  @override
  String get helpNew030o => '大きなウィンドウ向けのワイドレイアウトと、季節のPremiumアイコン。';

  @override
  String get helpNew030p => 'iPhoneとAndroidのアプリ内でPremiumを購入、プレゼント、友だちの招待ができます。';

  @override
  String get helpNew030q => '最大10人でコードを共有できるチーム保管庫。チームプランそのものは近日公開です。';

  @override
  String get helpNew030r => 'ファミリープランは近日公開です。';

  @override
  String get helpNew030s => 'デスクトップアプリがLinuxでも動くようになりました。Linux版のダウンロードは近日公開です。';

  @override
  String get helpNew020a => 'デバイス間の同期、ブラウザ拡張機能のためのスマホ連携、アカウント1件の安全な共有。';

  @override
  String get helpNew020b =>
      'パスコード、自動ロック、緊急消去、ダミーのパスコード、スクリーンショットのブロック、チェックアップ、漏えい警告。';

  @override
  String get helpNew020c =>
      'ウィジェット、Apple WatchとWear OSのアプリ、MacのメニューバーとWindowsのタスクトレイ、自動の暗号化バックアップ(Premium)。';

  @override
  String get helpNew020d =>
      'Aegis、2FAS、Authy、Bitwarden、1Passwordからの読み込みに加え、お気に入り、タグ、メモ、リカバリーコード、ゴミ箱。';

  @override
  String get helpNew010a =>
      '最初のバージョン: アカウントのスキャンや貼り付け、コードの表示、暗号化バックアップ、ブラウザ拡張機能。';

  @override
  String helpNoBrowser(String url) {
    return 'ブラウザを開けませんでした。ページのアドレスは$urlです';
  }

  @override
  String helpGuideFor(String name) {
    return '$nameで2段階認証をオンにする方法';
  }

  @override
  String get helpTourWelcome => 'Tanooki Authへようこそ';

  @override
  String get helpTourWelcomeBody =>
      '多くのサイトでは、パスワードに加えて6桁のコードを求められることがあります。これが2段階認証(2FA)です。Tanooki Authはそのコードをこのデバイス上で作るので、パスワードだけを知っている人はログインできません。';

  @override
  String get helpTourAdd => '最初のアカウントを追加';

  @override
  String get helpTourAddBody =>
      'サイトのセキュリティ設定で2段階認証をオンにすると、QRコードが表示されます。ここでスキャンするか、設定リンクをコピーして貼り付けてください。ほかの認証アプリを使っている場合は、アカウントをまとめて移せます。';

  @override
  String get helpTourScanOrPaste => 'QRコードをスキャン、またはリンクを貼り付け';

  @override
  String get helpTourImport => '別のアプリから読み込む';

  @override
  String get helpTourPopular => 'まず守りたい人気サイト';

  @override
  String get helpTourPopularBody =>
      '特に大切なのは、メール、SNS、お金に関わるサイトです。手順ガイドで、各サイトの2段階認証の設定場所がわかります。';

  @override
  String get helpAllGuides => 'すべての2FAガイド';

  @override
  String helpTourStep(int step, int total) {
    return 'ステップ $step/$total';
  }

  @override
  String get helpTourSkip => 'ツアーをスキップ';

  @override
  String get helpWhatsNew => '新機能';

  @override
  String helpVersion(String version) {
    return 'バージョン $version';
  }

  @override
  String helpVersionThis(String version) {
    return 'バージョン $version(このバージョン)';
  }

  @override
  String get helpFeedbackEmpty => '先にメッセージを入力してください。';

  @override
  String get helpFeedbackSent => '送信しました。ありがとうございます!Maddieはすべてのメッセージを読んでいます。';

  @override
  String get helpFeedbackTooLong => '長すぎて送信できません。短くしてください(最大で約4,000文字)。';

  @override
  String get helpFeedbackTooMany =>
      'この1時間でたくさんのフィードバックを送信しました。1時間後にもう一度お試しください。';

  @override
  String get helpFeedbackOffline =>
      'インターネットに接続できませんでした。接続を確認して、もう一度お試しください。メッセージは残っています。';

  @override
  String get helpFeedbackServerError =>
      'フィードバックサーバーに問題があり、メッセージを受け取れませんでした。あとでもう一度お試しください。メッセージは残っています。';

  @override
  String get helpFeedbackTitle => 'フィードバックを送る';

  @override
  String get helpFeedbackIntro =>
      'バグを見つけた、またはアプリにしてほしいことがある?ここからMaddieに伝えてください。';

  @override
  String get helpFeedbackMessage => 'メッセージ';

  @override
  String get helpFeedbackEmail => 'メールアドレス(任意)';

  @override
  String get helpFeedbackEmailHelp => '返信がほしい場合だけ。';

  @override
  String get helpFeedbackDevice => 'アプリのバージョンとデバイスの種類を含める';

  @override
  String get helpFeedbackDeviceHelp => 'たとえば「0.3.0」と「iOS」。バグの原因を探すのに役立ちます。';

  @override
  String get helpFeedbackNeverSent =>
      '送信されないもの: アカウント、その名前、コード、設定キー、タグ、メモなど、アプリ内のすべての情報。';

  @override
  String get helpFeedbackSend => '送信';

  @override
  String get phoneUiPushAndroid =>
      'Androidの通知はまだ設定されていないため、リクエストはTanooki Authを開いている間に表示されます。';

  @override
  String get phoneUiPushThisDevice =>
      'このデバイスはTanooki Authを開いている間にリクエストを受け取ります。';

  @override
  String get phoneUiPushNoToken => 'iPhoneから通知用のトークンを受け取れませんでした。';

  @override
  String get phoneUiPushDenied =>
      'Tanooki Authの通知がオフになっています。アプリを閉じていてもリクエストを受け取るには、iPhoneの「設定」アプリの「通知」でオンにしてください。';

  @override
  String phoneUiPushFailed(String problem) {
    return '通知をオンにできませんでした: $problem。Tanooki Authを開いている間は、引き続きリクエストが表示されます。';
  }

  @override
  String get phoneUiPushNotInBuild =>
      'このビルドでは通知を使えません。リクエストはTanooki Authを開いている間に表示されます。';

  @override
  String get phoneUiPushChecking => '通知が使えるか確認しています…';

  @override
  String get phoneUiRequest => 'ログインコードのリクエスト';

  @override
  String get phoneUiNoAccount =>
      'このサイト用に保存されたアカウントはないため、送るものはありません。あるはずだと思った場合、本物になりすました偽サイトかもしれません。';

  @override
  String get phoneUiWantsCode =>
      '連携したブラウザがこのサイトのコードを求めています。今まさにログインしているときだけ承認してください。';

  @override
  String get phoneUiApprove => '承認';

  @override
  String phoneUiApproveAccount(String name) {
    return '承認: $name';
  }

  @override
  String get phoneUiScanTitle => 'ブラウザのコードをスキャン';

  @override
  String get phoneUiScanWrong =>
      'これはブラウザ連携のコードではありません。ブラウザでTanooki Authの拡張機能をクリックし、「代わりにスマホを使う」を選んでください。';

  @override
  String get phoneUiPasteTitle => '連携リンクを貼り付け';

  @override
  String get phoneUiPair => '連携';

  @override
  String get phoneUiPaired => '連携しました。そのブラウザがコードを求めると、ここに表示されます。';

  @override
  String get phoneUiExpired => 'このコードは期限切れです。ブラウザで新しいコードを作り、もう一度スキャンしてください。';

  @override
  String get phoneUiPremium => 'スマホをブラウザと一緒に使うのはPremiumの機能です';

  @override
  String get phoneUiIntro =>
      'Tanooki Authアプリが入っていないパソコンでも、ブラウザでコードを入力できます。ブラウザ拡張機能から確認が届いたら、ここで「承認」をタップします。コードはエンドツーエンドで暗号化され、各アカウントに保存されたサイトにだけ送られます。';

  @override
  String get phoneUiPairBrowser => 'ブラウザと連携';

  @override
  String get phoneUiPairHelp =>
      'ブラウザでTanooki Authの拡張機能をクリックし、「代わりにスマホを使う」を選ぶとコードが表示されます。';

  @override
  String get phoneUiPairedBrowsers => '連携したブラウザ';

  @override
  String get phoneUiNoneYet => 'まだありません';

  @override
  String get phoneUiBrowser => 'ブラウザ';

  @override
  String phoneUiPairedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateStringに連携';
  }

  @override
  String get phoneUiUnpair => '連携を解除';

  @override
  String get phoneUiPushOn => '通知オン';

  @override
  String get phoneUiPushOff => 'リクエストはアプリを開いている間に表示されます';

  @override
  String get phoneUiPushOnHelp => 'Tanooki Authを閉じていても、リクエストごとに通知が届きます。';

  @override
  String phoneUiSendCodeFor(String name) {
    return '$nameのコードを送信';
  }

  @override
  String get phoneUiActivityWhere => 'ブラウザ(このスマホ経由)';

  @override
  String get premiumFiveOnce => '1回だけ\$5';

  @override
  String get premiumPayOnce => '1回払い';

  @override
  String get premiumCheckoutSoon =>
      '購入ページはまだ開いていません。もうすぐです。Tanooki Authを応援しようとしてくれてありがとうございます!';

  @override
  String get premiumEnterKeyTitle => 'ライセンスキーを入力';

  @override
  String get premiumEnterKeyHint => 'TA1.…  (購入時のメールに記載)';

  @override
  String get premiumBadKey =>
      'このライセンスキーは正しくありません。購入時のメールからキー全体をコピーして、もう一度お試しください。';

  @override
  String premiumInvitesNowFamily(int count) {
    return '$count人の友だちがあなたのリンクからPremiumを購入したので、あなたのキーは最大5人で使えるファミリーキーになりました。このデバイスにはインストール済みです。下の新しいキーをコピーして、ほかのデバイスでも入力してください。';
  }

  @override
  String premiumInvitesAlreadyFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count人の友だちがあなたのリンクからPremiumを購入しました。あなたのキーはすでにファミリーキーです。',
    );
    return '$_temp0';
  }

  @override
  String premiumInvitesProgress(int count, int needed, int left) {
    return '$needed人中$count人の友だちがあなたのリンクからPremiumを購入しました。あと$left人で、あなたのキーはファミリーキーになります。';
  }

  @override
  String get premiumInviteLinkCopied => '招待リンクをコピーしました。';

  @override
  String get premiumKeyCopied => 'ライセンスキーをコピーしました。';

  @override
  String premiumJustMe(String price) {
    return '自分だけ — $price';
  }

  @override
  String premiumFamilyPrice(String price) {
    return 'ファミリー(最大5人)— $price';
  }

  @override
  String get premiumFamilyApple =>
      'ファミリー: ファミリー共有でAppleのファミリーと共有でき、さらにどのデバイスでも使える最大5人分のライセンスキーが付きます。';

  @override
  String get premiumFamilyKey => 'ファミリー: ほかの最大4人と共有する1つのライセンスキー。';

  @override
  String get premiumYourKey => 'あなたのライセンスキー';

  @override
  String get premiumYourKeyHelp =>
      'ほかのデバイスで入力してください: 「設定」→「Premiumを入手」→「購入済みの方: ライセンスキーを入力」。';

  @override
  String get premiumCopyKey => 'キーをコピー';

  @override
  String get premiumInviteFriends => '友だちを招待';

  @override
  String get premiumInviteHelp =>
      '友だちは20%オフで購入できます。3人が購入すると、あなたのキーがファミリーキーになります。';

  @override
  String get premiumGetInvite => '招待リンクを取得';

  @override
  String get premiumCheckInvites => '招待の状況を確認';

  @override
  String get premiumYouHave => 'Premiumをご利用中です';

  @override
  String get premiumTitle => 'Tanooki Auth Premium';

  @override
  String get premiumOwnedFamily =>
      'ファミリープラン: ライセンスキーをほかの最大4人(合計5人)と共有できます。Tanooki Authを応援してくれてありがとうございます。';

  @override
  String get premiumOwnedThanks => 'Tanooki Authを応援してくれてありがとうございます。';

  @override
  String get premiumPitchStripe => '1回だけ\$5、家族全員なら\$10。ずっと使えます。';

  @override
  String get premiumPitchStore => '自分用でも家族全員用でも、支払いは1回だけ。ずっと使えます。';

  @override
  String get premiumPerkThemes => 'すべてのPremiumテーマ';

  @override
  String premiumPerkThemesBody(int count) {
    return 'パステルピンク、パステルブルーほか$count種類。今後追加されるテーマもすべて使えます。';
  }

  @override
  String get premiumPerkIcons => 'アプリアイコン';

  @override
  String premiumPerkIconsBody(int count) {
    return 'iPhoneとAndroidのホーム画面アイコンを、パステルピンク、パステルブルーほか$count色、さらに秋・冬・春の季節アイコンから選べます。Macではアプリを開いている間、Dockのアイコンが変わります。';
  }

  @override
  String get premiumPerkSync => 'デバイス間で同期';

  @override
  String get premiumPerkSyncBody =>
      '1台のデバイスでアカウントを追加すると、すべてのデバイスに表示されます。エンドツーエンドで暗号化。AppleデバイスどうしならiCloud、組み合わせが混在するならTanookiリレーを使います。';

  @override
  String get premiumPerkApprove => 'スマホでコードを承認';

  @override
  String get premiumPerkApproveBody =>
      'どのパソコンでもブラウザ拡張機能が使えます。スマホに確認が届き、「承認」をタップするとコードが入力されます。';

  @override
  String get premiumPerkBreach => '漏えい警告';

  @override
  String get premiumPerkBreachBody =>
      'アカウントのあるサイトが既知のデータ漏えいに含まれると通知します。チェックはデバイス上で行い、あなたの情報は何も送信されません。';

  @override
  String get premiumPerkShare => 'アカウントを安全に共有';

  @override
  String get premiumPerkShareBody =>
      '信頼できる人に、QRコードと6桁のコードでアカウントを1件渡せます。保護済み、24時間で期限切れ、サーバー不要。';

  @override
  String get premiumPerkFamily => 'ファミリープラン';

  @override
  String get premiumPerkFamilyStripe =>
      '\$5ではなく\$10で、1つのキーで最大5人までPremiumのロックを解除できます。家族に送れば、あなたと同じように入力するだけです。';

  @override
  String get premiumPerkFamilyStore =>
      'ファミリーの購入1回で、最大5人までPremiumのロックを解除できます。ライセンスキーを送れば、あなたと同じように入力するだけです。';

  @override
  String get premiumPerkFuture => '今後のPremium機能もすべて';

  @override
  String get premiumPerkFutureBody =>
      '1回払うだけで、Premiumに今後加わる機能もすべて使えます。サブスクリプションは一切ありません。';

  @override
  String get premiumPerkFree => 'プライバシー重視のアプリを無料のままに';

  @override
  String get premiumPerkFreeStripe => 'あなたの\$5のおかげで、追跡しない無料アプリを作り続けられます。';

  @override
  String get premiumPerkFreeStore => 'Premiumを購入してもらえることで、追跡しない無料アプリを作り続けられます。';

  @override
  String get premiumFreeForever =>
      'Premiumがなくてもずっと無料: アカウント数無制限、スキャン、バックアップ、ブラウザ拡張機能、アプリのロック。';

  @override
  String get premiumFamilySoon => 'ファミリープランは近日公開';

  @override
  String get premiumFamilyKeyEach =>
      'ファミリー: ほかの最大4人と共有する1つのライセンスキー。それぞれが自分のTanooki Authで入力します。';

  @override
  String get premiumRestore => '購入を復元';

  @override
  String get premiumAlreadyBought => '購入済みの方: ライセンスキーを入力';

  @override
  String get premiumDesktopKeySoon =>
      'Androidで購入した場合のパソコン用キーは近日対応予定です。このスマホではすでにPremiumのロックが解除されています。パソコン用のライセンスキーは今後のアップデートでここに表示されます。';

  @override
  String premiumGift(String price) {
    return 'Premiumをプレゼント — $price';
  }

  @override
  String premiumGiftFamily(String price) {
    return 'ファミリープランをプレゼント — $price';
  }

  @override
  String get premiumGiftHelp => '支払い後、相手用のキーが入った印刷できるギフトカードが届きます。';

  @override
  String get settingsIconFailed => 'アプリアイコンを変更できませんでした。もう一度試すか、アプリを再起動してください。';

  @override
  String settingsIconFailedWhy(String problem) {
    return 'アプリアイコンを変更できませんでした($problem)。もう一度試すか、アプリを再起動してください。';
  }

  @override
  String settingsIconSemantic(String name) {
    return '$nameのアプリアイコン';
  }

  @override
  String settingsIconSemanticPremium(String name) {
    return '$nameのアプリアイコン、Premium';
  }

  @override
  String get settingsAppIcon => 'アプリアイコン';

  @override
  String get settingsAppIconPremium => 'アプリアイコン(Premium)';

  @override
  String get settingsAppIconIos => 'ホーム画面のアイコンです。';

  @override
  String get settingsAppIconAndroid => 'ホーム画面のアイコンです。切り替えの間、少しのあいだ消えることがあります。';

  @override
  String get settingsAppIconMac =>
      'Tanooki Authを開いている間、Dockのアイコンが変わります。Macではアプリを終了すると別のアイコンを保てないため、FinderとLaunchpadでは青いアイコンのままです。';

  @override
  String get settingsAppIconOther => 'アプリアイコンはiPhoneとAndroidで変更できます。';

  @override
  String get settingsLockNameMac => 'Touch IDまたはMacのパスワード';

  @override
  String get settingsLockNamePhone => 'Face ID、指紋、またはパスコード';

  @override
  String settingsNoLockSetUp(String lock) {
    return 'このデバイスには$lockが設定されていないため、アプリをロックできません。先にシステムの設定で設定してください。';
  }

  @override
  String get settingsLockReasonOn => 'アプリのロックをオンにする';

  @override
  String get settingsLockReasonOff => 'アプリのロックをオフにする';

  @override
  String get settingsSetPasscode => 'アプリのパスコードを設定';

  @override
  String get settingsSetPasscodeIntro =>
      'Tanooki Authを開くときに入力します。Face IDや指紋が使えないときにも使えます。忘れると、元に戻す方法はバックアップしかありません。';

  @override
  String get settingsPasscodeOn => 'アプリのパスコードをオンにしました。';

  @override
  String get settingsPasscode => 'アプリのパスコード';

  @override
  String get settingsChangePasscode => 'パスコードを変更';

  @override
  String get settingsPasscodeOff => 'パスコードをオフにする';

  @override
  String get settingsNewPasscode => '新しいアプリのパスコード';

  @override
  String get settingsPasscodeChanged => 'パスコードを変更しました。';

  @override
  String get settingsPasscodeIsOff => 'アプリのパスコードをオフにしました。';

  @override
  String get settingsRemoveDecoyTitle => 'ダミーのパスコードを削除しますか?';

  @override
  String get settingsRemoveDecoyBody => 'ダミーのアカウントは消去されます。本物のアカウントには影響しません。';

  @override
  String get settingsSetDecoy => 'ダミーのパスコードを設定';

  @override
  String get settingsSetDecoyIntro =>
      '誰かにTanooki Authを開くよう強要されたら、代わりにこちらを入力してください。別の空のアカウント一覧が開き、本物でないことは画面のどこにも表れません。使っているように見せるため、差し支えないアカウントをいくつか追加しておきましょう。\n\n本物のパスコードでは、これまでどおり本物のアカウントが開きます。';

  @override
  String get settingsDecoySet => 'ダミーのパスコードを設定しました。';

  @override
  String settingsWipeTitle(int count) {
    return 'パスコードを$count回間違えたらすべて消去しますか?';
  }

  @override
  String settingsWipeBody(int count) {
    return '誰かがアプリのパスコードを$count回続けて間違えると、Tanooki Authはこのデバイスのアカウントをすべて消去します。元に戻すことも、始まってから止めることもできません。';
  }

  @override
  String get settingsWipeSureTitle => '本当によろしいですか?';

  @override
  String get settingsWipeSureBody =>
      'スマホで遊ぶ子どもや、調子の悪い日のあなた自身が作動させてしまうこともあります。消去後に元に戻す方法はバックアップファイルだけです。それがないと、これらのコードを使うすべてのサイトにログインできなくなるおそれがあります。';

  @override
  String get settingsWipeTurnOn => '緊急消去をオンにする';

  @override
  String get settingsTravelOffReason => 'トラベルモードをオフにする';

  @override
  String get settingsTravelOnNone =>
      'トラベルモードをオンにしましたが、「トラベルモードで隠す」に設定されたアカウントがまだありません。先に ⋯ > 編集 で設定してください。';

  @override
  String settingsTravelOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'トラベルモードをオンにしました。$count件のアカウントを隠しています。',
    );
    return '$_temp0';
  }

  @override
  String get settingsTravelOff => 'トラベルモードをオフにしました。すべてのアカウントが戻りました。';

  @override
  String get settingsCheckingClock => '時計を確認しています…';

  @override
  String get settingsClockRight =>
      '時計は正確なので、原因は時計ではありません。アカウントの設定(⋯ > 編集 > 詳細設定)がサイトの指示と合っているか確認してください。';

  @override
  String settingsClockFailed(String problem) {
    return '時計を確認できませんでした: $problem';
  }

  @override
  String get settingsLockApp => 'アプリをロック';

  @override
  String settingsLockAppHelp(String lock) {
    return 'アプリを開くときに$lockを求める';
  }

  @override
  String get settingsPasscodeOnHelp => 'オン。タップして変更またはオフにできます。';

  @override
  String settingsPasscodeOffHelp(String lock) {
    return 'オフ。アプリを開くときに入力する数字です。$lockの代わりにも、併用もできます。';
  }

  @override
  String get settingsLockAgain => '再ロック';

  @override
  String settingsLockAgainHelp(String time) {
    return 'バックグラウンドで$time';
  }

  @override
  String get settingsLockFirst => '先にロックかパスコードをオンにしてください';

  @override
  String get settingsDecoy => 'ダミーのパスコード';

  @override
  String get settingsDecoyOn => 'オン。別のアカウント一覧が開きます。タップして削除できます。';

  @override
  String get settingsDecoyOff => '別の空のアカウント一覧を開く2つ目のパスコード';

  @override
  String settingsWipe(int count) {
    return 'パスコードを$count回間違えたら消去';
  }

  @override
  String get settingsWipeHelp => '緊急消去。30日以内に作ったバックアップが必要です。';

  @override
  String get settingsLockOnSleep => 'パソコンのスリープ時にロック';

  @override
  String get settingsLockOnSleepHelp => '画面ロック時や一時的なログアウト時も';

  @override
  String get settingsLockOnSleepNeedsLock =>
      'ロックする対象が必要なので、先に「アプリをロック」かアプリのパスコードをオンにしてください。';

  @override
  String get settingsTravel => 'トラベルモード';

  @override
  String get settingsTravelPremium => 'トラベルモード(Premium)';

  @override
  String get settingsTravelOnHelp =>
      'オン。「トラベルモードで隠す」に設定したアカウントは、オフにするまでこのデバイスの画面、ウィジェット、ウォッチ、拡張機能、エクスポートから消えます。削除はされません。';

  @override
  String settingsTravelOffHelp(String proof) {
    return '国境を越える前に: 「トラベルモードで隠す」(⋯ > 編集)に設定したアカウントを隠します。オフにするときは$proofが必要です。';
  }

  @override
  String get settingsKeys => 'セキュリティキー';

  @override
  String get settingsKeysPremium => 'セキュリティキー(Premium)';

  @override
  String get settingsKeysHelp => 'YubiKeyなどのセキュリティキーでロック解除';

  @override
  String get settingsActivity => 'アクティビティ履歴';

  @override
  String get settingsActivityPremium => 'アクティビティ履歴(Premium)';

  @override
  String get settingsActivityHelp =>
      'どのコードをいつコピー・入力・タイプ・エクスポートしたか。このデバイスにだけ保存されます。';

  @override
  String get settingsEmergency => '緊急アクセス';

  @override
  String get settingsEmergencyPremium => '緊急アクセス(Premium)';

  @override
  String get settingsEmergencyHelp =>
      '万一のとき、信頼できる1人があなたのアカウントを受け取れるようにします。7日間の待機中ならあなたが止められます';

  @override
  String get settingsTeamHelp => '最大10人とログインコードを共有。エンドツーエンドで暗号化';

  @override
  String get settingsMonthly => '月間サマリーの通知';

  @override
  String get settingsMonthlyPremium => '月間サマリーの通知(Premium)';

  @override
  String get settingsMonthlyHelp =>
      '毎月1日に、サマリーカードを見るよう知らせます。アカウントについては何も表示しません。';

  @override
  String get settingsBlockShots => 'スクリーンショットをブロック';

  @override
  String get settingsBlockShotsDesktop =>
      'このウィンドウをスクリーンショット、画面収録、画面共有に写らないようにします';

  @override
  String get settingsBlockShotsPhone =>
      'スクリーンショット、画面収録、アプリスイッチャーにコードが写らないようにします';

  @override
  String get settingsCheckup => 'セキュリティチェックアップ';

  @override
  String get settingsCheckupHelp => '見直すとよい点と、リカバリーキット';

  @override
  String get settingsBreachPremium => '漏えい警告(Premium)';

  @override
  String get settingsBreachOn => 'オン。公開されている漏えいリストを毎週チェックします。';

  @override
  String get settingsBreachOff => 'オフ。オンにすると、公開されている漏えいリストを週に1回ダウンロードします。';

  @override
  String settingsThemeSemantic(String name) {
    return '$nameテーマ';
  }

  @override
  String settingsThemeSemanticPremium(String name) {
    return '$nameテーマ、Premium';
  }

  @override
  String get settingsPremiumThanks => 'Premium: ありがとうございます!';

  @override
  String get settingsGetPremium => 'Premiumを入手';

  @override
  String get settingsPremiumThanksHelp => 'すべてのテーマと今後のPremium機能が使えます。';

  @override
  String settingsGetPremiumHelp(String payOnce) {
    return '$payOnce: すべてのテーマ、デバイス間の同期など。';
  }

  @override
  String get settingsAppearance => '外観';

  @override
  String get settingsCountdown => 'カウントダウンのスタイル';

  @override
  String get settingsCountdownHelp => '各コードの残り時間の表示方法';

  @override
  String get settingsEasyFont => '読みやすいフォント';

  @override
  String get settingsEasyFontHelp =>
      'Atkinson Hyperlegible。文字や数字を見間違えにくいようBraille Instituteが作ったフォントです';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageSystem => 'システム';

  @override
  String get settingsAccountsList => 'アカウント一覧';

  @override
  String get settingsCompact => 'コンパクトなカード';

  @override
  String get settingsCompactHelp => 'カードを小さくして、画面により多くのアカウントを表示します';

  @override
  String get settingsSort => 'アカウントの並べ替え';

  @override
  String settingsSortHelp(String sort) {
    return '$sort。お気に入りは常に先頭です。';
  }

  @override
  String get settingsSortCustom => '自分で決めた順番。カードを長押ししてドラッグします。';

  @override
  String get settingsSortRecent => 'コードをコピーしたばかりのアカウントが上に来ます';

  @override
  String get settingsSortName => 'サービス名順';

  @override
  String get settingsTidyHelp =>
      '「google.com:you@gmail.com」のような名前を「Google」に整えます。変更内容は事前にすべて確認できます。';

  @override
  String get settingsHideCodes => 'タップするまでコードを隠す';

  @override
  String get settingsHideCodesHelp => 'コードの代わりに点を表示し、近くの人に読まれないようにします';

  @override
  String get settingsShareCodes => 'ウィジェットとウォッチにコードを表示';

  @override
  String get settingsShareCodesHelp =>
      'アプリを開かなくても、お気に入りのコードがホーム画面、ロック画面、ウォッチに表示されます。そのため、ロック解除されたスマホやウォッチを持っている人なら誰でも読めます。星を付けるとお気に入りになります。';

  @override
  String get settingsTrash => 'ゴミ箱';

  @override
  String settingsTrashCount(int count) {
    return 'ゴミ箱($count)';
  }

  @override
  String get settingsTrashHelp => '削除したアカウントは30日間ここに残ります';

  @override
  String get settingsWatchFace => '文字盤のお気に入り';

  @override
  String get settingsWatchFacePremium => '文字盤のお気に入り(Premium)';

  @override
  String get settingsWatchFaceNoFavorites =>
      '先にメインのリストでアカウントに星を付けてください。文字盤に表示できるのはお気に入りだけです。';

  @override
  String get settingsNone => 'なし';

  @override
  String get settingsCopying => 'コピーとショートカット';

  @override
  String get settingsCopyOnOpen => '開いたときにコピー';

  @override
  String get settingsCopyOnOpenHelp =>
      'アプリを開く・ロック解除すると、最後に使ったアカウントのコードをコピーします。コード表示前に確認するアカウントは対象外です。';

  @override
  String get settingsPasteOnce => '1回貼り付けたら消去';

  @override
  String get settingsPasteOnceHelp =>
      'コピーしたコードは1回貼り付けるとクリップボードから消えます。クリップボード履歴アプリがその1回に数えられることがあります。Windowsでは代わりに30秒後に消えます。';

  @override
  String get settingsSpotlight => 'Spotlightにアカウントを表示';

  @override
  String get settingsSpotlightHelp =>
      'どこからでもアカウント名を検索して直接開けます。共有されるのは名前だけで、コードは共有されません。';

  @override
  String get settingsLiveActivity => 'コピー後にロック画面にコードを表示';

  @override
  String get settingsLiveActivityPremium => 'コピー後にロック画面にコードを表示(Premium)';

  @override
  String get settingsLiveActivityHelp =>
      'コードをコピーすると、期限切れまでのカウントダウン付きでロック画面とDynamic Islandに表示されます。';

  @override
  String get settingsWatchFaceHelp =>
      'Apple Watchの文字盤にコードを表示するお気に入りを1つ選びます。「ウィジェットとウォッチにコードを表示」をオンにする必要があります。';

  @override
  String settingsWatchFaceChosen(String name) {
    return '$name。表示するには、文字盤にTanooki Authのコンプリケーションを追加してください。';
  }

  @override
  String get settingsBrowserSection => 'ブラウザ拡張機能とランチャー';

  @override
  String get settingsBridgeOff => '停止中';

  @override
  String get settingsBridgeOn => 'ブラウザ拡張機能の準備ができています';

  @override
  String settingsBridgeOffHelp(String first, String last) {
    return 'ポート$first〜$lastがすべてほかのプログラムに使われているため、拡張機能が接続できません。パソコンを再起動してもう一度お試しください。';
  }

  @override
  String settingsBridgeOnHelp(String port) {
    return 'このパソコン内だけで待ち受けています(127.0.0.1:$port)。Tanooki Authを開いている間に使えます。';
  }

  @override
  String settingsPairedClient(String name) {
    return '連携済み: $name';
  }

  @override
  String get settingsPairedBrowser => '連携済みのブラウザ';

  @override
  String settingsExtensionId(String id) {
    return '拡張機能 $id';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSecurity => 'セキュリティ';

  @override
  String get settingsBackup => 'バックアップ';

  @override
  String get settingsExport => 'バックアップをエクスポート';

  @override
  String get settingsExportHelp => '自分で決めたパスフレーズで保護された暗号化ファイル';

  @override
  String get settingsImport => 'バックアップを読み込む';

  @override
  String get settingsImportHelp => 'バックアップファイルからアカウントを追加します。すでにあるものはスキップします';

  @override
  String get settingsTestBackup => 'バックアップをテスト';

  @override
  String get settingsTestBackupHelp => 'バックアップファイルがパスフレーズで開けるか確認します。何も変更しません。';

  @override
  String get settingsMoveOut => '別のアプリに移す';

  @override
  String get settingsMoveOutHelp =>
      'Aegis、2FAS、Google Authenticator、またはそのままの設定リンク';

  @override
  String get settingsPaper => '紙のバックアップを印刷';

  @override
  String get settingsPaperHelp => '鍵のかかる場所に保管するための、QRコードとリカバリーコードのPDF';

  @override
  String get settingsHelp => 'ヘルプ';

  @override
  String get settingsGuidesHelp => '人気サイトで2段階認証をオンにする手順(当社サイト)';

  @override
  String get settingsTour => '紹介ツアーを見る';

  @override
  String get settingsFeedbackHelp => 'バグやアイデアをMaddieに伝えます。アカウントやコードは含まれません。';

  @override
  String get settingsAbout => '情報';

  @override
  String get settingsAboutMaddieHelp => 'Tanooki Authを作っている人からのメッセージ';

  @override
  String get settingsCodesNotWorking => 'コードが使えない?';

  @override
  String settingsCodesNotWorkingHelp(String time) {
    return 'デバイスの時刻 $time。コードは時計に左右されます。タップしてインターネットの時刻と比べます。';
  }

  @override
  String shareUiConfirmTitle(String name) {
    return '$nameを共有しますか?';
  }

  @override
  String get shareUiConfirmBody =>
      '共有した相手は完全にアクセスできるようになります。相手が持っている限り、相手のスマホでもあなたと同じコードが作られます。家族など、心から信頼できる人とだけ共有してください。\n\nあとで自分のリストから消しても、相手からは消えません。相手のアクセスを止めるには、そのサイトで2段階認証をいったんオフにしてから、もう一度オンにしてください。';

  @override
  String get shareUiConfirmButton => 'わかりました、共有する';

  @override
  String get shareUiLocking => '共有データを保護しています…';

  @override
  String shareUiTitle(String name) {
    return '$nameを共有';
  }

  @override
  String get shareUiInstructions =>
      '相手のデバイスで、Tanooki Authを開いて「アカウントを追加」をタップし、「QRコードをスキャン」(ファイルの場合は「共有アカウントを開く」)を選びます。そのあと、このコードを入力してもらいます:';

  @override
  String get shareUiTellCode => 'コードは自分で伝えてください。口頭か、ファイルとは別のアプリで。';

  @override
  String get shareUiSendFile => 'ファイルで送る';

  @override
  String get shareUiCopyLink => 'リンクとしてコピー';

  @override
  String get shareUiCopied => 'コピーしました。相手は「設定リンクを貼り付け」で貼り付けます。';

  @override
  String get shareUiWorksFor => '有効期間は24時間で、コードがないと開けません。サーバーは一切経由しません。';

  @override
  String get shareUiOpenTitle => '共有されたアカウント';

  @override
  String get shareUiOpenBody => '共有してくれた人から聞いた6桁のコードを入力してください。';

  @override
  String get shareUiUnlocking => 'ロック解除中…';

  @override
  String get signatureLabel => 'Maddieの署名';

  @override
  String get syncUiQrCode => 'QRコード';

  @override
  String get syncUiNotYet => 'まだ';

  @override
  String get syncUiJustNow => 'たった今';

  @override
  String syncUiMinutesAgo(int minutes) {
    return '$minutes分前';
  }

  @override
  String syncUiHoursAgo(int hours) {
    return '$hours時間前';
  }

  @override
  String syncUiDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get syncUiThisDevice => 'このデバイス';

  @override
  String get syncUiAnotherDevice => '別のデバイス';

  @override
  String syncUiAdded(String when) {
    return '追加: $when';
  }

  @override
  String syncUiThisDeviceNamed(String name) {
    return 'このデバイス($name)';
  }

  @override
  String syncUiLastSyncedAgo(String when) {
    return '最終同期: $when';
  }

  @override
  String get syncUiWhere => 'どこで同期しますか?';

  @override
  String get syncUiICloudHelp => 'iPhone、iPad、Mac専用です。あなた自身のiCloud Driveを使います。';

  @override
  String get syncUiRelay => 'Tanookiリレー';

  @override
  String get syncUiRelayHelp =>
      'AndroidやWindowsを含め、どのデバイスでも使えます。サーバーには暗号化されたデータしか保存されません。';

  @override
  String get syncUiStartFreshTitle => '最初からやり直しますか?';

  @override
  String get syncUiStartFreshBody =>
      'ほかのAppleデバイスで使っているパスフレーズを忘れた場合は、このパスフレーズで新しく同期を始められます。その場合、ほかのデバイスでは同期をオフにしてから、新しいパスフレーズでもう一度オンにする必要があります。';

  @override
  String get syncUiStartFresh => '最初からやり直す';

  @override
  String get syncUiOn => '同期がオンになりました。';

  @override
  String get syncUiScanTitle => '同期コードをスキャン';

  @override
  String get syncUiScanWrong =>
      'これは同期コードではありません。もう一方のデバイスで「設定」>「同期」>「デバイスを追加」を開いてください。';

  @override
  String get syncUiNowSyncing => 'このデバイスの同期が始まりました。';

  @override
  String get syncUiPasteTitle => '同期リンクを貼り付け';

  @override
  String get syncUiPasteHint => 'tanookiauth://sync?…  (もう一方のデバイスの「デバイスを追加」から)';

  @override
  String get syncUiAddApple => 'Appleデバイスを追加';

  @override
  String get syncUiAddAppleBody =>
      'もう一方のiPhone、iPad、Mac(同じApple Accountでサインインし、iCloud Driveがオン)でTanooki Authを開き、「設定」>「同期」で「同期をオンにする」をタップし、iCloudを選んで同じパスフレーズを入力してください。\n\nAndroidスマホやWindows PCを追加したい場合は、すべてのデバイスで同期をオフにしてから、Tanookiリレーでもう一度オンにしてください。';

  @override
  String get syncUiAddDevice => 'デバイスを追加';

  @override
  String get syncUiAddDeviceBody =>
      '新しいデバイスでTanooki Authを開き、「設定」>「同期」で「別のデバイスから参加」をタップします。このコードをスキャンして、そこで同期のパスフレーズを入力してください。';

  @override
  String get syncUiAddDeviceNote =>
      '1回だけ、24時間有効です。このコードだけでは、パスフレーズがなければ何も読めません。';

  @override
  String get syncUiLinkCopied => 'リンクをコピーしました。新しいデバイスで貼り付けてください。';

  @override
  String get syncUiCopyLink => '代わりにリンクをコピー';

  @override
  String get syncUiRemoveTitle => 'このデバイスを同期から外しますか?';

  @override
  String get syncUiRemoveBody =>
      'このデバイスには変更が届かなくなります。紛失・盗難の場合は、同期のパスフレーズも変えてください。失くしたデバイスは古いパスフレーズを知っているので、すべてのデバイスで同期をオフにしてから、新しいパスフレーズでオンにし直します。';

  @override
  String get syncUiTurnOffTitle => 'このデバイスで同期をオフにしますか?';

  @override
  String get syncUiTurnOffBody =>
      'アカウントはこのデバイスに残ります。変更の送受信が止まるだけです。ほかのデバイスどうしの同期は続きます。';

  @override
  String get syncUiOff => 'このデバイスの同期をオフにしました。';

  @override
  String get syncUiPremium => '同期はPremiumの機能です';

  @override
  String syncUiPremiumBody(String payOnce) {
    return '1台でアカウントを追加すると、すべてのデバイスに表示されます。エンドツーエンドで暗号化。$payOnce、サブスクリプションなし。';
  }

  @override
  String get syncUiIntro =>
      '同期を使うと、すべてのデバイスでアカウントが同じになります。データはこのデバイスを出る前に同期のパスフレーズで保護されるため、iCloudや私たちのサーバーには暗号化されたデータしか保存されません。私たちを含め、ほかの誰も読めません。';

  @override
  String get syncUiTurnOn => '同期をオンにする';

  @override
  String get syncUiJoin => '別のデバイスから参加';

  @override
  String get syncUiJoinHelp => '別のデバイスがすでにTanookiリレーで同期している場合は「参加」を使ってください。';

  @override
  String get syncUiSyncingRelay => 'Tanookiリレーで同期中';

  @override
  String get syncUiSyncingICloud => 'iCloudで同期中';

  @override
  String get syncUiSyncingNow => '同期しています…';

  @override
  String syncUiSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '同期した項目のうち$count件を読み込めませんでした',
    );
    return '$_temp0';
  }

  @override
  String get syncUiSkippedHelp =>
      'ほかの人に変更されたか、別のパスフレーズで作られた可能性があります。これが原因で削除されたものはありません。';

  @override
  String get syncUiDevices => 'デバイス';

  @override
  String get syncUiLoading => '読み込み中…';

  @override
  String get syncUiAddDeviceRelay => '新しいデバイスでスキャンするコードを表示します';

  @override
  String get syncUiAddDeviceApple => '別のiPhone、iPad、Mac';

  @override
  String get syncUiTurnOffButton => 'このデバイスで同期をオフにする';

  @override
  String get syncUiPassphraseNoteRelay =>
      '同期のパスフレーズは復元できません。忘れた場合は、すべてのデバイスで同期をオフにして、新しいパスフレーズでやり直してください。アカウントはそのまま残ります。';

  @override
  String get syncUiPassphraseNoteICloud =>
      '同期にはiCloud Driveを使います。パスフレーズは復元できないため、忘れた場合は新しいパスフレーズで最初からやり直してください。アカウントはそのまま残ります。';

  @override
  String get syncUiTitle => '同期';

  @override
  String get syncUiTooShort => '10文字以上にしてください。ランダムな単語をいくつか並べるのがおすすめです。';

  @override
  String get syncUiMismatch => '2つのパスフレーズが一致しません。';

  @override
  String get syncUiChoosePassphrase => '同期のパスフレーズを決める';

  @override
  String get syncUiTypePassphrase => '同期のパスフレーズを入力';

  @override
  String get syncUiChooseHelp =>
      '追加するデバイスごとに1回入力します。アカウントがこのデバイスを出る前に、このパスフレーズで保護されます。\n\n安全な場所に書き留めておいてください。あなたも私たちも、復元やリセットはできません。';

  @override
  String get syncUiTypeHelp => '最初のデバイスで同期をオンにしたときに決めたパスフレーズです。';

  @override
  String get syncUiPassphrase => '同期のパスフレーズ';

  @override
  String get syncUiTypeAgain => 'もう一度入力';

  @override
  String get syncUiSectionTitle => '同期とスマホ';

  @override
  String get syncUiTitlePremium => '同期(Premium)';

  @override
  String get syncUiOnRelay => 'オン(Tanookiリレー)';

  @override
  String get syncUiOnICloud => 'オン(iCloud)';

  @override
  String get syncUiOffHelp => 'すべてのデバイスでアカウントを同じに保ちます';

  @override
  String get syncUiBrowser => 'ブラウザで使う';

  @override
  String get syncUiBrowserPremium => 'ブラウザで使う(Premium)';

  @override
  String get syncUiBrowserHelp => 'どのパソコンのブラウザでも、このスマホでコードを承認できます';

  @override
  String get teamUiCreateTitle => 'チームを作成';

  @override
  String get teamUiCreateHint => 'TT1.…  (登録後に表示されたページから)';

  @override
  String get teamUiCreateButton => 'チームを作成';

  @override
  String get teamUiReady => 'チームの準備ができました。「メンバーを招待」で招待してください。';

  @override
  String get teamUiScanTitle => 'チームの招待をスキャン';

  @override
  String get teamUiScanWrong =>
      'これはチームの招待ではありません。チームの管理者に「設定」>「チーム保管庫」>「メンバーを招待」を開いてもらってください。';

  @override
  String get teamUiJoinTitle => 'チームに参加';

  @override
  String get teamUiJoinHint => 'tanookiauth://team?…  (チームの管理者からの招待リンク)';

  @override
  String get teamUiJoinButton => '参加';

  @override
  String get teamUiJoinedTeam =>
      'チームに参加しました。管理者のアプリがこのデバイスとチームキーを共有すると、チームのアカウントが表示されます。';

  @override
  String get teamUiInvite => 'メンバーを招待';

  @override
  String get teamUiInviteHelp =>
      '相手のデバイスで「設定」>「チーム保管庫」を開き、「招待のQRコードをスキャン」か「招待リンクを貼り付け」を選びます。招待は1回だけ使え、7日間有効です。';

  @override
  String get teamUiRemovePersonTitle => 'このメンバーを外しますか?';

  @override
  String get teamUiRemovePersonBody =>
      'このメンバーはすぐにアクセスできなくなり、チームには新しいキーが作られるので、今後追加・変更されたものは読めません。すでに見えていたコードのコピーを持っている可能性があるため、大切なアカウントの2段階認証は設定し直してください。';

  @override
  String get teamUiRemoved => '外しました。チームに新しいキーが作られました。';

  @override
  String get teamUiDeleteTitle => 'チームを削除しますか?';

  @override
  String get teamUiLeaveTitle => 'チームを抜けますか?';

  @override
  String get teamUiDeleteBody => 'チームのアカウントはメンバー全員から削除されます。各自のアカウントには影響しません。';

  @override
  String get teamUiLeaveBody => 'チームのアカウントはこのデバイスから消えます。あなた自身のアカウントには影響しません。';

  @override
  String get teamUiDeleteButton => 'チームを削除';

  @override
  String get teamUiLeaveButton => '抜ける';

  @override
  String get teamUiDeleted => 'チームを削除しました。';

  @override
  String get teamUiLeft => 'チームを抜けました。';

  @override
  String get teamUiAddFirst => 'まずアカウントをTanooki Authに追加してから、ここでチームにコピーしてください。';

  @override
  String get teamUiCopyInTitle => '自分のアカウントをチームにコピー';

  @override
  String teamUiCopiedIn(String name) {
    return '$nameをチームに追加しました。あなたのコピーはそのまま残ります。';
  }

  @override
  String get teamUiRenameTitle => 'チームのアカウント名を変更';

  @override
  String get teamUiRenameHint => '名前(例: AWS)';

  @override
  String teamUiRemoveAccountTitle(String name) {
    return '$nameをチームから外しますか?';
  }

  @override
  String get teamUiRemoveAccountBody => 'チームの全員から消えます。';

  @override
  String get teamUiIntro =>
      'チーム保管庫では、年\$20で最大10人とログインコードを共有できます。チームの全員がチームのアカウントを見たり、追加・変更したりできます。チームだけが持つキーでデバイス上で暗号化されるため、私たちのサーバーでは読めません。チームのアカウントは専用の「チーム」セクションに入り、あなた自身のアカウントと混ざることはありません。';

  @override
  String get teamUiStart => 'チームを始める';

  @override
  String get teamUiBuy => 'チームプランを購入 — 年\$20';

  @override
  String get teamUiPlanSoon => 'チームプランは近日公開';

  @override
  String get teamUiHaveLicense => 'チームライセンスを持っている: チームを作成';

  @override
  String get teamUiJoinHelp => 'チームの管理者に招待を頼んでください。参加は無料です。';

  @override
  String get teamUiScanInvite => '招待のQRコードをスキャン';

  @override
  String get teamUiPasteInvite => '招待リンクを貼り付け';

  @override
  String get teamUiYouRun => 'あなたはこのチームの管理者です';

  @override
  String get teamUiYoureIn => 'チームに参加しています';

  @override
  String teamUiPeopleCount(int count, int max) {
    return '$max人中$count人';
  }

  @override
  String teamUiLastSynced(String when) {
    return '最終同期: $when';
  }

  @override
  String teamUiPaidUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateStringまで支払い済み';
  }

  @override
  String get teamUiSyncNow => '今すぐ同期';

  @override
  String get teamUiWaitingForKey =>
      '管理者のアプリがこのデバイスとチームキーを共有するのを待っています。次に管理者がTanooki Authを開いたときに共有されます。';

  @override
  String get teamUiAccounts => 'チームのアカウント';

  @override
  String get teamUiAddMine => '自分のを追加';

  @override
  String get teamUiNoAccounts => 'チームのアカウントはまだありません。';

  @override
  String get teamUiChange => '変更';

  @override
  String get teamUiRename => '名前を変更';

  @override
  String get teamUiRemoveFromTeam => 'チームから外す';

  @override
  String get teamUiPeople => 'メンバー';

  @override
  String get teamUiThisDevice => 'このデバイス(管理者)';

  @override
  String teamUiDevice(String id) {
    return 'デバイス $id';
  }

  @override
  String teamUiJoined(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateStringに参加';
  }

  @override
  String teamUiJoinedGettingKey(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateStringに参加 · チームキーを受け取り中';
  }

  @override
  String get teamUiDeleteTeam => 'チームを削除';

  @override
  String get teamUiLeaveTeam => 'チームを抜ける';

  @override
  String get teamUiTitle => 'チーム保管庫';

  @override
  String teamUiCopiedCode(String name) {
    return '$nameのコードをコピーしました。クリップボードは30秒後に消去されます。';
  }

  @override
  String teamUiSection(int count) {
    return 'チーム · $count';
  }

  @override
  String get teamUiWaitingShort => 'チームの管理者がこのデバイスとチームキーを共有するのを待っています。';

  @override
  String get teamUiNoAccountsHint =>
      'チームのアカウントはまだありません。「設定」>「チーム保管庫」で追加してください。';

  @override
  String get themeAuto => '自動';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeLight => 'ライト';

  @override
  String get themePink => 'パステルピンク';

  @override
  String get themeBlue => 'パステルブルー';

  @override
  String get themeLavender => 'ラベンダー';

  @override
  String get themeMint => 'ミント';

  @override
  String get themeMidnight => 'ミッドナイト';

  @override
  String get themeSunset => 'サンセット';

  @override
  String get themePeach => 'ピーチ';

  @override
  String get themeForest => 'フォレスト';

  @override
  String get themeOcean => 'オーシャン';

  @override
  String get themeMono => 'モノ';

  @override
  String get tidyNoName => '(名前なし)';

  @override
  String tidyDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の名前を整理しました。',
    );
    return '$_temp0';
  }

  @override
  String get tidyTitle => 'アカウント名を整理';

  @override
  String get tidyNothing => 'アカウント名はすべて整理済みです。';

  @override
  String get tidyIntro =>
      'これらの名前にはサイトのアドレスや余分な部分が含まれています。そのままにしたいもののチェックを外して「適用」をタップしてください。コードは変わりません。';

  @override
  String tidyWas(String name) {
    return '変更前: $name';
  }

  @override
  String get tidyNothingTicked => 'チェックなし';

  @override
  String tidyApply(int count) {
    return '$count件を適用';
  }

  @override
  String get emergencyNotContactCode =>
      'これは Tanooki Auth の連絡先コードではありません。相手に Tanooki Auth を開いて［設定］>［緊急アクセス］から連絡先コードを共有してもらってください。';

  @override
  String get emergencyCopyWontOpen =>
      'この端末の鍵では緊急用コピーを開けませんでした。別の端末用に作られたか、壊れています。';

  @override
  String get emergencyGone => 'この緊急用コピーはもうありません。持ち主が削除しました。';

  @override
  String get emergencyWaitNotOver => '7日間の待機期間はまだ終わっていません。';

  @override
  String get emergencyNotOwnerOrContact => 'この端末は、その緊急用コピーの持ち主でも連絡先でもありません。';

  @override
  String get emergencyNoRequestToDeny => '拒否するリクエストはもうありません。';

  @override
  String get emergencyAskFirst => '先にアクセスをリクエストしてください。';

  @override
  String get emergencyTooBig => 'アカウントのデータが大きすぎて緊急用コピーにできません（上限は約 500 KB です）。';

  @override
  String get emergencyTooManyTries => '1分間の試行回数が多すぎます。1分待ってからもう一度お試しください。';

  @override
  String emergencyServerSaidNo(String status) {
    return '同期サーバーに拒否されました（HTTP $status）。';
  }

  @override
  String emergencyServerSaidNoWhy(String status, String reason) {
    return '同期サーバーに拒否されました（HTTP $status: $reason）。';
  }

  @override
  String get emergencyNotEmergencyCode =>
      'これは Tanooki Auth の緊急コードではありません。あなたを選んだ人に［設定］>［緊急アクセス］からもう一度送ってもらってください。';

  @override
  String get emergencyLessThanMinute => '1分未満';

  @override
  String emergencyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count日',
    );
    return '$_temp0';
  }

  @override
  String emergencyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count時間',
    );
    return '$_temp0';
  }

  @override
  String emergencyMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count分',
    );
    return '$_temp0';
  }

  @override
  String emergencyDaysHours(int days, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
    );
    String _temp1 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours時間',
    );
    return '$_temp0$_temp1';
  }

  @override
  String get emergencyUiExplainer =>
      '信頼できる人をひとり選びましょう。あなたに何かあったとき、その人はあなたのアカウントをリクエストできます。あなたの端末に通知が届き、7日以内なら拒否できます。誰も拒否しなければ、その人にコピーが届きます。\n\nTanooki Auth のサーバーが行うのは7日間の待機だけです。コピーは相手の端末だけが持つ鍵でロックされているので、サーバーには読めませんし、サーバーに侵入した人にも読めません。';

  @override
  String emergencyUiPushNotWorking(String reason) {
    return '通知はまだ使えません（$reason）。Tanooki Auth は開くたびにリクエストを確認します。';
  }

  @override
  String get emergencyUiScanTheirQr => '相手の QR コードを読み取る';

  @override
  String get emergencyUiPasteCode => '送られてきたコードを貼り付ける';

  @override
  String get emergencyUiWrongCode => '正しいコードではありません。';

  @override
  String get emergencyUiCopiedCode => 'コピーしました。どんな方法で送っても大丈夫です。秘密情報は含まれていません。';

  @override
  String get emergencyUiCopyAsText => 'テキストとしてコピー';

  @override
  String get emergencyUiTheirContactCode => '相手の連絡先コード';

  @override
  String get emergencyUiNotContactCodeShort =>
      'これは Tanooki Auth の連絡先コードではありません。';

  @override
  String get emergencyUiMakeThemContact => 'この人を緊急連絡先にしますか？';

  @override
  String emergencyUiMakeNamedContact(String name) {
    return '$name さんを緊急連絡先にしますか？';
  }

  @override
  String get emergencyUiCopyLeftOnServer =>
      'すべてのアカウントのコピーが相手の端末用にロックされ、Tanooki Auth のサーバーに置かれます。アカウントを変更すると更新されます。';

  @override
  String get emergencyUiYourNameWhose => 'あなたの名前（誰のコピーか分かるように）';

  @override
  String get emergencyUiDoneGiveCode => '完了です。この画面のコードを相手に渡してください。';

  @override
  String get emergencyUiStopTitle => '緊急アクセスを停止しますか？';

  @override
  String get emergencyUiStopBody => 'コピーはサーバーから削除され、相手はもうリクエストできなくなります。';

  @override
  String get emergencyUiChooseContact => '緊急連絡先を選ぶ';

  @override
  String get emergencyUiChooseContactPremium => '緊急連絡先を選ぶ（Premium）';

  @override
  String get emergencyUiChooseContactHow =>
      '相手が自分の端末で Tanooki Auth を開き、［設定］>［緊急アクセス］で連絡先コードを見せてくれます。';

  @override
  String get emergencyUiYourContact => 'あなたの連絡先';

  @override
  String get emergencyUiChecking => 'サーバーに確認しています…';

  @override
  String get emergencyUiIdleJustNow => 'まだ誰もリクエストしていません。コピーはたった今更新されました。';

  @override
  String emergencyUiIdleUpdated(String day) {
    return 'まだ誰もリクエストしていません。コピーの最終更新：$day。';
  }

  @override
  String emergencyUiWaiting(String who, String day, String left) {
    return '$who さんが $day にリクエストしました。拒否しなければ、$left後にコピーを開けるようになります。';
  }

  @override
  String emergencyUiReleased(String who) {
    return '$who さんがリクエストし、待機期間が終わりました。今ならコピーを開けます。止めるには拒否してください。';
  }

  @override
  String emergencyUiContactIs(String who) {
    return '緊急連絡先：$who';
  }

  @override
  String get emergencyUiDenied => '拒否しました。相手はあなたのアカウントを開けません。後でまたリクエストできます。';

  @override
  String get emergencyUiCopyUpdated => 'コピーを更新しました。';

  @override
  String get emergencyUiCouldntUpdate => 'コピーを更新できませんでした。';

  @override
  String get emergencyUiUpdateNow => '今すぐコピーを更新';

  @override
  String emergencyUiGiveCode(String who) {
    return '$who さんにこのコードを渡してください。Tanooki Auth の［設定］>［緊急アクセス］>「もらったコードを追加」から入力できます。';
  }

  @override
  String get emergencyUiCodeTheyGave => 'もらったコード';

  @override
  String get emergencyUiNotEmergencyCodeShort =>
      'これは Tanooki Auth の緊急コードではありません。';

  @override
  String get emergencyUiAddedTheir => '追加しました。必要なときは、ここから相手のアカウントをリクエストできます。';

  @override
  String emergencyUiAddedNamed(String name) {
    return '追加しました。必要なときは、ここから $name さんのアカウントをリクエストできます。';
  }

  @override
  String get emergencyUiTheOwner => '持ち主';

  @override
  String get emergencyUiAskTitle => '緊急アクセスをリクエストしますか？';

  @override
  String emergencyUiAskBody(String who) {
    return '$who に通知が届き、7日以内なら拒否できます。拒否されなければ、ここでアカウントのコピーを開けます。本当に必要なときだけリクエストしてください。';
  }

  @override
  String get emergencyUiAsk => 'リクエスト';

  @override
  String get emergencyUiAsked => 'リクエストしました。7日間の待機が始まりました。';

  @override
  String emergencyUiAddTheirAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '相手の $count 件のアカウントを追加しますか？',
    );
    return '$_temp0';
  }

  @override
  String emergencyUiAddNamedAccounts(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name さんの $count 件のアカウントを追加しますか？',
    );
    return '$_temp0';
  }

  @override
  String get emergencyUiSomeone => '誰か';

  @override
  String get emergencyUiCheckingShort => '確認しています…';

  @override
  String get emergencyUiNotAsked => 'まだリクエストしていません。';

  @override
  String get emergencyUiRequestAccess => 'アクセスをリクエスト';

  @override
  String emergencyUiOpensIn(String left, String day) {
    return 'リクエスト済みです。拒否されなければ $left後（$day）に開けます。';
  }

  @override
  String get emergencyUiWaitOver => '待機期間が終わりました。';

  @override
  String get emergencyUiOpenCopy => '緊急用コピーを開く';

  @override
  String emergencyUiPersonAccounts(String who) {
    return '$who のアカウント';
  }

  @override
  String get emergencyUiYourContactCode => 'あなたの連絡先コード';

  @override
  String get emergencyUiShowThis =>
      '誰かがあなたを緊急連絡先にしたいときは、これを見せてください。秘密情報は含まれていません。';

  @override
  String get emergencyUiYourNameItsYou => 'あなたの名前（あなただと分かるように）';

  @override
  String get emergencyUiShowMyCode => '自分の連絡先コードを表示';

  @override
  String get emergencyUiLetThemScan => 'Tanooki Auth で読み取ってもらうか、コピーして送ってください。';

  @override
  String get emergencyUiAddCodeGiven => 'もらったコードを追加';

  @override
  String get emergencyUiAddCodeGivenHow => 'あなたを選ぶと、相手のアプリにあなた用のコードが表示されます';

  @override
  String get emergencyUiTitle => '緊急アクセス';

  @override
  String get emergencyUiYourEmergencyContact => 'あなたの緊急連絡先';

  @override
  String get emergencyUiPeopleWhoChoseYou => 'あなたを選んだ人';

  @override
  String get securityUiProofWindows => 'Windows Hello';

  @override
  String get securityUiProofMac => 'Touch ID またはパスワード';

  @override
  String get securityUiProofIos => 'Face ID またはパスコード';

  @override
  String get securityUiProofOther => '指紋または PIN';

  @override
  String securityUiPasscodeAtLeast(int count) {
    return 'パスコード（$count桁以上の数字）';
  }

  @override
  String get securityUiTypeAgain => 'もう一度入力';

  @override
  String get securityUiPasscodesDontMatch => '2つのパスコードが一致しません。';

  @override
  String get securityUiPickDifferent => 'もう一方とは違うパスコードにしてください。';

  @override
  String get securityUiEnterPasscode => 'アプリのパスコードを入力';

  @override
  String get securityUiPasscode => 'パスコード';

  @override
  String get securityUiWrongPasscode => 'パスコードが違います。';

  @override
  String get securityUiCheckupTitle => 'セキュリティチェック';

  @override
  String get securityUiAllGood => '問題ありません';

  @override
  String get securityUiAllGoodBody =>
      'アプリはロックされ、最近のバックアップがあり、すべてのアカウントに復旧コードがあります。';

  @override
  String get securityUiLockOffTitle => 'アプリがロックされていません';

  @override
  String get securityUiLockOffBody =>
      'ロック解除された端末を手にした人は誰でもコードを見られます。設定で「アプリをロック」かアプリのパスコードをオンにしてください。';

  @override
  String get securityUiNoPasscodeTitle => 'アプリのパスコードがありません';

  @override
  String get securityUiNoPasscodeBody =>
      'パスコードがあれば、Face ID や指紋が使えなくなっても Tanooki Auth を開けます。設定で登録してください。';

  @override
  String get securityUiAutoBackupFailed => '自動バックアップに失敗しました';

  @override
  String get securityUiOpenAutoBackups => '自動バックアップを開く';

  @override
  String get securityUiNoBackupTitle => '過去30日間バックアップがありません';

  @override
  String get securityUiNoBackupBody =>
      'この端末をなくしたり壊したりしたとき、アカウントを取り戻す方法はバックアップだけです。';

  @override
  String get securityUiMakeBackupNow => '今すぐバックアップ';

  @override
  String securityUiNoRecoveryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '復旧コードのないアカウントが $count 件あります',
    );
    return '$_temp0';
  }

  @override
  String securityUiNoRecoveryBody(String names) {
    return '復旧コードがあれば、このアプリをなくしてもウェブサイトに入れます。各サイトのセキュリティ設定で確認し、アカウントの ⋯ >［復旧コード］から追加してください。\n\n$names';
  }

  @override
  String get securityUiRecoveryKit => 'あなたの復旧キット';

  @override
  String get securityUiRecoveryKitSub => 'バックアップ、復旧コード、紙のコピーを順番に';

  @override
  String securityUiBreachSnack(String sites) {
    return '$sites でデータ漏えいがありました。そのサイトのパスワードを変更してください。';
  }

  @override
  String get securityUiBreachDownloadFailed =>
      '漏えいリストをダウンロードできませんでした。インターネット接続を確認して、もう一度お試しください。';

  @override
  String get securityUiBreachAlerts => '漏えいアラート';

  @override
  String get securityUiBreachAlertsPremium => '漏えいアラート（Premium）';

  @override
  String get securityUiBreachAlertsSub => '使っているサイトでデータ漏えいがあったかを週に1回お知らせします';

  @override
  String get securityUiBreachHow =>
      'しくみ：Tanooki Auth は haveibeenpwned.com から既知の漏えいの公開リストをダウンロードし、この端末上で保存済みのサイトと照合します。あなたやアカウントの情報は一切送信されません。全員が同じものをダウンロードします。同期と Premium の購入を除けば、アプリがインターネットに接続するのはこのときだけです。';

  @override
  String securityUiNoWebsite(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントにサイトが保存されていないため、確認できません。⋯ >［編集］で追加してください。',
    );
    return '$_temp0';
  }

  @override
  String get securityUiCheckNow => '今すぐ確認';

  @override
  String get securityUiNoBreaches => '保存済みのサイトに既知の漏えいはありません。';

  @override
  String get securityUiBreached =>
      '漏えいがありました。それ以前にパスワードを作った場合は、そのサイトで変更してください。';

  @override
  String securityUiBreachedOn(String date) {
    return '$date に漏えい。それ以前にパスワードを作った場合は、そのサイトで変更してください。';
  }

  @override
  String securityUiBreachedLeaked(String data) {
    return '漏えいがありました。漏れた情報：$data。それ以前にパスワードを作った場合は、そのサイトで変更してください。';
  }

  @override
  String securityUiBreachedOnLeaked(String date, String data) {
    return '$date に漏えい。漏れた情報：$data。それ以前にパスワードを作った場合は、そのサイトで変更してください。';
  }

  @override
  String get securityUiKitIntro =>
      'この端末をなくしたときは、これらでアカウントに戻れます。どれも1分ほどで終わります。まだアカウントを追加していない場合は、先に追加してから［設定］>［セキュリティチェック］でここに戻ってきてください。';

  @override
  String get securityUiKitBackupTitle => 'バックアップを作る';

  @override
  String get securityUiKitBackupBody =>
      '自分で決めたパスフレーズでロックされた暗号化ファイルです。iCloud Drive、Google Drive、USB メモリなど、この端末以外の場所に保管してください。';

  @override
  String get securityUiKitBackupButton => 'バックアップを作る';

  @override
  String get securityUiKitCodesTitle => '復旧コードを保存する';

  @override
  String get securityUiKitCodesBody =>
      '2段階認証をオンにすると、多くのサイトで使い捨ての復旧コードの一覧がもらえます。各アカウントの ⋯ >［復旧コード］から追加すれば、バックアップにも含まれます。';

  @override
  String get securityUiKitPaperTitle => '紙のバックアップを印刷する';

  @override
  String get securityUiKitPaperBody =>
      '任意です。QR コードを印刷した紙は、すべての端末がなくなっても使えます。しっかり保管してください。持っている人は誰でもコードを作れます。';

  @override
  String get securityUiKitPaperButton => '紙のバックアップを印刷';

  @override
  String get securityUiSkipForNow => '今はスキップ';

  @override
  String get securityExtrasPrivacy =>
      'アカウント登録なし、トラッキングなし。セットアップキーはこの端末に暗号化して保存されます。アプリがインターネットに接続するのは次の場合だけです：時刻の確認（コードの表示中に1時間に最大1回、および「コードが使えない？」をタップしたときに Tanooki Auth のサーバーへ時刻を問い合わせます。あなたやアカウントの情報は送信されません）、オンにした場合の漏えいアラート（公開されている漏えいリストをダウンロード）、設定した場合の同期・スマホ連携・緊急アクセス（サーバーが読めない暗号化データだけを送ります）、Premium の購入、そして自分で送るフィードバック（メッセージ、入力した場合はメールアドレス、チェックを残した場合はアプリのバージョンと端末の種類。アカウントやコードなど、アプリ内のほかの情報は決して送りません）。2FA ガイドはウェブブラウザで開きます。';

  @override
  String get securityExtrasMonthlyBody =>
      '毎月のセキュリティまとめができました。Tanooki Auth を開いて確認しましょう。';

  @override
  String get securityExtrasNotificationsOffIos =>
      'Tanooki Auth の通知がオフになっています。iPhone の設定アプリの［通知］でオンにしてから、もう一度お試しください。';

  @override
  String get securityExtrasNotificationsOffMac =>
      'Tanooki Auth の通知がオフになっています。システム設定の［通知］でオンにしてから、もう一度お試しください。';

  @override
  String securityExtrasReminderFailed(String reason) {
    return 'リマインダーを設定できませんでした（$reason）。';
  }

  @override
  String get securityExtrasRemindersUnavailable => 'この端末ではまだリマインダーを使えません。';

  @override
  String securityExtrasDayTime(String day, String time) {
    return '$day $time';
  }

  @override
  String get securityExtrasClearTitle => 'アクティビティ履歴を消去しますか？';

  @override
  String get securityExtrasClearBody => 'この端末からすべての記録が削除されます。アカウントには影響しません。';

  @override
  String get securityExtrasActivityTitle => 'アクティビティ履歴';

  @override
  String securityExtrasActivityPitch(int count) {
    return 'アクティビティ履歴は Premium の機能です。コードのコピー、サイトへの入力、タイプ入力、QR コード表示、書き出しの直近 $count 回分を、この端末だけに記録します。';
  }

  @override
  String get securityExtrasNothingYet =>
      'まだ何もありません。コピー、入力、タイプ、QR コード表示、書き出しをするとここに表示されます。';

  @override
  String get securityExtrasAllAccounts => 'すべてのアカウント';

  @override
  String get securityExtrasDeletedAccount => '削除したアカウント';

  @override
  String securityExtrasActivityLine(String kind, String what) {
    return '$kind：$what';
  }

  @override
  String get securityExtrasGetPremium => 'Premium を入手';

  @override
  String get securityExtrasAddKey => 'セキュリティキーを追加';

  @override
  String get securityExtrasAddKeyPremium => 'セキュリティキーを追加（Premium）';

  @override
  String get securityExtrasAddKeyIos =>
      '次に、求められたらキーを iPhone の上部にかざすか、差し込んでください。2回タッチが必要な場合があります。';

  @override
  String get securityExtrasAddKeyOther =>
      '次に、キーを差し込んで、点滅したらタッチしてください。2回タッチが必要な場合や、PIN がある場合は入力が必要なことがあります。';

  @override
  String get securityExtrasKeyName => '名前（キーを見分けられるように）';

  @override
  String securityExtrasKeyAdded(String name) {
    return '「$name」を追加しました。この端末ではこのキーで Tanooki Auth のロックを解除できます。';
  }

  @override
  String securityExtrasKeyRemoved(String name) {
    return '「$name」を削除しました。このキーではもう Tanooki Auth のロックを解除できません。';
  }

  @override
  String get securityExtrasKeysTitle => 'セキュリティキー';

  @override
  String securityExtrasKeysIntro(String usual) {
    return 'セキュリティキー（YubiKey など）を使うと、$usualの代わりに Tanooki Auth のロックを解除できます。キーの中には外に出ない秘密があり、アプリはそれでアカウントの鍵を守ります。キーをなくしても、いつもの方法でロックを解除できます。';
  }

  @override
  String securityExtrasKeyAddedOn(String day) {
    return '$day に追加';
  }

  @override
  String get securityExtrasLockOffNote =>
      'アプリのロックがオフなので、何も聞かれずに開きます。キーを使うには、設定で「アプリをロック」かパスコードをオンにしてください。';

  @override
  String get securityExtrasLockWordWindows => 'Windows Hello やパスコード';

  @override
  String get securityExtrasLockWordMac => 'Touch ID やパスコード';

  @override
  String get securityExtrasLockWordOther => 'Face ID やパスコード';

  @override
  String get securityLockImmediately => 'すぐに';

  @override
  String get securityLockAfter30s => '30秒後';

  @override
  String get securityLockAfter1m => '1分後';

  @override
  String get securityLockAfter5m => '5分後';

  @override
  String get securityNumbersOnly => '数字だけを使ってください。';

  @override
  String securityAtLeastNumbers(int count) {
    return '$count桁以上にしてください。';
  }

  @override
  String get securitySameNumber => '同じ数字の繰り返しは使わないでください。';

  @override
  String get securityNumbersInRow => '123456 のような連続した数字は使わないでください。';

  @override
  String get securityPanicNeedsPasscode =>
      '先にアプリのパスコードを設定してください。緊急消去は間違ったパスコードの回数を数えます。';

  @override
  String get securityPanicNeedsBackup =>
      '先にバックアップを作ってください（［設定］>［バックアップを書き出す］）。緊急消去はすべてのアカウントを消すため、過去30日以内にバックアップがある場合だけオンにできます。';

  @override
  String get securityKeyDefaultName => 'セキュリティキー';

  @override
  String get securityKeyNotYours =>
      'そのセキュリティキーは、この端末の Tanooki Auth に追加したものではありません。';

  @override
  String get securityKeyNotAvailable => 'この端末ではまだ使えません。';

  @override
  String get securityKeyWindowsTooOld =>
      'このバージョンの Windows ではまだ使えません。最新の Windows 11 アップデートをインストールしてください。';

  @override
  String get securityKeyIosTooOld =>
      'iOS 26.4 以降が必要です。設定アプリでアップデートしてから、もう一度お試しください。';

  @override
  String get securityKeyMacTooOld =>
      'macOS 26.4 以降が必要です。設定アプリでアップデートしてから、もう一度お試しください。';

  @override
  String get securityKeyDidntWork => 'セキュリティキーがうまく動きませんでした。もう一度お試しください。';

  @override
  String securityKeyDidntWorkWhy(String reason) {
    return 'セキュリティキーがうまく動きませんでした（$reason）。もう一度お試しください。';
  }

  @override
  String get securityKeyCanceled => 'キャンセルしました。何も変わっていません。';

  @override
  String get securityKeyNoPrf =>
      'このセキュリティキーでは、この方法でアプリのロックを解除できません（「hmac-secret」機能がありません）。YubiKey 5 シリーズや、ここ数年の FIDO2 キーの多くは対応しています。';

  @override
  String get securityKeyNotAllowed =>
      'セキュリティキーが応答しなかったか、ここで追加したキーではありません。差し込む（またはスマホの上部にかざす）と、点滅したときにタッチしてください。';

  @override
  String get securityKeyNotAssociated =>
      'この Tanooki Auth ではまだセキュリティキーを使えません。Apple の仕組み上、先にアプリを auth.tanookistudios.com と連携させる必要があります。これはこちら側の作業で、あなたがすることはありません。';

  @override
  String get securityKeyExists => 'このセキュリティキーはすでに追加されています。';

  @override
  String get securityKeyPin =>
      'セキュリティキーの PIN が必要ですが、入力されませんでした。もう一度試して、求められたらキーの PIN を入力してください。';

  @override
  String get securityKeyVaultKeyMissing =>
      'アカウントのロックを解除する鍵が見つからないため、セキュリティキーを追加できません。';

  @override
  String get securityKeyNoneAdded => 'この端末にはセキュリティキーが追加されていません。';

  @override
  String get securityKeyBeforeReset =>
      'そのセキュリティキーはアカウントをリセットする前に追加されたため、開けません。削除してから追加し直してください。';

  @override
  String get backupUiChoosePassphrase => 'バックアップのパスフレーズを決める';

  @override
  String get backupUiPassphraseTitle => 'バックアップのパスフレーズ';

  @override
  String get backupUiPassphraseWarning =>
      'バックアップを復元するときに必要です。忘れると、私たちを含め誰にも取り戻せません。安全な場所に書き留めておいてください。';

  @override
  String get backupUiPassphrase => 'パスフレーズ';

  @override
  String get backupUiTypeAgain => 'もう一度入力';

  @override
  String get backupUiTooShort => '8文字以上にしてください。ランダムな単語をいくつか並べるのがおすすめです。';

  @override
  String get backupUiNoMatch => '2つのパスフレーズが一致しません。';

  @override
  String get backupUiTypePassphrase => 'パスフレーズを入力してください。';

  @override
  String get backupUiNothingToBackUp => 'バックアップするアカウントはまだありません。';

  @override
  String get backupUiEncrypting => 'バックアップを暗号化しています…';

  @override
  String backupUiSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントのバックアップを保存しました。',
    );
    return '$_temp0';
  }

  @override
  String get backupUiNotABackup => 'このファイルは Tanooki Auth のバックアップではありません。';

  @override
  String get backupUiUnlocking => 'バックアップのロックを解除しています…';

  @override
  String backupUiImported(int count) {
    return '$count 件を読み込みました。';
  }

  @override
  String backupUiImportedSkipped(int added, int skipped) {
    return '$added 件を読み込み、$skipped 件をスキップしました。';
  }

  @override
  String backupUiImportedSkippedAlready(int added, int skipped) {
    return '$added 件を読み込み、すでにリストにある $skipped 件をスキップしました。';
  }

  @override
  String backupUiAdded(int count) {
    return '$count 件を追加しました。';
  }

  @override
  String backupUiAddedSkipped(int added, int skipped) {
    return '$added 件を追加し、$skipped 件をスキップしました。';
  }

  @override
  String backupUiAddedSkippedAlready(int added, int skipped) {
    return '$added 件を追加し、すでにリストにある $skipped 件をスキップしました。';
  }

  @override
  String backupUiAlreadyInList(int count) {
    return '• $count 件はすでにリストにあります';
  }

  @override
  String get backupUiImport => '読み込む';

  @override
  String backupUiImportFromGoogle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Google Authenticator から $count 件を読み込みますか？',
    );
    return '$_temp0';
  }

  @override
  String get backupUiGoogleMoreCodes =>
      'Google Authenticator に QR コードが複数表示された場合は、すべて読み取ってください。';

  @override
  String get backupUiNothingToExport => '書き出すアカウントはまだありません。';

  @override
  String get backupUiPlainWhat => 'すべてのセットアップキーを暗号化せずに保存します。別の認証アプリに移るためのものです。';

  @override
  String get backupUiPlainTitle => '暗号化せずに書き出しますか？';

  @override
  String backupUiPlainBody(String what) {
    return '$whatこのファイルを手に入れた人は誰でもログインコードを作れます。読み込んだらすぐに削除してください。通常のバックアップには「バックアップを書き出す」を使いましょう。';
  }

  @override
  String get backupUiUnderstandExport => '理解したうえで書き出す';

  @override
  String get backupUiNothingToPrint => '印刷するアカウントはまだありません。';

  @override
  String get backupUiPaperTitle => '紙のバックアップを印刷しますか？';

  @override
  String get backupUiPaperBody =>
      'すべてのアカウントの QR コードと、未使用の復旧コードが入った PDF を作ります。この紙を見たり撮影したりした人は、あなたのスマホやパスワードがなくても、ずっとログインコードを作れてしまいます。\n\n印刷したら PDF は削除してください。紙は金庫や大切な書類と一緒など、鍵のかかる場所に保管しましょう。メールで送ったり、共有フォルダーに保存したりしないでください。';

  @override
  String get backupUiUnderstandPdf => '理解したうえで PDF を作る';

  @override
  String get backupUiMakingPdf => 'PDF を作成しています…';

  @override
  String get backupUiPdfReady => 'PDF ができました。印刷したらファイルを削除してください。';

  @override
  String get backupUiWorksTitle => 'バックアップは正常です';

  @override
  String backupUiWorksBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'このバックアップは問題なく開け、$count 件のアカウントが入っています。何も追加・変更していません。',
    );
    return '$_temp0';
  }

  @override
  String get backupWrongVersion =>
      'このバックアップは新しいバージョンの Tanooki Auth で作られています。アプリをアップデートしてから、もう一度お試しください。';

  @override
  String get backupWrongPassphrase => 'パスフレーズが違うか、バックアップファイルが壊れています。';

  @override
  String get backupDamaged => 'バックアップのロックは解除できましたが、中身が壊れています。';

  @override
  String get paperBackupTitle => 'Tanooki Auth 紙のバックアップ';

  @override
  String paperBackupHeader(String date) {
    return 'Tanooki Auth 紙のバックアップ、$date';
  }

  @override
  String get paperBackupWarning =>
      'これは秘密にしてください。この紙を持っている人は誰でもログインコードを作れます。鍵のかかる場所に保管し、新しく作ったら古いものはシュレッダーにかけてください。復元方法：どの認証アプリでも「QR コードを読み取る」を選び、下のコードを1つずつ読み取ります。';

  @override
  String paperBackupSetupKey(String key) {
    return 'セットアップキー：$key';
  }

  @override
  String get paperBackupRecoveryCodes => '復旧コード（それぞれ1回だけ使えます）：';

  @override
  String get autoBackupUiChooseFolderDialog => '自動バックアップ用のフォルダーを選ぶ';

  @override
  String autoBackupUiToday(String time) {
    return '今日 $time';
  }

  @override
  String autoBackupUiYesterday(String time) {
    return '昨日 $time';
  }

  @override
  String autoBackupUiOnDay(String date, String time) {
    return '$date $time';
  }

  @override
  String get autoBackupUiBackingUp => 'バックアップしています…';

  @override
  String autoBackupUiBackedUp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントをバックアップしました。',
    );
    return '$_temp0';
  }

  @override
  String get autoBackupUiCouldntUseFolder => 'そのフォルダーは使えませんでした。';

  @override
  String autoBackupUiCouldntUseFolderWhy(String reason) {
    return 'そのフォルダーは使えませんでした。$reason';
  }

  @override
  String get autoBackupUiTurnOffTitle => '自動バックアップをオフにしますか？';

  @override
  String get autoBackupUiTurnOffBody =>
      'フォルダー内の既存のバックアップはそのまま残ります。パスフレーズは消去されるので、もう一度オンにするときは新しく決めてください。';

  @override
  String get autoBackupUiTitle => '自動バックアップ';

  @override
  String get autoBackupUiTitlePremium => '自動バックアップ（Premium）';

  @override
  String autoBackupUiIntro(int count) {
    return 'Tanooki Auth は1日1回、選んだフォルダーに暗号化したバックアップを保存します。iCloud Drive、Google Drive、Dropbox のフォルダーを選べば、バックアップはこの端末の外にも残ります。最新の $count 件を残し、古いものは削除します。\n\n復元するには［設定］>［バックアップを読み込む］でバックアップのパスフレーズを入力します。';
  }

  @override
  String get autoBackupUiLastFailed => '前回の自動バックアップは失敗しました';

  @override
  String get autoBackupUiChooseFolder => 'フォルダーを選ぶ';

  @override
  String get autoBackupUiBackupFolder => 'バックアップフォルダー';

  @override
  String get autoBackupUiNoBackupYet => 'まだバックアップはありません';

  @override
  String autoBackupUiLastBackup(String when) {
    return '前回のバックアップ：$when';
  }

  @override
  String get autoBackupUiBackUpNow => '今すぐバックアップ';

  @override
  String get autoBackupUiChangeFolder => 'フォルダーを変更';

  @override
  String get autoBackupUiOffSubtitle =>
      'オフ。iCloud Drive、Google Drive、Dropbox などのフォルダーに毎日暗号化バックアップを保存します。';

  @override
  String autoBackupUiOnNoBackup(String folder) {
    return 'オン（$folder）。まだバックアップはありません。';
  }

  @override
  String autoBackupUiOnLast(String folder, String when) {
    return 'オン（$folder）。前回のバックアップ：$when。';
  }

  @override
  String get autoBackupFolderGone =>
      'バックアップフォルダーが見つかりません。削除されたか、アプリの外で名前が変わったか、ドライブが外れている可能性があります。もう一度フォルダーを選んでください。';

  @override
  String get autoBackupPermissionLost =>
      'Tanooki Auth はバックアップフォルダーに書き込めなくなりました。もう一度フォルダーを選んで許可し直してください。';

  @override
  String get autoBackupDiskFull =>
      'バックアップフォルダーのドライブがいっぱいです。空き容量を作ってから［今すぐバックアップ］をタップしてください。';

  @override
  String get autoBackupOther =>
      'バックアップを保存できませんでした。［今すぐバックアップ］をタップしてもう一度お試しください。';

  @override
  String autoBackupOtherWhy(String reason) {
    return 'バックアップを保存できませんでした（$reason）。［今すぐバックアップ］をタップしてもう一度お試しください。';
  }

  @override
  String get importUiDeleteNote =>
      '終わったら書き出したファイルを削除してください。手に入れた人は誰でもコードを作れます。';

  @override
  String get importUiStepsAegis =>
      'Android スマホの Aegis で：\n\n1. ⋮ をタップし、［設定］、「インポートとエクスポート」の順に進みます。\n2. 「エクスポート」をタップし、「Aegis (.JSON)」を選びます。\n3. 「保管庫を暗号化」はオンのままでも大丈夫です。そのパスワードをここで入力します。\n4. この端末で開ける場所にファイルを保存します（Google Drive や自分宛てのメールなど）。\n\nそのあと、ここでそのファイルを選んでください。';

  @override
  String get importUiStepsTwoFas =>
      '2FAS で：\n\n1. ［設定］を開き、「2FAS バックアップ」に進みます。\n2. 「ファイルにエクスポート」をタップします。パスワードを聞かれたら、同じものをここで入力します。\n3. .2fas ファイルをこの端末で開ける場所に保存します。\n\nそのあと、ここでそのファイルを選んでください。';

  @override
  String get importUiStepsAuthy =>
      'Authy にはエクスポートボタンがなく、パソコン版 Authy は2024年に終了しました。\n\n「authy-export」などのツールですでにアカウントを取り出している場合は、そのツールが作ったファイル（.json ファイル、または otpauth:// リンクを並べた .txt）を選んでください。\n\nそうでなければ、1つずつ移すのが安全です。各サイトにログインし、2段階認証をいったんオフにしてオンに戻し、新しい QR コードを Tanooki Auth で読み取ります。すべてのアカウントがここで使えるまで Authy は残しておきましょう。';

  @override
  String get importUiStepsBitwarden =>
      'Bitwarden（ウェブサイトまたはデスクトップアプリ）で：\n\n1. ［ツール］から「保管庫のエクスポート」に進みます。\n2. 「.json」か「.csv」を選びます。「暗号化」は選ばないでください。\n3. ファイルを保存します。\n\nそのあと、ここでそのファイルを選んでください。認証キーのあるログインだけが移り、パスワードは無視されます。';

  @override
  String get importUiStepsOnePassword =>
      'Mac または Windows の 1Password アプリで：\n\n1. ［ファイル］、［エクスポート］の順にクリックし、アカウントを選びます。\n2. 形式に「CSV」を選んで保存します。\n\nそのあと、ここでそのファイルを選んでください。ワンタイムパスワードのある項目だけが移り、パスワードは無視されます。';

  @override
  String get importUiStepsApple =>
      'これには Mac が必要です。iPhone ではファイルを保存できません。\n\nmacOS Sequoia 以降の Mac の場合：\n1. 「パスワード」アプリを開きます。\n2. メニューバーの［ファイル］から「すべてのパスワードを書き出す…」を選びます。\n3. 「パスワードを書き出す」をクリックし、求められたら Mac のパスワードを入力して、ファイルを保存します。\n\n古い Mac の場合：Safari を開き、Safari >［設定］>［パスワード］で ⋯ ボタンをクリックし、「すべてのパスワードを書き出す…」を選びます。\n\nそのあと、ここでそのファイルを選んでください。確認コードのある項目だけが移り、パスワードは無視されます。';

  @override
  String get importUiStepsMicrosoft =>
      'Microsoft Authenticator はアカウントを書き出せないため、まとめて移すことはできません。\n\nアカウントごとに：\n1. パソコンでそのサイトにログインします。\n2. セキュリティまたは2段階認証の設定を探します。\n3. 2段階認証をいったんオフにしてオンに戻します（または「新しい認証アプリを追加」を選びます）。\n4. 新しい QR コードを Tanooki Auth で読み取り、表示されたコードを入力して完了です。\n\nすべてのアカウントが Tanooki Auth で使えるまで Microsoft Authenticator は残しておきましょう。Microsoft アカウント自体も Tanooki Auth で使えます。account.microsoft.com の［セキュリティ］で追加してください。';

  @override
  String get importUiTitle => 'ほかのアプリから移す';

  @override
  String get importUiCantExport => '書き出し不可：アカウントを1つずつ移す方法';

  @override
  String get importUiFromExportFile => '書き出したファイルから';

  @override
  String importUiMoveFrom(String app) {
    return '$app から移す';
  }

  @override
  String get importUiGotIt => 'わかりました';

  @override
  String get importUiPickFile => 'ファイルを選ぶ';

  @override
  String get importUiCouldntRead => 'そのファイルを読み込めませんでした。';

  @override
  String importUiReading(String app) {
    return '$app の書き出しファイルを読み込んでいます…';
  }

  @override
  String get importUiNoAccountsInFile => 'そのファイルに2段階認証のアカウントはありませんでした。';

  @override
  String importUiImportFrom(int count, String app) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$app から $count 件を読み込みますか？',
    );
    return '$_temp0';
  }

  @override
  String importUiExportPassword(String app) {
    return '$app の書き出しパスワード';
  }

  @override
  String get importUiPasswordHint => '書き出すときに決めたパスワード';

  @override
  String importersNotAnExport(String app) {
    return 'このファイルは $app の書き出しファイルではありません。';
  }

  @override
  String importersLine(String line, String problem) {
    return '$line 行目：$problem';
  }

  @override
  String get importersEmpty => 'そのファイルは空です。';

  @override
  String get importersNotAuthy => 'このファイルは Authy の書き出しファイルではありません。';

  @override
  String get importersAnAccount => 'あるアカウント';

  @override
  String importersQuoted(String name) {
    return '「$name」';
  }

  @override
  String importersProblemColon(String name, String problem) {
    return '$name：$problem';
  }

  @override
  String importersProblem(String name, String problem) {
    return '$name：$problem';
  }

  @override
  String get importersAegisPassword => 'この Aegis の書き出しファイルはパスワードで保護されています。';

  @override
  String get importersAegisBiometricOnly =>
      'この Aegis の書き出しファイルは、作成したスマホの指紋でしか開けません。Aegis でパスワードを設定して書き出し直してください。';

  @override
  String get importersAegisWrongPassword => 'この Aegis の書き出しファイルのパスワードが違います。';

  @override
  String get importersAegisDamaged => 'Aegis の書き出しファイルのロックは解除できましたが、中身が壊れています。';

  @override
  String get importersNotAegis => 'このファイルは Aegis の書き出しファイルではありません。';

  @override
  String importersUnsupportedType(String type) {
    return '$type 形式のコードを使っていますが、Tanooki Auth は対応していません';
  }

  @override
  String get importersNotTwoFas => 'このファイルは 2FAS のバックアップではありません。';

  @override
  String get importersTwoFasPassword => 'この 2FAS のバックアップはパスワードで保護されています。';

  @override
  String get importersTwoFasDamaged => 'この 2FAS のバックアップは壊れています。';

  @override
  String get importersTwoFasWrongPassword => 'この 2FAS のバックアップのパスワードが違います。';

  @override
  String get importersBitwardenEncrypted =>
      'その Bitwarden の書き出しファイルは暗号化されています。Bitwarden で「.json」形式（「暗号化」ではないもの）を選んで書き出し直してください。';

  @override
  String get importersOnePux =>
      '1Password の .1pux ファイルのようです。1Password で CSV を選んで書き出し直してください。';

  @override
  String importersNoCodeColumn(String app) {
    return 'そのファイルにはワンタイムコードの列がないため、コード入りの $app の書き出しファイルではありません。';
  }

  @override
  String importersCantReadCode(String reason) {
    return 'Tanooki Auth で読めないワンタイムコードがあります（$reason）';
  }

  @override
  String get importersNoSecret => 'シークレットがありません';

  @override
  String get importersBadSecret => 'シークレットが正しくありません';

  @override
  String importersUnsupportedDigits(int count) {
    return '$count 桁のコードを使っていますが、Tanooki Auth は対応していません';
  }

  @override
  String get importersBadPeriod => '時間の間隔が壊れています';

  @override
  String importersUnsupportedAlgorithm(String algorithm) {
    return '$algorithm アルゴリズムを使っていますが、Tanooki Auth は対応していません';
  }

  @override
  String get exportUiTitle => 'ほかのアプリに移す';

  @override
  String get exportUiAegisLocked => 'Aegis（パスワード付き）';

  @override
  String get exportUiAegisLockedSub => '最も安全です。読み込むときに Aegis がパスワードを聞きます。';

  @override
  String get exportUiAegisPlain => 'Aegis（暗号化なし）';

  @override
  String get exportUiAegisPlainSub => 'Aegis ファイルは読めても、ロック付きのものは開けないアプリ向けです。';

  @override
  String get exportUiTwoFasSub => 'パスワードなしの .2fas ファイルです。';

  @override
  String get exportUiGoogleSub => 'Google Authenticator で読み取る QR コードです。';

  @override
  String get exportUiLinks => 'セットアップリンク（プレーンテキスト）';

  @override
  String get exportUiLinksSub => '1行に1つの otpauth:// リンク。ほかのどのアプリにも使えます。';

  @override
  String get exportUiConfirmReason => 'アカウントを書き出す';

  @override
  String get exportUiEncryptingAegis => 'Aegis 用に暗号化しています…';

  @override
  String get exportUiAegisPlainWhat => 'すべてのセットアップキーを暗号化なしの Aegis ファイルに保存します。';

  @override
  String get exportUiTwoFasWhat => 'すべてのセットアップキーをパスワードなしの 2FAS ファイルに保存します。';

  @override
  String get exportUiGoogleTitle => 'Google Authenticator 用の QR コードを表示しますか？';

  @override
  String get exportUiGoogleBody =>
      '次の画面に、すべてのセットアップキーを含む QR コードが表示されます。見たり撮影したりした人は誰でもログインコードを作れます。人目のない場所で行ってください。\n\nGoogle Authenticator で：+ をタップし、「QR コードをスキャン」を選んで、コードを1つずつ読み取ります。';

  @override
  String get exportUiShowCodes => 'コードを表示';

  @override
  String exportUiExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントを書き出しました。もう一方のアプリでファイルを読み込んだら削除してください。',
    );
    return '$_temp0';
  }

  @override
  String get exportUiNoneForGoogle => 'Google Authenticator に移せるアカウントはありません。';

  @override
  String get exportUiScanThisCode => 'このコードを読み取ってください';

  @override
  String exportUiCodeOf(int n, int total) {
    return 'コード $n/$total';
  }

  @override
  String get exportUiNextCode => '次のコード';

  @override
  String exportUiLeftOut(int count) {
    return '対象外（$count 件）。Google Authenticator ではこれらのコードを作れないため、別のアプリに追加してください：';
  }

  @override
  String get appIconClassic => 'クラシック';

  @override
  String get appIconPink => 'パステルピンク';

  @override
  String get appIconBlue => 'パステルブルー';

  @override
  String get appIconLavender => 'ラベンダー';

  @override
  String get appIconMint => 'ミント';

  @override
  String get appIconMidnight => 'ミッドナイト';

  @override
  String get appIconSunset => 'サンセット';

  @override
  String get appIconSpooky => 'スプーキー（秋）';

  @override
  String get appIconCozy => 'コージー（冬）';

  @override
  String get appIconSpring => 'スプリング';

  @override
  String get serverBrowserExtension => 'ブラウザ拡張機能';

  @override
  String get serverBadRequest => 'Tanooki Auth はそのリクエストを理解できませんでした。';

  @override
  String get serverLocked => 'Tanooki Auth はロックされています。ロックを解除してから、もう一度お試しください。';

  @override
  String get serverNotPaired => 'このアプリは Tanooki Auth とペアリングされていません。';

  @override
  String get serverNotFound => 'そのアカウントはもう Tanooki Auth にありません。';

  @override
  String get serverRateLimited => 'リクエストが多すぎます。';

  @override
  String get serverDenied =>
      '許可されていません。このアカウントは先に確認が必要ですが、Tanooki Auth のロックが解除されませんでした。';

  @override
  String get serverUnknownScreen => '不明な画面です。';

  @override
  String get serverNoWebsite => 'サイトが指定されていません。';

  @override
  String serverUnknownRequest(String type) {
    return '不明なリクエスト「$type」です。';
  }

  @override
  String get serverPairingTimedOut =>
      'ペアリングがタイムアウトしたか、閉じられました。もう一度ペアリングを始めてください。';

  @override
  String get serverThreeWrongCodes => 'コードを3回間違えました。もう一度ペアリングを始めてください。';

  @override
  String get serverWrongCode => 'コードが一致しません。Tanooki Auth に表示されているコードを確認してください。';

  @override
  String get serverNoLink => 'otpauth:// リンクが送られてきませんでした。';

  @override
  String get serverAlreadyThere => 'そのアカウントはすでに Tanooki Auth にあります。';

  @override
  String get serverAlreadyThereMany => 'それらのアカウントはすでに Tanooki Auth にあります。';

  @override
  String get autoBackupNotSupported => 'この端末では使えません';

  @override
  String homeProveCopy(String name) {
    return '$name のコードをコピー';
  }

  @override
  String homeProveReadAloud(String name) {
    return '$name のコードを読み上げ';
  }

  @override
  String homeProveEdit(String name) {
    return '$name を編集';
  }

  @override
  String homeProveShare(String name) {
    return '$name を共有';
  }

  @override
  String homeCopied(String name) {
    return '$name のコードをコピーしました。クリップボードは30秒後に消去されます。';
  }

  @override
  String get homeEditAccount => 'アカウントを編集';

  @override
  String homeShowQrFor(String name) {
    return '$name の QR コードを表示';
  }

  @override
  String homeMovedToTrash(String name) {
    return '$name をゴミ箱に移動しました。30日間は設定から元に戻せます。';
  }

  @override
  String get homeUndo => '元に戻す';

  @override
  String homeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウント',
    );
    return '$_temp0';
  }

  @override
  String homeAddTagTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントにタグを追加',
    );
    return '$_temp0';
  }

  @override
  String get homeTagHint => 'タグ（例：仕事）';

  @override
  String get homeAddTag => 'タグを追加';

  @override
  String homeTagged(int count, String tag) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントにタグ「$tag」を付けました。',
    );
    return '$_temp0';
  }

  @override
  String homeMoveToFolderTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントをフォルダーに移動',
    );
    return '$_temp0';
  }

  @override
  String get homeNoFolder => 'フォルダーなし';

  @override
  String get homeNewFolderHint => 'または新しいフォルダー（例：仕事）';

  @override
  String get homeMoveToNewFolder => '新しいフォルダーに移動';

  @override
  String homeTookOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントをフォルダーから出しました。',
    );
    return '$_temp0';
  }

  @override
  String homeMovedTo(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントを $folder に移動しました。',
    );
    return '$_temp0';
  }

  @override
  String homeAddedToFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントをお気に入りに追加しました。',
    );
    return '$_temp0';
  }

  @override
  String homeRemovedFromFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントをお気に入りから外しました。',
    );
    return '$_temp0';
  }

  @override
  String homeBulkTrashed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のアカウントをゴミ箱に移動しました。30日間は設定から元に戻せます。',
    );
    return '$_temp0';
  }

  @override
  String get homeDoneSelecting => '選択を終了';

  @override
  String get homeTapToSelect => 'アカウントをタップして選択';

  @override
  String homeSelectedCount(int count) {
    return '$count 件選択中';
  }

  @override
  String get homeSelectNone => '選択を解除';

  @override
  String get homeSelectAll => 'すべて選択';

  @override
  String get homeAddATag => 'タグを追加';

  @override
  String get homeMoveToFolder => 'フォルダーに移動';

  @override
  String get homeRemoveFromFavorites => 'お気に入りから外す';

  @override
  String get homeAddToFavorites => 'お気に入りに追加';

  @override
  String get homeMoveToTrash => 'ゴミ箱に移動';

  @override
  String get homeSelectFirst => '先にアカウントを選んでください。リストでタップします。';

  @override
  String homeSectionOpen(String name, String accounts) {
    return '$name、$accounts、タップして折りたたむ';
  }

  @override
  String homeSectionClosed(String name, String accounts) {
    return '$name、$accounts、タップして表示';
  }

  @override
  String get homeSearchHint => 'アカウントやサイトを検索…';

  @override
  String get homeAllTags => 'すべて';

  @override
  String get homeNoAccountsYet =>
      'アカウントはまだありません。\n追加してセットアップ用の QR コードを読み取りましょう。';

  @override
  String get homeNoTagMatches => 'このタグのアカウントはありません。';

  @override
  String get homeNoSearchMatches => '検索に一致するアカウントはありません。';

  @override
  String get homeSelectAccounts => 'アカウントを選択';

  @override
  String get homeSettings => '設定';

  @override
  String get homeAddAccount => 'アカウントを追加';

  @override
  String get homeAccounts => 'アカウント';

  @override
  String get homeYourAccounts => 'あなたのアカウント';

  @override
  String get homeSelect => '選択';

  @override
  String get homeKeysTouch => 'タップ（コピー）・Enter（コピー）・矢印（移動）';

  @override
  String get homeKeysClick => 'クリック（コピー）・Enter（コピー）・矢印（移動）';

  @override
  String get homePickOnLeft => '左のアカウントを選ぶと、ここに表示されます。';

  @override
  String homeQrFor(String name) {
    return '$name の QR コード';
  }

  @override
  String get homeQrWarning =>
      '別の認証アプリでこれを読み取ると、同じアカウントを追加できます。見たり撮影したりした人は誰でもコードを作れるので、人に見せないでください。';

  @override
  String homeVersionNote(Object version) {
    return 'v$version・この端末だけに保存';
  }

  @override
  String homeSelectName(String name) {
    return '$name を選択';
  }

  @override
  String get homeMore => 'その他';

  @override
  String get homeRecoveryCodes => '復旧コード';

  @override
  String homeRecoveryCodesLeft(int count) {
    return '復旧コード（残り $count）';
  }

  @override
  String get homeShareSecurely => '安全に共有';

  @override
  String get homeShowQr => 'QR コードを表示';

  @override
  String get homeMoveEarlier => '上へ移動';

  @override
  String get homeMoveLater => '下へ移動';

  @override
  String homeNextCodeShort(String code) {
    return '次：$code';
  }

  @override
  String get homeNextCode => '次のコード';

  @override
  String get homeFavorite => 'お気に入り';

  @override
  String get homeCodeHiddenAsk => '本人確認するまでコードは非表示です';

  @override
  String get homeCodeHidden => 'コードは非表示';

  @override
  String homeNextCodeSpoken(String code) {
    return '次のコード $code';
  }

  @override
  String homeKindTotp(int count, int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count桁',
    );
    return 'TOTP・$_temp0・$seconds秒';
  }

  @override
  String homeKindSteam(int seconds) {
    return 'Steam・5文字・$seconds秒';
  }

  @override
  String homeKindHotp(int count, String counter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count桁',
    );
    return 'HOTP・$_temp0・#$counter';
  }

  @override
  String get homeAccountHeading => 'アカウント';

  @override
  String get homeHintUnselect => '選択を解除';

  @override
  String get homeHintSelect => '選択';

  @override
  String get homeHintCopy => 'コードをコピー';

  @override
  String get homeReadCodeAloud => 'コードを読み上げ';

  @override
  String get homeMoreOptions => 'その他のオプション';

  @override
  String get mainPairRaycastTitle => 'Raycast とペアリング';

  @override
  String get mainPairRaycastBody => 'このコードを Raycast に入力してください：';

  @override
  String get mainPairRaycastWarning => '自分で Raycast のペアリングを始めたときだけ入力してください。';

  @override
  String get mainPairAlfredTitle => 'Alfred とペアリング';

  @override
  String get mainPairAlfredBody => 'Alfred に 2fa-pair とこのコードを入力してください：';

  @override
  String get mainPairAlfredWarning =>
      '自分で Alfred に 2fa-pair と入力したときだけ入力してください。';

  @override
  String get mainPairPowerToysTitle => 'PowerToys とペアリング';

  @override
  String get mainPairPowerToysBody => 'このコードを PowerToys のコマンド パレットに入力してください：';

  @override
  String get mainPairPowerToysWarning =>
      '自分で PowerToys のペアリングを始めたときだけ入力してください。';

  @override
  String get mainPairBrowserTitle => 'ブラウザとペアリング';

  @override
  String get mainPairBrowserBody => 'このコードを Tanooki Auth のブラウザ拡張機能に入力してください：';

  @override
  String get mainPairBrowserWarning => '自分で拡張機能の「ペアリング」をクリックしたときだけ入力してください。';

  @override
  String mainSendCodeTo(String name, String client) {
    return '$name のコードを $client に送信';
  }

  @override
  String mainWrongPasscodeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'パスコードが違います。あと $count 回間違えるとすべて消去されます。',
    );
    return '$_temp0';
  }

  @override
  String get mainWrongPasscode => 'パスコードが違います。';

  @override
  String get mainBiometricWindows => 'Windows Hello';

  @override
  String get mainBiometricMac => 'Touch ID';

  @override
  String get mainBiometricOther => 'Face ID または指紋';

  @override
  String get mainLockTitle => 'Tanooki Auth をロックしますか？';

  @override
  String get mainLockBody =>
      'アプリを開くときに顔、指紋、パスコードを求めます。ロック解除されたスマホを誰かが手にしても、コードを読まれません。あとで設定から変更できます。';

  @override
  String get mainTurnOnLock => 'ロックをオンにする';

  @override
  String get mainUnlockReason => 'Tanooki Auth のロックを解除';

  @override
  String get mainStartOverTitle => '新しい空の保管庫を作りますか？';

  @override
  String get mainStartOverBody =>
      '古いアカウントの残りは完全に置き換えられます。復元できるバックアップがない場合や、それらのサイトで2段階認証をすでにオフにした場合にだけ行ってください。';

  @override
  String get mainEraseStartOver => '消去して最初からやり直す';

  @override
  String get mainRestoreFromBackup => 'バックアップから復元';

  @override
  String get mainStartNewVault => '新しい空の保管庫を作る';

  @override
  String get mainLocked => 'Tanooki Auth はロックされています';

  @override
  String mainUseBiometric(String method) {
    return '$method を使う';
  }

  @override
  String get mainUseSecurityKey => 'セキュリティキーを使う';

  @override
  String homeHidesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'あと $count 秒で非表示',
    );
    return '$_temp0';
  }

  @override
  String homeCardsMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      'm1': '1月',
      'm2': '2月',
      'm3': '3月',
      'm4': '4月',
      'm5': '5月',
      'm6': '6月',
      'm7': '7月',
      'm8': '8月',
      'm9': '9月',
      'm10': '10月',
      'm11': '11月',
      'm12': '12月',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String homeCardsDay(String month, String day) {
    return '$month$day日';
  }

  @override
  String get homeCardsDenied =>
      '拒否しました。相手はあなたのアカウントを開けません。後でまたリクエストでき、そのときはもう一度確認されます。';

  @override
  String get homeCardsClockRight => '時計は正しくなりました。コードは使えるはずです。';

  @override
  String get homeCardsCheckAgain => 'もう一度確認';

  @override
  String get homeCardsYourContact => 'あなたの緊急連絡先';

  @override
  String homeCardsEmergencyWaiting(String who, String left, String day) {
    return '$who さんがあなたのアカウントへの緊急アクセスをリクエストしました。拒否しなければ、$left後（$day）にコピーを開けるようになります。';
  }

  @override
  String homeCardsEmergencyReleased(String who) {
    return '$who さんが緊急アクセスをリクエストし、7日間の待機が終わったため、今ならアカウントのコピーを開けます。止めるには拒否してください。';
  }

  @override
  String get homeCardsBackupNudge =>
      '前回のバックアップ以降、アカウントが変わっています。この端末をなくしたとき、バックアップファイルがあれば取り戻せます。';

  @override
  String get homeCardsBackUpNow => '今すぐバックアップ';

  @override
  String homeCardsSummaryNew(int count, String month) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$monthのまとめ：新しいアカウント $count 件。',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryNoBackup => 'まだバックアップはありません。';

  @override
  String homeCardsSummaryLastBackup(String day) {
    return '前回のバックアップ：$day。';
  }

  @override
  String get homeCardsSummaryAllCodes => 'すべてのアカウントに復旧コードがあります。';

  @override
  String homeCardsSummaryMissingCodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '復旧コードのないアカウント $count 件。',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryCheckupGood => 'セキュリティチェック：問題なし。';

  @override
  String homeCardsSummaryCheckupFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'セキュリティチェック：直すところが $count 件。',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsOpenCheckup => 'チェックを開く';

  @override
  String get quickPickSelf =>
      'Tanooki Auth が前面にあったため、何も入力されませんでした。入力したい欄をクリックしてから、もう一度メニューバーのアイコンを使ってください。';

  @override
  String quickPickTypeFailed(String reason) {
    return 'コードを入力できませんでした（$reason）。代わりにコピーしてください。';
  }

  @override
  String get quickPickTypeUnavailable =>
      'このパソコンではコードの自動入力を使えません。代わりにコピーしてください。';

  @override
  String quickPickUseCodeFor(String name) {
    return '$name のコードを使う';
  }

  @override
  String get quickPickAllowTitle => 'Tanooki Auth に入力を許可';

  @override
  String get quickPickAllowBody =>
      'ほかのアプリにコードを入力するには、Tanooki Auth がキーを押せるよう Mac で許可する必要があります。\n\n1. 下の「システム設定を開く」をクリックします。\n2. 「アクセシビリティ」という一覧が表示されます。Tanooki Auth を探してスイッチをオン（青）にします。\n3. Mac にパスワードや Touch ID を求められたら入力します。\n4. ここに戻って、もう一度［入力］をクリックします。\n\nTanooki Auth がキーを押すのは［入力］をクリックしたときだけで、入力するのはコードだけです。';

  @override
  String get quickPickOpenSystemSettings => 'システム設定を開く';

  @override
  String get quickPickTitle => 'クイックピック';

  @override
  String get quickPickSearch => 'アカウントを検索';

  @override
  String get quickPickLinuxNote =>
      'Linux ではほかのアプリへのコード入力は使えません。アカウントをクリックするとコードをコピーします。';

  @override
  String get quickPickNoMatches => '一致するアカウントはありません';

  @override
  String get quickPickAsksFirst => '••• •••（先に確認）';

  @override
  String get quickPickHiddenAsks => 'コードは非表示、先に確認します';

  @override
  String get quickPickType => '入力';

  @override
  String get codeViewRing => 'リング';

  @override
  String get codeViewBar => 'バー';

  @override
  String get codeViewNumber => '数字';

  @override
  String codeViewSpoken(String code) {
    return 'コード $code';
  }

  @override
  String codeViewSpokenLeft(int count, String code) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'コード $code、残り $count 秒',
    );
    return '$_temp0';
  }

  @override
  String get codeViewReadAloud => 'コードを読み上げ';

  @override
  String codeViewSecondsShort(int count) {
    return '$count秒';
  }

  @override
  String get codeViewColorBlue => '青';

  @override
  String get codeViewColorPurple => '紫';

  @override
  String get codeViewColorPink => 'ピンク';

  @override
  String get codeViewColorRed => '赤';

  @override
  String get codeViewColorOrange => 'オレンジ';

  @override
  String get codeViewColorGold => 'ゴールド';

  @override
  String get codeViewColorGreen => '緑';

  @override
  String get codeViewColorTeal => 'ティール';

  @override
  String get codeViewColorGray => 'グレー';

  @override
  String trashRestored(String name) {
    return '$name をリストに戻しました。';
  }

  @override
  String trashDeleteTitle(String name) {
    return '$name を完全に削除しますか？';
  }

  @override
  String get trashDeleteBody =>
      '元に戻せません。削除する前に、そのサイトの2段階認証をオフにするか、復旧コードがあることを確認してください。そうしないとログインできなくなるおそれがあります。';

  @override
  String get trashDeleteForGood => '完全に削除';

  @override
  String get trashTitle => 'ゴミ箱';

  @override
  String get trashEmpty => 'ゴミ箱は空です。\n削除したアカウントはここに30日間残ります。';

  @override
  String get trashNote => '削除したアカウントはここに30日間残り、その後完全に削除されます。';

  @override
  String get trashRemovedNextOpen => '次にアプリを開いたときに削除されます';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '残り $count 日',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => '元に戻す';

  @override
  String get recoveryAddTitle => '復旧コードを追加';

  @override
  String get recoveryPasteHint => 'サイトから受け取ったコードを1行に1つずつ貼り付けてください';

  @override
  String get recoveryNoneNew => '貼り付けた内容に新しいコードは見つかりませんでした。';

  @override
  String recoveryAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件のコードを追加しました。',
    );
    return '$_temp0';
  }

  @override
  String get recoveryCopiedUsed => 'コピーしました。注意：このコードは使用済みにしてあるので、おそらくもう使えません。';

  @override
  String get recoveryCopied =>
      'コピーしました。クリップボードは30秒後に消去されます。ログインできたら使用済みにしてください。';

  @override
  String get recoveryRemoveTitle => 'このコードを削除しますか？';

  @override
  String recoveryRemoveBody(String code) {
    return '$code\n\nサイトで使えなくなった場合だけ削除してください。';
  }

  @override
  String recoveryTitle(String name) {
    return '$name の復旧コード';
  }

  @override
  String get recoveryAddCodes => 'コードを追加';

  @override
  String get recoveryIntro =>
      '2段階認証をオンにすると、多くのサイトでバックアップコードの一覧ももらえます。このアプリをなくしても、1つにつき1回ログインできます。ここに貼り付けて、アカウントと一緒に安全に保管しましょう。';

  @override
  String recoveryUnusedOf(String unused, int total) {
    return '$total 件中 $unused 件が未使用です。コードをタップするとコピーでき、使ったらチェックを付けてください。';
  }

  @override
  String get recoveryUsed => '使用済み';

  @override
  String get detailsEditAccount => 'アカウントを編集';

  @override
  String get detailsCopyCode => 'コードをコピー';

  @override
  String get detailsReadAloud => '読み上げ';

  @override
  String get detailsFolderAndTags => 'フォルダーとタグ';

  @override
  String get detailsWebsites => 'ウェブサイト';

  @override
  String get detailsNotes => 'メモ';

  @override
  String get detailsNotesHidden => '本人確認するまで非表示です。';

  @override
  String get detailsNoNotes => 'メモはありません。［編集］で追加できます。';

  @override
  String get accountSortCustom => 'カスタム（ドラッグで並べ替え）';

  @override
  String get accountSortRecent => '最近使った順';

  @override
  String get accountSortName => '名前順';

  @override
  String get activityCopied => 'コピー';

  @override
  String get activityFilled => '入力（サイト）';

  @override
  String get activityTyped => 'タイプ入力';

  @override
  String get activityShownQr => 'QR コードを表示';

  @override
  String get activityExported => '書き出し';

  @override
  String totpBadCharacter(String char) {
    return '有効な Base32 のシークレットではありません（不正な文字「$char」）';
  }

  @override
  String get totpEmpty => 'シークレットが空です';

  @override
  String get vaultFileMissing =>
      'アカウントのファイルが見つかりません。バックアップがあれば復元してください。なければ、新しい空の保管庫を作れます。';

  @override
  String get vaultKeyMissing =>
      'アカウントのロックを解除する鍵が、この端末の安全な保管場所から見つかりません。バックアップを復元してアカウントを取り戻してください。';

  @override
  String get vaultDecryptFailed =>
      'アカウントのファイルのロックを解除できませんでした。壊れているか、アプリの外で変更された可能性があります。バックアップを復元してください。';

  @override
  String get vaultBadJson =>
      'アカウントのファイルのロックは解除できましたが、中身が壊れています。バックアップを復元してください。';

  @override
  String clockCheckBadAnswer(String status) {
    return '時刻サーバーから、アプリが理解できない応答が返ってきました（HTTP $status）。';
  }

  @override
  String clockCheckOff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '端末の時計が約 $count 分ずれているため、コードが使えません。設定で時刻の自動設定をオンにしてください。',
    );
    return '$_temp0';
  }

  @override
  String backupUiBullet(String item) {
    return '・$item';
  }

  @override
  String backupUiAccountWithLabel(String title, String label) {
    return '$title（$label）';
  }

  @override
  String exportUiLeftOutLine(String account, String reason) {
    return '・$account：$reason';
  }
}
