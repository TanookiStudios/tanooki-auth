// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRemove => 'Retirer';

  @override
  String get commonUnlock => 'Déverrouiller';

  @override
  String get commonTurnOff => 'Désactiver';

  @override
  String get commonNotNow => 'Pas maintenant';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonDone => 'Terminé';

  @override
  String get commonDeny => 'Refuser';

  @override
  String get commonAllow => 'Autoriser';

  @override
  String get commonTryAgain => 'Réessayer';

  @override
  String get commonStop => 'Arrêter';

  @override
  String get commonShare => 'Partager';

  @override
  String get commonOpen => 'Ouvrir';

  @override
  String get commonCopy => 'Copier';

  @override
  String get commonContinueLabel => 'Continuer';

  @override
  String get commonClear => 'Effacer';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonAdd => 'Ajouter';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonYes => 'Oui';

  @override
  String get commonNo => 'Non';

  @override
  String get commonSeePremium => 'Voir Premium';

  @override
  String get commonPremiumBadge => 'Premium';

  @override
  String get commonAppName => 'Tanooki Auth';

  @override
  String get googleMigrationUnreadable =>
      'Impossible de lire ce code Google Authenticator.';

  @override
  String get googleMigrationDamaged =>
      'Ce code Google Authenticator est abîmé.';

  @override
  String get googleMigrationEmpty =>
      'Ce code Google Authenticator ne contient aucun compte.';

  @override
  String get googleMigrationNoSecret =>
      'Un compte de ce code n\'a pas de clé secrète.';

  @override
  String get googleMigrationMd5 =>
      'Un compte de ce code utilise MD5, que Tanooki Auth ne prend pas en charge.';

  @override
  String get googleCantTakeSteam => 'codes Steam';

  @override
  String googleCantTakeDigits(int digits) {
    return 'codes à $digits chiffres';
  }

  @override
  String googleCantTakePeriod(int seconds) {
    return 'codes qui changent toutes les $seconds secondes';
  }

  @override
  String get otpauthNotALink => 'Ce n\'est pas un lien otpauth://.';

  @override
  String get otpauthNoSecret => 'Le lien ne contient pas de clé secrète.';

  @override
  String otpauthUnsupportedType(String type) {
    return 'Type de code non pris en charge : « $type ».';
  }

  @override
  String otpauthUnsupportedAlgorithm(String algorithm) {
    return 'Algorithme non pris en charge : « $algorithm ».';
  }

  @override
  String get otpauthBadDigits => 'Le nombre de chiffres doit être 6, 7 ou 8.';

  @override
  String get otpauthBadPeriod => 'La période doit être un nombre positif.';

  @override
  String get otpauthBadCounter =>
      'Le compteur doit être égal ou supérieur à zéro.';

  @override
  String get phoneLinkNotAPairingCode =>
      'Ce n\'est pas un code d\'association de navigateur Tanooki Auth.';

  @override
  String phoneLinkNotSavedFor(String host) {
    return 'Ce compte n\'est pas enregistré pour $host.';
  }

  @override
  String get phoneLinkPushNotSetUp =>
      'Les notifications ne sont pas encore configurées sur le serveur Tanooki Auth : les demandes n\'apparaissent que lorsque l\'app est ouverte.';

  @override
  String phoneLinkPushFailed(int status) {
    return 'Impossible d\'activer les notifications (HTTP $status).';
  }

  @override
  String get qrImageNotAPicture =>
      'Ce fichier n\'est pas une image que l\'app sait lire.';

  @override
  String get qrImageNoQr => 'Aucun code QR trouvé dans cette image.';

  @override
  String relayBadAnswer(int status) {
    return 'Le serveur de synchronisation a envoyé une réponse que l\'app ne comprend pas (HTTP $status).';
  }

  @override
  String get relayUnreachable =>
      'Impossible de joindre le serveur de synchronisation. Vérifiez votre connexion internet.';

  @override
  String get relayTimeout =>
      'Le serveur de synchronisation n\'a pas répondu à temps. Vérifiez votre connexion internet.';

  @override
  String get relayInsecure =>
      'Impossible d\'établir une connexion sécurisée avec le serveur de synchronisation.';

  @override
  String relaySaidNo(int status) {
    return 'Le serveur de synchronisation a refusé (HTTP $status).';
  }

  @override
  String get shareNotAShare =>
      'Ce n\'est pas un compte partagé par Tanooki Auth.';

  @override
  String get shareExpired =>
      'Ce partage a expiré (il ne dure que 24 heures). Demandez-en un nouveau.';

  @override
  String get shareWrongCode =>
      'Code incorrect, ou le partage est abîmé. Vérifiez les 6 chiffres et réessayez.';

  @override
  String get storeServerUnreachable =>
      'Impossible de joindre le serveur Tanooki Auth. Vérifiez votre connexion internet et réessayez.';

  @override
  String get storeBadKey =>
      'Le serveur a envoyé une clé de licence que cette app n\'accepte pas.';

  @override
  String storeReportedProblem(String problem) {
    return 'La boutique a signalé un problème : $problem';
  }

  @override
  String get storeGooglePlayUnavailable =>
      'Google Play n\'est pas disponible sur cet appareil, donc Premium ne peut pas être acheté ici. Si vous avez acheté Premium ailleurs, saisissez votre clé de licence ci-dessous.';

  @override
  String get storeAppStoreUnavailable =>
      'L\'App Store n\'est pas disponible pour le moment. Vérifiez votre connexion internet et réessayez.';

  @override
  String storeNotListed(String store) {
    return 'Le $store n\'a pas affiché Premium pour l\'instant. Réessayez dans un moment.';
  }

  @override
  String storeNotListedWithError(String store, String problem) {
    return 'Le $store n\'a pas affiché Premium pour l\'instant ($problem). Réessayez dans un moment.';
  }

  @override
  String storePricesFailed(String problem) {
    return 'Impossible de charger les prix de la boutique : $problem';
  }

  @override
  String storePurchaseCouldNotStart(String problem) {
    return 'L\'achat n\'a pas pu démarrer : $problem';
  }

  @override
  String storeNothingToRestore(String store) {
    return 'Aucun achat Premium trouvé pour ce compte $store.';
  }

  @override
  String storeRestoreFailed(String problem) {
    return 'Impossible de restaurer les achats : $problem';
  }

  @override
  String get storePending =>
      'En attente de la validation du paiement. Premium se débloque dès qu\'il est validé.';

  @override
  String get storeCanceled => 'Achat annulé. Vous n\'avez pas été débité.';

  @override
  String storeFailed(String problem) {
    return 'L\'achat n\'a pas abouti : $problem. Vous n\'avez pas été débité.';
  }

  @override
  String get storeFailedNoReason =>
      'L\'achat n\'a pas abouti : la boutique n\'a donné aucune raison. Vous n\'avez pas été débité.';

  @override
  String get storeUnlocked => 'Premium débloqué. Merci beaucoup !';

  @override
  String get storeUnlockedWithKey =>
      'Premium débloqué. Votre clé de licence pour vos ordinateurs se trouve ci-dessous.';

  @override
  String storeUnlockedKeyFailed(String problem) {
    return 'Premium est débloqué sur cet appareil. La clé pour vos ordinateurs n\'a pas encore pu être créée : $problem Touchez Restaurer les achats plus tard pour réessayer.';
  }

  @override
  String storeServerSaidNo(int status) {
    return 'Le serveur a refusé (HTTP $status).';
  }

  @override
  String get syncGroupExists =>
      'Un groupe de synchronisation avec cette phrase secrète existe déjà. Sur un appareil déjà synchronisé, touchez « Ajouter un appareil » et scannez son code.';

  @override
  String get syncNotASyncCode =>
      'Ce n\'est pas un code de synchronisation Tanooki Auth. Sur un appareil déjà synchronisé, ouvrez Réglages, Synchronisation, Ajouter un appareil.';

  @override
  String get syncWrongPassphrase =>
      'Cette phrase secrète ne correspond pas à celle de vos autres appareils. Vérifiez-la et réessayez.';

  @override
  String get syncICloudOtherPassphrase =>
      'Vos autres appareils Apple se synchronisent avec une autre phrase secrète. Saisissez-la, ou repartez de zéro avec celle-ci.';

  @override
  String get syncErrorRemoved =>
      'Cet appareil a été retiré de la synchronisation depuis un autre appareil. Désactivez puis réactivez la synchronisation pour le rejoindre.';

  @override
  String get syncErrorTurnedOff =>
      'La synchronisation a été désactivée depuis un autre appareil. Désactivez-la ici aussi, puis réactivez-la pour recommencer.';

  @override
  String get syncErrorTooOften =>
      'Synchronisations trop fréquentes. Nouvel essai dans quelques minutes.';

  @override
  String get syncErrorLimit =>
      'Vous avez atteint la limite de synchronisation (2 000 comptes, supprimés compris).';

  @override
  String syncErrorICloud(String problem) {
    return 'iCloud Drive a rencontré un problème : $problem.';
  }

  @override
  String syncErrorUnexpected(String problem) {
    return 'La synchronisation s\'est arrêtée à cause d\'un problème inattendu : $problem';
  }

  @override
  String get syncICloudAppleOnly =>
      'iCloud ne fonctionne que sur iPhone, iPad et Mac.';

  @override
  String get syncICloudSignedOut =>
      'iCloud Drive est désactivé sur cet appareil. Connectez-vous à iCloud et activez iCloud Drive dans les Réglages pour l\'utiliser.';

  @override
  String get syncICloudNotInBuild =>
      'La synchronisation iCloud n\'est pas encore activée dans cette version de Tanooki Auth. Utilisez le relais Tanooki pour l\'instant ; il marche sur tous les appareils.';

  @override
  String get teamKeyUnopenable =>
      'La clé d\'équipe envoyée à cet appareil n\'a pas pu être ouverte. Demandez à l\'admin de l\'équipe de retirer cet appareil puis de l\'inviter à nouveau.';

  @override
  String get teamNotAnInvite =>
      'Ce n\'est pas une invitation d\'équipe Tanooki Auth. Demandez à l\'admin de l\'équipe un nouveau lien ou code QR d\'invitation.';

  @override
  String get teamNotInTeam => 'Cet appareil ne fait partie d\'aucune équipe.';

  @override
  String get teamDeletedByAdmin =>
      'Cette équipe a été supprimée par son admin.';

  @override
  String get teamDeviceRemoved => 'Cet appareil a été retiré de l\'équipe.';

  @override
  String get teamAlreadyInTeam =>
      'Cet appareil fait déjà partie d\'une équipe.';

  @override
  String get teamNotALicense =>
      'Ce n\'est pas une licence d\'équipe. Elle commence par TT1. et figure sur la page que Stripe affiche après l\'abonnement.';

  @override
  String get teamAlreadyInTeamLeaveFirst =>
      'Cet appareil fait déjà partie d\'une équipe. Quittez-la d\'abord.';

  @override
  String get teamGone =>
      'Cette équipe n\'existe plus. Demandez une nouvelle invitation à l\'admin de l\'équipe.';

  @override
  String get teamInviteUsed =>
      'Cette invitation a déjà servi ou a expiré (elle dure 7 jours et ne sert qu\'une fois). Demandez-en une nouvelle à l\'admin de l\'équipe.';

  @override
  String get teamFull =>
      'Cette équipe est complète (10 personnes). L\'admin doit d\'abord retirer quelqu\'un.';

  @override
  String get aboutTitle => 'À propos de Maddie';

  @override
  String get aboutP1 =>
      'Je suis Maddie, une développeuse autiste qui tient, peut-être un peu trop, à soigner les petits détails.';

  @override
  String get aboutP2 =>
      'Je crois beaucoup à la vie privée. Les clés qui protègent vos comptes sont parmi les données les plus personnelles qui soient, alors Tanooki Auth les garde chiffrées sur votre propre appareil. Pas de compte, pas de pub, pas de pistage, et rien ne m\'est jamais envoyé.';

  @override
  String get aboutP3 =>
      'Tanooki Auth est gratuite, et je veux qu\'elle le reste. Votre soutien me permet de continuer à créer des apps gratuites et respectueuses de la vie privée comme celle-ci. Si Tanooki Auth vous plaît, les autres aussi peut-être : elles sont sur madilynthomas.com.';

  @override
  String get aboutP4 =>
      'Alors, de moi à vous : merci. Vous n\'utilisez pas simplement une app — vous rendez possible toute cette façon de vivre.';

  @override
  String get aboutSupportAddress =>
      'Soutenir mon travail : tanookistudios.com/support';

  @override
  String get aboutSupport => 'Soutenir mon travail';

  @override
  String get aboutCredits => 'Crédits';

  @override
  String get aboutCreditsBody =>
      'Les codes QR sont lus avec jsQR (Apache 2.0) dans l\'extension du navigateur et ZXing dans l\'app. Sans lien avec Google, Twilio ou Authy ; Google Authenticator est une marque de Google LLC.';

  @override
  String get addFromBrowserOne => 'Ajouter depuis votre navigateur ?';

  @override
  String addFromBrowserMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter $count comptes depuis votre navigateur ?',
      one: 'Ajouter 1 compte depuis votre navigateur ?',
    );
    return '$_temp0';
  }

  @override
  String get addFromGoogleTransfer =>
      'Depuis un code de transfert Google Authenticator :';

  @override
  String addCount(int count) {
    return 'Ajouter $count';
  }

  @override
  String get addNoColor => 'Aucune couleur';

  @override
  String addColorName(String name) {
    return 'Couleur $name';
  }

  @override
  String get addServiceLabel => 'Service (ex. : GitHub)';

  @override
  String get addAccountLabel => 'Compte (ex. : votre e-mail)';

  @override
  String get addWebsiteLabel => 'Site web (facultatif)';

  @override
  String get addWebsiteHelp =>
      'ex. : github.com. L\'extension du navigateur ne remplit les codes que sur ce site.';

  @override
  String get addTagsLabel => 'Étiquettes (facultatif)';

  @override
  String get addTagsHelp =>
      'ex. : travail, jeux. Séparez-les par des virgules.';

  @override
  String get addFolderLabel => 'Dossier (facultatif)';

  @override
  String get addFolderHelp => 'ex. : Travail. Laissez vide pour aucun dossier.';

  @override
  String get addPickFolder => 'Choisir un dossier';

  @override
  String get addNoFolder => 'Aucun dossier';

  @override
  String get addNotesLabel => 'Notes (facultatif)';

  @override
  String get addColorLabel => 'Couleur (facultatif)';

  @override
  String get addEmojiLabel => 'Emoji (facultatif)';

  @override
  String get addEmojiHelp =>
      'Affiché à la place du logo, ici, sur les widgets et sur la montre.';

  @override
  String addUseEmoji(String emoji) {
    return 'Utiliser $emoji';
  }

  @override
  String addRequireAuth(String proof) {
    return 'Demander $proof avant d\'afficher ce code';
  }

  @override
  String get addRequireAuthHelp =>
      'Le code reste masqué dans la liste, et les widgets, la montre et Choix rapide ne l\'affichent jamais.';

  @override
  String get addTravelHide => 'Masquer en mode voyage';

  @override
  String get addTravelHidePremium => 'Masquer en mode voyage (Premium)';

  @override
  String get addTravelHideHelp =>
      'Quand le mode voyage est activé (Réglages), ce compte disparaît de l\'app jusqu\'à ce que vous le désactiviez.';

  @override
  String get addTravelNeedsPremium =>
      'Le mode voyage fait partie de Premium. Obtenez-le dans Réglages > Obtenir Premium.';

  @override
  String get addAdvanced => 'Avancé';

  @override
  String get addAdvancedExisting =>
      'Ne modifiez ces réglages que si le site vous l\'a demandé. De mauvais réglages donnent de mauvais codes, et le site les refusera.';

  @override
  String get addAdvancedNew =>
      'La plupart des sites utilisent les réglages normaux. Ne les modifiez que si le site vous l\'a demandé.';

  @override
  String get addType => 'Type';

  @override
  String get addTypeTotp => 'Basé sur le temps (normal)';

  @override
  String get addTypeHotp => 'Basé sur un compteur (nouveau code à la demande)';

  @override
  String get addDigits => 'Chiffres';

  @override
  String get addAlgorithm => 'Algorithme';

  @override
  String get addSha1Normal => 'SHA-1 (normal)';

  @override
  String get addPeriod => 'Nouveau code toutes les';

  @override
  String addSeconds(int seconds) {
    return '$seconds secondes';
  }

  @override
  String get addCounter => 'Compteur';

  @override
  String get addCounterHelp => 'Nombre de codes déjà utilisés';

  @override
  String get addNotASharedFile =>
      'Ce fichier n\'est pas un compte partagé par Tanooki Auth. Demandez à la personne de le repartager.';

  @override
  String addAlreadyInList(String name) {
    return '$name est déjà dans votre liste.';
  }

  @override
  String get addThisAccount => 'Ajouter ce compte ?';

  @override
  String get addNoCameraWindows =>
      'Sous Windows, Tanooki Auth ne peut pas utiliser de caméra. Ouvrez plutôt une image du code QR ou collez le lien de configuration.';

  @override
  String get addFromGoogle => 'Transférer depuis Google Authenticator';

  @override
  String get addFromGoogleSteps =>
      'Sur l\'appareil qui a Google Authenticator :\n\n1. Ouvrez Google Authenticator.\n2. Touchez le menu (☰ ou ⋮), puis « Transférer des comptes », puis « Exporter des comptes ».\n3. Choisissez les comptes et touchez Suivant. Un code QR s\'affiche.\n\nScannez ensuite ce code QR ici. S\'il y a plusieurs codes QR, scannez-les tous.';

  @override
  String get addScan => 'Scanner';

  @override
  String get addOpenPicture => 'Ouvrir une image';

  @override
  String get addLookingOnScreen => 'Recherche d\'un code QR sur votre écran…';

  @override
  String get addScreenNoQr =>
      'Aucun code QR trouvé sur votre écran. Vérifiez que le code est entièrement visible et pas caché par une autre fenêtre, puis réessayez.';

  @override
  String get addScreenUnsupported =>
      'Scanner l\'écran nécessite macOS 14 (Sonoma) ou plus récent. Faites une capture d\'écran et utilisez plutôt « Ouvrir une image ».';

  @override
  String get addScreenFailed =>
      'Impossible de capturer l\'écran. Faites une capture d\'écran et utilisez plutôt « Ouvrir une image ».';

  @override
  String get addScreenWrongQr =>
      'Un code QR a été trouvé sur votre écran, mais ce n\'est pas un code de configuration de double authentification.';

  @override
  String get addScreenPermissionTitle =>
      'Autoriser Tanooki Auth à voir votre écran';

  @override
  String get addScreenPermissionSteps =>
      'Pour lire un code QR sur votre écran, votre Mac doit autoriser Tanooki Auth à le capturer. Tanooki Auth ne regarde que lorsque vous appuyez sur « Scanner mon écran », et l\'image ne quitte jamais ce Mac.\n\n1. Ouvrez Réglages Système (l\'icône d\'engrenage dans le Dock, ou menu Pomme > Réglages Système).\n2. Cliquez sur « Confidentialité et sécurité » dans la colonne de gauche.\n3. Cliquez sur « Enregistrement de l\'écran et de l\'audio du système ».\n4. Activez l\'interrupteur à côté de Tanooki Auth. S\'il n\'est pas dans la liste, cliquez sur +, choisissez Tanooki Auth dans Applications, puis activez-le.\n5. Votre Mac vous demandera de quitter Tanooki Auth. Cliquez sur « Quitter et rouvrir », puis appuyez de nouveau sur « Scanner mon écran ».';

  @override
  String get addPasteLinksTitle => 'Coller des liens de configuration';

  @override
  String get addPasteLinksHint =>
      'otpauth://totp/...\nUn lien par ligne. Vous pouvez en coller plusieurs à la fois.';

  @override
  String addManyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter $count comptes ?',
      one: 'Ajouter 1 compte ?',
    );
    return '$_temp0';
  }

  @override
  String addManyBadLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count lignes sont inutilisables ; vous verrez lesquelles ensuite.',
      one: '1 ligne est inutilisable ; vous verrez laquelle ensuite.',
    );
    return '$_temp0';
  }

  @override
  String get addEnterKey => 'Saisir la clé de configuration';

  @override
  String get addSetupKey => 'Clé de configuration';

  @override
  String get addSetupKeyHelp => 'Les lettres et chiffres affichés par le site';

  @override
  String get addBadKey =>
      'Cette clé de configuration n\'est pas valide. Elle ne doit contenir que des lettres de A à Z et des chiffres de 2 à 7.';

  @override
  String get addTitle => 'Ajouter un compte';

  @override
  String get addScanQr => 'Scanner un code QR';

  @override
  String get addScanQrHelp =>
      'Pointez la caméra vers le code affiché par le site';

  @override
  String addNoCameraOn(String platform) {
    return 'Pas de caméra sous $platform';
  }

  @override
  String get addScanScreen => 'Scanner mon écran';

  @override
  String get addScanScreenHelp =>
      'Lit un code QR affiché n\'importe où sur votre écran';

  @override
  String get addScanScreenLinux =>
      'Pas encore disponible sous Linux. Ouvrez plutôt une capture d\'écran du code QR.';

  @override
  String get addFromPhotos => 'Scanner un code QR depuis vos photos';

  @override
  String get addFromPicture => 'Ouvrir l\'image d\'un code QR';

  @override
  String get addFromPhotosHelp =>
      'Choisissez une capture d\'écran de la page de configuration';

  @override
  String get addFromPictureHelp =>
      'Une capture d\'écran de la page de configuration fonctionne';

  @override
  String get addPasteLink => 'Coller un lien de configuration';

  @override
  String get addPasteLinkHelp =>
      'Liens commençant par otpauth://, un ou plusieurs';

  @override
  String get addOpenShared => 'Ouvrir un compte partagé';

  @override
  String addOpenSharedHelp(String extension) {
    return 'Un fichier .$extension que quelqu\'un vous a envoyé';
  }

  @override
  String get addFromGoogleHelp => 'Transférez tous vos comptes en une fois';

  @override
  String get addFromOtherApp => 'Transférer depuis une autre app';

  @override
  String get addFromOtherAppHelp =>
      'Aegis, 2FAS, Authy, Bitwarden, 1Password, Mots de passe d\'Apple, Microsoft';

  @override
  String get addEnterKeyHelp =>
      'Saisissez la clé affichée sous « vous ne pouvez pas scanner le code ? »';

  @override
  String get addWrongQr =>
      'Ce code QR n\'est pas un code de configuration de double authentification.';

  @override
  String get addCameraDenied =>
      'Tanooki Auth n\'a pas le droit d\'utiliser la caméra. Autorisez l\'accès à la caméra pour Tanooki Auth dans les Réglages de votre appareil, ou revenez en arrière et utilisez une image ou la clé de configuration.';

  @override
  String addCameraFailed(String problem) {
    return 'La caméra n\'a pas pu démarrer ($problem). Revenez en arrière et utilisez plutôt une image ou la clé de configuration.';
  }

  @override
  String get helpNew030a =>
      'Des guides pas à pas pour activer la double authentification sur 40 sites populaires. Quand vous ajoutez ou modifiez un compte qui a un guide, un lien y mène.';

  @override
  String get helpNew030b =>
      'Une courte visite de bienvenue à la première ouverture de l\'app. Revoyez-la dans Réglages > Aide.';

  @override
  String get helpNew030c =>
      'Envoyez vos remarques depuis Réglages > Aide. Elles n\'incluent jamais vos comptes ni vos codes.';

  @override
  String get helpNew030d => 'Cette page Nouveautés.';

  @override
  String get helpNew030e =>
      'Importez depuis Mots de passe d\'Apple, et transférez vos comptes vers Aegis, 2FAS ou Google Authenticator.';

  @override
  String get helpNew030f =>
      'Codes Steam Guard, codes à compteur avec un bouton « Code suivant », et réglages avancés des codes avec aperçu en direct.';

  @override
  String get helpNew030g =>
      'Dossiers, sélection de plusieurs comptes à la fois, tri de A à Z ou par utilisation récente, et « Ranger les noms de comptes ».';

  @override
  String get helpNew030h =>
      'Affichez le code QR d\'un compte (après Face ID ou votre code) pour le transférer sur un autre appareil.';

  @override
  String get helpNew030i =>
      'Déverrouillage avec une clé de sécurité comme une YubiKey (Premium), sur les iPhone, Mac et PC Windows récents.';

  @override
  String get helpNew030j =>
      'Comptes « Demander d\'abord » qui exigent Face ID ou votre code avant d\'afficher le code, et mode voyage pour masquer les comptes choisis (Premium).';

  @override
  String get helpNew030k =>
      'Historique d\'activité (Premium), vérification de l\'horloge « Les codes ne marchent pas ? », Tester une sauvegarde, verrouillage à la mise en veille, et rappels de sauvegarde.';

  @override
  String get helpNew030l =>
      'Accès d\'urgence : laissez une personne de confiance demander vos comptes, avec plusieurs jours pour refuser.';

  @override
  String get helpNew030m =>
      'Recherche Spotlight, une Activité en direct pour le code copié et une complication de cadran (Premium), Copier à l\'ouverture, et « Effacer après un collage » sur Mac.';

  @override
  String get helpNew030n =>
      'Styles de compte à rebours, une couleur ou un emoji par compte, Lecture à voix haute, une police facile à lire, et une meilleure prise en charge des lecteurs d\'écran.';

  @override
  String get helpNew030o =>
      'Une mise en page large pour les grandes fenêtres, et des icônes Premium de saison.';

  @override
  String get helpNew030p =>
      'Achetez Premium dans l\'app sur iPhone et Android, offrez-le et invitez vos amis.';

  @override
  String get helpNew030q =>
      'Coffre d\'équipe pour partager des codes avec jusqu\'à 10 personnes. L\'offre équipe elle-même arrive bientôt.';

  @override
  String get helpNew030r => 'L\'offre Famille arrive bientôt.';

  @override
  String get helpNew030s =>
      'L\'app de bureau fonctionne maintenant aussi sous Linux. Les téléchargements pour Linux arrivent bientôt.';

  @override
  String get helpNew020a =>
      'Synchronisation entre vos appareils, liaison du téléphone pour l\'extension du navigateur, et partage sécurisé d\'un compte.';

  @override
  String get helpNew020b =>
      'Code d\'accès, verrouillage automatique, effacement d\'urgence, code leurre, blocage des captures d\'écran, bilan et alertes de fuites.';

  @override
  String get helpNew020c =>
      'Widgets, apps Apple Watch et Wear OS, la barre des menus du Mac et la zone de notification de Windows, et des sauvegardes chiffrées automatiques (Premium).';

  @override
  String get helpNew020d =>
      'Import depuis Aegis, 2FAS, Authy, Bitwarden et 1Password, plus favoris, étiquettes, notes, codes de récupération et Corbeille.';

  @override
  String get helpNew010a =>
      'La première version : scanner ou coller des comptes, voir les codes, sauvegardes chiffrées, et l\'extension du navigateur.';

  @override
  String helpNoBrowser(String url) {
    return 'Impossible d\'ouvrir votre navigateur. La page est $url';
  }

  @override
  String helpGuideFor(String name) {
    return 'Activer la double authentification sur $name';
  }

  @override
  String get helpTourWelcome => 'Bienvenue dans Tanooki Auth';

  @override
  String get helpTourWelcomeBody =>
      'Beaucoup de sites peuvent demander un code à 6 chiffres en plus de votre mot de passe. C\'est la double authentification, ou 2FA. Tanooki Auth crée ces codes pour vous, directement sur votre appareil : quelqu\'un qui n\'a que votre mot de passe ne peut donc pas entrer.';

  @override
  String get helpTourAdd => 'Ajoutez votre premier compte';

  @override
  String get helpTourAddBody =>
      'Activez la double authentification dans les réglages de sécurité d\'un site. Il affiche un code QR : scannez-le ici, ou copiez son lien de configuration et collez-le. Vous utilisez déjà une autre app d\'authentification ? Transférez vos comptes en une fois.';

  @override
  String get helpTourScanOrPaste => 'Scanner un code QR ou coller un lien';

  @override
  String get helpTourImport => 'Importer depuis une autre app';

  @override
  String get helpTourPopular => 'Les sites populaires à protéger en premier';

  @override
  String get helpTourPopularBody =>
      'Votre messagerie, vos réseaux sociaux et tout ce qui touche à votre argent comptent le plus. Nos guides pas à pas montrent où se trouve le réglage de double authentification sur chaque site.';

  @override
  String get helpAllGuides => 'Tous les guides 2FA';

  @override
  String helpTourStep(int step, int total) {
    return 'Étape $step sur $total';
  }

  @override
  String get helpTourSkip => 'Passer la visite';

  @override
  String get helpWhatsNew => 'Nouveautés';

  @override
  String helpVersion(String version) {
    return 'Version $version';
  }

  @override
  String helpVersionThis(String version) {
    return 'Version $version (cette version)';
  }

  @override
  String get helpFeedbackEmpty => 'Écrivez d\'abord un message.';

  @override
  String get helpFeedbackSent => 'Envoyé. Merci ! Maddie lit chaque message.';

  @override
  String get helpFeedbackTooLong =>
      'C\'est trop long pour être envoyé. Raccourcissez-le (4 000 caractères environ au maximum).';

  @override
  String get helpFeedbackTooMany =>
      'Vous avez envoyé beaucoup de messages dans la dernière heure. Réessayez dans une heure.';

  @override
  String get helpFeedbackOffline =>
      'Impossible d\'accéder à internet. Vérifiez votre connexion et réessayez. Votre message est toujours là.';

  @override
  String get helpFeedbackServerError =>
      'Le serveur de remarques a eu un problème et n\'a pas reçu votre message. Réessayez plus tard. Votre message est toujours là.';

  @override
  String get helpFeedbackTitle => 'Envoyer une remarque';

  @override
  String get helpFeedbackIntro =>
      'Vous avez trouvé un bug, ou aimeriez que l\'app fasse quelque chose ? Dites-le à Maddie ici.';

  @override
  String get helpFeedbackMessage => 'Votre message';

  @override
  String get helpFeedbackEmail => 'Votre e-mail (facultatif)';

  @override
  String get helpFeedbackEmailHelp =>
      'Seulement si vous souhaitez une réponse.';

  @override
  String get helpFeedbackDevice =>
      'Inclure la version de l\'app et le type d\'appareil';

  @override
  String get helpFeedbackDeviceHelp =>
      'Par exemple « 0.3.0 » et « iOS ». Cela aide à trouver les bugs.';

  @override
  String get helpFeedbackNeverSent =>
      'Jamais envoyé : vos comptes, leurs noms, les codes, les clés de configuration, les étiquettes, les notes ou quoi que ce soit d\'autre dans l\'app.';

  @override
  String get helpFeedbackSend => 'Envoyer';

  @override
  String get phoneUiPushAndroid =>
      'Les notifications sur Android ne sont pas encore configurées : les demandes apparaissent quand Tanooki Auth est ouverte.';

  @override
  String get phoneUiPushThisDevice =>
      'Cet appareil reçoit les demandes quand Tanooki Auth est ouverte.';

  @override
  String get phoneUiPushNoToken =>
      'L\'iPhone n\'a pas fourni de jeton de notification à l\'app.';

  @override
  String get phoneUiPushDenied =>
      'Les notifications sont désactivées pour Tanooki Auth. Activez-les dans l\'app Réglages de l\'iPhone, sous Notifications, pour recevoir les demandes quand l\'app est fermée.';

  @override
  String phoneUiPushFailed(String problem) {
    return 'Impossible d\'activer les notifications : $problem. Les demandes apparaissent toujours quand Tanooki Auth est ouverte.';
  }

  @override
  String get phoneUiPushNotInBuild =>
      'Les notifications ne sont pas disponibles dans cette version. Les demandes apparaissent quand Tanooki Auth est ouverte.';

  @override
  String get phoneUiPushChecking => 'Vérification des notifications…';

  @override
  String get phoneUiRequest => 'Demande de code de connexion';

  @override
  String get phoneUiNoAccount =>
      'Aucun compte n\'est enregistré pour ce site, il n\'y a donc rien à envoyer. Si vous en attendiez un, c\'est peut-être un faux site qui se fait passer pour un vrai.';

  @override
  String get phoneUiWantsCode =>
      'Votre navigateur associé demande le code de ce site. N\'approuvez que si vous êtes en train de vous connecter.';

  @override
  String get phoneUiApprove => 'Approuver';

  @override
  String phoneUiApproveAccount(String name) {
    return 'Approuver : $name';
  }

  @override
  String get phoneUiScanTitle => 'Scannez le code du navigateur';

  @override
  String get phoneUiScanWrong =>
      'Ce n\'est pas un code d\'association de navigateur. Dans le navigateur, cliquez sur l\'extension Tanooki Auth, puis sur « Utiliser mon téléphone ».';

  @override
  String get phoneUiPasteTitle => 'Collez le lien d\'association';

  @override
  String get phoneUiPair => 'Associer';

  @override
  String get phoneUiPaired =>
      'Associé. Quand ce navigateur demandera un code, vous le verrez ici.';

  @override
  String get phoneUiExpired =>
      'Ce code a expiré. Dans le navigateur, créez-en un nouveau et scannez-le à nouveau.';

  @override
  String get phoneUiPremium =>
      'Utiliser votre téléphone avec un navigateur fait partie de Premium';

  @override
  String get phoneUiIntro =>
      'Remplissez les codes dans un navigateur sur n\'importe quel ordinateur, même sans l\'app Tanooki Auth. L\'extension du navigateur demande, et vous touchez Approuver ici. Les codes voyagent chiffrés de bout en bout, et seulement pour le site de chaque compte.';

  @override
  String get phoneUiPairBrowser => 'Associer un navigateur';

  @override
  String get phoneUiPairHelp =>
      'Dans le navigateur, cliquez sur l\'extension Tanooki Auth, puis sur « Utiliser mon téléphone » pour afficher le code.';

  @override
  String get phoneUiPairedBrowsers => 'Navigateurs associés';

  @override
  String get phoneUiNoneYet => 'Aucun pour le moment';

  @override
  String get phoneUiBrowser => 'Navigateur';

  @override
  String phoneUiPairedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Associé le $dateString';
  }

  @override
  String get phoneUiUnpair => 'Dissocier';

  @override
  String get phoneUiPushOn => 'Notifications activées';

  @override
  String get phoneUiPushOff =>
      'Les demandes s\'affichent quand l\'app est ouverte';

  @override
  String get phoneUiPushOnHelp =>
      'Vous recevrez une notification pour chaque demande, même quand Tanooki Auth est fermée.';

  @override
  String phoneUiSendCodeFor(String name) {
    return 'Envoyer le code de $name';
  }

  @override
  String get phoneUiActivityWhere => 'Navigateur, via ce téléphone';

  @override
  String get premiumFiveOnce => '5 \$ une seule fois';

  @override
  String get premiumPayOnce => 'Payez une fois';

  @override
  String get premiumCheckoutSoon =>
      'Le paiement n\'est pas encore ouvert ; il arrive très bientôt. Merci de vouloir soutenir Tanooki Auth !';

  @override
  String get premiumEnterKeyTitle => 'Saisir la clé de licence';

  @override
  String get premiumEnterKeyHint => 'TA1.…  (dans votre e-mail d\'achat)';

  @override
  String get premiumBadKey =>
      'Cette clé de licence n\'est pas valide. Copiez la clé entière depuis votre e-mail d\'achat et réessayez.';

  @override
  String premiumInvitesNowFamily(int count) {
    return '$count amis ont acheté Premium avec votre lien : votre clé est maintenant une clé Famille pour 5 personnes maximum. Elle est installée sur cet appareil. Copiez la nouvelle clé ci-dessous et saisissez-la aussi sur vos autres appareils.';
  }

  @override
  String premiumInvitesAlreadyFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count amis ont acheté Premium avec votre lien. Votre clé est déjà une clé Famille.',
      one: '1 ami a acheté Premium avec votre lien. Votre clé est déjà une clé Famille.',
    );
    return '$_temp0';
  }

  @override
  String premiumInvitesProgress(int count, int needed, int left) {
    return '$count amis sur $needed ont acheté Premium avec votre lien. Encore $left et votre clé devient une clé Famille.';
  }

  @override
  String get premiumInviteLinkCopied => 'Lien d\'invitation copié.';

  @override
  String get premiumKeyCopied => 'Clé de licence copiée.';

  @override
  String premiumJustMe(String price) {
    return 'Juste moi — $price';
  }

  @override
  String premiumFamilyPrice(String price) {
    return 'Famille (5 personnes max.) — $price';
  }

  @override
  String get premiumFamilyApple =>
      'Famille : partagé avec votre famille Apple via le Partage familial, plus une clé de licence pour 5 personnes max. sur n\'importe quel appareil.';

  @override
  String get premiumFamilyKey =>
      'Famille : une clé de licence à partager avec jusqu\'à 4 autres personnes.';

  @override
  String get premiumYourKey => 'Votre clé de licence';

  @override
  String get premiumYourKeyHelp =>
      'Saisissez-la sur vos autres appareils : Réglages → Obtenir Premium → « Déjà acheté ? Saisissez votre clé de licence ».';

  @override
  String get premiumCopyKey => 'Copier la clé';

  @override
  String get premiumInviteFriends => 'Inviter des amis';

  @override
  String get premiumInviteHelp =>
      'Vos amis ont 20 % de réduction. Quand 3 amis achètent, votre clé devient une clé Famille.';

  @override
  String get premiumGetInvite => 'Obtenir mon lien d\'invitation';

  @override
  String get premiumCheckInvites => 'Voir mes invitations';

  @override
  String get premiumYouHave => 'Vous avez Premium';

  @override
  String get premiumTitle => 'Tanooki Auth Premium';

  @override
  String get premiumOwnedFamily =>
      'Offre Famille : partagez votre clé de licence avec jusqu\'à 4 autres personnes (5 en tout). Merci de soutenir Tanooki Auth.';

  @override
  String get premiumOwnedThanks => 'Merci de soutenir Tanooki Auth.';

  @override
  String get premiumPitchStripe =>
      '5 \$ une seule fois, ou 10 \$ pour toute la famille. À vous pour toujours.';

  @override
  String get premiumPitchStore =>
      'Payez une fois pour vous, ou une fois pour toute la famille. À vous pour toujours.';

  @override
  String get premiumPerkThemes => 'Tous les thèmes Premium';

  @override
  String premiumPerkThemesBody(int count) {
    return 'Rose pastel, Bleu pastel et $count autres, plus tous les thèmes ajoutés plus tard.';
  }

  @override
  String get premiumPerkIcons => 'Icônes de l\'app';

  @override
  String premiumPerkIconsBody(int count) {
    return 'Choisissez une autre icône d\'écran d\'accueil sur iPhone et Android, en Rose pastel, Bleu pastel et $count autres couleurs, plus des icônes de saison pour l\'automne, l\'hiver et le printemps. Sur Mac, elle change l\'icône du Dock tant que l\'app est ouverte.';
  }

  @override
  String get premiumPerkSync => 'Synchronisation entre vos appareils';

  @override
  String get premiumPerkSyncBody =>
      'Ajoutez un compte sur un appareil et retrouvez-le sur tous, chiffré de bout en bout. Via iCloud sur les appareils Apple, ou le relais Tanooki pour tout mélange d\'appareils.';

  @override
  String get premiumPerkApprove => 'Approuvez les codes depuis votre téléphone';

  @override
  String get premiumPerkApproveBody =>
      'Utilisez l\'extension du navigateur sur n\'importe quel ordinateur : elle demande à votre téléphone, vous touchez Approuver, et le code se remplit.';

  @override
  String get premiumPerkBreach => 'Alertes de fuites';

  @override
  String get premiumPerkBreachBody =>
      'Soyez prévenu quand un site où vous avez un compte figure dans une fuite de données connue. Vérifié sur votre appareil ; rien vous concernant n\'est envoyé.';

  @override
  String get premiumPerkShare => 'Partagez un compte en toute sécurité';

  @override
  String get premiumPerkShareBody =>
      'Donnez un compte à une personne de confiance avec un code QR et un code à 6 chiffres. Verrouillé, expire en 24 heures, sans serveur.';

  @override
  String get premiumPerkFamily => 'Offre Famille';

  @override
  String get premiumPerkFamilyStripe =>
      'Pour 10 \$ au lieu de 5 \$, une clé débloque Premium pour 5 personnes max. Envoyez-la à votre famille, qui la saisit comme vous.';

  @override
  String get premiumPerkFamilyStore =>
      'Un achat Famille débloque Premium pour 5 personnes max. Envoyez-leur votre clé de licence, qu\'ils saisissent comme vous.';

  @override
  String get premiumPerkFuture => 'Toutes les futures fonctions Premium';

  @override
  String get premiumPerkFutureBody =>
      'Payez une fois et profitez de tout ce que Premium deviendra. Jamais d\'abonnement.';

  @override
  String get premiumPerkFree =>
      'Garde les apps respectueuses de la vie privée gratuites';

  @override
  String get premiumPerkFreeStripe =>
      'Vos 5 \$ me permettent de continuer à créer des apps gratuites qui ne vous pistent pas.';

  @override
  String get premiumPerkFreeStore =>
      'Acheter Premium me permet de continuer à créer des apps gratuites qui ne vous pistent pas.';

  @override
  String get premiumFreeForever =>
      'Gratuit pour toujours, avec ou sans Premium : comptes illimités, scan, sauvegardes, l\'extension du navigateur et le verrouillage de l\'app.';

  @override
  String get premiumFamilySoon => 'Offre Famille bientôt disponible';

  @override
  String get premiumFamilyKeyEach =>
      'Famille : une clé de licence à partager avec jusqu\'à 4 autres personnes. Chacune la saisit dans son propre Tanooki Auth.';

  @override
  String get premiumRestore => 'Restaurer les achats';

  @override
  String get premiumAlreadyBought =>
      'Déjà acheté ? Saisissez votre clé de licence';

  @override
  String get premiumDesktopKeySoon =>
      'La clé pour ordinateur arrive bientôt pour les achats Android. Premium est déjà débloqué sur ce téléphone ; une clé de licence pour vos ordinateurs apparaîtra ici dans une prochaine mise à jour.';

  @override
  String premiumGift(String price) {
    return 'Offrir Premium — $price';
  }

  @override
  String premiumGiftFamily(String price) {
    return 'Offrir l\'offre Famille — $price';
  }

  @override
  String get premiumGiftHelp =>
      'Après le paiement, vous recevez une carte cadeau imprimable avec une clé pour la personne.';

  @override
  String get settingsIconFailed =>
      'Impossible de changer l\'icône de l\'app. Réessayez, ou redémarrez l\'app.';

  @override
  String settingsIconFailedWhy(String problem) {
    return 'Impossible de changer l\'icône de l\'app ($problem). Réessayez, ou redémarrez l\'app.';
  }

  @override
  String settingsIconSemantic(String name) {
    return 'Icône d\'app $name';
  }

  @override
  String settingsIconSemanticPremium(String name) {
    return 'Icône d\'app $name, Premium';
  }

  @override
  String get settingsAppIcon => 'Icône de l\'app';

  @override
  String get settingsAppIconPremium => 'Icône de l\'app (Premium)';

  @override
  String get settingsAppIconIos => 'L\'icône sur votre écran d\'accueil.';

  @override
  String get settingsAppIconAndroid =>
      'L\'icône sur votre écran d\'accueil. Elle peut disparaître un instant pendant que votre téléphone la change.';

  @override
  String get settingsAppIconMac =>
      'Change l\'icône du Dock tant que Tanooki Auth est ouverte. Les Mac ne peuvent pas garder une autre icône une fois l\'app fermée : le Finder et Launchpad gardent la bleue.';

  @override
  String get settingsAppIconOther =>
      'Les icônes de l\'app se changent sur iPhone et Android.';

  @override
  String get settingsLockNameMac => 'Touch ID ou le mot de passe de votre Mac';

  @override
  String get settingsLockNamePhone => 'Face ID, empreinte digitale ou code';

  @override
  String settingsNoLockSetUp(String lock) {
    return 'Aucun de ces moyens n\'est configuré sur cet appareil ($lock), donc l\'app ne peut pas être verrouillée. Configurez-en un dans les réglages du système d\'abord.';
  }

  @override
  String get settingsLockReasonOn => 'Activer le verrouillage de l\'app';

  @override
  String get settingsLockReasonOff => 'Désactiver le verrouillage de l\'app';

  @override
  String get settingsSetPasscode => 'Définir un code pour l\'app';

  @override
  String get settingsSetPasscodeIntro =>
      'Saisissez-le pour ouvrir Tanooki Auth. Il marche aussi quand Face ID ou votre empreinte ne marchent pas. Si vous l\'oubliez, le seul moyen de revenir est une sauvegarde.';

  @override
  String get settingsPasscodeOn => 'Code de l\'app activé.';

  @override
  String get settingsPasscode => 'Code de l\'app';

  @override
  String get settingsChangePasscode => 'Changer le code';

  @override
  String get settingsPasscodeOff => 'Désactiver le code';

  @override
  String get settingsNewPasscode => 'Nouveau code de l\'app';

  @override
  String get settingsPasscodeChanged => 'Code modifié.';

  @override
  String get settingsPasscodeIsOff => 'Code de l\'app désactivé.';

  @override
  String get settingsRemoveDecoyTitle => 'Supprimer le code leurre ?';

  @override
  String get settingsRemoveDecoyBody =>
      'Les comptes leurres sont effacés. Vos vrais comptes restent intacts.';

  @override
  String get settingsSetDecoy => 'Définir un code leurre';

  @override
  String get settingsSetDecoyIntro =>
      'Si quelqu\'un vous force à ouvrir Tanooki Auth, saisissez plutôt celui-ci. Il ouvre un ensemble de comptes séparé et vide, et rien à l\'écran ne montre que ce n\'est pas le vrai. Ajoutez-y quelques comptes sans importance pour qu\'il ait l\'air utilisé.\n\nVotre vrai code continue d\'ouvrir vos vrais comptes.';

  @override
  String get settingsDecoySet => 'Code leurre défini.';

  @override
  String settingsWipeTitle(int count) {
    return 'Tout effacer après $count codes erronés ?';
  }

  @override
  String settingsWipeBody(int count) {
    return 'Si quelqu\'un se trompe de code $count fois de suite, Tanooki Auth efface tous les comptes de cet appareil. Impossible d\'annuler ou d\'arrêter une fois lancé.';
  }

  @override
  String get settingsWipeSureTitle => 'Vous êtes sûr ?';

  @override
  String get settingsWipeSureBody =>
      'Un enfant qui joue avec votre téléphone, ou vous un mauvais jour, peut le déclencher. Après un effacement, le seul moyen de revenir est votre fichier de sauvegarde. Sans lui, vous pourriez être bloqué sur tous les sites qui utilisent ces codes.';

  @override
  String get settingsWipeTurnOn => 'Activer l\'effacement d\'urgence';

  @override
  String get settingsTravelOffReason => 'Désactiver le mode voyage';

  @override
  String get settingsTravelOnNone =>
      'Mode voyage activé, mais aucun compte n\'est encore marqué « Masquer en mode voyage ». Marquez-les d\'abord avec ⋯ > Modifier.';

  @override
  String settingsTravelOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mode voyage activé. $count comptes sont masqués.',
      one: 'Mode voyage activé. 1 compte est masqué.',
    );
    return '$_temp0';
  }

  @override
  String get settingsTravelOff =>
      'Mode voyage désactivé. Tous les comptes sont revenus.';

  @override
  String get settingsCheckingClock => 'Vérification de votre horloge…';

  @override
  String get settingsClockRight =>
      'Votre horloge est juste, ce n\'est donc pas ça. Vérifiez que les réglages du compte (⋯ > Modifier > Avancé) correspondent à ce que le site a indiqué.';

  @override
  String settingsClockFailed(String problem) {
    return 'Impossible de vérifier l\'horloge : $problem';
  }

  @override
  String get settingsLockApp => 'Verrouiller l\'app';

  @override
  String settingsLockAppHelp(String lock) {
    return 'Demander $lock à l\'ouverture de l\'app';
  }

  @override
  String get settingsPasscodeOnHelp =>
      'Activé. Touchez pour le changer ou le désactiver.';

  @override
  String settingsPasscodeOffHelp(String lock) {
    return 'Désactivé. Des chiffres à saisir pour ouvrir l\'app, à la place ou en plus de : $lock.';
  }

  @override
  String get settingsLockAgain => 'Reverrouiller';

  @override
  String settingsLockAgainHelp(String time) {
    return '$time en arrière-plan';
  }

  @override
  String get settingsLockFirst => 'Activez d\'abord le verrouillage ou un code';

  @override
  String get settingsDecoy => 'Code leurre';

  @override
  String get settingsDecoyOn =>
      'Activé. Ouvre un ensemble de comptes séparé. Touchez pour le supprimer.';

  @override
  String get settingsDecoyOff =>
      'Un second code qui ouvre un ensemble de comptes séparé et vide';

  @override
  String settingsWipe(int count) {
    return 'Effacer après $count codes erronés';
  }

  @override
  String get settingsWipeHelp =>
      'Effacement d\'urgence. Nécessite une sauvegarde de moins de 30 jours.';

  @override
  String get settingsLockOnSleep =>
      'Verrouiller quand l\'ordinateur se met en veille';

  @override
  String get settingsLockOnSleepHelp =>
      'Aussi quand l\'écran se verrouille ou que vous vous déconnectez un instant';

  @override
  String get settingsLockOnSleepNeedsLock =>
      'Activez d\'abord « Verrouiller l\'app » ou un code, pour qu\'il y ait quelque chose à verrouiller.';

  @override
  String get settingsTravel => 'Mode voyage';

  @override
  String get settingsTravelPremium => 'Mode voyage (Premium)';

  @override
  String get settingsTravelOnHelp =>
      'Activé. Les comptes marqués « Masquer en mode voyage » disparaissent des écrans, widgets, montre, extension et exports de cet appareil jusqu\'à ce que vous le désactiviez. Ils ne sont pas supprimés.';

  @override
  String settingsTravelOffHelp(String proof) {
    return 'Avant un passage de frontière : masque les comptes marqués « Masquer en mode voyage » (⋯ > Modifier). Le désactiver demande $proof.';
  }

  @override
  String get settingsKeys => 'Clés de sécurité';

  @override
  String get settingsKeysPremium => 'Clés de sécurité (Premium)';

  @override
  String get settingsKeysHelp =>
      'Déverrouillez avec une YubiKey ou une autre clé de sécurité';

  @override
  String get settingsActivity => 'Historique d\'activité';

  @override
  String get settingsActivityPremium => 'Historique d\'activité (Premium)';

  @override
  String get settingsActivityHelp =>
      'Quels codes ont été copiés, remplis, tapés ou exportés, et quand. Conservé sur cet appareil uniquement.';

  @override
  String get settingsEmergency => 'Accès d\'urgence';

  @override
  String get settingsEmergencyPremium => 'Accès d\'urgence (Premium)';

  @override
  String get settingsEmergencyHelp =>
      'Permettez à une personne de confiance de récupérer vos comptes s\'il vous arrive quelque chose, après une attente de 7 jours que vous pouvez arrêter';

  @override
  String get settingsTeamHelp =>
      'Partagez des codes de connexion avec jusqu\'à 10 personnes, chiffrés de bout en bout';

  @override
  String get settingsMonthly => 'Notification du bilan mensuel';

  @override
  String get settingsMonthlyPremium =>
      'Notification du bilan mensuel (Premium)';

  @override
  String get settingsMonthlyHelp =>
      'Un rappel le 1er de chaque mois pour consulter votre carte de bilan. Il ne dit jamais rien de vos comptes.';

  @override
  String get settingsBlockShots => 'Bloquer les captures d\'écran';

  @override
  String get settingsBlockShotsDesktop =>
      'Masque cette fenêtre des captures, enregistrements et partages d\'écran';

  @override
  String get settingsBlockShotsPhone =>
      'Garde les codes hors des captures, enregistrements d\'écran et du sélecteur d\'apps';

  @override
  String get settingsCheckup => 'Bilan de sécurité';

  @override
  String get settingsCheckupHelp =>
      'Points à corriger, et votre kit de récupération';

  @override
  String get settingsBreachPremium => 'Alertes de fuites (Premium)';

  @override
  String get settingsBreachOn =>
      'Activé. Vérifie la liste publique des fuites chaque semaine.';

  @override
  String get settingsBreachOff =>
      'Désactivé. Une fois activé, l\'app télécharge la liste publique des fuites une fois par semaine.';

  @override
  String settingsThemeSemantic(String name) {
    return 'Thème $name';
  }

  @override
  String settingsThemeSemanticPremium(String name) {
    return 'Thème $name, Premium';
  }

  @override
  String get settingsPremiumThanks => 'Premium : merci !';

  @override
  String get settingsGetPremium => 'Obtenir Premium';

  @override
  String get settingsPremiumThanksHelp =>
      'Tous les thèmes et les futures fonctions Premium sont à vous.';

  @override
  String settingsGetPremiumHelp(String payOnce) {
    return '$payOnce : tous les thèmes, la synchronisation entre vos appareils, et plus.';
  }

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsCountdown => 'Style du compte à rebours';

  @override
  String get settingsCountdownHelp =>
      'Comment le temps restant de chaque code est affiché';

  @override
  String get settingsEasyFont => 'Police facile à lire';

  @override
  String get settingsEasyFontHelp =>
      'Atkinson Hyperlegible, créée par le Braille Institute pour que lettres et chiffres soient difficiles à confondre';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Système';

  @override
  String get settingsAccountsList => 'Liste des comptes';

  @override
  String get settingsCompact => 'Cartes compactes';

  @override
  String get settingsCompactHelp =>
      'Des cartes plus petites, pour voir plus de comptes à l\'écran';

  @override
  String get settingsSort => 'Trier les comptes';

  @override
  String settingsSortHelp(String sort) {
    return '$sort. Les favoris viennent toujours en premier.';
  }

  @override
  String get settingsSortCustom =>
      'Votre propre ordre. Maintenez une carte appuyée, puis faites-la glisser.';

  @override
  String get settingsSortRecent =>
      'Les comptes dont vous venez de copier un code remontent en haut';

  @override
  String get settingsSortName => 'Par nom du service';

  @override
  String get settingsTidyHelp =>
      'Transforme des noms comme « google.com:you@gmail.com » en « Google ». Vous voyez chaque changement d\'abord.';

  @override
  String get settingsHideCodes => 'Masquer les codes jusqu\'au toucher';

  @override
  String get settingsHideCodesHelp =>
      'Affiche des points au lieu des codes, pour que les personnes autour ne puissent pas les lire';

  @override
  String get settingsShareCodes =>
      'Afficher les codes sur les widgets et la montre';

  @override
  String get settingsShareCodesHelp =>
      'Les codes de vos favoris s\'affichent sur votre écran d\'accueil, l\'écran verrouillé et la montre sans ouvrir cette app : quiconque tient votre téléphone déverrouillé ou votre montre peut les lire. Ajoutez une étoile à un compte pour en faire un favori.';

  @override
  String get settingsTrash => 'Corbeille';

  @override
  String settingsTrashCount(int count) {
    return 'Corbeille ($count)';
  }

  @override
  String get settingsTrashHelp => 'Les comptes supprimés restent ici 30 jours';

  @override
  String get settingsWatchFace => 'Favori du cadran';

  @override
  String get settingsWatchFacePremium => 'Favori du cadran (Premium)';

  @override
  String get settingsWatchFaceNoFavorites =>
      'Ajoutez d\'abord une étoile à un compte dans la liste principale. Seuls les favoris peuvent aller sur le cadran.';

  @override
  String get settingsNone => 'Aucun';

  @override
  String get settingsCopying => 'Copie et raccourcis';

  @override
  String get settingsCopyOnOpen => 'Copier à l\'ouverture';

  @override
  String get settingsCopyOnOpenHelp =>
      'Ouvrir ou déverrouiller l\'app copie le code du dernier compte utilisé. Les comptes qui demandent avant d\'afficher leur code sont ignorés.';

  @override
  String get settingsPasteOnce => 'Effacer après un collage';

  @override
  String get settingsPasteOnceHelp =>
      'Le code copié sert pour un seul collage, puis le presse-papiers se vide. Les apps d\'historique du presse-papiers peuvent compter comme ce collage. Sous Windows, les codes s\'effacent plutôt après 30 secondes.';

  @override
  String get settingsSpotlight => 'Afficher les comptes dans Spotlight';

  @override
  String get settingsSpotlightHelp =>
      'Recherchez le nom d\'un compte de n\'importe où et accédez-y directement. Seuls les noms sont partagés, jamais les codes.';

  @override
  String get settingsLiveActivity => 'Code sur l\'écran verrouillé après copie';

  @override
  String get settingsLiveActivityPremium =>
      'Code sur l\'écran verrouillé après copie (Premium)';

  @override
  String get settingsLiveActivityHelp =>
      'Après avoir copié un code, il s\'affiche sur l\'écran verrouillé et la Dynamic Island avec un compte à rebours jusqu\'à son expiration.';

  @override
  String get settingsWatchFaceHelp =>
      'Choisissez un favori dont le code s\'affiche sur le cadran de votre Apple Watch. Nécessite « Afficher les codes sur les widgets et la montre » activé.';

  @override
  String settingsWatchFaceChosen(String name) {
    return '$name. Ajoutez la complication Tanooki Auth à votre cadran pour le voir.';
  }

  @override
  String get settingsBrowserSection => 'Extension du navigateur et lanceurs';

  @override
  String get settingsBridgeOff => 'Inactif';

  @override
  String get settingsBridgeOn => 'Prêt pour l\'extension du navigateur';

  @override
  String settingsBridgeOffHelp(String first, String last) {
    return 'Les ports $first–$last sont tous utilisés par d\'autres programmes, donc l\'extension ne peut pas se connecter. Redémarrez votre ordinateur et réessayez.';
  }

  @override
  String settingsBridgeOnHelp(String port) {
    return 'À l\'écoute sur cet ordinateur uniquement (127.0.0.1:$port). Fonctionne tant que Tanooki Auth est ouverte.';
  }

  @override
  String settingsPairedClient(String name) {
    return 'Associé : $name';
  }

  @override
  String get settingsPairedBrowser => 'Navigateur associé';

  @override
  String settingsExtensionId(String id) {
    return 'Extension $id';
  }

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsSecurity => 'Sécurité';

  @override
  String get settingsBackup => 'Sauvegarde';

  @override
  String get settingsExport => 'Exporter une sauvegarde';

  @override
  String get settingsExportHelp =>
      'Un fichier chiffré, verrouillé par une phrase secrète de votre choix';

  @override
  String get settingsImport => 'Importer une sauvegarde';

  @override
  String get settingsImportHelp =>
      'Ajoute les comptes d\'un fichier de sauvegarde ; ignore ceux que vous avez déjà';

  @override
  String get settingsTestBackup => 'Tester une sauvegarde';

  @override
  String get settingsTestBackupHelp =>
      'Vérifie qu\'un fichier de sauvegarde s\'ouvre avec votre phrase secrète. Ne modifie rien.';

  @override
  String get settingsMoveOut => 'Transférer vers une autre app';

  @override
  String get settingsMoveOutHelp =>
      'Aegis, 2FAS, Google Authenticator, ou de simples liens de configuration';

  @override
  String get settingsPaper => 'Imprimer une sauvegarde papier';

  @override
  String get settingsPaperHelp =>
      'Un PDF de codes QR et de codes de récupération à garder sous clé';

  @override
  String get settingsHelp => 'Aide';

  @override
  String get settingsGuidesHelp =>
      'Aide pas à pas pour activer la double authentification sur les sites populaires, sur notre site';

  @override
  String get settingsTour => 'Revoir la visite de bienvenue';

  @override
  String get settingsFeedbackHelp =>
      'Signalez un bug ou une idée à Maddie. N\'inclut jamais vos comptes ni vos codes.';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsAboutMaddieHelp =>
      'Un mot de la personne qui fait Tanooki Auth';

  @override
  String get settingsCodesNotWorking => 'Les codes ne marchent pas ?';

  @override
  String settingsCodesNotWorkingHelp(String time) {
    return 'Heure de l\'appareil : $time. Les codes dépendent de l\'horloge : touchez pour la comparer avec internet.';
  }

  @override
  String shareUiConfirmTitle(String name) {
    return 'Partager $name ?';
  }

  @override
  String get shareUiConfirmBody =>
      'La personne avec qui vous le partagez obtient un accès complet : son téléphone produira les mêmes codes que le vôtre, tant qu\'elle le garde. Ne partagez qu\'avec quelqu\'un en qui vous avez entièrement confiance, comme votre famille.\n\nLe retirer de votre liste plus tard ne le lui reprend pas. Pour lui couper l\'accès, désactivez puis réactivez la double authentification sur le site.';

  @override
  String get shareUiConfirmButton => 'J\'ai compris, partager';

  @override
  String get shareUiLocking => 'Verrouillage du partage…';

  @override
  String shareUiTitle(String name) {
    return 'Partager $name';
  }

  @override
  String get shareUiInstructions =>
      'Sur son appareil : ouvrir Tanooki Auth, toucher Ajouter un compte, puis « Scanner un code QR » (ou « Ouvrir un compte partagé » pour le fichier). Puis saisir ce code :';

  @override
  String get shareUiTellCode =>
      'Donnez-lui le code vous-même, à voix haute ou dans une autre app que celle du fichier.';

  @override
  String get shareUiSendFile => 'Envoyer plutôt en fichier';

  @override
  String get shareUiCopyLink => 'Copier en lien';

  @override
  String get shareUiCopied =>
      'Copié. Il suffit de le coller avec « Coller un lien de configuration ».';

  @override
  String get shareUiWorksFor =>
      'Valable 24 heures, et seulement avec le code. Rien ne passe par un serveur.';

  @override
  String get shareUiOpenTitle => 'Compte partagé';

  @override
  String get shareUiOpenBody =>
      'Saisissez le code à 6 chiffres que vous a donné la personne qui l\'a partagé.';

  @override
  String get shareUiUnlocking => 'Déverrouillage…';

  @override
  String get signatureLabel => 'Signé, Maddie';

  @override
  String get syncUiQrCode => 'Code QR';

  @override
  String get syncUiNotYet => 'Pas encore';

  @override
  String get syncUiJustNow => 'À l\'instant';

  @override
  String syncUiMinutesAgo(int minutes) {
    return 'il y a $minutes min';
  }

  @override
  String syncUiHoursAgo(int hours) {
    return 'il y a $hours h';
  }

  @override
  String syncUiDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get syncUiThisDevice => 'Cet appareil';

  @override
  String get syncUiAnotherDevice => 'Un autre appareil';

  @override
  String syncUiAdded(String when) {
    return 'Ajouté : $when';
  }

  @override
  String syncUiThisDeviceNamed(String name) {
    return 'Cet appareil ($name)';
  }

  @override
  String syncUiLastSyncedAgo(String when) {
    return 'Dernière synchronisation : $when';
  }

  @override
  String get syncUiWhere => 'Où vos appareils doivent-ils se synchroniser ?';

  @override
  String get syncUiICloudHelp =>
      'Pour iPhone, iPad et Mac uniquement. Utilise votre propre iCloud Drive.';

  @override
  String get syncUiRelay => 'Relais Tanooki';

  @override
  String get syncUiRelayHelp =>
      'Fonctionne avec tous les appareils, Android et Windows compris. Le serveur ne stocke que des données chiffrées.';

  @override
  String get syncUiStartFreshTitle => 'Repartir de zéro ?';

  @override
  String get syncUiStartFreshBody =>
      'Si vous avez oublié la phrase secrète de vos autres appareils Apple, vous pouvez lancer une nouvelle synchronisation avec celle-ci. Vos autres appareils devront alors désactiver puis réactiver la synchronisation avec la nouvelle phrase.';

  @override
  String get syncUiStartFresh => 'Repartir de zéro';

  @override
  String get syncUiOn => 'La synchronisation est activée.';

  @override
  String get syncUiScanTitle => 'Scannez le code de synchronisation';

  @override
  String get syncUiScanWrong =>
      'Ce n\'est pas un code de synchronisation. Sur votre autre appareil, ouvrez Réglages, Synchronisation, Ajouter un appareil.';

  @override
  String get syncUiNowSyncing => 'Cet appareil est maintenant synchronisé.';

  @override
  String get syncUiPasteTitle => 'Collez le lien de synchronisation';

  @override
  String get syncUiPasteHint =>
      'tanookiauth://sync?…  (depuis Ajouter un appareil sur votre autre appareil)';

  @override
  String get syncUiAddApple => 'Ajouter un appareil Apple';

  @override
  String get syncUiAddAppleBody =>
      'Sur votre autre iPhone, iPad ou Mac (connecté au même identifiant Apple, avec iCloud Drive activé), ouvrez Tanooki Auth, allez dans Réglages puis Synchronisation, touchez « Activer la synchronisation », choisissez iCloud et saisissez la même phrase secrète.\n\nVous voulez ajouter un téléphone Android ou un PC Windows ? Désactivez la synchronisation sur tous les appareils, puis réactivez-la avec le relais Tanooki.';

  @override
  String get syncUiAddDevice => 'Ajouter un appareil';

  @override
  String get syncUiAddDeviceBody =>
      'Sur le nouvel appareil, ouvrez Tanooki Auth, allez dans Réglages puis Synchronisation, et touchez « Rejoindre depuis un autre appareil ». Scannez ce code, puis saisissez-y votre phrase secrète.';

  @override
  String get syncUiAddDeviceNote =>
      'Valable une fois, pendant 24 heures. Quelqu\'un qui n\'a que ce code ne peut rien lire sans votre phrase secrète.';

  @override
  String get syncUiLinkCopied =>
      'Lien copié. Collez-le sur le nouvel appareil.';

  @override
  String get syncUiCopyLink => 'Copier plutôt le lien';

  @override
  String get syncUiRemoveTitle =>
      'Retirer cet appareil de la synchronisation ?';

  @override
  String get syncUiRemoveBody =>
      'Il ne recevra plus les modifications. Si l\'appareil a été perdu ou volé, changez aussi votre phrase secrète : désactivez la synchronisation sur tous les appareils, puis réactivez-la avec une nouvelle phrase, car l\'appareil perdu connaît toujours l\'ancienne.';

  @override
  String get syncUiTurnOffTitle =>
      'Désactiver la synchronisation sur cet appareil ?';

  @override
  String get syncUiTurnOffBody =>
      'Vos comptes restent sur cet appareil. Il arrête simplement d\'envoyer et de recevoir des modifications. Vos autres appareils continuent de se synchroniser entre eux.';

  @override
  String get syncUiOff => 'La synchronisation est désactivée sur cet appareil.';

  @override
  String get syncUiPremium => 'La synchronisation fait partie de Premium';

  @override
  String syncUiPremiumBody(String payOnce) {
    return 'Ajoutez un compte sur un appareil et il apparaît sur tous, chiffré de bout en bout. $payOnce, sans abonnement.';
  }

  @override
  String get syncUiIntro =>
      'La synchronisation garde vos comptes identiques sur tous vos appareils. Avant de quitter cet appareil, tout est verrouillé avec votre phrase secrète : iCloud ou notre serveur ne stockent que des données chiffrées. Personne d\'autre ne peut les lire, nous compris.';

  @override
  String get syncUiTurnOn => 'Activer la synchronisation';

  @override
  String get syncUiJoin => 'Rejoindre depuis un autre appareil';

  @override
  String get syncUiJoinHelp =>
      'Utilisez « Rejoindre » quand un autre appareil se synchronise déjà avec le relais Tanooki.';

  @override
  String get syncUiSyncingRelay => 'Synchronisation avec le relais Tanooki';

  @override
  String get syncUiSyncingICloud => 'Synchronisation avec iCloud';

  @override
  String get syncUiSyncingNow => 'Synchronisation…';

  @override
  String syncUiSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments synchronisés sont illisibles',
      one: '1 élément synchronisé est illisible',
    );
    return '$_temp0';
  }

  @override
  String get syncUiSkippedHelp =>
      'Ils ont peut-être été modifiés par quelqu\'un d\'autre ou créés avec une autre phrase secrète. Rien n\'a été supprimé à cause d\'eux.';

  @override
  String get syncUiDevices => 'Appareils';

  @override
  String get syncUiLoading => 'Chargement…';

  @override
  String get syncUiAddDeviceRelay =>
      'Affiche un code à scanner sur le nouvel appareil';

  @override
  String get syncUiAddDeviceApple => 'Un autre iPhone, iPad ou Mac';

  @override
  String get syncUiTurnOffButton =>
      'Désactiver la synchronisation sur cet appareil';

  @override
  String get syncUiPassphraseNoteRelay =>
      'Votre phrase secrète ne peut pas être récupérée. Si vous l\'oubliez, désactivez la synchronisation sur tous les appareils et recommencez avec une nouvelle. Vos comptes ne bougent pas.';

  @override
  String get syncUiPassphraseNoteICloud =>
      'La synchronisation utilise votre iCloud Drive. Votre phrase secrète ne peut pas être récupérée ; si vous l\'oubliez, repartez de zéro avec une nouvelle. Vos comptes ne bougent pas.';

  @override
  String get syncUiTitle => 'Synchronisation';

  @override
  String get syncUiTooShort =>
      'Utilisez au moins 10 caractères. Quelques mots au hasard font très bien l\'affaire.';

  @override
  String get syncUiMismatch =>
      'Les deux phrases secrètes ne correspondent pas.';

  @override
  String get syncUiChoosePassphrase =>
      'Choisissez une phrase secrète de synchronisation';

  @override
  String get syncUiTypePassphrase =>
      'Saisissez votre phrase secrète de synchronisation';

  @override
  String get syncUiChooseHelp =>
      'Vous la saisirez une fois sur chaque appareil ajouté. Elle verrouille vos comptes avant qu\'ils quittent cet appareil.\n\nNotez-la en lieu sûr. Elle ne peut être ni récupérée ni réinitialisée, ni par vous ni par nous.';

  @override
  String get syncUiTypeHelp =>
      'La même phrase secrète que celle choisie en activant la synchronisation sur votre premier appareil.';

  @override
  String get syncUiPassphrase => 'Phrase secrète de synchronisation';

  @override
  String get syncUiTypeAgain => 'Saisissez-la à nouveau';

  @override
  String get syncUiSectionTitle => 'Synchronisation et téléphone';

  @override
  String get syncUiTitlePremium => 'Synchronisation (Premium)';

  @override
  String get syncUiOnRelay => 'Activée, avec le relais Tanooki';

  @override
  String get syncUiOnICloud => 'Activée, avec iCloud';

  @override
  String get syncUiOffHelp =>
      'Gardez vos comptes identiques sur tous vos appareils';

  @override
  String get syncUiBrowser => 'Utiliser avec un navigateur';

  @override
  String get syncUiBrowserPremium => 'Utiliser avec un navigateur (Premium)';

  @override
  String get syncUiBrowserHelp =>
      'Approuvez sur ce téléphone les codes d\'un navigateur sur n\'importe quel ordinateur';

  @override
  String get teamUiCreateTitle => 'Créez votre équipe';

  @override
  String get teamUiCreateHint =>
      'TT1.…  (sur la page affichée après l\'abonnement)';

  @override
  String get teamUiCreateButton => 'Créer l\'équipe';

  @override
  String get teamUiReady =>
      'Votre équipe est prête. Invitez des personnes avec « Inviter quelqu\'un ».';

  @override
  String get teamUiScanTitle => 'Scannez l\'invitation d\'équipe';

  @override
  String get teamUiScanWrong =>
      'Ce n\'est pas une invitation d\'équipe. Demandez à l\'admin d\'ouvrir Réglages, Coffre d\'équipe, Inviter quelqu\'un.';

  @override
  String get teamUiJoinTitle => 'Rejoindre une équipe';

  @override
  String get teamUiJoinHint =>
      'tanookiauth://team?…  (le lien d\'invitation de l\'admin)';

  @override
  String get teamUiJoinButton => 'Rejoindre';

  @override
  String get teamUiJoinedTeam =>
      'Vous faites partie de l\'équipe. Les comptes d\'équipe apparaîtront quand l\'app de l\'admin aura partagé la clé d\'équipe avec cet appareil.';

  @override
  String get teamUiInvite => 'Inviter quelqu\'un';

  @override
  String get teamUiInviteHelp =>
      'Sur son appareil : Réglages, Coffre d\'équipe, puis « Scanner un code QR d\'invitation » ou « Coller un lien d\'invitation ». L\'invitation sert une fois et dure 7 jours.';

  @override
  String get teamUiRemovePersonTitle => 'Retirer cette personne ?';

  @override
  String get teamUiRemovePersonBody =>
      'Elle perd l\'accès immédiatement, et l\'équipe reçoit une nouvelle clé : elle ne pourra rien lire de ce qui sera ajouté ou modifié désormais. Elle a pu garder des copies des codes qu\'elle voyait déjà, alors refaites la configuration de double authentification des comptes importants.';

  @override
  String get teamUiRemoved => 'Retiré. L\'équipe a une nouvelle clé.';

  @override
  String get teamUiDeleteTitle => 'Supprimer l\'équipe ?';

  @override
  String get teamUiLeaveTitle => 'Quitter l\'équipe ?';

  @override
  String get teamUiDeleteBody =>
      'Tous les comptes d\'équipe sont supprimés pour tous les membres. Les comptes personnels de chacun restent intacts.';

  @override
  String get teamUiLeaveBody =>
      'Les comptes de l\'équipe disparaissent de cet appareil. Vos propres comptes restent intacts.';

  @override
  String get teamUiDeleteButton => 'Supprimer l\'équipe';

  @override
  String get teamUiLeaveButton => 'Quitter';

  @override
  String get teamUiDeleted => 'Équipe supprimée.';

  @override
  String get teamUiLeft => 'Vous avez quitté l\'équipe.';

  @override
  String get teamUiAddFirst =>
      'Ajoutez d\'abord le compte à Tanooki Auth, puis copiez-le ici dans l\'équipe.';

  @override
  String get teamUiCopyInTitle => 'Copiez un de vos comptes dans l\'équipe';

  @override
  String teamUiCopiedIn(String name) {
    return '$name fait maintenant partie de l\'équipe. Votre copie reste où elle était.';
  }

  @override
  String get teamUiRenameTitle => 'Renommer le compte d\'équipe';

  @override
  String get teamUiRenameHint => 'Nom, ex. : AWS';

  @override
  String teamUiRemoveAccountTitle(String name) {
    return 'Retirer $name de l\'équipe ?';
  }

  @override
  String get teamUiRemoveAccountBody =>
      'Il disparaît pour tous les membres de l\'équipe.';

  @override
  String get teamUiIntro =>
      'Un coffre d\'équipe partage des codes de connexion avec jusqu\'à 10 personnes, pour 20 \$ par an. Tous les membres peuvent voir, ajouter et modifier les comptes d\'équipe. Ils sont chiffrés sur vos appareils avec une clé que seule l\'équipe possède, donc notre serveur ne peut pas les lire. Les comptes d\'équipe sont dans leur propre section Équipe et ne se mélangent jamais aux vôtres.';

  @override
  String get teamUiStart => 'Créer une équipe';

  @override
  String get teamUiBuy => 'Acheter une offre équipe — 20 \$ par an';

  @override
  String get teamUiPlanSoon => 'Offre équipe bientôt disponible';

  @override
  String get teamUiHaveLicense =>
      'J\'ai une licence d\'équipe : créer l\'équipe';

  @override
  String get teamUiJoinHelp =>
      'Demandez une invitation à l\'admin de l\'équipe. Rejoindre est gratuit.';

  @override
  String get teamUiScanInvite => 'Scanner un code QR d\'invitation';

  @override
  String get teamUiPasteInvite => 'Coller un lien d\'invitation';

  @override
  String get teamUiYouRun => 'Vous gérez cette équipe';

  @override
  String get teamUiYoureIn => 'Vous faites partie d\'une équipe';

  @override
  String teamUiPeopleCount(int count, int max) {
    return '$count personnes sur $max';
  }

  @override
  String teamUiLastSynced(String when) {
    return 'Dernière synchronisation : $when';
  }

  @override
  String teamUiPaidUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Payé jusqu\'au $dateString';
  }

  @override
  String get teamUiSyncNow => 'Synchroniser maintenant';

  @override
  String get teamUiWaitingForKey =>
      'En attente que l\'app de l\'admin partage la clé d\'équipe avec cet appareil. Cela se fera la prochaine fois que l\'admin ouvrira Tanooki Auth.';

  @override
  String get teamUiAccounts => 'Comptes d\'équipe';

  @override
  String get teamUiAddMine => 'Ajouter un des miens';

  @override
  String get teamUiNoAccounts => 'Pas encore de comptes d\'équipe.';

  @override
  String get teamUiChange => 'Modifier';

  @override
  String get teamUiRename => 'Renommer';

  @override
  String get teamUiRemoveFromTeam => 'Retirer de l\'équipe';

  @override
  String get teamUiPeople => 'Personnes';

  @override
  String get teamUiThisDevice => 'Cet appareil (admin)';

  @override
  String teamUiDevice(String id) {
    return 'Appareil $id';
  }

  @override
  String teamUiJoined(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'A rejoint le $dateString';
  }

  @override
  String teamUiJoinedGettingKey(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'A rejoint le $dateString · réception de la clé d\'équipe';
  }

  @override
  String get teamUiDeleteTeam => 'Supprimer l\'équipe';

  @override
  String get teamUiLeaveTeam => 'Quitter l\'équipe';

  @override
  String get teamUiTitle => 'Coffre d\'équipe';

  @override
  String teamUiCopiedCode(String name) {
    return 'Code $name copié. Le presse-papiers sera vidé dans 30 secondes.';
  }

  @override
  String teamUiSection(int count) {
    return 'Équipe · $count';
  }

  @override
  String get teamUiWaitingShort =>
      'En attente que l\'admin partage la clé d\'équipe avec cet appareil.';

  @override
  String get teamUiNoAccountsHint =>
      'Pas encore de comptes d\'équipe. Ajoutez-les dans Réglages, Coffre d\'équipe.';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

  @override
  String get themePink => 'Rose pastel';

  @override
  String get themeBlue => 'Bleu pastel';

  @override
  String get themeLavender => 'Lavande';

  @override
  String get themeMint => 'Menthe';

  @override
  String get themeMidnight => 'Minuit';

  @override
  String get themeSunset => 'Coucher de soleil';

  @override
  String get themePeach => 'Pêche';

  @override
  String get themeForest => 'Forêt';

  @override
  String get themeOcean => 'Océan';

  @override
  String get themeMono => 'Mono';

  @override
  String get tidyNoName => '(sans nom)';

  @override
  String tidyDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count noms rangés.',
      one: '1 nom rangé.',
    );
    return '$_temp0';
  }

  @override
  String get tidyTitle => 'Ranger les noms de comptes';

  @override
  String get tidyNothing => 'Tous vos noms de comptes sont déjà rangés.';

  @override
  String get tidyIntro =>
      'Ces noms contiennent des adresses de sites ou des éléments en trop. Décochez ceux que vous voulez garder tels quels, puis touchez Appliquer. Vos codes ne changent pas.';

  @override
  String tidyWas(String name) {
    return 'Avant : $name';
  }

  @override
  String get tidyNothingTicked => 'Rien de coché';

  @override
  String tidyApply(int count) {
    return 'Appliquer $count';
  }

  @override
  String get emergencyNotContactCode =>
      'Ce n\'est pas un code de contact Tanooki Auth. Demandez-lui d\'ouvrir Tanooki Auth, d\'aller dans Réglages > Accès d\'urgence et de partager son code de contact.';

  @override
  String get emergencyCopyWontOpen =>
      'Impossible d\'ouvrir la copie d\'urgence avec la clé de cet appareil. Elle a été faite pour un autre appareil, ou elle est endommagée.';

  @override
  String get emergencyGone =>
      'Cette copie d\'urgence n\'existe plus. Son propriétaire l\'a supprimée.';

  @override
  String get emergencyWaitNotOver =>
      'Le délai de 7 jours n\'est pas encore écoulé.';

  @override
  String get emergencyNotOwnerOrContact =>
      'Cet appareil n\'est ni le propriétaire ni le contact de cette copie d\'urgence.';

  @override
  String get emergencyNoRequestToDeny => 'Il n\'y a plus de demande à refuser.';

  @override
  String get emergencyAskFirst => 'Demandez d\'abord l\'accès.';

  @override
  String get emergencyTooBig =>
      'Vos comptes sont trop volumineux pour une copie d\'urgence (la limite est d\'environ 500 Ko).';

  @override
  String get emergencyTooManyTries =>
      'Trop d\'essais en une minute. Attendez une minute et réessayez.';

  @override
  String emergencyServerSaidNo(String status) {
    return 'Le serveur de synchronisation a refusé (HTTP $status).';
  }

  @override
  String emergencyServerSaidNoWhy(String status, String reason) {
    return 'Le serveur de synchronisation a refusé (HTTP $status : $reason).';
  }

  @override
  String get emergencyNotEmergencyCode =>
      'Ce n\'est pas un code d\'urgence Tanooki Auth. Demandez à la personne qui vous a choisi de le renvoyer depuis Réglages > Accès d\'urgence.';

  @override
  String get emergencyLessThanMinute => 'moins d\'une minute';

  @override
  String emergencyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String emergencyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures',
      one: '1 heure',
    );
    return '$_temp0';
  }

  @override
  String emergencyMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String emergencyDaysHours(int days, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '1 jour',
    );
    String _temp1 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours heures',
      one: '1 heure',
    );
    return '$_temp0 et $_temp1';
  }

  @override
  String get emergencyUiExplainer =>
      'Choisissez une personne de confiance. S\'il vous arrive quelque chose, elle pourra demander vos comptes. Vos appareils reçoivent une notification et vous avez 7 jours pour refuser. Si personne ne refuse, elle reçoit une copie.\n\nLe serveur Tanooki Auth ne fait qu\'appliquer le délai de 7 jours. La copie est verrouillée avec une clé que seul son appareil possède : le serveur ne peut pas la lire, ni quiconque parviendrait à s\'y introduire.';

  @override
  String emergencyUiPushNotWorking(String reason) {
    return 'Les notifications ne fonctionnent pas encore ($reason). Tanooki Auth vérifie les demandes à chaque ouverture.';
  }

  @override
  String get emergencyUiScanTheirQr => 'Scanner son code QR';

  @override
  String get emergencyUiPasteCode => 'Coller un code reçu';

  @override
  String get emergencyUiWrongCode => 'Ce n\'est pas le bon code.';

  @override
  String get emergencyUiCopiedCode =>
      'Copié. Envoyez-le comme vous voulez : il ne contient aucun secret.';

  @override
  String get emergencyUiCopyAsText => 'Copier en texte';

  @override
  String get emergencyUiTheirContactCode => 'Son code de contact';

  @override
  String get emergencyUiNotContactCodeShort =>
      'Ce n\'est pas un code de contact Tanooki Auth.';

  @override
  String get emergencyUiMakeThemContact =>
      'En faire votre contact d\'urgence ?';

  @override
  String emergencyUiMakeNamedContact(String name) {
    return 'Faire de $name votre contact d\'urgence ?';
  }

  @override
  String get emergencyUiCopyLeftOnServer =>
      'Une copie de tous vos comptes est verrouillée pour son appareil et déposée sur le serveur Tanooki Auth. Elle se met à jour quand vous modifiez vos comptes.';

  @override
  String get emergencyUiYourNameWhose =>
      'Votre nom (pour qu\'il sache à qui est la copie)';

  @override
  String get emergencyUiDoneGiveCode =>
      'C\'est fait. Donnez-lui maintenant le code affiché ici.';

  @override
  String get emergencyUiStopTitle => 'Arrêter l\'accès d\'urgence ?';

  @override
  String get emergencyUiStopBody =>
      'La copie est supprimée du serveur et la personne ne peut plus la demander.';

  @override
  String get emergencyUiChooseContact => 'Choisir un contact d\'urgence';

  @override
  String get emergencyUiChooseContactPremium =>
      'Choisir un contact d\'urgence (Premium)';

  @override
  String get emergencyUiChooseContactHow =>
      'La personne ouvre Tanooki Auth sur son appareil, va dans Réglages > Accès d\'urgence et vous montre son code de contact.';

  @override
  String get emergencyUiYourContact => 'Votre contact';

  @override
  String get emergencyUiChecking => 'Vérification auprès du serveur…';

  @override
  String get emergencyUiIdleJustNow =>
      'Personne n\'a rien demandé. Copie mise à jour à l\'instant.';

  @override
  String emergencyUiIdleUpdated(String day) {
    return 'Personne n\'a rien demandé. Copie mise à jour pour la dernière fois : $day.';
  }

  @override
  String emergencyUiWaiting(String who, String day, String left) {
    return '$who a fait la demande le $day. La copie pourra être ouverte dans $left, sauf si vous refusez.';
  }

  @override
  String emergencyUiReleased(String who) {
    return '$who a fait la demande et le délai est écoulé : la copie peut être ouverte maintenant. Refusez pour l\'en empêcher.';
  }

  @override
  String emergencyUiContactIs(String who) {
    return 'Contact d\'urgence : $who';
  }

  @override
  String get emergencyUiDenied =>
      'Refusé. La personne ne peut pas ouvrir vos comptes. Elle pourra redemander plus tard.';

  @override
  String get emergencyUiCopyUpdated => 'Copie mise à jour.';

  @override
  String get emergencyUiCouldntUpdate =>
      'Impossible de mettre à jour la copie.';

  @override
  String get emergencyUiUpdateNow => 'Mettre à jour la copie';

  @override
  String emergencyUiGiveCode(String who) {
    return 'Donnez ce code à $who. Dans Tanooki Auth, il faut aller dans Réglages > Accès d\'urgence > « Ajouter un code reçu ».';
  }

  @override
  String get emergencyUiCodeTheyGave => 'Code reçu';

  @override
  String get emergencyUiNotEmergencyCodeShort =>
      'Ce n\'est pas un code d\'urgence Tanooki Auth.';

  @override
  String get emergencyUiAddedTheir =>
      'Ajouté. Si un jour vous en avez besoin, vous pourrez demander ses comptes ici.';

  @override
  String emergencyUiAddedNamed(String name) {
    return 'Ajouté. Si un jour vous en avez besoin, vous pourrez demander les comptes de $name ici.';
  }

  @override
  String get emergencyUiTheOwner => 'le propriétaire';

  @override
  String get emergencyUiAskTitle => 'Demander l\'accès d\'urgence ?';

  @override
  String emergencyUiAskBody(String who) {
    return '$who reçoit une notification et a 7 jours pour refuser. Sinon, vous pourrez ouvrir ici une copie de ses comptes. Ne demandez que si vous en avez vraiment besoin.';
  }

  @override
  String get emergencyUiAsk => 'Demander';

  @override
  String get emergencyUiAsked =>
      'Demande envoyée. Le délai de 7 jours a commencé.';

  @override
  String emergencyUiAddTheirAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter ses $count comptes ?',
      one: 'Ajouter son compte ?',
    );
    return '$_temp0';
  }

  @override
  String emergencyUiAddNamedAccounts(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter les $count comptes de $name ?',
      one: 'Ajouter le compte de $name ?',
    );
    return '$_temp0';
  }

  @override
  String get emergencyUiSomeone => 'Quelqu\'un';

  @override
  String get emergencyUiCheckingShort => 'Vérification…';

  @override
  String get emergencyUiNotAsked => 'Vous n\'avez rien demandé.';

  @override
  String get emergencyUiRequestAccess => 'Demander l\'accès';

  @override
  String emergencyUiOpensIn(String left, String day) {
    return 'Demande envoyée. Ouverture dans $left ($day), sauf refus.';
  }

  @override
  String get emergencyUiWaitOver => 'Le délai est écoulé.';

  @override
  String get emergencyUiOpenCopy => 'Ouvrir la copie d\'urgence';

  @override
  String emergencyUiPersonAccounts(String who) {
    return 'Comptes de $who';
  }

  @override
  String get emergencyUiYourContactCode => 'Votre code de contact';

  @override
  String get emergencyUiShowThis =>
      'Si quelqu\'un veut faire de vous son contact d\'urgence, montrez-lui ceci. Il ne contient aucun secret.';

  @override
  String get emergencyUiYourNameItsYou =>
      'Votre nom (pour qu\'on sache que c\'est vous)';

  @override
  String get emergencyUiShowMyCode => 'Afficher mon code de contact';

  @override
  String get emergencyUiLetThemScan =>
      'Faites-le scanner dans Tanooki Auth, ou copiez-le et envoyez-le.';

  @override
  String get emergencyUiAddCodeGiven => 'Ajouter un code reçu';

  @override
  String get emergencyUiAddCodeGivenHow =>
      'Après vous avoir choisi, son app affiche un code pour vous';

  @override
  String get emergencyUiTitle => 'Accès d\'urgence';

  @override
  String get emergencyUiYourEmergencyContact => 'Votre contact d\'urgence';

  @override
  String get emergencyUiPeopleWhoChoseYou => 'Personnes qui vous ont choisi';

  @override
  String get securityUiProofWindows => 'Windows Hello';

  @override
  String get securityUiProofMac => 'Touch ID ou votre mot de passe';

  @override
  String get securityUiProofIos => 'Face ID ou code';

  @override
  String get securityUiProofOther => 'empreinte ou code PIN';

  @override
  String securityUiPasscodeAtLeast(int count) {
    return 'Code (au moins $count chiffres)';
  }

  @override
  String get securityUiTypeAgain => 'Retapez-le';

  @override
  String get securityUiPasscodesDontMatch =>
      'Les deux codes ne correspondent pas.';

  @override
  String get securityUiPickDifferent =>
      'Choisissez un code différent de l\'autre.';

  @override
  String get securityUiEnterPasscode => 'Saisissez le code de l\'app';

  @override
  String get securityUiPasscode => 'Code';

  @override
  String get securityUiWrongPasscode => 'Ce n\'est pas votre code.';

  @override
  String get securityUiCheckupTitle => 'Bilan de sécurité';

  @override
  String get securityUiAllGood => 'Tout va bien';

  @override
  String get securityUiAllGoodBody =>
      'L\'app est verrouillée, vous avez une sauvegarde récente et chaque compte a ses codes de récupération.';

  @override
  String get securityUiLockOffTitle => 'L\'app n\'est pas verrouillée';

  @override
  String get securityUiLockOffBody =>
      'Quiconque prend votre appareil déverrouillé peut voir vos codes. Activez « Verrouiller l\'app » ou un code d\'app dans les Réglages.';

  @override
  String get securityUiNoPasscodeTitle => 'Pas de code d\'app';

  @override
  String get securityUiNoPasscodeBody =>
      'Un code vous permet d\'ouvrir Tanooki Auth même si Face ID ou votre empreinte ne fonctionne plus. Définissez-en un dans les Réglages.';

  @override
  String get securityUiAutoBackupFailed => 'La sauvegarde automatique a échoué';

  @override
  String get securityUiOpenAutoBackups => 'Ouvrir les sauvegardes automatiques';

  @override
  String get securityUiNoBackupTitle => 'Aucune sauvegarde depuis 30 jours';

  @override
  String get securityUiNoBackupBody =>
      'Si cet appareil est perdu ou cassé, une sauvegarde est le seul moyen de récupérer vos comptes.';

  @override
  String get securityUiMakeBackupNow => 'Faire une sauvegarde';

  @override
  String securityUiNoRecoveryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes n\'ont pas de codes de récupération',
      one: '1 compte n\'a pas de codes de récupération',
    );
    return '$_temp0';
  }

  @override
  String securityUiNoRecoveryBody(String names) {
    return 'Les codes de récupération vous permettent d\'accéder à un site si vous perdez cette app. Trouvez-les dans les réglages de sécurité de chaque site, puis ajoutez-les avec ⋯ > Codes de récupération sur le compte.\n\n$names';
  }

  @override
  String get securityUiRecoveryKit => 'Votre kit de récupération';

  @override
  String get securityUiRecoveryKitSub =>
      'Sauvegarde, codes de récupération et copie papier, étape par étape';

  @override
  String securityUiBreachSnack(String sites) {
    return '$sites a subi une fuite de données. Changez votre mot de passe sur ce site.';
  }

  @override
  String get securityUiBreachDownloadFailed =>
      'Impossible de télécharger la liste des fuites. Vérifiez votre connexion internet et réessayez.';

  @override
  String get securityUiBreachAlerts => 'Alertes de fuites';

  @override
  String get securityUiBreachAlertsPremium => 'Alertes de fuites (Premium)';

  @override
  String get securityUiBreachAlertsSub =>
      'Une fois par semaine, vous prévient si un site que vous utilisez a subi une fuite';

  @override
  String get securityUiBreachHow =>
      'Comment ça marche : Tanooki Auth télécharge la liste publique des fuites connues sur haveibeenpwned.com et la compare, sur cet appareil, avec vos sites enregistrés. Rien sur vous ou vos comptes n\'est envoyé : c\'est le même téléchargement pour tout le monde. C\'est la seule fois où l\'app va sur internet, à part la synchronisation et l\'achat de Premium.';

  @override
  String securityUiNoWebsite(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count de vos comptes n\'ont pas de site enregistré, ils ne peuvent donc pas être vérifiés. Ajoutez-en un avec ⋯ > Modifier.',
      one: '1 de vos comptes n\'a pas de site enregistré, il ne peut donc pas être vérifié. Ajoutez-en un avec ⋯ > Modifier.',
    );
    return '$_temp0';
  }

  @override
  String get securityUiCheckNow => 'Vérifier maintenant';

  @override
  String get securityUiNoBreaches =>
      'Aucune fuite connue pour vos sites enregistrés.';

  @override
  String get securityUiBreached =>
      'Fuite. Si vous avez créé votre mot de passe avant, changez-le sur ce site.';

  @override
  String securityUiBreachedOn(String date) {
    return 'Fuite le $date. Si vous avez créé votre mot de passe avant, changez-le sur ce site.';
  }

  @override
  String securityUiBreachedLeaked(String data) {
    return 'Fuite. Données exposées : $data. Si vous avez créé votre mot de passe avant, changez-le sur ce site.';
  }

  @override
  String securityUiBreachedOnLeaked(String date, String data) {
    return 'Fuite le $date. Données exposées : $data. Si vous avez créé votre mot de passe avant, changez-le sur ce site.';
  }

  @override
  String get securityUiKitIntro =>
      'Si vous perdez cet appareil, voici comment retrouver l\'accès à vos comptes. Chaque étape prend une minute. Si vous n\'avez encore ajouté aucun compte, ajoutez-les d\'abord, puis revenez ici depuis Réglages > Bilan de sécurité.';

  @override
  String get securityUiKitBackupTitle => 'Faites une sauvegarde';

  @override
  String get securityUiKitBackupBody =>
      'Un fichier chiffré, protégé par une phrase secrète de votre choix. Gardez-le ailleurs que sur cet appareil, par exemple sur iCloud Drive, Google Drive ou une clé USB.';

  @override
  String get securityUiKitBackupButton => 'Faire une sauvegarde';

  @override
  String get securityUiKitCodesTitle => 'Enregistrez vos codes de récupération';

  @override
  String get securityUiKitCodesBody =>
      'Quand vous activez la connexion en deux étapes, la plupart des sites vous donnent une liste de codes de récupération à usage unique. Ajoutez-les à chaque compte avec ⋯ > Codes de récupération, pour qu\'ils soient aussi dans votre sauvegarde.';

  @override
  String get securityUiKitPaperTitle => 'Imprimez une sauvegarde papier';

  @override
  String get securityUiKitPaperBody =>
      'Facultatif. Une page imprimée de codes QR fonctionne même si tous vos appareils ont disparu. Gardez-la sous clé : quiconque l\'a peut générer vos codes.';

  @override
  String get securityUiKitPaperButton => 'Imprimer la sauvegarde papier';

  @override
  String get securityUiSkipForNow => 'Plus tard';

  @override
  String get securityExtrasPrivacy =>
      'Pas de compte, pas de pistage. Vos clés de configuration sont stockées chiffrées sur cet appareil. L\'app ne va en ligne que pour : vérifier l\'heure (elle demande l\'heure au serveur Tanooki Auth, au plus une fois par heure quand des codes sont affichés et quand vous touchez « Les codes ne marchent pas ? » ; rien sur vous ou vos comptes n\'est envoyé), les alertes de fuites si vous les activez (téléchargement de la liste publique des fuites), la synchronisation, le lien avec le téléphone et l\'accès d\'urgence si vous les configurez (ils ne transportent que des données chiffrées illisibles pour le serveur), l\'achat de Premium, et les retours que vous choisissez d\'envoyer (votre message, votre e-mail si vous en saisissez un, ainsi que la version de l\'app et le type d\'appareil si vous laissez cette case cochée ; jamais vos comptes, vos codes ni rien d\'autre dans l\'app). Les guides 2FA s\'ouvrent dans votre navigateur.';

  @override
  String get securityExtrasMonthlyBody =>
      'Votre bilan de sécurité mensuel est prêt. Ouvrez Tanooki Auth pour le consulter.';

  @override
  String get securityExtrasNotificationsOffIos =>
      'Les notifications sont désactivées pour Tanooki Auth. Activez-les dans l\'app Réglages de l\'iPhone, sous Notifications, puis réessayez.';

  @override
  String get securityExtrasNotificationsOffMac =>
      'Les notifications sont désactivées pour Tanooki Auth. Activez-les dans Réglages Système, sous Notifications, puis réessayez.';

  @override
  String securityExtrasReminderFailed(String reason) {
    return 'Impossible de programmer le rappel ($reason).';
  }

  @override
  String get securityExtrasRemindersUnavailable =>
      'Les rappels ne sont pas encore disponibles sur cet appareil.';

  @override
  String securityExtrasDayTime(String day, String time) {
    return '$day, $time';
  }

  @override
  String get securityExtrasClearTitle => 'Effacer l\'historique d\'activité ?';

  @override
  String get securityExtrasClearBody =>
      'Toutes les entrées sont supprimées de cet appareil. Vos comptes ne sont pas touchés.';

  @override
  String get securityExtrasActivityTitle => 'Historique d\'activité';

  @override
  String securityExtrasActivityPitch(int count) {
    return 'L\'historique d\'activité fait partie de Premium. Il garde les $count dernières fois où un code a été copié, rempli sur un site, tapé, affiché en code QR ou exporté, sur cet appareil uniquement.';
  }

  @override
  String get securityExtrasNothingYet =>
      'Rien pour l\'instant. Les copies, remplissages, saisies, affichages de QR code et exports apparaîtront ici.';

  @override
  String get securityExtrasAllAccounts => 'Tous les comptes';

  @override
  String get securityExtrasDeletedAccount => 'Un compte supprimé';

  @override
  String securityExtrasActivityLine(String kind, String what) {
    return '$kind : $what';
  }

  @override
  String get securityExtrasGetPremium => 'Obtenir Premium';

  @override
  String get securityExtrasAddKey => 'Ajouter une clé de sécurité';

  @override
  String get securityExtrasAddKeyPremium =>
      'Ajouter une clé de sécurité (Premium)';

  @override
  String get securityExtrasAddKeyIos =>
      'Ensuite, quand on vous le demande, approchez la clé du haut de votre iPhone ou branchez-la. Il faudra peut-être la toucher deux fois.';

  @override
  String get securityExtrasAddKeyOther =>
      'Ensuite, branchez la clé et touchez-la quand elle clignote. Il faudra peut-être la toucher deux fois et saisir son code PIN si elle en a un.';

  @override
  String get securityExtrasKeyName => 'Nom (pour distinguer vos clés)';

  @override
  String securityExtrasKeyAdded(String name) {
    return '« $name » ajoutée. Vous pouvez maintenant déverrouiller Tanooki Auth avec elle sur cet appareil.';
  }

  @override
  String securityExtrasKeyRemoved(String name) {
    return '« $name » retirée. Elle ne peut plus déverrouiller Tanooki Auth.';
  }

  @override
  String get securityExtrasKeysTitle => 'Clés de sécurité';

  @override
  String securityExtrasKeysIntro(String usual) {
    return 'Une clé de sécurité (comme une YubiKey) peut déverrouiller Tanooki Auth à la place de $usual. La clé contient un secret qui ne la quitte jamais, et l\'app s\'en sert pour protéger la clé de vos comptes. Si vous perdez la clé, vous pouvez toujours déverrouiller comme d\'habitude.';
  }

  @override
  String securityExtrasKeyAddedOn(String day) {
    return 'Ajoutée $day';
  }

  @override
  String get securityExtrasLockOffNote =>
      'Le verrouillage est désactivé, l\'app s\'ouvre donc sans rien demander. Activez « Verrouiller l\'app » ou un code dans les Réglages pour utiliser votre clé.';

  @override
  String get securityExtrasLockWordWindows => 'Windows Hello ou votre code';

  @override
  String get securityExtrasLockWordMac => 'Touch ID ou votre code';

  @override
  String get securityExtrasLockWordOther => 'Face ID ou votre code';

  @override
  String get securityLockImmediately => 'Immédiatement';

  @override
  String get securityLockAfter30s => 'Après 30 secondes';

  @override
  String get securityLockAfter1m => 'Après 1 minute';

  @override
  String get securityLockAfter5m => 'Après 5 minutes';

  @override
  String get securityNumbersOnly => 'Utilisez uniquement des chiffres.';

  @override
  String securityAtLeastNumbers(int count) {
    return 'Utilisez au moins $count chiffres.';
  }

  @override
  String get securitySameNumber =>
      'N\'utilisez pas le même chiffre encore et encore.';

  @override
  String get securityNumbersInRow =>
      'N\'utilisez pas des chiffres qui se suivent comme 123456.';

  @override
  String get securityPanicNeedsPasscode =>
      'Définissez d\'abord un code d\'app. L\'effacement d\'urgence compte les codes erronés.';

  @override
  String get securityPanicNeedsBackup =>
      'Faites d\'abord une sauvegarde (Réglages > Exporter une sauvegarde). L\'effacement d\'urgence supprime tous les comptes, il ne s\'active donc que si vous avez fait une sauvegarde ces 30 derniers jours.';

  @override
  String get securityKeyDefaultName => 'Clé de sécurité';

  @override
  String get securityKeyNotYours =>
      'Cette clé de sécurité ne fait pas partie de celles ajoutées à Tanooki Auth sur cet appareil.';

  @override
  String get securityKeyNotAvailable =>
      'Pas encore disponible sur cet appareil.';

  @override
  String get securityKeyWindowsTooOld =>
      'Pas encore disponible sur cette version de Windows. Installez les dernières mises à jour de Windows 11.';

  @override
  String get securityKeyIosTooOld =>
      'Nécessite iOS 26.4 ou plus récent. Mettez à jour dans l\'app Réglages, puis réessayez.';

  @override
  String get securityKeyMacTooOld =>
      'Nécessite macOS 26.4 ou plus récent. Mettez à jour dans l\'app Réglages, puis réessayez.';

  @override
  String get securityKeyDidntWork =>
      'La clé de sécurité n\'a pas fonctionné. Réessayez.';

  @override
  String securityKeyDidntWorkWhy(String reason) {
    return 'La clé de sécurité n\'a pas fonctionné ($reason). Réessayez.';
  }

  @override
  String get securityKeyCanceled => 'Annulé. Rien n\'a changé.';

  @override
  String get securityKeyNoPrf =>
      'Cette clé de sécurité ne peut pas déverrouiller d\'apps de cette façon (elle n\'a pas la fonction « hmac-secret »). La série YubiKey 5 et la plupart des clés FIDO2 récentes l\'ont.';

  @override
  String get securityKeyNotAllowed =>
      'La clé de sécurité n\'a pas répondu, ou elle n\'a pas été ajoutée ici. Branchez-la (ou approchez-la du haut de votre téléphone) et touchez-la quand elle clignote.';

  @override
  String get securityKeyNotAssociated =>
      'Cette copie de Tanooki Auth n\'a pas encore le droit d\'utiliser des clés de sécurité : Apple exige d\'abord que l\'app soit liée à auth.tanookistudios.com. C\'est de notre côté, pas du vôtre.';

  @override
  String get securityKeyExists => 'Cette clé de sécurité est déjà ajoutée.';

  @override
  String get securityKeyPin =>
      'La clé de sécurité a besoin de son code PIN, qui n\'a pas été saisi. Réessayez et tapez le code PIN de la clé quand on vous le demande.';

  @override
  String get securityKeyVaultKeyMissing =>
      'La clé qui déverrouille vos comptes est introuvable, impossible donc d\'ajouter une clé de sécurité.';

  @override
  String get securityKeyNoneAdded =>
      'Aucune clé de sécurité n\'est ajoutée sur cet appareil.';

  @override
  String get securityKeyBeforeReset =>
      'Cette clé de sécurité a été ajoutée avant la réinitialisation de vos comptes, elle ne peut donc pas les ouvrir. Retirez-la puis ajoutez-la de nouveau.';

  @override
  String get backupUiChoosePassphrase =>
      'Choisissez une phrase secrète pour la sauvegarde';

  @override
  String get backupUiPassphraseTitle => 'Phrase secrète de la sauvegarde';

  @override
  String get backupUiPassphraseWarning =>
      'Vous en aurez besoin pour restaurer la sauvegarde. Personne, pas même nous, ne peut la retrouver si vous l\'oubliez. Notez-la en lieu sûr.';

  @override
  String get backupUiPassphrase => 'Phrase secrète';

  @override
  String get backupUiTypeAgain => 'Retapez-la';

  @override
  String get backupUiTooShort =>
      'Utilisez au moins 8 caractères. Quelques mots au hasard font très bien l\'affaire.';

  @override
  String get backupUiNoMatch =>
      'Les deux phrases secrètes ne correspondent pas.';

  @override
  String get backupUiTypePassphrase => 'Tapez la phrase secrète.';

  @override
  String get backupUiNothingToBackUp =>
      'Il n\'y a encore aucun compte à sauvegarder.';

  @override
  String get backupUiEncrypting => 'Chiffrement de la sauvegarde…';

  @override
  String backupUiSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sauvegarde de $count comptes enregistrée.',
      one: 'Sauvegarde de 1 compte enregistrée.',
    );
    return '$_temp0';
  }

  @override
  String get backupUiNotABackup =>
      'Ce fichier n\'est pas une sauvegarde Tanooki Auth.';

  @override
  String get backupUiUnlocking => 'Déverrouillage de la sauvegarde…';

  @override
  String backupUiImported(int count) {
    return '$count importé(s).';
  }

  @override
  String backupUiImportedSkipped(int added, int skipped) {
    return '$added importé(s), $skipped ignoré(s).';
  }

  @override
  String backupUiImportedSkippedAlready(int added, int skipped) {
    return '$added importé(s), $skipped ignoré(s) car déjà dans votre liste.';
  }

  @override
  String backupUiAdded(int count) {
    return '$count ajouté(s).';
  }

  @override
  String backupUiAddedSkipped(int added, int skipped) {
    return '$added ajouté(s), $skipped ignoré(s).';
  }

  @override
  String backupUiAddedSkippedAlready(int added, int skipped) {
    return '$added ajouté(s), $skipped ignoré(s) car déjà dans votre liste.';
  }

  @override
  String backupUiAlreadyInList(int count) {
    return '• $count déjà dans votre liste';
  }

  @override
  String get backupUiImport => 'Importer';

  @override
  String backupUiImportFromGoogle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importer $count comptes depuis Google Authenticator ?',
      one: 'Importer 1 compte depuis Google Authenticator ?',
    );
    return '$_temp0';
  }

  @override
  String get backupUiGoogleMoreCodes =>
      'Si Google Authenticator a affiché plusieurs codes QR, scannez-les tous.';

  @override
  String get backupUiNothingToExport =>
      'Il n\'y a encore aucun compte à exporter.';

  @override
  String get backupUiPlainWhat =>
      'Cela enregistre chaque clé de configuration en texte clair, pour passer à une autre app d\'authentification.';

  @override
  String get backupUiPlainTitle => 'Exporter sans chiffrement ?';

  @override
  String backupUiPlainBody(String what) {
    return '$what Quiconque obtient ce fichier peut générer vos codes de connexion. Importez-le, puis supprimez-le aussitôt. Pour une sauvegarde normale, utilisez plutôt « Exporter une sauvegarde ».';
  }

  @override
  String get backupUiUnderstandExport => 'J\'ai compris, exporter';

  @override
  String get backupUiNothingToPrint =>
      'Il n\'y a encore aucun compte à imprimer.';

  @override
  String get backupUiPaperTitle => 'Imprimer une sauvegarde papier ?';

  @override
  String get backupUiPaperBody =>
      'Cela crée un PDF avec un code QR pour chaque compte, plus vos codes de récupération inutilisés. Quiconque voit ou photographie ce papier peut générer vos codes de connexion, pour toujours, sans votre téléphone ni votre mot de passe.\n\nImprimez-le, puis supprimez le PDF. Rangez le papier sous clé, par exemple dans un coffre ou avec vos documents importants. Ne l\'envoyez pas par e-mail et ne l\'enregistrez pas dans un dossier partagé.';

  @override
  String get backupUiUnderstandPdf => 'J\'ai compris, créer le PDF';

  @override
  String get backupUiMakingPdf => 'Création du PDF…';

  @override
  String get backupUiPdfReady =>
      'PDF prêt. Imprimez-le, puis supprimez le fichier.';

  @override
  String get backupUiWorksTitle => 'La sauvegarde fonctionne';

  @override
  String backupUiWorksBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Cette sauvegarde s\'ouvre bien et contient $count comptes. Rien n\'a été ajouté ni modifié.',
      one: 'Cette sauvegarde s\'ouvre bien et contient 1 compte. Rien n\'a été ajouté ni modifié.',
    );
    return '$_temp0';
  }

  @override
  String get backupWrongVersion =>
      'Cette sauvegarde a été faite avec une version plus récente de Tanooki Auth. Mettez l\'app à jour et réessayez.';

  @override
  String get backupWrongPassphrase =>
      'Phrase secrète incorrecte, ou le fichier de sauvegarde est endommagé.';

  @override
  String get backupDamaged =>
      'La sauvegarde s\'est déverrouillée, mais son contenu est endommagé.';

  @override
  String get paperBackupTitle => 'Sauvegarde papier Tanooki Auth';

  @override
  String paperBackupHeader(String date) {
    return 'Sauvegarde papier Tanooki Auth, $date';
  }

  @override
  String get paperBackupWarning =>
      'GARDEZ CECI SECRET. Quiconque a ce papier peut générer vos codes de connexion. Rangez-le sous clé ; détruisez-le quand vous en faites un nouveau. Pour restaurer : dans n\'importe quelle app d\'authentification, choisissez « Scanner un code QR » et scannez chaque code ci-dessous.';

  @override
  String paperBackupSetupKey(String key) {
    return 'Clé de configuration : $key';
  }

  @override
  String get paperBackupRecoveryCodes =>
      'Codes de récupération (chacun ne sert qu\'une fois) :';

  @override
  String get autoBackupUiChooseFolderDialog =>
      'Choisissez un dossier pour les sauvegardes automatiques';

  @override
  String autoBackupUiToday(String time) {
    return 'Aujourd\'hui à $time';
  }

  @override
  String autoBackupUiYesterday(String time) {
    return 'Hier à $time';
  }

  @override
  String autoBackupUiOnDay(String date, String time) {
    return '$date à $time';
  }

  @override
  String get autoBackupUiBackingUp => 'Sauvegarde en cours…';

  @override
  String autoBackupUiBackedUp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes sauvegardés.',
      one: '1 compte sauvegardé.',
    );
    return '$_temp0';
  }

  @override
  String get autoBackupUiCouldntUseFolder =>
      'Impossible d\'utiliser ce dossier.';

  @override
  String autoBackupUiCouldntUseFolderWhy(String reason) {
    return 'Impossible d\'utiliser ce dossier. $reason';
  }

  @override
  String get autoBackupUiTurnOffTitle =>
      'Désactiver les sauvegardes automatiques ?';

  @override
  String get autoBackupUiTurnOffBody =>
      'Les sauvegardes déjà dans le dossier y restent. La phrase secrète est oubliée : vous en choisirez une nouvelle si vous réactivez cette option.';

  @override
  String get autoBackupUiTitle => 'Sauvegardes automatiques';

  @override
  String get autoBackupUiTitlePremium => 'Sauvegardes automatiques (Premium)';

  @override
  String autoBackupUiIntro(int count) {
    return 'Une fois par jour, Tanooki Auth enregistre une sauvegarde chiffrée dans le dossier de votre choix. Choisissez votre dossier iCloud Drive, Google Drive ou Dropbox et vos sauvegardes seront aussi hors de cet appareil. Les $count plus récentes sont conservées ; les plus anciennes sont supprimées.\n\nRestaurez-en une avec Réglages > Importer une sauvegarde et votre phrase secrète.';
  }

  @override
  String get autoBackupUiLastFailed =>
      'La dernière sauvegarde automatique a échoué';

  @override
  String get autoBackupUiChooseFolder => 'Choisir un dossier';

  @override
  String get autoBackupUiBackupFolder => 'Dossier de sauvegarde';

  @override
  String get autoBackupUiNoBackupYet => 'Pas encore de sauvegarde';

  @override
  String autoBackupUiLastBackup(String when) {
    return 'Dernière sauvegarde : $when';
  }

  @override
  String get autoBackupUiBackUpNow => 'Sauvegarder maintenant';

  @override
  String get autoBackupUiChangeFolder => 'Changer de dossier';

  @override
  String get autoBackupUiOffSubtitle =>
      'Désactivé. Une sauvegarde chiffrée quotidienne vers iCloud Drive, Google Drive, Dropbox ou n\'importe quel dossier.';

  @override
  String autoBackupUiOnNoBackup(String folder) {
    return 'Activé, vers $folder. Pas encore de sauvegarde.';
  }

  @override
  String autoBackupUiOnLast(String folder, String when) {
    return 'Activé, vers $folder. Dernière sauvegarde : $when.';
  }

  @override
  String get autoBackupFolderGone =>
      'Le dossier de sauvegarde a disparu. Il a peut-être été supprimé, renommé en dehors de l\'app, ou son disque est débranché. Choisissez de nouveau le dossier.';

  @override
  String get autoBackupPermissionLost =>
      'Tanooki Auth n\'a plus le droit d\'écrire dans le dossier de sauvegarde. Choisissez de nouveau le dossier pour lui redonner l\'autorisation.';

  @override
  String get autoBackupDiskFull =>
      'Le disque du dossier de sauvegarde est plein. Libérez de l\'espace, puis touchez Sauvegarder maintenant.';

  @override
  String get autoBackupOther =>
      'La sauvegarde n\'a pas pu être enregistrée. Touchez Sauvegarder maintenant pour réessayer.';

  @override
  String autoBackupOtherWhy(String reason) {
    return 'La sauvegarde n\'a pas pu être enregistrée ($reason). Touchez Sauvegarder maintenant pour réessayer.';
  }

  @override
  String get importUiDeleteNote =>
      'Une fois terminé, supprimez le fichier exporté : quiconque l\'obtient peut générer vos codes.';

  @override
  String get importUiStepsAegis =>
      'Dans Aegis, sur votre téléphone Android :\n\n1. Touchez ⋮, puis Paramètres, puis « Importer et exporter ».\n2. Touchez « Exporter » et choisissez « Aegis (.JSON) ».\n3. Laissez « Chiffrer le coffre » activé si vous voulez ; vous taperez ce mot de passe ici.\n4. Enregistrez le fichier à un endroit que cet appareil peut ouvrir (par exemple Google Drive, ou envoyez-le-vous par e-mail).\n\nPuis choisissez ce fichier ici.';

  @override
  String get importUiStepsTwoFas =>
      'Dans 2FAS :\n\n1. Ouvrez les Paramètres, puis « Sauvegarde 2FAS ».\n2. Touchez « Exporter vers un fichier ». S\'il demande un mot de passe, vous taperez le même ici.\n3. Enregistrez le fichier .2fas à un endroit que cet appareil peut ouvrir.\n\nPuis choisissez ce fichier ici.';

  @override
  String get importUiStepsAuthy =>
      'Authy n\'a pas de bouton d\'export, et Authy pour ordinateur a fermé en 2024.\n\nSi vous avez déjà sorti vos comptes avec un outil comme « authy-export », choisissez le fichier qu\'il a créé (un fichier .json, ou une liste .txt de liens otpauth://).\n\nSinon, le plus sûr est d\'y aller compte par compte : connectez-vous à chaque site, désactivez puis réactivez la connexion en deux étapes, et scannez le nouveau code QR avec Tanooki Auth. Gardez Authy jusqu\'à ce que chaque compte fonctionne ici.';

  @override
  String get importUiStepsBitwarden =>
      'Dans Bitwarden (site web ou app de bureau) :\n\n1. Allez dans Outils, puis « Exporter le coffre ».\n2. Choisissez « .json » ou « .csv ». Pas « chiffré ».\n3. Enregistrez le fichier.\n\nPuis choisissez ce fichier ici. Seuls les identifiants avec une clé d\'authentification sont repris ; vos mots de passe sont ignorés.';

  @override
  String get importUiStepsOnePassword =>
      'Dans l\'app 1Password pour Mac ou Windows :\n\n1. Cliquez sur Fichier, puis Exporter, puis choisissez votre compte.\n2. Choisissez le format « CSV » et enregistrez.\n\nPuis choisissez ce fichier ici. Seuls les éléments avec un mot de passe à usage unique sont repris ; vos mots de passe sont ignorés.';

  @override
  String get importUiStepsApple =>
      'Il vous faut un Mac ; l\'iPhone ne peut pas enregistrer le fichier.\n\nSur un Mac avec macOS Sequoia ou plus récent :\n1. Ouvrez l\'app Mots de passe.\n2. Dans la barre des menus, cliquez sur Fichier, puis « Exporter tous les mots de passe… ».\n3. Cliquez sur « Exporter les mots de passe », tapez le mot de passe du Mac si demandé, et enregistrez le fichier.\n\nSur un Mac plus ancien : ouvrez Safari, puis Safari > Réglages > Mots de passe, cliquez sur le bouton ⋯ et choisissez « Exporter tous les mots de passe… ».\n\nPuis choisissez ce fichier ici. Seuls les éléments avec un code de validation sont repris ; vos mots de passe sont ignorés.';

  @override
  String get importUiStepsMicrosoft =>
      'Microsoft Authenticator ne peut pas exporter vos comptes, ils ne peuvent donc pas être transférés d\'un coup.\n\nPour chaque compte :\n1. Connectez-vous à ce site sur un ordinateur.\n2. Trouvez ses réglages de sécurité ou de double authentification.\n3. Désactivez puis réactivez la connexion en deux étapes (ou choisissez « ajouter une nouvelle app d\'authentification »).\n4. Scannez le nouveau code QR avec Tanooki Auth et tapez le code affiché pour terminer.\n\nGardez Microsoft Authenticator jusqu\'à ce que chaque compte fonctionne dans Tanooki Auth. Votre compte Microsoft lui-même peut aussi utiliser Tanooki Auth : ajoutez-le sur account.microsoft.com, dans Sécurité.';

  @override
  String get importUiTitle => 'Transférer depuis une autre app';

  @override
  String get importUiCantExport =>
      'Pas d\'export : comment transférer chaque compte';

  @override
  String get importUiFromExportFile => 'Depuis un fichier d\'export';

  @override
  String importUiMoveFrom(String app) {
    return 'Transférer depuis $app';
  }

  @override
  String get importUiGotIt => 'Compris';

  @override
  String get importUiPickFile => 'Choisir le fichier';

  @override
  String get importUiCouldntRead => 'Impossible de lire ce fichier.';

  @override
  String importUiReading(String app) {
    return 'Lecture de l\'export $app…';
  }

  @override
  String get importUiNoAccountsInFile =>
      'Ce fichier ne contenait aucun compte à double authentification.';

  @override
  String importUiImportFrom(int count, String app) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importer $count comptes depuis $app ?',
      one: 'Importer 1 compte depuis $app ?',
    );
    return '$_temp0';
  }

  @override
  String importUiExportPassword(String app) {
    return 'Mot de passe de l\'export $app';
  }

  @override
  String get importUiPasswordHint => 'Le mot de passe choisi lors de l\'export';

  @override
  String importersNotAnExport(String app) {
    return 'Ce fichier n\'est pas un export $app.';
  }

  @override
  String importersLine(String line, String problem) {
    return 'Ligne $line : $problem';
  }

  @override
  String get importersEmpty => 'Ce fichier est vide.';

  @override
  String get importersNotAuthy => 'Ce fichier n\'est pas un export Authy.';

  @override
  String get importersAnAccount => 'Un compte';

  @override
  String importersQuoted(String name) {
    return '« $name »';
  }

  @override
  String importersProblemColon(String name, String problem) {
    return '$name : $problem';
  }

  @override
  String importersProblem(String name, String problem) {
    return '$name $problem';
  }

  @override
  String get importersAegisPassword =>
      'Cet export Aegis est protégé par un mot de passe.';

  @override
  String get importersAegisBiometricOnly =>
      'Cet export Aegis ne peut être ouvert qu\'avec une empreinte sur le téléphone qui l\'a créé. Dans Aegis, exportez à nouveau en choisissant un mot de passe.';

  @override
  String get importersAegisWrongPassword =>
      'Mot de passe incorrect pour cet export Aegis.';

  @override
  String get importersAegisDamaged =>
      'L\'export Aegis s\'est déverrouillé, mais son contenu est endommagé.';

  @override
  String get importersNotAegis => 'Ce fichier n\'est pas un export Aegis.';

  @override
  String importersUnsupportedType(String type) {
    return 'utilise des codes $type, que Tanooki Auth ne prend pas en charge';
  }

  @override
  String get importersNotTwoFas => 'Ce fichier n\'est pas une sauvegarde 2FAS.';

  @override
  String get importersTwoFasPassword =>
      'Cette sauvegarde 2FAS est protégée par un mot de passe.';

  @override
  String get importersTwoFasDamaged => 'Cette sauvegarde 2FAS est endommagée.';

  @override
  String get importersTwoFasWrongPassword =>
      'Mot de passe incorrect pour cette sauvegarde 2FAS.';

  @override
  String get importersBitwardenEncrypted =>
      'Cet export Bitwarden est chiffré. Dans Bitwarden, exportez à nouveau au format « .json » (pas « chiffré »).';

  @override
  String get importersOnePux =>
      'Cela ressemble à un fichier .1pux de 1Password. Dans 1Password, exportez à nouveau en choisissant CSV.';

  @override
  String importersNoCodeColumn(String app) {
    return 'Ce fichier n\'a pas de colonne de codes à usage unique : ce n\'est donc pas un export $app contenant des codes.';
  }

  @override
  String importersCantReadCode(String reason) {
    return 'a un code à usage unique que Tanooki Auth ne sait pas lire ($reason)';
  }

  @override
  String get importersNoSecret => 'n\'a pas de secret';

  @override
  String get importersBadSecret => 'a un secret qui n\'est pas valide';

  @override
  String importersUnsupportedDigits(int count) {
    return 'utilise des codes à $count chiffres, que Tanooki Auth ne prend pas en charge';
  }

  @override
  String get importersBadPeriod => 'a une période de temps invalide';

  @override
  String importersUnsupportedAlgorithm(String algorithm) {
    return 'utilise l\'algorithme $algorithm, que Tanooki Auth ne prend pas en charge';
  }

  @override
  String get exportUiTitle => 'Transférer vers une autre app';

  @override
  String get exportUiAegisLocked => 'Aegis, avec mot de passe';

  @override
  String get exportUiAegisLockedSub =>
      'Le plus sûr. Aegis demande le mot de passe à l\'import.';

  @override
  String get exportUiAegisPlain => 'Aegis, non chiffré';

  @override
  String get exportUiAegisPlainSub =>
      'Pour les apps qui lisent les fichiers Aegis mais pas ceux protégés.';

  @override
  String get exportUiTwoFasSub => 'Un fichier .2fas sans mot de passe.';

  @override
  String get exportUiGoogleSub =>
      'Des codes QR à scanner avec Google Authenticator.';

  @override
  String get exportUiLinks => 'Liens de configuration (texte en clair)';

  @override
  String get exportUiLinksSub =>
      'Un lien otpauth:// par ligne, pour n\'importe quelle autre app.';

  @override
  String get exportUiConfirmReason => 'Exporter vos comptes';

  @override
  String get exportUiEncryptingAegis => 'Chiffrement pour Aegis…';

  @override
  String get exportUiAegisPlainWhat =>
      'Cela enregistre chaque clé de configuration dans un fichier Aegis non chiffré.';

  @override
  String get exportUiTwoFasWhat =>
      'Cela enregistre chaque clé de configuration dans un fichier 2FAS sans mot de passe.';

  @override
  String get exportUiGoogleTitle =>
      'Afficher des codes QR pour Google Authenticator ?';

  @override
  String get exportUiGoogleBody =>
      'L\'écran suivant affiche des codes QR contenant chaque clé de configuration. Quiconque les voit ou les photographie peut générer vos codes de connexion. Faites-le dans un endroit privé.\n\nDans Google Authenticator : touchez +, puis « Scanner un code QR », et scannez chaque code à tour de rôle.';

  @override
  String get exportUiShowCodes => 'Afficher les codes';

  @override
  String exportUiExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count comptes exportés. Importez le fichier dans l\'autre app, puis supprimez-le.',
      one: '1 compte exporté. Importez le fichier dans l\'autre app, puis supprimez-le.',
    );
    return '$_temp0';
  }

  @override
  String get exportUiNoneForGoogle =>
      'Aucun de vos comptes ne peut aller dans Google Authenticator.';

  @override
  String get exportUiScanThisCode => 'Scannez ce code';

  @override
  String exportUiCodeOf(int n, int total) {
    return 'Code $n sur $total';
  }

  @override
  String get exportUiNextCode => 'Code suivant';

  @override
  String exportUiLeftOut(int count) {
    return 'Laissés de côté ($count). Google Authenticator ne sait pas générer ces codes, ajoutez-les donc à une autre app :';
  }

  @override
  String get appIconClassic => 'Classique';

  @override
  String get appIconPink => 'Rose pastel';

  @override
  String get appIconBlue => 'Bleu pastel';

  @override
  String get appIconLavender => 'Lavande';

  @override
  String get appIconMint => 'Menthe';

  @override
  String get appIconMidnight => 'Minuit';

  @override
  String get appIconSunset => 'Coucher de soleil';

  @override
  String get appIconSpooky => 'Effrayant (automne)';

  @override
  String get appIconCozy => 'Douillet (hiver)';

  @override
  String get appIconSpring => 'Printemps';

  @override
  String get serverBrowserExtension => 'Extension de navigateur';

  @override
  String get serverBadRequest => 'Tanooki Auth n\'a pas compris cette demande.';

  @override
  String get serverLocked =>
      'Tanooki Auth est verrouillé. Déverrouillez-le, puis réessayez.';

  @override
  String get serverNotPaired => 'Cette app n\'est pas associée à Tanooki Auth.';

  @override
  String get serverNotFound => 'Ce compte n\'est plus dans Tanooki Auth.';

  @override
  String get serverRateLimited => 'Trop de demandes.';

  @override
  String get serverDenied =>
      'Non autorisé : ce compte demande d\'abord une confirmation, et Tanooki Auth n\'a pas été déverrouillé pour lui.';

  @override
  String get serverUnknownScreen => 'Écran inconnu.';

  @override
  String get serverNoWebsite => 'Aucun site indiqué.';

  @override
  String serverUnknownRequest(String type) {
    return 'Demande inconnue « $type ».';
  }

  @override
  String get serverPairingTimedOut =>
      'L\'association a expiré ou a été fermée. Recommencez l\'association.';

  @override
  String get serverThreeWrongCodes =>
      'Trois codes erronés. Recommencez l\'association.';

  @override
  String get serverWrongCode =>
      'Ce code ne correspond pas. Vérifiez le code affiché dans Tanooki Auth.';

  @override
  String get serverNoLink => 'Aucun lien otpauth:// n\'a été envoyé.';

  @override
  String get serverAlreadyThere => 'Ce compte est déjà dans Tanooki Auth.';

  @override
  String get serverAlreadyThereMany =>
      'Ces comptes sont déjà dans Tanooki Auth.';

  @override
  String get autoBackupNotSupported => 'non pris en charge sur cet appareil';

  @override
  String homeProveCopy(String name) {
    return 'Copier le code de $name';
  }

  @override
  String homeProveReadAloud(String name) {
    return 'Lire à voix haute le code de $name';
  }

  @override
  String homeProveEdit(String name) {
    return 'Modifier $name';
  }

  @override
  String homeProveShare(String name) {
    return 'Partager $name';
  }

  @override
  String homeCopied(String name) {
    return 'Code $name copié. Le presse-papiers s\'efface dans 30 secondes.';
  }

  @override
  String get homeEditAccount => 'Modifier le compte';

  @override
  String homeShowQrFor(String name) {
    return 'Afficher le code QR de $name';
  }

  @override
  String homeMovedToTrash(String name) {
    return '$name a été placé dans la corbeille. Vous pouvez le restaurer depuis les Réglages pendant 30 jours.';
  }

  @override
  String get homeUndo => 'Annuler';

  @override
  String homeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes',
      one: '1 compte',
    );
    return '$_temp0';
  }

  @override
  String homeAddTagTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ajouter une étiquette à $count comptes',
      one: 'Ajouter une étiquette à 1 compte',
    );
    return '$_temp0';
  }

  @override
  String get homeTagHint => 'Étiquette (par ex. travail)';

  @override
  String get homeAddTag => 'Ajouter l\'étiquette';

  @override
  String homeTagged(int count, String tag) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Étiquette « $tag » ajoutée à $count comptes.',
      one: 'Étiquette « $tag » ajoutée à 1 compte.',
    );
    return '$_temp0';
  }

  @override
  String homeMoveToFolderTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Déplacer $count comptes dans un dossier',
      one: 'Déplacer 1 compte dans un dossier',
    );
    return '$_temp0';
  }

  @override
  String get homeNoFolder => 'Aucun dossier';

  @override
  String get homeNewFolderHint => 'Ou un nouveau dossier (par ex. Travail)';

  @override
  String get homeMoveToNewFolder => 'Déplacer dans le nouveau dossier';

  @override
  String homeTookOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes retirés de leurs dossiers.',
      one: '1 compte retiré de son dossier.',
    );
    return '$_temp0';
  }

  @override
  String homeMovedTo(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes déplacés dans $folder.',
      one: '1 compte déplacé dans $folder.',
    );
    return '$_temp0';
  }

  @override
  String homeAddedToFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes ajoutés aux favoris.',
      one: '1 compte ajouté aux favoris.',
    );
    return '$_temp0';
  }

  @override
  String homeRemovedFromFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes retirés des favoris.',
      one: '1 compte retiré des favoris.',
    );
    return '$_temp0';
  }

  @override
  String homeBulkTrashed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count comptes placés dans la corbeille. Vous pouvez les restaurer depuis les Réglages pendant 30 jours.',
      one: '1 compte placé dans la corbeille. Vous pouvez le restaurer depuis les Réglages pendant 30 jours.',
    );
    return '$_temp0';
  }

  @override
  String get homeDoneSelecting => 'Terminer la sélection';

  @override
  String get homeTapToSelect => 'Touchez des comptes pour les sélectionner';

  @override
  String homeSelectedCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get homeSelectNone => 'Tout désélectionner';

  @override
  String get homeSelectAll => 'Tout sélectionner';

  @override
  String get homeAddATag => 'Ajouter une étiquette';

  @override
  String get homeMoveToFolder => 'Déplacer dans un dossier';

  @override
  String get homeRemoveFromFavorites => 'Retirer des favoris';

  @override
  String get homeAddToFavorites => 'Ajouter aux favoris';

  @override
  String get homeMoveToTrash => 'Placer dans la corbeille';

  @override
  String get homeSelectFirst =>
      'Sélectionnez d\'abord des comptes : touchez-les dans la liste.';

  @override
  String homeSectionOpen(String name, String accounts) {
    return '$name, $accounts, touchez pour replier';
  }

  @override
  String homeSectionClosed(String name, String accounts) {
    return '$name, $accounts, touchez pour afficher';
  }

  @override
  String get homeSearchHint => 'Rechercher des comptes ou des sites…';

  @override
  String get homeAllTags => 'Tous';

  @override
  String get homeNoAccountsYet =>
      'Aucun compte pour l\'instant.\nAjoutez-en un pour scanner un code QR de configuration.';

  @override
  String get homeNoTagMatches => 'Aucun compte avec cette étiquette.';

  @override
  String get homeNoSearchMatches =>
      'Aucun compte ne correspond à votre recherche.';

  @override
  String get homeSelectAccounts => 'Sélectionner des comptes';

  @override
  String get homeSettings => 'Réglages';

  @override
  String get homeAddAccount => 'Ajouter un compte';

  @override
  String get homeAccounts => 'Comptes';

  @override
  String get homeYourAccounts => 'Vos comptes';

  @override
  String get homeSelect => 'Sélectionner';

  @override
  String get homeKeysTouch =>
      'Toucher (Copier) · Entrée (Copier) · Flèches (Naviguer)';

  @override
  String get homeKeysClick =>
      'Clic (Copier) · Entrée (Copier) · Flèches (Naviguer)';

  @override
  String get homePickOnLeft =>
      'Choisissez un compte à gauche pour l\'afficher ici.';

  @override
  String homeQrFor(String name) {
    return 'Code QR de $name';
  }

  @override
  String get homeQrWarning =>
      'Scannez-le avec une autre app d\'authentification pour y ajouter le même compte. Quiconque le voit ou le photographie peut générer vos codes : gardez-le privé.';

  @override
  String homeVersionNote(Object version) {
    return 'v$version · reste sur cet appareil';
  }

  @override
  String homeSelectName(String name) {
    return 'Sélectionner $name';
  }

  @override
  String get homeMore => 'Plus';

  @override
  String get homeRecoveryCodes => 'Codes de récupération';

  @override
  String homeRecoveryCodesLeft(int count) {
    return 'Codes de récupération ($count restants)';
  }

  @override
  String get homeShareSecurely => 'Partager en toute sécurité';

  @override
  String get homeShowQr => 'Afficher le code QR';

  @override
  String get homeMoveEarlier => 'Monter';

  @override
  String get homeMoveLater => 'Descendre';

  @override
  String homeNextCodeShort(String code) {
    return 'Suivant : $code';
  }

  @override
  String get homeNextCode => 'Code suivant';

  @override
  String get homeFavorite => 'Favori';

  @override
  String get homeCodeHiddenAsk =>
      'Code masqué jusqu\'à ce que vous confirmiez que c\'est vous';

  @override
  String get homeCodeHidden => 'Code masqué';

  @override
  String homeNextCodeSpoken(String code) {
    return 'Code suivant $code';
  }

  @override
  String homeKindTotp(int count, int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chiffres',
      one: '1 chiffre',
    );
    return 'TOTP · $_temp0 · $seconds s';
  }

  @override
  String homeKindSteam(int seconds) {
    return 'Steam · 5 caractères · $seconds s';
  }

  @override
  String homeKindHotp(int count, String counter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chiffres',
      one: '1 chiffre',
    );
    return 'HOTP · $_temp0 · n° $counter';
  }

  @override
  String get homeAccountHeading => 'Compte';

  @override
  String get homeHintUnselect => 'désélectionner';

  @override
  String get homeHintSelect => 'sélectionner';

  @override
  String get homeHintCopy => 'copier le code';

  @override
  String get homeReadCodeAloud => 'Lire le code à voix haute';

  @override
  String get homeMoreOptions => 'Plus d\'options';

  @override
  String get mainPairRaycastTitle => 'Associer à Raycast';

  @override
  String get mainPairRaycastBody => 'Tapez ce code dans Raycast :';

  @override
  String get mainPairRaycastWarning =>
      'Ne le faites que si vous venez vous-même de lancer l\'association dans Raycast.';

  @override
  String get mainPairAlfredTitle => 'Associer à Alfred';

  @override
  String get mainPairAlfredBody =>
      'Tapez 2fa-pair suivi de ce code dans Alfred :';

  @override
  String get mainPairAlfredWarning =>
      'Ne le faites que si vous venez vous-même de taper 2fa-pair dans Alfred.';

  @override
  String get mainPairPowerToysTitle => 'Associer à PowerToys';

  @override
  String get mainPairPowerToysBody =>
      'Tapez ce code dans la palette de commandes de PowerToys :';

  @override
  String get mainPairPowerToysWarning =>
      'Ne le faites que si vous venez vous-même de lancer l\'association dans PowerToys.';

  @override
  String get mainPairBrowserTitle => 'Associer à votre navigateur';

  @override
  String get mainPairBrowserBody =>
      'Tapez ce code dans l\'extension de navigateur Tanooki Auth :';

  @override
  String get mainPairBrowserWarning =>
      'Ne le faites que si vous venez vous-même de cliquer sur « Associer » dans l\'extension.';

  @override
  String mainSendCodeTo(String name, String client) {
    return 'Envoyer le code de $name à $client';
  }

  @override
  String mainWrongPasscodeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Code incorrect. Encore $count erreurs et tout est effacé.',
      one: 'Code incorrect. Encore 1 erreur et tout est effacé.',
    );
    return '$_temp0';
  }

  @override
  String get mainWrongPasscode => 'Code incorrect.';

  @override
  String get mainBiometricWindows => 'Windows Hello';

  @override
  String get mainBiometricMac => 'Touch ID';

  @override
  String get mainBiometricOther => 'Face ID ou empreinte';

  @override
  String get mainLockTitle => 'Verrouiller Tanooki Auth ?';

  @override
  String get mainLockBody =>
      'Demander votre visage, votre empreinte ou votre code à l\'ouverture de l\'app, pour que personne tenant votre téléphone déverrouillé ne puisse lire vos codes. Vous pourrez changer cela plus tard dans les Réglages.';

  @override
  String get mainTurnOnLock => 'Activer le verrouillage';

  @override
  String get mainUnlockReason => 'Déverrouiller Tanooki Auth';

  @override
  String get mainStartOverTitle => 'Créer un nouveau coffre vide ?';

  @override
  String get mainStartOverBody =>
      'Cela remplace définitivement ce qui reste de vos anciens comptes. Ne le faites que si vous n\'avez aucune sauvegarde à restaurer, ou si vous avez déjà désactivé la connexion en deux étapes sur ces sites.';

  @override
  String get mainEraseStartOver => 'Tout effacer et recommencer';

  @override
  String get mainRestoreFromBackup => 'Restaurer une sauvegarde';

  @override
  String get mainStartNewVault => 'Créer un nouveau coffre vide';

  @override
  String get mainLocked => 'Tanooki Auth est verrouillé';

  @override
  String mainUseBiometric(String method) {
    return 'Utiliser $method';
  }

  @override
  String get mainUseSecurityKey => 'Utiliser une clé de sécurité';

  @override
  String homeHidesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Masqué dans $count secondes',
      one: 'Masqué dans 1 seconde',
    );
    return '$_temp0';
  }

  @override
  String homeCardsMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      'm1': 'janvier',
      'm2': 'février',
      'm3': 'mars',
      'm4': 'avril',
      'm5': 'mai',
      'm6': 'juin',
      'm7': 'juillet',
      'm8': 'août',
      'm9': 'septembre',
      'm10': 'octobre',
      'm11': 'novembre',
      'm12': 'décembre',
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
      'Refusé. La personne ne peut pas ouvrir vos comptes. Elle pourra redemander plus tard, et on vous redemandera.';

  @override
  String get homeCardsClockRight =>
      'Votre horloge est maintenant à l\'heure. Les codes devraient fonctionner.';

  @override
  String get homeCardsCheckAgain => 'Vérifier à nouveau';

  @override
  String get homeCardsYourContact => 'Votre contact d\'urgence';

  @override
  String homeCardsEmergencyWaiting(String who, String left, String day) {
    return '$who a demandé l\'accès d\'urgence à vos comptes. Sauf refus de votre part, la copie pourra être ouverte dans $left ($day).';
  }

  @override
  String homeCardsEmergencyReleased(String who) {
    return '$who a demandé l\'accès d\'urgence et le délai de 7 jours est écoulé : une copie de vos comptes peut être ouverte maintenant. Refusez pour l\'en empêcher.';
  }

  @override
  String get homeCardsBackupNudge =>
      'Vos comptes ont changé depuis votre dernière sauvegarde. Un fichier de sauvegarde permet de les récupérer si cet appareil est perdu.';

  @override
  String get homeCardsBackUpNow => 'Sauvegarder maintenant';

  @override
  String homeCardsSummaryNew(int count, String month) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Votre bilan de $month : $count nouveaux comptes.',
      one: 'Votre bilan de $month : 1 nouveau compte.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryNoBackup => 'Pas encore de sauvegarde.';

  @override
  String homeCardsSummaryLastBackup(String day) {
    return 'Dernière sauvegarde : $day.';
  }

  @override
  String get homeCardsSummaryAllCodes =>
      'Chaque compte a ses codes de récupération.';

  @override
  String homeCardsSummaryMissingCodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes sans codes de récupération.',
      one: '1 compte sans codes de récupération.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryCheckupGood => 'Bilan de sécurité : tout va bien.';

  @override
  String homeCardsSummaryCheckupFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bilan de sécurité : $count points à corriger.',
      one: 'Bilan de sécurité : 1 point à corriger.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsOpenCheckup => 'Ouvrir le bilan';

  @override
  String get quickPickSelf =>
      'Tanooki Auth était encore au premier plan, rien n\'a donc été tapé. Cliquez dans le champ à remplir, puis utilisez à nouveau l\'icône de la barre des menus.';

  @override
  String quickPickTypeFailed(String reason) {
    return 'Impossible de taper le code ($reason). Copiez-le plutôt.';
  }

  @override
  String get quickPickTypeUnavailable =>
      'La saisie de codes n\'est pas disponible sur cet ordinateur. Copiez-le plutôt.';

  @override
  String quickPickUseCodeFor(String name) {
    return 'Utiliser le code de $name';
  }

  @override
  String get quickPickAllowTitle => 'Autoriser Tanooki Auth à taper';

  @override
  String get quickPickAllowBody =>
      'Pour taper un code dans une autre app, votre Mac doit autoriser Tanooki Auth à appuyer sur des touches pour vous.\n\n1. Cliquez sur « Ouvrir Réglages Système » ci-dessous.\n2. Vous verrez une liste appelée Accessibilité. Trouvez Tanooki Auth et activez son interrupteur (bleu).\n3. Si votre Mac demande votre mot de passe ou Touch ID, donnez-le.\n4. Revenez ici et cliquez à nouveau sur Taper.\n\nTanooki Auth n\'appuie sur des touches que lorsque vous cliquez sur Taper, et ne tape que le code.';

  @override
  String get quickPickOpenSystemSettings => 'Ouvrir Réglages Système';

  @override
  String get quickPickTitle => 'Choix rapide';

  @override
  String get quickPickSearch => 'Rechercher des comptes';

  @override
  String get quickPickLinuxNote =>
      'La saisie de codes dans d\'autres apps n\'est pas disponible sous Linux. Cliquez sur un compte pour copier son code.';

  @override
  String get quickPickNoMatches => 'Aucun compte correspondant';

  @override
  String get quickPickAsksFirst => '••• •••  (demande d\'abord)';

  @override
  String get quickPickHiddenAsks => 'Code masqué, demande d\'abord';

  @override
  String get quickPickType => 'Taper';

  @override
  String get codeViewRing => 'Anneau';

  @override
  String get codeViewBar => 'Barre';

  @override
  String get codeViewNumber => 'Nombre';

  @override
  String codeViewSpoken(String code) {
    return 'Code $code';
  }

  @override
  String codeViewSpokenLeft(int count, String code) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Code $code, $count secondes restantes',
      one: 'Code $code, 1 seconde restante',
    );
    return '$_temp0';
  }

  @override
  String get codeViewReadAloud => 'Lire le code à voix haute';

  @override
  String codeViewSecondsShort(int count) {
    return '$count s';
  }

  @override
  String get codeViewColorBlue => 'Bleu';

  @override
  String get codeViewColorPurple => 'Violet';

  @override
  String get codeViewColorPink => 'Rose';

  @override
  String get codeViewColorRed => 'Rouge';

  @override
  String get codeViewColorOrange => 'Orange';

  @override
  String get codeViewColorGold => 'Or';

  @override
  String get codeViewColorGreen => 'Vert';

  @override
  String get codeViewColorTeal => 'Bleu canard';

  @override
  String get codeViewColorGray => 'Gris';

  @override
  String trashRestored(String name) {
    return '$name est de retour dans votre liste.';
  }

  @override
  String trashDeleteTitle(String name) {
    return 'Supprimer $name définitivement ?';
  }

  @override
  String get trashDeleteBody =>
      'C\'est irréversible. Avant de supprimer, désactivez la connexion en deux étapes sur ce site ou assurez-vous d\'avoir ses codes de récupération, sinon vous pourriez perdre l\'accès.';

  @override
  String get trashDeleteForGood => 'Supprimer définitivement';

  @override
  String get trashTitle => 'Corbeille';

  @override
  String get trashEmpty =>
      'La corbeille est vide.\nLes comptes supprimés y restent 30 jours.';

  @override
  String get trashNote =>
      'Les comptes supprimés restent ici 30 jours, puis ils sont supprimés définitivement.';

  @override
  String get trashRemovedNextOpen =>
      'Supprimé à la prochaine ouverture de l\'app';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours restants',
      one: '1 jour restant',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => 'Restaurer';

  @override
  String get recoveryAddTitle => 'Ajouter des codes de récupération';

  @override
  String get recoveryPasteHint =>
      'Collez les codes donnés par le site, un par ligne';

  @override
  String get recoveryNoneNew =>
      'Aucun nouveau code trouvé dans ce que vous avez collé.';

  @override
  String recoveryAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count codes ajoutés.',
      one: '1 code ajouté.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryCopiedUsed =>
      'Copié. Attention : vous avez marqué ce code comme utilisé, il ne fonctionnera sans doute plus.';

  @override
  String get recoveryCopied =>
      'Copié. Le presse-papiers s\'efface dans 30 secondes. Marquez-le comme utilisé une fois connecté.';

  @override
  String get recoveryRemoveTitle => 'Retirer ce code ?';

  @override
  String recoveryRemoveBody(String code) {
    return '$code\n\nNe le retirez que si le site ne l\'accepte plus.';
  }

  @override
  String recoveryTitle(String name) {
    return 'Codes de récupération de $name';
  }

  @override
  String get recoveryAddCodes => 'Ajouter des codes';

  @override
  String get recoveryIntro =>
      'Quand vous activez la connexion en deux étapes, la plupart des sites vous donnent aussi une liste de codes de secours. Chacun vous permet d\'entrer une fois si vous perdez cette app. Collez-les ici pour les garder en sécurité avec le compte.';

  @override
  String recoveryUnusedOf(String unused, int total) {
    return '$unused sur $total inutilisés. Touchez un code pour le copier, et cochez-le une fois utilisé.';
  }

  @override
  String get recoveryUsed => 'Utilisé';

  @override
  String get detailsEditAccount => 'Modifier le compte';

  @override
  String get detailsCopyCode => 'Copier le code';

  @override
  String get detailsReadAloud => 'Lire à voix haute';

  @override
  String get detailsFolderAndTags => 'Dossier et étiquettes';

  @override
  String get detailsWebsites => 'Sites web';

  @override
  String get detailsNotes => 'Notes';

  @override
  String get detailsNotesHidden =>
      'Masqué jusqu\'à ce que vous confirmiez que c\'est vous.';

  @override
  String get detailsNoNotes => 'Pas de notes. Ajoutez-en avec Modifier.';

  @override
  String get accountSortCustom => 'Personnalisé (faites glisser pour ranger)';

  @override
  String get accountSortRecent => 'Utilisés récemment';

  @override
  String get accountSortName => 'De A à Z';

  @override
  String get activityCopied => 'Copié';

  @override
  String get activityFilled => 'Rempli';

  @override
  String get activityTyped => 'Tapé';

  @override
  String get activityShownQr => 'Code QR affiché';

  @override
  String get activityExported => 'Exporté';

  @override
  String totpBadCharacter(String char) {
    return 'Ce n\'est pas un secret base32 valide (caractère incorrect « $char »)';
  }

  @override
  String get totpEmpty => 'Le secret est vide';

  @override
  String get vaultFileMissing =>
      'Le fichier de vos comptes est introuvable. Si vous avez une sauvegarde, restaurez-la. Sinon, vous pouvez créer un nouveau coffre vide.';

  @override
  String get vaultKeyMissing =>
      'La clé qui déverrouille vos comptes est absente du stockage sécurisé de cet appareil. Restaurez une sauvegarde pour récupérer vos comptes.';

  @override
  String get vaultDecryptFailed =>
      'Le fichier de vos comptes n\'a pas pu être déverrouillé. Il est peut-être endommagé ou a été modifié en dehors de l\'app. Restaurez une sauvegarde.';

  @override
  String get vaultBadJson =>
      'Le fichier de vos comptes s\'est déverrouillé, mais son contenu est endommagé. Restaurez une sauvegarde.';

  @override
  String clockCheckBadAnswer(String status) {
    return 'Le serveur d\'heure a envoyé une réponse que l\'app ne comprend pas (HTTP $status).';
  }

  @override
  String clockCheckOff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'L\'horloge de votre appareil est décalée d\'environ $count minutes, les codes ne fonctionneront donc pas. Activez l\'heure automatique dans les Réglages.',
      one: 'L\'horloge de votre appareil est décalée d\'environ 1 minute, les codes ne fonctionneront donc pas. Activez l\'heure automatique dans les Réglages.',
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
    return '• $account : $reason';
  }
}
