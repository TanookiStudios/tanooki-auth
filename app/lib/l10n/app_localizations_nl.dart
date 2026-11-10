// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get commonCancel => 'Annuleren';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRemove => 'Verwijderen';

  @override
  String get commonUnlock => 'Ontgrendelen';

  @override
  String get commonTurnOff => 'Uitzetten';

  @override
  String get commonNotNow => 'Niet nu';

  @override
  String get commonNext => 'Volgende';

  @override
  String get commonDone => 'Klaar';

  @override
  String get commonDeny => 'Weigeren';

  @override
  String get commonAllow => 'Toestaan';

  @override
  String get commonTryAgain => 'Opnieuw proberen';

  @override
  String get commonStop => 'Stoppen';

  @override
  String get commonShare => 'Delen';

  @override
  String get commonOpen => 'Openen';

  @override
  String get commonCopy => 'Kopiëren';

  @override
  String get commonContinueLabel => 'Doorgaan';

  @override
  String get commonClear => 'Wissen';

  @override
  String get commonBack => 'Terug';

  @override
  String get commonAdd => 'Toevoegen';

  @override
  String get commonSave => 'Bewaren';

  @override
  String get commonDelete => 'Verwijderen';

  @override
  String get commonClose => 'Sluiten';

  @override
  String get commonEdit => 'Bewerken';

  @override
  String get commonYes => 'Ja';

  @override
  String get commonNo => 'Nee';

  @override
  String get commonSeePremium => 'Bekijk Premium';

  @override
  String get commonPremiumBadge => 'Premium';

  @override
  String get commonAppName => 'Tanooki Auth';

  @override
  String get googleMigrationUnreadable =>
      'Die Google Authenticator-code kon niet worden gelezen.';

  @override
  String get googleMigrationDamaged =>
      'Die Google Authenticator-code is beschadigd.';

  @override
  String get googleMigrationEmpty =>
      'Er staan geen accounts in die Google Authenticator-code.';

  @override
  String get googleMigrationNoSecret =>
      'Een account in die code heeft geen geheime sleutel.';

  @override
  String get googleMigrationMd5 =>
      'Een account in die code gebruikt MD5, en dat ondersteunt Tanooki Auth niet.';

  @override
  String get googleCantTakeSteam => 'Steam-codes';

  @override
  String googleCantTakeDigits(int digits) {
    return 'codes van $digits cijfers';
  }

  @override
  String googleCantTakePeriod(int seconds) {
    return 'codes die elke $seconds seconden veranderen';
  }

  @override
  String get otpauthNotALink => 'Dat is geen otpauth://-link.';

  @override
  String get otpauthNoSecret => 'De link heeft geen geheime sleutel.';

  @override
  String otpauthUnsupportedType(String type) {
    return 'Codetype \"$type\" wordt niet ondersteund.';
  }

  @override
  String otpauthUnsupportedAlgorithm(String algorithm) {
    return 'Algoritme \"$algorithm\" wordt niet ondersteund.';
  }

  @override
  String get otpauthBadDigits => 'Het aantal cijfers moet 6, 7 of 8 zijn.';

  @override
  String get otpauthBadPeriod => 'De periode moet een positief getal zijn.';

  @override
  String get otpauthBadCounter => 'De teller moet nul of hoger zijn.';

  @override
  String get phoneLinkNotAPairingCode =>
      'Dat is geen koppelcode voor een browser van Tanooki Auth.';

  @override
  String phoneLinkNotSavedFor(String host) {
    return 'Dat account is niet bewaard voor $host.';
  }

  @override
  String get phoneLinkPushNotSetUp =>
      'Meldingen zijn nog niet ingesteld op de Tanooki Auth-server, dus verzoeken verschijnen alleen terwijl de app open is.';

  @override
  String phoneLinkPushFailed(int status) {
    return 'Kon meldingen niet aanzetten (HTTP $status).';
  }

  @override
  String get qrImageNotAPicture =>
      'Dat bestand is geen afbeelding die deze app kan lezen.';

  @override
  String get qrImageNoQr => 'Geen QR-code gevonden in die afbeelding.';

  @override
  String relayBadAnswer(int status) {
    return 'De syncserver stuurde een antwoord dat de app niet begrijpt (HTTP $status).';
  }

  @override
  String get relayUnreachable =>
      'Kan de syncserver niet bereiken. Controleer je internetverbinding.';

  @override
  String get relayTimeout =>
      'De syncserver antwoordde niet op tijd. Controleer je internetverbinding.';

  @override
  String get relayInsecure =>
      'Kon geen beveiligde verbinding maken met de syncserver.';

  @override
  String relaySaidNo(int status) {
    return 'De syncserver weigerde (HTTP $status).';
  }

  @override
  String get shareNotAShare => 'Dat is geen gedeeld account van Tanooki Auth.';

  @override
  String get shareExpired =>
      'Deze deellink is verlopen (ze blijven maar 24 uur geldig). Vraag om een nieuwe.';

  @override
  String get shareWrongCode =>
      'Verkeerde code, of het gedeelde account is beschadigd. Controleer de 6 cijfers en probeer het opnieuw.';

  @override
  String get storeServerUnreachable =>
      'Kan de Tanooki Auth-server niet bereiken. Controleer je internetverbinding en probeer het opnieuw.';

  @override
  String get storeBadKey =>
      'De server stuurde een licentiesleutel die deze app niet accepteert.';

  @override
  String storeReportedProblem(String problem) {
    return 'De store meldde een probleem: $problem';
  }

  @override
  String get storeGooglePlayUnavailable =>
      'Google Play is niet beschikbaar op dit apparaat, dus je kunt Premium hier niet kopen. Heb je Premium ergens anders gekocht? Vul dan hieronder je licentiesleutel in.';

  @override
  String get storeAppStoreUnavailable =>
      'De App Store is nu niet beschikbaar. Controleer je internetverbinding en probeer het opnieuw.';

  @override
  String storeNotListed(String store) {
    return 'De $store toonde Premium net niet. Probeer het straks opnieuw.';
  }

  @override
  String storeNotListedWithError(String store, String problem) {
    return 'De $store toonde Premium net niet ($problem). Probeer het straks opnieuw.';
  }

  @override
  String storePricesFailed(String problem) {
    return 'Kon de prijzen niet laden uit de store: $problem';
  }

  @override
  String storePurchaseCouldNotStart(String problem) {
    return 'De aankoop kon niet starten: $problem';
  }

  @override
  String storeNothingToRestore(String store) {
    return 'Geen Premium-aankoop gevonden voor dit $store-account.';
  }

  @override
  String storeRestoreFailed(String problem) {
    return 'Kon aankopen niet herstellen: $problem';
  }

  @override
  String get storePending =>
      'Wachten tot de betaling is goedgekeurd. Premium wordt ontgrendeld zodra dat zo is.';

  @override
  String get storeCanceled => 'Aankoop geannuleerd. Er is niets afgeschreven.';

  @override
  String storeFailed(String problem) {
    return 'De aankoop is niet gelukt: $problem. Er is niets afgeschreven.';
  }

  @override
  String get storeFailedNoReason =>
      'De aankoop is niet gelukt: de store gaf geen reden. Er is niets afgeschreven.';

  @override
  String get storeUnlocked => 'Premium ontgrendeld. Heel erg bedankt!';

  @override
  String get storeUnlockedWithKey =>
      'Premium ontgrendeld. Hieronder staat je licentiesleutel voor je computers.';

  @override
  String storeUnlockedKeyFailed(String problem) {
    return 'Premium is ontgrendeld op dit apparaat. De sleutel voor je computers kon nog niet worden gemaakt: $problem Tik later op Aankopen herstellen om het opnieuw te proberen.';
  }

  @override
  String storeServerSaidNo(int status) {
    return 'De server weigerde (HTTP $status).';
  }

  @override
  String get syncGroupExists =>
      'Er bestaat al een syncgroep met deze wachtwoordzin. Tik op een apparaat dat al synchroniseert op \"Apparaat toevoegen\" en scan in plaats daarvan die code.';

  @override
  String get syncNotASyncCode =>
      'Dat is geen synccode van Tanooki Auth. Open op een apparaat dat al synchroniseert Instellingen, Synchronisatie, Apparaat toevoegen.';

  @override
  String get syncWrongPassphrase =>
      'Die wachtwoordzin komt niet overeen met die van je andere apparaten. Controleer hem en probeer het opnieuw.';

  @override
  String get syncICloudOtherPassphrase =>
      'Je andere Apple-apparaten synchroniseren met een andere wachtwoordzin. Typ die, of begin opnieuw met deze.';

  @override
  String get syncErrorRemoved =>
      'Dit apparaat is op een ander apparaat uit de synchronisatie gehaald. Zet sync uit en weer aan om opnieuw mee te doen.';

  @override
  String get syncErrorTurnedOff =>
      'Sync is op een ander apparaat uitgezet. Zet het hier ook uit en daarna weer aan om opnieuw te beginnen.';

  @override
  String get syncErrorTooOften =>
      'Er wordt te vaak gesynchroniseerd. Over een paar minuten wordt het opnieuw geprobeerd.';

  @override
  String get syncErrorLimit =>
      'Je hebt de synclimiet bereikt (2.000 accounts, verwijderde meegeteld).';

  @override
  String syncErrorICloud(String problem) {
    return 'iCloud Drive had een probleem: $problem.';
  }

  @override
  String syncErrorUnexpected(String problem) {
    return 'Sync is gestopt door een onverwacht probleem: $problem';
  }

  @override
  String get syncICloudAppleOnly =>
      'iCloud werkt alleen op iPhone, iPad en Mac.';

  @override
  String get syncICloudSignedOut =>
      'iCloud Drive staat uit op dit apparaat. Log in bij iCloud en zet iCloud Drive aan in Instellingen om het te gebruiken.';

  @override
  String get syncICloudNotInBuild =>
      'iCloud-sync staat in deze versie van Tanooki Auth nog niet aan. Gebruik voorlopig de Tanooki-relay; die werkt op elk apparaat.';

  @override
  String get teamKeyUnopenable =>
      'De teamsleutel die naar dit apparaat is gestuurd, kon niet worden geopend. Vraag de teambeheerder om dit apparaat te verwijderen en opnieuw uit te nodigen.';

  @override
  String get teamNotAnInvite =>
      'Dat is geen teamuitnodiging van Tanooki Auth. Vraag de teambeheerder om een nieuwe uitnodigingslink of QR-code.';

  @override
  String get teamNotInTeam => 'Dit apparaat zit niet in een team.';

  @override
  String get teamDeletedByAdmin => 'Dit team is verwijderd door de beheerder.';

  @override
  String get teamDeviceRemoved => 'Dit apparaat is uit het team verwijderd.';

  @override
  String get teamAlreadyInTeam => 'Dit apparaat zit al in een team.';

  @override
  String get teamNotALicense =>
      'Dat is geen teamlicentie. Die begint met TT1. en staat op de pagina die Stripe toont nadat je een abonnement hebt genomen.';

  @override
  String get teamAlreadyInTeamLeaveFirst =>
      'Dit apparaat zit al in een team. Verlaat dat eerst.';

  @override
  String get teamGone =>
      'Dat team bestaat niet meer. Vraag de teambeheerder om een nieuwe uitnodiging.';

  @override
  String get teamInviteUsed =>
      'Die uitnodiging is al gebruikt of verlopen (ze zijn 7 dagen geldig en werken één keer). Vraag de teambeheerder om een nieuwe.';

  @override
  String get teamFull =>
      'Dat team is vol (10 mensen). De beheerder moet eerst iemand verwijderen.';

  @override
  String get aboutTitle => 'Over Maddie';

  @override
  String get aboutP1 =>
      'Ik ben Maddie, een autistische developer die er misschien iets te veel om geeft dat de kleine dingen kloppen.';

  @override
  String get aboutP2 =>
      'Ik geloof sterk in privacy. De sleutels die je accounts beschermen zijn ongeveer de meest persoonlijke gegevens die er zijn, dus Tanooki Auth bewaart ze versleuteld op je eigen apparaat. Geen account, geen advertenties, geen tracking, en er wordt nooit iets naar mij gestuurd.';

  @override
  String get aboutP3 =>
      'Tanooki Auth is gratis, en dat wil ik graag zo houden. Jouw steun maakt het mogelijk dat ik gratis privacy-apps zoals deze blijf maken. Bevalt Tanooki Auth je, dan vind je de rest misschien ook wat — die staan op madilynthomas.com.';

  @override
  String get aboutP4 =>
      'Dus, van mij aan jou: dank je wel. Je gebruikt niet zomaar een app — je maakt deze hele manier van leven mogelijk.';

  @override
  String get aboutSupportAddress =>
      'Steun mijn werk: tanookistudios.com/support';

  @override
  String get aboutSupport => 'Steun mijn werk';

  @override
  String get aboutCredits => 'Credits';

  @override
  String get aboutCreditsBody =>
      'QR-codes worden gelezen met jsQR (Apache 2.0) in de browserextensie en ZXing in de app. Niet verbonden aan Google, Twilio of Authy; Google Authenticator is een handelsmerk van Google LLC.';

  @override
  String get addFromBrowserOne => 'Toevoegen vanuit je browser?';

  @override
  String addFromBrowserMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts toevoegen vanuit je browser?',
      one: '1 account toevoegen vanuit je browser?',
    );
    return '$_temp0';
  }

  @override
  String get addFromGoogleTransfer =>
      'Uit een overzetcode van Google Authenticator:';

  @override
  String addCount(int count) {
    return '$count toevoegen';
  }

  @override
  String get addNoColor => 'Geen kleur';

  @override
  String addColorName(String name) {
    return 'Kleur $name';
  }

  @override
  String get addServiceLabel => 'Dienst (bijv. GitHub)';

  @override
  String get addAccountLabel => 'Account (bijv. je e-mailadres)';

  @override
  String get addWebsiteLabel => 'Website (optioneel)';

  @override
  String get addWebsiteHelp =>
      'bijv. github.com. De browserextensie vult codes alleen hier in.';

  @override
  String get addTagsLabel => 'Tags (optioneel)';

  @override
  String get addTagsHelp => 'bijv. werk, games. Scheid met komma\'s.';

  @override
  String get addFolderLabel => 'Map (optioneel)';

  @override
  String get addFolderHelp => 'bijv. Werk. Laat leeg voor geen map.';

  @override
  String get addPickFolder => 'Kies een map';

  @override
  String get addNoFolder => 'Geen map';

  @override
  String get addNotesLabel => 'Notities (optioneel)';

  @override
  String get addColorLabel => 'Kleur (optioneel)';

  @override
  String get addEmojiLabel => 'Emoji (optioneel)';

  @override
  String get addEmojiHelp =>
      'Wordt getoond in plaats van het logo, hier en op widgets en het horloge.';

  @override
  String addUseEmoji(String emoji) {
    return '$emoji gebruiken';
  }

  @override
  String addRequireAuth(String proof) {
    return 'Vraag om $proof voordat deze code wordt getoond';
  }

  @override
  String get addRequireAuthHelp =>
      'De code blijft verborgen in de lijst, en widgets, het horloge en Snelkeuze tonen hem nooit.';

  @override
  String get addTravelHide => 'Verbergen in reismodus';

  @override
  String get addTravelHidePremium => 'Verbergen in reismodus (Premium)';

  @override
  String get addTravelHideHelp =>
      'Als reismodus aanstaat (Instellingen), verdwijnt dit account uit de app tot je hem weer uitzet.';

  @override
  String get addTravelNeedsPremium =>
      'Reismodus hoort bij Premium. Haal het via Instellingen > Premium kopen.';

  @override
  String get addAdvanced => 'Geavanceerd';

  @override
  String get addAdvancedExisting =>
      'Wijzig deze alleen als de website dat zegt. Verkeerde instellingen geven verkeerde codes, en de website weigert ze dan.';

  @override
  String get addAdvancedNew =>
      'De meeste websites gebruiken de normale instellingen. Wijzig deze alleen als de website dat zegt.';

  @override
  String get addType => 'Type';

  @override
  String get addTypeTotp => 'Op tijd gebaseerd (normaal)';

  @override
  String get addTypeHotp =>
      'Op teller gebaseerd (nieuwe code als je erom vraagt)';

  @override
  String get addDigits => 'Cijfers';

  @override
  String get addAlgorithm => 'Algoritme';

  @override
  String get addSha1Normal => 'SHA-1 (normaal)';

  @override
  String get addPeriod => 'Nieuwe code elke';

  @override
  String addSeconds(int seconds) {
    return '$seconds seconden';
  }

  @override
  String get addCounter => 'Teller';

  @override
  String get addCounterHelp => 'Hoeveel codes er tot nu toe zijn gebruikt';

  @override
  String get addNotASharedFile =>
      'Dat bestand is geen gedeeld account van Tanooki Auth. Vraag de persoon om het opnieuw te delen.';

  @override
  String addAlreadyInList(String name) {
    return '$name staat al in je lijst.';
  }

  @override
  String get addThisAccount => 'Dit account toevoegen?';

  @override
  String get addNoCameraWindows =>
      'Windows kan in Tanooki Auth geen camera gebruiken. Open een afbeelding van de QR-code of plak de instellink.';

  @override
  String get addFromGoogle => 'Overzetten vanuit Google Authenticator';

  @override
  String get addFromGoogleSteps =>
      'Op het apparaat met Google Authenticator:\n\n1. Open Google Authenticator.\n2. Tik op het menu (☰ of ⋮), dan op \"Accounts overzetten\" en dan op \"Accounts exporteren\".\n3. Kies de accounts en tik op Volgende. Je ziet een QR-code.\n\nScan die QR-code dan hier. Zie je meerdere QR-codes, scan ze dan allemaal.';

  @override
  String get addScan => 'Scannen';

  @override
  String get addOpenPicture => 'Afbeelding openen';

  @override
  String get addLookingOnScreen => 'Zoeken naar een QR-code op je scherm…';

  @override
  String get addScreenNoQr =>
      'Geen QR-code gevonden op je scherm. Zorg dat de hele code zichtbaar is en niet onder een ander venster zit, en probeer het opnieuw.';

  @override
  String get addScreenUnsupported =>
      'Het scherm scannen kan pas vanaf macOS 14 (Sonoma). Maak een screenshot en gebruik \"Open een afbeelding\".';

  @override
  String get addScreenFailed =>
      'Kon geen afbeelding van het scherm maken. Maak een screenshot en gebruik \"Open een afbeelding\".';

  @override
  String get addScreenWrongQr =>
      'Er staat een QR-code op je scherm, maar het is geen code om tweestapsverificatie in te stellen.';

  @override
  String get addScreenPermissionTitle => 'Laat Tanooki Auth je scherm zien';

  @override
  String get addScreenPermissionSteps =>
      'Om een QR-code van je scherm te lezen, moet je Mac Tanooki Auth toestaan er een afbeelding van te maken. Tanooki Auth kijkt alleen als je op \"Scan mijn scherm\" drukt, en de afbeelding verlaat deze Mac nooit.\n\n1. Open Systeeminstellingen (het tandwiel in het Dock, of Apple-menu > Systeeminstellingen).\n2. Klik in de linkerkolom op \"Privacy en beveiliging\".\n3. Klik op \"Scherm- en systeemaudio-opname\".\n4. Zet de schakelaar naast Tanooki Auth aan. Staat het er niet tussen, klik dan op +, kies Tanooki Auth in Apps en zet het aan.\n5. Je Mac vraagt om Tanooki Auth te stoppen. Klik op \"Stop en open opnieuw\" en druk dan weer op \"Scan mijn scherm\".';

  @override
  String get addPasteLinksTitle => 'Instellinks plakken';

  @override
  String get addPasteLinksHint =>
      'otpauth://totp/...\nEén link per regel. Je kunt er veel tegelijk plakken.';

  @override
  String addManyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts toevoegen?',
      one: '1 account toevoegen?',
    );
    return '$_temp0';
  }

  @override
  String addManyBadLines(int count) {
    return '$count regel(s) kunnen niet worden gebruikt; je ziet straks welke.';
  }

  @override
  String get addEnterKey => 'Instelsleutel invoeren';

  @override
  String get addSetupKey => 'Instelsleutel';

  @override
  String get addSetupKeyHelp => 'De letters en cijfers die de website toont';

  @override
  String get addBadKey =>
      'Die instelsleutel is niet geldig. Hij mag alleen letters A–Z en cijfers 2–7 bevatten.';

  @override
  String get addTitle => 'Account toevoegen';

  @override
  String get addScanQr => 'QR-code scannen';

  @override
  String get addScanQrHelp => 'Richt de camera op de code die de website toont';

  @override
  String addNoCameraOn(String platform) {
    return 'Geen camera-ondersteuning op $platform';
  }

  @override
  String get addScanScreen => 'Scan mijn scherm';

  @override
  String get addScanScreenHelp =>
      'Leest een QR-code die ergens op je scherm staat';

  @override
  String get addScanScreenLinux =>
      'Nog niet beschikbaar op Linux. Open in plaats daarvan een screenshot van de QR-code.';

  @override
  String get addFromPhotos => 'Scan een QR-code uit je foto\'s';

  @override
  String get addFromPicture => 'Open een afbeelding van een QR-code';

  @override
  String get addFromPhotosHelp => 'Kies een screenshot van de instelpagina';

  @override
  String get addFromPictureHelp => 'Een screenshot van de instelpagina werkt';

  @override
  String get addPasteLink => 'Instellink plakken';

  @override
  String get addPasteLinkHelp =>
      'Links die beginnen met otpauth://, één of meer';

  @override
  String get addOpenShared => 'Een gedeeld account openen';

  @override
  String addOpenSharedHelp(String extension) {
    return 'Een .$extension-bestand dat iemand je stuurde';
  }

  @override
  String get addFromGoogleHelp => 'Zet al je accounts in één keer over';

  @override
  String get addFromOtherApp => 'Overzetten vanuit een andere app';

  @override
  String get addFromOtherAppHelp =>
      'Aegis, 2FAS, Authy, Bitwarden, 1Password, Apple Wachtwoorden, Microsoft';

  @override
  String get addEnterKeyHelp =>
      'Typ de sleutel onder \"kun je de code niet scannen?\"';

  @override
  String get addWrongQr =>
      'Die QR-code is geen code om tweestapsverificatie in te stellen.';

  @override
  String get addCameraDenied =>
      'Tanooki Auth mag de camera niet gebruiken. Zet cameratoegang voor Tanooki Auth aan in de instellingen van je apparaat, of ga terug en gebruik een afbeelding of de instelsleutel.';

  @override
  String addCameraFailed(String problem) {
    return 'De camera kon niet starten ($problem). Ga terug en gebruik een afbeelding of de instelsleutel.';
  }

  @override
  String get helpNew030a =>
      'Stapsgewijze handleidingen om 2FA aan te zetten bij 40 populaire sites. Als je een account toevoegt of bewerkt waarvoor we een handleiding hebben, staat er een link naar.';

  @override
  String get helpNew030b =>
      'Een korte welkomsttour de eerste keer dat je de app opent. Bekijk hem opnieuw via Instellingen > Hulp.';

  @override
  String get helpNew030c =>
      'Stuur feedback via Instellingen > Hulp. Je accounts en codes worden nooit meegestuurd.';

  @override
  String get helpNew030d => 'Deze Wat is er nieuw-pagina.';

  @override
  String get helpNew030e =>
      'Importeer uit Apple Wachtwoorden, en zet je accounts over naar Aegis, 2FAS of Google Authenticator.';

  @override
  String get helpNew030f =>
      'Steam Guard-codes, op teller gebaseerde codes met een knop \"Volgende code\", en geavanceerde code-instellingen met een live voorbeeld.';

  @override
  String get helpNew030g =>
      'Mappen, veel accounts tegelijk selecteren, sorteren op A tot Z of op laatst gebruikt, en \"Accountnamen opschonen\".';

  @override
  String get helpNew030h =>
      'Toon de QR-code van een account (na Face ID of je toegangscode) om het naar een ander apparaat over te zetten.';

  @override
  String get helpNew030i =>
      'Ontgrendel met een beveiligingssleutel zoals een YubiKey (Premium), op nieuwere iPhones, Macs en Windows-pc\'s.';

  @override
  String get helpNew030j =>
      '\"Vraagt eerst\"-accounts die Face ID of je toegangscode nodig hebben voordat de code verschijnt, en reismodus om gekozen accounts te verbergen (Premium).';

  @override
  String get helpNew030k =>
      'Activiteitengeschiedenis (Premium), klokcontrole bij \"Werken codes niet?\", Back-up testen, vergrendelen bij slaapstand, en back-upherinneringen.';

  @override
  String get helpNew030l =>
      'Noodtoegang: laat iemand die je vertrouwt om je accounts vragen, met een paar dagen tijd voor jou om nee te zeggen.';

  @override
  String get helpNew030m =>
      'Zoeken met Spotlight, een Live Activity voor gekopieerde codes en een complicatie voor de wijzerplaat (Premium), Kopiëren bij openen, en \"Wissen na één keer plakken\" op de Mac.';

  @override
  String get helpNew030n =>
      'Aftelstijlen, een kleur of emoji voor elk account, Voorlezen, een goed leesbaar lettertype, en betere ondersteuning voor schermlezers.';

  @override
  String get helpNew030o =>
      'Een brede indeling voor grote vensters, en Premium-iconen voor elk seizoen.';

  @override
  String get helpNew030p =>
      'Koop Premium in de app op iPhone en Android, geef het cadeau, en nodig vrienden uit.';

  @override
  String get helpNew030q =>
      'Teamkluis om codes te delen met maximaal 10 mensen. Het teamabonnement zelf komt binnenkort.';

  @override
  String get helpNew030r => 'Het gezinsabonnement komt binnenkort.';

  @override
  String get helpNew030s =>
      'De desktop-app werkt nu ook op Linux. Downloads voor Linux komen binnenkort.';

  @override
  String get helpNew020a =>
      'Synchronisatie tussen je apparaten, telefoonkoppeling voor de browserextensie, en één account veilig delen.';

  @override
  String get helpNew020b =>
      'Toegangscode, automatisch vergrendelen, noodwissen, nep-toegangscode, screenshots blokkeren, controle en meldingen bij datalekken.';

  @override
  String get helpNew020c =>
      'Widgets, apps voor Apple Watch en Wear OS, de Mac-menubalk en het Windows-systeemvak, en automatische versleutelde back-ups (Premium).';

  @override
  String get helpNew020d =>
      'Importeren uit Aegis, 2FAS, Authy, Bitwarden en 1Password, plus favorieten, tags, notities, herstelcodes en Prullenmand.';

  @override
  String get helpNew010a =>
      'De eerste versie: accounts scannen of plakken, codes zien, versleutelde back-ups, en de browserextensie.';

  @override
  String helpNoBrowser(String url) {
    return 'Kon je webbrowser niet openen. De pagina is $url';
  }

  @override
  String helpGuideFor(String name) {
    return '2FA aanzetten voor $name';
  }

  @override
  String get helpTourWelcome => 'Welkom bij Tanooki Auth';

  @override
  String get helpTourWelcomeBody =>
      'Veel websites kunnen naast je wachtwoord om een code van 6 cijfers vragen. Dat heet tweestapsverificatie, of 2FA. Tanooki Auth maakt die codes voor je, hier op je apparaat, zodat iemand met alleen je wachtwoord er nog steeds niet in komt.';

  @override
  String get helpTourAdd => 'Voeg je eerste account toe';

  @override
  String get helpTourAddBody =>
      'Zet 2FA aan in de beveiligingsinstellingen van een website. Je ziet dan een QR-code: scan hem hier, of kopieer de instellink en plak hem. Gebruik je al een andere authenticator-app? Zet je accounts in één keer over.';

  @override
  String get helpTourScanOrPaste => 'Scan een QR-code of plak een link';

  @override
  String get helpTourImport => 'Importeren uit een andere app';

  @override
  String get helpTourPopular => 'Populaire sites om eerst te beveiligen';

  @override
  String get helpTourPopularBody =>
      'Je e-mail, je sociale media en alles waar je geld bij zit zijn het belangrijkst. Onze stapsgewijze handleidingen laten zien waar de 2FA-instelling op elke site staat.';

  @override
  String get helpAllGuides => 'Alle 2FA-handleidingen';

  @override
  String helpTourStep(int step, int total) {
    return 'Stap $step van $total';
  }

  @override
  String get helpTourSkip => 'Tour overslaan';

  @override
  String get helpWhatsNew => 'Wat is er nieuw';

  @override
  String helpVersion(String version) {
    return 'Versie $version';
  }

  @override
  String helpVersionThis(String version) {
    return 'Versie $version (deze versie)';
  }

  @override
  String get helpFeedbackEmpty => 'Typ eerst een bericht.';

  @override
  String get helpFeedbackSent =>
      'Verstuurd. Bedankt! Maddie leest elk bericht.';

  @override
  String get helpFeedbackTooLong =>
      'Dat is te lang om te versturen. Maak het wat korter (maximaal ongeveer 4.000 tekens).';

  @override
  String get helpFeedbackTooMany =>
      'Je hebt het afgelopen uur veel feedback gestuurd. Probeer het over een uur opnieuw.';

  @override
  String get helpFeedbackOffline =>
      'Kon het internet niet bereiken. Controleer je verbinding en probeer het opnieuw. Je bericht staat er nog.';

  @override
  String get helpFeedbackServerError =>
      'De feedbackserver had een probleem en heeft je bericht niet aangenomen. Probeer het later opnieuw. Je bericht staat er nog.';

  @override
  String get helpFeedbackTitle => 'Feedback sturen';

  @override
  String get helpFeedbackIntro =>
      'Een bug gevonden, of zou je willen dat de app iets kon? Vertel het Maddie hier.';

  @override
  String get helpFeedbackMessage => 'Je bericht';

  @override
  String get helpFeedbackEmail => 'Je e-mailadres (optioneel)';

  @override
  String get helpFeedbackEmailHelp => 'Alleen als je een antwoord wilt.';

  @override
  String get helpFeedbackDevice => 'Appversie en apparaattype meesturen';

  @override
  String get helpFeedbackDeviceHelp =>
      'Bijvoorbeeld \"0.3.0\" en \"iOS\". Dat helpt om bugs op te sporen.';

  @override
  String get helpFeedbackNeverSent =>
      'Wordt nooit meegestuurd: je accounts, hun namen, codes, instelsleutels, tags, notities of iets anders uit de app.';

  @override
  String get helpFeedbackSend => 'Versturen';

  @override
  String get phoneUiPushAndroid =>
      'Meldingen op Android zijn nog niet ingesteld, dus verzoeken verschijnen terwijl Tanooki Auth open is.';

  @override
  String get phoneUiPushThisDevice =>
      'Dit apparaat krijgt verzoeken terwijl Tanooki Auth open is.';

  @override
  String get phoneUiPushNoToken => 'De iPhone gaf de app geen meldingstoken.';

  @override
  String get phoneUiPushDenied =>
      'Meldingen staan uit voor Tanooki Auth. Zet ze aan in de app Instellingen van je iPhone, onder Berichtgeving, om verzoeken te krijgen als de app gesloten is.';

  @override
  String phoneUiPushFailed(String problem) {
    return 'Kon meldingen niet aanzetten: $problem. Verzoeken verschijnen nog steeds terwijl Tanooki Auth open is.';
  }

  @override
  String get phoneUiPushNotInBuild =>
      'Meldingen zijn niet beschikbaar in deze build. Verzoeken verschijnen terwijl Tanooki Auth open is.';

  @override
  String get phoneUiPushChecking => 'Controleren of meldingen werken…';

  @override
  String get phoneUiRequest => 'Verzoek om inlogcode';

  @override
  String get phoneUiNoAccount =>
      'Er is geen account bewaard voor deze website, dus er valt niets te sturen. Had je er wel een verwacht? Dan is dit misschien een nepsite die zich voordoet als een echte.';

  @override
  String get phoneUiWantsCode =>
      'Je gekoppelde browser wil de code voor deze website. Keur alleen goed als je nu aan het inloggen bent.';

  @override
  String get phoneUiApprove => 'Goedkeuren';

  @override
  String phoneUiApproveAccount(String name) {
    return 'Goedkeuren: $name';
  }

  @override
  String get phoneUiScanTitle => 'Scan de code van de browser';

  @override
  String get phoneUiScanWrong =>
      'Dat is geen koppelcode voor een browser. Klik in de browser op de Tanooki Auth-extensie en dan op \"Gebruik mijn telefoon\".';

  @override
  String get phoneUiPasteTitle => 'Plak de koppellink';

  @override
  String get phoneUiPair => 'Koppelen';

  @override
  String get phoneUiPaired =>
      'Gekoppeld. Als die browser om een code vraagt, zie je dat hier.';

  @override
  String get phoneUiExpired =>
      'Die code is verlopen. Maak in de browser een nieuwe en scan hem opnieuw.';

  @override
  String get phoneUiPremium =>
      'Je telefoon gebruiken met een browser hoort bij Premium';

  @override
  String get phoneUiIntro =>
      'Vul codes in in een browser op elke computer, ook een zonder de Tanooki Auth-app. De browserextensie vraagt het, en jij tikt hier op Goedkeuren. Codes gaan end-to-end versleuteld, en alleen naar de website waarvoor elk account is bewaard.';

  @override
  String get phoneUiPairBrowser => 'Browser koppelen';

  @override
  String get phoneUiPairHelp =>
      'Klik in de browser op de Tanooki Auth-extensie en dan op \"Gebruik mijn telefoon\" om de code te tonen.';

  @override
  String get phoneUiPairedBrowsers => 'Gekoppelde browsers';

  @override
  String get phoneUiNoneYet => 'Nog geen';

  @override
  String get phoneUiBrowser => 'Browser';

  @override
  String phoneUiPairedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Gekoppeld op $dateString';
  }

  @override
  String get phoneUiUnpair => 'Ontkoppelen';

  @override
  String get phoneUiPushOn => 'Meldingen aan';

  @override
  String get phoneUiPushOff => 'Verzoeken verschijnen terwijl de app open is';

  @override
  String get phoneUiPushOnHelp =>
      'Je krijgt een melding bij elk verzoek, ook als Tanooki Auth gesloten is.';

  @override
  String phoneUiSendCodeFor(String name) {
    return 'Stuur de code voor $name';
  }

  @override
  String get phoneUiActivityWhere => 'Browser, via deze telefoon';

  @override
  String get premiumFiveOnce => '\$5 eenmalig';

  @override
  String get premiumPayOnce => 'Eenmalig betalen';

  @override
  String get premiumCheckoutSoon =>
      'Afrekenen kan nog niet; dat komt heel binnenkort. Bedankt dat je Tanooki Auth wilt steunen!';

  @override
  String get premiumEnterKeyTitle => 'Licentiesleutel invoeren';

  @override
  String get premiumEnterKeyHint => 'TA1.…  (uit je aankoopmail)';

  @override
  String get premiumBadKey =>
      'Die licentiesleutel is niet geldig. Kopieer de hele sleutel uit je aankoopmail en probeer het opnieuw.';

  @override
  String premiumInvitesNowFamily(int count) {
    return '$count vrienden hebben Premium gekocht met jouw link, dus je sleutel is nu een gezinssleutel voor maximaal 5 mensen. Hij is op dit apparaat geïnstalleerd. Kopieer hieronder de nieuwe sleutel en voer hem ook in op je andere apparaten.';
  }

  @override
  String premiumInvitesAlreadyFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count vrienden hebben Premium gekocht met jouw link. Je sleutel is al een gezinssleutel.',
      one: '1 vriend heeft Premium gekocht met jouw link. Je sleutel is al een gezinssleutel.',
    );
    return '$_temp0';
  }

  @override
  String premiumInvitesProgress(int count, int needed, int left) {
    return '$count van $needed vrienden hebben Premium gekocht met jouw link. Nog $left en je sleutel wordt een gezinssleutel.';
  }

  @override
  String get premiumInviteLinkCopied => 'Uitnodigingslink gekopieerd.';

  @override
  String get premiumKeyCopied => 'Licentiesleutel gekopieerd.';

  @override
  String premiumJustMe(String price) {
    return 'Alleen ik — $price';
  }

  @override
  String premiumFamilyPrice(String price) {
    return 'Gezin (maximaal 5 mensen) — $price';
  }

  @override
  String get premiumFamilyApple =>
      'Gezin: gedeeld met je Apple-gezin via Delen met gezin, plus een licentiesleutel voor maximaal 5 mensen op elk apparaat.';

  @override
  String get premiumFamilyKey =>
      'Gezin: één licentiesleutel die je deelt met maximaal 4 andere mensen.';

  @override
  String get premiumYourKey => 'Je licentiesleutel';

  @override
  String get premiumYourKeyHelp =>
      'Voer hem in op je andere apparaten: Instellingen → Premium kopen → \"Al gekocht? Voer je licentiesleutel in\".';

  @override
  String get premiumCopyKey => 'Sleutel kopiëren';

  @override
  String get premiumInviteFriends => 'Vrienden uitnodigen';

  @override
  String get premiumInviteHelp =>
      'Vrienden krijgen 20% korting. Als 3 vrienden kopen, wordt je sleutel een gezinssleutel.';

  @override
  String get premiumGetInvite => 'Mijn uitnodigingslink';

  @override
  String get premiumCheckInvites => 'Mijn uitnodigingen bekijken';

  @override
  String get premiumYouHave => 'Je hebt Premium';

  @override
  String get premiumTitle => 'Tanooki Auth Premium';

  @override
  String get premiumOwnedFamily =>
      'Gezinsabonnement: deel je licentiesleutel met maximaal 4 andere mensen (5 in totaal). Bedankt dat je Tanooki Auth steunt.';

  @override
  String get premiumOwnedThanks => 'Bedankt dat je Tanooki Auth steunt.';

  @override
  String get premiumPitchStripe =>
      '\$5 eenmalig, of \$10 voor je hele gezin. Voor altijd van jou.';

  @override
  String get premiumPitchStore =>
      'Betaal één keer voor jezelf, of één keer voor je hele gezin. Voor altijd van jou.';

  @override
  String get premiumPerkThemes => 'Alle Premium-thema\'s';

  @override
  String premiumPerkThemesBody(int count) {
    return 'Pastelroze, Pastelblauw en $count meer, seizoensthema\'s die vanzelf wisselen, tot 3 eigen thema\'s, plus elk thema dat later nog komt.';
  }

  @override
  String get premiumPerkIcons => 'App-iconen';

  @override
  String premiumPerkIconsBody(int count) {
    return 'Kies uit $count beginschermpictogrammen op iPhone en Android: kleuren, feestdagen en Pride-vlaggen. Op een Mac verandert het Dock-pictogram zolang de app open is.';
  }

  @override
  String get premiumPerkSync => 'Synchroniseren tussen je apparaten';

  @override
  String get premiumPerkSyncBody =>
      'Voeg een account toe op één apparaat en zie het op allemaal, end-to-end versleuteld. Via iCloud op Apple-apparaten, of via de Tanooki-relay voor elke mix.';

  @override
  String get premiumPerkApprove => 'Codes goedkeuren vanaf je telefoon';

  @override
  String get premiumPerkApproveBody =>
      'Gebruik de browserextensie op elke computer: hij vraagt het je telefoon, jij tikt op Goedkeuren, en de code wordt ingevuld.';

  @override
  String get premiumPerkBreach => 'Meldingen bij datalekken';

  @override
  String get premiumPerkBreachBody =>
      'Krijg een seintje als een website waar je een account hebt in een bekend datalek zit. Wordt op je apparaat gecontroleerd; er wordt niets over jou verstuurd.';

  @override
  String get premiumPerkShare => 'Een account veilig delen';

  @override
  String get premiumPerkShareBody =>
      'Geef één account aan iemand die je vertrouwt met een QR-code en een code van 6 cijfers. Vergrendeld, verloopt na 24 uur, geen server.';

  @override
  String get premiumPerkFamily => 'Gezinsabonnement';

  @override
  String get premiumPerkFamilyStripe =>
      'Voor \$10 in plaats van \$5 ontgrendelt één sleutel Premium voor maximaal 5 mensen. Stuur hem naar je gezin en zij voeren hem in net als jij.';

  @override
  String get premiumPerkFamilyStore =>
      'Eén gezinsaankoop ontgrendelt Premium voor maximaal 5 mensen. Stuur ze je licentiesleutel en ze voeren hem in net als jij.';

  @override
  String get premiumPerkFuture => 'Elke toekomstige Premium-functie';

  @override
  String get premiumPerkFutureBody =>
      'Betaal één keer en krijg alles waar Premium nog in uitgroeit. Nooit een abonnement.';

  @override
  String get premiumPerkFree => 'Houdt privacy-apps gratis';

  @override
  String get premiumPerkFreeStripe =>
      'Met jouw \$5 kan ik gratis apps blijven maken die je niet volgen.';

  @override
  String get premiumPerkFreeStore =>
      'Door Premium te kopen kan ik gratis apps blijven maken die je niet volgen.';

  @override
  String get premiumFreeForever =>
      'Voor altijd gratis, met of zonder Premium: onbeperkt accounts, scannen, back-ups, de browserextensie en de appvergrendeling.';

  @override
  String get premiumFamilySoon => 'Gezinsabonnement komt binnenkort';

  @override
  String get premiumFamilyKeyEach =>
      'Gezin: één licentiesleutel die je deelt met maximaal 4 andere mensen. Ieder voert hem in in zijn eigen Tanooki Auth.';

  @override
  String get premiumRestore => 'Aankopen herstellen';

  @override
  String get premiumAlreadyBought => 'Al gekocht? Voer je licentiesleutel in';

  @override
  String get premiumDesktopKeySoon =>
      'Een desktopsleutel voor aankopen via Android komt binnenkort. Premium is nu ontgrendeld op deze telefoon; een licentiesleutel voor je computers verschijnt hier in een latere update.';

  @override
  String premiumGift(String price) {
    return 'Geef Premium cadeau — $price';
  }

  @override
  String premiumGiftFamily(String price) {
    return 'Geef het gezinsabonnement cadeau — $price';
  }

  @override
  String get premiumGiftHelp =>
      'Na het betalen krijg je een cadeaubon om te printen, met een sleutel voor de ontvanger.';

  @override
  String get settingsIconFailed =>
      'Kon het app-icoon niet wijzigen. Probeer het opnieuw, of start de app opnieuw op.';

  @override
  String settingsIconFailedWhy(String problem) {
    return 'Kon het app-icoon niet wijzigen ($problem). Probeer het opnieuw, of start de app opnieuw op.';
  }

  @override
  String settingsIconSemantic(String name) {
    return 'App-icoon $name';
  }

  @override
  String settingsIconSemanticPremium(String name) {
    return 'App-icoon $name, Premium';
  }

  @override
  String get settingsAppIcon => 'App-icoon';

  @override
  String get settingsAppIconPremium => 'App-icoon (Premium)';

  @override
  String get settingsAppIconIos => 'Het icoon op je beginscherm.';

  @override
  String get settingsAppIconAndroid =>
      'Het icoon op je beginscherm. Het kan even verdwijnen terwijl je telefoon het wisselt.';

  @override
  String get settingsAppIconMac =>
      'Wijzigt het Dock-icoon terwijl Tanooki Auth open is. Een Mac kan geen ander icoon houden nadat de app stopt, dus Finder en Launchpad houden het blauwe.';

  @override
  String get settingsAppIconOther =>
      'App-iconen kun je wijzigen op iPhone en Android.';

  @override
  String get settingsLockNameMac => 'Touch ID of je Mac-wachtwoord';

  @override
  String get settingsLockNamePhone => 'Face ID, vingerafdruk of toegangscode';

  @override
  String settingsNoLockSetUp(String lock) {
    return 'Op dit apparaat is geen $lock ingesteld, dus de app kan niet worden vergrendeld. Stel dat eerst in bij je systeeminstellingen.';
  }

  @override
  String get settingsLockReasonOn => 'Appvergrendeling aanzetten';

  @override
  String get settingsLockReasonOff => 'Appvergrendeling uitzetten';

  @override
  String get settingsSetPasscode => 'App-toegangscode instellen';

  @override
  String get settingsSetPasscodeIntro =>
      'Typ deze om Tanooki Auth te openen. Hij werkt ook als Face ID of je vingerafdruk niet werkt. Vergeet je hem, dan kom je er alleen nog in met een back-up.';

  @override
  String get settingsPasscodeOn => 'App-toegangscode aan.';

  @override
  String get settingsPasscode => 'App-toegangscode';

  @override
  String get settingsChangePasscode => 'Toegangscode wijzigen';

  @override
  String get settingsPasscodeOff => 'Toegangscode uitzetten';

  @override
  String get settingsNewPasscode => 'Nieuwe app-toegangscode';

  @override
  String get settingsPasscodeChanged => 'Toegangscode gewijzigd.';

  @override
  String get settingsPasscodeIsOff => 'App-toegangscode uit.';

  @override
  String get settingsRemoveDecoyTitle => 'Nep-toegangscode verwijderen?';

  @override
  String get settingsRemoveDecoyBody =>
      'De nepaccounts worden gewist. Je echte accounts blijven onaangeroerd.';

  @override
  String get settingsSetDecoy => 'Nep-toegangscode instellen';

  @override
  String get settingsSetDecoyIntro =>
      'Als iemand je dwingt Tanooki Auth te openen, typ dan deze. Hij opent een aparte, lege set accounts, en niets op het scherm verraadt dat het niet de echte is. Zet er een paar onschuldige accounts in zodat het gebruikt lijkt.\n\nJe echte toegangscode blijft je echte accounts openen.';

  @override
  String get settingsDecoySet => 'Nep-toegangscode ingesteld.';

  @override
  String settingsWipeTitle(int count) {
    return 'Alles wissen na $count verkeerde toegangscodes?';
  }

  @override
  String settingsWipeBody(int count) {
    return 'Als iemand $count keer achter elkaar de verkeerde app-toegangscode typt, wist Tanooki Auth elk account op dit apparaat. Dat kan niet ongedaan worden gemaakt en niet meer worden gestopt als het eenmaal begint.';
  }

  @override
  String get settingsWipeSureTitle => 'Weet je het zeker?';

  @override
  String get settingsWipeSureBody =>
      'Een kind dat met je telefoon speelt, of jijzelf op een slechte dag, kan dit in gang zetten. Na het wissen kom je alleen terug met je back-upbestand. Zonder dat kun je buitengesloten raken van elke website die deze codes gebruikt.';

  @override
  String get settingsWipeTurnOn => 'Noodwissen aanzetten';

  @override
  String get settingsTravelOffReason => 'Reismodus uitzetten';

  @override
  String get settingsTravelOnNone =>
      'Reismodus staat aan, maar er is nog geen account gemarkeerd met \"Verbergen in reismodus\". Markeer ze eerst via ⋯ > Bewerken.';

  @override
  String settingsTravelOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reismodus aan. $count accounts zijn verborgen.',
      one: 'Reismodus aan. 1 account is verborgen.',
    );
    return '$_temp0';
  }

  @override
  String get settingsTravelOff => 'Reismodus uit. Alle accounts zijn terug.';

  @override
  String get settingsCheckingClock => 'Je klok controleren…';

  @override
  String get settingsClockRight =>
      'Je klok loopt goed, dus daar ligt het niet aan. Controleer of de instellingen van het account (⋯ > Bewerken > Geavanceerd) overeenkomen met wat de website zei.';

  @override
  String settingsClockFailed(String problem) {
    return 'Kon de klok niet controleren: $problem';
  }

  @override
  String get settingsLockApp => 'App vergrendelen';

  @override
  String settingsLockAppHelp(String lock) {
    return 'Vraag om $lock als de app opent';
  }

  @override
  String get settingsPasscodeOnHelp =>
      'Aan. Tik om te wijzigen of uit te zetten.';

  @override
  String settingsPasscodeOffHelp(String lock) {
    return 'Uit. Cijfers die je typt om de app te openen, in plaats van of naast $lock.';
  }

  @override
  String get settingsLockAgain => 'Opnieuw vergrendelen';

  @override
  String settingsLockAgainHelp(String time) {
    return '$time op de achtergrond';
  }

  @override
  String get settingsLockFirst =>
      'Zet eerst de vergrendeling of een toegangscode aan';

  @override
  String get settingsDecoy => 'Nep-toegangscode';

  @override
  String get settingsDecoyOn =>
      'Aan. Opent een aparte set accounts. Tik om te verwijderen.';

  @override
  String get settingsDecoyOff =>
      'Een tweede toegangscode die een aparte, lege set accounts opent';

  @override
  String settingsWipe(int count) {
    return 'Wissen na $count verkeerde toegangscodes';
  }

  @override
  String get settingsWipeHelp =>
      'Noodwissen. Vereist een back-up van de afgelopen 30 dagen.';

  @override
  String get settingsLockOnSleep => 'Vergrendelen als de computer slaapt';

  @override
  String get settingsLockOnSleepHelp =>
      'Ook als het scherm vergrendelt of je even uitlogt';

  @override
  String get settingsLockOnSleepNeedsLock =>
      'Zet eerst \"App vergrendelen\" of een app-toegangscode aan, zodat er iets te vergrendelen valt.';

  @override
  String get settingsTravel => 'Reismodus';

  @override
  String get settingsTravelPremium => 'Reismodus (Premium)';

  @override
  String get settingsTravelOnHelp =>
      'Aan. Accounts gemarkeerd met \"Verbergen in reismodus\" zijn weg van de schermen, widgets, het horloge, de extensie en de exports van dit apparaat tot je hem uitzet. Ze zijn niet verwijderd.';

  @override
  String settingsTravelOffHelp(String proof) {
    return 'Voor een grensovergang: verbergt de accounts die je hebt gemarkeerd met \"Verbergen in reismodus\" (⋯ > Bewerken). Uitzetten vraagt om $proof.';
  }

  @override
  String get settingsKeys => 'Beveiligingssleutels';

  @override
  String get settingsKeysPremium => 'Beveiligingssleutels (Premium)';

  @override
  String get settingsKeysHelp =>
      'Ontgrendel met een YubiKey of een andere beveiligingssleutel';

  @override
  String get settingsActivity => 'Activiteitengeschiedenis';

  @override
  String get settingsActivityPremium => 'Activiteitengeschiedenis (Premium)';

  @override
  String get settingsActivityHelp =>
      'Welke codes zijn gekopieerd, ingevuld, getypt of geëxporteerd, en wanneer. Alleen bewaard op dit apparaat.';

  @override
  String get settingsEmergency => 'Noodtoegang';

  @override
  String get settingsEmergencyPremium => 'Noodtoegang (Premium)';

  @override
  String get settingsEmergencyHelp =>
      'Laat één vertrouwd persoon je accounts krijgen als jou iets overkomt, na 7 dagen wachten die jij kunt stoppen';

  @override
  String get settingsTeamHelp =>
      'Deel inlogcodes met maximaal 10 mensen, end-to-end versleuteld';

  @override
  String get settingsMonthly => 'Maandelijkse overzichtsmelding';

  @override
  String get settingsMonthlyPremium =>
      'Maandelijkse overzichtsmelding (Premium)';

  @override
  String get settingsMonthlyHelp =>
      'Een herinnering op de 1e van elke maand om naar je overzichtskaart te kijken. Er staat nooit iets in over je accounts.';

  @override
  String get settingsBlockShots => 'Screenshots blokkeren';

  @override
  String get settingsBlockShotsDesktop =>
      'Verbergt dit venster voor screenshots, schermopnames en scherm delen';

  @override
  String get settingsBlockShotsPhone =>
      'Houdt codes uit screenshots, schermopnames en de appkiezer';

  @override
  String get settingsCheckup => 'Beveiligingscontrole';

  @override
  String get settingsCheckupHelp =>
      'Dingen die het verbeteren waard zijn, en je herstelpakket';

  @override
  String get settingsBreachPremium => 'Meldingen bij datalekken (Premium)';

  @override
  String get settingsBreachOn =>
      'Aan. Controleert wekelijks de openbare lijst met datalekken.';

  @override
  String get settingsBreachOff =>
      'Uit. Als dit aanstaat, downloadt de app één keer per week de openbare lijst met datalekken.';

  @override
  String settingsThemeSemantic(String name) {
    return 'Thema $name';
  }

  @override
  String settingsThemeSemanticPremium(String name) {
    return 'Thema $name, Premium';
  }

  @override
  String get settingsPremiumThanks => 'Premium: bedankt!';

  @override
  String get settingsGetPremium => 'Premium kopen';

  @override
  String get settingsPremiumThanksHelp =>
      'Elk thema en elke toekomstige Premium-functie is van jou.';

  @override
  String settingsGetPremiumHelp(String payOnce) {
    return '$payOnce: elk thema, synchroniseren tussen je apparaten, en meer.';
  }

  @override
  String get settingsAppearance => 'Weergave';

  @override
  String get settingsCountdown => 'Aftelstijl';

  @override
  String get settingsCountdownHelp =>
      'Hoe de resterende tijd van elke code wordt getoond';

  @override
  String get settingsEasyFont => 'Goed leesbaar lettertype';

  @override
  String get settingsEasyFontHelp =>
      'Atkinson Hyperlegible, gemaakt door het Braille Institute zodat letters en cijfers moeilijk te verwarren zijn';

  @override
  String get settingsLanguage => 'Taal';

  @override
  String get settingsLanguageSystem => 'Systeem';

  @override
  String get settingsAccountsList => 'Accountlijst';

  @override
  String get settingsCompact => 'Compacte kaarten';

  @override
  String get settingsCompactHelp =>
      'Kleinere kaarten, zodat er meer accounts op het scherm passen';

  @override
  String get settingsSort => 'Accounts sorteren';

  @override
  String settingsSortHelp(String sort) {
    return '$sort. Favorieten staan altijd bovenaan.';
  }

  @override
  String get settingsSortCustom =>
      'Je eigen volgorde. Houd een kaart ingedrukt en sleep hem.';

  @override
  String get settingsSortRecent =>
      'Accounts waarvan je net een code hebt gekopieerd, gaan naar boven';

  @override
  String get settingsSortName => 'Op naam van de dienst';

  @override
  String get settingsTidyHelp =>
      'Maakt van namen als \"google.com:you@gmail.com\" gewoon \"Google\". Je ziet elke wijziging eerst.';

  @override
  String get settingsHideCodes => 'Codes verbergen tot je tikt';

  @override
  String get settingsHideCodesHelp =>
      'Toont puntjes in plaats van codes, zodat mensen in de buurt ze niet kunnen lezen';

  @override
  String get settingsShareCodes => 'Codes tonen op widgets en horloge';

  @override
  String get settingsShareCodesHelp =>
      'De codes van je favorieten verschijnen op je beginscherm, toegangsscherm en horloge zonder dat je deze app opent, dus iedereen met je ontgrendelde telefoon of je horloge kan ze lezen. Geef een account een ster om er een favoriet van te maken.';

  @override
  String get settingsAutofill => 'Codes automatisch invullen';

  @override
  String get settingsAutofillHelpIos =>
      'Als een website of app om een 2FA-code vraagt, biedt je iPhone hem aan boven het toetsenbord, zodat je hem niet hoeft te kopiëren. Accounts die eerst vragen, hebben Face ID nodig voordat ze worden ingevuld. Accounts die verborgen zijn in reismodus worden nooit aangeboden.';

  @override
  String get settingsAutofillHelpAndroid =>
      'Als een app of website om een 2FA-code vraagt, biedt je telefoon hem aan in een kleine pop-up, zodat je hem niet hoeft te kopiëren. Android laat maar één app tegelijk automatisch invullen, dus dit vervangt het automatisch invullen van je wachtwoordbeheerder. Ben je daarvan afhankelijk, laat dit dan uit.';

  @override
  String get settingsAutofillStepsTitle => 'Automatisch invullen aanzetten';

  @override
  String get settingsAutofillStepsIos =>
      'Hiervoor heb je iOS 18 of nieuwer nodig.\n\n1. Open de app Instellingen (het grijze tandwiel).\n2. Tik op Algemeen en dan op Automatisch invullen en wachtwoorden.\n3. Zet in de lijst met apps die automatisch kunnen invullen de schakelaar naast Tanooki Auth aan.\n\nHet is gelukt als die schakelaar groen is. Als een website of app de volgende keer om een code vraagt, tik je op het codevak en dan op de suggestie van Tanooki Auth boven het toetsenbord.';

  @override
  String get settingsAutofillStepsAndroid =>
      '1. Tik hieronder op Instellingen openen. Er opent een lijst met apps voor automatisch invullen.\n2. Tik op Tanooki Auth, en dan op OK als je telefoon dat vraagt.\n\nOpent er geen lijst? Open dan de app Instellingen, zoek naar \"Service voor automatisch invullen\", tik erop en kies Tanooki Auth.\n\nHet is gelukt als Tanooki Auth nu als service voor automatisch invullen staat. Als een app of website de volgende keer om een code vraagt, tik je op het codevak en kies je Tanooki Auth in de pop-up.\n\nAndroid laat maar één app tegelijk automatisch invullen. Als je Tanooki Auth kiest, vult je wachtwoordbeheerder (zoals Google, Bitwarden of 1Password) geen wachtwoorden meer in. Wil je terug, kies hem dan weer op dezelfde plek.';

  @override
  String get settingsAutofillOpen => 'Instellingen openen';

  @override
  String get settingsTrash => 'Prullenmand';

  @override
  String settingsTrashCount(int count) {
    return 'Prullenmand ($count)';
  }

  @override
  String get settingsTrashHelp =>
      'Verwijderde accounts blijven hier 30 dagen staan';

  @override
  String get settingsWatchFace => 'Favoriet op wijzerplaat';

  @override
  String get settingsWatchFacePremium => 'Favoriet op wijzerplaat (Premium)';

  @override
  String get settingsWatchFaceNoFavorites =>
      'Geef eerst een account in de hoofdlijst een ster. Alleen favorieten kunnen op de wijzerplaat.';

  @override
  String get settingsNone => 'Geen';

  @override
  String get settingsCopying => 'Kopiëren en snelkoppelingen';

  @override
  String get settingsCopyOnOpen => 'Kopiëren bij openen';

  @override
  String get settingsCopyOnOpenHelp =>
      'Als je de app opent of ontgrendelt, wordt de code gekopieerd van het account dat je het laatst gebruikte. Accounts die eerst vragen voordat ze hun code tonen, worden overgeslagen.';

  @override
  String get settingsPasteOnce => 'Wissen na één keer plakken';

  @override
  String get settingsPasteOnceHelp =>
      'De gekopieerde code werkt voor één keer plakken, daarna wordt het klembord leeggemaakt. Apps met klembordgeschiedenis kunnen als die ene keer tellen. Op Windows worden codes in plaats daarvan na 30 seconden gewist.';

  @override
  String get settingsSpotlight => 'Accounts tonen in Spotlight';

  @override
  String get settingsSpotlightHelp =>
      'Zoek overal naar de naam van een account en ga er meteen naartoe. Alleen namen worden gedeeld, nooit codes.';

  @override
  String get settingsLiveActivity => 'Code op toegangsscherm na kopiëren';

  @override
  String get settingsLiveActivityPremium =>
      'Code op toegangsscherm na kopiëren (Premium)';

  @override
  String get settingsLiveActivityHelp =>
      'Nadat je een code kopieert, verschijnt hij op je toegangsscherm en in het Dynamic Island, met een aftelling tot hij verloopt.';

  @override
  String get settingsWatchFaceHelp =>
      'Kies één favoriet waarvan de code op je Apple Watch-wijzerplaat verschijnt. Vereist dat \"Codes tonen op widgets en horloge\" aanstaat.';

  @override
  String settingsWatchFaceChosen(String name) {
    return '$name. Voeg de Tanooki Auth-complicatie toe aan je wijzerplaat om hem te zien.';
  }

  @override
  String get settingsBrowserSection => 'Browserextensie en launchers';

  @override
  String get settingsBridgeOff => 'Niet actief';

  @override
  String get settingsBridgeOn => 'Klaar voor de browserextensie';

  @override
  String settingsBridgeOffHelp(String first, String last) {
    return 'Poorten $first–$last worden allemaal door andere programma\'s gebruikt, dus de extensie kan geen verbinding maken. Start je computer opnieuw op en probeer het nog eens.';
  }

  @override
  String settingsBridgeOnHelp(String port) {
    return 'Luistert alleen op deze computer (127.0.0.1:$port). Werkt terwijl Tanooki Auth open is.';
  }

  @override
  String settingsPairedClient(String name) {
    return 'Gekoppeld: $name';
  }

  @override
  String get settingsPairedBrowser => 'Gekoppelde browser';

  @override
  String settingsExtensionId(String id) {
    return 'Extensie $id';
  }

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get settingsSecurity => 'Beveiliging';

  @override
  String get settingsBackup => 'Back-up';

  @override
  String get settingsExport => 'Back-up exporteren';

  @override
  String get settingsExportHelp =>
      'Een versleuteld bestand, vergrendeld met een wachtwoordzin die jij kiest';

  @override
  String get settingsImport => 'Back-up importeren';

  @override
  String get settingsImportHelp =>
      'Voegt accounts toe uit een back-upbestand; slaat accounts over die je al hebt';

  @override
  String get settingsTestBackup => 'Back-up testen';

  @override
  String get settingsTestBackupHelp =>
      'Controleert of een back-upbestand opent met je wachtwoordzin. Verandert niets.';

  @override
  String get settingsMoveOut => 'Overzetten naar een andere app';

  @override
  String get settingsMoveOutHelp =>
      'Aegis, 2FAS, Google Authenticator, of gewone instellinks';

  @override
  String get settingsPaper => 'Papieren back-up printen';

  @override
  String get settingsPaperHelp =>
      'Een pdf met QR-codes en herstelcodes om ergens achter slot te bewaren';

  @override
  String get settingsHelp => 'Hulp';

  @override
  String get settingsGuidesHelp =>
      'Stapsgewijze hulp om 2FA aan te zetten bij populaire sites, op onze website';

  @override
  String get settingsTour => 'Welkomsttour tonen';

  @override
  String get settingsFeedbackHelp =>
      'Vertel Maddie over een bug of een idee. Je accounts en codes worden nooit meegestuurd.';

  @override
  String get settingsAbout => 'Over';

  @override
  String get settingsAboutMaddieHelp =>
      'Een berichtje van degene die Tanooki Auth maakt';

  @override
  String get settingsCodesNotWorking => 'Werken codes niet?';

  @override
  String settingsCodesNotWorkingHelp(String time) {
    return 'Apparaattijd $time. Codes hangen af van de klok: tik om hem te vergelijken met het internet.';
  }

  @override
  String shareUiConfirmTitle(String name) {
    return '$name delen?';
  }

  @override
  String get shareUiConfirmBody =>
      'Degene met wie je dit deelt krijgt volledige toegang: hun telefoon maakt dezelfde codes als de jouwe, zolang ze het bewaren. Deel alleen met iemand die je volledig vertrouwt, zoals familie.\n\nAls je het later uit je lijst verwijdert, neem je het niet bij hen terug. Wil je ze afsluiten, zet dan tweestapsverificatie uit en weer aan op de website.';

  @override
  String get shareUiConfirmButton => 'Ik begrijp het, delen';

  @override
  String get shareUiLocking => 'Gedeeld account vergrendelen…';

  @override
  String shareUiTitle(String name) {
    return '$name delen';
  }

  @override
  String get shareUiInstructions =>
      'Op hun apparaat: open Tanooki Auth, tik op Account toevoegen en dan op \"QR-code scannen\" (of \"Een gedeeld account openen\" voor het bestand). Daarna typen ze deze code:';

  @override
  String get shareUiTellCode =>
      'Geef ze de code zelf, hardop of in een andere app dan het bestand.';

  @override
  String get shareUiSendFile => 'Liever als bestand sturen';

  @override
  String get shareUiCopyLink => 'Kopiëren als link';

  @override
  String get shareUiCopied =>
      'Gekopieerd. Ze plakken het met \"Instellink plakken\".';

  @override
  String get shareUiWorksFor =>
      'Werkt 24 uur, en alleen met de code. Er gaat niets via een server.';

  @override
  String get shareUiOpenTitle => 'Gedeeld account';

  @override
  String get shareUiOpenBody =>
      'Typ de code van 6 cijfers die je kreeg van degene die het deelde.';

  @override
  String get shareUiUnlocking => 'Ontgrendelen…';

  @override
  String get signatureLabel => 'Groetjes, Maddie';

  @override
  String get syncUiQrCode => 'QR-code';

  @override
  String get syncUiNotYet => 'Nog niet';

  @override
  String get syncUiJustNow => 'Zojuist';

  @override
  String syncUiMinutesAgo(int minutes) {
    return '$minutes min geleden';
  }

  @override
  String syncUiHoursAgo(int hours) {
    return '$hours uur geleden';
  }

  @override
  String syncUiDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get syncUiThisDevice => 'Dit apparaat';

  @override
  String get syncUiAnotherDevice => 'Een ander apparaat';

  @override
  String syncUiAdded(String when) {
    return 'Toegevoegd $when';
  }

  @override
  String syncUiThisDeviceNamed(String name) {
    return 'Dit apparaat ($name)';
  }

  @override
  String syncUiLastSyncedAgo(String when) {
    return 'Laatst gesynchroniseerd: $when';
  }

  @override
  String get syncUiWhere => 'Waar moeten je apparaten synchroniseren?';

  @override
  String get syncUiICloudHelp =>
      'Alleen voor iPhone, iPad en Mac. Gebruikt je eigen iCloud Drive.';

  @override
  String get syncUiRelay => 'Tanooki-relay';

  @override
  String get syncUiRelayHelp =>
      'Werkt met elk apparaat, ook Android en Windows. De server bewaart alleen versleutelde gegevens.';

  @override
  String get syncUiStartFreshTitle => 'Opnieuw beginnen?';

  @override
  String get syncUiStartFreshBody =>
      'Ben je de wachtwoordzin vergeten die je andere Apple-apparaten gebruiken? Dan kun je met deze een nieuwe synchronisatie beginnen. Je andere apparaten moeten sync dan uit- en weer aanzetten met de nieuwe wachtwoordzin.';

  @override
  String get syncUiStartFresh => 'Opnieuw beginnen';

  @override
  String get syncUiOn => 'Sync staat aan.';

  @override
  String get syncUiScanTitle => 'Scan de synccode';

  @override
  String get syncUiScanWrong =>
      'Dat is geen synccode. Open op je andere apparaat Instellingen, Synchronisatie, Apparaat toevoegen.';

  @override
  String get syncUiNowSyncing => 'Dit apparaat synchroniseert nu.';

  @override
  String get syncUiPasteTitle => 'Plak de synclink';

  @override
  String get syncUiPasteHint =>
      'tanookiauth://sync?…  (via Apparaat toevoegen op je andere apparaat)';

  @override
  String get syncUiAddApple => 'Apple-apparaat toevoegen';

  @override
  String get syncUiAddAppleBody =>
      'Open op je andere iPhone, iPad of Mac (ingelogd met dezelfde Apple ID, met iCloud Drive aan) Tanooki Auth, ga naar Instellingen en dan Synchronisatie, tik op \"Sync aanzetten\", kies iCloud en typ dezelfde sync-wachtwoordzin.\n\nWil je een Android-telefoon of een Windows-pc toevoegen? Zet sync uit op elk apparaat en zet hem daarna weer aan met de Tanooki-relay.';

  @override
  String get syncUiAddDevice => 'Apparaat toevoegen';

  @override
  String get syncUiAddDeviceBody =>
      'Open op het nieuwe apparaat Tanooki Auth, ga naar Instellingen en dan Synchronisatie, en tik op \"Meedoen vanaf een ander apparaat\". Scan deze code en typ daar je sync-wachtwoordzin.';

  @override
  String get syncUiAddDeviceNote =>
      'Werkt één keer, 24 uur lang. Iemand met alleen deze code kan niets lezen zonder je wachtwoordzin.';

  @override
  String get syncUiLinkCopied =>
      'Link gekopieerd. Plak hem op het nieuwe apparaat.';

  @override
  String get syncUiCopyLink => 'Liever de link kopiëren';

  @override
  String get syncUiRemoveTitle => 'Dit apparaat uit sync verwijderen?';

  @override
  String get syncUiRemoveBody =>
      'Het krijgt dan geen wijzigingen meer. Is het apparaat kwijt of gestolen, wijzig dan ook je sync-wachtwoordzin: zet sync uit op elk apparaat en daarna weer aan met een nieuwe wachtwoordzin, want het verloren apparaat kent de oude nog.';

  @override
  String get syncUiTurnOffTitle => 'Sync uitzetten op dit apparaat?';

  @override
  String get syncUiTurnOffBody =>
      'Je accounts blijven op dit apparaat. Het stopt alleen met wijzigingen versturen en ontvangen. Je andere apparaten blijven onderling synchroniseren.';

  @override
  String get syncUiOff => 'Sync staat uit op dit apparaat.';

  @override
  String get syncUiPremium => 'Synchronisatie hoort bij Premium';

  @override
  String syncUiPremiumBody(String payOnce) {
    return 'Voeg een account toe op één apparaat en het verschijnt op allemaal, end-to-end versleuteld. $payOnce, geen abonnement.';
  }

  @override
  String get syncUiIntro =>
      'Sync houdt je accounts gelijk op al je apparaten. Voordat iets dit apparaat verlaat, wordt het vergrendeld met je sync-wachtwoordzin, dus iCloud of onze server bewaart alleen versleutelde gegevens. Niemand anders kan het lezen, wij ook niet.';

  @override
  String get syncUiTurnOn => 'Sync aanzetten';

  @override
  String get syncUiJoin => 'Meedoen vanaf een ander apparaat';

  @override
  String get syncUiJoinHelp =>
      'Gebruik \"Meedoen\" als een ander apparaat al synchroniseert met de Tanooki-relay.';

  @override
  String get syncUiSyncingRelay => 'Synchroniseert met de Tanooki-relay';

  @override
  String get syncUiSyncingICloud => 'Synchroniseert met iCloud';

  @override
  String get syncUiSyncingNow => 'Bezig met synchroniseren…';

  @override
  String syncUiSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gesynchroniseerde items konden niet worden gelezen',
      one: '1 gesynchroniseerd item kon niet worden gelezen',
    );
    return '$_temp0';
  }

  @override
  String get syncUiSkippedHelp =>
      'Misschien zijn ze door iemand anders gewijzigd of gemaakt met een andere wachtwoordzin. Er is niets door verwijderd.';

  @override
  String get syncUiDevices => 'Apparaten';

  @override
  String get syncUiLoading => 'Laden…';

  @override
  String get syncUiAddDeviceRelay =>
      'Toont een code om te scannen op het nieuwe apparaat';

  @override
  String get syncUiAddDeviceApple => 'Nog een iPhone, iPad of Mac';

  @override
  String get syncUiTurnOffButton => 'Sync uitzetten op dit apparaat';

  @override
  String get syncUiPassphraseNoteRelay =>
      'Je sync-wachtwoordzin kan niet worden hersteld. Vergeet je hem, zet sync dan uit op elk apparaat en begin opnieuw met een nieuwe. Je accounts blijven staan.';

  @override
  String get syncUiPassphraseNoteICloud =>
      'Sync gebruikt je iCloud Drive. Je sync-wachtwoordzin kan niet worden hersteld; vergeet je hem, begin dan opnieuw met een nieuwe. Je accounts blijven staan.';

  @override
  String get syncUiTitle => 'Synchronisatie';

  @override
  String get syncUiTooShort =>
      'Gebruik minstens 10 tekens. Een paar willekeurige woorden werkt goed.';

  @override
  String get syncUiMismatch => 'De twee wachtwoordzinnen komen niet overeen.';

  @override
  String get syncUiChoosePassphrase => 'Kies een sync-wachtwoordzin';

  @override
  String get syncUiTypePassphrase => 'Typ je sync-wachtwoordzin';

  @override
  String get syncUiChooseHelp =>
      'Je typt deze één keer op elk apparaat dat je toevoegt. Hij vergrendelt je accounts voordat ze dit apparaat verlaten.\n\nSchrijf hem op en bewaar hem op een veilige plek. Hij kan niet worden hersteld of gereset, niet door jou en niet door ons.';

  @override
  String get syncUiTypeHelp =>
      'Dezelfde wachtwoordzin die je koos toen je sync aanzette op je eerste apparaat.';

  @override
  String get syncUiPassphrase => 'Sync-wachtwoordzin';

  @override
  String get syncUiTypeAgain => 'Typ hem nog een keer';

  @override
  String get syncUiSectionTitle => 'Synchronisatie en telefoon';

  @override
  String get syncUiTitlePremium => 'Synchronisatie (Premium)';

  @override
  String get syncUiOnRelay => 'Aan, met de Tanooki-relay';

  @override
  String get syncUiOnICloud => 'Aan, met iCloud';

  @override
  String get syncUiOffHelp => 'Houd je accounts gelijk op al je apparaten';

  @override
  String get syncUiBrowser => 'Gebruiken met een browser';

  @override
  String get syncUiBrowserPremium => 'Gebruiken met een browser (Premium)';

  @override
  String get syncUiBrowserHelp =>
      'Keur op deze telefoon codes goed voor een browser op elke computer';

  @override
  String get teamUiCreateTitle => 'Maak je team';

  @override
  String get teamUiCreateHint =>
      'TT1.…  (van de pagina nadat je een abonnement nam)';

  @override
  String get teamUiCreateButton => 'Team maken';

  @override
  String get teamUiReady =>
      'Je team is klaar. Nodig mensen uit met \"Iemand uitnodigen\".';

  @override
  String get teamUiScanTitle => 'Scan de teamuitnodiging';

  @override
  String get teamUiScanWrong =>
      'Dat is geen teamuitnodiging. Vraag de teambeheerder om Instellingen, Teamkluis, Iemand uitnodigen te openen.';

  @override
  String get teamUiJoinTitle => 'Lid worden van een team';

  @override
  String get teamUiJoinHint =>
      'tanookiauth://team?…  (de uitnodigingslink van de teambeheerder)';

  @override
  String get teamUiJoinButton => 'Lid worden';

  @override
  String get teamUiJoinedTeam =>
      'Je zit in het team. Teamaccounts verschijnen zodra de app van de beheerder de teamsleutel met dit apparaat deelt.';

  @override
  String get teamUiInvite => 'Iemand uitnodigen';

  @override
  String get teamUiInviteHelp =>
      'Op hun apparaat: Instellingen, Teamkluis, en dan \"Een uitnodigings-QR-code scannen\" of \"Een uitnodigingslink plakken\". De uitnodiging werkt één keer en is 7 dagen geldig.';

  @override
  String get teamUiRemovePersonTitle => 'Deze persoon verwijderen?';

  @override
  String get teamUiRemovePersonBody =>
      'Diegene verliest meteen toegang, en het team krijgt een nieuwe sleutel zodat diegene niets kan lezen wat vanaf nu wordt toegevoegd of gewijzigd. Misschien heeft diegene kopieën bewaard van de codes die al zichtbaar waren, dus wijzig de tweestapsinstelling van elk account dat ertoe doet.';

  @override
  String get teamUiRemoved => 'Verwijderd. Het team heeft een nieuwe sleutel.';

  @override
  String get teamUiDeleteTitle => 'Team verwijderen?';

  @override
  String get teamUiLeaveTitle => 'Team verlaten?';

  @override
  String get teamUiDeleteBody =>
      'Elk teamaccount wordt verwijderd voor iedereen in het team. De eigen accounts van iedereen blijven onaangeroerd.';

  @override
  String get teamUiLeaveBody =>
      'De accounts van het team verdwijnen van dit apparaat. Je eigen accounts blijven onaangeroerd.';

  @override
  String get teamUiDeleteButton => 'Team verwijderen';

  @override
  String get teamUiLeaveButton => 'Verlaten';

  @override
  String get teamUiDeleted => 'Team verwijderd.';

  @override
  String get teamUiLeft => 'Je hebt het team verlaten.';

  @override
  String get teamUiAddFirst =>
      'Voeg het account eerst toe aan Tanooki Auth en kopieer het dan hier naar het team.';

  @override
  String get teamUiCopyInTitle => 'Kopieer een van je accounts naar het team';

  @override
  String teamUiCopiedIn(String name) {
    return '$name zit nu in het team. Je eigen kopie blijft waar hij was.';
  }

  @override
  String get teamUiRenameTitle => 'Teamaccount hernoemen';

  @override
  String get teamUiRenameHint => 'Naam, bijv. AWS';

  @override
  String teamUiRemoveAccountTitle(String name) {
    return '$name uit het team verwijderen?';
  }

  @override
  String get teamUiRemoveAccountBody =>
      'Het verdwijnt voor iedereen in het team.';

  @override
  String get teamUiIntro =>
      'Een teamkluis deelt inlogcodes met maximaal 10 mensen, voor \$20 per jaar. Iedereen in het team kan teamaccounts zien, toevoegen en wijzigen. Ze zijn op je apparaten versleuteld met een sleutel die alleen het team heeft, dus onze server kan ze niet lezen. Teamaccounts staan in een eigen Team-gedeelte en raken nooit vermengd met je eigen accounts.';

  @override
  String get teamUiStart => 'Een team starten';

  @override
  String get teamUiBuy => 'Teamabonnement kopen — \$20 per jaar';

  @override
  String get teamUiPlanSoon => 'Teamabonnement komt binnenkort';

  @override
  String get teamUiHaveLicense => 'Ik heb een teamlicentie: team maken';

  @override
  String get teamUiJoinHelp =>
      'Vraag de teambeheerder om een uitnodiging. Lid worden is gratis.';

  @override
  String get teamUiScanInvite => 'Een uitnodigings-QR-code scannen';

  @override
  String get teamUiPasteInvite => 'Een uitnodigingslink plakken';

  @override
  String get teamUiYouRun => 'Jij beheert dit team';

  @override
  String get teamUiYoureIn => 'Je zit in een team';

  @override
  String teamUiPeopleCount(int count, int max) {
    return '$count van $max mensen';
  }

  @override
  String teamUiLastSynced(String when) {
    return 'Laatst gesynchroniseerd: $when';
  }

  @override
  String teamUiPaidUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Betaald tot $dateString';
  }

  @override
  String get teamUiSyncNow => 'Nu synchroniseren';

  @override
  String get teamUiWaitingForKey =>
      'Wachten tot de app van de teambeheerder de teamsleutel met dit apparaat deelt. Dat gebeurt de volgende keer dat de beheerder Tanooki Auth opent.';

  @override
  String get teamUiAccounts => 'Teamaccounts';

  @override
  String get teamUiAddMine => 'Een van mijn accounts toevoegen';

  @override
  String get teamUiNoAccounts => 'Nog geen teamaccounts.';

  @override
  String get teamUiChange => 'Wijzigen';

  @override
  String get teamUiRename => 'Hernoemen';

  @override
  String get teamUiRemoveFromTeam => 'Uit team verwijderen';

  @override
  String get teamUiPeople => 'Mensen';

  @override
  String get teamUiThisDevice => 'Dit apparaat (beheerder)';

  @override
  String teamUiDevice(String id) {
    return 'Apparaat $id';
  }

  @override
  String teamUiJoined(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Lid sinds $dateString';
  }

  @override
  String teamUiJoinedGettingKey(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Lid sinds $dateString · teamsleutel ophalen';
  }

  @override
  String get teamUiDeleteTeam => 'Team verwijderen';

  @override
  String get teamUiLeaveTeam => 'Team verlaten';

  @override
  String get teamUiTitle => 'Teamkluis';

  @override
  String teamUiCopiedCode(String name) {
    return 'Code van $name gekopieerd. Het klembord wordt over 30 seconden gewist.';
  }

  @override
  String teamUiSection(int count) {
    return 'Team · $count';
  }

  @override
  String get teamUiWaitingShort =>
      'Wachten tot de teambeheerder de teamsleutel met dit apparaat deelt.';

  @override
  String get teamUiNoAccountsHint =>
      'Nog geen teamaccounts. Voeg ze toe via Instellingen, Teamkluis.';

  @override
  String get themeAuto => 'Automatisch';

  @override
  String get themeDark => 'Donker';

  @override
  String get themeLight => 'Licht';

  @override
  String get themePink => 'Pastelroze';

  @override
  String get themeBlue => 'Pastelblauw';

  @override
  String get themeLavender => 'Lavendel';

  @override
  String get themeMint => 'Mint';

  @override
  String get themeMidnight => 'Middernacht';

  @override
  String get themeSunset => 'Zonsondergang';

  @override
  String get themePeach => 'Perzik';

  @override
  String get themeForest => 'Bos';

  @override
  String get themeOcean => 'Oceaan';

  @override
  String get themeMono => 'Mono';

  @override
  String get tidyNoName => '(geen naam)';

  @override
  String tidyDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count namen opgeschoond.',
      one: '1 naam opgeschoond.',
    );
    return '$_temp0';
  }

  @override
  String get tidyTitle => 'Accountnamen opschonen';

  @override
  String get tidyNothing => 'Al je accountnamen zijn al netjes.';

  @override
  String get tidyIntro =>
      'Deze namen bevatten websiteadressen of extra stukjes. Vink uit wat je zo wilt houden en tik dan op Toepassen. Je codes veranderen niet.';

  @override
  String tidyWas(String name) {
    return 'Was: $name';
  }

  @override
  String get tidyNothingTicked => 'Niets aangevinkt';

  @override
  String tidyApply(int count) {
    return '$count toepassen';
  }

  @override
  String get emergencyNotContactCode =>
      'Dat is geen contactcode van Tanooki Auth. Vraag ze om Tanooki Auth te openen, naar Instellingen > Noodtoegang te gaan en hun contactcode te delen.';

  @override
  String get emergencyCopyWontOpen =>
      'De noodkopie kon niet worden geopend met de sleutel van dit apparaat. Hij is voor een ander apparaat gemaakt, of hij is beschadigd.';

  @override
  String get emergencyGone =>
      'Deze noodkopie bestaat niet meer. De eigenaar heeft hem verwijderd.';

  @override
  String get emergencyWaitNotOver =>
      'De wachttijd van 7 dagen is nog niet voorbij.';

  @override
  String get emergencyNotOwnerOrContact =>
      'Dit apparaat is niet de eigenaar of het contact voor die noodkopie.';

  @override
  String get emergencyNoRequestToDeny =>
      'Er is geen verzoek meer om te weigeren.';

  @override
  String get emergencyAskFirst => 'Vraag eerst om toegang.';

  @override
  String get emergencyTooBig =>
      'Je accounts zijn te groot om als noodkopie achter te laten (de limiet is ongeveer 500 KB).';

  @override
  String get emergencyTooManyTries =>
      'Te veel pogingen in één minuut. Wacht een minuut en probeer het opnieuw.';

  @override
  String emergencyServerSaidNo(String status) {
    return 'De syncserver weigerde (HTTP $status).';
  }

  @override
  String emergencyServerSaidNoWhy(String status, String reason) {
    return 'De syncserver weigerde (HTTP $status: $reason).';
  }

  @override
  String get emergencyNotEmergencyCode =>
      'Dat is geen noodcode van Tanooki Auth. Vraag degene die jou koos om hem opnieuw te sturen via Instellingen > Noodtoegang.';

  @override
  String get emergencyLessThanMinute => 'minder dan een minuut';

  @override
  String emergencyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dagen',
      one: '1 dag',
    );
    return '$_temp0';
  }

  @override
  String emergencyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uur',
      one: '1 uur',
    );
    return '$_temp0';
  }

  @override
  String emergencyMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuten',
      one: '1 minuut',
    );
    return '$_temp0';
  }

  @override
  String emergencyDaysHours(int days, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagen',
      one: '1 dag',
    );
    String _temp1 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours uur',
      one: '1 uur',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get emergencyUiExplainer =>
      'Kies één persoon die je vertrouwt. Als jou iets overkomt, kan diegene om je accounts vragen. Je apparaten krijgen een melding en je hebt 7 dagen om nee te zeggen. Zegt niemand nee, dan krijgt diegene een kopie.\n\nDe Tanooki Auth-server bewaakt alleen de wachttijd van 7 dagen. De kopie is vergrendeld met een sleutel die alleen hun apparaat heeft, dus de server kan hem niet lezen, en iemand die inbreekt op de server ook niet.';

  @override
  String emergencyUiPushNotWorking(String reason) {
    return 'Meldingen werken nog niet ($reason). Tanooki Auth kijkt elke keer dat je hem opent of er verzoeken zijn.';
  }

  @override
  String get emergencyUiScanTheirQr => 'Scan hun QR-code';

  @override
  String get emergencyUiPasteCode => 'Plak een code die ze stuurden';

  @override
  String get emergencyUiWrongCode => 'Dat is niet de juiste code.';

  @override
  String get emergencyUiCopiedCode =>
      'Gekopieerd. Stuur hem op elke manier die je wilt: er staan geen geheimen in.';

  @override
  String get emergencyUiCopyAsText => 'Kopiëren als tekst';

  @override
  String get emergencyUiTheirContactCode => 'Hun contactcode';

  @override
  String get emergencyUiNotContactCodeShort =>
      'Dat is geen contactcode van Tanooki Auth.';

  @override
  String get emergencyUiMakeThemContact => 'Diegene je noodcontact maken?';

  @override
  String emergencyUiMakeNamedContact(String name) {
    return '$name je noodcontact maken?';
  }

  @override
  String get emergencyUiCopyLeftOnServer =>
      'Een kopie van al je accounts wordt vergrendeld voor hun apparaat en achtergelaten op de Tanooki Auth-server. Hij wordt bijgewerkt als je je accounts wijzigt.';

  @override
  String get emergencyUiYourNameWhose =>
      'Je naam (zodat ze weten van wie de kopie is)';

  @override
  String get emergencyUiDoneGiveCode =>
      'Klaar. Geef ze nu de code op dit scherm.';

  @override
  String get emergencyUiStopTitle => 'Noodtoegang stoppen?';

  @override
  String get emergencyUiStopBody =>
      'De kopie wordt van de server verwijderd en ze kunnen er niet meer om vragen.';

  @override
  String get emergencyUiChooseContact => 'Kies een noodcontact';

  @override
  String get emergencyUiChooseContactPremium =>
      'Kies een noodcontact (Premium)';

  @override
  String get emergencyUiChooseContactHow =>
      'Ze openen Tanooki Auth op hun apparaat, gaan naar Instellingen > Noodtoegang en laten je hun contactcode zien.';

  @override
  String get emergencyUiYourContact => 'Je contact';

  @override
  String get emergencyUiChecking => 'Navragen bij de server…';

  @override
  String get emergencyUiIdleJustNow =>
      'Niemand heeft gevraagd. Kopie zojuist bijgewerkt.';

  @override
  String emergencyUiIdleUpdated(String day) {
    return 'Niemand heeft gevraagd. Kopie laatst bijgewerkt op $day.';
  }

  @override
  String emergencyUiWaiting(String who, String day, String left) {
    return '$who vroeg erom op $day. Diegene kan de kopie openen over $left, tenzij jij weigert.';
  }

  @override
  String emergencyUiReleased(String who) {
    return '$who vroeg erom en de wachttijd is voorbij: diegene kan de kopie nu openen. Weiger om dat te stoppen.';
  }

  @override
  String emergencyUiContactIs(String who) {
    return 'Noodcontact: $who';
  }

  @override
  String get emergencyUiDenied =>
      'Geweigerd. Ze kunnen je accounts niet openen. Ze kunnen later opnieuw vragen.';

  @override
  String get emergencyUiCopyUpdated => 'Kopie bijgewerkt.';

  @override
  String get emergencyUiCouldntUpdate => 'Kon de kopie niet bijwerken.';

  @override
  String get emergencyUiUpdateNow => 'Kopie nu bijwerken';

  @override
  String emergencyUiGiveCode(String who) {
    return 'Geef $who deze code. In Tanooki Auth gaat diegene naar Instellingen > Noodtoegang > \"Code toevoegen die je kreeg\".';
  }

  @override
  String get emergencyUiCodeTheyGave => 'Code die je kreeg';

  @override
  String get emergencyUiNotEmergencyCodeShort =>
      'Dat is geen noodcode van Tanooki Auth.';

  @override
  String get emergencyUiAddedTheir =>
      'Toegevoegd. Je kunt hier om hun accounts vragen als je ze ooit nodig hebt.';

  @override
  String emergencyUiAddedNamed(String name) {
    return 'Toegevoegd. Je kunt hier om de accounts van $name vragen als je ze ooit nodig hebt.';
  }

  @override
  String get emergencyUiTheOwner => 'de eigenaar';

  @override
  String get emergencyUiAskTitle => 'Om noodtoegang vragen?';

  @override
  String emergencyUiAskBody(String who) {
    return '$who krijgt een melding en heeft 7 dagen om nee te zeggen. Gebeurt dat niet, dan kun je hier een kopie van hun accounts openen. Vraag het alleen als het echt nodig is.';
  }

  @override
  String get emergencyUiAsk => 'Vragen';

  @override
  String get emergencyUiAsked =>
      'Gevraagd. De wachttijd van 7 dagen is begonnen.';

  @override
  String emergencyUiAddTheirAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hun $count accounts toevoegen?',
      one: 'Hun 1 account toevoegen?',
    );
    return '$_temp0';
  }

  @override
  String emergencyUiAddNamedAccounts(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts van $name toevoegen?',
      one: '1 account van $name toevoegen?',
    );
    return '$_temp0';
  }

  @override
  String get emergencyUiSomeone => 'Iemand';

  @override
  String get emergencyUiCheckingShort => 'Controleren…';

  @override
  String get emergencyUiNotAsked => 'Je hebt niet gevraagd.';

  @override
  String get emergencyUiRequestAccess => 'Toegang vragen';

  @override
  String emergencyUiOpensIn(String left, String day) {
    return 'Je hebt gevraagd. Gaat open over $left ($day), tenzij ze nee zeggen.';
  }

  @override
  String get emergencyUiWaitOver => 'De wachttijd is voorbij.';

  @override
  String get emergencyUiOpenCopy => 'Noodkopie openen';

  @override
  String emergencyUiPersonAccounts(String who) {
    return 'Accounts van $who';
  }

  @override
  String get emergencyUiYourContactCode => 'Je contactcode';

  @override
  String get emergencyUiShowThis =>
      'Wil iemand jou als noodcontact, laat dit dan zien. Er staan geen geheimen in.';

  @override
  String get emergencyUiYourNameItsYou =>
      'Je naam (zodat ze weten dat jij het bent)';

  @override
  String get emergencyUiShowMyCode => 'Mijn contactcode tonen';

  @override
  String get emergencyUiLetThemScan =>
      'Laat ze dit scannen in Tanooki Auth, of kopieer het en stuur het naar ze.';

  @override
  String get emergencyUiAddCodeGiven => 'Code toevoegen die je kreeg';

  @override
  String get emergencyUiAddCodeGivenHow =>
      'Nadat ze jou kozen, toont hun app een code voor jou';

  @override
  String get emergencyUiTitle => 'Noodtoegang';

  @override
  String get emergencyUiYourEmergencyContact => 'Je noodcontact';

  @override
  String get emergencyUiPeopleWhoChoseYou => 'Mensen die jou kozen';

  @override
  String get securityUiProofWindows => 'Windows Hello';

  @override
  String get securityUiProofMac => 'Touch ID of je wachtwoord';

  @override
  String get securityUiProofIos => 'Face ID of toegangscode';

  @override
  String get securityUiProofOther => 'vingerafdruk of pincode';

  @override
  String securityUiPasscodeAtLeast(int count) {
    return 'Toegangscode (minstens $count cijfers)';
  }

  @override
  String get securityUiTypeAgain => 'Typ hem nog een keer';

  @override
  String get securityUiPasscodesDontMatch =>
      'De twee toegangscodes komen niet overeen.';

  @override
  String get securityUiPickDifferent =>
      'Kies een andere toegangscode dan je andere.';

  @override
  String get securityUiEnterPasscode => 'Voer je app-toegangscode in';

  @override
  String get securityUiPasscode => 'Toegangscode';

  @override
  String get securityUiWrongPasscode => 'Dat is niet je toegangscode.';

  @override
  String get securityUiCheckupTitle => 'Beveiligingscontrole';

  @override
  String get securityUiAllGood => 'Alles in orde';

  @override
  String get securityUiAllGoodBody =>
      'Je app is vergrendeld, je hebt een recente back-up, en elk account heeft herstelcodes.';

  @override
  String get securityUiLockOffTitle => 'De app is niet vergrendeld';

  @override
  String get securityUiLockOffBody =>
      'Iedereen die je ontgrendelde apparaat oppakt, kan je codes zien. Zet \"App vergrendelen\" of een app-toegangscode aan in Instellingen.';

  @override
  String get securityUiNoPasscodeTitle => 'Geen app-toegangscode';

  @override
  String get securityUiNoPasscodeBody =>
      'Met een toegangscode kun je Tanooki Auth openen, ook als Face ID of je vingerafdruk niet meer werkt. Stel er een in via Instellingen.';

  @override
  String get securityUiAutoBackupFailed => 'Automatische back-up mislukt';

  @override
  String get securityUiOpenAutoBackups => 'Automatische back-ups openen';

  @override
  String get securityUiNoBackupTitle => 'Geen back-up in de afgelopen 30 dagen';

  @override
  String get securityUiNoBackupBody =>
      'Als dit apparaat kwijtraakt of kapotgaat, is een back-up de enige manier om je accounts terug te krijgen.';

  @override
  String get securityUiMakeBackupNow => 'Nu een back-up maken';

  @override
  String securityUiNoRecoveryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts hebben geen herstelcodes',
      one: '1 account heeft geen herstelcodes',
    );
    return '$_temp0';
  }

  @override
  String securityUiNoRecoveryBody(String names) {
    return 'Met herstelcodes kom je in een website als je deze app kwijtraakt. Je vindt ze in de beveiligingsinstellingen van elke site; voeg ze daarna toe via ⋯ > Herstelcodes bij het account.\n\n$names';
  }

  @override
  String get securityUiRecoveryKit => 'Je herstelpakket';

  @override
  String get securityUiRecoveryKitSub =>
      'Back-up, herstelcodes en een papieren kopie, stap voor stap';

  @override
  String securityUiBreachSnack(String sites) {
    return '$sites had een datalek. Wijzig daar je wachtwoord.';
  }

  @override
  String get securityUiBreachDownloadFailed =>
      'Kon de lijst met datalekken niet downloaden. Controleer je internetverbinding en probeer het opnieuw.';

  @override
  String get securityUiBreachAlerts => 'Meldingen bij datalekken';

  @override
  String get securityUiBreachAlertsPremium =>
      'Meldingen bij datalekken (Premium)';

  @override
  String get securityUiBreachAlertsSub =>
      'Laat je één keer per week weten of een website die je gebruikt een datalek had';

  @override
  String get securityUiBreachHow =>
      'Zo werkt het: Tanooki Auth downloadt de openbare lijst met bekende datalekken van haveibeenpwned.com en vergelijkt die op dit apparaat met je bewaarde websites. Er wordt niets over jou of je accounts verstuurd: iedereen krijgt dezelfde download. Behalve voor sync en het kopen van Premium is dit de enige keer dat de app online gaat.';

  @override
  String securityUiNoWebsite(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count van je accounts hebben geen website bewaard, dus ze kunnen niet worden gecontroleerd. Voeg er een toe via ⋯ > Bewerken.',
      one: '1 van je accounts heeft geen website bewaard, dus het kan niet worden gecontroleerd. Voeg er een toe via ⋯ > Bewerken.',
    );
    return '$_temp0';
  }

  @override
  String get securityUiCheckNow => 'Nu controleren';

  @override
  String get securityUiNoBreaches =>
      'Geen bekende datalekken voor je bewaarde websites.';

  @override
  String get securityUiBreached =>
      'Gelekt. Heb je je wachtwoord daarvoor gemaakt, wijzig het daar dan.';

  @override
  String securityUiBreachedOn(String date) {
    return 'Gelekt op $date. Heb je je wachtwoord daarvoor gemaakt, wijzig het daar dan.';
  }

  @override
  String securityUiBreachedLeaked(String data) {
    return 'Gelekt. Uitgelekt: $data. Heb je je wachtwoord daarvoor gemaakt, wijzig het daar dan.';
  }

  @override
  String securityUiBreachedOnLeaked(String date, String data) {
    return 'Gelekt op $date. Uitgelekt: $data. Heb je je wachtwoord daarvoor gemaakt, wijzig het daar dan.';
  }

  @override
  String get securityUiKitIntro =>
      'Als je dit apparaat kwijtraakt, kom je hiermee weer in je accounts. Elk kost een minuutje. Heb je nog geen accounts toegevoegd, voeg ze dan eerst toe en kom hier terug via Instellingen > Beveiligingscontrole.';

  @override
  String get securityUiKitBackupTitle => 'Maak een back-up';

  @override
  String get securityUiKitBackupBody =>
      'Een versleuteld bestand, vergrendeld met een wachtwoordzin die jij kiest. Bewaar het ergens anders dan op dit apparaat, zoals iCloud Drive, Google Drive of een usb-stick.';

  @override
  String get securityUiKitBackupButton => 'Back-up maken';

  @override
  String get securityUiKitCodesTitle => 'Bewaar je herstelcodes';

  @override
  String get securityUiKitCodesBody =>
      'Als je tweestapsverificatie aanzet, geven de meeste websites je een lijst met eenmalige herstelcodes. Voeg ze aan elk account toe via ⋯ > Herstelcodes, zodat ze ook in je back-up staan.';

  @override
  String get securityUiKitPaperTitle => 'Print een papieren back-up';

  @override
  String get securityUiKitPaperBody =>
      'Optioneel. Een geprinte pagina met QR-codes werkt ook als al je apparaten weg zijn. Bewaar hem achter slot: iedereen die hem heeft, kan je codes maken.';

  @override
  String get securityUiKitPaperButton => 'Papieren back-up printen';

  @override
  String get securityUiSkipForNow => 'Nu overslaan';

  @override
  String get securityExtrasPrivacy =>
      'Geen account, geen tracking. Je instelsleutels worden versleuteld op dit apparaat bewaard. De app gaat alleen online voor: een klokcontrole (hij vraagt de Tanooki Auth-server hoe laat het is, hooguit één keer per uur terwijl er codes op het scherm staan en als je op \"Werken codes niet?\" tikt; er wordt niets over jou of je accounts verstuurd), meldingen bij datalekken als je die aanzet (downloadt de openbare lijst met datalekken), sync, telefoonkoppeling en noodtoegang als je die instelt (die versturen alleen versleutelde gegevens die de server niet kan lezen), Premium kopen, en feedback die je zelf stuurt (je bericht, je e-mailadres als je dat invult, en de appversie en het apparaattype als je dat aangevinkt laat; nooit je accounts, codes of iets anders uit de app). 2FA-handleidingen openen in je webbrowser.';

  @override
  String get securityExtrasMonthlyBody =>
      'Je maandelijkse beveiligingsoverzicht staat klaar. Open Tanooki Auth om het te bekijken.';

  @override
  String get securityExtrasNotificationsOffIos =>
      'Meldingen staan uit voor Tanooki Auth. Zet ze aan in de app Instellingen van je iPhone, onder Berichtgeving, en probeer het opnieuw.';

  @override
  String get securityExtrasNotificationsOffMac =>
      'Meldingen staan uit voor Tanooki Auth. Zet ze aan in Systeeminstellingen, onder Berichtgeving, en probeer het opnieuw.';

  @override
  String securityExtrasReminderFailed(String reason) {
    return 'Kon de herinnering niet instellen ($reason).';
  }

  @override
  String get securityExtrasRemindersUnavailable =>
      'Herinneringen zijn nog niet beschikbaar op dit apparaat.';

  @override
  String securityExtrasDayTime(String day, String time) {
    return '$day, $time';
  }

  @override
  String get securityExtrasClearTitle => 'Activiteitengeschiedenis wissen?';

  @override
  String get securityExtrasClearBody =>
      'Elke regel wordt van dit apparaat verwijderd. Je accounts blijven onaangeroerd.';

  @override
  String get securityExtrasActivityTitle => 'Activiteitengeschiedenis';

  @override
  String securityExtrasActivityPitch(int count) {
    return 'Activiteitengeschiedenis hoort bij Premium. Hij bewaart de laatste $count keer dat een code is gekopieerd, op een website ingevuld, getypt, als QR-code getoond of geëxporteerd, alleen op dit apparaat.';
  }

  @override
  String get securityExtrasNothingYet =>
      'Nog niets. Kopiëren, invullen, typen, een QR-code tonen of exporteren verschijnt hier.';

  @override
  String get securityExtrasAllAccounts => 'Alle accounts';

  @override
  String get securityExtrasDeletedAccount => 'Een verwijderd account';

  @override
  String securityExtrasActivityLine(String kind, String what) {
    return '$kind: $what';
  }

  @override
  String get securityExtrasGetPremium => 'Premium kopen';

  @override
  String get securityExtrasAddKey => 'Beveiligingssleutel toevoegen';

  @override
  String get securityExtrasAddKeyPremium =>
      'Beveiligingssleutel toevoegen (Premium)';

  @override
  String get securityExtrasAddKeyIos =>
      'Houd de sleutel daarna tegen de bovenkant van je iPhone, of steek hem erin, als daarom wordt gevraagd. Misschien moet je hem twee keer aanraken.';

  @override
  String get securityExtrasAddKeyOther =>
      'Steek de sleutel er daarna in en raak hem aan als hij knippert. Misschien moet je hem twee keer aanraken, en de pincode typen als hij er een heeft.';

  @override
  String get securityExtrasKeyName =>
      'Naam (zodat je je sleutels uit elkaar kunt houden)';

  @override
  String securityExtrasKeyAdded(String name) {
    return '\"$name\" toegevoegd. Je kunt Tanooki Auth er nu mee ontgrendelen op dit apparaat.';
  }

  @override
  String securityExtrasKeyRemoved(String name) {
    return '\"$name\" verwijderd. Hij kan Tanooki Auth niet meer ontgrendelen.';
  }

  @override
  String get securityExtrasKeysTitle => 'Beveiligingssleutels';

  @override
  String securityExtrasKeysIntro(String usual) {
    return 'Een beveiligingssleutel (zoals een YubiKey) kan Tanooki Auth ontgrendelen in plaats van $usual. De sleutel bevat een geheim dat hem nooit verlaat, en de app gebruikt dat om de sleutel tot je accounts af te sluiten. Raak je de sleutel kwijt, dan kun je nog steeds op de gewone manier ontgrendelen.';
  }

  @override
  String securityExtrasKeyAddedOn(String day) {
    return 'Toegevoegd op $day';
  }

  @override
  String get securityExtrasLockOffNote =>
      'De appvergrendeling staat uit, dus de app opent zonder te vragen. Zet \"App vergrendelen\" of een toegangscode aan in Instellingen om je sleutel te gebruiken.';

  @override
  String get securityExtrasLockWordWindows =>
      'Windows Hello of je toegangscode';

  @override
  String get securityExtrasLockWordMac => 'Touch ID of je toegangscode';

  @override
  String get securityExtrasLockWordOther => 'Face ID of je toegangscode';

  @override
  String get securityLockImmediately => 'Meteen';

  @override
  String get securityLockAfter30s => 'Na 30 seconden';

  @override
  String get securityLockAfter1m => 'Na 1 minuut';

  @override
  String get securityLockAfter5m => 'Na 5 minuten';

  @override
  String get securityNumbersOnly => 'Gebruik alleen cijfers.';

  @override
  String securityAtLeastNumbers(int count) {
    return 'Gebruik minstens $count cijfers.';
  }

  @override
  String get securitySameNumber => 'Gebruik niet steeds hetzelfde cijfer.';

  @override
  String get securityNumbersInRow =>
      'Gebruik geen opeenvolgende cijfers zoals 123456.';

  @override
  String get securityPanicNeedsPasscode =>
      'Stel eerst een app-toegangscode in. Noodwissen telt verkeerde toegangscodes.';

  @override
  String get securityPanicNeedsBackup =>
      'Maak eerst een back-up (Instellingen > Back-up exporteren). Noodwissen wist elk account, dus het gaat alleen aan als je de afgelopen 30 dagen een back-up hebt gemaakt.';

  @override
  String get securityKeyDefaultName => 'Beveiligingssleutel';

  @override
  String get securityKeyNotYours =>
      'Die beveiligingssleutel heb je niet aan Tanooki Auth toegevoegd op dit apparaat.';

  @override
  String get securityKeyNotAvailable => 'Nog niet beschikbaar op dit apparaat.';

  @override
  String get securityKeyWindowsTooOld =>
      'Nog niet beschikbaar op deze versie van Windows. Installeer de nieuwste updates voor Windows 11.';

  @override
  String get securityKeyIosTooOld =>
      'Vereist iOS 26.4 of nieuwer. Werk bij in de app Instellingen en probeer het opnieuw.';

  @override
  String get securityKeyMacTooOld =>
      'Vereist macOS 26.4 of nieuwer. Werk bij in de app Instellingen en probeer het opnieuw.';

  @override
  String get securityKeyDidntWork =>
      'De beveiligingssleutel werkte niet. Probeer het opnieuw.';

  @override
  String securityKeyDidntWorkWhy(String reason) {
    return 'De beveiligingssleutel werkte niet ($reason). Probeer het opnieuw.';
  }

  @override
  String get securityKeyCanceled => 'Geannuleerd. Er is niets veranderd.';

  @override
  String get securityKeyNoPrf =>
      'Deze beveiligingssleutel kan apps niet op deze manier ontgrendelen (hij heeft de functie \"hmac-secret\" niet). De YubiKey 5-serie en de meeste FIDO2-sleutels van de laatste jaren wel.';

  @override
  String get securityKeyNotAllowed =>
      'De beveiligingssleutel antwoordde niet, of hij is hier niet toegevoegd. Steek hem erin (of houd hem tegen de bovenkant van je telefoon) en raak hem aan als hij knippert.';

  @override
  String get securityKeyNotAssociated =>
      'Deze kopie van Tanooki Auth mag nog geen beveiligingssleutels gebruiken: Apple wil eerst dat de app gekoppeld is aan auth.tanookistudios.com. Dat moeten wij regelen, niet jij.';

  @override
  String get securityKeyExists => 'Deze beveiligingssleutel is al toegevoegd.';

  @override
  String get securityKeyPin =>
      'De beveiligingssleutel heeft zijn pincode nodig, en die is niet ingevoerd. Probeer het opnieuw en typ de pincode van de sleutel als daarom wordt gevraagd.';

  @override
  String get securityKeyVaultKeyMissing =>
      'De sleutel die je accounts ontgrendelt ontbreekt, dus er kan geen beveiligingssleutel worden toegevoegd.';

  @override
  String get securityKeyNoneAdded =>
      'Er is geen beveiligingssleutel toegevoegd op dit apparaat.';

  @override
  String get securityKeyBeforeReset =>
      'Die beveiligingssleutel is toegevoegd voordat je accounts werden gereset, dus hij kan ze niet openen. Verwijder hem en voeg hem opnieuw toe.';

  @override
  String get backupUiChoosePassphrase => 'Kies een back-upwachtwoordzin';

  @override
  String get backupUiPassphraseTitle => 'Back-upwachtwoordzin';

  @override
  String get backupUiPassphraseWarning =>
      'Je hebt deze nodig om de back-up terug te zetten. Niemand, wij ook niet, kan hem herstellen als je hem vergeet. Schrijf hem op en bewaar hem op een veilige plek.';

  @override
  String get backupUiPassphrase => 'Wachtwoordzin';

  @override
  String get backupUiTypeAgain => 'Typ hem nog een keer';

  @override
  String get backupUiTooShort =>
      'Gebruik minstens 8 tekens. Een paar willekeurige woorden werkt goed.';

  @override
  String get backupUiNoMatch => 'De twee wachtwoordzinnen komen niet overeen.';

  @override
  String get backupUiTypePassphrase => 'Typ de wachtwoordzin.';

  @override
  String get backupUiNothingToBackUp =>
      'Er zijn nog geen accounts om een back-up van te maken.';

  @override
  String get backupUiEncrypting => 'Back-up versleutelen…';

  @override
  String backupUiSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Back-up van $count accounts bewaard.',
      one: 'Back-up van 1 account bewaard.',
    );
    return '$_temp0';
  }

  @override
  String get backupUiNotABackup =>
      'Dat bestand is geen back-up van Tanooki Auth.';

  @override
  String get backupUiUnlocking => 'Back-up ontgrendelen…';

  @override
  String backupUiImported(int count) {
    return '$count geïmporteerd.';
  }

  @override
  String backupUiImportedSkipped(int added, int skipped) {
    return '$added geïmporteerd, $skipped overgeslagen.';
  }

  @override
  String backupUiImportedSkippedAlready(int added, int skipped) {
    return '$added geïmporteerd, $skipped overgeslagen die al in je lijst stonden.';
  }

  @override
  String backupUiAdded(int count) {
    return '$count toegevoegd.';
  }

  @override
  String backupUiAddedSkipped(int added, int skipped) {
    return '$added toegevoegd, $skipped overgeslagen.';
  }

  @override
  String backupUiAddedSkippedAlready(int added, int skipped) {
    return '$added toegevoegd, $skipped overgeslagen die al in je lijst stonden.';
  }

  @override
  String backupUiAlreadyInList(int count) {
    return '• $count staan al in je lijst';
  }

  @override
  String get backupUiImport => 'Importeren';

  @override
  String backupUiImportFromGoogle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importeren uit Google Authenticator?',
      one: '1 importeren uit Google Authenticator?',
    );
    return '$_temp0';
  }

  @override
  String get backupUiGoogleMoreCodes =>
      'Toonde Google Authenticator meer dan één QR-code, scan ze dan allemaal.';

  @override
  String get backupUiNothingToExport =>
      'Er zijn nog geen accounts om te exporteren.';

  @override
  String get backupUiPlainWhat =>
      'Dit bewaart elke instelsleutel als gewone tekst, om over te zetten naar een andere authenticator-app.';

  @override
  String get backupUiPlainTitle => 'Onversleuteld exporteren?';

  @override
  String backupUiPlainBody(String what) {
    return '$what Iedereen die dit bestand krijgt, kan je inlogcodes maken. Importeer het en verwijder het meteen daarna. Gebruik voor een normale back-up liever \"Back-up exporteren\".';
  }

  @override
  String get backupUiUnderstandExport => 'Ik begrijp het, exporteren';

  @override
  String get backupUiNothingToPrint =>
      'Er zijn nog geen accounts om te printen.';

  @override
  String get backupUiPaperTitle => 'Papieren back-up printen?';

  @override
  String get backupUiPaperBody =>
      'Dit maakt een pdf met een QR-code voor elk account, plus je ongebruikte herstelcodes. Iedereen die dat papier ziet of fotografeert, kan je inlogcodes maken, voor altijd, zonder je telefoon of wachtwoord.\n\nPrint het en verwijder daarna de pdf. Bewaar het papier achter slot, zoals in een kluisje of bij belangrijke documenten. Mail het niet, en bewaar het niet in een gedeelde map.';

  @override
  String get backupUiUnderstandPdf => 'Ik begrijp het, maak de pdf';

  @override
  String get backupUiMakingPdf => 'Pdf maken…';

  @override
  String get backupUiPdfReady =>
      'Pdf klaar. Print hem en verwijder daarna het bestand.';

  @override
  String get backupUiWorksTitle => 'Back-up werkt';

  @override
  String backupUiWorksBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Deze back-up opent goed en bevat $count accounts. Er is niets toegevoegd of gewijzigd.',
      one: 'Deze back-up opent goed en bevat 1 account. Er is niets toegevoegd of gewijzigd.',
    );
    return '$_temp0';
  }

  @override
  String get backupWrongVersion =>
      'Deze back-up is gemaakt met een nieuwere versie van Tanooki Auth. Werk de app bij en probeer het opnieuw.';

  @override
  String get backupWrongPassphrase =>
      'Verkeerde wachtwoordzin, of het back-upbestand is beschadigd.';

  @override
  String get backupDamaged =>
      'De back-up is ontgrendeld, maar de inhoud is beschadigd.';

  @override
  String get paperBackupTitle => 'Papieren back-up van Tanooki Auth';

  @override
  String paperBackupHeader(String date) {
    return 'Papieren back-up van Tanooki Auth, $date';
  }

  @override
  String get paperBackupWarning =>
      'HOUD DIT GEHEIM. Iedereen met dit papier kan je inlogcodes maken. Bewaar het achter slot; versnipper het als je een nieuwe maakt. Terugzetten: kies in een authenticator-app \"QR-code scannen\" en scan elke code hieronder.';

  @override
  String paperBackupSetupKey(String key) {
    return 'Instelsleutel: $key';
  }

  @override
  String get paperBackupRecoveryCodes =>
      'Herstelcodes (elke code werkt één keer):';

  @override
  String get autoBackupUiChooseFolderDialog =>
      'Kies een map voor automatische back-ups';

  @override
  String autoBackupUiToday(String time) {
    return 'Vandaag om $time';
  }

  @override
  String autoBackupUiYesterday(String time) {
    return 'Gisteren om $time';
  }

  @override
  String autoBackupUiOnDay(String date, String time) {
    return '$date om $time';
  }

  @override
  String get autoBackupUiBackingUp => 'Back-up maken…';

  @override
  String autoBackupUiBackedUp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Back-up van $count accounts gemaakt.',
      one: 'Back-up van 1 account gemaakt.',
    );
    return '$_temp0';
  }

  @override
  String get autoBackupUiCouldntUseFolder => 'Kon die map niet gebruiken.';

  @override
  String autoBackupUiCouldntUseFolderWhy(String reason) {
    return 'Kon die map niet gebruiken. $reason';
  }

  @override
  String get autoBackupUiTurnOffTitle => 'Automatische back-ups uitzetten?';

  @override
  String get autoBackupUiTurnOffBody =>
      'Back-ups die al in de map staan, blijven daar. De back-upwachtwoordzin wordt vergeten, dus je kiest een nieuwe als je dit weer aanzet.';

  @override
  String get autoBackupUiTitle => 'Automatische back-ups';

  @override
  String get autoBackupUiTitlePremium => 'Automatische back-ups (Premium)';

  @override
  String autoBackupUiIntro(int count) {
    return 'Eén keer per dag bewaart Tanooki Auth een versleutelde back-up in een map die jij kiest. Kies je map in iCloud Drive, Google Drive of Dropbox, dan staan je back-ups ook buiten dit apparaat. De nieuwste $count blijven bewaard; oudere worden verwijderd.\n\nZet er een terug via Instellingen > Back-up importeren met je back-upwachtwoordzin.';
  }

  @override
  String get autoBackupUiLastFailed =>
      'De laatste automatische back-up is mislukt';

  @override
  String get autoBackupUiChooseFolder => 'Kies een map';

  @override
  String get autoBackupUiBackupFolder => 'Back-upmap';

  @override
  String get autoBackupUiNoBackupYet => 'Nog geen back-up';

  @override
  String autoBackupUiLastBackup(String when) {
    return 'Laatste back-up: $when';
  }

  @override
  String get autoBackupUiBackUpNow => 'Nu back-up maken';

  @override
  String get autoBackupUiChangeFolder => 'Map wijzigen';

  @override
  String get autoBackupUiOffSubtitle =>
      'Uit. Een dagelijkse versleutelde back-up naar iCloud Drive, Google Drive, Dropbox of een andere map.';

  @override
  String autoBackupUiOnNoBackup(String folder) {
    return 'Aan, naar $folder. Nog geen back-up.';
  }

  @override
  String autoBackupUiOnLast(String folder, String when) {
    return 'Aan, naar $folder. Laatste back-up: $when.';
  }

  @override
  String get autoBackupFolderGone =>
      'De back-upmap is weg. Misschien is hij verwijderd, buiten de app hernoemd, of is de schijf losgekoppeld. Kies de map opnieuw.';

  @override
  String get autoBackupPermissionLost =>
      'Tanooki Auth mag niet meer in de back-upmap schrijven. Kies de map opnieuw om weer toestemming te geven.';

  @override
  String get autoBackupDiskFull =>
      'De schijf van de back-upmap is vol. Maak wat ruimte vrij en tik dan op Nu back-up maken.';

  @override
  String get autoBackupOther =>
      'De back-up kon niet worden bewaard. Tik op Nu back-up maken om het opnieuw te proberen.';

  @override
  String autoBackupOtherWhy(String reason) {
    return 'De back-up kon niet worden bewaard ($reason). Tik op Nu back-up maken om het opnieuw te proberen.';
  }

  @override
  String get importUiDeleteNote =>
      'Verwijder het exportbestand als je klaar bent: iedereen die het krijgt, kan je codes maken.';

  @override
  String get importUiStepsAegis =>
      'In Aegis op je Android-telefoon:\n\n1. Tik op ⋮, dan op Instellingen en dan op \"Importeren & exporteren\".\n2. Tik op \"Exporteren\" en kies \"Aegis (.JSON)\".\n3. Laat \"De kluis versleutelen\" aan als je wilt; dat wachtwoord typ je dan hier.\n4. Bewaar het bestand ergens waar dit apparaat het kan openen (bijvoorbeeld Google Drive, of mail het naar jezelf).\n\nKies dat bestand dan hier.';

  @override
  String get importUiStepsTwoFas =>
      'In 2FAS:\n\n1. Open Instellingen en dan \"2FAS-back-up\".\n2. Tik op \"Exporteren naar bestand\". Vraagt hij om een wachtwoord, dan typ je hier hetzelfde.\n3. Bewaar het .2fas-bestand ergens waar dit apparaat het kan openen.\n\nKies dat bestand dan hier.';

  @override
  String get importUiStepsAuthy =>
      'Authy heeft geen exportknop, en Authy voor computers is in 2024 stopgezet.\n\nHeb je je accounts er al uit gehaald met een tool zoals \"authy-export\", kies dan het bestand dat die maakte (een .json-bestand, of een .txt-lijst met otpauth://-links).\n\nZo niet, dan is de veilige manier één account tegelijk: log in bij elke website, zet tweestapsverificatie uit en weer aan, en scan de nieuwe QR-code met Tanooki Auth. Houd Authy tot elk account hier werkt.';

  @override
  String get importUiStepsBitwarden =>
      'In Bitwarden (website of desktop-app):\n\n1. Ga naar Hulpmiddelen en dan \"Kluis exporteren\".\n2. Kies \".json\" of \".csv\". Niet \"versleuteld\".\n3. Bewaar het bestand.\n\nKies dat bestand dan hier. Alleen logins met een authenticatorsleutel komen mee; je wachtwoorden worden genegeerd.';

  @override
  String get importUiStepsOnePassword =>
      'In de 1Password-app voor Mac of Windows:\n\n1. Klik op Bestand, dan op Exporteren, en kies je account.\n2. Kies \"CSV\" als indeling en bewaar.\n\nKies dat bestand dan hier. Alleen items met een eenmalig wachtwoord komen mee; je wachtwoorden worden genegeerd.';

  @override
  String get importUiStepsApple =>
      'Hiervoor heb je een Mac nodig; een iPhone kan het bestand niet bewaren.\n\nOp een Mac met macOS Sequoia of nieuwer:\n1. Open de app Wachtwoorden.\n2. Klik in de menubalk op Archief en dan op \"Exporteer alle wachtwoorden…\".\n3. Klik op \"Exporteer wachtwoorden\", typ je Mac-wachtwoord als daarom wordt gevraagd, en bewaar het bestand.\n\nOp een oudere Mac: open Safari, dan Safari > Instellingen > Wachtwoorden, klik op de knop ⋯ en kies \"Exporteer alle wachtwoorden…\".\n\nKies dat bestand dan hier. Alleen items met een verificatiecode komen mee; je wachtwoorden worden genegeerd.';

  @override
  String get importUiStepsMicrosoft =>
      'Microsoft Authenticator kan je accounts niet exporteren, dus ze kunnen niet in één keer worden overgezet.\n\nVoor elk account:\n1. Log in bij die website op een computer.\n2. Zoek de instellingen voor beveiliging of tweestapsverificatie.\n3. Zet tweestapsverificatie uit en weer aan (of kies \"een nieuwe authenticator-app toevoegen\").\n4. Scan de nieuwe QR-code met Tanooki Auth en typ de code die hij toont om af te ronden.\n\nHoud Microsoft Authenticator tot elk account in Tanooki Auth werkt. Je Microsoft-account zelf kan ook Tanooki Auth gebruiken: voeg het toe via account.microsoft.com, onder Beveiliging.';

  @override
  String get importUiTitle => 'Overzetten vanuit een andere app';

  @override
  String get importUiCantExport =>
      'Kan niet exporteren: zo zet je elk account over';

  @override
  String get importUiFromExportFile => 'Uit een exportbestand';

  @override
  String importUiMoveFrom(String app) {
    return 'Overzetten vanuit $app';
  }

  @override
  String get importUiGotIt => 'Begrepen';

  @override
  String get importUiPickFile => 'Bestand kiezen';

  @override
  String get importUiCouldntRead => 'Dat bestand kon niet worden gelezen.';

  @override
  String importUiReading(String app) {
    return 'Export van $app lezen…';
  }

  @override
  String get importUiNoAccountsInFile =>
      'Er stonden geen accounts met tweestapsverificatie in dat bestand.';

  @override
  String importUiImportFrom(int count, String app) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count importeren uit $app?',
      one: '1 importeren uit $app?',
    );
    return '$_temp0';
  }

  @override
  String importUiExportPassword(String app) {
    return 'Exportwachtwoord van $app';
  }

  @override
  String get importUiPasswordHint =>
      'Het wachtwoord dat je koos bij het exporteren';

  @override
  String importersNotAnExport(String app) {
    return 'Dat bestand is geen export van $app.';
  }

  @override
  String importersLine(String line, String problem) {
    return 'Regel $line: $problem';
  }

  @override
  String get importersEmpty => 'Dat bestand is leeg.';

  @override
  String get importersNotAuthy => 'Dat bestand is geen export van Authy.';

  @override
  String get importersAnAccount => 'Een account';

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
    return '$name $problem';
  }

  @override
  String get importersAegisPassword =>
      'Deze Aegis-export is beveiligd met een wachtwoord.';

  @override
  String get importersAegisBiometricOnly =>
      'Deze Aegis-export kan alleen worden geopend met een vingerafdruk op de telefoon die hem maakte. Exporteer opnieuw in Aegis en kies een wachtwoord.';

  @override
  String get importersAegisWrongPassword =>
      'Verkeerd wachtwoord voor deze Aegis-export.';

  @override
  String get importersAegisDamaged =>
      'De Aegis-export is ontgrendeld, maar de inhoud is beschadigd.';

  @override
  String get importersNotAegis => 'Dat bestand is geen export van Aegis.';

  @override
  String importersUnsupportedType(String type) {
    return 'gebruikt $type-codes, en die ondersteunt Tanooki Auth niet';
  }

  @override
  String get importersNotTwoFas => 'Dat bestand is geen 2FAS-back-up.';

  @override
  String get importersTwoFasPassword =>
      'Deze 2FAS-back-up is beveiligd met een wachtwoord.';

  @override
  String get importersTwoFasDamaged => 'Deze 2FAS-back-up is beschadigd.';

  @override
  String get importersTwoFasWrongPassword =>
      'Verkeerd wachtwoord voor deze 2FAS-back-up.';

  @override
  String get importersBitwardenEncrypted =>
      'Die Bitwarden-export is versleuteld. Exporteer opnieuw in Bitwarden en kies de indeling \".json\" (niet \"versleuteld\").';

  @override
  String get importersOnePux =>
      'Dat lijkt een .1pux-bestand van 1Password. Exporteer opnieuw in 1Password en kies CSV.';

  @override
  String importersNoCodeColumn(String app) {
    return 'Dat bestand heeft geen kolom voor eenmalige codes, dus het is geen export van $app met codes erin.';
  }

  @override
  String importersCantReadCode(String reason) {
    return 'heeft een eenmalige code die Tanooki Auth niet kan lezen ($reason)';
  }

  @override
  String get importersNoSecret => 'heeft geen geheime sleutel';

  @override
  String get importersBadSecret =>
      'heeft een geheime sleutel die niet geldig is';

  @override
  String importersUnsupportedDigits(int count) {
    return 'gebruikt codes van $count cijfers, en die ondersteunt Tanooki Auth niet';
  }

  @override
  String get importersBadPeriod => 'heeft een kapotte tijdsperiode';

  @override
  String importersUnsupportedAlgorithm(String algorithm) {
    return 'gebruikt het algoritme $algorithm, en dat ondersteunt Tanooki Auth niet';
  }

  @override
  String get exportUiTitle => 'Overzetten naar een andere app';

  @override
  String get exportUiAegisLocked => 'Aegis, met een wachtwoord';

  @override
  String get exportUiAegisLockedSub =>
      'Het veiligst. Aegis vraagt om het wachtwoord als je importeert.';

  @override
  String get exportUiAegisPlain => 'Aegis, niet versleuteld';

  @override
  String get exportUiAegisPlainSub =>
      'Voor apps die Aegis-bestanden lezen maar geen vergrendelde kunnen openen.';

  @override
  String get exportUiTwoFasSub => 'Een .2fas-bestand zonder wachtwoord.';

  @override
  String get exportUiGoogleSub =>
      'QR-codes om te scannen met Google Authenticator.';

  @override
  String get exportUiLinks => 'Instellinks (gewone tekst)';

  @override
  String get exportUiLinksSub =>
      'Eén otpauth://-link per regel, voor elke andere app.';

  @override
  String get exportUiConfirmReason => 'Je accounts exporteren';

  @override
  String get exportUiEncryptingAegis => 'Versleutelen voor Aegis…';

  @override
  String get exportUiAegisPlainWhat =>
      'Dit bewaart elke instelsleutel in een onversleuteld Aegis-bestand.';

  @override
  String get exportUiTwoFasWhat =>
      'Dit bewaart elke instelsleutel in een 2FAS-bestand zonder wachtwoord.';

  @override
  String get exportUiGoogleTitle => 'QR-codes tonen voor Google Authenticator?';

  @override
  String get exportUiGoogleBody =>
      'Het volgende scherm toont QR-codes met elke instelsleutel erin. Iedereen die ze ziet of fotografeert, kan je inlogcodes maken. Doe dit op een plek waar niemand meekijkt.\n\nIn Google Authenticator: tik op + en dan op \"QR-code scannen\", en scan de codes een voor een.';

  @override
  String get exportUiShowCodes => 'Codes tonen';

  @override
  String exportUiExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count accounts geëxporteerd. Importeer het bestand in de andere app en verwijder het daarna.',
      one: '1 account geëxporteerd. Importeer het bestand in de andere app en verwijder het daarna.',
    );
    return '$_temp0';
  }

  @override
  String get exportUiNoneForGoogle =>
      'Geen van je accounts kan naar Google Authenticator.';

  @override
  String get exportUiScanThisCode => 'Scan deze code';

  @override
  String exportUiCodeOf(int n, int total) {
    return 'Code $n van $total';
  }

  @override
  String get exportUiNextCode => 'Volgende code';

  @override
  String exportUiLeftOut(int count) {
    return 'Weggelaten ($count). Google Authenticator kan deze codes niet maken, dus voeg ze toe aan een andere app:';
  }

  @override
  String get appIconClassic => 'Origineel blauw';

  @override
  String get appIconPink => 'Pastelroze';

  @override
  String get appIconBlue => 'Pastelblauw';

  @override
  String get appIconSpooky => 'Halloween';

  @override
  String get appIconCozy => 'Winter';

  @override
  String get appIconSpring => 'Pasen';

  @override
  String get serverBrowserExtension => 'Browserextensie';

  @override
  String get serverBadRequest => 'Tanooki Auth begreep dat verzoek niet.';

  @override
  String get serverLocked =>
      'Tanooki Auth is vergrendeld. Ontgrendel hem en probeer het opnieuw.';

  @override
  String get serverNotPaired => 'Deze app is niet gekoppeld aan Tanooki Auth.';

  @override
  String get serverNotFound => 'Dat account staat niet meer in Tanooki Auth.';

  @override
  String get serverRateLimited => 'Te veel verzoeken.';

  @override
  String get serverDenied =>
      'Niet toegestaan: dit account vraagt eerst, en Tanooki Auth is er niet voor ontgrendeld.';

  @override
  String get serverUnknownScreen => 'Onbekend scherm.';

  @override
  String get serverNoWebsite => 'Geen website opgegeven.';

  @override
  String serverUnknownRequest(String type) {
    return 'Onbekend verzoek \"$type\".';
  }

  @override
  String get serverPairingTimedOut =>
      'Koppelen is verlopen of gesloten. Begin opnieuw met koppelen.';

  @override
  String get serverThreeWrongCodes =>
      'Drie verkeerde codes. Begin opnieuw met koppelen.';

  @override
  String get serverWrongCode =>
      'Die code klopt niet. Controleer de code die Tanooki Auth toont.';

  @override
  String get serverNoLink => 'Er is geen otpauth://-link gestuurd.';

  @override
  String get serverAlreadyThere => 'Dat account staat al in Tanooki Auth.';

  @override
  String get serverAlreadyThereMany => 'Die accounts staan al in Tanooki Auth.';

  @override
  String get autoBackupNotSupported => 'niet ondersteund op dit apparaat';

  @override
  String homeProveCopy(String name) {
    return 'De code voor $name kopiëren';
  }

  @override
  String homeProveReadAloud(String name) {
    return 'De code voor $name voorlezen';
  }

  @override
  String homeProveEdit(String name) {
    return '$name bewerken';
  }

  @override
  String homeProveShare(String name) {
    return '$name delen';
  }

  @override
  String homeProveRecoveryCodes(String name) {
    return 'De herstelcodes voor $name bekijken';
  }

  @override
  String homeCopied(String name) {
    return 'Code van $name gekopieerd. Het klembord wordt over 30 seconden gewist.';
  }

  @override
  String get homeEditAccount => 'Account bewerken';

  @override
  String homeShowQrFor(String name) {
    return 'De QR-code voor $name tonen';
  }

  @override
  String homeMovedToTrash(String name) {
    return '$name is naar de prullenmand verplaatst. Je kunt het 30 dagen lang terugzetten via Instellingen.';
  }

  @override
  String get homeUndo => 'Ongedaan maken';

  @override
  String homeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts',
      one: '1 account',
    );
    return '$_temp0';
  }

  @override
  String homeAddTagTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tag toevoegen aan $count accounts',
      one: 'Tag toevoegen aan 1 account',
    );
    return '$_temp0';
  }

  @override
  String get homeTagHint => 'Tag (bijv. werk)';

  @override
  String get homeAddTag => 'Tag toevoegen';

  @override
  String homeTagged(int count, String tag) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts getagd met \"$tag\".',
      one: '1 account getagd met \"$tag\".',
    );
    return '$_temp0';
  }

  @override
  String homeMoveToFolderTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts naar een map verplaatsen',
      one: '1 account naar een map verplaatsen',
    );
    return '$_temp0';
  }

  @override
  String get homeNoFolder => 'Geen map';

  @override
  String get homeNewFolderHint => 'Of een nieuwe map (bijv. Werk)';

  @override
  String get homeMoveToNewFolder => 'Naar nieuwe map verplaatsen';

  @override
  String homeTookOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts uit hun mappen gehaald.',
      one: '1 account uit zijn map gehaald.',
    );
    return '$_temp0';
  }

  @override
  String homeMovedTo(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts verplaatst naar $folder.',
      one: '1 account verplaatst naar $folder.',
    );
    return '$_temp0';
  }

  @override
  String homeAddedToFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts toegevoegd aan favorieten.',
      one: '1 account toegevoegd aan favorieten.',
    );
    return '$_temp0';
  }

  @override
  String homeRemovedFromFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts verwijderd uit favorieten.',
      one: '1 account verwijderd uit favorieten.',
    );
    return '$_temp0';
  }

  @override
  String homeBulkTrashed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count accounts naar de prullenmand verplaatst. Je kunt ze 30 dagen lang terugzetten via Instellingen.',
      one: '1 account naar de prullenmand verplaatst. Je kunt het 30 dagen lang terugzetten via Instellingen.',
    );
    return '$_temp0';
  }

  @override
  String get homeDoneSelecting => 'Klaar met selecteren';

  @override
  String get homeTapToSelect => 'Tik op accounts om te selecteren';

  @override
  String homeSelectedCount(int count) {
    return '$count geselecteerd';
  }

  @override
  String get homeSelectNone => 'Niets selecteren';

  @override
  String get homeSelectAll => 'Alles selecteren';

  @override
  String get homeAddATag => 'Tag toevoegen';

  @override
  String get homeMoveToFolder => 'Naar map verplaatsen';

  @override
  String get homeRemoveFromFavorites => 'Uit favorieten verwijderen';

  @override
  String get homeAddToFavorites => 'Aan favorieten toevoegen';

  @override
  String get homeMoveToTrash => 'Naar prullenmand';

  @override
  String get homeSelectFirst =>
      'Selecteer eerst een paar accounts: tik erop in de lijst.';

  @override
  String homeSectionOpen(String name, String accounts) {
    return '$name, $accounts, tik om in te klappen';
  }

  @override
  String homeSectionClosed(String name, String accounts) {
    return '$name, $accounts, tik om te tonen';
  }

  @override
  String get homeSearchHint => 'Zoek accounts of websites…';

  @override
  String get homeAllTags => 'Alle';

  @override
  String get homeNoAccountsYet =>
      'Nog geen accounts.\nVoeg er een toe om een QR-code te scannen.';

  @override
  String get homeNoTagMatches => 'Geen accounts met deze tag.';

  @override
  String get homeNoSearchMatches =>
      'Geen accounts gevonden voor je zoekopdracht.';

  @override
  String get homeSelectAccounts => 'Accounts selecteren';

  @override
  String get homeSettings => 'Instellingen';

  @override
  String get homeAddAccount => 'Account toevoegen';

  @override
  String get homeAccounts => 'Accounts';

  @override
  String get homeYourAccounts => 'Je accounts';

  @override
  String get homeSelect => 'Selecteren';

  @override
  String get homeKeysTouch =>
      'Tikken (Kopiëren) · Enter (Kopiëren) · Pijltjes (Navigeren)';

  @override
  String get homeKeysClick =>
      'Klikken (Kopiëren) · Enter (Kopiëren) · Pijltjes (Navigeren)';

  @override
  String get homePickOnLeft => 'Kies links een account om het hier te zien.';

  @override
  String homeQrFor(String name) {
    return 'QR-code voor $name';
  }

  @override
  String get homeQrWarning =>
      'Scan dit met een andere authenticator-app om daar hetzelfde account toe te voegen. Iedereen die het ziet of fotografeert, kan je codes maken, dus houd het privé.';

  @override
  String homeVersionNote(Object version) {
    return 'v$version · blijft op dit apparaat';
  }

  @override
  String homeSelectName(String name) {
    return '$name selecteren';
  }

  @override
  String get homeMore => 'Meer';

  @override
  String get homeRecoveryCodes => 'Herstelcodes';

  @override
  String homeRecoveryCodesLeft(int count) {
    return 'Herstelcodes (nog $count)';
  }

  @override
  String get homeShareSecurely => 'Veilig delen';

  @override
  String get homeShowQr => 'QR-code tonen';

  @override
  String get homeMoveEarlier => 'Naar voren';

  @override
  String get homeMoveLater => 'Naar achteren';

  @override
  String homeNextCodeShort(String code) {
    return 'Volgende $code';
  }

  @override
  String get homeNextCode => 'Volgende code';

  @override
  String get homeFavorite => 'Favoriet';

  @override
  String get homeCodeHiddenAsk =>
      'Code verborgen tot je bevestigt dat jij het bent';

  @override
  String get homeCodeHidden => 'Code verborgen';

  @override
  String homeNextCodeSpoken(String code) {
    return 'Volgende code $code';
  }

  @override
  String homeKindTotp(int count, int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cijfers',
      one: '1 cijfer',
    );
    return 'TOTP · $_temp0 · ${seconds}s';
  }

  @override
  String homeKindSteam(int seconds) {
    return 'Steam · 5 tekens · ${seconds}s';
  }

  @override
  String homeKindHotp(int count, String counter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cijfers',
      one: '1 cijfer',
    );
    return 'HOTP · $_temp0 · #$counter';
  }

  @override
  String get homeAccountHeading => 'Account';

  @override
  String get homeHintUnselect => 'deselecteren';

  @override
  String get homeHintSelect => 'selecteren';

  @override
  String get homeHintCopy => 'de code kopiëren';

  @override
  String get homeReadCodeAloud => 'Code voorlezen';

  @override
  String get homeMoreOptions => 'Meer opties';

  @override
  String get mainPairRaycastTitle => 'Koppelen met Raycast';

  @override
  String get mainPairRaycastBody => 'Typ deze code in Raycast:';

  @override
  String get mainPairRaycastWarning =>
      'Doe dit alleen als je net zelf bent begonnen met koppelen in Raycast.';

  @override
  String get mainPairAlfredTitle => 'Koppelen met Alfred';

  @override
  String get mainPairAlfredBody => 'Typ 2fa-pair en deze code in Alfred:';

  @override
  String get mainPairAlfredWarning =>
      'Doe dit alleen als je net zelf 2fa-pair hebt getypt in Alfred.';

  @override
  String get mainPairPowerToysTitle => 'Koppelen met PowerToys';

  @override
  String get mainPairPowerToysBody =>
      'Typ deze code in PowerToys Command Palette:';

  @override
  String get mainPairPowerToysWarning =>
      'Doe dit alleen als je net zelf bent begonnen met koppelen in PowerToys.';

  @override
  String get mainPairBrowserTitle => 'Koppelen met je browser';

  @override
  String get mainPairBrowserBody =>
      'Typ deze code in de browserextensie van Tanooki Auth:';

  @override
  String get mainPairBrowserWarning =>
      'Doe dit alleen als je net zelf op \"Koppelen\" hebt geklikt in de extensie.';

  @override
  String mainSendCodeTo(String name, String client) {
    return 'De code voor $name naar $client sturen';
  }

  @override
  String mainWrongPasscodeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Verkeerde toegangscode. Nog $count verkeerde pogingen wissen alles.',
      one: 'Verkeerde toegangscode. Nog 1 verkeerde poging wist alles.',
    );
    return '$_temp0';
  }

  @override
  String get mainWrongPasscode => 'Verkeerde toegangscode.';

  @override
  String get mainBiometricWindows => 'Windows Hello';

  @override
  String get mainBiometricMac => 'Touch ID';

  @override
  String get mainBiometricOther => 'Face ID of vingerafdruk';

  @override
  String get mainLockTitle => 'Tanooki Auth vergrendelen?';

  @override
  String get mainLockBody =>
      'Vraag om je gezicht, vingerafdruk of toegangscode als de app opent, zodat iemand met je ontgrendelde telefoon je codes niet kan lezen. Je kunt dit later wijzigen in Instellingen.';

  @override
  String get mainTurnOnLock => 'Vergrendeling aanzetten';

  @override
  String get mainUnlockReason => 'Tanooki Auth ontgrendelen';

  @override
  String get mainStartOverTitle => 'Een nieuwe, lege kluis beginnen?';

  @override
  String get mainStartOverBody =>
      'Dit vervangt voorgoed wat er nog over is van je oude accounts. Doe dit alleen als je geen back-up hebt om terug te zetten, of als je tweestapsverificatie op die sites al hebt uitgezet.';

  @override
  String get mainEraseStartOver => 'Wissen en opnieuw beginnen';

  @override
  String get mainRestoreFromBackup => 'Terugzetten uit back-up';

  @override
  String get mainStartNewVault => 'Een nieuwe, lege kluis beginnen';

  @override
  String get mainLocked => 'Tanooki Auth is vergrendeld';

  @override
  String mainUseBiometric(String method) {
    return '$method gebruiken';
  }

  @override
  String get mainUseSecurityKey => 'Beveiligingssleutel gebruiken';

  @override
  String homeHidesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Verbergt over $count seconden',
      one: 'Verbergt over 1 seconde',
    );
    return '$_temp0';
  }

  @override
  String homeCardsMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      'm1': 'januari',
      'm2': 'februari',
      'm3': 'maart',
      'm4': 'april',
      'm5': 'mei',
      'm6': 'juni',
      'm7': 'juli',
      'm8': 'augustus',
      'm9': 'september',
      'm10': 'oktober',
      'm11': 'november',
      'm12': 'december',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String homeCardsDay(String month, String day) {
    return '$day $month';
  }

  @override
  String get homeCardsDenied =>
      'Geweigerd. Ze kunnen je accounts niet openen. Ze kunnen later opnieuw vragen, en dan krijg je weer de vraag.';

  @override
  String get homeCardsClockRight =>
      'Je klok loopt nu goed. Codes zouden moeten werken.';

  @override
  String get homeCardsCheckAgain => 'Opnieuw controleren';

  @override
  String get homeCardsYourContact => 'Je noodcontact';

  @override
  String homeCardsEmergencyWaiting(String who, String left, String day) {
    return '$who vroeg om noodtoegang tot je accounts. Tenzij je weigert, kan diegene over $left ($day) een kopie openen.';
  }

  @override
  String homeCardsEmergencyReleased(String who) {
    return '$who vroeg om noodtoegang en de wachttijd van 7 dagen is voorbij, dus diegene kan nu een kopie van je accounts openen. Weiger om dat te stoppen.';
  }

  @override
  String get homeCardsBackupNudge =>
      'Je accounts zijn gewijzigd sinds je laatste back-up. Met een back-upbestand krijg je ze terug als dit apparaat kwijtraakt.';

  @override
  String get homeCardsBackUpNow => 'Nu back-up maken';

  @override
  String homeCardsSummaryNew(int count, String month) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Je overzicht van $month: $count nieuwe accounts.',
      one: 'Je overzicht van $month: 1 nieuw account.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryNoBackup => 'Nog geen back-up.';

  @override
  String homeCardsSummaryLastBackup(String day) {
    return 'Laatste back-up $day.';
  }

  @override
  String get homeCardsSummaryAllCodes => 'Elk account heeft herstelcodes.';

  @override
  String homeCardsSummaryMissingCodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts zonder herstelcodes.',
      one: '1 account zonder herstelcodes.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryCheckupGood =>
      'Beveiligingscontrole: alles in orde.';

  @override
  String homeCardsSummaryCheckupFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Beveiligingscontrole: $count dingen om op te lossen.',
      one: 'Beveiligingscontrole: 1 ding om op te lossen.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsOpenCheckup => 'Controle openen';

  @override
  String get quickPickSelf =>
      'Tanooki Auth stond nog vooraan, dus er is niets getypt. Klik in het vak dat je wilt invullen en gebruik dan het menubalkicoon opnieuw.';

  @override
  String quickPickTypeFailed(String reason) {
    return 'Kon de code niet typen ($reason). Kopieer hem in plaats daarvan.';
  }

  @override
  String get quickPickTypeUnavailable =>
      'Codes typen is niet beschikbaar op deze computer. Kopieer hem in plaats daarvan.';

  @override
  String quickPickUseCodeFor(String name) {
    return 'De code voor $name gebruiken';
  }

  @override
  String get quickPickAllowTitle => 'Laat Tanooki Auth typen';

  @override
  String get quickPickAllowBody =>
      'Om een code in een andere app te typen, moet je Mac Tanooki Auth toestaan toetsen voor je in te drukken.\n\n1. Klik hieronder op \"Open Systeeminstellingen\".\n2. Je ziet een lijst met de naam Toegankelijkheid. Zoek Tanooki Auth en zet de schakelaar aan (blauw).\n3. Vraagt je Mac om je wachtwoord of Touch ID, geef dat dan.\n4. Kom hier terug en klik nog eens op Typ.\n\nTanooki Auth drukt alleen toetsen in als je op Typ klikt, en typt alleen de code.';

  @override
  String get quickPickOpenSystemSettings => 'Open Systeeminstellingen';

  @override
  String get quickPickTitle => 'Snelkeuze';

  @override
  String get quickPickSearch => 'Accounts zoeken';

  @override
  String get quickPickLinuxNote =>
      'Codes typen in andere apps is niet beschikbaar op Linux. Klik op een account om de code te kopiëren.';

  @override
  String get quickPickNoMatches => 'Geen passende accounts';

  @override
  String get quickPickAsksFirst => '••• •••  (vraagt eerst)';

  @override
  String get quickPickHiddenAsks => 'Code verborgen, vraagt eerst';

  @override
  String get quickPickType => 'Typ';

  @override
  String get codeViewRing => 'Ring';

  @override
  String get codeViewBar => 'Balk';

  @override
  String get codeViewNumber => 'Getal';

  @override
  String codeViewSpoken(String code) {
    return 'Code $code';
  }

  @override
  String codeViewSpokenLeft(int count, String code) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Code $code, nog $count seconden',
      one: 'Code $code, nog 1 seconde',
    );
    return '$_temp0';
  }

  @override
  String get codeViewReadAloud => 'Code voorlezen';

  @override
  String codeViewSecondsShort(int count) {
    return '${count}s';
  }

  @override
  String get codeViewColorBlue => 'Blauw';

  @override
  String get codeViewColorPurple => 'Paars';

  @override
  String get codeViewColorPink => 'Roze';

  @override
  String get codeViewColorRed => 'Rood';

  @override
  String get codeViewColorOrange => 'Oranje';

  @override
  String get codeViewColorGold => 'Goud';

  @override
  String get codeViewColorGreen => 'Groen';

  @override
  String get codeViewColorTeal => 'Blauwgroen';

  @override
  String get codeViewColorGray => 'Grijs';

  @override
  String trashRestored(String name) {
    return '$name staat weer in je lijst.';
  }

  @override
  String trashDeleteTitle(String name) {
    return '$name definitief verwijderen?';
  }

  @override
  String get trashDeleteBody =>
      'Dit kan niet ongedaan worden gemaakt. Zet voor het verwijderen tweestapsverificatie uit op die website, of zorg dat je de herstelcodes hebt, anders kun je buitengesloten raken.';

  @override
  String get trashDeleteForGood => 'Definitief verwijderen';

  @override
  String get trashTitle => 'Prullenmand';

  @override
  String get trashEmpty =>
      'De prullenmand is leeg.\nVerwijderde accounts blijven hier 30 dagen staan.';

  @override
  String get trashNote =>
      'Verwijderde accounts blijven hier 30 dagen staan en worden daarna definitief verwijderd.';

  @override
  String get trashRemovedNextOpen => 'Wordt verwijderd als de app weer opent';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nog $count dagen',
      one: 'Nog 1 dag',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => 'Terugzetten';

  @override
  String get recoveryAddTitle => 'Herstelcodes toevoegen';

  @override
  String get recoveryPasteHint =>
      'Plak de codes die je van de website kreeg, één per regel';

  @override
  String get recoveryNoneNew => 'Geen nieuwe codes gevonden in wat je plakte.';

  @override
  String recoveryAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count codes toegevoegd.',
      one: '1 code toegevoegd.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryCopiedUsed =>
      'Gekopieerd. Let op: je hebt deze code als gebruikt gemarkeerd, dus hij werkt waarschijnlijk niet meer.';

  @override
  String get recoveryCopied =>
      'Gekopieerd. Het klembord wordt over 30 seconden gewist. Markeer hem als gebruikt zodra je bent ingelogd.';

  @override
  String get recoveryRemoveTitle => 'Deze code verwijderen?';

  @override
  String recoveryRemoveBody(String code) {
    return '$code\n\nVerwijder hem alleen als de website hem niet meer accepteert.';
  }

  @override
  String recoveryTitle(String name) {
    return 'Herstelcodes voor $name';
  }

  @override
  String get recoveryAddCodes => 'Codes toevoegen';

  @override
  String get recoveryIntro =>
      'Als je tweestapsverificatie aanzet, geven de meeste websites je ook een lijst met back-upcodes. Met elke code kom je één keer binnen als je deze app ooit kwijtraakt. Plak ze hier, zodat ze veilig bij het account bewaard blijven.';

  @override
  String recoveryUnusedOf(String unused, int total) {
    return '$unused van $total ongebruikt. Tik op een code om hem te kopiëren, en vink hem aan zodra je hem hebt gebruikt.';
  }

  @override
  String get recoveryUsed => 'Gebruikt';

  @override
  String get detailsEditAccount => 'Account bewerken';

  @override
  String get detailsCopyCode => 'Code kopiëren';

  @override
  String get detailsReadAloud => 'Voorlezen';

  @override
  String get detailsFolderAndTags => 'Map en tags';

  @override
  String get detailsWebsites => 'Websites';

  @override
  String get detailsNotes => 'Notities';

  @override
  String get detailsNotesHidden =>
      'Verborgen tot je bevestigt dat jij het bent.';

  @override
  String get detailsNoNotes => 'Geen notities. Voeg ze toe via Bewerken.';

  @override
  String get accountSortCustom => 'Eigen volgorde (sleep om te ordenen)';

  @override
  String get accountSortRecent => 'Laatst gebruikt';

  @override
  String get accountSortName => 'A tot Z';

  @override
  String get activityCopied => 'Gekopieerd';

  @override
  String get activityFilled => 'Ingevuld';

  @override
  String get activityTyped => 'Getypt';

  @override
  String get activityShownQr => 'QR-code getoond';

  @override
  String get activityExported => 'Geëxporteerd';

  @override
  String get activityPlaceThisApp => 'Deze app';

  @override
  String get activityPlaceBackupFile => 'Back-upbestand';

  @override
  String get activityPlaceSetupLinks => 'Bestand met instellinks';

  @override
  String get activityPlacePaperBackup => 'Pdf van papieren back-up';

  @override
  String get activityPlaceGoogleQr => 'QR-codes voor Google Authenticator';

  @override
  String totpBadCharacter(String char) {
    return 'Geen geldige base32-sleutel (ongeldig teken \"$char\")';
  }

  @override
  String get totpEmpty => 'Geheime sleutel is leeg';

  @override
  String get vaultFileMissing =>
      'Je accountbestand ontbreekt. Heb je een back-up, zet die dan terug. Anders kun je een nieuwe, lege kluis beginnen.';

  @override
  String get vaultKeyMissing =>
      'De sleutel die je accounts ontgrendelt ontbreekt in de beveiligde opslag van dit apparaat. Zet een back-up terug om je accounts terug te krijgen.';

  @override
  String get vaultDecryptFailed =>
      'Je accountbestand kon niet worden ontgrendeld. Het is misschien beschadigd of buiten de app gewijzigd. Zet een back-up terug.';

  @override
  String get vaultBadJson =>
      'Je accountbestand is ontgrendeld, maar de inhoud is beschadigd. Zet een back-up terug.';

  @override
  String clockCheckBadAnswer(String status) {
    return 'De tijdserver stuurde een antwoord dat de app niet begrijpt (HTTP $status).';
  }

  @override
  String clockCheckOff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'De klok van je apparaat loopt ongeveer $count minuten verkeerd, dus codes werken niet. Zet automatische tijd aan in Instellingen.',
      one: 'De klok van je apparaat loopt ongeveer 1 minuut verkeerd, dus codes werken niet. Zet automatische tijd aan in Instellingen.',
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
  String get keysTitle => 'Sneltoetsen';

  @override
  String get keysWhere => 'In de accountlijst en in Snelkeuze.';

  @override
  String get keysMove => 'Omhoog en omlaag door de lijst';

  @override
  String get keysEnter => 'Enter';

  @override
  String get keysCopy => 'De gemarkeerde code kopiëren';

  @override
  String get keysAnyLetter => 'Een letter';

  @override
  String get keysSearch => 'Beginnen met zoeken';

  @override
  String get keysEsc => 'Esc';

  @override
  String get keysClear => 'De zoekopdracht wissen';

  @override
  String get keysShowList => 'Deze lijst tonen';

  @override
  String get settingsKeysShortcutMac => 'Druk overal op ⌘/ om ze te zien';

  @override
  String get settingsKeysShortcutOther => 'Druk overal op Ctrl+/ om ze te zien';

  @override
  String trayTooltip(String name, int seconds) {
    return 'Tanooki Auth: $name, nog $seconds s';
  }

  @override
  String get settingsTrayCountdownMac => 'Aftelling tonen in menubalk';

  @override
  String get settingsTrayCountdownMacHelp =>
      'De resterende seconden van je eerste favoriet, naast het menubalkicoon. Nooit de code zelf.';

  @override
  String get settingsTrayCountdownWindows =>
      'Aftelling tonen op systeemvakicoon';

  @override
  String get settingsTrayCountdownWindowsHelp =>
      'Wijs naar het Tanooki Auth-icoon bij de klok om te zien hoeveel seconden je eerste favoriet nog heeft. Nooit de code zelf.';

  @override
  String get unusedTitle => 'Accounts die je nooit gebruikt';

  @override
  String get settingsUnusedHelp =>
      'Al 6 maanden of langer geen code gekopieerd';

  @override
  String get unusedIntro =>
      'Van deze accounts is in deze app al 6 maanden of langer geen code gekopieerd. Gebruik je de website niet meer, zet daar dan eerst tweestapsverificatie uit en ruim ze daarna hier op. De prullenmand bewaart ze 30 dagen.';

  @override
  String get unusedNone =>
      'Elk account is de afgelopen 6 maanden gebruikt. Niets op te ruimen.';

  @override
  String unusedLastUsed(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Laatst gebruikt op $dateString';
  }

  @override
  String unusedNeverUsed(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Hier nooit gebruikt. Toegevoegd op $dateString';
  }

  @override
  String get unusedPickFirst => 'Vink eerst een of meer accounts aan.';

  @override
  String get unusedTagSuggestion => 'ongebruikt';

  @override
  String checkupUnusedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts die je nooit gebruikt',
      one: '1 account dat je nooit gebruikt',
    );
    return '$_temp0';
  }

  @override
  String get checkupUnusedBody =>
      'Al 6 maanden of langer geen code gekopieerd. Vergeten oude accounts vallen niet op als er een wordt gehackt.';

  @override
  String get checkupUnusedReview => 'Bekijk ze';

  @override
  String get halvesTitle => 'Papieren back-up in twee helften';

  @override
  String get settingsHalvesHelp =>
      'Twee sets pagina\'s. Elke helft afzonderlijk verraadt niets';

  @override
  String get halvesRestoreTitle => 'Terugzetten uit twee helften';

  @override
  String get settingsHalvesRestoreHelp =>
      'Scan de codes op beide helften van een papieren back-up';

  @override
  String get halvesExplain =>
      'Dit print je versleutelde back-up als twee aparte sets pagina\'s, Helft A en Helft B.\n\nElke helft afzonderlijk is alleen willekeurige ruis: niemand kan er iets uit halen, zelfs niet met je wachtwoordzin. Om terug te zetten heb je beide helften en de wachtwoordzin nodig.\n\nBewaar de helften op twee verschillende plekken, bijvoorbeeld één thuis en één bij iemand die je vertrouwt.';

  @override
  String get halvesHalfA => 'Helft A van 2';

  @override
  String get halvesHalfB => 'Helft B van 2';

  @override
  String halvesPart(String which, int part, int parts) {
    return 'Helft $which · deel $part van $parts';
  }

  @override
  String halvesPdfHeader(String date) {
    return 'Papieren back-up van Tanooki Auth, gemaakt op $date';
  }

  @override
  String get halvesPdfExplain =>
      'Deze helft alleen is nutteloos. Terugzetten: open in Tanooki Auth Instellingen > Terugzetten uit twee helften, scan elke code op beide helften en typ dan de back-upwachtwoordzin. Bewaar de twee helften op verschillende plekken.';

  @override
  String halvesPdfPage(String half, int page, int pages) {
    return '$half, pagina $page van $pages';
  }

  @override
  String get halvesNowB => 'Bewaar nu Helft B';

  @override
  String get halvesNowBBody =>
      'Helft A is bewaard. Helft B is de andere helft: print die ook en bewaar hem ergens anders.';

  @override
  String get halvesSaveB => 'Helft B bewaren';

  @override
  String get halvesOnlyA =>
      'Alleen Helft A is bewaard. Met Helft A alleen kun je niets terugzetten, dus maak beide helften opnieuw als je er klaar voor bent.';

  @override
  String get halvesReady =>
      'Beide helften zijn klaar. Print ze en bewaar ze op verschillende plekken.';

  @override
  String get halvesRestoreIntro =>
      'Scan elke code op beide helften, in willekeurige volgorde. Zijn beide compleet, typ dan de wachtwoordzin die je koos toen je de back-up maakte.';

  @override
  String halvesNotStarted(String half) {
    return '$half: nog geen codes gescand';
  }

  @override
  String halvesProgress(String half, int have, int total) {
    return '$half: $have van $total codes';
  }

  @override
  String get halvesScan => 'Codes scannen';

  @override
  String get halvesScanTitle => 'Scan beide helften';

  @override
  String get halvesPictures => 'Afbeeldingen van de codes openen';

  @override
  String halvesSomeUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Op $count afbeeldingen stond geen code die deze app kon lezen. Probeer een scherpere afbeelding van één code.',
      one: 'Op 1 afbeelding stond geen code die deze app kon lezen. Probeer een scherpere afbeelding van één code.',
    );
    return '$_temp0';
  }

  @override
  String get halvesNotAHalf =>
      'Dat is geen code van een papieren back-up in twee helften.';

  @override
  String get halvesOtherSet =>
      'Die code hoort bij een andere papieren back-up. Gebruik beide helften van dezelfde print.';

  @override
  String get halvesAlreadyHave =>
      'Die is al gescand. Door naar de volgende code.';

  @override
  String get halvesDontFit =>
      'Deze helften passen niet bij elkaar. Misschien is een code verkeerd gelezen, of komen de helften van verschillende back-ups. Begin opnieuw met scannen.';

  @override
  String get halvesRestoreNow => 'Beide helften gescand: terugzetten';

  @override
  String get healthTitle => 'Gezondheidscheck';

  @override
  String get settingsHealthHelp =>
      'Sync, back-up, klok, vergrendeling en herstelcodes op één scherm';

  @override
  String get healthIntro =>
      'Groen betekent prima. Geel is het bekijken waard, en de knop ernaast lost het op.';

  @override
  String get healthGood => 'Prima';

  @override
  String get healthLook => 'Even bekijken';

  @override
  String get healthSync => 'Sync';

  @override
  String get healthSyncOff =>
      'Niet ingesteld. Sync houdt je accounts gelijk op al je apparaten.';

  @override
  String healthSyncOk(String when) {
    return 'Laatst gesynchroniseerd: $when';
  }

  @override
  String healthSyncStale(String when) {
    return 'Laatst gesynchroniseerd: $when. Dat is al een tijdje geleden: open Synchronisatie om te zien wat er mis is.';
  }

  @override
  String get healthOpenSync => 'Synchronisatie openen';

  @override
  String get healthSetUp => 'Instellen';

  @override
  String get healthOpen => 'Openen';

  @override
  String get healthBackup => 'Back-up';

  @override
  String get healthBackupNever =>
      'Nog geen back-up. Raakt dit apparaat kwijt, dan zijn je accounts ook weg.';

  @override
  String healthBackupOk(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Laatste back-up $dateString';
  }

  @override
  String healthBackupOld(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Laatste back-up $dateString. Dat is meer dan 30 dagen geleden: maak een nieuwe.';
  }

  @override
  String get healthClock => 'Klok';

  @override
  String get healthClockNotChecked =>
      'Nog niet gecontroleerd. Codes werken alleen als de klok van dit apparaat goed loopt.';

  @override
  String healthClockOk(String when) {
    return 'Je klok loopt goed (gecontroleerd $when).';
  }

  @override
  String get healthCheckNow => 'Nu controleren';

  @override
  String get healthPhoneLink => 'Telefoonkoppeling';

  @override
  String healthPhoneLinkOk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Gekoppeld aan $count browsers',
      one: 'Gekoppeld aan 1 browser',
    );
    return '$_temp0';
  }

  @override
  String get healthPhoneLinkOff =>
      'Niet gekoppeld. Koppel de browser van je computer om inlogcodes goed te keuren vanaf deze telefoon.';

  @override
  String get healthLock => 'Vergrendeling';

  @override
  String get healthLockOn =>
      'Aan. De app vraagt wie je bent voordat hij codes toont.';

  @override
  String get healthLockOff =>
      'Uit. Iedereen die dit apparaat oppakt, kan je codes zien.';

  @override
  String get healthGoToSettings => 'Naar de vergrendelingsschakelaar';

  @override
  String get healthRecovery => 'Herstelcodes';

  @override
  String healthRecoveryCount(int count, int total) {
    return '$count van $total accounts hebben herstelcodes bewaard.';
  }

  @override
  String get healthRecoveryNoAccounts => 'Nog geen accounts.';

  @override
  String get healthAddCodes => 'Codes toevoegen';

  @override
  String get syncErrorWiped =>
      'Een ander apparaat heeft Tanooki Auth op dit apparaat gewist. Alles erop is verwijderd en het is uit sync gegaan.';

  @override
  String get syncUiEraseDevice => 'Dit apparaat wissen';

  @override
  String get syncUiEraseTitle => 'Dit apparaat wissen?';

  @override
  String get syncUiEraseBody =>
      'De volgende keer dat dat apparaat online gaat, verwijdert Tanooki Auth erop alles: de accounts, instellingen, widgets en zoekgegevens. Het verlaat ook definitief sync. Dit kan niet ongedaan worden gemaakt. Er verandert niets op dit apparaat of op je andere apparaten.';

  @override
  String get syncUiEraseButton => 'Wissen';

  @override
  String get syncUiErased =>
      'Klaar. Dat apparaat wist zichzelf de volgende keer dat het online gaat.';

  @override
  String syncUiClashes(int count) {
    return 'Syncconflicten ($count)';
  }

  @override
  String get syncUiClashesHelp =>
      'Een account is op twee apparaten gewijzigd voordat ze synchroniseerden. Kies welke versie je wilt houden.';

  @override
  String get syncUiClashTitle => 'Syncconflicten';

  @override
  String get syncUiClashIntro =>
      'Elk account hieronder is op twee apparaten gewijzigd voordat ze synchroniseerden. Sync gebruikte de laatste wijziging. Wil je liever de andere versie, tik dan op Deze houden eronder.';

  @override
  String get syncUiClashNone => 'Geen conflicten. Niets te kiezen.';

  @override
  String get syncUiClashInUse => 'Nu in gebruik';

  @override
  String get syncUiClashOther => 'Andere versie';

  @override
  String get syncUiClashKeep => 'Deze houden';

  @override
  String get syncUiClashKept =>
      'Klaar. Je andere apparaten krijgen deze versie bij hun volgende sync.';

  @override
  String syncUiClashEdited(String when) {
    return 'Gewijzigd $when';
  }

  @override
  String get syncUiClashName => 'Naam';

  @override
  String get syncUiClashAccount => 'Account';

  @override
  String get syncUiClashFolder => 'Map';

  @override
  String get syncUiClashNotes => 'Notities';

  @override
  String get syncUiClashInTrash => 'In prullenmand';

  @override
  String get syncUiClashSecret => 'Instelsleutel';

  @override
  String get syncUiClashSecretDifferent => 'anders';

  @override
  String get syncUiClashYes => 'Ja';

  @override
  String get syncUiClashNo => 'Nee';

  @override
  String get syncUiClashOtherDiffers =>
      'Andere instellingen verschillen ook, zoals het uiterlijk, de website of herstelcodes.';

  @override
  String get teamRoleAdmin => 'Beheerder';

  @override
  String get teamRoleMember => 'Lid';

  @override
  String get teamRoleViewer => 'Alleen bekijken';

  @override
  String get teamRoleOwner => 'Eigenaar';

  @override
  String get teamUiMakeAdmin => 'Beheerder maken';

  @override
  String get teamUiMakeMember => 'Lid maken';

  @override
  String get teamUiMakeViewer => 'Alleen bekijken maken';

  @override
  String get teamUiRoleChanged => 'Rol gewijzigd.';

  @override
  String get teamUiInviteRole => 'Ze worden lid als';

  @override
  String get teamUiRoleHelp =>
      'Beheerders nodigen mensen uit, verwijderen ze en zien het activiteitenlogboek. Leden gebruiken en wijzigen teamaccounts. Mensen met Alleen bekijken kunnen de accounts gebruiken maar niet wijzigen.';

  @override
  String get teamUiInviteEmailLabel => 'Hun e-mailadres (optioneel)';

  @override
  String get teamUiInviteEmailHint => 'naam@voorbeeld.nl';

  @override
  String get teamUiInviteMake => 'Uitnodiging maken';

  @override
  String teamUiInviteEmailed(String email) {
    return 'Uitnodiging gestuurd naar $email.';
  }

  @override
  String get teamUiEmailNotSetUp =>
      'E-mails versturen is nog niet ingesteld. Kopieer de link hieronder en stuur hem zelf.';

  @override
  String teamUiEmailFailed(String reason) {
    return 'De e-mail is niet verstuurd ($reason). Kopieer de link hieronder en stuur hem zelf.';
  }

  @override
  String get teamUiYoureAdmin => 'Je bent beheerder van dit team';

  @override
  String get teamUiYoureViewer => 'Je zit in een team (alleen bekijken)';

  @override
  String get teamUiViewOnly =>
      'Je kunt deze accounts gebruiken, maar alleen beheerders en leden kunnen ze wijzigen.';

  @override
  String get teamUiActivity => 'Activiteit';

  @override
  String get teamUiActivityTitle => 'Teamactiviteit';

  @override
  String get teamUiActivityHelp =>
      'Wie teamaccounts heeft gekopieerd of gewijzigd, en wanneer. Alleen beheerders zien dit. Wordt 90 dagen bewaard, tot de laatste 2.000 regels.';

  @override
  String get teamUiActivityEmpty =>
      'Nog niets. Kopieën en wijzigingen van teamaccounts verschijnen hier.';

  @override
  String teamActCopy(String name) {
    return 'Code gekopieerd voor $name';
  }

  @override
  String teamActFill(String name) {
    return 'Code ingevuld voor $name';
  }

  @override
  String teamActAdd(String name) {
    return '$name toegevoegd';
  }

  @override
  String teamActEdit(String name) {
    return '$name gewijzigd';
  }

  @override
  String teamActDelete(String name) {
    return '$name verwijderd';
  }

  @override
  String get teamUiBuyBusiness =>
      'Zakelijk abonnement: \$3 per persoon per jaar';

  @override
  String get teamUiBusinessSoon =>
      'Zakelijk abonnement voor teams van meer dan 10 mensen (\$3 per persoon per jaar): komt binnenkort.';

  @override
  String themeCustom(int n) {
    return 'Mijn thema $n';
  }

  @override
  String get themeMakeOwn => 'Maak je eigen';

  @override
  String get themeMakeOwnPremium => 'Maak je eigen thema, Premium';

  @override
  String get themeEditOwn => 'Dit thema bewerken';

  @override
  String get themeEditorTitle => 'Je thema';

  @override
  String get themeEditorAccent => 'Accent';

  @override
  String get themeEditorBackground => 'Achtergrond';

  @override
  String get themeEditorCard => 'Kaarten';

  @override
  String get themeEditorText => 'Tekst';

  @override
  String get themeEditorHue => 'Tint';

  @override
  String themeEditorSwatch(String hex) {
    return 'Kleur $hex';
  }

  @override
  String get themeEditorPreview => 'Voorbeeld';

  @override
  String get themeEditorSample => 'Voorbeeldaccount';

  @override
  String get themeEditorSampleHint => 'Tik om te kopiëren';

  @override
  String get themeEditorSave => 'Thema bewaren';

  @override
  String get themeEditorDelete => 'Thema verwijderen';

  @override
  String get themeEditorAdjusted =>
      'Sommige kleuren zijn aangepast zodat tekst en knoppen goed leesbaar blijven.';

  @override
  String get themeEditorUnreadable =>
      'Met deze kleuren wordt het niet goed leesbaar. Probeer een kaartkleur die dichter bij de achtergrond ligt.';

  @override
  String get themeEditorFull =>
      'Je hebt al 3 thema\'s. Verwijder er een om een nieuw te maken.';

  @override
  String get settingsSeasonal => 'Wisselen met de seizoenen';

  @override
  String get settingsSeasonalPremium => 'Wisselen met de seizoenen (Premium)';

  @override
  String get settingsSeasonalHelp =>
      'Spookachtig in de herfst, Knus in de winter en Lente in de lente; je eigen keuze in de zomer. Een seizoensgebonden app-icoon wisselt mee.';

  @override
  String get helpNew040a =>
      'Vul codes in met Automatisch invullen op iPhone en Android.';

  @override
  String get helpNew040b =>
      'Deel een QR-afbeelding met de app om een account toe te voegen. Op een Mac sleep je hem naar het venster.';

  @override
  String get helpNew040c =>
      'Pijltjestoetsen, Enter en een lijst met sneltoetsen (⌘/ of Ctrl+/) op computers, plus een aftelling in de menubalk.';

  @override
  String get helpNew040d =>
      'Vind accounts die je nooit gebruikt en print een papieren back-up in twee helften.';

  @override
  String get helpNew040e => 'Een nieuw scherm Gezondheidscheck.';

  @override
  String get helpNew040f =>
      'Wis een kwijtgeraakt apparaat vanaf een ander en los synchronisatieconflicten op.';

  @override
  String get helpNew040g =>
      'Teamrollen, een activiteitenlog voor teams, uitnodigingen per e-mail en een Business-abonnement (binnenkort).';

  @override
  String get helpNew040h =>
      'Maak je eigen thema, seizoensthema\'s en een Smart Stack-widget voor Apple Watch.';

  @override
  String get helpNew040i =>
      'Vijf extra talen: Portugees, Italiaans, Koreaans, Chinees en Nederlands.';

  @override
  String get appIconGroupColors => 'Kleuren';

  @override
  String get appIconGroupHolidays => 'Feestdagen';

  @override
  String get appIconGroupPride => 'Pride';

  @override
  String get appIconHotpink => 'Roze';

  @override
  String get appIconRed => 'Rood';

  @override
  String get appIconOrange => 'Oranje';

  @override
  String get appIconGold => 'Goud';

  @override
  String get appIconGreen => 'Groen';

  @override
  String get appIconCyan => 'Cyaan';

  @override
  String get appIconPurple => 'Paars';

  @override
  String get appIconMonochrome => 'Monochroom';

  @override
  String get appIconBlackgold => 'Zwart en goud';

  @override
  String get appIconSummer => 'Zomer';

  @override
  String get appIconThanksgiving => 'Thanksgiving';

  @override
  String get appIconChristmas => 'Kerst';

  @override
  String get appIconValentines => 'Valentijnsdag';

  @override
  String get appIconStpatricks => 'St. Patrick\'s Day';

  @override
  String get appIconIndependence => 'Onafhankelijkheidsdag';

  @override
  String get appIconRainbow => 'Regenboog';

  @override
  String get appIconProgress => 'Progress';

  @override
  String get appIconTransgender => 'Transgender';

  @override
  String get appIconLesbian => 'Lesbisch';

  @override
  String get appIconBisexual => 'Biseksueel';

  @override
  String get appIconPansexual => 'Panseksueel';

  @override
  String get appIconNonbinary => 'Non-binair';

  @override
  String get appIconAsexual => 'Aseksueel';

  @override
  String get appIconGenderfluid => 'Genderfluïde';

  @override
  String get homeCardsIphoneOnMac =>
      'Dit is de iPhone-versie van Tanooki Auth op je Mac, dus browserextensies kunnen hem niet bereiken. Installeer de Mac-versie: open TestFlight op deze Mac, kies Tanooki Auth en kies macOS.';
}
