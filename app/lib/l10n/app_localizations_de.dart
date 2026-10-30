// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRemove => 'Entfernen';

  @override
  String get commonUnlock => 'Entsperren';

  @override
  String get commonTurnOff => 'Ausschalten';

  @override
  String get commonNotNow => 'Nicht jetzt';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonDone => 'Fertig';

  @override
  String get commonDeny => 'Ablehnen';

  @override
  String get commonAllow => 'Erlauben';

  @override
  String get commonTryAgain => 'Erneut versuchen';

  @override
  String get commonStop => 'Stoppen';

  @override
  String get commonShare => 'Teilen';

  @override
  String get commonOpen => 'Öffnen';

  @override
  String get commonCopy => 'Kopieren';

  @override
  String get commonContinueLabel => 'Weiter';

  @override
  String get commonClear => 'Leeren';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonYes => 'Ja';

  @override
  String get commonNo => 'Nein';

  @override
  String get commonSeePremium => 'Premium ansehen';

  @override
  String get commonPremiumBadge => 'Premium';

  @override
  String get commonAppName => 'Tanooki Auth';

  @override
  String get googleMigrationUnreadable =>
      'Dieser Google Authenticator-Code konnte nicht gelesen werden.';

  @override
  String get googleMigrationDamaged =>
      'Dieser Google Authenticator-Code ist beschädigt.';

  @override
  String get googleMigrationEmpty =>
      'Dieser Google Authenticator-Code enthält keine Konten.';

  @override
  String get googleMigrationNoSecret =>
      'Ein Konto in diesem Code hat keinen geheimen Schlüssel.';

  @override
  String get googleMigrationMd5 =>
      'Ein Konto in diesem Code nutzt MD5, das Tanooki Auth nicht unterstützt.';

  @override
  String get googleCantTakeSteam => 'Steam-Codes';

  @override
  String googleCantTakeDigits(int digits) {
    return '$digits-stellige Codes';
  }

  @override
  String googleCantTakePeriod(int seconds) {
    return 'Codes, die sich alle $seconds Sekunden ändern';
  }

  @override
  String get otpauthNotALink => 'Das ist kein otpauth://-Link.';

  @override
  String get otpauthNoSecret => 'Der Link enthält keinen geheimen Schlüssel.';

  @override
  String otpauthUnsupportedType(String type) {
    return 'Nicht unterstützter Codetyp „$type“.';
  }

  @override
  String otpauthUnsupportedAlgorithm(String algorithm) {
    return 'Nicht unterstützter Algorithmus „$algorithm“.';
  }

  @override
  String get otpauthBadDigits => 'Die Stellenzahl muss 6, 7 oder 8 sein.';

  @override
  String get otpauthBadPeriod => 'Das Intervall muss eine positive Zahl sein.';

  @override
  String get otpauthBadCounter => 'Der Zähler muss null oder größer sein.';

  @override
  String get phoneLinkNotAPairingCode =>
      'Das ist kein Tanooki Auth-Kopplungscode für den Browser.';

  @override
  String phoneLinkNotSavedFor(String host) {
    return 'Dieses Konto ist nicht für $host gespeichert.';
  }

  @override
  String get phoneLinkPushNotSetUp =>
      'Benachrichtigungen sind auf dem Tanooki Auth-Server noch nicht eingerichtet, daher erscheinen Anfragen nur, solange die App offen ist.';

  @override
  String phoneLinkPushFailed(int status) {
    return 'Benachrichtigungen konnten nicht eingeschaltet werden (HTTP $status).';
  }

  @override
  String get qrImageNotAPicture =>
      'Diese Datei ist kein Bild, das die App lesen kann.';

  @override
  String get qrImageNoQr => 'In diesem Bild wurde kein QR-Code gefunden.';

  @override
  String relayBadAnswer(int status) {
    return 'Der Sync-Server hat eine Antwort geschickt, die die App nicht versteht (HTTP $status).';
  }

  @override
  String get relayUnreachable =>
      'Der Sync-Server ist nicht erreichbar. Prüfe deine Internetverbindung.';

  @override
  String get relayTimeout =>
      'Der Sync-Server hat nicht rechtzeitig geantwortet. Prüfe deine Internetverbindung.';

  @override
  String get relayInsecure =>
      'Es konnte keine sichere Verbindung zum Sync-Server hergestellt werden.';

  @override
  String relaySaidNo(int status) {
    return 'Der Sync-Server hat abgelehnt (HTTP $status).';
  }

  @override
  String get shareNotAShare => 'Das ist kein geteiltes Tanooki Auth-Konto.';

  @override
  String get shareExpired =>
      'Diese Freigabe ist abgelaufen (sie gilt nur 24 Stunden). Bitte um eine neue.';

  @override
  String get shareWrongCode =>
      'Falscher Code oder die Freigabe ist beschädigt. Prüfe die 6 Ziffern und versuch es noch mal.';

  @override
  String get storeServerUnreachable =>
      'Der Tanooki Auth-Server ist nicht erreichbar. Prüfe deine Internetverbindung und versuch es noch mal.';

  @override
  String get storeBadKey =>
      'Der Server hat einen Lizenzschlüssel geschickt, den diese App nicht annimmt.';

  @override
  String storeReportedProblem(String problem) {
    return 'Der Store hat ein Problem gemeldet: $problem';
  }

  @override
  String get storeGooglePlayUnavailable =>
      'Google Play ist auf diesem Gerät nicht verfügbar, daher kann Premium hier nicht gekauft werden. Wenn du Premium woanders gekauft hast, gib unten deinen Lizenzschlüssel ein.';

  @override
  String get storeAppStoreUnavailable =>
      'Der App Store ist gerade nicht verfügbar. Prüfe deine Internetverbindung und versuch es noch mal.';

  @override
  String storeNotListed(String store) {
    return 'Der $store hat Premium gerade nicht angezeigt. Versuch es gleich noch mal.';
  }

  @override
  String storeNotListedWithError(String store, String problem) {
    return 'Der $store hat Premium gerade nicht angezeigt ($problem). Versuch es gleich noch mal.';
  }

  @override
  String storePricesFailed(String problem) {
    return 'Preise konnten nicht aus dem Store geladen werden: $problem';
  }

  @override
  String storePurchaseCouldNotStart(String problem) {
    return 'Der Kauf konnte nicht starten: $problem';
  }

  @override
  String storeNothingToRestore(String store) {
    return 'Für dieses $store-Konto wurde kein Premium-Kauf gefunden.';
  }

  @override
  String storeRestoreFailed(String problem) {
    return 'Käufe konnten nicht wiederhergestellt werden: $problem';
  }

  @override
  String get storePending =>
      'Warte auf die Freigabe der Zahlung. Premium wird freigeschaltet, sobald sie da ist.';

  @override
  String get storeCanceled => 'Kauf abgebrochen. Dir wurde nichts berechnet.';

  @override
  String storeFailed(String problem) {
    return 'Der Kauf hat nicht geklappt: $problem. Dir wurde nichts berechnet.';
  }

  @override
  String get storeFailedNoReason =>
      'Der Kauf hat nicht geklappt: Der Store hat keinen Grund genannt. Dir wurde nichts berechnet.';

  @override
  String get storeUnlocked =>
      'Premium ist freigeschaltet. Vielen, vielen Dank!';

  @override
  String get storeUnlockedWithKey =>
      'Premium ist freigeschaltet. Deinen Lizenzschlüssel für deine Computer findest du unten.';

  @override
  String storeUnlockedKeyFailed(String problem) {
    return 'Premium ist auf diesem Gerät freigeschaltet. Der Schlüssel für deine Computer konnte noch nicht erstellt werden: $problem Tippe später auf „Käufe wiederherstellen“, um es noch mal zu versuchen.';
  }

  @override
  String storeServerSaidNo(int status) {
    return 'Der Server hat abgelehnt (HTTP $status).';
  }

  @override
  String get syncGroupExists =>
      'Eine Sync-Gruppe mit dieser Passphrase gibt es schon. Tippe auf einem Gerät, das schon synchronisiert, auf „Gerät hinzufügen“ und scanne dessen Code.';

  @override
  String get syncNotASyncCode =>
      'Das ist kein Tanooki Auth-Sync-Code. Öffne auf einem Gerät, das schon synchronisiert, Einstellungen > Sync > Gerät hinzufügen.';

  @override
  String get syncWrongPassphrase =>
      'Diese Passphrase passt nicht zu der deiner anderen Geräte. Prüfe sie und versuch es noch mal.';

  @override
  String get syncICloudOtherPassphrase =>
      'Deine anderen Apple-Geräte synchronisieren mit einer anderen Passphrase. Gib diese ein oder fang mit dieser hier neu an.';

  @override
  String get syncErrorRemoved =>
      'Dieses Gerät wurde auf einem anderen Gerät aus dem Sync entfernt. Schalte Sync aus und wieder ein, um wieder beizutreten.';

  @override
  String get syncErrorTurnedOff =>
      'Sync wurde auf einem anderen Gerät ausgeschaltet. Schalte es hier auch aus und dann wieder ein, um neu anzufangen.';

  @override
  String get syncErrorTooOften =>
      'Zu viele Synchronisierungen. In ein paar Minuten wird es erneut versucht.';

  @override
  String get syncErrorLimit =>
      'Du hast das Sync-Limit erreicht (2.000 Konten, gelöschte mitgezählt).';

  @override
  String syncErrorICloud(String problem) {
    return 'iCloud Drive hatte ein Problem: $problem.';
  }

  @override
  String syncErrorUnexpected(String problem) {
    return 'Sync wurde wegen eines unerwarteten Problems gestoppt: $problem';
  }

  @override
  String get syncICloudAppleOnly =>
      'iCloud funktioniert nur auf iPhone, iPad und Mac.';

  @override
  String get syncICloudSignedOut =>
      'iCloud Drive ist auf diesem Gerät aus. Melde dich bei iCloud an und schalte iCloud Drive in den Einstellungen ein, um es zu nutzen.';

  @override
  String get syncICloudNotInBuild =>
      'iCloud-Sync ist in dieser Version von Tanooki Auth noch nicht eingeschaltet. Nutze vorerst das Tanooki-Relay; es funktioniert auf jedem Gerät.';

  @override
  String get teamKeyUnopenable =>
      'Der an dieses Gerät gesendete Team-Schlüssel ließ sich nicht öffnen. Bitte den Team-Admin, dieses Gerät zu entfernen und neu einzuladen.';

  @override
  String get teamNotAnInvite =>
      'Das ist keine Tanooki Auth-Team-Einladung. Bitte den Team-Admin um einen neuen Einladungslink oder QR-Code.';

  @override
  String get teamNotInTeam => 'Dieses Gerät ist in keinem Team.';

  @override
  String get teamDeletedByAdmin => 'Dieses Team wurde vom Admin gelöscht.';

  @override
  String get teamDeviceRemoved => 'Dieses Gerät wurde aus dem Team entfernt.';

  @override
  String get teamAlreadyInTeam => 'Dieses Gerät ist schon in einem Team.';

  @override
  String get teamNotALicense =>
      'Das ist keine Team-Lizenz. Sie beginnt mit TT1. und steht auf der Seite, die Stripe nach dem Abo anzeigt.';

  @override
  String get teamAlreadyInTeamLeaveFirst =>
      'Dieses Gerät ist schon in einem Team. Verlass es zuerst.';

  @override
  String get teamGone =>
      'Dieses Team gibt es nicht mehr. Bitte den Team-Admin um eine neue Einladung.';

  @override
  String get teamInviteUsed =>
      'Diese Einladung wurde schon benutzt oder ist abgelaufen (sie gilt 7 Tage und funktioniert einmal). Bitte den Team-Admin um eine neue.';

  @override
  String get teamFull =>
      'Dieses Team ist voll (10 Personen). Der Admin muss zuerst jemanden entfernen.';

  @override
  String get aboutTitle => 'Über Maddie';

  @override
  String get aboutP1 =>
      'Ich bin Maddie, eine autistische Entwicklerin, der es wichtig ist, vielleicht ein bisschen zu wichtig, die kleinen Dinge richtig zu machen.';

  @override
  String get aboutP2 =>
      'Privatsphäre ist mir sehr wichtig. Die Schlüssel, die deine Konten schützen, sind so persönlich, wie Daten nur sein können. Deshalb speichert Tanooki Auth sie verschlüsselt auf deinem eigenen Gerät. Kein Konto, keine Werbung, kein Tracking, und nichts wird je an mich gesendet.';

  @override
  String get aboutP3 =>
      'Tanooki Auth ist kostenlos, und das soll so bleiben. Deine Unterstützung ermöglicht mir, weiter kostenlose Datenschutz-Apps wie diese zu machen. Wenn dir Tanooki Auth gefällt, gefallen dir vielleicht auch die anderen – sie sind auf madilynthomas.com.';

  @override
  String get aboutP4 =>
      'Also, von mir an dich: danke. Du nutzt nicht einfach nur eine App – du machst diese ganze Art zu leben möglich.';

  @override
  String get aboutSupportAddress =>
      'Unterstütze meine Arbeit: tanookistudios.com/support';

  @override
  String get aboutSupport => 'Unterstütze meine Arbeit';

  @override
  String get aboutCredits => 'Danksagungen';

  @override
  String get aboutCreditsBody =>
      'QR-Codes werden in der Browser-Erweiterung mit jsQR (Apache 2.0) und in der App mit ZXing gelesen. Nicht mit Google, Twilio oder Authy verbunden; Google Authenticator ist eine Marke von Google LLC.';

  @override
  String get addFromBrowserOne => 'Aus deinem Browser hinzufügen?';

  @override
  String addFromBrowserMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten aus deinem Browser hinzufügen?',
      one: '1 Konto aus deinem Browser hinzufügen?',
    );
    return '$_temp0';
  }

  @override
  String get addFromGoogleTransfer =>
      'Aus einem Google Authenticator-Übertragungscode:';

  @override
  String addCount(int count) {
    return '$count hinzufügen';
  }

  @override
  String get addNoColor => 'Keine Farbe';

  @override
  String addColorName(String name) {
    return 'Farbe $name';
  }

  @override
  String get addServiceLabel => 'Dienst (z. B. GitHub)';

  @override
  String get addAccountLabel => 'Konto (z. B. deine E-Mail)';

  @override
  String get addWebsiteLabel => 'Website (optional)';

  @override
  String get addWebsiteHelp =>
      'z. B. github.com. Die Browser-Erweiterung füllt Codes nur hier aus.';

  @override
  String get addTagsLabel => 'Tags (optional)';

  @override
  String get addTagsHelp => 'z. B. Arbeit, Spiele. Mit Kommas trennen.';

  @override
  String get addFolderLabel => 'Ordner (optional)';

  @override
  String get addFolderHelp => 'z. B. Arbeit. Leer lassen für keinen Ordner.';

  @override
  String get addPickFolder => 'Ordner auswählen';

  @override
  String get addNoFolder => 'Kein Ordner';

  @override
  String get addNotesLabel => 'Notizen (optional)';

  @override
  String get addColorLabel => 'Farbe (optional)';

  @override
  String get addEmojiLabel => 'Emoji (optional)';

  @override
  String get addEmojiHelp =>
      'Wird statt des Logos angezeigt, hier, in Widgets und auf der Uhr.';

  @override
  String addUseEmoji(String emoji) {
    return '$emoji verwenden';
  }

  @override
  String addRequireAuth(String proof) {
    return 'Vor dem Anzeigen dieses Codes nach $proof fragen';
  }

  @override
  String get addRequireAuthHelp =>
      'Der Code bleibt in der Liste verborgen, und Widgets, die Uhr und die Schnellauswahl zeigen ihn nie.';

  @override
  String get addTravelHide => 'Im Reisemodus ausblenden';

  @override
  String get addTravelHidePremium => 'Im Reisemodus ausblenden (Premium)';

  @override
  String get addTravelHideHelp =>
      'Wenn der Reisemodus an ist (Einstellungen), verschwindet dieses Konto aus der App, bis du ihn ausschaltest.';

  @override
  String get addTravelNeedsPremium =>
      'Der Reisemodus gehört zu Premium. Hol ihn dir unter Einstellungen > Premium holen.';

  @override
  String get addAdvanced => 'Erweitert';

  @override
  String get addAdvancedExisting =>
      'Ändere das nur, wenn die Website es dir gesagt hat. Falsche Einstellungen ergeben falsche Codes, und die Website lehnt sie ab.';

  @override
  String get addAdvancedNew =>
      'Die meisten Websites nutzen die normalen Einstellungen. Ändere sie nur, wenn die Website es dir gesagt hat.';

  @override
  String get addType => 'Typ';

  @override
  String get addTypeTotp => 'Zeitbasiert (normal)';

  @override
  String get addTypeHotp => 'Zählerbasiert (neuer Code auf Anfrage)';

  @override
  String get addDigits => 'Stellen';

  @override
  String get addAlgorithm => 'Algorithmus';

  @override
  String get addSha1Normal => 'SHA-1 (normal)';

  @override
  String get addPeriod => 'Neuer Code alle';

  @override
  String addSeconds(int seconds) {
    return '$seconds Sekunden';
  }

  @override
  String get addCounter => 'Zähler';

  @override
  String get addCounterHelp => 'Wie viele Codes bisher benutzt wurden';

  @override
  String get addNotASharedFile =>
      'Diese Datei ist kein geteiltes Tanooki Auth-Konto. Bitte die Person, es noch einmal zu teilen.';

  @override
  String addAlreadyInList(String name) {
    return '$name ist schon in deiner Liste.';
  }

  @override
  String get addThisAccount => 'Dieses Konto hinzufügen?';

  @override
  String get addNoCameraWindows =>
      'Unter Windows kann Tanooki Auth keine Kamera nutzen. Öffne stattdessen ein Bild des QR-Codes oder füge den Einrichtungslink ein.';

  @override
  String get addFromGoogle => 'Von Google Authenticator umziehen';

  @override
  String get addFromGoogleSteps =>
      'Auf dem Gerät mit Google Authenticator:\n\n1. Öffne Google Authenticator.\n2. Tippe auf das Menü (☰ oder ⋮), dann auf „Konten übertragen“ und dann auf „Konten exportieren“.\n3. Wähle die Konten aus und tippe auf Weiter. Ein QR-Code erscheint.\n\nScanne dann diesen QR-Code hier. Wenn mehrere QR-Codes erscheinen, scanne jeden davon.';

  @override
  String get addScan => 'Scannen';

  @override
  String get addOpenPicture => 'Bild öffnen';

  @override
  String get addLookingOnScreen =>
      'Suche nach einem QR-Code auf deinem Bildschirm…';

  @override
  String get addScreenNoQr =>
      'Auf deinem Bildschirm wurde kein QR-Code gefunden. Achte darauf, dass der ganze Code zu sehen ist und kein anderes Fenster ihn verdeckt, und versuch es noch mal.';

  @override
  String get addScreenUnsupported =>
      'Zum Scannen des Bildschirms brauchst du macOS 14 (Sonoma) oder neuer. Mach stattdessen ein Bildschirmfoto und nutze „Bild öffnen“.';

  @override
  String get addScreenFailed =>
      'Der Bildschirm konnte nicht aufgenommen werden. Mach stattdessen ein Bildschirmfoto und nutze „Bild öffnen“.';

  @override
  String get addScreenWrongQr =>
      'Auf deinem Bildschirm ist ein QR-Code, aber kein Einrichtungscode für die Zwei-Faktor-Anmeldung.';

  @override
  String get addScreenPermissionTitle =>
      'Tanooki Auth deinen Bildschirm sehen lassen';

  @override
  String get addScreenPermissionSteps =>
      'Damit ein QR-Code vom Bildschirm gelesen werden kann, muss dein Mac Tanooki Auth erlauben, ein Bild davon zu machen. Tanooki Auth schaut nur hin, wenn du auf „Meinen Bildschirm scannen“ drückst, und das Bild verlässt diesen Mac nie.\n\n1. Öffne die Systemeinstellungen (das Zahnrad im Dock oder Apple-Menü > Systemeinstellungen).\n2. Klicke links auf „Datenschutz & Sicherheit“.\n3. Klicke auf „Bildschirm- & Systemaudioaufnahme“.\n4. Schalte den Schalter neben Tanooki Auth ein. Fehlt es in der Liste, klicke auf +, wähle Tanooki Auth unter Programme und schalte es ein.\n5. Dein Mac fragt, ob Tanooki Auth beendet werden soll. Klicke auf „Beenden & erneut öffnen“ und drücke dann noch mal auf „Meinen Bildschirm scannen“.';

  @override
  String get addPasteLinksTitle => 'Einrichtungslinks einfügen';

  @override
  String get addPasteLinksHint =>
      'otpauth://totp/...\nEin Link pro Zeile. Du kannst viele auf einmal einfügen.';

  @override
  String addManyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten hinzufügen?',
      one: '1 Konto hinzufügen?',
    );
    return '$_temp0';
  }

  @override
  String addManyBadLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Zeilen sind nicht verwendbar; welche, siehst du danach.',
      one: '1 Zeile ist nicht verwendbar; welche, siehst du danach.',
    );
    return '$_temp0';
  }

  @override
  String get addEnterKey => 'Einrichtungsschlüssel eingeben';

  @override
  String get addSetupKey => 'Einrichtungsschlüssel';

  @override
  String get addSetupKeyHelp =>
      'Die Buchstaben und Zahlen, die die Website zeigt';

  @override
  String get addBadKey =>
      'Dieser Einrichtungsschlüssel ist ungültig. Er darf nur die Buchstaben A–Z und die Zahlen 2–7 enthalten.';

  @override
  String get addTitle => 'Konto hinzufügen';

  @override
  String get addScanQr => 'QR-Code scannen';

  @override
  String get addScanQrHelp =>
      'Richte die Kamera auf den Code, den die Website zeigt';

  @override
  String addNoCameraOn(String platform) {
    return 'Keine Kamera-Unterstützung unter $platform';
  }

  @override
  String get addScanScreen => 'Meinen Bildschirm scannen';

  @override
  String get addScanScreenHelp =>
      'Liest einen QR-Code, der irgendwo auf deinem Bildschirm zu sehen ist';

  @override
  String get addScanScreenLinux =>
      'Unter Linux noch nicht verfügbar. Öffne stattdessen ein Bildschirmfoto des QR-Codes.';

  @override
  String get addFromPhotos => 'QR-Code aus deinen Fotos scannen';

  @override
  String get addFromPicture => 'Bild eines QR-Codes öffnen';

  @override
  String get addFromPhotosHelp =>
      'Wähle ein Bildschirmfoto der Einrichtungsseite';

  @override
  String get addFromPictureHelp =>
      'Ein Bildschirmfoto der Einrichtungsseite reicht';

  @override
  String get addPasteLink => 'Einrichtungslink einfügen';

  @override
  String get addPasteLinkHelp =>
      'Links, die mit otpauth:// beginnen, einer oder viele';

  @override
  String get addOpenShared => 'Geteiltes Konto öffnen';

  @override
  String addOpenSharedHelp(String extension) {
    return 'Eine .$extension-Datei, die dir jemand geschickt hat';
  }

  @override
  String get addFromGoogleHelp => 'Hol alle deine Konten auf einmal rüber';

  @override
  String get addFromOtherApp => 'Von einer anderen App umziehen';

  @override
  String get addFromOtherAppHelp =>
      'Aegis, 2FAS, Authy, Bitwarden, 1Password, Apple Passwörter, Microsoft';

  @override
  String get addEnterKeyHelp =>
      'Gib den Schlüssel ein, der unter „Code kann nicht gescannt werden?“ steht';

  @override
  String get addWrongQr =>
      'Dieser QR-Code ist kein Einrichtungscode für die Zwei-Faktor-Anmeldung.';

  @override
  String get addCameraDenied =>
      'Tanooki Auth darf die Kamera nicht nutzen. Erlaube Tanooki Auth den Kamerazugriff in den Einstellungen deines Geräts, oder geh zurück und nutze ein Bild oder den Einrichtungsschlüssel.';

  @override
  String addCameraFailed(String problem) {
    return 'Die Kamera konnte nicht starten ($problem). Geh zurück und nutze stattdessen ein Bild oder den Einrichtungsschlüssel.';
  }

  @override
  String get helpNew030a =>
      'Schritt-für-Schritt-Anleitungen zum Einschalten von 2FA bei 40 beliebten Websites. Wenn du ein Konto hinzufügst oder bearbeitest, für das es eine Anleitung gibt, findest du einen Link dazu.';

  @override
  String get helpNew030b =>
      'Eine kurze Willkommenstour beim ersten Öffnen der App. Du findest sie wieder unter Einstellungen > Hilfe.';

  @override
  String get helpNew030c =>
      'Sende Feedback unter Einstellungen > Hilfe. Deine Konten und Codes sind nie dabei.';

  @override
  String get helpNew030d => 'Diese Seite „Neuigkeiten“.';

  @override
  String get helpNew030e =>
      'Import aus Apple Passwörter und Umzug deiner Konten zu Aegis, 2FAS oder Google Authenticator.';

  @override
  String get helpNew030f =>
      'Steam Guard-Codes, zählerbasierte Codes mit einer Schaltfläche „Nächster Code“ und erweiterte Code-Einstellungen mit Live-Vorschau.';

  @override
  String get helpNew030g =>
      'Ordner, mehrere Konten auf einmal auswählen, Sortierung von A bis Z oder nach zuletzt benutzt, und „Kontonamen aufräumen“.';

  @override
  String get helpNew030h =>
      'Zeig den QR-Code eines Kontos (nach Face ID oder deinem Code an), um es auf ein anderes Gerät zu übertragen.';

  @override
  String get helpNew030i =>
      'Entsperren mit einem Sicherheitsschlüssel wie einem YubiKey (Premium) auf neueren iPhones, Macs und Windows-PCs.';

  @override
  String get helpNew030j =>
      '„Erst fragen“-Konten, die Face ID oder deinen Code verlangen, bevor der Code erscheint, und ein Reisemodus, der ausgewählte Konten ausblendet (Premium).';

  @override
  String get helpNew030k =>
      'Aktivitätsverlauf (Premium), Uhrzeit-Check „Codes funktionieren nicht?“, Backup testen, Sperren im Ruhezustand und Backup-Erinnerungen.';

  @override
  String get helpNew030l =>
      'Notfallzugang: Lass eine Vertrauensperson deine Konten anfordern, mit ein paar Tagen Zeit für dich, Nein zu sagen.';

  @override
  String get helpNew030m =>
      'Spotlight-Suche, eine Live-Aktivität für den kopierten Code und eine Komplikation fürs Zifferblatt (Premium), Beim Öffnen kopieren und „Nach einmal Einfügen löschen“ auf dem Mac.';

  @override
  String get helpNew030n =>
      'Countdown-Stile, eine Farbe oder ein Emoji pro Konto, Vorlesen, eine gut lesbare Schrift und bessere Unterstützung für Screenreader.';

  @override
  String get helpNew030o =>
      'Ein breites Layout für große Fenster und saisonale Premium-Symbole.';

  @override
  String get helpNew030p =>
      'Kauf Premium direkt in der App auf iPhone und Android, verschenk es und lade Freunde ein.';

  @override
  String get helpNew030q =>
      'Team-Tresor zum Teilen von Codes mit bis zu 10 Personen. Der Team-Tarif selbst kommt bald.';

  @override
  String get helpNew030r => 'Der Familientarif kommt bald.';

  @override
  String get helpNew030s =>
      'Die Desktop-App läuft jetzt auch unter Linux. Linux-Downloads kommen bald.';

  @override
  String get helpNew020a =>
      'Sync zwischen deinen Geräten, Handy-Verknüpfung für die Browser-Erweiterung und sicheres Teilen eines Kontos.';

  @override
  String get helpNew020b =>
      'Code, automatische Sperre, Notfall-Löschung, Täuschungscode, Bildschirmfoto-Sperre, Sicherheitscheck und Warnungen bei Datenlecks.';

  @override
  String get helpNew020c =>
      'Widgets, Apps für Apple Watch und Wear OS, die Mac-Menüleiste und den Windows-Infobereich sowie automatische verschlüsselte Backups (Premium).';

  @override
  String get helpNew020d =>
      'Import aus Aegis, 2FAS, Authy, Bitwarden und 1Password, dazu Favoriten, Tags, Notizen, Wiederherstellungscodes und Papierkorb.';

  @override
  String get helpNew010a =>
      'Die erste Version: Konten scannen oder einfügen, Codes sehen, verschlüsselte Backups und die Browser-Erweiterung.';

  @override
  String helpNoBrowser(String url) {
    return 'Dein Browser konnte nicht geöffnet werden. Die Seite ist $url';
  }

  @override
  String helpGuideFor(String name) {
    return 'So schaltest du 2FA für $name ein';
  }

  @override
  String get helpTourWelcome => 'Willkommen bei Tanooki Auth';

  @override
  String get helpTourWelcomeBody =>
      'Viele Websites können neben deinem Passwort einen 6-stelligen Code verlangen. Das ist die Zwei-Faktor-Authentifizierung, kurz 2FA. Tanooki Auth erzeugt diese Codes für dich, direkt auf deinem Gerät. So kommt niemand rein, der nur dein Passwort hat.';

  @override
  String get helpTourAdd => 'Füge dein erstes Konto hinzu';

  @override
  String get helpTourAddBody =>
      'Schalte 2FA in den Sicherheitseinstellungen einer Website ein. Sie zeigt einen QR-Code: Scanne ihn hier oder kopiere den Einrichtungslink und füge ihn ein. Du nutzt schon eine andere Authenticator-App? Hol deine Konten auf einmal rüber.';

  @override
  String get helpTourScanOrPaste => 'QR-Code scannen oder Link einfügen';

  @override
  String get helpTourImport => 'Aus einer anderen App importieren';

  @override
  String get helpTourPopular =>
      'Beliebte Websites, die du zuerst schützen solltest';

  @override
  String get helpTourPopularBody =>
      'Am wichtigsten sind deine E-Mail, deine sozialen Netzwerke und alles, wo dein Geld liegt. Unsere Schritt-für-Schritt-Anleitungen zeigen, wo die 2FA-Einstellung auf jeder Website ist.';

  @override
  String get helpAllGuides => 'Alle 2FA-Anleitungen';

  @override
  String helpTourStep(int step, int total) {
    return 'Schritt $step von $total';
  }

  @override
  String get helpTourSkip => 'Tour überspringen';

  @override
  String get helpWhatsNew => 'Neuigkeiten';

  @override
  String helpVersion(String version) {
    return 'Version $version';
  }

  @override
  String helpVersionThis(String version) {
    return 'Version $version (diese Version)';
  }

  @override
  String get helpFeedbackEmpty => 'Schreib zuerst eine Nachricht.';

  @override
  String get helpFeedbackSent =>
      'Gesendet. Danke! Maddie liest jede Nachricht.';

  @override
  String get helpFeedbackTooLong =>
      'Das ist zu lang zum Senden. Bitte kürze es (höchstens etwa 4.000 Zeichen).';

  @override
  String get helpFeedbackTooMany =>
      'Du hast in der letzten Stunde viel Feedback gesendet. Bitte versuch es in einer Stunde wieder.';

  @override
  String get helpFeedbackOffline =>
      'Keine Internetverbindung. Prüfe deine Verbindung und versuch es noch mal. Deine Nachricht ist noch da.';

  @override
  String get helpFeedbackServerError =>
      'Der Feedback-Server hatte ein Problem und hat deine Nachricht nicht angenommen. Bitte versuch es später noch mal. Deine Nachricht ist noch da.';

  @override
  String get helpFeedbackTitle => 'Feedback senden';

  @override
  String get helpFeedbackIntro =>
      'Einen Fehler gefunden oder einen Wunsch an die App? Erzähl es Maddie hier.';

  @override
  String get helpFeedbackMessage => 'Deine Nachricht';

  @override
  String get helpFeedbackEmail => 'Deine E-Mail (optional)';

  @override
  String get helpFeedbackEmailHelp => 'Nur wenn du eine Antwort möchtest.';

  @override
  String get helpFeedbackDevice => 'App-Version und Gerätetyp mitsenden';

  @override
  String get helpFeedbackDeviceHelp =>
      'Zum Beispiel „0.3.0“ und „iOS“. Das hilft, Fehler zu finden.';

  @override
  String get helpFeedbackNeverSent =>
      'Nie gesendet: deine Konten, ihre Namen, Codes, Einrichtungsschlüssel, Tags, Notizen oder sonst etwas aus der App.';

  @override
  String get helpFeedbackSend => 'Senden';

  @override
  String get phoneUiPushAndroid =>
      'Benachrichtigungen unter Android sind noch nicht eingerichtet, daher erscheinen Anfragen, solange Tanooki Auth offen ist.';

  @override
  String get phoneUiPushThisDevice =>
      'Dieses Gerät bekommt Anfragen, solange Tanooki Auth offen ist.';

  @override
  String get phoneUiPushNoToken =>
      'Das iPhone hat der App kein Benachrichtigungs-Token gegeben.';

  @override
  String get phoneUiPushDenied =>
      'Benachrichtigungen für Tanooki Auth sind aus. Schalte sie in der Einstellungen-App des iPhones unter „Mitteilungen“ ein, um Anfragen auch bei geschlossener App zu bekommen.';

  @override
  String phoneUiPushFailed(String problem) {
    return 'Benachrichtigungen konnten nicht eingeschaltet werden: $problem. Anfragen erscheinen weiterhin, solange Tanooki Auth offen ist.';
  }

  @override
  String get phoneUiPushNotInBuild =>
      'Benachrichtigungen gibt es in dieser Version nicht. Anfragen erscheinen, solange Tanooki Auth offen ist.';

  @override
  String get phoneUiPushChecking =>
      'Prüfe, ob Benachrichtigungen funktionieren…';

  @override
  String get phoneUiRequest => 'Anfrage für einen Anmeldecode';

  @override
  String get phoneUiNoAccount =>
      'Für diese Website ist kein Konto gespeichert, also gibt es nichts zu senden. Wenn du eins erwartet hast, ist das vielleicht eine gefälschte Seite, die sich als echte ausgibt.';

  @override
  String get phoneUiWantsCode =>
      'Dein gekoppelter Browser möchte den Code für diese Website. Bestätige nur, wenn du dich gerade anmeldest.';

  @override
  String get phoneUiApprove => 'Bestätigen';

  @override
  String phoneUiApproveAccount(String name) {
    return 'Bestätigen: $name';
  }

  @override
  String get phoneUiScanTitle => 'Code des Browsers scannen';

  @override
  String get phoneUiScanWrong =>
      'Das ist kein Kopplungscode für den Browser. Klicke im Browser auf die Tanooki Auth-Erweiterung und dann auf „Stattdessen mein Handy nutzen“.';

  @override
  String get phoneUiPasteTitle => 'Kopplungslink einfügen';

  @override
  String get phoneUiPair => 'Koppeln';

  @override
  String get phoneUiPaired =>
      'Gekoppelt. Wenn dieser Browser nach einem Code fragt, siehst du es hier.';

  @override
  String get phoneUiExpired =>
      'Dieser Code ist abgelaufen. Erstelle im Browser einen neuen und scanne ihn erneut.';

  @override
  String get phoneUiPremium =>
      'Dein Handy mit einem Browser zu nutzen gehört zu Premium';

  @override
  String get phoneUiIntro =>
      'Fülle Codes in einem Browser auf jedem Computer aus, auch ohne die Tanooki Auth-App. Die Browser-Erweiterung fragt, und du tippst hier auf Bestätigen. Codes werden Ende-zu-Ende-verschlüsselt übertragen und nur für die Website, für die das Konto gespeichert ist.';

  @override
  String get phoneUiPairBrowser => 'Browser koppeln';

  @override
  String get phoneUiPairHelp =>
      'Klicke im Browser auf die Tanooki Auth-Erweiterung und dann auf „Stattdessen mein Handy nutzen“, um den Code anzuzeigen.';

  @override
  String get phoneUiPairedBrowsers => 'Gekoppelte Browser';

  @override
  String get phoneUiNoneYet => 'Noch keine';

  @override
  String get phoneUiBrowser => 'Browser';

  @override
  String phoneUiPairedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Gekoppelt am $dateString';
  }

  @override
  String get phoneUiUnpair => 'Entkoppeln';

  @override
  String get phoneUiPushOn => 'Benachrichtigungen an';

  @override
  String get phoneUiPushOff => 'Anfragen erscheinen, solange die App offen ist';

  @override
  String get phoneUiPushOnHelp =>
      'Du bekommst für jede Anfrage eine Benachrichtigung, auch wenn Tanooki Auth geschlossen ist.';

  @override
  String phoneUiSendCodeFor(String name) {
    return 'Code für $name senden';
  }

  @override
  String get phoneUiActivityWhere => 'Browser, über dieses Handy';

  @override
  String get premiumFiveOnce => 'Einmalig 5 \$';

  @override
  String get premiumPayOnce => 'Einmal zahlen';

  @override
  String get premiumCheckoutSoon =>
      'Der Kauf ist noch nicht geöffnet, kommt aber sehr bald. Danke, dass du Tanooki Auth unterstützen möchtest!';

  @override
  String get premiumEnterKeyTitle => 'Lizenzschlüssel eingeben';

  @override
  String get premiumEnterKeyHint => 'TA1.…  (aus deiner Kauf-E-Mail)';

  @override
  String get premiumBadKey =>
      'Dieser Lizenzschlüssel ist ungültig. Kopiere den ganzen Schlüssel aus deiner Kauf-E-Mail und versuch es noch mal.';

  @override
  String premiumInvitesNowFamily(int count) {
    return '$count Freunde haben Premium über deinen Link gekauft, daher ist dein Schlüssel jetzt ein Familienschlüssel für bis zu 5 Personen. Er ist auf diesem Gerät installiert. Kopiere den neuen Schlüssel unten und gib ihn auch auf deinen anderen Geräten ein.';
  }

  @override
  String premiumInvitesAlreadyFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Freunde haben Premium über deinen Link gekauft. Dein Schlüssel ist schon ein Familienschlüssel.',
      one: '1 Freund hat Premium über deinen Link gekauft. Dein Schlüssel ist schon ein Familienschlüssel.',
    );
    return '$_temp0';
  }

  @override
  String premiumInvitesProgress(int count, int needed, int left) {
    return '$count von $needed Freunden haben Premium über deinen Link gekauft. Noch $left, und dein Schlüssel wird ein Familienschlüssel.';
  }

  @override
  String get premiumInviteLinkCopied => 'Einladungslink kopiert.';

  @override
  String get premiumKeyCopied => 'Lizenzschlüssel kopiert.';

  @override
  String premiumJustMe(String price) {
    return 'Nur ich — $price';
  }

  @override
  String premiumFamilyPrice(String price) {
    return 'Familie (bis zu 5 Personen) — $price';
  }

  @override
  String get premiumFamilyApple =>
      'Familie: über die Familienfreigabe mit deiner Apple-Familie geteilt, dazu ein Lizenzschlüssel für bis zu 5 Personen auf jedem Gerät.';

  @override
  String get premiumFamilyKey =>
      'Familie: ein Lizenzschlüssel, den du mit bis zu 4 anderen Personen teilst.';

  @override
  String get premiumYourKey => 'Dein Lizenzschlüssel';

  @override
  String get premiumYourKeyHelp =>
      'Gib ihn auf deinen anderen Geräten ein: Einstellungen → Premium holen → „Schon gekauft? Lizenzschlüssel eingeben“.';

  @override
  String get premiumCopyKey => 'Schlüssel kopieren';

  @override
  String get premiumInviteFriends => 'Freunde einladen';

  @override
  String get premiumInviteHelp =>
      'Freunde bekommen 20 % Rabatt. Wenn 3 Freunde kaufen, wird dein Schlüssel ein Familienschlüssel.';

  @override
  String get premiumGetInvite => 'Meinen Einladungslink holen';

  @override
  String get premiumCheckInvites => 'Meine Einladungen prüfen';

  @override
  String get premiumYouHave => 'Du hast Premium';

  @override
  String get premiumTitle => 'Tanooki Auth Premium';

  @override
  String get premiumOwnedFamily =>
      'Familientarif: Teile deinen Lizenzschlüssel mit bis zu 4 anderen Personen (insgesamt 5). Danke, dass du Tanooki Auth unterstützt.';

  @override
  String get premiumOwnedThanks => 'Danke, dass du Tanooki Auth unterstützt.';

  @override
  String get premiumPitchStripe =>
      'Einmalig 5 \$ oder 10 \$ für deine ganze Familie. Für immer deins.';

  @override
  String get premiumPitchStore =>
      'Einmal für dich zahlen oder einmal für deine ganze Familie. Für immer deins.';

  @override
  String get premiumPerkThemes => 'Alle Premium-Designs';

  @override
  String premiumPerkThemesBody(int count) {
    return 'Pastellrosa, Pastellblau und $count weitere, plus jedes Design, das später dazukommt.';
  }

  @override
  String get premiumPerkIcons => 'App-Symbole';

  @override
  String premiumPerkIconsBody(int count) {
    return 'Wähle auf iPhone und Android ein anderes Home-Bildschirm-Symbol, in Pastellrosa, Pastellblau und $count weiteren Farben, plus saisonale für Herbst, Winter und Frühling. Auf dem Mac ändert sich das Dock-Symbol, solange die App offen ist.';
  }

  @override
  String get premiumPerkSync => 'Sync zwischen deinen Geräten';

  @override
  String get premiumPerkSyncBody =>
      'Füge ein Konto auf einem Gerät hinzu und sieh es auf allen, Ende-zu-Ende-verschlüsselt. Über iCloud auf Apple-Geräten oder über das Tanooki-Relay für jede Kombination.';

  @override
  String get premiumPerkApprove => 'Codes vom Handy aus bestätigen';

  @override
  String get premiumPerkApproveBody =>
      'Nutze die Browser-Erweiterung auf jedem Computer: Sie fragt dein Handy, du tippst auf Bestätigen, und der Code wird eingefüllt.';

  @override
  String get premiumPerkBreach => 'Warnungen bei Datenlecks';

  @override
  String get premiumPerkBreachBody =>
      'Erfahre, wenn eine Website, bei der du ein Konto hast, in einem bekannten Datenleck steckt. Geprüft auf deinem Gerät; nichts über dich wird gesendet.';

  @override
  String get premiumPerkShare => 'Ein Konto sicher teilen';

  @override
  String get premiumPerkShareBody =>
      'Gib einer Vertrauensperson ein Konto per QR-Code und 6-stelligem Code. Verschlüsselt, läuft nach 24 Stunden ab, ohne Server.';

  @override
  String get premiumPerkFamily => 'Familientarif';

  @override
  String get premiumPerkFamilyStripe =>
      'Für 10 \$ statt 5 \$ schaltet ein Schlüssel Premium für bis zu 5 Personen frei. Schick ihn deiner Familie, und sie gibt ihn genauso ein wie du.';

  @override
  String get premiumPerkFamilyStore =>
      'Ein Familienkauf schaltet Premium für bis zu 5 Personen frei. Schick ihnen deinen Lizenzschlüssel, und sie geben ihn genauso ein wie du.';

  @override
  String get premiumPerkFuture => 'Alle künftigen Premium-Funktionen';

  @override
  String get premiumPerkFutureBody =>
      'Einmal zahlen und alles bekommen, was Premium noch wird. Nie ein Abo.';

  @override
  String get premiumPerkFree => 'Hält Datenschutz-Apps kostenlos';

  @override
  String get premiumPerkFreeStripe =>
      'Deine 5 \$ ermöglichen mir, weiter kostenlose Apps zu machen, die dich nicht verfolgen.';

  @override
  String get premiumPerkFreeStore =>
      'Dein Premium-Kauf ermöglicht mir, weiter kostenlose Apps zu machen, die dich nicht verfolgen.';

  @override
  String get premiumFreeForever =>
      'Für immer kostenlos, mit oder ohne Premium: unbegrenzte Konten, Scannen, Backups, die Browser-Erweiterung und die App-Sperre.';

  @override
  String get premiumFamilySoon => 'Familientarif kommt bald';

  @override
  String get premiumFamilyKeyEach =>
      'Familie: ein Lizenzschlüssel, den du mit bis zu 4 anderen Personen teilst. Jede gibt ihn in ihrem eigenen Tanooki Auth ein.';

  @override
  String get premiumRestore => 'Käufe wiederherstellen';

  @override
  String get premiumAlreadyBought => 'Schon gekauft? Lizenzschlüssel eingeben';

  @override
  String get premiumDesktopKeySoon =>
      'Der Computer-Schlüssel für Android-Käufe kommt bald. Premium ist auf diesem Handy schon freigeschaltet; ein Lizenzschlüssel für deine Computer erscheint hier in einem späteren Update.';

  @override
  String premiumGift(String price) {
    return 'Premium verschenken — $price';
  }

  @override
  String premiumGiftFamily(String price) {
    return 'Den Familientarif verschenken — $price';
  }

  @override
  String get premiumGiftHelp =>
      'Nach dem Bezahlen bekommst du eine druckbare Geschenkkarte mit einem Schlüssel für die Person.';

  @override
  String get settingsIconFailed =>
      'Das App-Symbol konnte nicht geändert werden. Versuch es noch mal oder starte die App neu.';

  @override
  String settingsIconFailedWhy(String problem) {
    return 'Das App-Symbol konnte nicht geändert werden ($problem). Versuch es noch mal oder starte die App neu.';
  }

  @override
  String settingsIconSemantic(String name) {
    return 'App-Symbol $name';
  }

  @override
  String settingsIconSemanticPremium(String name) {
    return 'App-Symbol $name, Premium';
  }

  @override
  String get settingsAppIcon => 'App-Symbol';

  @override
  String get settingsAppIconPremium => 'App-Symbol (Premium)';

  @override
  String get settingsAppIconIos => 'Das Symbol auf deinem Home-Bildschirm.';

  @override
  String get settingsAppIconAndroid =>
      'Das Symbol auf deinem Home-Bildschirm. Es kann kurz verschwinden, während dein Handy es austauscht.';

  @override
  String get settingsAppIconMac =>
      'Ändert das Dock-Symbol, solange Tanooki Auth offen ist. Macs können nach dem Beenden kein anderes Symbol behalten, daher zeigen Finder und Launchpad weiter das blaue.';

  @override
  String get settingsAppIconOther =>
      'App-Symbole lassen sich auf iPhone und Android ändern.';

  @override
  String get settingsLockNameMac => 'Touch ID oder dein Mac-Passwort';

  @override
  String get settingsLockNamePhone => 'Face ID, Fingerabdruck oder Code';

  @override
  String settingsNoLockSetUp(String lock) {
    return 'Auf diesem Gerät ist nichts davon eingerichtet ($lock), daher kann die App nicht gesperrt werden. Richte es zuerst in den Systemeinstellungen ein.';
  }

  @override
  String get settingsLockReasonOn => 'App-Sperre einschalten';

  @override
  String get settingsLockReasonOff => 'App-Sperre ausschalten';

  @override
  String get settingsSetPasscode => 'App-Code festlegen';

  @override
  String get settingsSetPasscodeIntro =>
      'Gib ihn ein, um Tanooki Auth zu öffnen. Er funktioniert auch, wenn Face ID oder dein Fingerabdruck nicht klappt. Wenn du ihn vergisst, kommst du nur mit einem Backup wieder rein.';

  @override
  String get settingsPasscodeOn => 'App-Code ist an.';

  @override
  String get settingsPasscode => 'App-Code';

  @override
  String get settingsChangePasscode => 'Code ändern';

  @override
  String get settingsPasscodeOff => 'Code ausschalten';

  @override
  String get settingsNewPasscode => 'Neuer App-Code';

  @override
  String get settingsPasscodeChanged => 'Code geändert.';

  @override
  String get settingsPasscodeIsOff => 'App-Code ist aus.';

  @override
  String get settingsRemoveDecoyTitle => 'Täuschungscode entfernen?';

  @override
  String get settingsRemoveDecoyBody =>
      'Die Täuschungskonten werden gelöscht. Deine echten Konten bleiben unberührt.';

  @override
  String get settingsSetDecoy => 'Täuschungscode festlegen';

  @override
  String get settingsSetDecoyIntro =>
      'Wenn dich jemand zwingt, Tanooki Auth zu öffnen, gib stattdessen diesen ein. Er öffnet einen separaten, leeren Satz Konten, und nichts auf dem Bildschirm verrät, dass es nicht der echte ist. Füge dort ein paar harmlose Konten hinzu, damit er benutzt aussieht.\n\nDein echter Code öffnet weiterhin deine echten Konten.';

  @override
  String get settingsDecoySet => 'Täuschungscode festgelegt.';

  @override
  String settingsWipeTitle(int count) {
    return 'Nach $count falschen Codes alles löschen?';
  }

  @override
  String settingsWipeBody(int count) {
    return 'Wenn jemand den App-Code $count-mal hintereinander falsch eingibt, löscht Tanooki Auth alle Konten auf diesem Gerät. Das lässt sich weder rückgängig machen noch aufhalten, sobald es beginnt.';
  }

  @override
  String get settingsWipeSureTitle => 'Bist du sicher?';

  @override
  String get settingsWipeSureBody =>
      'Ein Kind, das mit deinem Handy spielt, oder du an einem schlechten Tag kann das auslösen. Nach dem Löschen hilft nur noch deine Backup-Datei. Ohne sie könntest du bei jeder Website ausgesperrt sein, die diese Codes nutzt.';

  @override
  String get settingsWipeTurnOn => 'Notfall-Löschung einschalten';

  @override
  String get settingsTravelOffReason => 'Reisemodus ausschalten';

  @override
  String get settingsTravelOnNone =>
      'Reisemodus an, aber noch kein Konto ist mit „Im Reisemodus ausblenden“ markiert. Markiere sie zuerst über ⋯ > Bearbeiten.';

  @override
  String settingsTravelOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reisemodus an. $count Konten sind ausgeblendet.',
      one: 'Reisemodus an. 1 Konto ist ausgeblendet.',
    );
    return '$_temp0';
  }

  @override
  String get settingsTravelOff => 'Reisemodus aus. Alle Konten sind wieder da.';

  @override
  String get settingsCheckingClock => 'Deine Uhrzeit wird geprüft…';

  @override
  String get settingsClockRight =>
      'Deine Uhr geht richtig, daran liegt es also nicht. Prüfe, ob die Einstellungen des Kontos (⋯ > Bearbeiten > Erweitert) zu den Angaben der Website passen.';

  @override
  String settingsClockFailed(String problem) {
    return 'Die Uhrzeit konnte nicht geprüft werden: $problem';
  }

  @override
  String get settingsLockApp => 'App sperren';

  @override
  String settingsLockAppHelp(String lock) {
    return 'Beim Öffnen der App nach $lock fragen';
  }

  @override
  String get settingsPasscodeOnHelp => 'An. Tippe zum Ändern oder Ausschalten.';

  @override
  String settingsPasscodeOffHelp(String lock) {
    return 'Aus. Zahlen, die du zum Öffnen der App eingibst, statt oder zusätzlich zu $lock.';
  }

  @override
  String get settingsLockAgain => 'Wieder sperren';

  @override
  String settingsLockAgainHelp(String time) {
    return '$time im Hintergrund';
  }

  @override
  String get settingsLockFirst =>
      'Schalte zuerst die Sperre oder einen Code ein';

  @override
  String get settingsDecoy => 'Täuschungscode';

  @override
  String get settingsDecoyOn =>
      'An. Öffnet einen separaten Satz Konten. Tippe zum Entfernen.';

  @override
  String get settingsDecoyOff =>
      'Ein zweiter Code, der einen separaten, leeren Satz Konten öffnet';

  @override
  String settingsWipe(int count) {
    return 'Nach $count falschen Codes löschen';
  }

  @override
  String get settingsWipeHelp =>
      'Notfall-Löschung. Braucht ein Backup aus den letzten 30 Tagen.';

  @override
  String get settingsLockOnSleep =>
      'Sperren, wenn der Computer in den Ruhezustand geht';

  @override
  String get settingsLockOnSleepHelp =>
      'Auch wenn der Bildschirm sperrt oder du dich kurz abmeldest';

  @override
  String get settingsLockOnSleepNeedsLock =>
      'Schalte zuerst „App sperren“ oder einen App-Code ein, damit es etwas zu sperren gibt.';

  @override
  String get settingsTravel => 'Reisemodus';

  @override
  String get settingsTravelPremium => 'Reisemodus (Premium)';

  @override
  String get settingsTravelOnHelp =>
      'An. Konten mit „Im Reisemodus ausblenden“ verschwinden von den Bildschirmen, Widgets, der Uhr, der Erweiterung und aus Exporten dieses Geräts, bis du ihn ausschaltest. Sie werden nicht gelöscht.';

  @override
  String settingsTravelOffHelp(String proof) {
    return 'Vor einem Grenzübertritt: blendet die Konten aus, die du mit „Im Reisemodus ausblenden“ markiert hast (⋯ > Bearbeiten). Zum Ausschalten wird nach $proof gefragt.';
  }

  @override
  String get settingsKeys => 'Sicherheitsschlüssel';

  @override
  String get settingsKeysPremium => 'Sicherheitsschlüssel (Premium)';

  @override
  String get settingsKeysHelp =>
      'Mit einem YubiKey oder anderen Sicherheitsschlüssel entsperren';

  @override
  String get settingsActivity => 'Aktivitätsverlauf';

  @override
  String get settingsActivityPremium => 'Aktivitätsverlauf (Premium)';

  @override
  String get settingsActivityHelp =>
      'Welche Codes kopiert, ausgefüllt, getippt oder exportiert wurden und wann. Nur auf diesem Gerät gespeichert.';

  @override
  String get settingsEmergency => 'Notfallzugang';

  @override
  String get settingsEmergencyPremium => 'Notfallzugang (Premium)';

  @override
  String get settingsEmergencyHelp =>
      'Lass eine Vertrauensperson an deine Konten, falls dir etwas passiert, nach einer 7-tägigen Wartezeit, die du stoppen kannst';

  @override
  String get settingsTeamHelp =>
      'Teile Anmeldecodes mit bis zu 10 Personen, Ende-zu-Ende-verschlüsselt';

  @override
  String get settingsMonthly => 'Benachrichtigung zur Monatsübersicht';

  @override
  String get settingsMonthlyPremium =>
      'Benachrichtigung zur Monatsübersicht (Premium)';

  @override
  String get settingsMonthlyHelp =>
      'Eine Erinnerung am 1. jedes Monats, dir deine Übersichtskarte anzusehen. Sie verrät nie etwas über deine Konten.';

  @override
  String get settingsBlockShots => 'Bildschirmfotos blockieren';

  @override
  String get settingsBlockShotsDesktop =>
      'Verbirgt dieses Fenster vor Bildschirmfotos, Bildschirmaufnahmen und Bildschirmfreigaben';

  @override
  String get settingsBlockShotsPhone =>
      'Hält Codes aus Bildschirmfotos, Bildschirmaufnahmen und dem App-Umschalter heraus';

  @override
  String get settingsCheckup => 'Sicherheitscheck';

  @override
  String get settingsCheckupHelp =>
      'Was sich zu beheben lohnt, und dein Wiederherstellungs-Kit';

  @override
  String get settingsBreachPremium => 'Warnungen bei Datenlecks (Premium)';

  @override
  String get settingsBreachOn =>
      'An. Prüft wöchentlich die öffentliche Liste der Datenlecks.';

  @override
  String get settingsBreachOff =>
      'Aus. Wenn an, lädt die App einmal pro Woche die öffentliche Liste der Datenlecks herunter.';

  @override
  String settingsThemeSemantic(String name) {
    return 'Design $name';
  }

  @override
  String settingsThemeSemanticPremium(String name) {
    return 'Design $name, Premium';
  }

  @override
  String get settingsPremiumThanks => 'Premium: Danke!';

  @override
  String get settingsGetPremium => 'Premium holen';

  @override
  String get settingsPremiumThanksHelp =>
      'Alle Designs und künftigen Premium-Funktionen gehören dir.';

  @override
  String settingsGetPremiumHelp(String payOnce) {
    return '$payOnce: alle Designs, Sync zwischen deinen Geräten und mehr.';
  }

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsCountdown => 'Countdown-Stil';

  @override
  String get settingsCountdownHelp =>
      'Wie die verbleibende Zeit jedes Codes angezeigt wird';

  @override
  String get settingsEasyFont => 'Gut lesbare Schrift';

  @override
  String get settingsEasyFontHelp =>
      'Atkinson Hyperlegible, vom Braille Institute entworfen, damit Buchstaben und Zahlen schwer zu verwechseln sind';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsAccountsList => 'Kontenliste';

  @override
  String get settingsCompact => 'Kompakte Karten';

  @override
  String get settingsCompactHelp =>
      'Kleinere Karten, damit mehr Konten auf den Bildschirm passen';

  @override
  String get settingsSort => 'Konten sortieren';

  @override
  String settingsSortHelp(String sort) {
    return '$sort. Favoriten stehen immer oben.';
  }

  @override
  String get settingsSortCustom =>
      'Deine eigene Reihenfolge. Halte eine Karte gedrückt und zieh sie.';

  @override
  String get settingsSortRecent =>
      'Konten, aus denen du gerade einen Code kopiert hast, rutschen nach oben';

  @override
  String get settingsSortName => 'Nach Dienstname';

  @override
  String get settingsTidyHelp =>
      'Macht aus Namen wie „google.com:you@gmail.com“ einfach „Google“. Du siehst jede Änderung vorher.';

  @override
  String get settingsHideCodes => 'Codes bis zum Antippen verbergen';

  @override
  String get settingsHideCodesHelp =>
      'Zeigt Punkte statt Codes, damit Leute in der Nähe sie nicht lesen können';

  @override
  String get settingsShareCodes => 'Codes auf Widgets und Uhr anzeigen';

  @override
  String get settingsShareCodesHelp =>
      'Die Codes deiner Favoriten erscheinen auf dem Home-Bildschirm, dem Sperrbildschirm und der Uhr, ohne diese App zu öffnen. Wer dein entsperrtes Handy oder deine Uhr hält, kann sie also lesen. Markiere ein Konto mit einem Stern, um es zum Favoriten zu machen.';

  @override
  String get settingsTrash => 'Papierkorb';

  @override
  String settingsTrashCount(int count) {
    return 'Papierkorb ($count)';
  }

  @override
  String get settingsTrashHelp => 'Gelöschte Konten bleiben hier 30 Tage lang';

  @override
  String get settingsWatchFace => 'Favorit fürs Zifferblatt';

  @override
  String get settingsWatchFacePremium => 'Favorit fürs Zifferblatt (Premium)';

  @override
  String get settingsWatchFaceNoFavorites =>
      'Markiere zuerst ein Konto in der Hauptliste mit einem Stern. Nur Favoriten können aufs Zifferblatt.';

  @override
  String get settingsNone => 'Keiner';

  @override
  String get settingsCopying => 'Kopieren und Kurzbefehle';

  @override
  String get settingsCopyOnOpen => 'Beim Öffnen kopieren';

  @override
  String get settingsCopyOnOpenHelp =>
      'Beim Öffnen oder Entsperren der App wird der Code des zuletzt benutzten Kontos kopiert. Konten, die vor dem Anzeigen fragen, werden übersprungen.';

  @override
  String get settingsPasteOnce => 'Nach einmal Einfügen löschen';

  @override
  String get settingsPasteOnceHelp =>
      'Der kopierte Code lässt sich einmal einfügen, dann wird die Zwischenablage geleert. Apps mit Zwischenablage-Verlauf können als dieses eine Einfügen zählen. Unter Windows werden Codes stattdessen nach 30 Sekunden gelöscht.';

  @override
  String get settingsSpotlight => 'Konten in Spotlight anzeigen';

  @override
  String get settingsSpotlightHelp =>
      'Such von überall nach dem Namen eines Kontos und spring direkt dorthin. Nur Namen werden geteilt, nie Codes.';

  @override
  String get settingsLiveActivity =>
      'Code auf dem Sperrbildschirm nach dem Kopieren';

  @override
  String get settingsLiveActivityPremium =>
      'Code auf dem Sperrbildschirm nach dem Kopieren (Premium)';

  @override
  String get settingsLiveActivityHelp =>
      'Nachdem du einen Code kopiert hast, erscheint er auf dem Sperrbildschirm und in der Dynamic Island mit einem Countdown bis zum Ablauf.';

  @override
  String get settingsWatchFaceHelp =>
      'Wähle einen Favoriten, dessen Code auf deinem Apple Watch-Zifferblatt erscheint. „Codes auf Widgets und Uhr anzeigen“ muss an sein.';

  @override
  String settingsWatchFaceChosen(String name) {
    return '$name. Füge die Tanooki Auth-Komplikation deinem Zifferblatt hinzu, um ihn zu sehen.';
  }

  @override
  String get settingsBrowserSection => 'Browser-Erweiterung und Launcher';

  @override
  String get settingsBridgeOff => 'Läuft nicht';

  @override
  String get settingsBridgeOn => 'Bereit für die Browser-Erweiterung';

  @override
  String settingsBridgeOffHelp(String first, String last) {
    return 'Die Ports $first–$last sind alle von anderen Programmen belegt, daher kann sich die Erweiterung nicht verbinden. Starte deinen Computer neu und versuch es noch mal.';
  }

  @override
  String settingsBridgeOnHelp(String port) {
    return 'Lauscht nur auf diesem Computer (127.0.0.1:$port). Funktioniert, solange Tanooki Auth offen ist.';
  }

  @override
  String settingsPairedClient(String name) {
    return 'Gekoppelt: $name';
  }

  @override
  String get settingsPairedBrowser => 'Gekoppelter Browser';

  @override
  String settingsExtensionId(String id) {
    return 'Erweiterung $id';
  }

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSecurity => 'Sicherheit';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsExport => 'Backup exportieren';

  @override
  String get settingsExportHelp =>
      'Eine verschlüsselte Datei, gesichert mit einer Passphrase deiner Wahl';

  @override
  String get settingsImport => 'Backup importieren';

  @override
  String get settingsImportHelp =>
      'Fügt Konten aus einer Backup-Datei hinzu; überspringt die, die du schon hast';

  @override
  String get settingsTestBackup => 'Backup testen';

  @override
  String get settingsTestBackupHelp =>
      'Prüft, ob sich eine Backup-Datei mit deiner Passphrase öffnen lässt. Ändert nichts.';

  @override
  String get settingsMoveOut => 'Zu einer anderen App umziehen';

  @override
  String get settingsMoveOutHelp =>
      'Aegis, 2FAS, Google Authenticator oder einfache Einrichtungslinks';

  @override
  String get settingsPaper => 'Papier-Backup drucken';

  @override
  String get settingsPaperHelp =>
      'Ein PDF mit QR-Codes und Wiederherstellungscodes, das du sicher wegschließt';

  @override
  String get settingsHelp => 'Hilfe';

  @override
  String get settingsGuidesHelp =>
      'Schritt-für-Schritt-Hilfe zum Einschalten von 2FA bei beliebten Websites, auf unserer Website';

  @override
  String get settingsTour => 'Willkommenstour zeigen';

  @override
  String get settingsFeedbackHelp =>
      'Erzähl Maddie von einem Fehler oder einer Idee. Deine Konten und Codes sind nie dabei.';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsAboutMaddieHelp =>
      'Ein paar Worte von der Person, die Tanooki Auth macht';

  @override
  String get settingsCodesNotWorking => 'Codes funktionieren nicht?';

  @override
  String settingsCodesNotWorkingHelp(String time) {
    return 'Gerätezeit $time. Codes hängen von der Uhr ab: Tippe, um sie mit dem Internet abzugleichen.';
  }

  @override
  String shareUiConfirmTitle(String name) {
    return '$name teilen?';
  }

  @override
  String get shareUiConfirmBody =>
      'Die Person, mit der du das teilst, bekommt vollen Zugriff: Ihr Handy erzeugt dieselben Codes wie deins, solange sie es behält. Teile es nur mit jemandem, dem du voll vertraust, zum Beispiel deiner Familie.\n\nWenn du es später aus deiner Liste entfernst, hat die Person es trotzdem noch. Um ihr den Zugang zu nehmen, schalte die Zwei-Faktor-Anmeldung auf der Website aus und wieder ein.';

  @override
  String get shareUiConfirmButton => 'Verstanden, teilen';

  @override
  String get shareUiLocking => 'Freigabe wird verschlüsselt…';

  @override
  String shareUiTitle(String name) {
    return '$name teilen';
  }

  @override
  String get shareUiInstructions =>
      'Auf dem anderen Gerät: Tanooki Auth öffnen, auf „Konto hinzufügen“ tippen, dann „QR-Code scannen“ (oder „Geteiltes Konto öffnen“ für die Datei). Danach diesen Code eingeben:';

  @override
  String get shareUiTellCode =>
      'Sag der Person den Code selbst, laut oder über eine andere App als die Datei.';

  @override
  String get shareUiSendFile => 'Lieber als Datei senden';

  @override
  String get shareUiCopyLink => 'Als Link kopieren';

  @override
  String get shareUiCopied =>
      'Kopiert. Die Person fügt ihn mit „Einrichtungslink einfügen“ ein.';

  @override
  String get shareUiWorksFor =>
      'Gilt 24 Stunden und nur mit dem Code. Nichts läuft über einen Server.';

  @override
  String get shareUiOpenTitle => 'Geteiltes Konto';

  @override
  String get shareUiOpenBody =>
      'Gib den 6-stelligen Code ein, den dir die teilende Person gegeben hat.';

  @override
  String get shareUiUnlocking => 'Wird entsperrt…';

  @override
  String get signatureLabel => 'Unterschrieben, Maddie';

  @override
  String get syncUiQrCode => 'QR-Code';

  @override
  String get syncUiNotYet => 'Noch nicht';

  @override
  String get syncUiJustNow => 'Gerade eben';

  @override
  String syncUiMinutesAgo(int minutes) {
    return 'vor $minutes Min.';
  }

  @override
  String syncUiHoursAgo(int hours) {
    return 'vor $hours Std.';
  }

  @override
  String syncUiDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get syncUiThisDevice => 'Dieses Gerät';

  @override
  String get syncUiAnotherDevice => 'Ein anderes Gerät';

  @override
  String syncUiAdded(String when) {
    return 'Hinzugefügt: $when';
  }

  @override
  String syncUiThisDeviceNamed(String name) {
    return 'Dieses Gerät ($name)';
  }

  @override
  String syncUiLastSyncedAgo(String when) {
    return 'Zuletzt synchronisiert: $when';
  }

  @override
  String get syncUiWhere => 'Worüber sollen deine Geräte synchronisieren?';

  @override
  String get syncUiICloudHelp =>
      'Nur für iPhone, iPad und Mac. Nutzt dein eigenes iCloud Drive.';

  @override
  String get syncUiRelay => 'Tanooki-Relay';

  @override
  String get syncUiRelayHelp =>
      'Funktioniert mit jedem Gerät, auch mit Android und Windows. Der Server speichert nur verschlüsselte Daten.';

  @override
  String get syncUiStartFreshTitle => 'Neu anfangen?';

  @override
  String get syncUiStartFreshBody =>
      'Wenn du die Passphrase deiner anderen Apple-Geräte vergessen hast, kannst du mit dieser einen neuen Sync starten. Deine anderen Geräte müssen Sync dann aus- und mit der neuen Passphrase wieder einschalten.';

  @override
  String get syncUiStartFresh => 'Neu anfangen';

  @override
  String get syncUiOn => 'Sync ist an.';

  @override
  String get syncUiScanTitle => 'Sync-Code scannen';

  @override
  String get syncUiScanWrong =>
      'Das ist kein Sync-Code. Öffne auf deinem anderen Gerät Einstellungen > Sync > Gerät hinzufügen.';

  @override
  String get syncUiNowSyncing => 'Dieses Gerät synchronisiert jetzt.';

  @override
  String get syncUiPasteTitle => 'Sync-Link einfügen';

  @override
  String get syncUiPasteHint =>
      'tanookiauth://sync?…  (aus „Gerät hinzufügen“ auf deinem anderen Gerät)';

  @override
  String get syncUiAddApple => 'Apple-Gerät hinzufügen';

  @override
  String get syncUiAddAppleBody =>
      'Öffne auf deinem anderen iPhone, iPad oder Mac (mit derselben Apple-ID angemeldet, iCloud Drive an) Tanooki Auth, geh zu Einstellungen > Sync, tippe auf „Sync einschalten“, wähle iCloud und gib dieselbe Sync-Passphrase ein.\n\nDu willst ein Android-Handy oder einen Windows-PC hinzufügen? Schalte Sync auf allen Geräten aus und dann mit dem Tanooki-Relay wieder ein.';

  @override
  String get syncUiAddDevice => 'Gerät hinzufügen';

  @override
  String get syncUiAddDeviceBody =>
      'Öffne auf dem neuen Gerät Tanooki Auth, geh zu Einstellungen > Sync und tippe auf „Von einem anderen Gerät beitreten“. Scanne diesen Code und gib dort deine Sync-Passphrase ein.';

  @override
  String get syncUiAddDeviceNote =>
      'Funktioniert einmal, 24 Stunden lang. Wer nur diesen Code hat, kann ohne deine Passphrase nichts lesen.';

  @override
  String get syncUiLinkCopied =>
      'Link kopiert. Füge ihn auf dem neuen Gerät ein.';

  @override
  String get syncUiCopyLink => 'Lieber Link kopieren';

  @override
  String get syncUiRemoveTitle => 'Dieses Gerät aus dem Sync entfernen?';

  @override
  String get syncUiRemoveBody =>
      'Es bekommt keine Änderungen mehr. Wenn das Gerät verloren oder gestohlen wurde, ändere auch deine Sync-Passphrase: Schalte Sync auf allen Geräten aus und mit einer neuen Passphrase wieder ein, denn das verlorene Gerät kennt die alte noch.';

  @override
  String get syncUiTurnOffTitle => 'Sync auf diesem Gerät ausschalten?';

  @override
  String get syncUiTurnOffBody =>
      'Deine Konten bleiben auf diesem Gerät. Es sendet und empfängt nur keine Änderungen mehr. Deine anderen Geräte synchronisieren weiter untereinander.';

  @override
  String get syncUiOff => 'Sync ist auf diesem Gerät aus.';

  @override
  String get syncUiPremium => 'Sync gehört zu Premium';

  @override
  String syncUiPremiumBody(String payOnce) {
    return 'Füge ein Konto auf einem Gerät hinzu, und es erscheint auf allen, Ende-zu-Ende-verschlüsselt. $payOnce, kein Abo.';
  }

  @override
  String get syncUiIntro =>
      'Sync hält deine Konten auf all deinen Geräten gleich. Bevor etwas dieses Gerät verlässt, wird es mit deiner Sync-Passphrase verschlüsselt, sodass iCloud oder unser Server nur unlesbare Daten speichern. Niemand sonst kann sie lesen, auch wir nicht.';

  @override
  String get syncUiTurnOn => 'Sync einschalten';

  @override
  String get syncUiJoin => 'Von einem anderen Gerät beitreten';

  @override
  String get syncUiJoinHelp =>
      'Nutze „Beitreten“, wenn ein anderes Gerät schon mit dem Tanooki-Relay synchronisiert.';

  @override
  String get syncUiSyncingRelay => 'Synchronisiert mit dem Tanooki-Relay';

  @override
  String get syncUiSyncingICloud => 'Synchronisiert mit iCloud';

  @override
  String get syncUiSyncingNow => 'Wird synchronisiert…';

  @override
  String syncUiSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count synchronisierte Elemente konnten nicht gelesen werden',
      one: '1 synchronisiertes Element konnte nicht gelesen werden',
    );
    return '$_temp0';
  }

  @override
  String get syncUiSkippedHelp =>
      'Sie wurden vielleicht von jemand anderem geändert oder mit einer anderen Passphrase erstellt. Deswegen wurde nichts gelöscht.';

  @override
  String get syncUiDevices => 'Geräte';

  @override
  String get syncUiLoading => 'Wird geladen…';

  @override
  String get syncUiAddDeviceRelay =>
      'Zeigt einen Code zum Scannen auf dem neuen Gerät';

  @override
  String get syncUiAddDeviceApple => 'Ein weiteres iPhone, iPad oder Mac';

  @override
  String get syncUiTurnOffButton => 'Sync auf diesem Gerät ausschalten';

  @override
  String get syncUiPassphraseNoteRelay =>
      'Deine Sync-Passphrase kann nicht wiederhergestellt werden. Wenn du sie vergisst, schalte Sync auf allen Geräten aus und fang mit einer neuen an. Deine Konten bleiben, wo sie sind.';

  @override
  String get syncUiPassphraseNoteICloud =>
      'Sync nutzt dein iCloud Drive. Deine Sync-Passphrase kann nicht wiederhergestellt werden; wenn du sie vergisst, fang mit einer neuen von vorn an. Deine Konten bleiben, wo sie sind.';

  @override
  String get syncUiTitle => 'Sync';

  @override
  String get syncUiTooShort =>
      'Nimm mindestens 10 Zeichen. Ein paar zufällige Wörter funktionieren gut.';

  @override
  String get syncUiMismatch => 'Die beiden Passphrasen stimmen nicht überein.';

  @override
  String get syncUiChoosePassphrase => 'Sync-Passphrase wählen';

  @override
  String get syncUiTypePassphrase => 'Gib deine Sync-Passphrase ein';

  @override
  String get syncUiChooseHelp =>
      'Du gibst sie einmal auf jedem neuen Gerät ein. Sie verschlüsselt deine Konten, bevor sie dieses Gerät verlassen.\n\nSchreib sie dir an einem sicheren Ort auf. Sie kann weder von dir noch von uns wiederhergestellt oder zurückgesetzt werden.';

  @override
  String get syncUiTypeHelp =>
      'Dieselbe Passphrase, die du beim Einschalten von Sync auf deinem ersten Gerät gewählt hast.';

  @override
  String get syncUiPassphrase => 'Sync-Passphrase';

  @override
  String get syncUiTypeAgain => 'Noch einmal eingeben';

  @override
  String get syncUiSectionTitle => 'Sync und Handy';

  @override
  String get syncUiTitlePremium => 'Sync (Premium)';

  @override
  String get syncUiOnRelay => 'An, mit dem Tanooki-Relay';

  @override
  String get syncUiOnICloud => 'An, mit iCloud';

  @override
  String get syncUiOffHelp => 'Halte deine Konten auf allen Geräten gleich';

  @override
  String get syncUiBrowser => 'Mit einem Browser nutzen';

  @override
  String get syncUiBrowserPremium => 'Mit einem Browser nutzen (Premium)';

  @override
  String get syncUiBrowserHelp =>
      'Bestätige auf diesem Handy Codes für einen Browser auf jedem Computer';

  @override
  String get teamUiCreateTitle => 'Erstelle dein Team';

  @override
  String get teamUiCreateHint =>
      'TT1.…  (von der Seite nach dem Abschluss des Abos)';

  @override
  String get teamUiCreateButton => 'Team erstellen';

  @override
  String get teamUiReady =>
      'Dein Team ist bereit. Lade Leute mit „Jemanden einladen“ ein.';

  @override
  String get teamUiScanTitle => 'Team-Einladung scannen';

  @override
  String get teamUiScanWrong =>
      'Das ist keine Team-Einladung. Bitte den Team-Admin, Einstellungen > Team-Tresor > Jemanden einladen zu öffnen.';

  @override
  String get teamUiJoinTitle => 'Einem Team beitreten';

  @override
  String get teamUiJoinHint =>
      'tanookiauth://team?…  (der Einladungslink vom Team-Admin)';

  @override
  String get teamUiJoinButton => 'Beitreten';

  @override
  String get teamUiJoinedTeam =>
      'Du bist im Team. Team-Konten erscheinen, sobald die App des Admins den Team-Schlüssel mit diesem Gerät teilt.';

  @override
  String get teamUiInvite => 'Jemanden einladen';

  @override
  String get teamUiInviteHelp =>
      'Auf dem anderen Gerät: Einstellungen > Team-Tresor, dann „Einladungs-QR-Code scannen“ oder „Einladungslink einfügen“. Die Einladung funktioniert einmal und gilt 7 Tage.';

  @override
  String get teamUiRemovePersonTitle => 'Diese Person entfernen?';

  @override
  String get teamUiRemovePersonBody =>
      'Die Person verliert sofort den Zugriff, und das Team bekommt einen neuen Schlüssel, sodass sie nichts mehr lesen kann, was ab jetzt hinzukommt oder sich ändert. Sie hat vielleicht Kopien der Codes behalten, die sie schon sehen konnte – richte also die Zwei-Faktor-Anmeldung wichtiger Konten neu ein.';

  @override
  String get teamUiRemoved => 'Entfernt. Das Team hat einen neuen Schlüssel.';

  @override
  String get teamUiDeleteTitle => 'Das Team löschen?';

  @override
  String get teamUiLeaveTitle => 'Das Team verlassen?';

  @override
  String get teamUiDeleteBody =>
      'Alle Team-Konten werden für alle im Team gelöscht. Die eigenen Konten aller bleiben unberührt.';

  @override
  String get teamUiLeaveBody =>
      'Die Team-Konten verschwinden von diesem Gerät. Deine eigenen Konten bleiben unberührt.';

  @override
  String get teamUiDeleteButton => 'Team löschen';

  @override
  String get teamUiLeaveButton => 'Verlassen';

  @override
  String get teamUiDeleted => 'Team gelöscht.';

  @override
  String get teamUiLeft => 'Du hast das Team verlassen.';

  @override
  String get teamUiAddFirst =>
      'Füge das Konto zuerst zu Tanooki Auth hinzu und kopiere es dann hier ins Team.';

  @override
  String get teamUiCopyInTitle => 'Eines deiner Konten ins Team kopieren';

  @override
  String teamUiCopiedIn(String name) {
    return '$name ist jetzt im Team. Deine eigene Kopie bleibt, wo sie war.';
  }

  @override
  String get teamUiRenameTitle => 'Team-Konto umbenennen';

  @override
  String get teamUiRenameHint => 'Name, z. B. AWS';

  @override
  String teamUiRemoveAccountTitle(String name) {
    return '$name aus dem Team entfernen?';
  }

  @override
  String get teamUiRemoveAccountBody => 'Es verschwindet für alle im Team.';

  @override
  String get teamUiIntro =>
      'Ein Team-Tresor teilt Anmeldecodes mit bis zu 10 Personen, für 20 \$ im Jahr. Alle im Team können Team-Konten sehen, hinzufügen und ändern. Sie werden auf deinen Geräten mit einem Schlüssel verschlüsselt, den nur das Team hat, sodass unser Server sie nicht lesen kann. Team-Konten stehen in einem eigenen Team-Bereich und mischen sich nie mit deinen eigenen Konten.';

  @override
  String get teamUiStart => 'Ein Team gründen';

  @override
  String get teamUiBuy => 'Team-Tarif kaufen — 20 \$ im Jahr';

  @override
  String get teamUiPlanSoon => 'Team-Tarif kommt bald';

  @override
  String get teamUiHaveLicense => 'Ich habe eine Team-Lizenz: Team erstellen';

  @override
  String get teamUiJoinHelp =>
      'Bitte den Team-Admin um eine Einladung. Beitreten ist kostenlos.';

  @override
  String get teamUiScanInvite => 'Einladungs-QR-Code scannen';

  @override
  String get teamUiPasteInvite => 'Einladungslink einfügen';

  @override
  String get teamUiYouRun => 'Du leitest dieses Team';

  @override
  String get teamUiYoureIn => 'Du bist in einem Team';

  @override
  String teamUiPeopleCount(int count, int max) {
    return '$count von $max Personen';
  }

  @override
  String teamUiLastSynced(String when) {
    return 'Zuletzt synchronisiert: $when';
  }

  @override
  String teamUiPaidUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Bezahlt bis $dateString';
  }

  @override
  String get teamUiSyncNow => 'Jetzt synchronisieren';

  @override
  String get teamUiWaitingForKey =>
      'Warte darauf, dass die App des Team-Admins den Team-Schlüssel mit diesem Gerät teilt. Das passiert, wenn der Admin Tanooki Auth das nächste Mal öffnet.';

  @override
  String get teamUiAccounts => 'Team-Konten';

  @override
  String get teamUiAddMine => 'Eines von meinen hinzufügen';

  @override
  String get teamUiNoAccounts => 'Noch keine Team-Konten.';

  @override
  String get teamUiChange => 'Ändern';

  @override
  String get teamUiRename => 'Umbenennen';

  @override
  String get teamUiRemoveFromTeam => 'Aus dem Team entfernen';

  @override
  String get teamUiPeople => 'Personen';

  @override
  String get teamUiThisDevice => 'Dieses Gerät (Admin)';

  @override
  String teamUiDevice(String id) {
    return 'Gerät $id';
  }

  @override
  String teamUiJoined(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Beigetreten am $dateString';
  }

  @override
  String teamUiJoinedGettingKey(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Beigetreten am $dateString · erhält den Team-Schlüssel';
  }

  @override
  String get teamUiDeleteTeam => 'Das Team löschen';

  @override
  String get teamUiLeaveTeam => 'Das Team verlassen';

  @override
  String get teamUiTitle => 'Team-Tresor';

  @override
  String teamUiCopiedCode(String name) {
    return 'Code von $name kopiert. Die Zwischenablage wird in 30 Sekunden geleert.';
  }

  @override
  String teamUiSection(int count) {
    return 'Team · $count';
  }

  @override
  String get teamUiWaitingShort =>
      'Warte darauf, dass der Team-Admin den Team-Schlüssel mit diesem Gerät teilt.';

  @override
  String get teamUiNoAccountsHint =>
      'Noch keine Team-Konten. Füge sie unter Einstellungen > Team-Tresor hinzu.';

  @override
  String get themeAuto => 'Automatisch';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeLight => 'Hell';

  @override
  String get themePink => 'Pastellrosa';

  @override
  String get themeBlue => 'Pastellblau';

  @override
  String get themeLavender => 'Lavendel';

  @override
  String get themeMint => 'Mint';

  @override
  String get themeMidnight => 'Mitternacht';

  @override
  String get themeSunset => 'Sonnenuntergang';

  @override
  String get themePeach => 'Pfirsich';

  @override
  String get themeForest => 'Wald';

  @override
  String get themeOcean => 'Ozean';

  @override
  String get themeMono => 'Mono';

  @override
  String get tidyNoName => '(kein Name)';

  @override
  String tidyDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Namen aufgeräumt.',
      one: '1 Name aufgeräumt.',
    );
    return '$_temp0';
  }

  @override
  String get tidyTitle => 'Kontonamen aufräumen';

  @override
  String get tidyNothing => 'Alle deine Kontonamen sind schon aufgeräumt.';

  @override
  String get tidyIntro =>
      'Diese Namen enthalten Website-Adressen oder überflüssige Teile. Entferne den Haken bei allen, die so bleiben sollen, und tippe auf Anwenden. Deine Codes ändern sich nicht.';

  @override
  String tidyWas(String name) {
    return 'Vorher: $name';
  }

  @override
  String get tidyNothingTicked => 'Nichts angehakt';

  @override
  String tidyApply(int count) {
    return '$count anwenden';
  }

  @override
  String get emergencyNotContactCode =>
      'Das ist kein Tanooki Auth-Kontaktcode. Bitte die Person, Tanooki Auth zu öffnen, zu Einstellungen > Notfallzugriff zu gehen und ihren Kontaktcode zu teilen.';

  @override
  String get emergencyCopyWontOpen =>
      'Die Notfallkopie ließ sich mit dem Schlüssel dieses Geräts nicht öffnen. Sie wurde für ein anderes Gerät erstellt oder ist beschädigt.';

  @override
  String get emergencyGone =>
      'Diese Notfallkopie gibt es nicht mehr. Der Besitzer hat sie entfernt.';

  @override
  String get emergencyWaitNotOver =>
      'Die 7-tägige Wartezeit ist noch nicht vorbei.';

  @override
  String get emergencyNotOwnerOrContact =>
      'Dieses Gerät ist weder Besitzer noch Kontakt dieser Notfallkopie.';

  @override
  String get emergencyNoRequestToDeny =>
      'Es gibt keine Anfrage mehr, die du ablehnen könntest.';

  @override
  String get emergencyAskFirst => 'Frag zuerst nach Zugriff.';

  @override
  String get emergencyTooBig =>
      'Deine Konten sind zu groß für eine Notfallkopie (die Grenze liegt bei etwa 500 KB).';

  @override
  String get emergencyTooManyTries =>
      'Zu viele Versuche in einer Minute. Warte eine Minute und versuch es dann erneut.';

  @override
  String emergencyServerSaidNo(String status) {
    return 'Der Sync-Server hat abgelehnt (HTTP $status).';
  }

  @override
  String emergencyServerSaidNoWhy(String status, String reason) {
    return 'Der Sync-Server hat abgelehnt (HTTP $status: $reason).';
  }

  @override
  String get emergencyNotEmergencyCode =>
      'Das ist kein Tanooki Auth-Notfallcode. Bitte die Person, die dich ausgewählt hat, ihn noch einmal über Einstellungen > Notfallzugriff zu senden.';

  @override
  String get emergencyLessThanMinute => 'weniger als eine Minute';

  @override
  String emergencyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String emergencyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stunden',
      one: '1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String emergencyMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Minuten',
      one: '1 Minute',
    );
    return '$_temp0';
  }

  @override
  String emergencyDaysHours(int days, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '1 Tag',
    );
    String _temp1 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours Stunden',
      one: '1 Stunde',
    );
    return '$_temp0 und $_temp1';
  }

  @override
  String get emergencyUiExplainer =>
      'Wähle eine Person, der du vertraust. Falls dir etwas passiert, kann sie deine Konten anfordern. Deine Geräte bekommen eine Benachrichtigung und du hast 7 Tage Zeit, Nein zu sagen. Sagt niemand Nein, bekommt sie eine Kopie.\n\nDer Tanooki Auth-Server sorgt nur für die 7-tägige Wartezeit. Die Kopie ist mit einem Schlüssel gesperrt, den nur ihr Gerät hat. Der Server kann sie also nicht lesen, und auch niemand, der in den Server einbricht.';

  @override
  String emergencyUiPushNotWorking(String reason) {
    return 'Benachrichtigungen funktionieren noch nicht ($reason). Tanooki Auth sucht bei jedem Öffnen nach Anfragen.';
  }

  @override
  String get emergencyUiScanTheirQr => 'Ihren QR-Code scannen';

  @override
  String get emergencyUiPasteCode => 'Einen gesendeten Code einfügen';

  @override
  String get emergencyUiWrongCode => 'Das ist nicht der richtige Code.';

  @override
  String get emergencyUiCopiedCode =>
      'Kopiert. Schick ihn auf jedem beliebigen Weg: Er enthält keine Geheimnisse.';

  @override
  String get emergencyUiCopyAsText => 'Als Text kopieren';

  @override
  String get emergencyUiTheirContactCode => 'Ihr Kontaktcode';

  @override
  String get emergencyUiNotContactCodeShort =>
      'Das ist kein Tanooki Auth-Kontaktcode.';

  @override
  String get emergencyUiMakeThemContact =>
      'Diese Person als Notfallkontakt festlegen?';

  @override
  String emergencyUiMakeNamedContact(String name) {
    return '$name als Notfallkontakt festlegen?';
  }

  @override
  String get emergencyUiCopyLeftOnServer =>
      'Eine Kopie all deiner Konten wird für ihr Gerät gesperrt und auf dem Tanooki Auth-Server hinterlegt. Sie aktualisiert sich, wenn du deine Konten änderst.';

  @override
  String get emergencyUiYourNameWhose =>
      'Dein Name (damit sie weiß, wessen Kopie das ist)';

  @override
  String get emergencyUiDoneGiveCode =>
      'Fertig. Gib ihr jetzt den Code auf diesem Bildschirm.';

  @override
  String get emergencyUiStopTitle => 'Notfallzugriff beenden?';

  @override
  String get emergencyUiStopBody =>
      'Die Kopie wird vom Server gelöscht und die Person kann sie nicht mehr anfordern.';

  @override
  String get emergencyUiChooseContact => 'Notfallkontakt auswählen';

  @override
  String get emergencyUiChooseContactPremium =>
      'Notfallkontakt auswählen (Premium)';

  @override
  String get emergencyUiChooseContactHow =>
      'Die Person öffnet Tanooki Auth auf ihrem Gerät, geht zu Einstellungen > Notfallzugriff und zeigt dir ihren Kontaktcode.';

  @override
  String get emergencyUiYourContact => 'Dein Kontakt';

  @override
  String get emergencyUiChecking => 'Frage beim Server nach…';

  @override
  String get emergencyUiIdleJustNow =>
      'Niemand hat angefragt. Kopie gerade eben aktualisiert.';

  @override
  String emergencyUiIdleUpdated(String day) {
    return 'Niemand hat angefragt. Kopie zuletzt aktualisiert: $day.';
  }

  @override
  String emergencyUiWaiting(String who, String day, String left) {
    return '$who hat am $day angefragt. In $left kann die Kopie geöffnet werden, außer du lehnst ab.';
  }

  @override
  String emergencyUiReleased(String who) {
    return '$who hat angefragt und die Wartezeit ist vorbei: Die Kopie kann jetzt geöffnet werden. Lehne ab, um das zu verhindern.';
  }

  @override
  String emergencyUiContactIs(String who) {
    return 'Notfallkontakt: $who';
  }

  @override
  String get emergencyUiDenied =>
      'Abgelehnt. Die Person kann deine Konten nicht öffnen. Sie kann später erneut anfragen.';

  @override
  String get emergencyUiCopyUpdated => 'Kopie aktualisiert.';

  @override
  String get emergencyUiCouldntUpdate =>
      'Die Kopie konnte nicht aktualisiert werden.';

  @override
  String get emergencyUiUpdateNow => 'Kopie jetzt aktualisieren';

  @override
  String emergencyUiGiveCode(String who) {
    return 'Gib $who diesen Code. In Tanooki Auth geht es zu Einstellungen > Notfallzugriff > „Code von jemandem hinzufügen“.';
  }

  @override
  String get emergencyUiCodeTheyGave => 'Code, den du bekommen hast';

  @override
  String get emergencyUiNotEmergencyCodeShort =>
      'Das ist kein Tanooki Auth-Notfallcode.';

  @override
  String get emergencyUiAddedTheir =>
      'Hinzugefügt. Falls du sie je brauchst, kannst du die Konten hier anfordern.';

  @override
  String emergencyUiAddedNamed(String name) {
    return 'Hinzugefügt. Falls du sie je brauchst, kannst du die Konten von $name hier anfordern.';
  }

  @override
  String get emergencyUiTheOwner => 'der Besitzer';

  @override
  String get emergencyUiAskTitle => 'Notfallzugriff anfordern?';

  @override
  String emergencyUiAskBody(String who) {
    return '$who bekommt eine Benachrichtigung und hat 7 Tage Zeit, Nein zu sagen. Wenn nicht, kannst du hier eine Kopie der Konten öffnen. Frag nur, wenn du es wirklich brauchst.';
  }

  @override
  String get emergencyUiAsk => 'Anfragen';

  @override
  String get emergencyUiAsked =>
      'Angefragt. Die 7-tägige Wartezeit hat begonnen.';

  @override
  String emergencyUiAddTheirAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Die $count Konten hinzufügen?',
      one: 'Das 1 Konto hinzufügen?',
    );
    return '$_temp0';
  }

  @override
  String emergencyUiAddNamedAccounts(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Die $count Konten von $name hinzufügen?',
      one: 'Das Konto von $name hinzufügen?',
    );
    return '$_temp0';
  }

  @override
  String get emergencyUiSomeone => 'Jemand';

  @override
  String get emergencyUiCheckingShort => 'Wird geprüft…';

  @override
  String get emergencyUiNotAsked => 'Du hast noch nicht angefragt.';

  @override
  String get emergencyUiRequestAccess => 'Zugriff anfordern';

  @override
  String emergencyUiOpensIn(String left, String day) {
    return 'Du hast angefragt. Öffnet sich in $left ($day), außer die Person sagt Nein.';
  }

  @override
  String get emergencyUiWaitOver => 'Die Wartezeit ist vorbei.';

  @override
  String get emergencyUiOpenCopy => 'Notfallkopie öffnen';

  @override
  String emergencyUiPersonAccounts(String who) {
    return 'Konten von $who';
  }

  @override
  String get emergencyUiYourContactCode => 'Dein Kontaktcode';

  @override
  String get emergencyUiShowThis =>
      'Wenn dich jemand als Notfallkontakt möchte, zeig ihm das. Es enthält keine Geheimnisse.';

  @override
  String get emergencyUiYourNameItsYou =>
      'Dein Name (damit man weiß, dass du es bist)';

  @override
  String get emergencyUiShowMyCode => 'Meinen Kontaktcode zeigen';

  @override
  String get emergencyUiLetThemScan =>
      'Lass es in Tanooki Auth scannen, oder kopier es und schick es.';

  @override
  String get emergencyUiAddCodeGiven => 'Code von jemandem hinzufügen';

  @override
  String get emergencyUiAddCodeGivenHow =>
      'Nachdem die Person dich gewählt hat, zeigt ihre App einen Code für dich';

  @override
  String get emergencyUiTitle => 'Notfallzugriff';

  @override
  String get emergencyUiYourEmergencyContact => 'Dein Notfallkontakt';

  @override
  String get emergencyUiPeopleWhoChoseYou => 'Personen, die dich gewählt haben';

  @override
  String get securityUiProofWindows => 'Windows Hello';

  @override
  String get securityUiProofMac => 'Touch ID oder dein Passwort';

  @override
  String get securityUiProofIos => 'Face ID oder Code';

  @override
  String get securityUiProofOther => 'Fingerabdruck oder PIN';

  @override
  String securityUiPasscodeAtLeast(int count) {
    return 'Code (mindestens $count Ziffern)';
  }

  @override
  String get securityUiTypeAgain => 'Noch einmal eingeben';

  @override
  String get securityUiPasscodesDontMatch =>
      'Die beiden Codes stimmen nicht überein.';

  @override
  String get securityUiPickDifferent =>
      'Wähle einen anderen Code als deinen anderen.';

  @override
  String get securityUiEnterPasscode => 'Gib deinen App-Code ein';

  @override
  String get securityUiPasscode => 'Code';

  @override
  String get securityUiWrongPasscode => 'Das ist nicht dein Code.';

  @override
  String get securityUiCheckupTitle => 'Sicherheitscheck';

  @override
  String get securityUiAllGood => 'Alles in Ordnung';

  @override
  String get securityUiAllGoodBody =>
      'Die App ist gesperrt, du hast ein aktuelles Backup und jedes Konto hat Wiederherstellungscodes.';

  @override
  String get securityUiLockOffTitle => 'Die App ist nicht gesperrt';

  @override
  String get securityUiLockOffBody =>
      'Wer dein entsperrtes Gerät in die Hand nimmt, sieht deine Codes. Schalte in den Einstellungen „App sperren“ oder einen App-Code ein.';

  @override
  String get securityUiNoPasscodeTitle => 'Kein App-Code';

  @override
  String get securityUiNoPasscodeBody =>
      'Mit einem Code kannst du Tanooki Auth auch öffnen, wenn Face ID oder dein Fingerabdruck nicht mehr funktioniert. Leg einen in den Einstellungen fest.';

  @override
  String get securityUiAutoBackupFailed =>
      'Automatisches Backup fehlgeschlagen';

  @override
  String get securityUiOpenAutoBackups => 'Automatische Backups öffnen';

  @override
  String get securityUiNoBackupTitle => 'Kein Backup in den letzten 30 Tagen';

  @override
  String get securityUiNoBackupBody =>
      'Wenn dieses Gerät verloren geht oder kaputtgeht, ist ein Backup der einzige Weg, deine Konten zurückzubekommen.';

  @override
  String get securityUiMakeBackupNow => 'Jetzt Backup erstellen';

  @override
  String securityUiNoRecoveryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten haben keine Wiederherstellungscodes',
      one: '1 Konto hat keine Wiederherstellungscodes',
    );
    return '$_temp0';
  }

  @override
  String securityUiNoRecoveryBody(String names) {
    return 'Mit Wiederherstellungscodes kommst du in eine Website, wenn du diese App verlierst. Du findest sie in den Sicherheitseinstellungen jeder Seite. Füge sie dann mit ⋯ > Wiederherstellungscodes beim Konto hinzu.\n\n$names';
  }

  @override
  String get securityUiRecoveryKit => 'Dein Wiederherstellungs-Kit';

  @override
  String get securityUiRecoveryKitSub =>
      'Backup, Wiederherstellungscodes und Papierkopie, Schritt für Schritt';

  @override
  String securityUiBreachSnack(String sites) {
    return '$sites hatte ein Datenleck. Ändere dort dein Passwort.';
  }

  @override
  String get securityUiBreachDownloadFailed =>
      'Die Liste der Datenlecks konnte nicht geladen werden. Prüfe deine Internetverbindung und versuch es erneut.';

  @override
  String get securityUiBreachAlerts => 'Datenleck-Warnungen';

  @override
  String get securityUiBreachAlertsPremium => 'Datenleck-Warnungen (Premium)';

  @override
  String get securityUiBreachAlertsSub =>
      'Sagt dir einmal pro Woche, ob eine Website, die du nutzt, ein Datenleck hatte';

  @override
  String get securityUiBreachHow =>
      'So funktioniert\'s: Tanooki Auth lädt die öffentliche Liste bekannter Datenlecks von haveibeenpwned.com herunter und vergleicht sie auf diesem Gerät mit deinen gespeicherten Websites. Es wird nichts über dich oder deine Konten gesendet: Alle bekommen denselben Download. Abgesehen von Sync und dem Kauf von Premium ist das das einzige Mal, dass die App ins Internet geht.';

  @override
  String securityUiNoWebsite(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count deiner Konten haben keine gespeicherte Website und können daher nicht geprüft werden. Füge eine mit ⋯ > Bearbeiten hinzu.',
      one: '1 deiner Konten hat keine gespeicherte Website und kann daher nicht geprüft werden. Füge eine mit ⋯ > Bearbeiten hinzu.',
    );
    return '$_temp0';
  }

  @override
  String get securityUiCheckNow => 'Jetzt prüfen';

  @override
  String get securityUiNoBreaches =>
      'Keine bekannten Datenlecks bei deinen gespeicherten Websites.';

  @override
  String get securityUiBreached =>
      'Datenleck. Wenn du dein Passwort davor angelegt hast, ändere es dort.';

  @override
  String securityUiBreachedOn(String date) {
    return 'Datenleck am $date. Wenn du dein Passwort davor angelegt hast, ändere es dort.';
  }

  @override
  String securityUiBreachedLeaked(String data) {
    return 'Datenleck. Betroffen: $data. Wenn du dein Passwort davor angelegt hast, ändere es dort.';
  }

  @override
  String securityUiBreachedOnLeaked(String date, String data) {
    return 'Datenleck am $date. Betroffen: $data. Wenn du dein Passwort davor angelegt hast, ändere es dort.';
  }

  @override
  String get securityUiKitIntro =>
      'Wenn du dieses Gerät verlierst, kommst du so wieder in deine Konten. Jeder Schritt dauert eine Minute. Falls du noch keine Konten hinzugefügt hast, mach das zuerst und komm dann über Einstellungen > Sicherheitscheck hierher zurück.';

  @override
  String get securityUiKitBackupTitle => 'Backup erstellen';

  @override
  String get securityUiKitBackupBody =>
      'Eine verschlüsselte Datei, gesichert mit einer Passphrase deiner Wahl. Bewahre sie nicht nur auf diesem Gerät auf, sondern z. B. in iCloud Drive, Google Drive oder auf einem USB-Stick.';

  @override
  String get securityUiKitBackupButton => 'Backup erstellen';

  @override
  String get securityUiKitCodesTitle => 'Wiederherstellungscodes sichern';

  @override
  String get securityUiKitCodesBody =>
      'Wenn du die Zwei-Faktor-Anmeldung einschaltest, geben dir die meisten Websites eine Liste einmaliger Wiederherstellungscodes. Füge sie bei jedem Konto über ⋯ > Wiederherstellungscodes hinzu, dann sind sie auch in deinem Backup.';

  @override
  String get securityUiKitPaperTitle => 'Papier-Backup drucken';

  @override
  String get securityUiKitPaperBody =>
      'Optional. Eine gedruckte Seite mit QR-Codes funktioniert auch, wenn alle Geräte weg sind. Schließ sie weg: Wer sie hat, kann deine Codes erzeugen.';

  @override
  String get securityUiKitPaperButton => 'Papier-Backup drucken';

  @override
  String get securityUiSkipForNow => 'Jetzt überspringen';

  @override
  String get securityExtrasPrivacy =>
      'Kein Konto, kein Tracking. Deine Einrichtungsschlüssel werden verschlüsselt auf diesem Gerät gespeichert. Die App geht nur online für: eine Uhrzeitprüfung (sie fragt den Tanooki Auth-Server nach der Uhrzeit, höchstens einmal pro Stunde, solange Codes angezeigt werden, und wenn du auf „Codes funktionieren nicht?“ tippst; es wird nichts über dich oder deine Konten gesendet), Datenleck-Warnungen, wenn du sie einschaltest (lädt die öffentliche Liste herunter), Sync, Telefon-Verknüpfung und Notfallzugriff, wenn du sie einrichtest (sie übertragen nur verschlüsselte Daten, die der Server nicht lesen kann), den Kauf von Premium und Feedback, das du senden möchtest (deine Nachricht, deine E-Mail, falls du eine eingibst, sowie App-Version und Gerätetyp, wenn das Häkchen gesetzt bleibt; nie deine Konten, Codes oder sonst etwas aus der App). 2FA-Anleitungen öffnen sich in deinem Webbrowser.';

  @override
  String get securityExtrasMonthlyBody =>
      'Deine monatliche Sicherheitsübersicht ist fertig. Öffne Tanooki Auth, um sie anzusehen.';

  @override
  String get securityExtrasNotificationsOffIos =>
      'Benachrichtigungen sind für Tanooki Auth ausgeschaltet. Schalte sie in der iPhone-App „Einstellungen“ unter „Mitteilungen“ ein und versuch es dann erneut.';

  @override
  String get securityExtrasNotificationsOffMac =>
      'Benachrichtigungen sind für Tanooki Auth ausgeschaltet. Schalte sie in den Systemeinstellungen unter „Mitteilungen“ ein und versuch es dann erneut.';

  @override
  String securityExtrasReminderFailed(String reason) {
    return 'Die Erinnerung konnte nicht eingerichtet werden ($reason).';
  }

  @override
  String get securityExtrasRemindersUnavailable =>
      'Erinnerungen sind auf diesem Gerät noch nicht verfügbar.';

  @override
  String securityExtrasDayTime(String day, String time) {
    return '$day, $time';
  }

  @override
  String get securityExtrasClearTitle => 'Aktivitätsverlauf löschen?';

  @override
  String get securityExtrasClearBody =>
      'Alle Einträge werden von diesem Gerät entfernt. Deine Konten bleiben unberührt.';

  @override
  String get securityExtrasActivityTitle => 'Aktivitätsverlauf';

  @override
  String securityExtrasActivityPitch(int count) {
    return 'Der Aktivitätsverlauf gehört zu Premium. Er speichert die letzten $count Male, die ein Code kopiert, auf einer Website ausgefüllt, getippt, als QR-Code gezeigt oder exportiert wurde, nur auf diesem Gerät.';
  }

  @override
  String get securityExtrasNothingYet =>
      'Noch nichts. Kopieren, Ausfüllen, Tippen, QR-Code-Anzeigen und Exportieren erscheint hier.';

  @override
  String get securityExtrasAllAccounts => 'Alle Konten';

  @override
  String get securityExtrasDeletedAccount => 'Ein gelöschtes Konto';

  @override
  String securityExtrasActivityLine(String kind, String what) {
    return '$kind: $what';
  }

  @override
  String get securityExtrasGetPremium => 'Premium holen';

  @override
  String get securityExtrasAddKey => 'Sicherheitsschlüssel hinzufügen';

  @override
  String get securityExtrasAddKeyPremium =>
      'Sicherheitsschlüssel hinzufügen (Premium)';

  @override
  String get securityExtrasAddKeyIos =>
      'Halte den Schlüssel danach auf Aufforderung an die Oberseite deines iPhone oder steck ihn ein. Eventuell musst du ihn zweimal berühren.';

  @override
  String get securityExtrasAddKeyOther =>
      'Steck den Schlüssel danach ein und berühre ihn, wenn er blinkt. Eventuell musst du ihn zweimal berühren und seine PIN eingeben, falls er eine hat.';

  @override
  String get securityExtrasKeyName =>
      'Name (damit du deine Schlüssel auseinanderhalten kannst)';

  @override
  String securityExtrasKeyAdded(String name) {
    return '„$name“ hinzugefügt. Du kannst Tanooki Auth auf diesem Gerät jetzt damit entsperren.';
  }

  @override
  String securityExtrasKeyRemoved(String name) {
    return '„$name“ entfernt. Damit lässt sich Tanooki Auth nicht mehr entsperren.';
  }

  @override
  String get securityExtrasKeysTitle => 'Sicherheitsschlüssel';

  @override
  String securityExtrasKeysIntro(String usual) {
    return 'Ein Sicherheitsschlüssel (z. B. ein YubiKey) kann Tanooki Auth statt $usual entsperren. Der Schlüssel enthält ein Geheimnis, das ihn nie verlässt, und die App sichert damit den Schlüssel zu deinen Konten. Verlierst du ihn, kannst du trotzdem wie gewohnt entsperren.';
  }

  @override
  String securityExtrasKeyAddedOn(String day) {
    return 'Hinzugefügt $day';
  }

  @override
  String get securityExtrasLockOffNote =>
      'Die App-Sperre ist aus, die App öffnet sich also ohne Nachfrage. Schalte in den Einstellungen „App sperren“ oder einen Code ein, um deinen Schlüssel zu nutzen.';

  @override
  String get securityExtrasLockWordWindows => 'Windows Hello oder deines Codes';

  @override
  String get securityExtrasLockWordMac => 'Touch ID oder deines Codes';

  @override
  String get securityExtrasLockWordOther => 'Face ID oder deines Codes';

  @override
  String get securityLockImmediately => 'Sofort';

  @override
  String get securityLockAfter30s => 'Nach 30 Sekunden';

  @override
  String get securityLockAfter1m => 'Nach 1 Minute';

  @override
  String get securityLockAfter5m => 'Nach 5 Minuten';

  @override
  String get securityNumbersOnly => 'Nur Ziffern verwenden.';

  @override
  String securityAtLeastNumbers(int count) {
    return 'Verwende mindestens $count Ziffern.';
  }

  @override
  String get securitySameNumber =>
      'Verwende nicht immer wieder dieselbe Ziffer.';

  @override
  String get securityNumbersInRow =>
      'Verwende keine aufeinanderfolgenden Ziffern wie 123456.';

  @override
  String get securityPanicNeedsPasscode =>
      'Leg zuerst einen App-Code fest. Die Notfall-Löschung zählt falsche Codes.';

  @override
  String get securityPanicNeedsBackup =>
      'Erstelle zuerst ein Backup (Einstellungen > Backup exportieren). Die Notfall-Löschung löscht alle Konten und lässt sich daher nur einschalten, wenn du in den letzten 30 Tagen ein Backup gemacht hast.';

  @override
  String get securityKeyDefaultName => 'Sicherheitsschlüssel';

  @override
  String get securityKeyNotYours =>
      'Dieser Sicherheitsschlüssel wurde auf diesem Gerät nicht zu Tanooki Auth hinzugefügt.';

  @override
  String get securityKeyNotAvailable =>
      'Auf diesem Gerät noch nicht verfügbar.';

  @override
  String get securityKeyWindowsTooOld =>
      'Auf dieser Windows-Version noch nicht verfügbar. Installiere die neuesten Windows 11-Updates.';

  @override
  String get securityKeyIosTooOld =>
      'Benötigt iOS 26.4 oder neuer. Aktualisiere in der App „Einstellungen“ und versuch es dann erneut.';

  @override
  String get securityKeyMacTooOld =>
      'Benötigt macOS 26.4 oder neuer. Aktualisiere in der App „Einstellungen“ und versuch es dann erneut.';

  @override
  String get securityKeyDidntWork =>
      'Der Sicherheitsschlüssel hat nicht funktioniert. Versuch es erneut.';

  @override
  String securityKeyDidntWorkWhy(String reason) {
    return 'Der Sicherheitsschlüssel hat nicht funktioniert ($reason). Versuch es erneut.';
  }

  @override
  String get securityKeyCanceled => 'Abgebrochen. Nichts wurde geändert.';

  @override
  String get securityKeyNoPrf =>
      'Dieser Sicherheitsschlüssel kann Apps so nicht entsperren (ihm fehlt die Funktion „hmac-secret“). Die YubiKey 5-Serie und die meisten FIDO2-Schlüssel der letzten Jahre haben sie.';

  @override
  String get securityKeyNotAllowed =>
      'Der Sicherheitsschlüssel hat nicht geantwortet oder wurde hier nicht hinzugefügt. Steck ihn ein (oder halte ihn an die Oberseite deines Telefons) und berühre ihn, wenn er blinkt.';

  @override
  String get securityKeyNotAssociated =>
      'Diese Kopie von Tanooki Auth darf noch keine Sicherheitsschlüssel nutzen: Apple verlangt zuerst, dass die App mit auth.tanookistudios.com verknüpft ist. Das liegt bei uns, nicht bei dir.';

  @override
  String get securityKeyExists =>
      'Dieser Sicherheitsschlüssel ist bereits hinzugefügt.';

  @override
  String get securityKeyPin =>
      'Der Sicherheitsschlüssel braucht seine PIN, und sie wurde nicht eingegeben. Versuch es erneut und gib die PIN ein, wenn du gefragt wirst.';

  @override
  String get securityKeyVaultKeyMissing =>
      'Der Schlüssel, der deine Konten entsperrt, fehlt. Deshalb kann kein Sicherheitsschlüssel hinzugefügt werden.';

  @override
  String get securityKeyNoneAdded =>
      'Auf diesem Gerät ist kein Sicherheitsschlüssel hinzugefügt.';

  @override
  String get securityKeyBeforeReset =>
      'Dieser Sicherheitsschlüssel wurde hinzugefügt, bevor deine Konten zurückgesetzt wurden, und kann sie daher nicht öffnen. Entferne ihn und füge ihn neu hinzu.';

  @override
  String get backupUiChoosePassphrase => 'Wähle eine Backup-Passphrase';

  @override
  String get backupUiPassphraseTitle => 'Backup-Passphrase';

  @override
  String get backupUiPassphraseWarning =>
      'Du brauchst sie, um das Backup wiederherzustellen. Niemand, auch wir nicht, kann sie wiederherstellen, wenn du sie vergisst. Schreib sie an einem sicheren Ort auf.';

  @override
  String get backupUiPassphrase => 'Passphrase';

  @override
  String get backupUiTypeAgain => 'Noch einmal eingeben';

  @override
  String get backupUiTooShort =>
      'Verwende mindestens 8 Zeichen. Ein paar zufällige Wörter funktionieren gut.';

  @override
  String get backupUiNoMatch => 'Die beiden Passphrasen stimmen nicht überein.';

  @override
  String get backupUiTypePassphrase => 'Gib die Passphrase ein.';

  @override
  String get backupUiNothingToBackUp =>
      'Es gibt noch keine Konten zum Sichern.';

  @override
  String get backupUiEncrypting => 'Backup wird verschlüsselt…';

  @override
  String backupUiSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Backup von $count Konten gespeichert.',
      one: 'Backup von 1 Konto gespeichert.',
    );
    return '$_temp0';
  }

  @override
  String get backupUiNotABackup => 'Diese Datei ist kein Tanooki Auth-Backup.';

  @override
  String get backupUiUnlocking => 'Backup wird entsperrt…';

  @override
  String backupUiImported(int count) {
    return '$count importiert.';
  }

  @override
  String backupUiImportedSkipped(int added, int skipped) {
    return '$added importiert, $skipped übersprungen.';
  }

  @override
  String backupUiImportedSkippedAlready(int added, int skipped) {
    return '$added importiert, $skipped übersprungen, weil schon in deiner Liste.';
  }

  @override
  String backupUiAdded(int count) {
    return '$count hinzugefügt.';
  }

  @override
  String backupUiAddedSkipped(int added, int skipped) {
    return '$added hinzugefügt, $skipped übersprungen.';
  }

  @override
  String backupUiAddedSkippedAlready(int added, int skipped) {
    return '$added hinzugefügt, $skipped übersprungen, weil schon in deiner Liste.';
  }

  @override
  String backupUiAlreadyInList(int count) {
    return '• $count schon in deiner Liste';
  }

  @override
  String get backupUiImport => 'Importieren';

  @override
  String backupUiImportFromGoogle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten aus Google Authenticator importieren?',
      one: '1 Konto aus Google Authenticator importieren?',
    );
    return '$_temp0';
  }

  @override
  String get backupUiGoogleMoreCodes =>
      'Wenn Google Authenticator mehr als einen QR-Code gezeigt hat, scanne jeden davon.';

  @override
  String get backupUiNothingToExport =>
      'Es gibt noch keine Konten zum Exportieren.';

  @override
  String get backupUiPlainWhat =>
      'Damit wird jeder Einrichtungsschlüssel als Klartext gespeichert, um zu einer anderen Authenticator-App zu wechseln.';

  @override
  String get backupUiPlainTitle => 'Unverschlüsselt exportieren?';

  @override
  String backupUiPlainBody(String what) {
    return '$what Wer diese Datei bekommt, kann deine Anmeldecodes erzeugen. Importiere sie und lösch sie danach sofort. Für ein normales Backup nimm lieber „Backup exportieren“.';
  }

  @override
  String get backupUiUnderstandExport => 'Verstanden, exportieren';

  @override
  String get backupUiNothingToPrint => 'Es gibt noch keine Konten zum Drucken.';

  @override
  String get backupUiPaperTitle => 'Papier-Backup drucken?';

  @override
  String get backupUiPaperBody =>
      'Damit entsteht ein PDF mit einem QR-Code für jedes Konto plus deinen unbenutzten Wiederherstellungscodes. Wer das Papier sieht oder fotografiert, kann für immer deine Anmeldecodes erzeugen, ohne dein Telefon oder Passwort.\n\nDruck es aus und lösch dann das PDF. Bewahre das Papier verschlossen auf, z. B. in einem Safe oder bei wichtigen Unterlagen. Schick es nicht per E-Mail und speichere es nicht in einem geteilten Ordner.';

  @override
  String get backupUiUnderstandPdf => 'Verstanden, PDF erstellen';

  @override
  String get backupUiMakingPdf => 'PDF wird erstellt…';

  @override
  String get backupUiPdfReady =>
      'PDF fertig. Druck es aus und lösch dann die Datei.';

  @override
  String get backupUiWorksTitle => 'Backup funktioniert';

  @override
  String backupUiWorksBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Dieses Backup lässt sich öffnen und enthält $count Konten. Es wurde nichts hinzugefügt oder geändert.',
      one: 'Dieses Backup lässt sich öffnen und enthält 1 Konto. Es wurde nichts hinzugefügt oder geändert.',
    );
    return '$_temp0';
  }

  @override
  String get backupWrongVersion =>
      'Dieses Backup wurde mit einer neueren Version von Tanooki Auth erstellt. Aktualisiere die App und versuch es erneut.';

  @override
  String get backupWrongPassphrase =>
      'Falsche Passphrase, oder die Backup-Datei ist beschädigt.';

  @override
  String get backupDamaged =>
      'Das Backup wurde entsperrt, aber sein Inhalt ist beschädigt.';

  @override
  String get paperBackupTitle => 'Tanooki Auth-Papier-Backup';

  @override
  String paperBackupHeader(String date) {
    return 'Tanooki Auth-Papier-Backup, $date';
  }

  @override
  String get paperBackupWarning =>
      'GEHEIM HALTEN. Wer dieses Papier hat, kann deine Anmeldecodes erzeugen. Bewahre es verschlossen auf und vernichte es, wenn du ein neues machst. Zum Wiederherstellen: Wähle in einer beliebigen Authenticator-App „QR-Code scannen“ und scanne jeden Code unten.';

  @override
  String paperBackupSetupKey(String key) {
    return 'Einrichtungsschlüssel: $key';
  }

  @override
  String get paperBackupRecoveryCodes =>
      'Wiederherstellungscodes (jeder funktioniert einmal):';

  @override
  String get autoBackupUiChooseFolderDialog =>
      'Wähle einen Ordner für automatische Backups';

  @override
  String autoBackupUiToday(String time) {
    return 'Heute um $time';
  }

  @override
  String autoBackupUiYesterday(String time) {
    return 'Gestern um $time';
  }

  @override
  String autoBackupUiOnDay(String date, String time) {
    return '$date um $time';
  }

  @override
  String get autoBackupUiBackingUp => 'Backup läuft…';

  @override
  String autoBackupUiBackedUp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten gesichert.',
      one: '1 Konto gesichert.',
    );
    return '$_temp0';
  }

  @override
  String get autoBackupUiCouldntUseFolder =>
      'Dieser Ordner konnte nicht verwendet werden.';

  @override
  String autoBackupUiCouldntUseFolderWhy(String reason) {
    return 'Dieser Ordner konnte nicht verwendet werden. $reason';
  }

  @override
  String get autoBackupUiTurnOffTitle => 'Automatische Backups ausschalten?';

  @override
  String get autoBackupUiTurnOffBody =>
      'Backups, die schon im Ordner liegen, bleiben dort. Die Backup-Passphrase wird vergessen, du wählst also eine neue, wenn du das wieder einschaltest.';

  @override
  String get autoBackupUiTitle => 'Automatische Backups';

  @override
  String get autoBackupUiTitlePremium => 'Automatische Backups (Premium)';

  @override
  String autoBackupUiIntro(int count) {
    return 'Einmal am Tag speichert Tanooki Auth ein verschlüsseltes Backup in einem Ordner deiner Wahl. Nimm deinen iCloud Drive-, Google Drive- oder Dropbox-Ordner, dann liegen deine Backups auch außerhalb dieses Geräts. Die neuesten $count bleiben erhalten, ältere werden gelöscht.\n\nStelle eines über Einstellungen > Backup importieren mit deiner Backup-Passphrase wieder her.';
  }

  @override
  String get autoBackupUiLastFailed =>
      'Das letzte automatische Backup ist fehlgeschlagen';

  @override
  String get autoBackupUiChooseFolder => 'Ordner auswählen';

  @override
  String get autoBackupUiBackupFolder => 'Backup-Ordner';

  @override
  String get autoBackupUiNoBackupYet => 'Noch kein Backup';

  @override
  String autoBackupUiLastBackup(String when) {
    return 'Letztes Backup: $when';
  }

  @override
  String get autoBackupUiBackUpNow => 'Jetzt sichern';

  @override
  String get autoBackupUiChangeFolder => 'Ordner ändern';

  @override
  String get autoBackupUiOffSubtitle =>
      'Aus. Ein tägliches verschlüsseltes Backup in iCloud Drive, Google Drive, Dropbox oder einen beliebigen Ordner.';

  @override
  String autoBackupUiOnNoBackup(String folder) {
    return 'An, in $folder. Noch kein Backup.';
  }

  @override
  String autoBackupUiOnLast(String folder, String when) {
    return 'An, in $folder. Letztes Backup: $when.';
  }

  @override
  String get autoBackupFolderGone =>
      'Der Backup-Ordner ist weg. Er wurde vielleicht gelöscht, außerhalb der App umbenannt, oder sein Laufwerk ist nicht angeschlossen. Wähle den Ordner erneut.';

  @override
  String get autoBackupPermissionLost =>
      'Tanooki Auth darf nicht mehr in den Backup-Ordner schreiben. Wähle den Ordner erneut, um die Berechtigung wieder zu erteilen.';

  @override
  String get autoBackupDiskFull =>
      'Das Laufwerk des Backup-Ordners ist voll. Gib etwas Speicher frei und tippe dann auf „Jetzt sichern“.';

  @override
  String get autoBackupOther =>
      'Das Backup konnte nicht gespeichert werden. Tippe auf „Jetzt sichern“, um es erneut zu versuchen.';

  @override
  String autoBackupOtherWhy(String reason) {
    return 'Das Backup konnte nicht gespeichert werden ($reason). Tippe auf „Jetzt sichern“, um es erneut zu versuchen.';
  }

  @override
  String get importUiDeleteNote =>
      'Wenn du fertig bist, lösch die Exportdatei: Wer sie bekommt, kann deine Codes erzeugen.';

  @override
  String get importUiStepsAegis =>
      'In Aegis auf deinem Android-Telefon:\n\n1. Tippe auf ⋮, dann Einstellungen, dann „Importieren & Exportieren“.\n2. Tippe auf „Exportieren“ und wähle „Aegis (.JSON)“.\n3. Lass „Tresor verschlüsseln“ ruhig an; das Passwort gibst du dann hier ein.\n4. Speichere die Datei dort, wo dieses Gerät sie öffnen kann (z. B. Google Drive, oder schick sie dir per E-Mail).\n\nWähle dann diese Datei hier aus.';

  @override
  String get importUiStepsTwoFas =>
      'In 2FAS:\n\n1. Öffne die Einstellungen, dann „2FAS-Backup“.\n2. Tippe auf „In Datei exportieren“. Falls ein Passwort verlangt wird, gibst du dasselbe hier ein.\n3. Speichere die .2fas-Datei dort, wo dieses Gerät sie öffnen kann.\n\nWähle dann diese Datei hier aus.';

  @override
  String get importUiStepsAuthy =>
      'Authy hat keine Export-Schaltfläche, und Authy für Computer wurde 2024 eingestellt.\n\nFalls du deine Konten schon mit einem Tool wie „authy-export“ herausgeholt hast, wähle die Datei, die es erstellt hat (eine .json-Datei oder eine .txt-Liste mit otpauth://-Links).\n\nFalls nicht, geht es sicher nur Konto für Konto: Melde dich bei jeder Website an, schalte die Zwei-Faktor-Anmeldung aus und wieder ein und scanne den neuen QR-Code mit Tanooki Auth. Behalte Authy, bis jedes Konto hier funktioniert.';

  @override
  String get importUiStepsBitwarden =>
      'In Bitwarden (Website oder Desktop-App):\n\n1. Geh zu Werkzeuge, dann „Tresor exportieren“.\n2. Wähle „.json“ oder „.csv“. Nicht „verschlüsselt“.\n3. Speichere die Datei.\n\nWähle dann diese Datei hier aus. Nur Zugangsdaten mit einem Authenticator-Schlüssel werden übernommen; deine Passwörter werden ignoriert.';

  @override
  String get importUiStepsOnePassword =>
      'In der 1Password-App für Mac oder Windows:\n\n1. Klicke auf Ablage bzw. Datei, dann Exportieren, und wähle dein Konto.\n2. Wähle „CSV“ als Format und speichere.\n\nWähle dann diese Datei hier aus. Nur Einträge mit Einmalpasswort werden übernommen; deine Passwörter werden ignoriert.';

  @override
  String get importUiStepsApple =>
      'Dafür brauchst du einen Mac; das iPhone kann die Datei nicht speichern.\n\nAuf einem Mac mit macOS Sequoia oder neuer:\n1. Öffne die App „Passwörter“.\n2. Klicke in der Menüleiste auf Ablage, dann „Alle Passwörter exportieren …“.\n3. Klicke auf „Passwörter exportieren“, gib bei Bedarf dein Mac-Passwort ein und speichere die Datei.\n\nAuf einem älteren Mac: Öffne Safari, dann Safari > Einstellungen > Passwörter, klicke auf ⋯ und wähle „Alle Passwörter exportieren …“.\n\nWähle dann diese Datei hier aus. Nur Einträge mit Bestätigungscode werden übernommen; deine Passwörter werden ignoriert.';

  @override
  String get importUiStepsMicrosoft =>
      'Microsoft Authenticator kann deine Konten nicht exportieren, deshalb lassen sie sich nicht auf einmal umziehen.\n\nFür jedes Konto:\n1. Melde dich an einem Computer bei dieser Website an.\n2. Such ihre Sicherheits- oder Zwei-Faktor-Einstellungen.\n3. Schalte die Zwei-Faktor-Anmeldung aus und wieder ein (oder wähle „neue Authenticator-App hinzufügen“).\n4. Scanne den neuen QR-Code mit Tanooki Auth und gib zum Abschluss den angezeigten Code ein.\n\nBehalte Microsoft Authenticator, bis jedes Konto in Tanooki Auth funktioniert. Auch dein Microsoft-Konto selbst kann Tanooki Auth nutzen: Füge es auf account.microsoft.com unter „Sicherheit“ hinzu.';

  @override
  String get importUiTitle => 'Aus einer anderen App umziehen';

  @override
  String get importUiCantExport =>
      'Kein Export möglich: So ziehst du jedes Konto um';

  @override
  String get importUiFromExportFile => 'Aus einer Exportdatei';

  @override
  String importUiMoveFrom(String app) {
    return 'Aus $app umziehen';
  }

  @override
  String get importUiGotIt => 'Verstanden';

  @override
  String get importUiPickFile => 'Datei auswählen';

  @override
  String get importUiCouldntRead => 'Diese Datei konnte nicht gelesen werden.';

  @override
  String importUiReading(String app) {
    return '$app-Export wird gelesen…';
  }

  @override
  String get importUiNoAccountsInFile =>
      'In dieser Datei waren keine Zwei-Faktor-Konten.';

  @override
  String importUiImportFrom(int count, String app) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten aus $app importieren?',
      one: '1 Konto aus $app importieren?',
    );
    return '$_temp0';
  }

  @override
  String importUiExportPassword(String app) {
    return 'Passwort des $app-Exports';
  }

  @override
  String get importUiPasswordHint =>
      'Das Passwort, das du beim Exportieren gewählt hast';

  @override
  String importersNotAnExport(String app) {
    return 'Diese Datei ist kein $app-Export.';
  }

  @override
  String importersLine(String line, String problem) {
    return 'Zeile $line: $problem';
  }

  @override
  String get importersEmpty => 'Diese Datei ist leer.';

  @override
  String get importersNotAuthy => 'Diese Datei ist kein Authy-Export.';

  @override
  String get importersAnAccount => 'Ein Konto';

  @override
  String importersQuoted(String name) {
    return '„$name“';
  }

  @override
  String importersProblemColon(String name, String problem) {
    return '$name: $problem';
  }

  @override
  String importersProblem(String name, String problem) {
    return '$name $problem';
  }

  @override
  String get importersAegisPassword =>
      'Dieser Aegis-Export ist mit einem Passwort geschützt.';

  @override
  String get importersAegisBiometricOnly =>
      'Dieser Aegis-Export lässt sich nur per Fingerabdruck auf dem Telefon öffnen, das ihn erstellt hat. Exportiere in Aegis erneut und wähle ein Passwort.';

  @override
  String get importersAegisWrongPassword =>
      'Falsches Passwort für diesen Aegis-Export.';

  @override
  String get importersAegisDamaged =>
      'Der Aegis-Export wurde entsperrt, aber sein Inhalt ist beschädigt.';

  @override
  String get importersNotAegis => 'Diese Datei ist kein Aegis-Export.';

  @override
  String importersUnsupportedType(String type) {
    return 'nutzt $type-Codes, die Tanooki Auth nicht unterstützt';
  }

  @override
  String get importersNotTwoFas => 'Diese Datei ist kein 2FAS-Backup.';

  @override
  String get importersTwoFasPassword =>
      'Dieses 2FAS-Backup ist mit einem Passwort geschützt.';

  @override
  String get importersTwoFasDamaged => 'Dieses 2FAS-Backup ist beschädigt.';

  @override
  String get importersTwoFasWrongPassword =>
      'Falsches Passwort für dieses 2FAS-Backup.';

  @override
  String get importersBitwardenEncrypted =>
      'Dieser Bitwarden-Export ist verschlüsselt. Exportiere in Bitwarden erneut und wähle das Format „.json“ (nicht „verschlüsselt“).';

  @override
  String get importersOnePux =>
      'Das sieht nach einer 1Password-.1pux-Datei aus. Exportiere in 1Password erneut und wähle CSV.';

  @override
  String importersNoCodeColumn(String app) {
    return 'Diese Datei hat keine Spalte für Einmalcodes, ist also kein $app-Export mit Codes darin.';
  }

  @override
  String importersCantReadCode(String reason) {
    return 'hat einen Einmalcode, den Tanooki Auth nicht lesen kann ($reason)';
  }

  @override
  String get importersNoSecret => 'hat kein Geheimnis';

  @override
  String get importersBadSecret => 'hat ein ungültiges Geheimnis';

  @override
  String importersUnsupportedDigits(int count) {
    return 'nutzt $count-stellige Codes, die Tanooki Auth nicht unterstützt';
  }

  @override
  String get importersBadPeriod => 'hat einen fehlerhaften Zeitraum';

  @override
  String importersUnsupportedAlgorithm(String algorithm) {
    return 'nutzt den Algorithmus $algorithm, den Tanooki Auth nicht unterstützt';
  }

  @override
  String get exportUiTitle => 'In eine andere App umziehen';

  @override
  String get exportUiAegisLocked => 'Aegis, mit Passwort';

  @override
  String get exportUiAegisLockedSub =>
      'Am sichersten. Aegis fragt beim Importieren nach dem Passwort.';

  @override
  String get exportUiAegisPlain => 'Aegis, unverschlüsselt';

  @override
  String get exportUiAegisPlainSub =>
      'Für Apps, die Aegis-Dateien lesen, aber keine gesperrten öffnen können.';

  @override
  String get exportUiTwoFasSub => 'Eine .2fas-Datei ohne Passwort.';

  @override
  String get exportUiGoogleSub =>
      'QR-Codes zum Scannen mit Google Authenticator.';

  @override
  String get exportUiLinks => 'Einrichtungslinks (Klartext)';

  @override
  String get exportUiLinksSub =>
      'Ein otpauth://-Link pro Zeile, für jede andere App.';

  @override
  String get exportUiConfirmReason => 'Deine Konten exportieren';

  @override
  String get exportUiEncryptingAegis => 'Wird für Aegis verschlüsselt…';

  @override
  String get exportUiAegisPlainWhat =>
      'Damit wird jeder Einrichtungsschlüssel in einer unverschlüsselten Aegis-Datei gespeichert.';

  @override
  String get exportUiTwoFasWhat =>
      'Damit wird jeder Einrichtungsschlüssel in einer 2FAS-Datei ohne Passwort gespeichert.';

  @override
  String get exportUiGoogleTitle =>
      'QR-Codes für Google Authenticator anzeigen?';

  @override
  String get exportUiGoogleBody =>
      'Der nächste Bildschirm zeigt QR-Codes mit jedem Einrichtungsschlüssel. Wer sie sieht oder fotografiert, kann deine Anmeldecodes erzeugen. Mach das an einem ungestörten Ort.\n\nIn Google Authenticator: Tippe auf +, dann „QR-Code scannen“, und scanne einen Code nach dem anderen.';

  @override
  String get exportUiShowCodes => 'Codes anzeigen';

  @override
  String exportUiExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Konten exportiert. Importiere die Datei in der anderen App und lösch sie dann.',
      one: '1 Konto exportiert. Importiere die Datei in der anderen App und lösch sie dann.',
    );
    return '$_temp0';
  }

  @override
  String get exportUiNoneForGoogle =>
      'Keines deiner Konten kann in Google Authenticator übernommen werden.';

  @override
  String get exportUiScanThisCode => 'Diesen Code scannen';

  @override
  String exportUiCodeOf(int n, int total) {
    return 'Code $n von $total';
  }

  @override
  String get exportUiNextCode => 'Nächster Code';

  @override
  String exportUiLeftOut(int count) {
    return 'Ausgelassen ($count). Google Authenticator kann diese Codes nicht erzeugen, füge sie also einer anderen App hinzu:';
  }

  @override
  String get appIconClassic => 'Klassisch';

  @override
  String get appIconPink => 'Pastellrosa';

  @override
  String get appIconBlue => 'Pastellblau';

  @override
  String get appIconLavender => 'Lavendel';

  @override
  String get appIconMint => 'Mint';

  @override
  String get appIconMidnight => 'Mitternacht';

  @override
  String get appIconSunset => 'Sonnenuntergang';

  @override
  String get appIconSpooky => 'Gruselig (Herbst)';

  @override
  String get appIconCozy => 'Gemütlich (Winter)';

  @override
  String get appIconSpring => 'Frühling';

  @override
  String get serverBrowserExtension => 'Browsererweiterung';

  @override
  String get serverBadRequest =>
      'Tanooki Auth hat diese Anfrage nicht verstanden.';

  @override
  String get serverLocked =>
      'Tanooki Auth ist gesperrt. Entsperre es und versuch es dann erneut.';

  @override
  String get serverNotPaired =>
      'Diese App ist nicht mit Tanooki Auth gekoppelt.';

  @override
  String get serverNotFound => 'Dieses Konto ist nicht mehr in Tanooki Auth.';

  @override
  String get serverRateLimited => 'Zu viele Anfragen.';

  @override
  String get serverDenied =>
      'Nicht erlaubt: Dieses Konto fragt zuerst nach, und Tanooki Auth wurde dafür nicht entsperrt.';

  @override
  String get serverUnknownScreen => 'Unbekannter Bildschirm.';

  @override
  String get serverNoWebsite => 'Keine Website angegeben.';

  @override
  String serverUnknownRequest(String type) {
    return 'Unbekannte Anfrage „$type“.';
  }

  @override
  String get serverPairingTimedOut =>
      'Die Kopplung ist abgelaufen oder wurde geschlossen. Starte die Kopplung neu.';

  @override
  String get serverThreeWrongCodes =>
      'Dreimal falscher Code. Starte die Kopplung neu.';

  @override
  String get serverWrongCode =>
      'Dieser Code stimmt nicht. Prüfe den Code, der in Tanooki Auth angezeigt wird.';

  @override
  String get serverNoLink => 'Es wurde kein otpauth://-Link gesendet.';

  @override
  String get serverAlreadyThere => 'Dieses Konto ist schon in Tanooki Auth.';

  @override
  String get serverAlreadyThereMany =>
      'Diese Konten sind schon in Tanooki Auth.';

  @override
  String get autoBackupNotSupported => 'auf diesem Gerät nicht unterstützt';

  @override
  String homeProveCopy(String name) {
    return 'Code für $name kopieren';
  }

  @override
  String homeProveReadAloud(String name) {
    return 'Code für $name vorlesen';
  }

  @override
  String homeProveEdit(String name) {
    return '$name bearbeiten';
  }

  @override
  String homeProveShare(String name) {
    return '$name teilen';
  }

  @override
  String homeCopied(String name) {
    return 'Code für $name kopiert. Die Zwischenablage wird in 30 Sekunden geleert.';
  }

  @override
  String get homeEditAccount => 'Konto bearbeiten';

  @override
  String homeShowQrFor(String name) {
    return 'QR-Code für $name anzeigen';
  }

  @override
  String homeMovedToTrash(String name) {
    return '$name wurde in den Papierkorb verschoben. Du kannst es 30 Tage lang in den Einstellungen wiederherstellen.';
  }

  @override
  String get homeUndo => 'Rückgängig';

  @override
  String homeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten',
      one: '1 Konto',
    );
    return '$_temp0';
  }

  @override
  String homeAddTagTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten mit einem Tag versehen',
      one: '1 Konto mit einem Tag versehen',
    );
    return '$_temp0';
  }

  @override
  String get homeTagHint => 'Tag (z. B. Arbeit)';

  @override
  String get homeAddTag => 'Tag hinzufügen';

  @override
  String homeTagged(int count, String tag) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten mit „$tag“ getaggt.',
      one: '1 Konto mit „$tag“ getaggt.',
    );
    return '$_temp0';
  }

  @override
  String homeMoveToFolderTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten in einen Ordner verschieben',
      one: '1 Konto in einen Ordner verschieben',
    );
    return '$_temp0';
  }

  @override
  String get homeNoFolder => 'Kein Ordner';

  @override
  String get homeNewFolderHint => 'Oder ein neuer Ordner (z. B. Arbeit)';

  @override
  String get homeMoveToNewFolder => 'In neuen Ordner verschieben';

  @override
  String homeTookOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten aus ihren Ordnern genommen.',
      one: '1 Konto aus seinem Ordner genommen.',
    );
    return '$_temp0';
  }

  @override
  String homeMovedTo(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten nach $folder verschoben.',
      one: '1 Konto nach $folder verschoben.',
    );
    return '$_temp0';
  }

  @override
  String homeAddedToFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten zu den Favoriten hinzugefügt.',
      one: '1 Konto zu den Favoriten hinzugefügt.',
    );
    return '$_temp0';
  }

  @override
  String homeRemovedFromFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten aus den Favoriten entfernt.',
      one: '1 Konto aus den Favoriten entfernt.',
    );
    return '$_temp0';
  }

  @override
  String homeBulkTrashed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Konten in den Papierkorb verschoben. Du kannst sie 30 Tage lang in den Einstellungen wiederherstellen.',
      one: '1 Konto in den Papierkorb verschoben. Du kannst es 30 Tage lang in den Einstellungen wiederherstellen.',
    );
    return '$_temp0';
  }

  @override
  String get homeDoneSelecting => 'Auswahl beenden';

  @override
  String get homeTapToSelect => 'Tippe auf Konten, um sie auszuwählen';

  @override
  String homeSelectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get homeSelectNone => 'Auswahl aufheben';

  @override
  String get homeSelectAll => 'Alle auswählen';

  @override
  String get homeAddATag => 'Tag hinzufügen';

  @override
  String get homeMoveToFolder => 'In Ordner verschieben';

  @override
  String get homeRemoveFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get homeAddToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get homeMoveToTrash => 'In den Papierkorb';

  @override
  String get homeSelectFirst =>
      'Wähle zuerst Konten aus: Tippe sie in der Liste an.';

  @override
  String homeSectionOpen(String name, String accounts) {
    return '$name, $accounts, tippen zum Einklappen';
  }

  @override
  String homeSectionClosed(String name, String accounts) {
    return '$name, $accounts, tippen zum Anzeigen';
  }

  @override
  String get homeSearchHint => 'Konten oder Websites suchen …';

  @override
  String get homeAllTags => 'Alle';

  @override
  String get homeNoAccountsYet =>
      'Noch keine Konten.\nFüge eins hinzu, um einen QR-Code zur Einrichtung zu scannen.';

  @override
  String get homeNoTagMatches => 'Keine Konten mit diesem Tag.';

  @override
  String get homeNoSearchMatches => 'Keine Konten passen zu deiner Suche.';

  @override
  String get homeSelectAccounts => 'Konten auswählen';

  @override
  String get homeSettings => 'Einstellungen';

  @override
  String get homeAddAccount => 'Konto hinzufügen';

  @override
  String get homeAccounts => 'Konten';

  @override
  String get homeYourAccounts => 'Deine Konten';

  @override
  String get homeSelect => 'Auswählen';

  @override
  String get homeKeysTouch =>
      'Tippen (Kopieren) · Eingabe (Kopieren) · Pfeile (Navigieren)';

  @override
  String get homeKeysClick =>
      'Klicken (Kopieren) · Eingabe (Kopieren) · Pfeile (Navigieren)';

  @override
  String get homePickOnLeft => 'Wähle links ein Konto, um es hier zu sehen.';

  @override
  String homeQrFor(String name) {
    return 'QR-Code für $name';
  }

  @override
  String get homeQrWarning =>
      'Scanne ihn mit einer anderen Authenticator-App, um dort dasselbe Konto hinzuzufügen. Wer ihn sieht oder fotografiert, kann deine Codes erzeugen, also halte ihn privat.';

  @override
  String homeVersionNote(Object version) {
    return 'v$version · bleibt auf diesem Gerät';
  }

  @override
  String homeSelectName(String name) {
    return '$name auswählen';
  }

  @override
  String get homeMore => 'Mehr';

  @override
  String get homeRecoveryCodes => 'Wiederherstellungscodes';

  @override
  String homeRecoveryCodesLeft(int count) {
    return 'Wiederherstellungscodes ($count übrig)';
  }

  @override
  String get homeShareSecurely => 'Sicher teilen';

  @override
  String get homeShowQr => 'QR-Code anzeigen';

  @override
  String get homeMoveEarlier => 'Nach oben';

  @override
  String get homeMoveLater => 'Nach unten';

  @override
  String homeNextCodeShort(String code) {
    return 'Nächster: $code';
  }

  @override
  String get homeNextCode => 'Nächster Code';

  @override
  String get homeFavorite => 'Favorit';

  @override
  String get homeCodeHiddenAsk =>
      'Code verborgen, bis du bestätigst, dass du es bist';

  @override
  String get homeCodeHidden => 'Code verborgen';

  @override
  String homeNextCodeSpoken(String code) {
    return 'Nächster Code $code';
  }

  @override
  String homeKindTotp(int count, int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ziffern',
      one: '1 Ziffer',
    );
    return 'TOTP · $_temp0 · $seconds s';
  }

  @override
  String homeKindSteam(int seconds) {
    return 'Steam · 5 Zeichen · $seconds s';
  }

  @override
  String homeKindHotp(int count, String counter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ziffern',
      one: '1 Ziffer',
    );
    return 'HOTP · $_temp0 · Nr. $counter';
  }

  @override
  String get homeAccountHeading => 'Konto';

  @override
  String get homeHintUnselect => 'abwählen';

  @override
  String get homeHintSelect => 'auswählen';

  @override
  String get homeHintCopy => 'Code kopieren';

  @override
  String get homeReadCodeAloud => 'Code vorlesen';

  @override
  String get homeMoreOptions => 'Weitere Optionen';

  @override
  String get mainPairRaycastTitle => 'Mit Raycast koppeln';

  @override
  String get mainPairRaycastBody => 'Gib diesen Code in Raycast ein:';

  @override
  String get mainPairRaycastWarning =>
      'Mach das nur, wenn du gerade selbst die Kopplung in Raycast gestartet hast.';

  @override
  String get mainPairAlfredTitle => 'Mit Alfred koppeln';

  @override
  String get mainPairAlfredBody =>
      'Gib 2fa-pair und diesen Code in Alfred ein:';

  @override
  String get mainPairAlfredWarning =>
      'Mach das nur, wenn du gerade selbst 2fa-pair in Alfred eingegeben hast.';

  @override
  String get mainPairPowerToysTitle => 'Mit PowerToys koppeln';

  @override
  String get mainPairPowerToysBody =>
      'Gib diesen Code in der PowerToys-Befehlspalette ein:';

  @override
  String get mainPairPowerToysWarning =>
      'Mach das nur, wenn du gerade selbst die Kopplung in PowerToys gestartet hast.';

  @override
  String get mainPairBrowserTitle => 'Mit deinem Browser koppeln';

  @override
  String get mainPairBrowserBody =>
      'Gib diesen Code in die Tanooki Auth-Browsererweiterung ein:';

  @override
  String get mainPairBrowserWarning =>
      'Mach das nur, wenn du gerade selbst in der Erweiterung auf „Koppeln“ geklickt hast.';

  @override
  String mainSendCodeTo(String name, String client) {
    return 'Code für $name an $client senden';
  }

  @override
  String mainWrongPasscodeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Falscher Code. Noch $count Fehlversuche löschen alles.',
      one: 'Falscher Code. Noch 1 Fehlversuch löscht alles.',
    );
    return '$_temp0';
  }

  @override
  String get mainWrongPasscode => 'Falscher Code.';

  @override
  String get mainBiometricWindows => 'Windows Hello';

  @override
  String get mainBiometricMac => 'Touch ID';

  @override
  String get mainBiometricOther => 'Face ID oder Fingerabdruck';

  @override
  String get mainLockTitle => 'Tanooki Auth sperren?';

  @override
  String get mainLockBody =>
      'Beim Öffnen der App nach Gesicht, Fingerabdruck oder Code fragen, damit niemand mit deinem entsperrten Telefon deine Codes lesen kann. Du kannst das später in den Einstellungen ändern.';

  @override
  String get mainTurnOnLock => 'Sperre einschalten';

  @override
  String get mainUnlockReason => 'Tanooki Auth entsperren';

  @override
  String get mainStartOverTitle => 'Einen neuen, leeren Tresor anlegen?';

  @override
  String get mainStartOverBody =>
      'Das ersetzt dauerhaft alles, was von deinen alten Konten übrig ist. Mach das nur, wenn du kein Backup zum Wiederherstellen hast oder die Zwei-Faktor-Anmeldung auf diesen Websites schon ausgeschaltet hast.';

  @override
  String get mainEraseStartOver => 'Löschen und neu beginnen';

  @override
  String get mainRestoreFromBackup => 'Aus Backup wiederherstellen';

  @override
  String get mainStartNewVault => 'Neuen, leeren Tresor anlegen';

  @override
  String get mainLocked => 'Tanooki Auth ist gesperrt';

  @override
  String mainUseBiometric(String method) {
    return '$method verwenden';
  }

  @override
  String get mainUseSecurityKey => 'Sicherheitsschlüssel verwenden';

  @override
  String homeHidesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wird in $count Sekunden ausgeblendet',
      one: 'Wird in 1 Sekunde ausgeblendet',
    );
    return '$_temp0';
  }

  @override
  String homeCardsMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      'm1': 'Januar',
      'm2': 'Februar',
      'm3': 'März',
      'm4': 'April',
      'm5': 'Mai',
      'm6': 'Juni',
      'm7': 'Juli',
      'm8': 'August',
      'm9': 'September',
      'm10': 'Oktober',
      'm11': 'November',
      'm12': 'Dezember',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String homeCardsDay(String month, String day) {
    return '$day. $month';
  }

  @override
  String get homeCardsDenied =>
      'Abgelehnt. Die Person kann deine Konten nicht öffnen. Sie kann später erneut anfragen, und du wirst wieder gefragt.';

  @override
  String get homeCardsClockRight =>
      'Deine Uhr stimmt jetzt. Die Codes sollten funktionieren.';

  @override
  String get homeCardsCheckAgain => 'Erneut prüfen';

  @override
  String get homeCardsYourContact => 'Dein Notfallkontakt';

  @override
  String homeCardsEmergencyWaiting(String who, String left, String day) {
    return '$who hat Notfallzugriff auf deine Konten angefragt. Wenn du nicht ablehnst, kann die Kopie in $left ($day) geöffnet werden.';
  }

  @override
  String homeCardsEmergencyReleased(String who) {
    return '$who hat Notfallzugriff angefragt und die 7-tägige Wartezeit ist vorbei, also kann jetzt eine Kopie deiner Konten geöffnet werden. Lehne ab, um das zu verhindern.';
  }

  @override
  String get homeCardsBackupNudge =>
      'Deine Konten haben sich seit dem letzten Backup geändert. Mit einer Backup-Datei bekommst du sie zurück, wenn dieses Gerät verloren geht.';

  @override
  String get homeCardsBackUpNow => 'Jetzt sichern';

  @override
  String homeCardsSummaryNew(int count, String month) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deine Übersicht für $month: $count neue Konten.',
      one: 'Deine Übersicht für $month: 1 neues Konto.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryNoBackup => 'Noch kein Backup.';

  @override
  String homeCardsSummaryLastBackup(String day) {
    return 'Letztes Backup: $day.';
  }

  @override
  String get homeCardsSummaryAllCodes =>
      'Jedes Konto hat Wiederherstellungscodes.';

  @override
  String homeCardsSummaryMissingCodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Konten ohne Wiederherstellungscodes.',
      one: '1 Konto ohne Wiederherstellungscodes.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryCheckupGood =>
      'Sicherheitscheck: alles in Ordnung.';

  @override
  String homeCardsSummaryCheckupFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sicherheitscheck: $count Sachen zu beheben.',
      one: 'Sicherheitscheck: 1 Sache zu beheben.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsOpenCheckup => 'Check öffnen';

  @override
  String get quickPickSelf =>
      'Tanooki Auth war noch im Vordergrund, deshalb wurde nichts eingegeben. Klicke in das Feld, das du ausfüllen willst, und nutze dann erneut das Symbol in der Menüleiste.';

  @override
  String quickPickTypeFailed(String reason) {
    return 'Der Code konnte nicht eingegeben werden ($reason). Kopier ihn stattdessen.';
  }

  @override
  String get quickPickTypeUnavailable =>
      'Codes eintippen ist auf diesem Computer nicht verfügbar. Kopier ihn stattdessen.';

  @override
  String quickPickUseCodeFor(String name) {
    return 'Code für $name verwenden';
  }

  @override
  String get quickPickAllowTitle => 'Tanooki Auth das Tippen erlauben';

  @override
  String get quickPickAllowBody =>
      'Um einen Code in eine andere App einzutippen, muss dein Mac Tanooki Auth erlauben, Tasten für dich zu drücken.\n\n1. Klicke unten auf „Systemeinstellungen öffnen“.\n2. Du siehst eine Liste namens Bedienungshilfen. Such Tanooki Auth und schalte den Schalter ein (blau).\n3. Wenn dein Mac nach Passwort oder Touch ID fragt, gib es ein.\n4. Komm hierher zurück und klicke erneut auf Eintippen.\n\nTanooki Auth drückt nur Tasten, wenn du auf Eintippen klickst, und tippt nur den Code.';

  @override
  String get quickPickOpenSystemSettings => 'Systemeinstellungen öffnen';

  @override
  String get quickPickTitle => 'Schnellauswahl';

  @override
  String get quickPickSearch => 'Konten suchen';

  @override
  String get quickPickLinuxNote =>
      'Codes in andere Apps eintippen ist unter Linux nicht verfügbar. Klicke auf ein Konto, um seinen Code zu kopieren.';

  @override
  String get quickPickNoMatches => 'Keine passenden Konten';

  @override
  String get quickPickAsksFirst => '••• •••  (fragt zuerst)';

  @override
  String get quickPickHiddenAsks => 'Code verborgen, fragt zuerst';

  @override
  String get quickPickType => 'Eintippen';

  @override
  String get codeViewRing => 'Ring';

  @override
  String get codeViewBar => 'Balken';

  @override
  String get codeViewNumber => 'Zahl';

  @override
  String codeViewSpoken(String code) {
    return 'Code $code';
  }

  @override
  String codeViewSpokenLeft(int count, String code) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Code $code, noch $count Sekunden',
      one: 'Code $code, noch 1 Sekunde',
    );
    return '$_temp0';
  }

  @override
  String get codeViewReadAloud => 'Code vorlesen';

  @override
  String codeViewSecondsShort(int count) {
    return '$count s';
  }

  @override
  String get codeViewColorBlue => 'Blau';

  @override
  String get codeViewColorPurple => 'Lila';

  @override
  String get codeViewColorPink => 'Rosa';

  @override
  String get codeViewColorRed => 'Rot';

  @override
  String get codeViewColorOrange => 'Orange';

  @override
  String get codeViewColorGold => 'Gold';

  @override
  String get codeViewColorGreen => 'Grün';

  @override
  String get codeViewColorTeal => 'Petrol';

  @override
  String get codeViewColorGray => 'Grau';

  @override
  String trashRestored(String name) {
    return '$name ist wieder in deiner Liste.';
  }

  @override
  String trashDeleteTitle(String name) {
    return '$name endgültig löschen?';
  }

  @override
  String get trashDeleteBody =>
      'Das lässt sich nicht rückgängig machen. Schalte vor dem Löschen die Zwei-Faktor-Anmeldung auf dieser Website aus oder stell sicher, dass du ihre Wiederherstellungscodes hast, sonst könntest du ausgesperrt werden.';

  @override
  String get trashDeleteForGood => 'Endgültig löschen';

  @override
  String get trashTitle => 'Papierkorb';

  @override
  String get trashEmpty =>
      'Der Papierkorb ist leer.\nGelöschte Konten bleiben hier 30 Tage.';

  @override
  String get trashNote =>
      'Gelöschte Konten bleiben hier 30 Tage und werden dann endgültig entfernt.';

  @override
  String get trashRemovedNextOpen =>
      'Wird beim nächsten Öffnen der App entfernt';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Tage',
      one: 'Noch 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => 'Wiederherstellen';

  @override
  String get recoveryAddTitle => 'Wiederherstellungscodes hinzufügen';

  @override
  String get recoveryPasteHint =>
      'Füge die Codes der Website ein, einen pro Zeile';

  @override
  String get recoveryNoneNew =>
      'In deinem eingefügten Text wurden keine neuen Codes gefunden.';

  @override
  String recoveryAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Codes hinzugefügt.',
      one: '1 Code hinzugefügt.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryCopiedUsed =>
      'Kopiert. Achtung: Du hast diesen Code als benutzt markiert, er funktioniert also wahrscheinlich nicht mehr.';

  @override
  String get recoveryCopied =>
      'Kopiert. Die Zwischenablage wird in 30 Sekunden geleert. Markiere ihn als benutzt, sobald du angemeldet bist.';

  @override
  String get recoveryRemoveTitle => 'Diesen Code entfernen?';

  @override
  String recoveryRemoveBody(String code) {
    return '$code\n\nEntferne ihn nur, wenn die Website ihn nicht mehr akzeptiert.';
  }

  @override
  String recoveryTitle(String name) {
    return 'Wiederherstellungscodes für $name';
  }

  @override
  String get recoveryAddCodes => 'Codes hinzufügen';

  @override
  String get recoveryIntro =>
      'Wenn du die Zwei-Faktor-Anmeldung einschaltest, geben dir die meisten Websites auch eine Liste mit Backup-Codes. Jeder bringt dich einmal hinein, falls du diese App verlierst. Füge sie hier ein, damit sie sicher beim Konto liegen.';

  @override
  String recoveryUnusedOf(String unused, int total) {
    return '$unused von $total unbenutzt. Tippe auf einen Code, um ihn zu kopieren, und hak ihn ab, wenn du ihn benutzt hast.';
  }

  @override
  String get recoveryUsed => 'Benutzt';

  @override
  String get detailsEditAccount => 'Konto bearbeiten';

  @override
  String get detailsCopyCode => 'Code kopieren';

  @override
  String get detailsReadAloud => 'Vorlesen';

  @override
  String get detailsFolderAndTags => 'Ordner und Tags';

  @override
  String get detailsWebsites => 'Websites';

  @override
  String get detailsNotes => 'Notizen';

  @override
  String get detailsNotesHidden =>
      'Verborgen, bis du bestätigst, dass du es bist.';

  @override
  String get detailsNoNotes =>
      'Keine Notizen. Füge welche mit Bearbeiten hinzu.';

  @override
  String get accountSortCustom => 'Eigene (zum Anordnen ziehen)';

  @override
  String get accountSortRecent => 'Zuletzt verwendet';

  @override
  String get accountSortName => 'A bis Z';

  @override
  String get activityCopied => 'Kopiert';

  @override
  String get activityFilled => 'Ausgefüllt';

  @override
  String get activityTyped => 'Eingetippt';

  @override
  String get activityShownQr => 'QR-Code gezeigt';

  @override
  String get activityExported => 'Exportiert';

  @override
  String totpBadCharacter(String char) {
    return 'Kein gültiges Base32-Geheimnis (ungültiges Zeichen „$char“)';
  }

  @override
  String get totpEmpty => 'Das Geheimnis ist leer';

  @override
  String get vaultFileMissing =>
      'Deine Kontendatei fehlt. Wenn du ein Backup hast, stell es wieder her. Andernfalls kannst du einen neuen, leeren Tresor anlegen.';

  @override
  String get vaultKeyMissing =>
      'Der Schlüssel, der deine Konten entsperrt, fehlt im sicheren Speicher dieses Geräts. Stell ein Backup wieder her, um deine Konten zurückzubekommen.';

  @override
  String get vaultDecryptFailed =>
      'Deine Kontendatei konnte nicht entsperrt werden. Sie ist vielleicht beschädigt oder wurde außerhalb der App geändert. Stell ein Backup wieder her.';

  @override
  String get vaultBadJson =>
      'Deine Kontendatei wurde entsperrt, aber ihr Inhalt ist beschädigt. Stell ein Backup wieder her.';

  @override
  String clockCheckBadAnswer(String status) {
    return 'Der Zeitserver hat eine Antwort geschickt, die die App nicht versteht (HTTP $status).';
  }

  @override
  String clockCheckOff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Die Uhr deines Geräts geht etwa $count Minuten falsch, deshalb funktionieren die Codes nicht. Schalte in den Einstellungen die automatische Uhrzeit ein.',
      one: 'Die Uhr deines Geräts geht etwa 1 Minute falsch, deshalb funktionieren die Codes nicht. Schalte in den Einstellungen die automatische Uhrzeit ein.',
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
}
