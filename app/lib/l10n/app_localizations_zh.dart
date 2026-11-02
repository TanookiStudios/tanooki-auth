// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get commonCancel => '取消';

  @override
  String get commonOk => '好';

  @override
  String get commonRemove => '移除';

  @override
  String get commonUnlock => '解锁';

  @override
  String get commonTurnOff => '关闭';

  @override
  String get commonNotNow => '以后再说';

  @override
  String get commonNext => '下一步';

  @override
  String get commonDone => '完成';

  @override
  String get commonDeny => '拒绝';

  @override
  String get commonAllow => '允许';

  @override
  String get commonTryAgain => '重试';

  @override
  String get commonStop => '停止';

  @override
  String get commonShare => '分享';

  @override
  String get commonOpen => '打开';

  @override
  String get commonCopy => '复制';

  @override
  String get commonContinueLabel => '继续';

  @override
  String get commonClear => '清除';

  @override
  String get commonBack => '返回';

  @override
  String get commonAdd => '添加';

  @override
  String get commonSave => '保存';

  @override
  String get commonDelete => '删除';

  @override
  String get commonClose => '关闭';

  @override
  String get commonEdit => '编辑';

  @override
  String get commonYes => '是';

  @override
  String get commonNo => '否';

  @override
  String get commonSeePremium => '查看 Premium';

  @override
  String get commonPremiumBadge => 'Premium';

  @override
  String get commonAppName => 'Tanooki Auth';

  @override
  String get googleMigrationUnreadable => '无法读取这个 Google Authenticator 迁移码。';

  @override
  String get googleMigrationDamaged => '这个 Google Authenticator 迁移码已损坏。';

  @override
  String get googleMigrationEmpty => '这个 Google Authenticator 迁移码里没有账号。';

  @override
  String get googleMigrationNoSecret => '这个迁移码里有一个账号没有密钥。';

  @override
  String get googleMigrationMd5 => '这个迁移码里有一个账号使用 MD5，Tanooki Auth 不支持。';

  @override
  String get googleCantTakeSteam => 'Steam 验证码';

  @override
  String googleCantTakeDigits(int digits) {
    return '$digits 位验证码';
  }

  @override
  String googleCantTakePeriod(int seconds) {
    return '每 $seconds 秒更换一次的验证码';
  }

  @override
  String get otpauthNotALink => '这不是 otpauth:// 链接。';

  @override
  String get otpauthNoSecret => '这个链接里没有密钥。';

  @override
  String otpauthUnsupportedType(String type) {
    return '不支持的验证码类型“$type”。';
  }

  @override
  String otpauthUnsupportedAlgorithm(String algorithm) {
    return '不支持的算法“$algorithm”。';
  }

  @override
  String get otpauthBadDigits => '位数必须是 6、7 或 8。';

  @override
  String get otpauthBadPeriod => '周期必须是正数。';

  @override
  String get otpauthBadCounter => '计数器必须大于或等于零。';

  @override
  String get phoneLinkNotAPairingCode => '这不是 Tanooki Auth 的浏览器配对码。';

  @override
  String phoneLinkNotSavedFor(String host) {
    return '这个账号没有保存为 $host 使用。';
  }

  @override
  String get phoneLinkPushNotSetUp =>
      'Tanooki Auth 服务器还没有设置好通知，所以请求只会在应用打开时出现。';

  @override
  String phoneLinkPushFailed(int status) {
    return '无法开启通知（HTTP $status）。';
  }

  @override
  String get qrImageNotAPicture => '这个文件不是本应用能读取的图片。';

  @override
  String get qrImageNoQr => '图片里没有找到二维码。';

  @override
  String relayBadAnswer(int status) {
    return '同步服务器返回了应用无法理解的回应（HTTP $status）。';
  }

  @override
  String get relayUnreachable => '无法连接同步服务器。请检查网络连接。';

  @override
  String get relayTimeout => '同步服务器没有及时回应。请检查网络连接。';

  @override
  String get relayInsecure => '无法与同步服务器建立安全连接。';

  @override
  String relaySaidNo(int status) {
    return '同步服务器拒绝了请求（HTTP $status）。';
  }

  @override
  String get shareNotAShare => '这不是 Tanooki Auth 分享的账号。';

  @override
  String get shareExpired => '这个分享已过期（分享只保留 24 小时）。请对方重新分享。';

  @override
  String get shareWrongCode => '验证码错误，或者分享已损坏。请检查这 6 位数字后重试。';

  @override
  String get storeServerUnreachable => '无法连接 Tanooki Auth 服务器。请检查网络连接后重试。';

  @override
  String get storeBadKey => '服务器发来的许可证密钥本应用无法接受。';

  @override
  String storeReportedProblem(String problem) {
    return '商店报告了一个问题：$problem';
  }

  @override
  String get storeGooglePlayUnavailable =>
      '这台设备上没有 Google Play，所以无法在这里购买 Premium。如果你在别处买过 Premium，请在下方输入许可证密钥。';

  @override
  String get storeAppStoreUnavailable => 'App Store 暂时无法使用。请检查网络连接后重试。';

  @override
  String storeNotListed(String store) {
    return '$store刚才没有列出 Premium。请稍后再试。';
  }

  @override
  String storeNotListedWithError(String store, String problem) {
    return '$store刚才没有列出 Premium（$problem）。请稍后再试。';
  }

  @override
  String storePricesFailed(String problem) {
    return '无法从商店加载价格：$problem';
  }

  @override
  String storePurchaseCouldNotStart(String problem) {
    return '无法开始购买：$problem';
  }

  @override
  String storeNothingToRestore(String store) {
    return '这个$store账号下没有找到 Premium 购买记录。';
  }

  @override
  String storeRestoreFailed(String problem) {
    return '无法恢复购买：$problem';
  }

  @override
  String get storePending => '正在等待付款获批。获批后 Premium 会立即解锁。';

  @override
  String get storeCanceled => '已取消购买。没有扣款。';

  @override
  String storeFailed(String problem) {
    return '购买没有成功：$problem。没有扣款。';
  }

  @override
  String get storeFailedNoReason => '购买没有成功：商店没有说明原因。没有扣款。';

  @override
  String get storeUnlocked => 'Premium 已解锁。非常感谢！';

  @override
  String get storeUnlockedWithKey => 'Premium 已解锁。下方是用于你电脑的许可证密钥。';

  @override
  String storeUnlockedKeyFailed(String problem) {
    return 'Premium 已在这台设备上解锁。用于电脑的密钥暂时没能生成：$problem 稍后点按“恢复购买”再试一次。';
  }

  @override
  String storeServerSaidNo(int status) {
    return '服务器拒绝了请求（HTTP $status）。';
  }

  @override
  String get syncGroupExists =>
      '使用这个密码短语的同步组已经存在。请在已经在同步的设备上点按“添加设备”，然后扫描它显示的码。';

  @override
  String get syncNotASyncCode =>
      '这不是 Tanooki Auth 同步码。请在已经在同步的设备上打开“设置”>“同步”>“添加设备”。';

  @override
  String get syncWrongPassphrase => '这个密码短语和你其他设备用的不一致。请检查后重试。';

  @override
  String get syncICloudOtherPassphrase =>
      '你的其他 Apple 设备用的是另一个密码短语。请输入那个密码短语，或者用这个重新开始。';

  @override
  String get syncErrorRemoved => '这台设备已在另一台设备上被移出同步。请先关闭同步，再重新开启以重新加入。';

  @override
  String get syncErrorTurnedOff => '同步已在另一台设备上关闭。请在这里也关闭，然后重新开启以从头开始。';

  @override
  String get syncErrorTooOften => '同步太频繁了。几分钟后会自动重试。';

  @override
  String get syncErrorLimit => '你已达到同步上限（2,000 个账号，包括已删除的）。';

  @override
  String syncErrorICloud(String problem) {
    return 'iCloud 云盘出了问题：$problem。';
  }

  @override
  String syncErrorUnexpected(String problem) {
    return '同步因意外问题而停止：$problem';
  }

  @override
  String get syncICloudAppleOnly => 'iCloud 只能在 iPhone、iPad 和 Mac 上使用。';

  @override
  String get syncICloudSignedOut =>
      '这台设备上的 iCloud 云盘已关闭。要使用它，请在“设置”中登录 iCloud 并开启 iCloud 云盘。';

  @override
  String get syncICloudNotInBuild =>
      '这个版本的 Tanooki Auth 还没有开启 iCloud 同步。目前请使用 Tanooki 中继，它在所有设备上都能用。';

  @override
  String get teamKeyUnopenable => '无法打开发送到这台设备的团队密钥。请让团队管理员移除这台设备后重新邀请。';

  @override
  String get teamNotAnInvite => '这不是 Tanooki Auth 团队邀请。请向团队管理员索取新的邀请链接或二维码。';

  @override
  String get teamNotInTeam => '这台设备不在任何团队中。';

  @override
  String get teamDeletedByAdmin => '这个团队已被管理员删除。';

  @override
  String get teamDeviceRemoved => '这台设备已被移出团队。';

  @override
  String get teamAlreadyInTeam => '这台设备已经在一个团队中。';

  @override
  String get teamNotALicense => '这不是团队许可证。团队许可证以 TT1. 开头，来自你订阅后 Stripe 显示的页面。';

  @override
  String get teamAlreadyInTeamLeaveFirst => '这台设备已经在一个团队中。请先退出。';

  @override
  String get teamGone => '这个团队已不存在。请向团队管理员索取新的邀请。';

  @override
  String get teamInviteUsed => '这个邀请已被使用或已过期（邀请有效期 7 天，只能用一次）。请向团队管理员索取新的邀请。';

  @override
  String get teamFull => '这个团队已满（10 人）。管理员需要先移除一个人。';

  @override
  String get aboutTitle => '关于 Maddie';

  @override
  String get aboutP1 => '我是 Maddie，一名自闭症开发者，对把小事做好这件事很在意，可能有点过于在意了。';

  @override
  String get aboutP2 =>
      '我非常看重隐私。保护你账号的密钥几乎是最私密的数据，所以 Tanooki Auth 把它们加密保存在你自己的设备上。不用注册账号，没有广告，没有跟踪，也绝不会把任何东西发给我。';

  @override
  String get aboutP3 =>
      'Tanooki Auth 是免费的，我希望它一直免费。正是你的支持，让我能继续做像这样的免费隐私应用。如果你喜欢 Tanooki Auth，其他应用可能也适合你——都在 madilynthomas.com。';

  @override
  String get aboutP4 => '所以，我想对你说：谢谢你。你不只是在用一个应用——你让这一切成为可能。';

  @override
  String get aboutSupportAddress => '支持我的工作：tanookistudios.com/support';

  @override
  String get aboutSupport => '支持我的工作';

  @override
  String get aboutCredits => '致谢';

  @override
  String get aboutCreditsBody =>
      '浏览器扩展用 jsQR（Apache 2.0）读取二维码，应用用 ZXing 读取。本应用与 Google、Twilio 或 Authy 无关；Google Authenticator 是 Google LLC 的商标。';

  @override
  String get addFromBrowserOne => '从浏览器添加？';

  @override
  String addFromBrowserMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '从浏览器添加 $count 个账号？',
    );
    return '$_temp0';
  }

  @override
  String get addFromGoogleTransfer => '来自 Google Authenticator 迁移码：';

  @override
  String addCount(int count) {
    return '添加 $count 个';
  }

  @override
  String get addNoColor => '无颜色';

  @override
  String addColorName(String name) {
    return '$name色';
  }

  @override
  String get addServiceLabel => '服务（例如 GitHub）';

  @override
  String get addAccountLabel => '账号（例如你的邮箱）';

  @override
  String get addWebsiteLabel => '网站（可选）';

  @override
  String get addWebsiteHelp => '例如 github.com。浏览器扩展只会在这里填写验证码。';

  @override
  String get addTagsLabel => '标签（可选）';

  @override
  String get addTagsHelp => '例如 工作, 游戏。用逗号分隔。';

  @override
  String get addFolderLabel => '文件夹（可选）';

  @override
  String get addFolderHelp => '例如 工作。留空表示不放进文件夹。';

  @override
  String get addPickFolder => '选择文件夹';

  @override
  String get addNoFolder => '无文件夹';

  @override
  String get addNotesLabel => '备注（可选）';

  @override
  String get addColorLabel => '颜色（可选）';

  @override
  String get addEmojiLabel => '表情符号（可选）';

  @override
  String get addEmojiHelp => '代替图标显示，在这里、小组件和手表上都是。';

  @override
  String addUseEmoji(String emoji) {
    return '使用 $emoji';
  }

  @override
  String addRequireAuth(String proof) {
    return '显示这个验证码前先要求$proof';
  }

  @override
  String get addRequireAuthHelp => '验证码在列表中保持隐藏，小组件、手表和快速选取也不会显示它。';

  @override
  String get addTravelHide => '旅行模式下隐藏';

  @override
  String get addTravelHidePremium => '旅行模式下隐藏（Premium）';

  @override
  String get addTravelHideHelp => '开启旅行模式（在“设置”中）后，这个账号会从应用中消失，直到你关闭旅行模式。';

  @override
  String get addTravelNeedsPremium => '旅行模式属于 Premium。请在“设置”>“获取 Premium”中购买。';

  @override
  String get addAdvanced => '高级';

  @override
  String get addAdvancedExisting => '只有网站要求时才修改这些。设置错误会生成错误的验证码，网站会拒绝。';

  @override
  String get addAdvancedNew => '大多数网站使用常规设置。只有网站要求时才修改这些。';

  @override
  String get addType => '类型';

  @override
  String get addTypeTotp => '基于时间（常规）';

  @override
  String get addTypeHotp => '基于计数器（需要时生成新验证码）';

  @override
  String get addDigits => '位数';

  @override
  String get addAlgorithm => '算法';

  @override
  String get addSha1Normal => 'SHA-1（常规）';

  @override
  String get addPeriod => '验证码更换间隔';

  @override
  String addSeconds(int seconds) {
    return '$seconds 秒';
  }

  @override
  String get addCounter => '计数器';

  @override
  String get addCounterHelp => '到目前为止已使用的验证码数量';

  @override
  String get addNotASharedFile => '这个文件不是 Tanooki Auth 分享的账号。请让对方重新分享。';

  @override
  String addAlreadyInList(String name) {
    return '$name 已经在你的列表里了。';
  }

  @override
  String get addThisAccount => '添加这个账号？';

  @override
  String get addNoCameraWindows =>
      '在 Windows 上，Tanooki Auth 无法使用摄像头。请打开二维码图片，或者粘贴设置链接。';

  @override
  String get addFromGoogle => '从 Google Authenticator 迁移';

  @override
  String get addFromGoogleSteps =>
      '在装有 Google Authenticator 的设备上：\n\n1. 打开 Google Authenticator。\n2. 点按菜单（☰ 或 ⋮），然后点“转移账号”，再点“导出账号”。\n3. 选择账号并点按“下一步”。它会显示一个二维码。\n\n然后在这里扫描那个二维码。如果显示了好几个二维码，请逐个扫描。';

  @override
  String get addScan => '扫描';

  @override
  String get addOpenPicture => '打开图片';

  @override
  String get addLookingOnScreen => '正在屏幕上查找二维码…';

  @override
  String get addScreenNoQr => '屏幕上没有找到二维码。请确认整个二维码都显示出来，没有被其他窗口挡住，然后重试。';

  @override
  String get addScreenUnsupported =>
      '扫描屏幕需要 macOS 14（Sonoma）或更新版本。请截图后改用“打开二维码图片”。';

  @override
  String get addScreenFailed => '无法截取屏幕画面。请截图后改用“打开二维码图片”。';

  @override
  String get addScreenWrongQr => '在屏幕上找到了一个二维码，但它不是两步验证设置码。';

  @override
  String get addScreenPermissionTitle => '允许 Tanooki Auth 查看你的屏幕';

  @override
  String get addScreenPermissionSteps =>
      '要读取屏幕上的二维码，你的 Mac 需要允许 Tanooki Auth 截取屏幕画面。Tanooki Auth 只在你按下“扫描我的屏幕”时才会看，画面也绝不会离开这台 Mac。\n\n1. 打开“系统设置”（程序坞里的齿轮图标，或苹果菜单 >“系统设置”）。\n2. 点按左栏的“隐私与安全性”。\n3. 点按“录屏与系统录音”。\n4. 打开 Tanooki Auth 旁边的开关。如果列表里没有它，点按 +，从“应用程序”中选择 Tanooki Auth，然后打开开关。\n5. Mac 会要求退出 Tanooki Auth。点按“退出并重新打开”，然后再按一次“扫描我的屏幕”。';

  @override
  String get addPasteLinksTitle => '粘贴设置链接';

  @override
  String get addPasteLinksHint => 'otpauth://totp/...\n每行一个链接。可以一次粘贴很多个。';

  @override
  String addManyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '添加 $count 个账号？',
    );
    return '$_temp0';
  }

  @override
  String addManyBadLines(int count) {
    return '有 $count 行无法使用；稍后会告诉你是哪几行。';
  }

  @override
  String get addEnterKey => '输入设置密钥';

  @override
  String get addSetupKey => '设置密钥';

  @override
  String get addSetupKeyHelp => '网站显示的字母和数字';

  @override
  String get addBadKey => '这个设置密钥无效。它只能包含字母 A–Z 和数字 2–7。';

  @override
  String get addTitle => '添加账号';

  @override
  String get addScanQr => '扫描二维码';

  @override
  String get addScanQrHelp => '把摄像头对准网站显示的二维码';

  @override
  String addNoCameraOn(String platform) {
    return '$platform 上不支持摄像头';
  }

  @override
  String get addScanScreen => '扫描我的屏幕';

  @override
  String get addScanScreenHelp => '读取屏幕上任意位置显示的二维码';

  @override
  String get addScanScreenLinux => 'Linux 上暂不可用。请打开二维码的截图。';

  @override
  String get addFromPhotos => '从照片中扫描二维码';

  @override
  String get addFromPicture => '打开二维码图片';

  @override
  String get addFromPhotosHelp => '选择设置页面的截图';

  @override
  String get addFromPictureHelp => '设置页面的截图就可以';

  @override
  String get addPasteLink => '粘贴设置链接';

  @override
  String get addPasteLinkHelp => '以 otpauth:// 开头的链接，一个或多个';

  @override
  String get addOpenShared => '打开分享的账号';

  @override
  String addOpenSharedHelp(String extension) {
    return '别人发给你的 .$extension 文件';
  }

  @override
  String get addFromGoogleHelp => '一次性迁移所有账号';

  @override
  String get addFromOtherApp => '从其他应用迁移';

  @override
  String get addFromOtherAppHelp =>
      'Aegis、2FAS、Authy、Bitwarden、1Password、Apple 密码、Microsoft';

  @override
  String get addEnterKeyHelp => '输入“无法扫描二维码？”下方显示的密钥';

  @override
  String get addWrongQr => '这个二维码不是两步验证设置码。';

  @override
  String get addCameraDenied =>
      'Tanooki Auth 没有使用摄像头的权限。请在设备的“设置”中为 Tanooki Auth 开启摄像头权限，或者返回改用图片或设置密钥。';

  @override
  String addCameraFailed(String problem) {
    return '摄像头无法启动（$problem）。请返回改用图片或设置密钥。';
  }

  @override
  String get helpNew030a => '40 个热门网站开启 2FA 的分步指南。添加或编辑有指南的账号时，会显示指南链接。';

  @override
  String get helpNew030b => '第一次打开应用时的简短欢迎导览。可以在“设置”>“帮助”中再看一次。';

  @override
  String get helpNew030c => '在“设置”>“帮助”中发送反馈。反馈绝不会包含你的账号或验证码。';

  @override
  String get helpNew030d => '就是这个“新功能”页面。';

  @override
  String get helpNew030e =>
      '从 Apple 密码导入，以及把账号迁移到 Aegis、2FAS 或 Google Authenticator。';

  @override
  String get helpNew030f =>
      'Steam Guard 验证码、带“下一个验证码”按钮的计数器验证码，以及可实时预览的高级验证码设置。';

  @override
  String get helpNew030g => '文件夹、一次选择多个账号、按 A 到 Z 或最近使用排序，以及“整理账号名称”。';

  @override
  String get helpNew030h => '显示账号的二维码（需先通过 Face ID 或设备密码），把它转移到另一台设备。';

  @override
  String get helpNew030i =>
      '在较新的 iPhone、Mac 和 Windows 电脑上，用 YubiKey 等安全密钥解锁（Premium）。';

  @override
  String get helpNew030j =>
      '“需先验证”账号：显示验证码前需要 Face ID 或设备密码；还有旅行模式，可隐藏选定的账号（Premium）。';

  @override
  String get helpNew030k => '活动记录（Premium）、“验证码不对？”时钟检查、测试备份、睡眠时锁定，以及备份提醒。';

  @override
  String get helpNew030l => '紧急访问：让你信任的人申请获取你的账号，并留出几天时间让你拒绝。';

  @override
  String get helpNew030m =>
      '聚焦搜索、已复制验证码的实时活动和表盘复杂功能（Premium）、打开时复制，以及 Mac 上的“粘贴一次后清除”。';

  @override
  String get helpNew030n => '倒计时样式、为每个账号设置颜色或表情符号、朗读、易读字体，以及更好的屏幕阅读器支持。';

  @override
  String get helpNew030o => '适合大窗口的宽屏布局，以及应季的 Premium 图标。';

  @override
  String get helpNew030p => '在 iPhone 和 Android 上直接在应用内购买 Premium、送礼，以及邀请朋友。';

  @override
  String get helpNew030q => '团队保险库，可与最多 10 人共享验证码。团队方案本身即将推出。';

  @override
  String get helpNew030r => '家庭版即将推出。';

  @override
  String get helpNew030s => '桌面应用现在也能在 Linux 上运行了。Linux 下载即将推出。';

  @override
  String get helpNew020a => '设备间同步、浏览器扩展的手机连接，以及安全分享单个账号。';

  @override
  String get helpNew020b => '应用密码、自动锁定、紧急抹除、伪装密码、禁止截屏、安全检查和泄露提醒。';

  @override
  String get helpNew020c =>
      '小组件、Apple Watch 和 Wear OS 应用、Mac 菜单栏和 Windows 系统托盘，以及自动加密备份（Premium）。';

  @override
  String get helpNew020d =>
      '支持从 Aegis、2FAS、Authy、Bitwarden 和 1Password 导入，还有收藏、标签、备注、恢复码和回收站。';

  @override
  String get helpNew010a => '第一个版本：扫描或粘贴账号、查看验证码、加密备份，以及浏览器扩展。';

  @override
  String helpNoBrowser(String url) {
    return '无法打开你的网页浏览器。网页地址是 $url';
  }

  @override
  String helpGuideFor(String name) {
    return '如何为 $name 开启 2FA';
  }

  @override
  String get helpTourWelcome => '欢迎使用 Tanooki Auth';

  @override
  String get helpTourWelcomeBody =>
      '很多网站除了密码，还会要求输入 6 位验证码。这就是两步验证，也叫 2FA。Tanooki Auth 直接在你的设备上为你生成这些验证码，这样即使别人知道你的密码，也登录不了。';

  @override
  String get helpTourAdd => '添加第一个账号';

  @override
  String get helpTourAddBody =>
      '在网站的安全设置里开启 2FA。网站会显示一个二维码：在这里扫描，或者复制它的设置链接粘贴进来。已经在用别的验证器应用？可以一次性把账号迁移过来。';

  @override
  String get helpTourScanOrPaste => '扫描二维码或粘贴链接';

  @override
  String get helpTourImport => '从其他应用导入';

  @override
  String get helpTourPopular => '优先保护这些热门网站';

  @override
  String get helpTourPopularBody =>
      '最重要的是你的邮箱、社交媒体，以及所有和钱有关的地方。我们的分步指南会告诉你每个网站的 2FA 设置在哪里。';

  @override
  String get helpAllGuides => '所有 2FA 指南';

  @override
  String helpTourStep(int step, int total) {
    return '第 $step 步，共 $total 步';
  }

  @override
  String get helpTourSkip => '跳过导览';

  @override
  String get helpWhatsNew => '新功能';

  @override
  String helpVersion(String version) {
    return '版本 $version';
  }

  @override
  String helpVersionThis(String version) {
    return '版本 $version（当前版本）';
  }

  @override
  String get helpFeedbackEmpty => '请先输入内容。';

  @override
  String get helpFeedbackSent => '已发送。谢谢你！每条消息 Maddie 都会看。';

  @override
  String get helpFeedbackTooLong => '内容太长，发不出去。请写短一点（最多大约 4,000 个字）。';

  @override
  String get helpFeedbackTooMany => '你在过去一小时里发送了很多反馈。请一小时后再试。';

  @override
  String get helpFeedbackOffline => '无法连接互联网。请检查网络连接后重试。你的消息还在这里。';

  @override
  String get helpFeedbackServerError => '反馈服务器出了问题，没有收到你的消息。请稍后再试。你的消息还在这里。';

  @override
  String get helpFeedbackTitle => '发送反馈';

  @override
  String get helpFeedbackIntro => '发现了 bug，或者希望应用能做点什么？在这里告诉 Maddie。';

  @override
  String get helpFeedbackMessage => '你的消息';

  @override
  String get helpFeedbackEmail => '你的邮箱（可选）';

  @override
  String get helpFeedbackEmailHelp => '仅在你想收到回复时填写。';

  @override
  String get helpFeedbackDevice => '附带应用版本和设备类型';

  @override
  String get helpFeedbackDeviceHelp => '例如“0.3.0”和“iOS”。这有助于查找 bug。';

  @override
  String get helpFeedbackNeverSent =>
      '绝不会发送：你的账号及其名称、验证码、设置密钥、标签、备注，以及应用里的任何其他内容。';

  @override
  String get helpFeedbackSend => '发送';

  @override
  String get phoneUiPushAndroid =>
      'Android 上的通知还没有设置好，所以请求会在 Tanooki Auth 打开时出现。';

  @override
  String get phoneUiPushThisDevice => '这台设备会在 Tanooki Auth 打开时收到请求。';

  @override
  String get phoneUiPushNoToken => 'iPhone 没有给应用通知令牌。';

  @override
  String get phoneUiPushDenied =>
      'Tanooki Auth 的通知已关闭。要在应用关闭时也收到请求，请在 iPhone 的“设置”应用中的“通知”里开启。';

  @override
  String phoneUiPushFailed(String problem) {
    return '无法开启通知：$problem。Tanooki Auth 打开时仍会显示请求。';
  }

  @override
  String get phoneUiPushNotInBuild => '这个版本不支持通知。Tanooki Auth 打开时会显示请求。';

  @override
  String get phoneUiPushChecking => '正在检查通知能否使用…';

  @override
  String get phoneUiRequest => '登录验证码请求';

  @override
  String get phoneUiNoAccount =>
      '这个网站没有保存账号，所以没有可发送的内容。如果你以为有，这可能是一个冒充真网站的假网站。';

  @override
  String get phoneUiWantsCode => '你配对的浏览器想要这个网站的验证码。只有在你正在登录时才批准。';

  @override
  String get phoneUiApprove => '批准';

  @override
  String phoneUiApproveAccount(String name) {
    return '批准：$name';
  }

  @override
  String get phoneUiScanTitle => '扫描浏览器显示的码';

  @override
  String get phoneUiScanWrong =>
      '这不是浏览器配对码。请在浏览器中点按 Tanooki Auth 扩展，然后点“改用我的手机”。';

  @override
  String get phoneUiPasteTitle => '粘贴配对链接';

  @override
  String get phoneUiPair => '配对';

  @override
  String get phoneUiPaired => '已配对。当那个浏览器请求验证码时，会显示在这里。';

  @override
  String get phoneUiExpired => '这个码已过期。请在浏览器中生成一个新的，再扫描一次。';

  @override
  String get phoneUiPremium => '用手机配合浏览器属于 Premium 功能';

  @override
  String get phoneUiIntro =>
      '在任何电脑的浏览器中填写验证码，即使那台电脑没有安装 Tanooki Auth 应用。浏览器扩展发出请求，你在这里点按“批准”即可。验证码全程端到端加密，并且只会发给每个账号所保存的网站。';

  @override
  String get phoneUiPairBrowser => '配对浏览器';

  @override
  String get phoneUiPairHelp => '在浏览器中点按 Tanooki Auth 扩展，然后点“改用我的手机”来显示配对码。';

  @override
  String get phoneUiPairedBrowsers => '已配对的浏览器';

  @override
  String get phoneUiNoneYet => '暂无';

  @override
  String get phoneUiBrowser => '浏览器';

  @override
  String phoneUiPairedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '配对于 $dateString';
  }

  @override
  String get phoneUiUnpair => '取消配对';

  @override
  String get phoneUiPushOn => '通知已开启';

  @override
  String get phoneUiPushOff => '应用打开时显示请求';

  @override
  String get phoneUiPushOnHelp => '每个请求都会通知你，即使 Tanooki Auth 已关闭。';

  @override
  String phoneUiSendCodeFor(String name) {
    return '发送 $name 的验证码';
  }

  @override
  String get phoneUiActivityWhere => '浏览器，通过这部手机';

  @override
  String get premiumFiveOnce => '一次性 \$5';

  @override
  String get premiumPayOnce => '一次付费';

  @override
  String get premiumCheckoutSoon => '付款功能还没有开放，很快就来。谢谢你愿意支持 Tanooki Auth！';

  @override
  String get premiumEnterKeyTitle => '输入许可证密钥';

  @override
  String get premiumEnterKeyHint => 'TA1.…（见购买确认邮件）';

  @override
  String get premiumBadKey => '这个许可证密钥无效。请从购买确认邮件中复制完整的密钥后重试。';

  @override
  String premiumInvitesNowFamily(int count) {
    return '已有 $count 位朋友通过你的链接购买了 Premium，所以你的密钥现在升级为家庭版密钥，最多可供 5 人使用。它已安装在这台设备上。请复制下方的新密钥，也在你的其他设备上输入。';
  }

  @override
  String premiumInvitesAlreadyFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已有 $count 位朋友通过你的链接购买了 Premium。你的密钥已经是家庭版密钥。',
    );
    return '$_temp0';
  }

  @override
  String premiumInvitesProgress(int count, int needed, int left) {
    return '已有 $count/$needed 位朋友通过你的链接购买了 Premium。再有 $left 位，你的密钥就会升级为家庭版密钥。';
  }

  @override
  String get premiumInviteLinkCopied => '邀请链接已复制。';

  @override
  String get premiumKeyCopied => '许可证密钥已复制。';

  @override
  String premiumJustMe(String price) {
    return '仅自己 — $price';
  }

  @override
  String premiumFamilyPrice(String price) {
    return '家庭版（最多 5 人）— $price';
  }

  @override
  String get premiumFamilyApple =>
      '家庭版：通过“家人共享”与你的 Apple 家庭共享，另附一个许可证密钥，最多 5 人可在任何设备上使用。';

  @override
  String get premiumFamilyKey => '家庭版：一个许可证密钥，可与最多 4 位其他人共享。';

  @override
  String get premiumYourKey => '你的许可证密钥';

  @override
  String get premiumYourKeyHelp =>
      '在你的其他设备上输入：“设置”→“获取 Premium”→“已经买过？输入许可证密钥”。';

  @override
  String get premiumCopyKey => '复制密钥';

  @override
  String get premiumInviteFriends => '邀请朋友';

  @override
  String get premiumInviteHelp => '朋友可享 8 折优惠。有 3 位朋友购买后，你的密钥会升级为家庭版密钥。';

  @override
  String get premiumGetInvite => '获取我的邀请链接';

  @override
  String get premiumCheckInvites => '查看我的邀请';

  @override
  String get premiumYouHave => '你已拥有 Premium';

  @override
  String get premiumTitle => 'Tanooki Auth Premium';

  @override
  String get premiumOwnedFamily =>
      '家庭版：可与最多 4 位其他人共享你的许可证密钥（共 5 人）。谢谢你支持 Tanooki Auth。';

  @override
  String get premiumOwnedThanks => '谢谢你支持 Tanooki Auth。';

  @override
  String get premiumPitchStripe => '一次性 \$5，或 \$10 全家可用。永久拥有。';

  @override
  String get premiumPitchStore => '自己用付一次，全家用也只付一次。永久拥有。';

  @override
  String get premiumPerkThemes => '所有 Premium 主题';

  @override
  String premiumPerkThemesBody(int count) {
    return '淡粉、淡蓝和另外 $count 款主题，还有会自动切换的应季主题、最多 3 个自定义主题，以及以后新增的所有主题。';
  }

  @override
  String get premiumPerkIcons => '应用图标';

  @override
  String premiumPerkIconsBody(int count) {
    return '在 iPhone 和 Android 上选择不同的主屏幕图标，有淡粉、淡蓝和另外 $count 种颜色，还有秋季、冬季和春季的应季图标。在 Mac 上，应用打开时会更换程序坞图标。';
  }

  @override
  String get premiumPerkSync => '在你的设备间同步';

  @override
  String get premiumPerkSyncBody =>
      '在一台设备上添加账号，所有设备上都能看到，全程端到端加密。Apple 设备之间用 iCloud，混合设备用 Tanooki 中继。';

  @override
  String get premiumPerkApprove => '在手机上批准验证码';

  @override
  String get premiumPerkApproveBody =>
      '在任何电脑上使用浏览器扩展：它会询问你的手机，你点按“批准”，验证码就自动填好。';

  @override
  String get premiumPerkBreach => '泄露提醒';

  @override
  String get premiumPerkBreachBody =>
      '当你有账号的网站出现在已知数据泄露事件中时提醒你。检查在你的设备上完成，不会发送任何关于你的信息。';

  @override
  String get premiumPerkShare => '安全分享账号';

  @override
  String get premiumPerkShareBody =>
      '用一个二维码和一个 6 位数字码，把一个账号交给你信任的人。加密锁定，24 小时后过期，不经过服务器。';

  @override
  String get premiumPerkFamily => '家庭版';

  @override
  String get premiumPerkFamilyStripe =>
      '只需 \$10 而不是 \$5，一个密钥就能为最多 5 人解锁 Premium。把它发给家人，他们像你一样输入即可。';

  @override
  String get premiumPerkFamilyStore =>
      '购买一次家庭版，就能为最多 5 人解锁 Premium。把你的许可证密钥发给他们，他们像你一样输入即可。';

  @override
  String get premiumPerkFuture => '以后所有的 Premium 功能';

  @override
  String get premiumPerkFutureBody => '付一次费，Premium 以后增加的功能全都有。永远不用订阅。';

  @override
  String get premiumPerkFree => '让隐私应用保持免费';

  @override
  String get premiumPerkFreeStripe => '正是你的 \$5，让我能继续做不跟踪你的免费应用。';

  @override
  String get premiumPerkFreeStore => '正是你购买 Premium，让我能继续做不跟踪你的免费应用。';

  @override
  String get premiumFreeForever =>
      '无论有没有 Premium，这些永远免费：不限数量的账号、扫描、备份、浏览器扩展和应用锁。';

  @override
  String get premiumFamilySoon => '家庭版即将推出';

  @override
  String get premiumFamilyKeyEach =>
      '家庭版：一个许可证密钥，可与最多 4 位其他人共享。每个人在自己的 Tanooki Auth 里输入即可。';

  @override
  String get premiumRestore => '恢复购买';

  @override
  String get premiumAlreadyBought => '已经买过？输入许可证密钥';

  @override
  String get premiumDesktopKeySoon =>
      'Android 购买的桌面版密钥即将推出。Premium 现在已在这部手机上解锁；用于你电脑的许可证密钥会在以后的更新中显示在这里。';

  @override
  String premiumGift(String price) {
    return '把 Premium 当作礼物送人 — $price';
  }

  @override
  String premiumGiftFamily(String price) {
    return '把家庭版当作礼物送人 — $price';
  }

  @override
  String get premiumGiftHelp => '付款后你会收到一张可打印的礼品卡，上面有给对方的密钥。';

  @override
  String get settingsIconFailed => '无法更换应用图标。请重试，或重新启动应用。';

  @override
  String settingsIconFailedWhy(String problem) {
    return '无法更换应用图标（$problem）。请重试，或重新启动应用。';
  }

  @override
  String settingsIconSemantic(String name) {
    return '$name应用图标';
  }

  @override
  String settingsIconSemanticPremium(String name) {
    return '$name应用图标，Premium';
  }

  @override
  String get settingsAppIcon => '应用图标';

  @override
  String get settingsAppIconPremium => '应用图标（Premium）';

  @override
  String get settingsAppIconIos => '主屏幕上的图标。';

  @override
  String get settingsAppIconAndroid => '主屏幕上的图标。手机更换图标时，它可能会短暂消失。';

  @override
  String get settingsAppIconMac =>
      'Tanooki Auth 打开时更换程序坞图标。应用退出后 Mac 无法保留其他图标，所以访达和启动台里仍是蓝色图标。';

  @override
  String get settingsAppIconOther => '可以在 iPhone 和 Android 上更换应用图标。';

  @override
  String get settingsLockNameMac => 'Touch ID 或你的 Mac 密码';

  @override
  String get settingsLockNamePhone => 'Face ID、指纹或设备密码';

  @override
  String settingsNoLockSetUp(String lock) {
    return '这台设备没有设置$lock，所以无法锁定应用。请先在系统设置中设置。';
  }

  @override
  String get settingsLockReasonOn => '开启应用锁';

  @override
  String get settingsLockReasonOff => '关闭应用锁';

  @override
  String get settingsSetPasscode => '设置应用密码';

  @override
  String get settingsSetPasscodeIntro =>
      '输入它来打开 Tanooki Auth。Face ID 或指纹不管用时，它也能用。如果你忘了，唯一的办法就是用备份恢复。';

  @override
  String get settingsPasscodeOn => '应用密码已开启。';

  @override
  String get settingsPasscode => '应用密码';

  @override
  String get settingsChangePasscode => '更改密码';

  @override
  String get settingsPasscodeOff => '关闭密码';

  @override
  String get settingsNewPasscode => '新的应用密码';

  @override
  String get settingsPasscodeChanged => '密码已更改。';

  @override
  String get settingsPasscodeIsOff => '应用密码已关闭。';

  @override
  String get settingsRemoveDecoyTitle => '移除伪装密码？';

  @override
  String get settingsRemoveDecoyBody => '伪装账号会被抹除。你的真实账号不受影响。';

  @override
  String get settingsSetDecoy => '设置伪装密码';

  @override
  String get settingsSetDecoyIntro =>
      '如果有人逼你打开 Tanooki Auth，就输入这个密码。它会打开一组单独的空账号，屏幕上看不出这不是真的。在里面加几个无关紧要的账号，让它看起来像在用。\n\n你的真实密码仍然打开你的真实账号。';

  @override
  String get settingsDecoySet => '伪装密码已设置。';

  @override
  String settingsWipeTitle(int count) {
    return '输错 $count 次密码后抹除所有内容？';
  }

  @override
  String settingsWipeBody(int count) {
    return '如果有人连续 $count 次输错应用密码，Tanooki Auth 会抹除这台设备上的所有账号。无法撤销，一旦开始也无法停止。';
  }

  @override
  String get settingsWipeSureTitle => '你确定吗？';

  @override
  String get settingsWipeSureBody =>
      '小孩玩你的手机，或者你状态不好的时候，都可能触发它。抹除之后，唯一的恢复办法就是你的备份文件。没有备份，你可能会被所有使用这些验证码的网站拒之门外。';

  @override
  String get settingsWipeTurnOn => '开启紧急抹除';

  @override
  String get settingsTravelOffReason => '关闭旅行模式';

  @override
  String get settingsTravelOnNone =>
      '旅行模式已开启，但还没有账号标记为“旅行模式下隐藏”。请先通过 ⋯ >“编辑”标记。';

  @override
  String settingsTravelOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '旅行模式已开启。已隐藏 $count 个账号。',
    );
    return '$_temp0';
  }

  @override
  String get settingsTravelOff => '旅行模式已关闭。所有账号都回来了。';

  @override
  String get settingsCheckingClock => '正在检查你的时钟…';

  @override
  String get settingsClockRight =>
      '你的时钟是准的，所以不是这个原因。请检查账号的设置（⋯ >“编辑”>“高级”）是否和网站说的一致。';

  @override
  String settingsClockFailed(String problem) {
    return '无法检查时钟：$problem';
  }

  @override
  String get settingsLockApp => '锁定应用';

  @override
  String settingsLockAppHelp(String lock) {
    return '打开应用时要求$lock';
  }

  @override
  String get settingsPasscodeOnHelp => '已开启。点按可更改或关闭。';

  @override
  String settingsPasscodeOffHelp(String lock) {
    return '已关闭。输入数字来打开应用，可以代替$lock或与之同时使用。';
  }

  @override
  String get settingsLockAgain => '再次锁定';

  @override
  String settingsLockAgainHelp(String time) {
    return '在后台 $time 后';
  }

  @override
  String get settingsLockFirst => '请先开启应用锁或应用密码';

  @override
  String get settingsDecoy => '伪装密码';

  @override
  String get settingsDecoyOn => '已开启。会打开一组单独的账号。点按可移除。';

  @override
  String get settingsDecoyOff => '第二个密码，打开一组单独的空账号';

  @override
  String settingsWipe(int count) {
    return '输错 $count 次密码后抹除';
  }

  @override
  String get settingsWipeHelp => '紧急抹除。需要最近 30 天内做过备份。';

  @override
  String get settingsLockOnSleep => '电脑睡眠时锁定';

  @override
  String get settingsLockOnSleepHelp => '屏幕锁定或你暂时退出登录时也会锁定';

  @override
  String get settingsLockOnSleepNeedsLock => '请先开启“锁定应用”或应用密码，这样才有东西可锁。';

  @override
  String get settingsTravel => '旅行模式';

  @override
  String get settingsTravelPremium => '旅行模式（Premium）';

  @override
  String get settingsTravelOnHelp =>
      '已开启。标记为“旅行模式下隐藏”的账号会从这台设备的屏幕、小组件、手表、扩展和导出中消失，直到你关闭旅行模式。它们不会被删除。';

  @override
  String settingsTravelOffHelp(String proof) {
    return '过境检查前使用：隐藏你标记为“旅行模式下隐藏”的账号（⋯ >“编辑”）。关闭时需要$proof。';
  }

  @override
  String get settingsKeys => '安全密钥';

  @override
  String get settingsKeysPremium => '安全密钥（Premium）';

  @override
  String get settingsKeysHelp => '用 YubiKey 或其他安全密钥解锁';

  @override
  String get settingsActivity => '活动记录';

  @override
  String get settingsActivityPremium => '活动记录（Premium）';

  @override
  String get settingsActivityHelp => '哪些验证码在什么时候被复制、填写、输入或导出。只保存在这台设备上。';

  @override
  String get settingsEmergency => '紧急访问';

  @override
  String get settingsEmergencyPremium => '紧急访问（Premium）';

  @override
  String get settingsEmergencyHelp => '万一你出了什么事，让一位信任的人获取你的账号；需等待 7 天，期间你可以阻止';

  @override
  String get settingsTeamHelp => '与最多 10 人共享登录验证码，端到端加密';

  @override
  String get settingsMonthly => '每月摘要通知';

  @override
  String get settingsMonthlyPremium => '每月摘要通知（Premium）';

  @override
  String get settingsMonthlyHelp => '每月 1 日提醒你看一下摘要卡片。通知里绝不会提到你的账号。';

  @override
  String get settingsBlockShots => '禁止截屏';

  @override
  String get settingsBlockShotsDesktop => '在截屏、录屏和屏幕共享中隐藏这个窗口';

  @override
  String get settingsBlockShotsPhone => '让验证码不出现在截屏、录屏和应用切换器中';

  @override
  String get settingsCheckup => '安全检查';

  @override
  String get settingsCheckupHelp => '值得修复的问题，以及你的恢复工具包';

  @override
  String get settingsBreachPremium => '泄露提醒（Premium）';

  @override
  String get settingsBreachOn => '已开启。每周检查一次公开的泄露列表。';

  @override
  String get settingsBreachOff => '已关闭。开启后，应用每周下载一次公开的泄露列表。';

  @override
  String settingsThemeSemantic(String name) {
    return '$name主题';
  }

  @override
  String settingsThemeSemanticPremium(String name) {
    return '$name主题，Premium';
  }

  @override
  String get settingsPremiumThanks => 'Premium：谢谢你！';

  @override
  String get settingsGetPremium => '获取 Premium';

  @override
  String get settingsPremiumThanksHelp => '所有主题和以后的 Premium 功能都归你了。';

  @override
  String settingsGetPremiumHelp(String payOnce) {
    return '$payOnce：所有主题、在你的设备间同步，以及更多功能。';
  }

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsCountdown => '倒计时样式';

  @override
  String get settingsCountdownHelp => '每个验证码剩余时间的显示方式';

  @override
  String get settingsEasyFont => '易读字体';

  @override
  String get settingsEasyFontHelp =>
      'Atkinson Hyperlegible，由布莱叶盲文研究所设计，让字母和数字不容易混淆';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsAccountsList => '账号列表';

  @override
  String get settingsCompact => '紧凑卡片';

  @override
  String get settingsCompactHelp => '卡片更小，屏幕上能放下更多账号';

  @override
  String get settingsSort => '账号排序';

  @override
  String settingsSortHelp(String sort) {
    return '$sort。收藏的账号始终排在最前。';
  }

  @override
  String get settingsSortCustom => '自定义顺序。长按卡片，然后拖动。';

  @override
  String get settingsSortRecent => '刚复制过验证码的账号移到最上面';

  @override
  String get settingsSortName => '按服务名称';

  @override
  String get settingsTidyHelp =>
      '把“google.com:you@gmail.com”这样的名称改成“Google”。每处更改都会先给你看。';

  @override
  String get settingsHideCodes => '点按后才显示验证码';

  @override
  String get settingsHideCodesHelp => '用圆点代替验证码，旁边的人看不到';

  @override
  String get settingsShareCodes => '在小组件和手表上显示验证码';

  @override
  String get settingsShareCodesHelp =>
      '收藏账号的验证码会显示在主屏幕、锁定屏幕和手表上，不用打开这个应用，所以任何拿着你已解锁手机或手表的人都能看到。给账号加星标即可收藏。';

  @override
  String get settingsAutofill => '用自动填充填写验证码';

  @override
  String get settingsAutofillHelpIos =>
      '当网站或应用要求输入 2FA 验证码时，iPhone 会在键盘上方提供验证码，不用复制。需先验证的账号在填写前需要 Face ID。旅行模式下隐藏的账号永远不会出现。';

  @override
  String get settingsAutofillHelpAndroid =>
      '当应用或网站要求输入 2FA 验证码时，手机会在一个小弹窗里提供验证码，不用复制。Android 同一时间只允许一个应用自动填充，所以这会替换你密码管理器的自动填充。如果你依赖它，请保持关闭。';

  @override
  String get settingsAutofillStepsTitle => '开启自动填充';

  @override
  String get settingsAutofillStepsIos =>
      '需要 iOS 18 或更新版本。\n\n1. 打开“设置”应用（灰色齿轮图标）。\n2. 点按“通用”，然后点“自动填充与密码”。\n3. 在可以自动填充的应用列表中，打开 Tanooki Auth 旁边的开关。\n\n开关变成绿色就成功了。下次网站或应用要求输入验证码时，点按验证码输入框，再点键盘上方的 Tanooki Auth 建议。';

  @override
  String get settingsAutofillStepsAndroid =>
      '1. 点按下方的“打开设置”。会打开一个自动填充应用列表。\n2. 点按 Tanooki Auth，如果手机询问，再点“确定”。\n\n如果没有打开列表：打开“设置”应用，搜索“自动填充服务”，点按它，然后选择 Tanooki Auth。\n\n如果 Tanooki Auth 现在显示为自动填充服务，就成功了。下次应用或网站要求输入验证码时，点按验证码输入框，在弹窗中选择 Tanooki Auth。\n\nAndroid 同一时间只允许一个应用自动填充。选择 Tanooki Auth 后，你的密码管理器（比如 Google、Bitwarden 或 1Password）将无法填写密码。要切换回去，在同一个地方重新选择它即可。';

  @override
  String get settingsAutofillOpen => '打开设置';

  @override
  String get settingsTrash => '回收站';

  @override
  String settingsTrashCount(int count) {
    return '回收站（$count）';
  }

  @override
  String get settingsTrashHelp => '已删除的账号会在这里保留 30 天';

  @override
  String get settingsWatchFace => '表盘收藏账号';

  @override
  String get settingsWatchFacePremium => '表盘收藏账号（Premium）';

  @override
  String get settingsWatchFaceNoFavorites => '请先在主列表中给账号加星标。只有收藏的账号才能放到表盘上。';

  @override
  String get settingsNone => '无';

  @override
  String get settingsCopying => '复制和快捷方式';

  @override
  String get settingsCopyOnOpen => '打开时复制';

  @override
  String get settingsCopyOnOpenHelp => '打开或解锁应用时，复制你上次使用的账号的验证码。需先验证的账号会跳过。';

  @override
  String get settingsPasteOnce => '粘贴一次后清除';

  @override
  String get settingsPasteOnceHelp =>
      '复制的验证码只能粘贴一次，之后剪贴板会清空。剪贴板历史应用可能会占用这一次粘贴。在 Windows 上，验证码改为 30 秒后清除。';

  @override
  String get settingsSpotlight => '在聚焦搜索中显示账号';

  @override
  String get settingsSpotlightHelp => '在任何地方搜索账号名称，直接跳转过去。只共享名称，绝不共享验证码。';

  @override
  String get settingsLiveActivity => '复制后在锁定屏幕显示验证码';

  @override
  String get settingsLiveActivityPremium => '复制后在锁定屏幕显示验证码（Premium）';

  @override
  String get settingsLiveActivityHelp => '复制验证码后，它会显示在锁定屏幕和灵动岛上，并倒计时直到过期。';

  @override
  String get settingsWatchFaceHelp =>
      '选择一个收藏的账号，让它的验证码显示在 Apple Watch 表盘上。需要开启“在小组件和手表上显示验证码”。';

  @override
  String settingsWatchFaceChosen(String name) {
    return '$name。把 Tanooki Auth 复杂功能添加到表盘上就能看到它。';
  }

  @override
  String get settingsBrowserSection => '浏览器扩展和启动器';

  @override
  String get settingsBridgeOff => '未运行';

  @override
  String get settingsBridgeOn => '已准备好连接浏览器扩展';

  @override
  String settingsBridgeOffHelp(String first, String last) {
    return '端口 $first–$last 都被其他程序占用了，所以扩展无法连接。请重新启动电脑后重试。';
  }

  @override
  String settingsBridgeOnHelp(String port) {
    return '只在这台电脑上监听（127.0.0.1:$port）。Tanooki Auth 打开时可用。';
  }

  @override
  String settingsPairedClient(String name) {
    return '已配对：$name';
  }

  @override
  String get settingsPairedBrowser => '已配对的浏览器';

  @override
  String settingsExtensionId(String id) {
    return '扩展 $id';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSecurity => '安全';

  @override
  String get settingsBackup => '备份';

  @override
  String get settingsExport => '导出备份';

  @override
  String get settingsExportHelp => '一个加密文件，用你选择的密码短语锁定';

  @override
  String get settingsImport => '导入备份';

  @override
  String get settingsImportHelp => '从备份文件添加账号；已有的会跳过';

  @override
  String get settingsTestBackup => '测试备份';

  @override
  String get settingsTestBackupHelp => '检查备份文件能否用你的密码短语打开。不会更改任何内容。';

  @override
  String get settingsMoveOut => '迁移到其他应用';

  @override
  String get settingsMoveOutHelp => 'Aegis、2FAS、Google Authenticator，或纯设置链接';

  @override
  String get settingsPaper => '打印纸质备份';

  @override
  String get settingsPaperHelp => '包含二维码和恢复码的 PDF，请放在上锁的地方保管';

  @override
  String get settingsHelp => '帮助';

  @override
  String get settingsGuidesHelp => '我们网站上的分步帮助，教你在热门网站开启 2FA';

  @override
  String get settingsTour => '显示欢迎导览';

  @override
  String get settingsFeedbackHelp => '告诉 Maddie 你发现的 bug 或想法。绝不会包含你的账号或验证码。';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsAboutMaddieHelp => '来自 Tanooki Auth 开发者的一段话';

  @override
  String get settingsCodesNotWorking => '验证码不对？';

  @override
  String settingsCodesNotWorkingHelp(String time) {
    return '设备时间 $time。验证码依赖时钟：点按即可与互联网时间核对。';
  }

  @override
  String shareUiConfirmTitle(String name) {
    return '分享 $name？';
  }

  @override
  String get shareUiConfirmBody =>
      '接收分享的人将获得完全访问权限：只要他们保留着，他们的手机就会生成和你一样的验证码。只分享给你完全信任的人，比如家人。\n\n以后从你的列表中移除它，也收不回对方那份。要切断对方的访问，请在网站上关闭再重新开启两步验证。';

  @override
  String get shareUiConfirmButton => '我明白了，分享';

  @override
  String get shareUiLocking => '正在加密分享…';

  @override
  String shareUiTitle(String name) {
    return '分享 $name';
  }

  @override
  String get shareUiInstructions =>
      '在对方的设备上：打开 Tanooki Auth，点按“添加账号”，然后点“扫描二维码”（如果是文件，点“打开分享的账号”）。然后让对方输入这个码：';

  @override
  String get shareUiTellCode => '亲口告诉对方这个码，或者用和发送文件不同的应用告诉对方。';

  @override
  String get shareUiSendFile => '改为以文件发送';

  @override
  String get shareUiCopyLink => '复制为链接';

  @override
  String get shareUiCopied => '已复制。对方用“粘贴设置链接”粘贴即可。';

  @override
  String get shareUiWorksFor => '24 小时内有效，且必须配合这个码。不经过任何服务器。';

  @override
  String get shareUiOpenTitle => '分享的账号';

  @override
  String get shareUiOpenBody => '输入分享者给你的 6 位数字码。';

  @override
  String get shareUiUnlocking => '正在解锁…';

  @override
  String get signatureLabel => 'Maddie 敬上';

  @override
  String get syncUiQrCode => '二维码';

  @override
  String get syncUiNotYet => '尚未同步';

  @override
  String get syncUiJustNow => '刚刚';

  @override
  String syncUiMinutesAgo(int minutes) {
    return '$minutes 分钟前';
  }

  @override
  String syncUiHoursAgo(int hours) {
    return '$hours 小时前';
  }

  @override
  String syncUiDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get syncUiThisDevice => '这台设备';

  @override
  String get syncUiAnotherDevice => '另一台设备';

  @override
  String syncUiAdded(String when) {
    return '添加时间：$when';
  }

  @override
  String syncUiThisDeviceNamed(String name) {
    return '这台设备（$name）';
  }

  @override
  String syncUiLastSyncedAgo(String when) {
    return '上次同步：$when';
  }

  @override
  String get syncUiWhere => '你的设备要通过哪里同步？';

  @override
  String get syncUiICloudHelp => '仅适用于 iPhone、iPad 和 Mac。使用你自己的 iCloud 云盘。';

  @override
  String get syncUiRelay => 'Tanooki 中继';

  @override
  String get syncUiRelayHelp => '适用于所有设备，包括 Android 和 Windows。服务器只存储加密后的乱码数据。';

  @override
  String get syncUiStartFreshTitle => '重新开始？';

  @override
  String get syncUiStartFreshBody =>
      '如果你忘了其他 Apple 设备使用的密码短语，可以用这个新的重新开始同步。之后你的其他设备需要关闭再开启同步，并输入新的密码短语。';

  @override
  String get syncUiStartFresh => '重新开始';

  @override
  String get syncUiOn => '同步已开启。';

  @override
  String get syncUiScanTitle => '扫描同步码';

  @override
  String get syncUiScanWrong => '这不是同步码。请在你的另一台设备上打开“设置”>“同步”>“添加设备”。';

  @override
  String get syncUiNowSyncing => '这台设备现在开始同步了。';

  @override
  String get syncUiPasteTitle => '粘贴同步链接';

  @override
  String get syncUiPasteHint => 'tanookiauth://sync?…（来自另一台设备上的“添加设备”）';

  @override
  String get syncUiAddApple => '添加 Apple 设备';

  @override
  String get syncUiAddAppleBody =>
      '在你的另一台 iPhone、iPad 或 Mac 上（登录同一个 Apple 账户，并开启 iCloud 云盘），打开 Tanooki Auth，进入“设置”>“同步”，点按“开启同步”，选择 iCloud，然后输入相同的同步密码短语。\n\n想添加 Android 手机或 Windows 电脑？请在所有设备上关闭同步，然后用 Tanooki 中继重新开启。';

  @override
  String get syncUiAddDevice => '添加设备';

  @override
  String get syncUiAddDeviceBody =>
      '在新设备上打开 Tanooki Auth，进入“设置”>“同步”，点按“从另一台设备加入”。扫描这个码，然后在那里输入你的同步密码短语。';

  @override
  String get syncUiAddDeviceNote => '只能用一次，24 小时内有效。只有这个码而没有你的密码短语，什么也读不到。';

  @override
  String get syncUiLinkCopied => '链接已复制。请在新设备上粘贴。';

  @override
  String get syncUiCopyLink => '改为复制链接';

  @override
  String get syncUiRemoveTitle => '从同步中移除这台设备？';

  @override
  String get syncUiRemoveBody =>
      '它将不再接收更改。如果设备丢失或被盗，还要更改你的同步密码短语：在所有设备上关闭同步，再用新的密码短语重新开启，因为丢失的设备仍然知道旧的。';

  @override
  String get syncUiTurnOffTitle => '在这台设备上关闭同步？';

  @override
  String get syncUiTurnOffBody => '你的账号会保留在这台设备上，只是不再发送和接收更改。你的其他设备之间会继续同步。';

  @override
  String get syncUiOff => '这台设备已关闭同步。';

  @override
  String get syncUiPremium => '同步属于 Premium 功能';

  @override
  String syncUiPremiumBody(String payOnce) {
    return '在一台设备上添加账号，所有设备上都会出现，全程端到端加密。$payOnce，无需订阅。';
  }

  @override
  String get syncUiIntro =>
      '同步让你所有设备上的账号保持一致。数据离开这台设备前，会先用你的同步密码短语加密，所以 iCloud 或我们的服务器只会存储加密后的乱码数据。除你之外没人能读取，包括我们。';

  @override
  String get syncUiTurnOn => '开启同步';

  @override
  String get syncUiJoin => '从另一台设备加入';

  @override
  String get syncUiJoinHelp => '如果另一台设备已经在用 Tanooki 中继同步，请用“加入”。';

  @override
  String get syncUiSyncingRelay => '正在通过 Tanooki 中继同步';

  @override
  String get syncUiSyncingICloud => '正在通过 iCloud 同步';

  @override
  String get syncUiSyncingNow => '正在同步…';

  @override
  String syncUiSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 个同步项目无法读取',
    );
    return '$_temp0';
  }

  @override
  String get syncUiSkippedHelp => '它们可能被别人改过，或者是用另一个密码短语生成的。没有因此删除任何内容。';

  @override
  String get syncUiDevices => '设备';

  @override
  String get syncUiLoading => '正在加载…';

  @override
  String get syncUiAddDeviceRelay => '显示一个码，在新设备上扫描';

  @override
  String get syncUiAddDeviceApple => '另一台 iPhone、iPad 或 Mac';

  @override
  String get syncUiTurnOffButton => '在这台设备上关闭同步';

  @override
  String get syncUiPassphraseNoteRelay =>
      '同步密码短语无法找回。如果忘了，请在所有设备上关闭同步，再用新的密码短语重新开始。你的账号不会丢。';

  @override
  String get syncUiPassphraseNoteICloud =>
      '同步使用你的 iCloud 云盘。同步密码短语无法找回；如果忘了，请用新的密码短语重新开始。你的账号不会丢。';

  @override
  String get syncUiTitle => '同步';

  @override
  String get syncUiTooShort => '请至少使用 10 个字符。几个随机的词就很好。';

  @override
  String get syncUiMismatch => '两次输入的密码短语不一致。';

  @override
  String get syncUiChoosePassphrase => '设置同步密码短语';

  @override
  String get syncUiTypePassphrase => '输入你的同步密码短语';

  @override
  String get syncUiChooseHelp =>
      '每添加一台设备，你都要在上面输入一次。账号离开这台设备前会用它加密。\n\n请把它写下来，放在安全的地方。无论是你还是我们，都无法找回或重置它。';

  @override
  String get syncUiTypeHelp => '就是你在第一台设备上开启同步时设置的那个密码短语。';

  @override
  String get syncUiPassphrase => '同步密码短语';

  @override
  String get syncUiTypeAgain => '再输入一次';

  @override
  String get syncUiSectionTitle => '同步和手机';

  @override
  String get syncUiTitlePremium => '同步（Premium）';

  @override
  String get syncUiOnRelay => '已开启，通过 Tanooki 中继';

  @override
  String get syncUiOnICloud => '已开启，通过 iCloud';

  @override
  String get syncUiOffHelp => '让你所有设备上的账号保持一致';

  @override
  String get syncUiBrowser => '配合浏览器使用';

  @override
  String get syncUiBrowserPremium => '配合浏览器使用（Premium）';

  @override
  String get syncUiBrowserHelp => '在这部手机上批准验证码，供任何电脑上的浏览器使用';

  @override
  String get teamUiCreateTitle => '创建你的团队';

  @override
  String get teamUiCreateHint => 'TT1.…（来自订阅后显示的页面）';

  @override
  String get teamUiCreateButton => '创建团队';

  @override
  String get teamUiReady => '你的团队已准备好。用“邀请成员”邀请大家加入。';

  @override
  String get teamUiScanTitle => '扫描团队邀请';

  @override
  String get teamUiScanWrong => '这不是团队邀请。请让团队管理员打开“设置”>“团队保险库”>“邀请成员”。';

  @override
  String get teamUiJoinTitle => '加入团队';

  @override
  String get teamUiJoinHint => 'tanookiauth://team?…（团队管理员发来的邀请链接）';

  @override
  String get teamUiJoinButton => '加入';

  @override
  String get teamUiJoinedTeam => '你已加入团队。管理员的应用把团队密钥共享给这台设备后，团队账号就会出现。';

  @override
  String get teamUiInvite => '邀请成员';

  @override
  String get teamUiInviteHelp =>
      '在对方的设备上：“设置”>“团队保险库”，然后点“扫描邀请二维码”或“粘贴邀请链接”。邀请只能用一次，有效期 7 天。';

  @override
  String get teamUiRemovePersonTitle => '移除这个人？';

  @override
  String get teamUiRemovePersonBody =>
      '对方会立即失去访问权限，团队也会换一个新密钥，让对方读不到之后添加或更改的任何内容。对方可能保存了已经能看到的验证码副本，所以请为重要账号重新设置两步验证。';

  @override
  String get teamUiRemoved => '已移除。团队已换用新密钥。';

  @override
  String get teamUiDeleteTitle => '删除团队？';

  @override
  String get teamUiLeaveTitle => '退出团队？';

  @override
  String get teamUiDeleteBody => '所有团队账号都会为团队中的每个人删除。每个人自己的账号不受影响。';

  @override
  String get teamUiLeaveBody => '团队的账号会从这台设备上消失。你自己的账号不受影响。';

  @override
  String get teamUiDeleteButton => '删除团队';

  @override
  String get teamUiLeaveButton => '退出';

  @override
  String get teamUiDeleted => '团队已删除。';

  @override
  String get teamUiLeft => '你已退出团队。';

  @override
  String get teamUiAddFirst => '请先把账号添加到 Tanooki Auth，再在这里把它复制到团队中。';

  @override
  String get teamUiCopyInTitle => '把你的一个账号复制到团队中';

  @override
  String teamUiCopiedIn(String name) {
    return '$name 现在已在团队中。你自己的那份保持不变。';
  }

  @override
  String get teamUiRenameTitle => '重命名团队账号';

  @override
  String get teamUiRenameHint => '名称，例如 AWS';

  @override
  String teamUiRemoveAccountTitle(String name) {
    return '从团队中移除 $name？';
  }

  @override
  String get teamUiRemoveAccountBody => '团队中的每个人都将看不到它。';

  @override
  String get teamUiIntro =>
      '团队保险库可与最多 10 人共享登录验证码，每年 \$20。团队中的每个人都能查看、添加和更改团队账号。它们在你的设备上用只有团队才有的密钥加密，所以我们的服务器无法读取。团队账号放在单独的“团队”分区，绝不会和你自己的账号混在一起。';

  @override
  String get teamUiStart => '创建团队';

  @override
  String get teamUiBuy => '购买团队方案 — 每年 \$20';

  @override
  String get teamUiPlanSoon => '团队方案即将推出';

  @override
  String get teamUiHaveLicense => '我有团队许可证：创建团队';

  @override
  String get teamUiJoinHelp => '向团队管理员索取邀请。加入是免费的。';

  @override
  String get teamUiScanInvite => '扫描邀请二维码';

  @override
  String get teamUiPasteInvite => '粘贴邀请链接';

  @override
  String get teamUiYouRun => '你是这个团队的管理员';

  @override
  String get teamUiYoureIn => '你在一个团队中';

  @override
  String teamUiPeopleCount(int count, int max) {
    return '$count/$max 人';
  }

  @override
  String teamUiLastSynced(String when) {
    return '上次同步：$when';
  }

  @override
  String teamUiPaidUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '已付费至 $dateString';
  }

  @override
  String get teamUiSyncNow => '立即同步';

  @override
  String get teamUiWaitingForKey =>
      '正在等待团队管理员的应用把团队密钥共享给这台设备。管理员下次打开 Tanooki Auth 时就会完成。';

  @override
  String get teamUiAccounts => '团队账号';

  @override
  String get teamUiAddMine => '添加我的账号';

  @override
  String get teamUiNoAccounts => '还没有团队账号。';

  @override
  String get teamUiChange => '更改';

  @override
  String get teamUiRename => '重命名';

  @override
  String get teamUiRemoveFromTeam => '从团队中移除';

  @override
  String get teamUiPeople => '成员';

  @override
  String get teamUiThisDevice => '这台设备（管理员）';

  @override
  String teamUiDevice(String id) {
    return '设备 $id';
  }

  @override
  String teamUiJoined(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '加入于 $dateString';
  }

  @override
  String teamUiJoinedGettingKey(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '加入于 $dateString · 正在获取团队密钥';
  }

  @override
  String get teamUiDeleteTeam => '删除团队';

  @override
  String get teamUiLeaveTeam => '退出团队';

  @override
  String get teamUiTitle => '团队保险库';

  @override
  String teamUiCopiedCode(String name) {
    return '已复制 $name 的验证码。剪贴板会在 30 秒后清空。';
  }

  @override
  String teamUiSection(int count) {
    return '团队 · $count';
  }

  @override
  String get teamUiWaitingShort => '正在等待团队管理员把团队密钥共享给这台设备。';

  @override
  String get teamUiNoAccountsHint => '还没有团队账号。请在“设置”>“团队保险库”中添加。';

  @override
  String get themeAuto => '自动';

  @override
  String get themeDark => '深色';

  @override
  String get themeLight => '浅色';

  @override
  String get themePink => '淡粉';

  @override
  String get themeBlue => '淡蓝';

  @override
  String get themeLavender => '薰衣草';

  @override
  String get themeMint => '薄荷';

  @override
  String get themeMidnight => '午夜';

  @override
  String get themeSunset => '日落';

  @override
  String get themePeach => '蜜桃';

  @override
  String get themeForest => '森林';

  @override
  String get themeOcean => '海洋';

  @override
  String get themeMono => '黑白';

  @override
  String get tidyNoName => '（无名称）';

  @override
  String tidyDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已整理 $count 个名称。',
    );
    return '$_temp0';
  }

  @override
  String get tidyTitle => '整理账号名称';

  @override
  String get tidyNothing => '你的账号名称都已经很整齐了。';

  @override
  String get tidyIntro => '这些名称里有网址或多余的部分。取消勾选你想保持原样的名称，然后点按“应用”。你的验证码不会改变。';

  @override
  String tidyWas(String name) {
    return '原名称：$name';
  }

  @override
  String get tidyNothingTicked => '没有勾选任何项';

  @override
  String tidyApply(int count) {
    return '应用 $count 项';
  }

  @override
  String get emergencyNotContactCode =>
      '这不是 Tanooki Auth 联系人码。请让对方打开 Tanooki Auth，进入“设置”>“紧急访问”，分享他们的联系人码。';

  @override
  String get emergencyCopyWontOpen => '无法用这台设备的密钥打开紧急副本。它是为另一台设备制作的，或者已损坏。';

  @override
  String get emergencyGone => '这个紧急副本已不存在。所有者已将其移除。';

  @override
  String get emergencyWaitNotOver => '7 天等待期还没结束。';

  @override
  String get emergencyNotOwnerOrContact => '这台设备既不是该紧急副本的所有者，也不是其联系人。';

  @override
  String get emergencyNoRequestToDeny => '已经没有可拒绝的请求了。';

  @override
  String get emergencyAskFirst => '请先申请访问。';

  @override
  String get emergencyTooBig => '你的账号数据太大，无法保存为紧急副本（上限约 500 KB）。';

  @override
  String get emergencyTooManyTries => '一分钟内尝试次数太多。请等一分钟后重试。';

  @override
  String emergencyServerSaidNo(String status) {
    return '同步服务器拒绝了请求（HTTP $status）。';
  }

  @override
  String emergencyServerSaidNoWhy(String status, String reason) {
    return '同步服务器拒绝了请求（HTTP $status：$reason）。';
  }

  @override
  String get emergencyNotEmergencyCode =>
      '这不是 Tanooki Auth 紧急码。请让选择你的人从“设置”>“紧急访问”重新发送。';

  @override
  String get emergencyLessThanMinute => '不到一分钟';

  @override
  String emergencyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 天',
    );
    return '$_temp0';
  }

  @override
  String emergencyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 小时',
    );
    return '$_temp0';
  }

  @override
  String emergencyMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分钟',
    );
    return '$_temp0';
  }

  @override
  String emergencyDaysHours(int days, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days 天',
    );
    String _temp1 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours 小时',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get emergencyUiExplainer =>
      '选择一位你信任的人。万一你出了什么事，对方可以申请获取你的账号。你的设备会收到通知，你有 7 天时间拒绝。如果没人拒绝，对方就会得到一份副本。\n\nTanooki Auth 服务器只负责执行 7 天等待期。副本用只有对方设备才有的密钥锁定，所以服务器无法读取，入侵服务器的人也读不了。';

  @override
  String emergencyUiPushNotWorking(String reason) {
    return '通知暂时无法使用（$reason）。每次打开 Tanooki Auth 时都会检查是否有请求。';
  }

  @override
  String get emergencyUiScanTheirQr => '扫描对方的二维码';

  @override
  String get emergencyUiPasteCode => '粘贴对方发来的码';

  @override
  String get emergencyUiWrongCode => '这个码不对。';

  @override
  String get emergencyUiCopiedCode => '已复制。用任何方式发给对方都可以：它不包含任何机密信息。';

  @override
  String get emergencyUiCopyAsText => '复制为文本';

  @override
  String get emergencyUiTheirContactCode => '对方的联系人码';

  @override
  String get emergencyUiNotContactCodeShort => '这不是 Tanooki Auth 联系人码。';

  @override
  String get emergencyUiMakeThemContact => '把对方设为你的紧急联系人？';

  @override
  String emergencyUiMakeNamedContact(String name) {
    return '把 $name 设为你的紧急联系人？';
  }

  @override
  String get emergencyUiCopyLeftOnServer =>
      '你所有账号的一份副本会锁定到对方的设备，并保存在 Tanooki Auth 服务器上。你更改账号时它会随之更新。';

  @override
  String get emergencyUiYourNameWhose => '你的名字（让对方知道这是谁的副本）';

  @override
  String get emergencyUiDoneGiveCode => '完成。现在把这个屏幕上的码给对方。';

  @override
  String get emergencyUiStopTitle => '停止紧急访问？';

  @override
  String get emergencyUiStopBody => '副本会从服务器上删除，对方也无法再申请。';

  @override
  String get emergencyUiChooseContact => '选择紧急联系人';

  @override
  String get emergencyUiChooseContactPremium => '选择紧急联系人（Premium）';

  @override
  String get emergencyUiChooseContactHow =>
      '对方在自己的设备上打开 Tanooki Auth，进入“设置”>“紧急访问”，给你看他们的联系人码。';

  @override
  String get emergencyUiYourContact => '你的联系人';

  @override
  String get emergencyUiChecking => '正在与服务器核对…';

  @override
  String get emergencyUiIdleJustNow => '没有人申请。副本刚刚更新过。';

  @override
  String emergencyUiIdleUpdated(String day) {
    return '没有人申请。副本上次更新于$day。';
  }

  @override
  String emergencyUiWaiting(String who, String day, String left) {
    return '$who于$day提出申请。除非你拒绝，对方将在 $left后可以打开副本。';
  }

  @override
  String emergencyUiReleased(String who) {
    return '$who已申请，且等待期已结束：对方现在可以打开副本。点“拒绝”可阻止。';
  }

  @override
  String emergencyUiContactIs(String who) {
    return '紧急联系人：$who';
  }

  @override
  String get emergencyUiDenied => '已拒绝。对方无法打开你的账号。对方以后还可以再次申请。';

  @override
  String get emergencyUiCopyUpdated => '副本已更新。';

  @override
  String get emergencyUiCouldntUpdate => '无法更新副本。';

  @override
  String get emergencyUiUpdateNow => '立即更新副本';

  @override
  String emergencyUiGiveCode(String who) {
    return '把这个码给$who。对方在 Tanooki Auth 中进入“设置”>“紧急访问”>“添加别人给你的码”。';
  }

  @override
  String get emergencyUiCodeTheyGave => '对方给你的码';

  @override
  String get emergencyUiNotEmergencyCodeShort => '这不是 Tanooki Auth 紧急码。';

  @override
  String get emergencyUiAddedTheir => '已添加。如果有需要，你可以在这里申请获取对方的账号。';

  @override
  String emergencyUiAddedNamed(String name) {
    return '已添加。如果有需要，你可以在这里申请获取 $name 的账号。';
  }

  @override
  String get emergencyUiTheOwner => '所有者';

  @override
  String get emergencyUiAskTitle => '申请紧急访问？';

  @override
  String emergencyUiAskBody(String who) {
    return '$who会收到通知，并有 7 天时间拒绝。如果对方没有拒绝，你就可以在这里打开其账号的副本。只在真正需要时才申请。';
  }

  @override
  String get emergencyUiAsk => '申请';

  @override
  String get emergencyUiAsked => '已申请。7 天等待期已开始。';

  @override
  String emergencyUiAddTheirAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '添加对方的 $count 个账号？',
    );
    return '$_temp0';
  }

  @override
  String emergencyUiAddNamedAccounts(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '添加 $name 的 $count 个账号？',
    );
    return '$_temp0';
  }

  @override
  String get emergencyUiSomeone => '某人';

  @override
  String get emergencyUiCheckingShort => '正在检查…';

  @override
  String get emergencyUiNotAsked => '你还没有申请。';

  @override
  String get emergencyUiRequestAccess => '申请访问';

  @override
  String emergencyUiOpensIn(String left, String day) {
    return '你已申请。除非对方拒绝，将在 $left后（$day）可以打开。';
  }

  @override
  String get emergencyUiWaitOver => '等待期已结束。';

  @override
  String get emergencyUiOpenCopy => '打开紧急副本';

  @override
  String emergencyUiPersonAccounts(String who) {
    return '$who的账号';
  }

  @override
  String get emergencyUiYourContactCode => '你的联系人码';

  @override
  String get emergencyUiShowThis => '如果有人想把你设为紧急联系人，就给对方看这个。它不包含任何机密信息。';

  @override
  String get emergencyUiYourNameItsYou => '你的名字（让对方知道是你）';

  @override
  String get emergencyUiShowMyCode => '显示我的联系人码';

  @override
  String get emergencyUiLetThemScan => '让对方在 Tanooki Auth 中扫描，或者复制后发给对方。';

  @override
  String get emergencyUiAddCodeGiven => '添加别人给你的码';

  @override
  String get emergencyUiAddCodeGivenHow => '对方选择你之后，他们的应用会显示一个给你的码';

  @override
  String get emergencyUiTitle => '紧急访问';

  @override
  String get emergencyUiYourEmergencyContact => '你的紧急联系人';

  @override
  String get emergencyUiPeopleWhoChoseYou => '选择了你的人';

  @override
  String get securityUiProofWindows => 'Windows Hello';

  @override
  String get securityUiProofMac => 'Touch ID 或你的密码';

  @override
  String get securityUiProofIos => 'Face ID 或设备密码';

  @override
  String get securityUiProofOther => '指纹或 PIN 码';

  @override
  String securityUiPasscodeAtLeast(int count) {
    return '密码（至少 $count 位数字）';
  }

  @override
  String get securityUiTypeAgain => '再输入一次';

  @override
  String get securityUiPasscodesDontMatch => '两次输入的密码不一致。';

  @override
  String get securityUiPickDifferent => '请选择一个和另一个密码不同的密码。';

  @override
  String get securityUiEnterPasscode => '输入你的应用密码';

  @override
  String get securityUiPasscode => '密码';

  @override
  String get securityUiWrongPasscode => '密码不对。';

  @override
  String get securityUiCheckupTitle => '安全检查';

  @override
  String get securityUiAllGood => '一切正常';

  @override
  String get securityUiAllGoodBody => '你的应用已上锁，有最近的备份，并且每个账号都有恢复码。';

  @override
  String get securityUiLockOffTitle => '应用没有上锁';

  @override
  String get securityUiLockOffBody =>
      '任何人拿起你已解锁的设备都能看到你的验证码。请在“设置”中开启“锁定应用”或应用密码。';

  @override
  String get securityUiNoPasscodeTitle => '没有应用密码';

  @override
  String get securityUiNoPasscodeBody =>
      '即使 Face ID 或指纹失灵，有了应用密码也能打开 Tanooki Auth。请在“设置”中设置一个。';

  @override
  String get securityUiAutoBackupFailed => '自动备份失败';

  @override
  String get securityUiOpenAutoBackups => '打开自动备份';

  @override
  String get securityUiNoBackupTitle => '最近 30 天内没有备份';

  @override
  String get securityUiNoBackupBody => '如果这台设备丢失或损坏，备份是找回账号的唯一办法。';

  @override
  String get securityUiMakeBackupNow => '立即备份';

  @override
  String securityUiNoRecoveryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 个账号没有恢复码',
    );
    return '$_temp0';
  }

  @override
  String securityUiNoRecoveryBody(String names) {
    return '如果你丢了这个应用，恢复码能让你登录网站。请在每个网站的安全设置中找到它们，然后通过账号的 ⋯ >“恢复码”添加。\n\n$names';
  }

  @override
  String get securityUiRecoveryKit => '你的恢复工具包';

  @override
  String get securityUiRecoveryKitSub => '备份、恢复码和纸质副本，一步一步来';

  @override
  String securityUiBreachSnack(String sites) {
    return '$sites发生了数据泄露。请去那里更改你的密码。';
  }

  @override
  String get securityUiBreachDownloadFailed => '无法下载泄露列表。请检查网络连接后重试。';

  @override
  String get securityUiBreachAlerts => '泄露提醒';

  @override
  String get securityUiBreachAlertsPremium => '泄露提醒（Premium）';

  @override
  String get securityUiBreachAlertsSub => '每周一次，告诉你用过的网站是否发生了数据泄露';

  @override
  String get securityUiBreachHow =>
      '工作原理：Tanooki Auth 从 haveibeenpwned.com 下载已知泄露事件的公开列表，并在这台设备上与你保存的网站进行比对。不会发送任何关于你或你账号的信息：每个人下载的内容都一样。除了同步和购买 Premium，这是应用唯一一次联网。';

  @override
  String securityUiNoWebsite(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '你有 $count 个账号没有保存网站，所以无法检查。请通过 ⋯ >“编辑”添加。',
    );
    return '$_temp0';
  }

  @override
  String get securityUiCheckNow => '立即检查';

  @override
  String get securityUiNoBreaches => '你保存的网站没有已知的泄露事件。';

  @override
  String get securityUiBreached => '已泄露。如果你的密码是在那之前设置的，请去那里更改。';

  @override
  String securityUiBreachedOn(String date) {
    return '于 $date 泄露。如果你的密码是在那之前设置的，请去那里更改。';
  }

  @override
  String securityUiBreachedLeaked(String data) {
    return '已泄露。泄露内容：$data。如果你的密码是在那之前设置的，请去那里更改。';
  }

  @override
  String securityUiBreachedOnLeaked(String date, String data) {
    return '于 $date 泄露。泄露内容：$data。如果你的密码是在那之前设置的，请去那里更改。';
  }

  @override
  String get securityUiKitIntro =>
      '如果你丢了这台设备，靠这些才能重新登录你的账号。每项只需一分钟。如果你还没添加任何账号，请先添加，再从“设置”>“安全检查”回到这里。';

  @override
  String get securityUiKitBackupTitle => '做一个备份';

  @override
  String get securityUiKitBackupBody =>
      '一个加密文件，用你选择的密码短语锁定。请把它存放在这台设备以外的地方，比如 iCloud 云盘、Google 云端硬盘或 U 盘。';

  @override
  String get securityUiKitBackupButton => '做一个备份';

  @override
  String get securityUiKitCodesTitle => '保存你的恢复码';

  @override
  String get securityUiKitCodesBody =>
      '开启两步验证登录时，大多数网站都会给你一组一次性恢复码。通过 ⋯ >“恢复码”把它们添加到每个账号，这样备份里也会有。';

  @override
  String get securityUiKitPaperTitle => '打印纸质备份';

  @override
  String get securityUiKitPaperBody =>
      '可选。即使所有设备都没了，打印出来的二维码页面也能用。请把它锁好：任何拿到它的人都能生成你的验证码。';

  @override
  String get securityUiKitPaperButton => '打印纸质备份';

  @override
  String get securityUiSkipForNow => '暂时跳过';

  @override
  String get securityExtrasPrivacy =>
      '无需注册，没有跟踪。你的设置密钥加密保存在这台设备上。应用只在以下情况联网：时钟检查（向 Tanooki Auth 服务器询问时间，屏幕上显示验证码时最多每小时一次，以及你点按“验证码不对？”时；不会发送任何关于你或你账号的信息）；泄露提醒（如果你开启，会下载公开的泄露列表）；同步、手机连接和紧急访问（如果你设置了，它们只传输服务器无法读取的加密数据）；购买 Premium；以及你选择发送的反馈（你的消息、你填写的邮箱，以及勾选时附带的应用版本和设备类型；绝不包括你的账号、验证码或应用里的其他任何内容）。2FA 指南会在你的网页浏览器中打开。';

  @override
  String get securityExtrasMonthlyBody => '你的每月安全摘要已准备好。打开 Tanooki Auth 查看。';

  @override
  String get securityExtrasNotificationsOffIos =>
      'Tanooki Auth 的通知已关闭。请在 iPhone 的“设置”应用中的“通知”里开启，然后重试。';

  @override
  String get securityExtrasNotificationsOffMac =>
      'Tanooki Auth 的通知已关闭。请在“系统设置”的“通知”中开启，然后重试。';

  @override
  String securityExtrasReminderFailed(String reason) {
    return '无法设置提醒（$reason）。';
  }

  @override
  String get securityExtrasRemindersUnavailable => '这台设备暂不支持提醒。';

  @override
  String securityExtrasDayTime(String day, String time) {
    return '$day $time';
  }

  @override
  String get securityExtrasClearTitle => '清除活动记录？';

  @override
  String get securityExtrasClearBody => '所有记录都会从这台设备上移除。你的账号不受影响。';

  @override
  String get securityExtrasActivityTitle => '活动记录';

  @override
  String securityExtrasActivityPitch(int count) {
    return '活动记录属于 Premium 功能。它会保留最近 $count 次验证码被复制、填入网站、输入、显示为二维码或导出的记录，只保存在这台设备上。';
  }

  @override
  String get securityExtrasNothingYet => '暂无记录。复制、填写、输入、显示二维码或导出都会显示在这里。';

  @override
  String get securityExtrasAllAccounts => '所有账号';

  @override
  String get securityExtrasDeletedAccount => '一个已删除的账号';

  @override
  String securityExtrasActivityLine(String kind, String what) {
    return '$kind：$what';
  }

  @override
  String get securityExtrasGetPremium => '获取 Premium';

  @override
  String get securityExtrasAddKey => '添加安全密钥';

  @override
  String get securityExtrasAddKeyPremium => '添加安全密钥（Premium）';

  @override
  String get securityExtrasAddKeyIos =>
      '接下来，在提示时把密钥贴近 iPhone 顶部，或者插上它。你可能需要触摸两次。';

  @override
  String get securityExtrasAddKeyOther =>
      '接下来，插上密钥，在它闪烁时触摸它。你可能需要触摸两次；如果密钥设置了 PIN 码，还要输入。';

  @override
  String get securityExtrasKeyName => '名称（方便区分你的密钥）';

  @override
  String securityExtrasKeyAdded(String name) {
    return '已添加“$name”。现在你可以在这台设备上用它解锁 Tanooki Auth 了。';
  }

  @override
  String securityExtrasKeyRemoved(String name) {
    return '已移除“$name”。它不能再解锁 Tanooki Auth。';
  }

  @override
  String get securityExtrasKeysTitle => '安全密钥';

  @override
  String securityExtrasKeysIntro(String usual) {
    return '安全密钥（比如 YubiKey）可以代替$usual解锁 Tanooki Auth。密钥里保存着一个永不离开它的机密，应用用它来锁住你账号的密钥。即使丢了安全密钥，你仍然可以用平常的方式解锁。';
  }

  @override
  String securityExtrasKeyAddedOn(String day) {
    return '添加于$day';
  }

  @override
  String get securityExtrasLockOffNote =>
      '应用锁已关闭，所以应用打开时不会验证。要使用密钥，请在“设置”中开启“锁定应用”或应用密码。';

  @override
  String get securityExtrasLockWordWindows => 'Windows Hello 或你的应用密码';

  @override
  String get securityExtrasLockWordMac => 'Touch ID 或你的应用密码';

  @override
  String get securityExtrasLockWordOther => 'Face ID 或你的应用密码';

  @override
  String get securityLockImmediately => '立即';

  @override
  String get securityLockAfter30s => '30 秒后';

  @override
  String get securityLockAfter1m => '1 分钟后';

  @override
  String get securityLockAfter5m => '5 分钟后';

  @override
  String get securityNumbersOnly => '只能使用数字。';

  @override
  String securityAtLeastNumbers(int count) {
    return '请至少使用 $count 位数字。';
  }

  @override
  String get securitySameNumber => '不要一直重复同一个数字。';

  @override
  String get securityNumbersInRow => '不要使用 123456 这样的连续数字。';

  @override
  String get securityPanicNeedsPasscode => '请先设置应用密码。紧急抹除会统计输错密码的次数。';

  @override
  String get securityPanicNeedsBackup =>
      '请先做一个备份（“设置”>“导出备份”）。紧急抹除会抹掉所有账号，所以只有在你最近 30 天内做过备份时才能开启。';

  @override
  String get securityKeyDefaultName => '安全密钥';

  @override
  String get securityKeyNotYours => '这个安全密钥不是你在这台设备上添加到 Tanooki Auth 的。';

  @override
  String get securityKeyNotAvailable => '这台设备暂不支持。';

  @override
  String get securityKeyWindowsTooOld =>
      '这个版本的 Windows 暂不支持。请安装最新的 Windows 11 更新。';

  @override
  String get securityKeyIosTooOld => '需要 iOS 26.4 或更新版本。请在“设置”应用中更新后重试。';

  @override
  String get securityKeyMacTooOld => '需要 macOS 26.4 或更新版本。请在“设置”应用中更新后重试。';

  @override
  String get securityKeyDidntWork => '安全密钥没有起作用。请重试。';

  @override
  String securityKeyDidntWorkWhy(String reason) {
    return '安全密钥没有起作用（$reason）。请重试。';
  }

  @override
  String get securityKeyCanceled => '已取消。没有任何更改。';

  @override
  String get securityKeyNoPrf =>
      '这个安全密钥无法用这种方式解锁应用（它没有“hmac-secret”功能）。YubiKey 5 系列和近几年的大多数 FIDO2 密钥都有。';

  @override
  String get securityKeyNotAllowed =>
      '安全密钥没有回应，或者它不是在这里添加的。请插上它（或贴近手机顶部），在它闪烁时触摸。';

  @override
  String get securityKeyNotAssociated =>
      '这个版本的 Tanooki Auth 暂时还不能使用安全密钥：Apple 要求应用先与 auth.tanookistudios.com 关联。这是我们这边的问题，不是你的。';

  @override
  String get securityKeyExists => '这个安全密钥已经添加过了。';

  @override
  String get securityKeyPin => '安全密钥需要 PIN 码，但没有输入。请重试，并在提示时输入密钥的 PIN 码。';

  @override
  String get securityKeyVaultKeyMissing => '解锁你账号的密钥丢失了，所以无法添加安全密钥。';

  @override
  String get securityKeyNoneAdded => '这台设备上没有添加安全密钥。';

  @override
  String get securityKeyBeforeReset => '这个安全密钥是在你的账号被重置之前添加的，所以打不开它们。请移除后重新添加。';

  @override
  String get backupUiChoosePassphrase => '设置备份密码短语';

  @override
  String get backupUiPassphraseTitle => '备份密码短语';

  @override
  String get backupUiPassphraseWarning =>
      '恢复备份时需要它。如果你忘了，任何人都无法找回，包括我们。请把它写下来，放在安全的地方。';

  @override
  String get backupUiPassphrase => '密码短语';

  @override
  String get backupUiTypeAgain => '再输入一次';

  @override
  String get backupUiTooShort => '请至少使用 8 个字符。几个随机的词就很好。';

  @override
  String get backupUiNoMatch => '两次输入的密码短语不一致。';

  @override
  String get backupUiTypePassphrase => '请输入密码短语。';

  @override
  String get backupUiNothingToBackUp => '还没有可备份的账号。';

  @override
  String get backupUiEncrypting => '正在加密备份…';

  @override
  String backupUiSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已保存 $count 个账号的备份。',
    );
    return '$_temp0';
  }

  @override
  String get backupUiNotABackup => '这个文件不是 Tanooki Auth 备份。';

  @override
  String get backupUiUnlocking => '正在解锁备份…';

  @override
  String backupUiImported(int count) {
    return '已导入 $count 个。';
  }

  @override
  String backupUiImportedSkipped(int added, int skipped) {
    return '已导入 $added 个，跳过 $skipped 个。';
  }

  @override
  String backupUiImportedSkippedAlready(int added, int skipped) {
    return '已导入 $added 个，跳过 $skipped 个已在列表中的账号。';
  }

  @override
  String backupUiAdded(int count) {
    return '已添加 $count 个。';
  }

  @override
  String backupUiAddedSkipped(int added, int skipped) {
    return '已添加 $added 个，跳过 $skipped 个。';
  }

  @override
  String backupUiAddedSkippedAlready(int added, int skipped) {
    return '已添加 $added 个，跳过 $skipped 个已在列表中的账号。';
  }

  @override
  String backupUiAlreadyInList(int count) {
    return '• $count 个已在你的列表中';
  }

  @override
  String get backupUiImport => '导入';

  @override
  String backupUiImportFromGoogle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '从 Google Authenticator 导入 $count 个账号？',
    );
    return '$_temp0';
  }

  @override
  String get backupUiGoogleMoreCodes =>
      '如果 Google Authenticator 显示了不止一个二维码，请逐个扫描。';

  @override
  String get backupUiNothingToExport => '还没有可导出的账号。';

  @override
  String get backupUiPlainWhat => '这会把每个设置密钥保存为纯文本，用于迁移到其他验证器应用。';

  @override
  String get backupUiPlainTitle => '导出未加密文件？';

  @override
  String backupUiPlainBody(String what) {
    return '$what任何拿到这个文件的人都能生成你的登录验证码。导入后请立即删除它。如果只是普通备份，请改用“导出备份”。';
  }

  @override
  String get backupUiUnderstandExport => '我明白了，导出';

  @override
  String get backupUiNothingToPrint => '还没有可打印的账号。';

  @override
  String get backupUiPaperTitle => '打印纸质备份？';

  @override
  String get backupUiPaperBody =>
      '这会生成一个 PDF，包含每个账号的二维码以及你未使用的恢复码。任何看到或拍下这张纸的人，都能永久生成你的登录验证码，不需要你的手机或密码。\n\n打印后请删除 PDF。把纸放在上锁的地方，比如保险箱或和重要文件放在一起。不要用邮件发送，也不要保存到共享文件夹。';

  @override
  String get backupUiUnderstandPdf => '我明白了，生成 PDF';

  @override
  String get backupUiMakingPdf => '正在生成 PDF…';

  @override
  String get backupUiPdfReady => 'PDF 已准备好。打印后请删除文件。';

  @override
  String get backupUiWorksTitle => '备份可用';

  @override
  String backupUiWorksBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '这个备份可以正常打开，里面有 $count 个账号。没有添加或更改任何内容。',
    );
    return '$_temp0';
  }

  @override
  String get backupWrongVersion => '这个备份是用更新版本的 Tanooki Auth 制作的。请更新应用后重试。';

  @override
  String get backupWrongPassphrase => '密码短语错误，或者备份文件已损坏。';

  @override
  String get backupDamaged => '备份已解锁，但内容已损坏。';

  @override
  String get paperBackupTitle => 'Tanooki Auth 纸质备份';

  @override
  String paperBackupHeader(String date) {
    return 'Tanooki Auth 纸质备份，$date';
  }

  @override
  String get paperBackupWarning =>
      '请务必保密。任何拿到这张纸的人都能生成你的登录验证码。请放在上锁的地方保管；制作新的备份后把它粉碎。恢复方法：在任意验证器应用中选择“扫描二维码”，逐个扫描下方的码。';

  @override
  String paperBackupSetupKey(String key) {
    return '设置密钥：$key';
  }

  @override
  String get paperBackupRecoveryCodes => '恢复码（每个只能用一次）：';

  @override
  String get autoBackupUiChooseFolderDialog => '选择自动备份的文件夹';

  @override
  String autoBackupUiToday(String time) {
    return '今天 $time';
  }

  @override
  String autoBackupUiYesterday(String time) {
    return '昨天 $time';
  }

  @override
  String autoBackupUiOnDay(String date, String time) {
    return '$date $time';
  }

  @override
  String get autoBackupUiBackingUp => '正在备份…';

  @override
  String autoBackupUiBackedUp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已备份 $count 个账号。',
    );
    return '$_temp0';
  }

  @override
  String get autoBackupUiCouldntUseFolder => '无法使用这个文件夹。';

  @override
  String autoBackupUiCouldntUseFolderWhy(String reason) {
    return '无法使用这个文件夹。$reason';
  }

  @override
  String get autoBackupUiTurnOffTitle => '关闭自动备份？';

  @override
  String get autoBackupUiTurnOffBody =>
      '文件夹中已有的备份会保留。备份密码短语会被清除，所以重新开启时你需要设置一个新的。';

  @override
  String get autoBackupUiTitle => '自动备份';

  @override
  String get autoBackupUiTitlePremium => '自动备份（Premium）';

  @override
  String autoBackupUiIntro(int count) {
    return 'Tanooki Auth 每天会把一份加密备份保存到你选择的文件夹。选择你的 iCloud 云盘、Google 云端硬盘或 Dropbox 文件夹，备份就不只存在这台设备上了。会保留最新的 $count 份，更早的会被删除。\n\n要恢复，请使用“设置”>“导入备份”并输入你的备份密码短语。';
  }

  @override
  String get autoBackupUiLastFailed => '上一次自动备份失败了';

  @override
  String get autoBackupUiChooseFolder => '选择文件夹';

  @override
  String get autoBackupUiBackupFolder => '备份文件夹';

  @override
  String get autoBackupUiNoBackupYet => '还没有备份';

  @override
  String autoBackupUiLastBackup(String when) {
    return '上次备份：$when';
  }

  @override
  String get autoBackupUiBackUpNow => '立即备份';

  @override
  String get autoBackupUiChangeFolder => '更换文件夹';

  @override
  String get autoBackupUiOffSubtitle =>
      '已关闭。每天把加密备份保存到 iCloud 云盘、Google 云端硬盘、Dropbox 或任意文件夹。';

  @override
  String autoBackupUiOnNoBackup(String folder) {
    return '已开启，保存到 $folder。还没有备份。';
  }

  @override
  String autoBackupUiOnLast(String folder, String when) {
    return '已开启，保存到 $folder。上次备份：$when。';
  }

  @override
  String get autoBackupFolderGone =>
      '备份文件夹不见了。它可能已被删除、在应用外被重命名，或者所在的磁盘已拔出。请重新选择文件夹。';

  @override
  String get autoBackupPermissionLost =>
      'Tanooki Auth 不再有写入备份文件夹的权限。请重新选择文件夹以恢复权限。';

  @override
  String get autoBackupDiskFull => '备份文件夹所在的磁盘已满。请释放一些空间，然后点按“立即备份”。';

  @override
  String get autoBackupOther => '无法保存备份。点按“立即备份”重试。';

  @override
  String autoBackupOtherWhy(String reason) {
    return '无法保存备份（$reason）。点按“立即备份”重试。';
  }

  @override
  String get importUiDeleteNote => '完成后请删除导出的文件：任何拿到它的人都能生成你的验证码。';

  @override
  String get importUiStepsAegis =>
      '在你 Android 手机上的 Aegis 中：\n\n1. 点按 ⋮，然后点“设置”，再点“导入和导出”。\n2. 点按“导出”，选择“Aegis (.JSON)”。\n3. 你可以保持“加密保险库”开启；之后在这里输入那个密码即可。\n4. 把文件保存到这台设备能打开的地方（比如 Google 云端硬盘，或者用邮件发给自己）。\n\n然后在这里选择那个文件。';

  @override
  String get importUiStepsTwoFas =>
      '在 2FAS 中：\n\n1. 打开“设置”，然后点“2FAS 备份”。\n2. 点按“导出到文件”。如果它要求设置密码，之后在这里输入同一个密码。\n3. 把 .2fas 文件保存到这台设备能打开的地方。\n\n然后在这里选择那个文件。';

  @override
  String get importUiStepsAuthy =>
      'Authy 没有导出按钮，而且电脑版 Authy 已于 2024 年停止服务。\n\n如果你已经用“authy-export”之类的工具导出了账号，请选择它生成的文件（.json 文件，或包含 otpauth:// 链接的 .txt 列表）。\n\n如果没有，安全的做法是一次迁移一个账号：登录每个网站，关闭再重新开启两步验证登录，然后用 Tanooki Auth 扫描新的二维码。在所有账号都能在这里正常使用之前，请保留 Authy。';

  @override
  String get importUiStepsBitwarden =>
      '在 Bitwarden（网页版或桌面应用）中：\n\n1. 进入“工具”，然后点“导出密码库”。\n2. 选择“.json”或“.csv”。不要选“加密”。\n3. 保存文件。\n\n然后在这里选择那个文件。只有带验证器密钥的登录项会被导入；你的密码会被忽略。';

  @override
  String get importUiStepsOnePassword =>
      '在 Mac 或 Windows 版 1Password 应用中：\n\n1. 点按“文件”，然后点“导出”，再选择你的账户。\n2. 选择“CSV”格式并保存。\n\n然后在这里选择那个文件。只有带一次性密码的项目会被导入；你的密码会被忽略。';

  @override
  String get importUiStepsApple =>
      '这一步需要 Mac；iPhone 无法保存这个文件。\n\n在 macOS Sequoia 或更新版本的 Mac 上：\n1. 打开“密码”应用。\n2. 在菜单栏中点按“文件”，然后点“导出所有密码…”。\n3. 点按“导出密码”，如果要求就输入你的 Mac 密码，然后保存文件。\n\n在较旧的 Mac 上：打开 Safari 浏览器，然后选择 Safari 浏览器 >“设置”>“密码”，点按 ⋯ 按钮，选择“导出所有密码…”。\n\n然后在这里选择那个文件。只有带验证码的项目会被导入；你的密码会被忽略。';

  @override
  String get importUiStepsMicrosoft =>
      'Microsoft Authenticator 无法导出账号，所以不能一次性迁移。\n\n对每个账号：\n1. 在电脑上登录那个网站。\n2. 找到它的安全或两步验证设置。\n3. 关闭再重新开启两步验证登录（或选择“添加新的验证器应用”）。\n4. 用 Tanooki Auth 扫描新的二维码，并输入它显示的验证码来完成设置。\n\n在所有账号都能在 Tanooki Auth 中正常使用之前，请保留 Microsoft Authenticator。你的 Microsoft 账户本身也可以使用 Tanooki Auth：在 account.microsoft.com 的“安全”中添加即可。';

  @override
  String get importUiTitle => '从其他应用迁移';

  @override
  String get importUiCantExport => '无法导出：如何逐个迁移账号';

  @override
  String get importUiFromExportFile => '从导出文件';

  @override
  String importUiMoveFrom(String app) {
    return '从 $app 迁移';
  }

  @override
  String get importUiGotIt => '知道了';

  @override
  String get importUiPickFile => '选择文件';

  @override
  String get importUiCouldntRead => '无法读取这个文件。';

  @override
  String importUiReading(String app) {
    return '正在读取 $app 导出文件…';
  }

  @override
  String get importUiNoAccountsInFile => '这个文件里没有两步验证账号。';

  @override
  String importUiImportFrom(int count, String app) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '从 $app 导入 $count 个账号？',
    );
    return '$_temp0';
  }

  @override
  String importUiExportPassword(String app) {
    return '$app 导出密码';
  }

  @override
  String get importUiPasswordHint => '你导出时设置的密码';

  @override
  String importersNotAnExport(String app) {
    return '这个文件不是 $app 导出文件。';
  }

  @override
  String importersLine(String line, String problem) {
    return '第 $line 行：$problem';
  }

  @override
  String get importersEmpty => '这个文件是空的。';

  @override
  String get importersNotAuthy => '这个文件不是 Authy 导出文件。';

  @override
  String get importersAnAccount => '一个账号';

  @override
  String importersQuoted(String name) {
    return '“$name”';
  }

  @override
  String importersProblemColon(String name, String problem) {
    return '$name：$problem';
  }

  @override
  String importersProblem(String name, String problem) {
    return '$name $problem';
  }

  @override
  String get importersAegisPassword => '这个 Aegis 导出文件有密码保护。';

  @override
  String get importersAegisBiometricOnly =>
      '这个 Aegis 导出文件只能在生成它的手机上用指纹打开。请在 Aegis 中重新导出，并设置一个密码。';

  @override
  String get importersAegisWrongPassword => '这个 Aegis 导出文件的密码不对。';

  @override
  String get importersAegisDamaged => 'Aegis 导出文件已解锁，但内容已损坏。';

  @override
  String get importersNotAegis => '这个文件不是 Aegis 导出文件。';

  @override
  String importersUnsupportedType(String type) {
    return '使用 $type 验证码，Tanooki Auth 不支持';
  }

  @override
  String get importersNotTwoFas => '这个文件不是 2FAS 备份。';

  @override
  String get importersTwoFasPassword => '这个 2FAS 备份有密码保护。';

  @override
  String get importersTwoFasDamaged => '这个 2FAS 备份已损坏。';

  @override
  String get importersTwoFasWrongPassword => '这个 2FAS 备份的密码不对。';

  @override
  String get importersBitwardenEncrypted =>
      '这个 Bitwarden 导出文件是加密的。请在 Bitwarden 中重新导出，并选择“.json”格式（不要选“加密”）。';

  @override
  String get importersOnePux =>
      '这看起来是 1Password 的 .1pux 文件。请在 1Password 中重新导出，并选择 CSV。';

  @override
  String importersNoCodeColumn(String app) {
    return '这个文件没有一次性验证码列，所以它不是包含验证码的 $app 导出文件。';
  }

  @override
  String importersCantReadCode(String reason) {
    return '有一个 Tanooki Auth 无法读取的一次性验证码（$reason）';
  }

  @override
  String get importersNoSecret => '没有密钥';

  @override
  String get importersBadSecret => '的密钥无效';

  @override
  String importersUnsupportedDigits(int count) {
    return '使用 $count 位验证码，Tanooki Auth 不支持';
  }

  @override
  String get importersBadPeriod => '的时间周期有误';

  @override
  String importersUnsupportedAlgorithm(String algorithm) {
    return '使用 $algorithm 算法，Tanooki Auth 不支持';
  }

  @override
  String get exportUiTitle => '迁移到其他应用';

  @override
  String get exportUiAegisLocked => 'Aegis，带密码';

  @override
  String get exportUiAegisLockedSub => '最安全。导入时 Aegis 会要求输入密码。';

  @override
  String get exportUiAegisPlain => 'Aegis，不加密';

  @override
  String get exportUiAegisPlainSub => '适用于能读取 Aegis 文件但打不开加密文件的应用。';

  @override
  String get exportUiTwoFasSub => '不带密码的 .2fas 文件。';

  @override
  String get exportUiGoogleSub => '用 Google Authenticator 扫描的二维码。';

  @override
  String get exportUiLinks => '设置链接（纯文本）';

  @override
  String get exportUiLinksSub => '每行一个 otpauth:// 链接，适用于任何其他应用。';

  @override
  String get exportUiConfirmReason => '导出你的账号';

  @override
  String get exportUiEncryptingAegis => '正在为 Aegis 加密…';

  @override
  String get exportUiAegisPlainWhat => '这会把每个设置密钥保存到一个未加密的 Aegis 文件中。';

  @override
  String get exportUiTwoFasWhat => '这会把每个设置密钥保存到一个不带密码的 2FAS 文件中。';

  @override
  String get exportUiGoogleTitle => '显示用于 Google Authenticator 的二维码？';

  @override
  String get exportUiGoogleBody =>
      '下一个屏幕会显示包含所有设置密钥的二维码。任何看到或拍下它们的人都能生成你的登录验证码。请在私密的地方操作。\n\n在 Google Authenticator 中：点按 +，然后点“扫描二维码”，依次扫描每个码。';

  @override
  String get exportUiShowCodes => '显示二维码';

  @override
  String exportUiExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已导出 $count 个账号。请在另一个应用中导入这个文件，然后删除它。',
    );
    return '$_temp0';
  }

  @override
  String get exportUiNoneForGoogle => '你的账号都无法导入 Google Authenticator。';

  @override
  String get exportUiScanThisCode => '扫描这个码';

  @override
  String exportUiCodeOf(int n, int total) {
    return '第 $n 个，共 $total 个';
  }

  @override
  String get exportUiNextCode => '下一个';

  @override
  String exportUiLeftOut(int count) {
    return '未包含（$count 个）。Google Authenticator 无法生成这些验证码，请把它们添加到其他应用：';
  }

  @override
  String get appIconClassic => '经典';

  @override
  String get appIconPink => '淡粉';

  @override
  String get appIconBlue => '淡蓝';

  @override
  String get appIconLavender => '薰衣草';

  @override
  String get appIconMint => '薄荷';

  @override
  String get appIconMidnight => '午夜';

  @override
  String get appIconSunset => '日落';

  @override
  String get appIconSpooky => '万圣（秋季）';

  @override
  String get appIconCozy => '暖冬（冬季）';

  @override
  String get appIconSpring => '春日';

  @override
  String get serverBrowserExtension => '浏览器扩展';

  @override
  String get serverBadRequest => 'Tanooki Auth 无法理解这个请求。';

  @override
  String get serverLocked => 'Tanooki Auth 已锁定。请解锁后重试。';

  @override
  String get serverNotPaired => '这个应用没有与 Tanooki Auth 配对。';

  @override
  String get serverNotFound => '这个账号已不在 Tanooki Auth 中。';

  @override
  String get serverRateLimited => '请求太多了。';

  @override
  String get serverDenied => '不允许：这个账号需先验证，而 Tanooki Auth 没有为它解锁。';

  @override
  String get serverUnknownScreen => '未知屏幕。';

  @override
  String get serverNoWebsite => '没有提供网站。';

  @override
  String serverUnknownRequest(String type) {
    return '未知请求“$type”。';
  }

  @override
  String get serverPairingTimedOut => '配对超时或已关闭。请重新开始配对。';

  @override
  String get serverThreeWrongCodes => '已输错三次码。请重新开始配对。';

  @override
  String get serverWrongCode => '这个码不匹配。请核对 Tanooki Auth 中显示的码。';

  @override
  String get serverNoLink => '没有收到 otpauth:// 链接。';

  @override
  String get serverAlreadyThere => '这个账号已经在 Tanooki Auth 中了。';

  @override
  String get serverAlreadyThereMany => '这些账号已经在 Tanooki Auth 中了。';

  @override
  String get autoBackupNotSupported => '这台设备不支持';

  @override
  String homeProveCopy(String name) {
    return '复制 $name 的验证码';
  }

  @override
  String homeProveReadAloud(String name) {
    return '朗读 $name 的验证码';
  }

  @override
  String homeProveEdit(String name) {
    return '编辑 $name';
  }

  @override
  String homeProveShare(String name) {
    return '分享 $name';
  }

  @override
  String homeProveRecoveryCodes(String name) {
    return '查看 $name 的恢复码';
  }

  @override
  String homeCopied(String name) {
    return '已复制 $name 的验证码。剪贴板会在 30 秒后清空。';
  }

  @override
  String get homeEditAccount => '编辑账号';

  @override
  String homeShowQrFor(String name) {
    return '显示 $name 的二维码';
  }

  @override
  String homeMovedToTrash(String name) {
    return '已将 $name 移到回收站。30 天内可以在“设置”中恢复。';
  }

  @override
  String get homeUndo => '撤销';

  @override
  String homeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个账号',
    );
    return '$_temp0';
  }

  @override
  String homeAddTagTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '为 $count 个账号添加标签',
    );
    return '$_temp0';
  }

  @override
  String get homeTagHint => '标签（例如 工作）';

  @override
  String get homeAddTag => '添加标签';

  @override
  String homeTagged(int count, String tag) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已为 $count 个账号添加标签“$tag”。',
    );
    return '$_temp0';
  }

  @override
  String homeMoveToFolderTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '把 $count 个账号移到文件夹',
    );
    return '$_temp0';
  }

  @override
  String get homeNoFolder => '无文件夹';

  @override
  String get homeNewFolderHint => '或新建文件夹（例如 工作）';

  @override
  String get homeMoveToNewFolder => '移到新文件夹';

  @override
  String homeTookOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已将 $count 个账号移出文件夹。',
    );
    return '$_temp0';
  }

  @override
  String homeMovedTo(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已将 $count 个账号移到 $folder。',
    );
    return '$_temp0';
  }

  @override
  String homeAddedToFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已收藏 $count 个账号。',
    );
    return '$_temp0';
  }

  @override
  String homeRemovedFromFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已取消收藏 $count 个账号。',
    );
    return '$_temp0';
  }

  @override
  String homeBulkTrashed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已将 $count 个账号移到回收站。30 天内可以在“设置”中恢复。',
    );
    return '$_temp0';
  }

  @override
  String get homeDoneSelecting => '完成选择';

  @override
  String get homeTapToSelect => '点按账号进行选择';

  @override
  String homeSelectedCount(int count) {
    return '已选择 $count 个';
  }

  @override
  String get homeSelectNone => '全不选';

  @override
  String get homeSelectAll => '全选';

  @override
  String get homeAddATag => '添加标签';

  @override
  String get homeMoveToFolder => '移到文件夹';

  @override
  String get homeRemoveFromFavorites => '取消收藏';

  @override
  String get homeAddToFavorites => '收藏';

  @override
  String get homeMoveToTrash => '移到回收站';

  @override
  String get homeSelectFirst => '请先选择一些账号：在列表中点按它们。';

  @override
  String homeSectionOpen(String name, String accounts) {
    return '$name，$accounts，点按可收起';
  }

  @override
  String homeSectionClosed(String name, String accounts) {
    return '$name，$accounts，点按可展开';
  }

  @override
  String get homeSearchHint => '搜索账号或网站…';

  @override
  String get homeAllTags => '全部';

  @override
  String get homeNoAccountsYet => '还没有账号。\n添加一个账号来扫描设置二维码。';

  @override
  String get homeNoTagMatches => '没有带这个标签的账号。';

  @override
  String get homeNoSearchMatches => '没有符合搜索的账号。';

  @override
  String get homeSelectAccounts => '选择账号';

  @override
  String get homeSettings => '设置';

  @override
  String get homeAddAccount => '添加账号';

  @override
  String get homeAccounts => '账号';

  @override
  String get homeYourAccounts => '你的账号';

  @override
  String get homeSelect => '选择';

  @override
  String get homeKeysTouch => '点按（复制）· Enter（复制）· 方向键（切换）';

  @override
  String get homeKeysClick => '点击（复制）· Enter（复制）· 方向键（切换）';

  @override
  String get homePickOnLeft => '在左侧选择一个账号，在这里查看。';

  @override
  String homeQrFor(String name) {
    return '$name 的二维码';
  }

  @override
  String get homeQrWarning =>
      '用另一个验证器应用扫描它，就能在那里添加同一个账号。任何看到或拍下它的人都能生成你的验证码，请注意保密。';

  @override
  String homeVersionNote(Object version) {
    return 'v$version · 只保存在这台设备上';
  }

  @override
  String homeSelectName(String name) {
    return '选择 $name';
  }

  @override
  String get homeMore => '更多';

  @override
  String get homeRecoveryCodes => '恢复码';

  @override
  String homeRecoveryCodesLeft(int count) {
    return '恢复码（剩余 $count 个）';
  }

  @override
  String get homeShareSecurely => '安全分享';

  @override
  String get homeShowQr => '显示二维码';

  @override
  String get homeMoveEarlier => '上移';

  @override
  String get homeMoveLater => '下移';

  @override
  String homeNextCodeShort(String code) {
    return '下一个 $code';
  }

  @override
  String get homeNextCode => '下一个验证码';

  @override
  String get homeFavorite => '收藏';

  @override
  String get homeCodeHiddenAsk => '验证码已隐藏，确认是你本人后显示';

  @override
  String get homeCodeHidden => '验证码已隐藏';

  @override
  String homeNextCodeSpoken(String code) {
    return '下一个验证码 $code';
  }

  @override
  String homeKindTotp(int count, int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位',
    );
    return 'TOTP · $_temp0 · $seconds 秒';
  }

  @override
  String homeKindSteam(int seconds) {
    return 'Steam · 5 个字符 · $seconds 秒';
  }

  @override
  String homeKindHotp(int count, String counter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位',
    );
    return 'HOTP · $_temp0 · #$counter';
  }

  @override
  String get homeAccountHeading => '账号';

  @override
  String get homeHintUnselect => '取消选择';

  @override
  String get homeHintSelect => '选择';

  @override
  String get homeHintCopy => '复制验证码';

  @override
  String get homeReadCodeAloud => '朗读验证码';

  @override
  String get homeMoreOptions => '更多选项';

  @override
  String get mainPairRaycastTitle => '与 Raycast 配对';

  @override
  String get mainPairRaycastBody => '在 Raycast 中输入这个码：';

  @override
  String get mainPairRaycastWarning => '只有在你刚刚亲自在 Raycast 中开始配对时才这样做。';

  @override
  String get mainPairAlfredTitle => '与 Alfred 配对';

  @override
  String get mainPairAlfredBody => '在 Alfred 中输入 2fa-pair 和这个码：';

  @override
  String get mainPairAlfredWarning => '只有在你刚刚亲自在 Alfred 中输入了 2fa-pair 时才这样做。';

  @override
  String get mainPairPowerToysTitle => '与 PowerToys 配对';

  @override
  String get mainPairPowerToysBody => '在 PowerToys 命令面板中输入这个码：';

  @override
  String get mainPairPowerToysWarning => '只有在你刚刚亲自在 PowerToys 中开始配对时才这样做。';

  @override
  String get mainPairBrowserTitle => '与你的浏览器配对';

  @override
  String get mainPairBrowserBody => '在 Tanooki Auth 浏览器扩展中输入这个码：';

  @override
  String get mainPairBrowserWarning => '只有在你刚刚亲自在扩展中点击了“配对”时才这样做。';

  @override
  String mainSendCodeTo(String name, String client) {
    return '把 $name 的验证码发送到 $client';
  }

  @override
  String mainWrongPasscodeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '密码错误。再输错 $count 次将抹除所有内容。',
    );
    return '$_temp0';
  }

  @override
  String get mainWrongPasscode => '密码错误。';

  @override
  String get mainBiometricWindows => 'Windows Hello';

  @override
  String get mainBiometricMac => 'Touch ID';

  @override
  String get mainBiometricOther => 'Face ID 或指纹';

  @override
  String get mainLockTitle => '锁定 Tanooki Auth？';

  @override
  String get mainLockBody =>
      '打开应用时验证你的面容、指纹或密码，这样拿着你已解锁手机的人也看不到你的验证码。以后可以在“设置”中更改。';

  @override
  String get mainTurnOnLock => '开启锁定';

  @override
  String get mainUnlockReason => '解锁 Tanooki Auth';

  @override
  String get mainStartOverTitle => '新建一个空的保险库？';

  @override
  String get mainStartOverBody =>
      '这会永久替换你旧账号剩下的所有内容。只有在你没有可恢复的备份，或者已经在那些网站上关闭了两步验证登录时，才这样做。';

  @override
  String get mainEraseStartOver => '抹除并重新开始';

  @override
  String get mainRestoreFromBackup => '从备份恢复';

  @override
  String get mainStartNewVault => '新建一个空的保险库';

  @override
  String get mainLocked => 'Tanooki Auth 已锁定';

  @override
  String mainUseBiometric(String method) {
    return '使用$method';
  }

  @override
  String get mainUseSecurityKey => '使用安全密钥';

  @override
  String homeHidesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 秒后隐藏',
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
  String get homeCardsDenied => '已拒绝。对方无法打开你的账号。对方以后还可以再次申请，到时会再询问你。';

  @override
  String get homeCardsClockRight => '你的时钟现在是准的。验证码应该可以用了。';

  @override
  String get homeCardsCheckAgain => '再检查一次';

  @override
  String get homeCardsYourContact => '你的紧急联系人';

  @override
  String homeCardsEmergencyWaiting(String who, String left, String day) {
    return '$who申请了对你账号的紧急访问。除非你拒绝，对方将在 $left后（$day）可以打开副本。';
  }

  @override
  String homeCardsEmergencyReleased(String who) {
    return '$who申请了紧急访问，且 7 天等待期已结束，所以对方现在可以打开你账号的副本。点“拒绝”可阻止。';
  }

  @override
  String get homeCardsBackupNudge => '自上次备份以来，你的账号有了变化。如果这台设备丢了，备份文件是找回账号的办法。';

  @override
  String get homeCardsBackUpNow => '立即备份';

  @override
  String homeCardsSummaryNew(int count, String month) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '你的$month摘要：新增 $count 个账号。',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryNoBackup => '还没有备份。';

  @override
  String homeCardsSummaryLastBackup(String day) {
    return '上次备份：$day。';
  }

  @override
  String get homeCardsSummaryAllCodes => '每个账号都有恢复码。';

  @override
  String homeCardsSummaryMissingCodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 个账号没有恢复码。',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryCheckupGood => '安全检查：一切正常。';

  @override
  String homeCardsSummaryCheckupFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '安全检查：有 $count 项需要修复。',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsOpenCheckup => '打开安全检查';

  @override
  String get quickPickSelf =>
      'Tanooki Auth 仍在最前面，所以没有输入任何内容。请点击你要填写的输入框，然后再次使用菜单栏图标。';

  @override
  String quickPickTypeFailed(String reason) {
    return '无法输入验证码（$reason）。请改为复制。';
  }

  @override
  String get quickPickTypeUnavailable => '这台电脑不支持输入验证码。请改为复制。';

  @override
  String quickPickUseCodeFor(String name) {
    return '使用 $name 的验证码';
  }

  @override
  String get quickPickAllowTitle => '允许 Tanooki Auth 输入';

  @override
  String get quickPickAllowBody =>
      '要把验证码输入到另一个应用，你的 Mac 需要允许 Tanooki Auth 替你按键。\n\n1. 点按下方的“打开系统设置”。\n2. 你会看到一个名为“辅助功能”的列表。找到 Tanooki Auth，打开它的开关（变成蓝色）。\n3. 如果 Mac 要求输入密码或使用 Touch ID，照做即可。\n4. 回到这里，再点一次“输入”。\n\nTanooki Auth 只在你点按“输入”时才按键，并且只输入验证码。';

  @override
  String get quickPickOpenSystemSettings => '打开系统设置';

  @override
  String get quickPickTitle => '快速选取';

  @override
  String get quickPickSearch => '搜索账号';

  @override
  String get quickPickLinuxNote => 'Linux 上无法把验证码输入到其他应用。点击账号即可复制它的验证码。';

  @override
  String get quickPickNoMatches => '没有匹配的账号';

  @override
  String get quickPickAsksFirst => '••• •••（需先验证）';

  @override
  String get quickPickHiddenAsks => '验证码已隐藏，需先验证';

  @override
  String get quickPickType => '输入';

  @override
  String get codeViewRing => '圆环';

  @override
  String get codeViewBar => '进度条';

  @override
  String get codeViewNumber => '数字';

  @override
  String codeViewSpoken(String code) {
    return '验证码 $code';
  }

  @override
  String codeViewSpokenLeft(int count, String code) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '验证码 $code，剩余 $count 秒',
    );
    return '$_temp0';
  }

  @override
  String get codeViewReadAloud => '朗读验证码';

  @override
  String codeViewSecondsShort(int count) {
    return '$count秒';
  }

  @override
  String get codeViewColorBlue => '蓝色';

  @override
  String get codeViewColorPurple => '紫色';

  @override
  String get codeViewColorPink => '粉色';

  @override
  String get codeViewColorRed => '红色';

  @override
  String get codeViewColorOrange => '橙色';

  @override
  String get codeViewColorGold => '金色';

  @override
  String get codeViewColorGreen => '绿色';

  @override
  String get codeViewColorTeal => '青色';

  @override
  String get codeViewColorGray => '灰色';

  @override
  String trashRestored(String name) {
    return '$name 已回到你的列表中。';
  }

  @override
  String trashDeleteTitle(String name) {
    return '永久删除 $name？';
  }

  @override
  String get trashDeleteBody =>
      '此操作无法撤销。删除前，请先在那个网站上关闭两步验证登录，或者确认你有它的恢复码，否则你可能会被锁在外面。';

  @override
  String get trashDeleteForGood => '永久删除';

  @override
  String get trashTitle => '回收站';

  @override
  String get trashEmpty => '回收站是空的。\n已删除的账号会在这里保留 30 天。';

  @override
  String get trashNote => '已删除的账号会在这里保留 30 天，之后会被永久移除。';

  @override
  String get trashRemovedNextOpen => '下次打开应用时移除';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '剩余 $count 天',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => '恢复';

  @override
  String get recoveryAddTitle => '添加恢复码';

  @override
  String get recoveryPasteHint => '粘贴网站给你的码，每行一个';

  @override
  String get recoveryNoneNew => '你粘贴的内容里没有找到新的码。';

  @override
  String recoveryAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已添加 $count 个码。',
    );
    return '$_temp0';
  }

  @override
  String get recoveryCopiedUsed => '已复制。注意：你已把这个码标记为已使用，它很可能用不了了。';

  @override
  String get recoveryCopied => '已复制。剪贴板会在 30 秒后清空。登录后请把它标记为已使用。';

  @override
  String get recoveryRemoveTitle => '移除这个码？';

  @override
  String recoveryRemoveBody(String code) {
    return '$code\n\n只有在网站不再接受它时才移除。';
  }

  @override
  String recoveryTitle(String name) {
    return '$name 的恢复码';
  }

  @override
  String get recoveryAddCodes => '添加恢复码';

  @override
  String get recoveryIntro =>
      '开启两步验证登录时，大多数网站还会给你一组备用码。万一你丢了这个应用，每个码都能让你登录一次。把它们粘贴到这里，和账号一起安全保存。';

  @override
  String recoveryUnusedOf(String unused, int total) {
    return '$total 个中有 $unused 个未使用。点按一个码即可复制，用过后请勾选它。';
  }

  @override
  String get recoveryUsed => '已使用';

  @override
  String get detailsEditAccount => '编辑账号';

  @override
  String get detailsCopyCode => '复制验证码';

  @override
  String get detailsReadAloud => '朗读';

  @override
  String get detailsFolderAndTags => '文件夹和标签';

  @override
  String get detailsWebsites => '网站';

  @override
  String get detailsNotes => '备注';

  @override
  String get detailsNotesHidden => '确认是你本人后显示。';

  @override
  String get detailsNoNotes => '没有备注。可以通过“编辑”添加。';

  @override
  String get accountSortCustom => '自定义（拖动排列）';

  @override
  String get accountSortRecent => '最近使用';

  @override
  String get accountSortName => 'A 到 Z';

  @override
  String get activityCopied => '已复制';

  @override
  String get activityFilled => '已填写';

  @override
  String get activityTyped => '已输入';

  @override
  String get activityShownQr => '已显示二维码';

  @override
  String get activityExported => '已导出';

  @override
  String get activityPlaceThisApp => '本应用';

  @override
  String get activityPlaceBackupFile => '备份文件';

  @override
  String get activityPlaceSetupLinks => '设置链接文件';

  @override
  String get activityPlacePaperBackup => '纸质备份 PDF';

  @override
  String get activityPlaceGoogleQr => 'Google Authenticator 二维码';

  @override
  String totpBadCharacter(String char) {
    return '不是有效的 base32 密钥（无效字符“$char”）';
  }

  @override
  String get totpEmpty => '密钥为空';

  @override
  String get vaultFileMissing => '你的账号文件不见了。如果你有备份，请恢复它。否则可以新建一个空的保险库。';

  @override
  String get vaultKeyMissing => '这台设备的安全存储中缺少解锁你账号的密钥。请恢复备份来找回你的账号。';

  @override
  String get vaultDecryptFailed => '无法解锁你的账号文件。它可能已损坏，或在应用外被更改过。请恢复备份。';

  @override
  String get vaultBadJson => '你的账号文件已解锁，但内容已损坏。请恢复备份。';

  @override
  String clockCheckBadAnswer(String status) {
    return '时间服务器返回了应用无法理解的回应（HTTP $status）。';
  }

  @override
  String clockCheckOff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '你的设备时钟偏差约 $count 分钟，所以验证码用不了。请在“设置”中开启自动设置时间。',
    );
    return '$_temp0';
  }

  @override
  String backupUiBullet(String item) {
    return '• $item';
  }

  @override
  String backupUiAccountWithLabel(String title, String label) {
    return '$title（$label）';
  }

  @override
  String exportUiLeftOutLine(String account, String reason) {
    return '• $account：$reason';
  }

  @override
  String get keysTitle => '键盘快捷键';

  @override
  String get keysWhere => '在账号列表和快速选取中可用。';

  @override
  String get keysMove => '在列表中上下移动';

  @override
  String get keysEnter => 'Enter';

  @override
  String get keysCopy => '复制高亮的验证码';

  @override
  String get keysAnyLetter => '任意字母';

  @override
  String get keysSearch => '开始搜索';

  @override
  String get keysEsc => 'Esc';

  @override
  String get keysClear => '清除搜索';

  @override
  String get keysShowList => '显示这个列表';

  @override
  String get settingsKeysShortcutMac => '在任何地方按 ⌘/ 即可查看';

  @override
  String get settingsKeysShortcutOther => '在任何地方按 Ctrl+/ 即可查看';

  @override
  String trayTooltip(String name, int seconds) {
    return 'Tanooki Auth：$name，剩余 $seconds 秒';
  }

  @override
  String get settingsTrayCountdownMac => '在菜单栏显示倒计时';

  @override
  String get settingsTrayCountdownMacHelp => '在菜单栏图标旁显示第一个收藏账号的剩余秒数。绝不显示验证码本身。';

  @override
  String get settingsTrayCountdownWindows => '在托盘图标上显示倒计时';

  @override
  String get settingsTrayCountdownWindowsHelp =>
      '把鼠标指向时钟旁的 Tanooki Auth 图标，就能看到第一个收藏账号还剩几秒。绝不显示验证码本身。';

  @override
  String get unusedTitle => '从不使用的账号';

  @override
  String get settingsUnusedHelp => '6 个月或更久没有复制过验证码';

  @override
  String get unusedIntro =>
      '这些账号在这个应用里已经 6 个月或更久没有复制过验证码了。如果你不再使用那个网站，请先在那里关闭两步验证登录，再在这里整理它们。回收站会保留它们 30 天。';

  @override
  String get unusedNone => '每个账号在最近 6 个月内都用过。没什么需要整理的。';

  @override
  String unusedLastUsed(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '上次使用：$dateString';
  }

  @override
  String unusedNeverUsed(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '从未在这里使用。添加于 $dateString';
  }

  @override
  String get unusedPickFirst => '请先勾选一个或多个账号。';

  @override
  String get unusedTagSuggestion => '未使用';

  @override
  String checkupUnusedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 个从不使用的账号',
    );
    return '$_temp0';
  }

  @override
  String get checkupUnusedBody => '6 个月或更久没有复制过验证码。被遗忘的旧账号一旦被入侵，很容易被忽略。';

  @override
  String get checkupUnusedReview => '查看';

  @override
  String get halvesTitle => '分成两半的纸质备份';

  @override
  String get settingsHalvesHelp => '两组页面。单独任何一半都不会泄露任何信息';

  @override
  String get halvesRestoreTitle => '从两半恢复';

  @override
  String get settingsHalvesRestoreHelp => '扫描纸质备份两半上的码';

  @override
  String get halvesExplain =>
      '这会把你的加密备份打印成两组单独的页面：A 半和 B 半。\n\n单独任何一半都只是随机乱码：即使有你的密码短语，也没人能从中得到任何信息。要恢复，你需要两半加上密码短语。\n\n请把两半放在两个不同的地方，比如一半放在家里，一半交给你信任的人。';

  @override
  String get halvesHalfA => 'A 半（共 2 半）';

  @override
  String get halvesHalfB => 'B 半（共 2 半）';

  @override
  String halvesPart(String which, int part, int parts) {
    return '$which 半 · 第 $part 部分，共 $parts 部分';
  }

  @override
  String halvesPdfHeader(String date) {
    return 'Tanooki Auth 纸质备份，制作于 $date';
  }

  @override
  String get halvesPdfExplain =>
      '单独这一半没有用。恢复方法：在 Tanooki Auth 中打开“设置”>“从两半恢复”，扫描两半上的每个码，然后输入备份密码短语。请把两半放在不同的地方。';

  @override
  String halvesPdfPage(String half, int page, int pages) {
    return '$half，第 $page 页，共 $pages 页';
  }

  @override
  String get halvesNowB => '现在保存 B 半';

  @override
  String get halvesNowBBody => 'A 半已保存。B 半是另一半：也把它打印出来，放在别的地方。';

  @override
  String get halvesSaveB => '保存 B 半';

  @override
  String get halvesOnlyA => '只保存了 A 半。单独 A 半什么也恢复不了，所以准备好后请重新制作两半。';

  @override
  String get halvesReady => '两半都准备好了。把它们打印出来，放在不同的地方。';

  @override
  String get halvesRestoreIntro => '扫描两半上的每个码，顺序不限。两半都完成后，输入你制作备份时设置的密码短语。';

  @override
  String halvesNotStarted(String half) {
    return '$half：还没有扫描任何码';
  }

  @override
  String halvesProgress(String half, int have, int total) {
    return '$half：$have/$total 个码';
  }

  @override
  String get halvesScan => '扫描码';

  @override
  String get halvesScanTitle => '扫描两半';

  @override
  String get halvesPictures => '打开码的图片';

  @override
  String halvesSomeUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有 $count 张图片里没有本应用能读取的码。请对着单个码拍得更近一点。',
    );
    return '$_temp0';
  }

  @override
  String get halvesNotAHalf => '这不是两半纸质备份上的码。';

  @override
  String get halvesOtherSet => '这个码属于另一份纸质备份。请使用同一次打印的两半。';

  @override
  String get halvesAlreadyHave => '这个已经扫描过了。继续扫描下一个码。';

  @override
  String get halvesDontFit => '这两半对不上。可能某个码读错了，或者两半来自不同的备份。请重新开始扫描。';

  @override
  String get halvesRestoreNow => '两半都已扫描：开始恢复';

  @override
  String get healthTitle => '健康检查';

  @override
  String get settingsHealthHelp => '同步、备份、时钟、锁定和恢复码，一屏查看';

  @override
  String get healthIntro => '绿色表示正常。黄色值得看一下，点它的按钮即可修复。';

  @override
  String get healthGood => '正常';

  @override
  String get healthLook => '值得看一下';

  @override
  String get healthSync => '同步';

  @override
  String get healthSyncOff => '未设置。同步让你所有设备上的账号保持一致。';

  @override
  String healthSyncOk(String when) {
    return '上次同步：$when';
  }

  @override
  String healthSyncStale(String when) {
    return '上次同步：$when。已经有一段时间了：打开“同步”看看哪里出了问题。';
  }

  @override
  String get healthOpenSync => '打开同步';

  @override
  String get healthSetUp => '设置';

  @override
  String get healthOpen => '打开';

  @override
  String get healthBackup => '备份';

  @override
  String get healthBackupNever => '还没有备份。如果这台设备丢了，你的账号也会跟着丢。';

  @override
  String healthBackupOk(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '上次备份：$dateString';
  }

  @override
  String healthBackupOld(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '上次备份：$dateString。已经超过 30 天了：请重新备份一次。';
  }

  @override
  String get healthClock => '时钟';

  @override
  String get healthClockNotChecked => '还没有检查。只有这台设备的时钟准确，验证码才能用。';

  @override
  String healthClockOk(String when) {
    return '你的时钟是准的（检查于 $when）。';
  }

  @override
  String get healthCheckNow => '立即检查';

  @override
  String get healthPhoneLink => '手机连接';

  @override
  String healthPhoneLinkOk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已与 $count 个浏览器配对',
    );
    return '$_temp0';
  }

  @override
  String get healthPhoneLinkOff => '未配对。配对你电脑上的浏览器，就能在这部手机上批准登录验证码。';

  @override
  String get healthLock => '锁定';

  @override
  String get healthLockOn => '已开启。显示验证码前，应用会确认你的身份。';

  @override
  String get healthLockOff => '已关闭。任何拿起这台设备的人都能看到你的验证码。';

  @override
  String get healthGoToSettings => '前往锁定开关';

  @override
  String get healthRecovery => '恢复码';

  @override
  String healthRecoveryCount(int count, int total) {
    return '$total 个账号中有 $count 个保存了恢复码。';
  }

  @override
  String get healthRecoveryNoAccounts => '还没有账号。';

  @override
  String get healthAddCodes => '添加恢复码';

  @override
  String get syncErrorWiped =>
      '另一台设备抹除了这台设备上的 Tanooki Auth。上面的所有内容都已删除，并且已退出同步。';

  @override
  String get syncUiEraseDevice => '抹除这台设备';

  @override
  String get syncUiEraseTitle => '抹除这台设备？';

  @override
  String get syncUiEraseBody =>
      '那台设备下次联网时，上面的 Tanooki Auth 会删除所有内容：账号、设置、小组件和搜索条目。它也会永久退出同步。此操作无法撤销。这台设备和你的其他设备不会有任何变化。';

  @override
  String get syncUiEraseButton => '抹除';

  @override
  String get syncUiErased => '完成。那台设备下次联网时会自行抹除。';

  @override
  String syncUiClashes(int count) {
    return '同步冲突（$count）';
  }

  @override
  String get syncUiClashesHelp => '有账号在同步前在两台设备上被更改了。请选择保留哪个版本。';

  @override
  String get syncUiClashTitle => '同步冲突';

  @override
  String get syncUiClashIntro =>
      '下面每个账号都在同步前在两台设备上被更改过。同步采用了较晚的更改。如果你想要的是另一个版本，请点按它下方的“保留这个”。';

  @override
  String get syncUiClashNone => '没有冲突。无需选择。';

  @override
  String get syncUiClashInUse => '当前使用';

  @override
  String get syncUiClashOther => '另一个版本';

  @override
  String get syncUiClashKeep => '保留这个';

  @override
  String get syncUiClashKept => '完成。你的其他设备下次同步时会得到这个版本。';

  @override
  String syncUiClashEdited(String when) {
    return '更改时间：$when';
  }

  @override
  String get syncUiClashName => '名称';

  @override
  String get syncUiClashAccount => '账号';

  @override
  String get syncUiClashFolder => '文件夹';

  @override
  String get syncUiClashNotes => '备注';

  @override
  String get syncUiClashInTrash => '在回收站中';

  @override
  String get syncUiClashSecret => '设置密钥';

  @override
  String get syncUiClashSecretDifferent => '不同';

  @override
  String get syncUiClashYes => '是';

  @override
  String get syncUiClashNo => '否';

  @override
  String get syncUiClashOtherDiffers => '其他设置也有不同，比如外观、网站或恢复码。';

  @override
  String get teamRoleAdmin => '管理员';

  @override
  String get teamRoleMember => '成员';

  @override
  String get teamRoleViewer => '仅查看';

  @override
  String get teamRoleOwner => '所有者';

  @override
  String get teamUiMakeAdmin => '设为管理员';

  @override
  String get teamUiMakeMember => '设为成员';

  @override
  String get teamUiMakeViewer => '设为仅查看';

  @override
  String get teamUiRoleChanged => '角色已更改。';

  @override
  String get teamUiInviteRole => '对方加入后的角色';

  @override
  String get teamUiRoleHelp =>
      '管理员可以邀请和移除成员，并查看活动日志。成员可以使用和更改团队账号。仅查看的人可以使用账号，但不能更改。';

  @override
  String get teamUiInviteEmailLabel => '对方的邮箱（可选）';

  @override
  String get teamUiInviteEmailHint => 'name@example.com';

  @override
  String get teamUiInviteMake => '生成邀请';

  @override
  String teamUiInviteEmailed(String email) {
    return '邀请已发送到 $email。';
  }

  @override
  String get teamUiEmailNotSetUp => '邮件发送还没有设置好。请复制下方的链接，自己发给对方。';

  @override
  String teamUiEmailFailed(String reason) {
    return '邮件没有发出去（$reason）。请复制下方的链接，自己发给对方。';
  }

  @override
  String get teamUiYoureAdmin => '你是这个团队的管理员';

  @override
  String get teamUiYoureViewer => '你在一个团队中（仅查看）';

  @override
  String get teamUiViewOnly => '你可以使用这些账号，但只有管理员和成员能更改它们。';

  @override
  String get teamUiActivity => '活动';

  @override
  String get teamUiActivityTitle => '团队活动';

  @override
  String get teamUiActivityHelp =>
      '谁在什么时候复制或更改了团队账号。只有管理员能看到。保留 90 天，最多保留最近 2,000 条。';

  @override
  String get teamUiActivityEmpty => '暂无记录。复制和更改团队账号都会显示在这里。';

  @override
  String teamActCopy(String name) {
    return '复制了 $name 的验证码';
  }

  @override
  String teamActFill(String name) {
    return '填写了 $name 的验证码';
  }

  @override
  String teamActAdd(String name) {
    return '添加了 $name';
  }

  @override
  String teamActEdit(String name) {
    return '更改了 $name';
  }

  @override
  String teamActDelete(String name) {
    return '移除了 $name';
  }

  @override
  String get teamUiBuyBusiness => '商业方案：每人每年 \$3';

  @override
  String get teamUiBusinessSoon => '适合 10 人以上团队的商业方案（每人每年 \$3）：即将推出。';

  @override
  String themeCustom(int n) {
    return '我的主题 $n';
  }

  @override
  String get themeMakeOwn => '自己制作';

  @override
  String get themeMakeOwnPremium => '自己制作主题，Premium';

  @override
  String get themeEditOwn => '编辑这个主题';

  @override
  String get themeEditorTitle => '你的主题';

  @override
  String get themeEditorAccent => '强调色';

  @override
  String get themeEditorBackground => '背景';

  @override
  String get themeEditorCard => '卡片';

  @override
  String get themeEditorText => '文字';

  @override
  String get themeEditorHue => '色相';

  @override
  String themeEditorSwatch(String hex) {
    return '颜色 $hex';
  }

  @override
  String get themeEditorPreview => '预览';

  @override
  String get themeEditorSample => '示例账号';

  @override
  String get themeEditorSampleHint => '点按复制';

  @override
  String get themeEditorSave => '保存主题';

  @override
  String get themeEditorDelete => '删除主题';

  @override
  String get themeEditorAdjusted => '部分颜色已调整，让文字和按钮保持清晰易读。';

  @override
  String get themeEditorUnreadable => '这些颜色没法调得清晰易读。请试试和背景更接近的卡片颜色。';

  @override
  String get themeEditorFull => '你已经有 3 个主题了。删除一个才能再制作。';

  @override
  String get settingsSeasonal => '随季节变换';

  @override
  String get settingsSeasonalPremium => '随季节变换（Premium）';

  @override
  String get settingsSeasonalHelp => '秋季用万圣，冬季用暖冬，春季用春日；夏季用你自己选的。应季应用图标也会随之更换。';

  @override
  String get helpNew040a => '在 iPhone 和 Android 上用自动填充输入验证码。';

  @override
  String get helpNew040b => '把二维码图片分享到应用即可添加账户。在 Mac 上拖到窗口里就行。';

  @override
  String get helpNew040c => '电脑上可用方向键、回车和快捷键列表(⌘/ 或 Ctrl+/),菜单栏还会显示倒计时。';

  @override
  String get helpNew040d => '找出从不使用的账户,并把纸质备份分成两半打印。';

  @override
  String get helpNew040e => '新增“健康检查”页面。';

  @override
  String get helpNew040f => '从另一台设备抹掉丢失的设备,并处理同步冲突。';

  @override
  String get helpNew040g => '团队角色、团队活动记录、邮件邀请,以及商业版方案(即将推出)。';

  @override
  String get helpNew040h => '自定义主题、季节主题,以及 Apple Watch 智能叠放小组件。';

  @override
  String get helpNew040i => '新增五种语言:葡萄牙语、意大利语、韩语、中文和荷兰语。';
}
