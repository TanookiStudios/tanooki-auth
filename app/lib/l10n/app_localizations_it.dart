// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRemove => 'Rimuovi';

  @override
  String get commonUnlock => 'Sblocca';

  @override
  String get commonTurnOff => 'Disattiva';

  @override
  String get commonNotNow => 'Non ora';

  @override
  String get commonNext => 'Avanti';

  @override
  String get commonDone => 'Fine';

  @override
  String get commonDeny => 'Rifiuta';

  @override
  String get commonAllow => 'Consenti';

  @override
  String get commonTryAgain => 'Riprova';

  @override
  String get commonStop => 'Interrompi';

  @override
  String get commonShare => 'Condividi';

  @override
  String get commonOpen => 'Apri';

  @override
  String get commonCopy => 'Copia';

  @override
  String get commonContinueLabel => 'Continua';

  @override
  String get commonClear => 'Cancella';

  @override
  String get commonBack => 'Indietro';

  @override
  String get commonAdd => 'Aggiungi';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get commonEdit => 'Modifica';

  @override
  String get commonYes => 'Sì';

  @override
  String get commonNo => 'No';

  @override
  String get commonSeePremium => 'Scopri Premium';

  @override
  String get commonPremiumBadge => 'Premium';

  @override
  String get commonAppName => 'Tanooki Auth';

  @override
  String get googleMigrationUnreadable =>
      'Impossibile leggere quel codice di Google Authenticator.';

  @override
  String get googleMigrationDamaged =>
      'Quel codice di Google Authenticator è danneggiato.';

  @override
  String get googleMigrationEmpty =>
      'Quel codice di Google Authenticator non contiene account.';

  @override
  String get googleMigrationNoSecret =>
      'Un account in quel codice non ha una chiave segreta.';

  @override
  String get googleMigrationMd5 =>
      'Un account in quel codice usa MD5, che Tanooki Auth non supporta.';

  @override
  String get googleCantTakeSteam => 'codici Steam';

  @override
  String googleCantTakeDigits(int digits) {
    return 'codici a $digits cifre';
  }

  @override
  String googleCantTakePeriod(int seconds) {
    return 'codici che cambiano ogni $seconds secondi';
  }

  @override
  String get otpauthNotALink => 'Non è un link otpauth://.';

  @override
  String get otpauthNoSecret => 'Il link non contiene la chiave segreta.';

  @override
  String otpauthUnsupportedType(String type) {
    return 'Tipo di codice \"$type\" non supportato.';
  }

  @override
  String otpauthUnsupportedAlgorithm(String algorithm) {
    return 'Algoritmo \"$algorithm\" non supportato.';
  }

  @override
  String get otpauthBadDigits => 'Le cifre devono essere 6, 7 o 8.';

  @override
  String get otpauthBadPeriod => 'Il periodo deve essere un numero positivo.';

  @override
  String get otpauthBadCounter => 'Il contatore deve essere zero o più.';

  @override
  String get phoneLinkNotAPairingCode =>
      'Non è un codice di abbinamento browser di Tanooki Auth.';

  @override
  String phoneLinkNotSavedFor(String host) {
    return 'Quell\'account non è salvato per $host.';
  }

  @override
  String get phoneLinkPushNotSetUp =>
      'Le notifiche non sono ancora attive sul server di Tanooki Auth, quindi le richieste compaiono solo mentre l\'app è aperta.';

  @override
  String phoneLinkPushFailed(int status) {
    return 'Impossibile attivare le notifiche (HTTP $status).';
  }

  @override
  String get qrImageNotAPicture =>
      'Quel file non è un\'immagine che questa app può leggere.';

  @override
  String get qrImageNoQr => 'Nessun codice QR trovato in quell\'immagine.';

  @override
  String relayBadAnswer(int status) {
    return 'Il server di sincronizzazione ha inviato una risposta che l\'app non capisce (HTTP $status).';
  }

  @override
  String get relayUnreachable =>
      'Impossibile raggiungere il server di sincronizzazione. Controlla la connessione a internet.';

  @override
  String get relayTimeout =>
      'Il server di sincronizzazione non ha risposto in tempo. Controlla la connessione a internet.';

  @override
  String get relayInsecure =>
      'Impossibile stabilire una connessione sicura con il server di sincronizzazione.';

  @override
  String relaySaidNo(int status) {
    return 'Il server di sincronizzazione ha rifiutato (HTTP $status).';
  }

  @override
  String get shareNotAShare => 'Non è un account condiviso di Tanooki Auth.';

  @override
  String get shareExpired =>
      'Questa condivisione è scaduta (dura solo 24 ore). Chiedine una nuova.';

  @override
  String get shareWrongCode =>
      'Codice errato, oppure la condivisione è danneggiata. Controlla le 6 cifre e riprova.';

  @override
  String get storeServerUnreachable =>
      'Impossibile raggiungere il server di Tanooki Auth. Controlla la connessione a internet e riprova.';

  @override
  String get storeBadKey =>
      'Il server ha inviato una chiave di licenza che questa app non accetta.';

  @override
  String storeReportedProblem(String problem) {
    return 'Lo store ha segnalato un problema: $problem';
  }

  @override
  String get storeGooglePlayUnavailable =>
      'Google Play non è disponibile su questo dispositivo, quindi qui non puoi acquistare Premium. Se hai acquistato Premium altrove, inserisci qui sotto la tua chiave di licenza.';

  @override
  String get storeAppStoreUnavailable =>
      'L\'App Store non è disponibile al momento. Controlla la connessione a internet e riprova.';

  @override
  String storeNotListed(String store) {
    return '$store non ha mostrato Premium in questo momento. Riprova tra poco.';
  }

  @override
  String storeNotListedWithError(String store, String problem) {
    return '$store non ha mostrato Premium in questo momento ($problem). Riprova tra poco.';
  }

  @override
  String storePricesFailed(String problem) {
    return 'Impossibile caricare i prezzi dallo store: $problem';
  }

  @override
  String storePurchaseCouldNotStart(String problem) {
    return 'Impossibile avviare l\'acquisto: $problem';
  }

  @override
  String storeNothingToRestore(String store) {
    return 'Nessun acquisto Premium trovato per questo account $store.';
  }

  @override
  String storeRestoreFailed(String problem) {
    return 'Impossibile ripristinare gli acquisti: $problem';
  }

  @override
  String get storePending =>
      'In attesa dell\'approvazione del pagamento. Premium si sblocca appena viene approvato.';

  @override
  String get storeCanceled =>
      'Acquisto annullato. Non ti è stato addebitato nulla.';

  @override
  String storeFailed(String problem) {
    return 'L\'acquisto non è andato a buon fine: $problem. Non ti è stato addebitato nulla.';
  }

  @override
  String get storeFailedNoReason =>
      'L\'acquisto non è andato a buon fine: lo store non ha dato un motivo. Non ti è stato addebitato nulla.';

  @override
  String get storeUnlocked => 'Premium sbloccato. Grazie di cuore!';

  @override
  String get storeUnlockedWithKey =>
      'Premium sbloccato. Qui sotto trovi la chiave di licenza per i tuoi computer.';

  @override
  String storeUnlockedKeyFailed(String problem) {
    return 'Premium è sbloccato su questo dispositivo. Non è stato ancora possibile creare la chiave per i tuoi computer: $problem Tocca Ripristina acquisti più tardi per riprovare.';
  }

  @override
  String storeServerSaidNo(int status) {
    return 'Il server ha rifiutato (HTTP $status).';
  }

  @override
  String get syncGroupExists =>
      'Esiste già un gruppo di sincronizzazione con questa passphrase. Su un dispositivo che sta già sincronizzando, tocca \"Aggiungi un dispositivo\" e scansiona il suo codice.';

  @override
  String get syncNotASyncCode =>
      'Non è un codice di sincronizzazione di Tanooki Auth. Su un dispositivo che sta già sincronizzando, apri Impostazioni, Sincronizzazione, Aggiungi un dispositivo.';

  @override
  String get syncWrongPassphrase =>
      'Quella passphrase non corrisponde a quella usata dagli altri tuoi dispositivi. Controllala e riprova.';

  @override
  String get syncICloudOtherPassphrase =>
      'Gli altri tuoi dispositivi Apple sincronizzano con una passphrase diversa. Digita quella, oppure ricomincia da zero con questa.';

  @override
  String get syncErrorRemoved =>
      'Questo dispositivo è stato rimosso dalla sincronizzazione su un altro dispositivo. Disattiva la sincronizzazione e riattivala per rientrare.';

  @override
  String get syncErrorTurnedOff =>
      'La sincronizzazione è stata disattivata da un altro dispositivo. Disattivala anche qui, poi riattivala per ricominciare.';

  @override
  String get syncErrorTooOften =>
      'Sincronizzazioni troppo frequenti. Riproverà tra qualche minuto.';

  @override
  String get syncErrorLimit =>
      'Hai raggiunto il limite di sincronizzazione (2.000 account, compresi quelli eliminati).';

  @override
  String syncErrorICloud(String problem) {
    return 'iCloud Drive ha avuto un problema: $problem.';
  }

  @override
  String syncErrorUnexpected(String problem) {
    return 'La sincronizzazione si è interrotta per un problema imprevisto: $problem';
  }

  @override
  String get syncICloudAppleOnly =>
      'iCloud funziona solo su iPhone, iPad e Mac.';

  @override
  String get syncICloudSignedOut =>
      'iCloud Drive è disattivato su questo dispositivo. Per usarlo, accedi a iCloud e attiva iCloud Drive in Impostazioni.';

  @override
  String get syncICloudNotInBuild =>
      'La sincronizzazione iCloud non è ancora attiva in questa versione di Tanooki Auth. Per ora usa il relay Tanooki: funziona su tutti i dispositivi.';

  @override
  String get teamKeyUnopenable =>
      'Non è stato possibile aprire la chiave del team inviata a questo dispositivo. Chiedi all\'admin del team di rimuovere questo dispositivo e invitarlo di nuovo.';

  @override
  String get teamNotAnInvite =>
      'Non è un invito a un team di Tanooki Auth. Chiedi all\'admin del team un nuovo link o codice QR d\'invito.';

  @override
  String get teamNotInTeam => 'Questo dispositivo non fa parte di un team.';

  @override
  String get teamDeletedByAdmin =>
      'Questo team è stato eliminato dal suo admin.';

  @override
  String get teamDeviceRemoved =>
      'Questo dispositivo è stato rimosso dal team.';

  @override
  String get teamAlreadyInTeam => 'Questo dispositivo fa già parte di un team.';

  @override
  String get teamNotALicense =>
      'Non è una licenza team. Inizia con TT1. e si trova nella pagina che Stripe mostra dopo l\'abbonamento.';

  @override
  String get teamAlreadyInTeamLeaveFirst =>
      'Questo dispositivo fa già parte di un team. Prima esci da quel team.';

  @override
  String get teamGone =>
      'Quel team non esiste più. Chiedi all\'admin del team un nuovo invito.';

  @override
  String get teamInviteUsed =>
      'Quell\'invito è già stato usato o è scaduto (dura 7 giorni e funziona una volta sola). Chiedine uno nuovo all\'admin del team.';

  @override
  String get teamFull =>
      'Quel team è al completo (10 persone). L\'admin deve prima rimuovere qualcuno.';

  @override
  String get aboutTitle => 'Chi è Maddie';

  @override
  String get aboutP1 =>
      'Sono Maddie, una sviluppatrice autistica a cui sta a cuore, forse un po\' troppo, curare bene i piccoli dettagli.';

  @override
  String get aboutP2 =>
      'Credo molto nella privacy. Le chiavi che proteggono i tuoi account sono tra i dati più personali che esistano, per questo Tanooki Auth le tiene cifrate sul tuo dispositivo. Nessun account, niente pubblicità, nessun tracciamento, e a me non viene mai inviato nulla.';

  @override
  String get aboutP3 =>
      'Tanooki Auth è gratis, e voglio che resti così. Il tuo supporto è ciò che mi permette di continuare a creare app gratuite per la privacy come questa. Se Tanooki Auth ti piace, potrebbero piacerti anche le altre: le trovi su madilynthomas.com.';

  @override
  String get aboutP4 =>
      'Quindi, da me a te: grazie. Non stai solo usando un\'app: stai rendendo possibile tutto questo modo di vivere.';

  @override
  String get aboutSupportAddress =>
      'Sostieni il mio lavoro: tanookistudios.com/support';

  @override
  String get aboutSupport => 'Sostieni il mio lavoro';

  @override
  String get aboutCredits => 'Riconoscimenti';

  @override
  String get aboutCreditsBody =>
      'I codici QR vengono letti con jsQR (Apache 2.0) nell\'estensione del browser e con ZXing nell\'app. Non affiliata a Google, Twilio o Authy; Google Authenticator è un marchio di Google LLC.';

  @override
  String get addFromBrowserOne => 'Aggiungere dal browser?';

  @override
  String addFromBrowserMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aggiungere $count account dal browser?',
      one: 'Aggiungere 1 account dal browser?',
    );
    return '$_temp0';
  }

  @override
  String get addFromGoogleTransfer =>
      'Da un codice di trasferimento di Google Authenticator:';

  @override
  String addCount(int count) {
    return 'Aggiungi $count';
  }

  @override
  String get addNoColor => 'Nessun colore';

  @override
  String addColorName(String name) {
    return 'Colore $name';
  }

  @override
  String get addServiceLabel => 'Servizio (es. GitHub)';

  @override
  String get addAccountLabel => 'Account (es. la tua email)';

  @override
  String get addWebsiteLabel => 'Sito web (facoltativo)';

  @override
  String get addWebsiteHelp =>
      'es. github.com. L\'estensione del browser inserisce i codici solo qui.';

  @override
  String get addTagsLabel => 'Tag (facoltativi)';

  @override
  String get addTagsHelp => 'es. lavoro, giochi. Separali con virgole.';

  @override
  String get addFolderLabel => 'Cartella (facoltativa)';

  @override
  String get addFolderHelp => 'es. Lavoro. Lascia vuoto per nessuna cartella.';

  @override
  String get addPickFolder => 'Scegli una cartella';

  @override
  String get addNoFolder => 'Nessuna cartella';

  @override
  String get addNotesLabel => 'Note (facoltative)';

  @override
  String get addColorLabel => 'Colore (facoltativo)';

  @override
  String get addEmojiLabel => 'Emoji (facoltativa)';

  @override
  String get addEmojiHelp =>
      'Mostrata al posto del logo, qui, nei widget e sull\'orologio.';

  @override
  String addUseEmoji(String emoji) {
    return 'Usa $emoji';
  }

  @override
  String addRequireAuth(String proof) {
    return 'Chiedi $proof prima di mostrare questo codice';
  }

  @override
  String get addRequireAuthHelp =>
      'Il codice resta nascosto nell\'elenco, e widget, orologio e Scelta rapida non lo mostrano mai.';

  @override
  String get addTravelHide => 'Nascondi in modalità viaggio';

  @override
  String get addTravelHidePremium => 'Nascondi in modalità viaggio (Premium)';

  @override
  String get addTravelHideHelp =>
      'Quando la modalità viaggio è attiva (Impostazioni), questo account sparisce dall\'app finché non la disattivi.';

  @override
  String get addTravelNeedsPremium =>
      'La modalità viaggio fa parte di Premium. Ottienilo in Impostazioni > Ottieni Premium.';

  @override
  String get addAdvanced => 'Avanzate';

  @override
  String get addAdvancedExisting =>
      'Modificale solo se te l\'ha detto il sito web. Impostazioni sbagliate generano codici sbagliati, e il sito web li rifiuterà.';

  @override
  String get addAdvancedNew =>
      'La maggior parte dei siti web usa le impostazioni normali. Modificale solo se te l\'ha detto il sito web.';

  @override
  String get addType => 'Tipo';

  @override
  String get addTypeTotp => 'A tempo (normale)';

  @override
  String get addTypeHotp => 'A contatore (nuovo codice quando lo chiedi)';

  @override
  String get addDigits => 'Cifre';

  @override
  String get addAlgorithm => 'Algoritmo';

  @override
  String get addSha1Normal => 'SHA-1 (normale)';

  @override
  String get addPeriod => 'Nuovo codice ogni';

  @override
  String addSeconds(int seconds) {
    return '$seconds secondi';
  }

  @override
  String get addCounter => 'Contatore';

  @override
  String get addCounterHelp => 'Quanti codici sono stati usati finora';

  @override
  String get addNotASharedFile =>
      'Quel file non è un account condiviso di Tanooki Auth. Chiedi alla persona di condividerlo di nuovo.';

  @override
  String addAlreadyInList(String name) {
    return '$name è già nel tuo elenco.';
  }

  @override
  String get addThisAccount => 'Aggiungere questo account?';

  @override
  String get addNoCameraWindows =>
      'Su Windows Tanooki Auth non può usare la fotocamera. Apri un\'immagine del codice QR oppure incolla il link di configurazione.';

  @override
  String get addFromGoogle => 'Trasferisci da Google Authenticator';

  @override
  String get addFromGoogleSteps =>
      'Sul dispositivo con Google Authenticator:\n\n1. Apri Google Authenticator.\n2. Tocca il menu (☰ o ⋮), poi \"Trasferisci account\", poi \"Esporta account\".\n3. Scegli gli account e tocca Avanti. Comparirà un codice QR.\n\nPoi scansiona quel codice QR qui. Se ne mostra più di uno, scansionali tutti.';

  @override
  String get addScan => 'Scansiona';

  @override
  String get addOpenPicture => 'Apri immagine';

  @override
  String get addLookingOnScreen => 'Cerco un codice QR sullo schermo…';

  @override
  String get addScreenNoQr =>
      'Nessun codice QR trovato sullo schermo. Assicurati che il codice sia visibile per intero e non coperto da un\'altra finestra, poi riprova.';

  @override
  String get addScreenUnsupported =>
      'La scansione dello schermo richiede macOS 14 (Sonoma) o successivo. Fai uno screenshot e usa \"Apri un\'immagine\".';

  @override
  String get addScreenFailed =>
      'Impossibile catturare lo schermo. Fai uno screenshot e usa \"Apri un\'immagine\".';

  @override
  String get addScreenWrongQr =>
      'Ho trovato un codice QR sullo schermo, ma non è un codice di configurazione a due fattori.';

  @override
  String get addScreenPermissionTitle =>
      'Consenti a Tanooki Auth di vedere lo schermo';

  @override
  String get addScreenPermissionSteps =>
      'Per leggere un codice QR dallo schermo, il Mac deve consentire a Tanooki Auth di catturarlo. Tanooki Auth guarda solo quando premi \"Scansiona il mio schermo\", e l\'immagine non lascia mai questo Mac.\n\n1. Apri Impostazioni di Sistema (l\'icona a forma di ingranaggio nel Dock, oppure menu Apple > Impostazioni di Sistema).\n2. Fai clic su \"Privacy e sicurezza\" nella colonna a sinistra.\n3. Fai clic su \"Registrazione schermo e audio di sistema\".\n4. Attiva l\'interruttore accanto a Tanooki Auth. Se non è nell\'elenco, fai clic su +, scegli Tanooki Auth da Applicazioni e attivalo.\n5. Il Mac chiederà di chiudere Tanooki Auth. Fai clic su \"Esci e riapri\", poi premi di nuovo \"Scansiona il mio schermo\".';

  @override
  String get addPasteLinksTitle => 'Incolla link di configurazione';

  @override
  String get addPasteLinksHint =>
      'otpauth://totp/...\nUn link per riga. Puoi incollarne molti insieme.';

  @override
  String addManyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aggiungere $count account?',
      one: 'Aggiungere 1 account?',
    );
    return '$_temp0';
  }

  @override
  String addManyBadLines(int count) {
    return '$count righe non utilizzabili; dopo vedrai quali.';
  }

  @override
  String get addEnterKey => 'Inserisci chiave di configurazione';

  @override
  String get addSetupKey => 'Chiave di configurazione';

  @override
  String get addSetupKeyHelp => 'Le lettere e i numeri mostrati dal sito web';

  @override
  String get addBadKey =>
      'Quella chiave di configurazione non è valida. Deve contenere solo lettere A–Z e numeri 2–7.';

  @override
  String get addTitle => 'Aggiungi account';

  @override
  String get addScanQr => 'Scansiona codice QR';

  @override
  String get addScanQrHelp => 'Inquadra il codice mostrato dal sito web';

  @override
  String addNoCameraOn(String platform) {
    return 'Fotocamera non supportata su $platform';
  }

  @override
  String get addScanScreen => 'Scansiona il mio schermo';

  @override
  String get addScanScreenHelp =>
      'Legge un codice QR visibile in qualsiasi punto dello schermo';

  @override
  String get addScanScreenLinux =>
      'Non ancora disponibile su Linux. Apri invece uno screenshot del codice QR.';

  @override
  String get addFromPhotos => 'Scansiona un codice QR dalle tue foto';

  @override
  String get addFromPicture => 'Apri un\'immagine di un codice QR';

  @override
  String get addFromPhotosHelp =>
      'Scegli uno screenshot della pagina di configurazione';

  @override
  String get addFromPictureHelp =>
      'Va bene uno screenshot della pagina di configurazione';

  @override
  String get addPasteLink => 'Incolla link di configurazione';

  @override
  String get addPasteLinkHelp => 'Link che iniziano con otpauth://, uno o più';

  @override
  String get addOpenShared => 'Apri un account condiviso';

  @override
  String addOpenSharedHelp(String extension) {
    return 'Un file .$extension che qualcuno ti ha inviato';
  }

  @override
  String get addFromGoogleHelp =>
      'Porta qui tutti i tuoi account in un colpo solo';

  @override
  String get addFromOtherApp => 'Trasferisci da un\'altra app';

  @override
  String get addFromOtherAppHelp =>
      'Aegis, 2FAS, Authy, Bitwarden, 1Password, Apple Passwords, Microsoft';

  @override
  String get addEnterKeyHelp =>
      'Digita la chiave mostrata sotto \"non riesci a scansionare il codice?\"';

  @override
  String get addWrongQr =>
      'Quel codice QR non è un codice di configurazione a due fattori.';

  @override
  String get addCameraDenied =>
      'Tanooki Auth non ha il permesso di usare la fotocamera. Attiva l\'accesso alla fotocamera per Tanooki Auth nelle Impostazioni del dispositivo, oppure torna indietro e usa un\'immagine o la chiave di configurazione.';

  @override
  String addCameraFailed(String problem) {
    return 'Impossibile avviare la fotocamera ($problem). Torna indietro e usa un\'immagine o la chiave di configurazione.';
  }

  @override
  String get helpNew030a =>
      'Guide passo passo per attivare la 2FA su 40 siti popolari. Quando aggiungi o modifichi un account per cui abbiamo una guida, trovi un link.';

  @override
  String get helpNew030b =>
      'Un breve tour di benvenuto la prima volta che apri l\'app. Rivedilo in Impostazioni > Aiuto.';

  @override
  String get helpNew030c =>
      'Invia un feedback da Impostazioni > Aiuto. Non include mai i tuoi account o codici.';

  @override
  String get helpNew030d => 'Questa pagina Novità.';

  @override
  String get helpNew030e =>
      'Importa da Apple Passwords e sposta i tuoi account su Aegis, 2FAS o Google Authenticator.';

  @override
  String get helpNew030f =>
      'Codici Steam Guard, codici a contatore con un pulsante \"Codice successivo\" e impostazioni avanzate del codice con anteprima in tempo reale.';

  @override
  String get helpNew030g =>
      'Cartelle, selezione di più account insieme, ordinamento dalla A alla Z o per uso recente e \"Riordina i nomi degli account\".';

  @override
  String get helpNew030h =>
      'Mostra il codice QR di un account (dopo Face ID o il codice d\'accesso) per spostarlo su un altro dispositivo.';

  @override
  String get helpNew030i =>
      'Sblocca con una chiave di sicurezza come una YubiKey (Premium), su iPhone, Mac e PC Windows più recenti.';

  @override
  String get helpNew030j =>
      'Account \"Chiedi prima\" che richiedono Face ID o il codice d\'accesso prima di mostrare il codice, e modalità viaggio per nascondere gli account scelti (Premium).';

  @override
  String get helpNew030k =>
      'Cronologia attività (Premium), controllo dell\'orologio \"I codici non funzionano?\", Prova un backup, blocco in stop e promemoria per i backup.';

  @override
  String get helpNew030l =>
      'Accesso d\'emergenza: permetti a una persona di fiducia di chiedere i tuoi account, con qualche giorno di tempo per dire di no.';

  @override
  String get helpNew030m =>
      'Ricerca Spotlight, una Live Activity per il codice copiato e una complicazione per il quadrante (Premium), Copia all\'apertura e \"Cancella dopo un incolla\" su Mac.';

  @override
  String get helpNew030n =>
      'Stili del conto alla rovescia, un colore o un\'emoji per ogni account, Leggi ad alta voce, un font facile da leggere e un supporto migliore per i lettori di schermo.';

  @override
  String get helpNew030o =>
      'Un layout ampio per le finestre grandi e icone Premium stagionali.';

  @override
  String get helpNew030p =>
      'Acquista Premium nell\'app su iPhone e Android, regalalo e invita gli amici.';

  @override
  String get helpNew030q =>
      'Cassaforte del team per condividere codici con un massimo di 10 persone. Il piano team arriverà presto.';

  @override
  String get helpNew030r => 'Il piano Famiglia arriverà presto.';

  @override
  String get helpNew030s =>
      'L\'app desktop ora funziona anche su Linux. I download per Linux arriveranno presto.';

  @override
  String get helpNew020a =>
      'Sincronizzazione tra i tuoi dispositivi, collegamento del telefono per l\'estensione del browser e condivisione sicura di un singolo account.';

  @override
  String get helpNew020b =>
      'Codice d\'accesso, blocco automatico, cancellazione d\'emergenza, codice d\'accesso fittizio, blocco degli screenshot, controllo e avvisi di violazione.';

  @override
  String get helpNew020c =>
      'Widget, app per Apple Watch e Wear OS, barra dei menu del Mac e area di notifica di Windows, e backup cifrati automatici (Premium).';

  @override
  String get helpNew020d =>
      'Importazione da Aegis, 2FAS, Authy, Bitwarden e 1Password, più preferiti, tag, note, codici di recupero e Cestino.';

  @override
  String get helpNew010a =>
      'La prima versione: scansiona o incolla account, vedi i codici, backup cifrati e l\'estensione del browser.';

  @override
  String helpNoBrowser(String url) {
    return 'Impossibile aprire il browser. La pagina è $url';
  }

  @override
  String helpGuideFor(String name) {
    return 'Come attivare la 2FA per $name';
  }

  @override
  String get helpTourWelcome => 'Benvenuto in Tanooki Auth';

  @override
  String get helpTourWelcomeBody =>
      'Molti siti web possono chiederti un codice a 6 cifre oltre alla password. È l\'autenticazione a due fattori, o 2FA. Tanooki Auth crea quei codici per te, qui sul tuo dispositivo, così chi conosce solo la tua password non può comunque entrare.';

  @override
  String get helpTourAdd => 'Aggiungi il tuo primo account';

  @override
  String get helpTourAddBody =>
      'Attiva la 2FA nelle impostazioni di sicurezza di un sito web. Ti mostrerà un codice QR: scansionalo qui, oppure copia il suo link di configurazione e incollalo. Usi già un\'altra app di autenticazione? Porta qui i tuoi account in un colpo solo.';

  @override
  String get helpTourScanOrPaste => 'Scansiona un codice QR o incolla un link';

  @override
  String get helpTourImport => 'Importa da un\'altra app';

  @override
  String get helpTourPopular => 'Siti popolari da proteggere per primi';

  @override
  String get helpTourPopularBody =>
      'La tua email, i tuoi social e ovunque ci siano i tuoi soldi sono le cose più importanti. Le nostre guide passo passo mostrano dove si trova l\'impostazione 2FA su ogni sito.';

  @override
  String get helpAllGuides => 'Tutte le guide 2FA';

  @override
  String helpTourStep(int step, int total) {
    return 'Passo $step di $total';
  }

  @override
  String get helpTourSkip => 'Salta il tour';

  @override
  String get helpWhatsNew => 'Novità';

  @override
  String helpVersion(String version) {
    return 'Versione $version';
  }

  @override
  String helpVersionThis(String version) {
    return 'Versione $version (questa versione)';
  }

  @override
  String get helpFeedbackEmpty => 'Prima scrivi un messaggio.';

  @override
  String get helpFeedbackSent =>
      'Inviato. Grazie! Maddie legge ogni messaggio.';

  @override
  String get helpFeedbackTooLong =>
      'È troppo lungo da inviare. Accorcialo un po\' (al massimo circa 4.000 caratteri).';

  @override
  String get helpFeedbackTooMany =>
      'Hai inviato molti feedback nell\'ultima ora. Riprova tra un\'ora.';

  @override
  String get helpFeedbackOffline =>
      'Impossibile connettersi a internet. Controlla la connessione e riprova. Il tuo messaggio è ancora qui.';

  @override
  String get helpFeedbackServerError =>
      'Il server dei feedback ha avuto un problema e non ha ricevuto il tuo messaggio. Riprova più tardi. Il tuo messaggio è ancora qui.';

  @override
  String get helpFeedbackTitle => 'Invia feedback';

  @override
  String get helpFeedbackIntro =>
      'Hai trovato un bug, o vorresti che l\'app facesse qualcosa? Dillo a Maddie qui.';

  @override
  String get helpFeedbackMessage => 'Il tuo messaggio';

  @override
  String get helpFeedbackEmail => 'La tua email (facoltativa)';

  @override
  String get helpFeedbackEmailHelp => 'Solo se vuoi una risposta.';

  @override
  String get helpFeedbackDevice =>
      'Includi versione dell\'app e tipo di dispositivo';

  @override
  String get helpFeedbackDeviceHelp =>
      'Per esempio \"0.3.0\" e \"iOS\". Aiuta a scovare i bug.';

  @override
  String get helpFeedbackNeverSent =>
      'Mai inviati: i tuoi account, i loro nomi, codici, chiavi di configurazione, tag, note o qualsiasi altra cosa nell\'app.';

  @override
  String get helpFeedbackSend => 'Invia';

  @override
  String get phoneUiPushAndroid =>
      'Le notifiche su Android non sono ancora attive, quindi le richieste compaiono mentre Tanooki Auth è aperta.';

  @override
  String get phoneUiPushThisDevice =>
      'Questo dispositivo riceve le richieste mentre Tanooki Auth è aperta.';

  @override
  String get phoneUiPushNoToken =>
      'L\'iPhone non ha fornito all\'app un token per le notifiche.';

  @override
  String get phoneUiPushDenied =>
      'Le notifiche sono disattivate per Tanooki Auth. Attivale nell\'app Impostazioni dell\'iPhone, in Notifiche, per ricevere le richieste quando l\'app è chiusa.';

  @override
  String phoneUiPushFailed(String problem) {
    return 'Impossibile attivare le notifiche: $problem. Le richieste compaiono comunque mentre Tanooki Auth è aperta.';
  }

  @override
  String get phoneUiPushNotInBuild =>
      'Le notifiche non sono disponibili in questa build. Le richieste compaiono mentre Tanooki Auth è aperta.';

  @override
  String get phoneUiPushChecking => 'Controllo se le notifiche funzionano…';

  @override
  String get phoneUiRequest => 'Richiesta di un codice per accedere';

  @override
  String get phoneUiNoAccount =>
      'Nessun account salvato per questo sito web, quindi non c\'è nulla da inviare. Se te ne aspettavi uno, potrebbe essere un sito falso che finge di essere quello vero.';

  @override
  String get phoneUiWantsCode =>
      'Il browser abbinato vuole il codice per questo sito web. Approva solo se stai accedendo proprio ora.';

  @override
  String get phoneUiApprove => 'Approva';

  @override
  String phoneUiApproveAccount(String name) {
    return 'Approva: $name';
  }

  @override
  String get phoneUiScanTitle => 'Scansiona il codice del browser';

  @override
  String get phoneUiScanWrong =>
      'Non è un codice di abbinamento del browser. Nel browser, fai clic sull\'estensione Tanooki Auth, poi su \"Usa il mio telefono\".';

  @override
  String get phoneUiPasteTitle => 'Incolla il link di abbinamento';

  @override
  String get phoneUiPair => 'Abbina';

  @override
  String get phoneUiPaired =>
      'Abbinato. Quando quel browser chiederà un codice, lo vedrai qui.';

  @override
  String get phoneUiExpired =>
      'Quel codice è scaduto. Nel browser, creane uno nuovo e scansionalo di nuovo.';

  @override
  String get phoneUiPremium =>
      'Usare il telefono con un browser fa parte di Premium';

  @override
  String get phoneUiIntro =>
      'Inserisci i codici in un browser su qualsiasi computer, anche senza l\'app Tanooki Auth. L\'estensione del browser chiede e tu tocchi Approva qui. I codici viaggiano con cifratura end-to-end, e solo per il sito web per cui è salvato ogni account.';

  @override
  String get phoneUiPairBrowser => 'Abbina un browser';

  @override
  String get phoneUiPairHelp =>
      'Nel browser, fai clic sull\'estensione Tanooki Auth, poi su \"Usa il mio telefono\" per mostrare il codice.';

  @override
  String get phoneUiPairedBrowsers => 'Browser abbinati';

  @override
  String get phoneUiNoneYet => 'Ancora nessuno';

  @override
  String get phoneUiBrowser => 'Browser';

  @override
  String phoneUiPairedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Abbinato il $dateString';
  }

  @override
  String get phoneUiUnpair => 'Disabbina';

  @override
  String get phoneUiPushOn => 'Notifiche attive';

  @override
  String get phoneUiPushOff => 'Le richieste compaiono mentre l\'app è aperta';

  @override
  String get phoneUiPushOnHelp =>
      'Riceverai una notifica per ogni richiesta, anche quando Tanooki Auth è chiusa.';

  @override
  String phoneUiSendCodeFor(String name) {
    return 'Invia il codice per $name';
  }

  @override
  String get phoneUiActivityWhere => 'Browser, tramite questo telefono';

  @override
  String get premiumFiveOnce => '5 \$ una volta';

  @override
  String get premiumPayOnce => 'Paga una volta';

  @override
  String get premiumCheckoutSoon =>
      'Il pagamento non è ancora aperto; arriverà prestissimo. Grazie per voler sostenere Tanooki Auth!';

  @override
  String get premiumEnterKeyTitle => 'Inserisci la chiave di licenza';

  @override
  String get premiumEnterKeyHint => 'TA1.…  (dalla email di acquisto)';

  @override
  String get premiumBadKey =>
      'Quella chiave di licenza non è valida. Copia la chiave completa dalla email di acquisto e riprova.';

  @override
  String premiumInvitesNowFamily(int count) {
    return '$count amici hanno acquistato Premium con il tuo link, quindi ora la tua chiave è una chiave Famiglia per un massimo di 5 persone. È installata su questo dispositivo. Copia la nuova chiave qui sotto e inseriscila anche sugli altri tuoi dispositivi.';
  }

  @override
  String premiumInvitesAlreadyFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count amici hanno acquistato Premium con il tuo link. La tua chiave è già una chiave Famiglia.',
      one: '1 amico ha acquistato Premium con il tuo link. La tua chiave è già una chiave Famiglia.',
    );
    return '$_temp0';
  }

  @override
  String premiumInvitesProgress(int count, int needed, int left) {
    return '$count amici su $needed hanno acquistato Premium con il tuo link. Ancora $left e la tua chiave diventa una chiave Famiglia.';
  }

  @override
  String get premiumInviteLinkCopied => 'Link d\'invito copiato.';

  @override
  String get premiumKeyCopied => 'Chiave di licenza copiata.';

  @override
  String premiumJustMe(String price) {
    return 'Solo io — $price';
  }

  @override
  String premiumFamilyPrice(String price) {
    return 'Famiglia (fino a 5 persone) — $price';
  }

  @override
  String get premiumFamilyApple =>
      'Famiglia: condiviso con la tua famiglia Apple tramite In famiglia, più una chiave di licenza per un massimo di 5 persone su qualsiasi dispositivo.';

  @override
  String get premiumFamilyKey =>
      'Famiglia: una chiave di licenza da condividere con un massimo di altre 4 persone.';

  @override
  String get premiumYourKey => 'La tua chiave di licenza';

  @override
  String get premiumYourKeyHelp =>
      'Inseriscila sugli altri tuoi dispositivi: Impostazioni → Ottieni Premium → \"Già acquistato? Inserisci la chiave di licenza\".';

  @override
  String get premiumCopyKey => 'Copia chiave';

  @override
  String get premiumInviteFriends => 'Invita amici';

  @override
  String get premiumInviteHelp =>
      'Gli amici hanno il 20% di sconto. Quando 3 amici acquistano, la tua chiave diventa una chiave Famiglia.';

  @override
  String get premiumGetInvite => 'Ottieni il mio link d\'invito';

  @override
  String get premiumCheckInvites => 'Controlla i miei inviti';

  @override
  String get premiumYouHave => 'Hai Premium';

  @override
  String get premiumTitle => 'Tanooki Auth Premium';

  @override
  String get premiumOwnedFamily =>
      'Piano Famiglia: condividi la tua chiave di licenza con un massimo di altre 4 persone (5 in tutto). Grazie per sostenere Tanooki Auth.';

  @override
  String get premiumOwnedThanks => 'Grazie per sostenere Tanooki Auth.';

  @override
  String get premiumPitchStripe =>
      '5 \$ una volta, o 10 \$ per tutta la famiglia. Tuo per sempre.';

  @override
  String get premiumPitchStore =>
      'Paga una volta per te, o una volta per tutta la famiglia. Tuo per sempre.';

  @override
  String get premiumPerkThemes => 'Tutti i temi Premium';

  @override
  String premiumPerkThemesBody(int count) {
    return 'Rosa pastello, Azzurro pastello e altri $count, temi stagionali che cambiano da soli, fino a 3 temi tuoi, più ogni tema aggiunto in futuro.';
  }

  @override
  String get premiumPerkIcons => 'Icone dell\'app';

  @override
  String premiumPerkIconsBody(int count) {
    return 'Scegli un\'icona diversa per la schermata Home su iPhone e Android, in Rosa pastello, Azzurro pastello e altri $count colori, più quelle stagionali per autunno, inverno e primavera. Su Mac cambia l\'icona nel Dock mentre l\'app è aperta.';
  }

  @override
  String get premiumPerkSync => 'Sincronizzazione tra i tuoi dispositivi';

  @override
  String get premiumPerkSyncBody =>
      'Aggiungi un account su un dispositivo e lo vedi su tutti, con cifratura end-to-end. Tramite iCloud sui dispositivi Apple, o il relay Tanooki per qualsiasi combinazione.';

  @override
  String get premiumPerkApprove => 'Approva i codici dal telefono';

  @override
  String get premiumPerkApproveBody =>
      'Usa l\'estensione del browser su qualsiasi computer: chiede al tuo telefono, tu tocchi Approva e il codice viene inserito.';

  @override
  String get premiumPerkBreach => 'Avvisi di violazione';

  @override
  String get premiumPerkBreachBody =>
      'Ricevi un avviso quando un sito web dove hai un account è coinvolto in una violazione di dati nota. Il controllo avviene sul tuo dispositivo; nessun dato su di te viene inviato.';

  @override
  String get premiumPerkShare => 'Condividi un account in modo sicuro';

  @override
  String get premiumPerkShareBody =>
      'Dai un account a una persona di fiducia con un codice QR e un codice a 6 cifre. Protetto, scade in 24 ore, nessun server.';

  @override
  String get premiumPerkFamily => 'Piano Famiglia';

  @override
  String get premiumPerkFamilyStripe =>
      'Per 10 \$ invece di 5 \$, una sola chiave sblocca Premium per un massimo di 5 persone. Inviala alla tua famiglia e la inseriranno come fai tu.';

  @override
  String get premiumPerkFamilyStore =>
      'Un solo acquisto Famiglia sblocca Premium per un massimo di 5 persone. Invia loro la tua chiave di licenza e la inseriranno come fai tu.';

  @override
  String get premiumPerkFuture => 'Ogni futura funzione Premium';

  @override
  String get premiumPerkFutureBody =>
      'Paga una volta e ottieni tutto ciò che Premium diventerà. Nessun abbonamento, mai.';

  @override
  String get premiumPerkFree => 'Mantiene gratuite le app per la privacy';

  @override
  String get premiumPerkFreeStripe =>
      'I tuoi 5 \$ mi permettono di continuare a creare app gratuite che non ti tracciano.';

  @override
  String get premiumPerkFreeStore =>
      'Acquistare Premium mi permette di continuare a creare app gratuite che non ti tracciano.';

  @override
  String get premiumFreeForever =>
      'Gratis per sempre, con o senza Premium: account illimitati, scansione, backup, l\'estensione del browser e il blocco dell\'app.';

  @override
  String get premiumFamilySoon => 'Piano Famiglia in arrivo';

  @override
  String get premiumFamilyKeyEach =>
      'Famiglia: una chiave di licenza da condividere con un massimo di altre 4 persone. Ognuna la inserisce nel proprio Tanooki Auth.';

  @override
  String get premiumRestore => 'Ripristina acquisti';

  @override
  String get premiumAlreadyBought =>
      'Già acquistato? Inserisci la chiave di licenza';

  @override
  String get premiumDesktopKeySoon =>
      'La chiave per desktop per gli acquisti Android arriverà presto. Premium è già sbloccato su questo telefono; una chiave di licenza per i tuoi computer comparirà qui in un prossimo aggiornamento.';

  @override
  String premiumGift(String price) {
    return 'Regala Premium — $price';
  }

  @override
  String premiumGiftFamily(String price) {
    return 'Regala il piano Famiglia — $price';
  }

  @override
  String get premiumGiftHelp =>
      'Dopo il pagamento ricevi un buono regalo stampabile con una chiave per chi lo riceve.';

  @override
  String get settingsIconFailed =>
      'Impossibile cambiare l\'icona dell\'app. Riprova o riavvia l\'app.';

  @override
  String settingsIconFailedWhy(String problem) {
    return 'Impossibile cambiare l\'icona dell\'app ($problem). Riprova o riavvia l\'app.';
  }

  @override
  String settingsIconSemantic(String name) {
    return 'Icona dell\'app $name';
  }

  @override
  String settingsIconSemanticPremium(String name) {
    return 'Icona dell\'app $name, Premium';
  }

  @override
  String get settingsAppIcon => 'Icona dell\'app';

  @override
  String get settingsAppIconPremium => 'Icona dell\'app (Premium)';

  @override
  String get settingsAppIconIos => 'L\'icona nella schermata Home.';

  @override
  String get settingsAppIconAndroid =>
      'L\'icona nella schermata Home. Potrebbe sparire per un attimo mentre il telefono la sostituisce.';

  @override
  String get settingsAppIconMac =>
      'Cambia l\'icona nel Dock mentre Tanooki Auth è aperta. I Mac non possono mantenere un\'icona diversa dopo la chiusura dell\'app, quindi Finder e Launchpad mostrano quella blu.';

  @override
  String get settingsAppIconOther =>
      'Le icone dell\'app si possono cambiare su iPhone e Android.';

  @override
  String get settingsLockNameMac => 'Touch ID o la password del Mac';

  @override
  String get settingsLockNamePhone => 'Face ID, impronta digitale o codice';

  @override
  String settingsNoLockSetUp(String lock) {
    return 'Su questo dispositivo non è configurato $lock, quindi l\'app non può essere bloccata. Configuralo prima nelle impostazioni di sistema.';
  }

  @override
  String get settingsLockReasonOn => 'Attiva il blocco dell\'app';

  @override
  String get settingsLockReasonOff => 'Disattiva il blocco dell\'app';

  @override
  String get settingsSetPasscode => 'Imposta un codice d\'accesso';

  @override
  String get settingsSetPasscodeIntro =>
      'Digitalo per aprire Tanooki Auth. Funziona anche quando Face ID o l\'impronta digitale non funzionano. Se lo dimentichi, l\'unico modo per rientrare è un backup.';

  @override
  String get settingsPasscodeOn => 'Codice d\'accesso attivo.';

  @override
  String get settingsPasscode => 'Codice d\'accesso';

  @override
  String get settingsChangePasscode => 'Cambia codice d\'accesso';

  @override
  String get settingsPasscodeOff => 'Disattiva codice d\'accesso';

  @override
  String get settingsNewPasscode => 'Nuovo codice d\'accesso';

  @override
  String get settingsPasscodeChanged => 'Codice d\'accesso cambiato.';

  @override
  String get settingsPasscodeIsOff => 'Codice d\'accesso disattivato.';

  @override
  String get settingsRemoveDecoyTitle =>
      'Rimuovere il codice d\'accesso fittizio?';

  @override
  String get settingsRemoveDecoyBody =>
      'Gli account fittizi vengono cancellati. I tuoi account veri restano intatti.';

  @override
  String get settingsSetDecoy => 'Imposta un codice d\'accesso fittizio';

  @override
  String get settingsSetDecoyIntro =>
      'Se qualcuno ti costringe ad aprire Tanooki Auth, digita questo. Apre un insieme di account separato e vuoto, e niente sullo schermo fa capire che non è quello vero. Aggiungi lì un paio di account innocui così sembra usato.\n\nIl tuo vero codice d\'accesso continua ad aprire i tuoi account veri.';

  @override
  String get settingsDecoySet => 'Codice d\'accesso fittizio impostato.';

  @override
  String settingsWipeTitle(int count) {
    return 'Cancellare tutto dopo $count codici d\'accesso errati?';
  }

  @override
  String settingsWipeBody(int count) {
    return 'Se qualcuno digita il codice d\'accesso sbagliato $count volte di fila, Tanooki Auth cancella tutti gli account su questo dispositivo. Non si può annullare e, una volta iniziato, non si può fermare.';
  }

  @override
  String get settingsWipeSureTitle => 'Sei sicuro?';

  @override
  String get settingsWipeSureBody =>
      'Può attivarlo un bambino che gioca con il tuo telefono, o tu in una giornata storta. Dopo la cancellazione, l\'unico modo per recuperare è il tuo file di backup. Senza, potresti restare chiuso fuori da tutti i siti web che usano questi codici.';

  @override
  String get settingsWipeTurnOn => 'Attiva la cancellazione d\'emergenza';

  @override
  String get settingsTravelOffReason => 'Disattiva la modalità viaggio';

  @override
  String get settingsTravelOnNone =>
      'Modalità viaggio attiva, ma nessun account è ancora contrassegnato \"Nascondi in modalità viaggio\". Prima contrassegnali con ⋯ > Modifica.';

  @override
  String settingsTravelOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Modalità viaggio attiva. $count account sono nascosti.',
      one: 'Modalità viaggio attiva. 1 account è nascosto.',
    );
    return '$_temp0';
  }

  @override
  String get settingsTravelOff =>
      'Modalità viaggio disattivata. Tutti gli account sono tornati.';

  @override
  String get settingsCheckingClock => 'Controllo l\'orologio…';

  @override
  String get settingsClockRight =>
      'L\'orologio è giusto, quindi non è quello il problema. Controlla che le impostazioni dell\'account (⋯ > Modifica > Avanzate) corrispondano a quanto indicato dal sito web.';

  @override
  String settingsClockFailed(String problem) {
    return 'Impossibile controllare l\'orologio: $problem';
  }

  @override
  String get settingsLockApp => 'Blocca l\'app';

  @override
  String settingsLockAppHelp(String lock) {
    return 'Chiedi $lock all\'apertura dell\'app';
  }

  @override
  String get settingsPasscodeOnHelp =>
      'Attivo. Tocca per cambiarlo o disattivarlo.';

  @override
  String settingsPasscodeOffHelp(String lock) {
    return 'Disattivo. Numeri da digitare per aprire l\'app, al posto di $lock o in aggiunta.';
  }

  @override
  String get settingsLockAgain => 'Blocca di nuovo';

  @override
  String settingsLockAgainHelp(String time) {
    return '$time in background';
  }

  @override
  String get settingsLockFirst =>
      'Prima attiva il blocco o un codice d\'accesso';

  @override
  String get settingsDecoy => 'Codice d\'accesso fittizio';

  @override
  String get settingsDecoyOn =>
      'Attivo. Apre un insieme di account separato. Tocca per rimuoverlo.';

  @override
  String get settingsDecoyOff =>
      'Un secondo codice d\'accesso che apre un insieme di account separato e vuoto';

  @override
  String settingsWipe(int count) {
    return 'Cancella dopo $count codici errati';
  }

  @override
  String get settingsWipeHelp =>
      'Cancellazione d\'emergenza. Richiede un backup fatto negli ultimi 30 giorni.';

  @override
  String get settingsLockOnSleep => 'Blocca quando il computer va in stop';

  @override
  String get settingsLockOnSleepHelp =>
      'Anche quando lo schermo si blocca o esci per un momento';

  @override
  String get settingsLockOnSleepNeedsLock =>
      'Prima attiva \"Blocca l\'app\" o un codice d\'accesso, così c\'è qualcosa da bloccare.';

  @override
  String get settingsTravel => 'Modalità viaggio';

  @override
  String get settingsTravelPremium => 'Modalità viaggio (Premium)';

  @override
  String get settingsTravelOnHelp =>
      'Attiva. Gli account contrassegnati \"Nascondi in modalità viaggio\" spariscono da schermate, widget, orologio, estensione ed esportazioni di questo dispositivo finché non la disattivi. Non vengono eliminati.';

  @override
  String settingsTravelOffHelp(String proof) {
    return 'Prima di passare una frontiera: nasconde gli account che hai contrassegnato \"Nascondi in modalità viaggio\" (⋯ > Modifica). Per disattivarla serve $proof.';
  }

  @override
  String get settingsKeys => 'Chiavi di sicurezza';

  @override
  String get settingsKeysPremium => 'Chiavi di sicurezza (Premium)';

  @override
  String get settingsKeysHelp =>
      'Sblocca con una YubiKey o un\'altra chiave di sicurezza';

  @override
  String get settingsActivity => 'Cronologia attività';

  @override
  String get settingsActivityPremium => 'Cronologia attività (Premium)';

  @override
  String get settingsActivityHelp =>
      'Quali codici sono stati copiati, inseriti, digitati o esportati, e quando. Conservata solo su questo dispositivo.';

  @override
  String get settingsEmergency => 'Accesso d\'emergenza';

  @override
  String get settingsEmergencyPremium => 'Accesso d\'emergenza (Premium)';

  @override
  String get settingsEmergencyHelp =>
      'Permetti a una persona di fiducia di ottenere i tuoi account se ti succede qualcosa, dopo un\'attesa di 7 giorni che puoi interrompere';

  @override
  String get settingsTeamHelp =>
      'Condividi i codici per accedere con un massimo di 10 persone, con cifratura end-to-end';

  @override
  String get settingsMonthly => 'Notifica di riepilogo mensile';

  @override
  String get settingsMonthlyPremium =>
      'Notifica di riepilogo mensile (Premium)';

  @override
  String get settingsMonthlyHelp =>
      'Un promemoria il 1° di ogni mese per dare un\'occhiata alla scheda di riepilogo. Non dice mai nulla sui tuoi account.';

  @override
  String get settingsBlockShots => 'Blocca gli screenshot';

  @override
  String get settingsBlockShotsDesktop =>
      'Nasconde questa finestra da screenshot, registrazioni e condivisione dello schermo';

  @override
  String get settingsBlockShotsPhone =>
      'Tiene i codici fuori da screenshot, registrazioni dello schermo e selettore delle app';

  @override
  String get settingsCheckup => 'Controllo di sicurezza';

  @override
  String get settingsCheckupHelp =>
      'Cose da sistemare e il tuo kit di recupero';

  @override
  String get settingsBreachPremium => 'Avvisi di violazione (Premium)';

  @override
  String get settingsBreachOn =>
      'Attivi. Controlla ogni settimana l\'elenco pubblico delle violazioni.';

  @override
  String get settingsBreachOff =>
      'Disattivi. Se attivi, l\'app scarica l\'elenco pubblico delle violazioni una volta a settimana.';

  @override
  String settingsThemeSemantic(String name) {
    return 'Tema $name';
  }

  @override
  String settingsThemeSemanticPremium(String name) {
    return 'Tema $name, Premium';
  }

  @override
  String get settingsPremiumThanks => 'Premium: grazie!';

  @override
  String get settingsGetPremium => 'Ottieni Premium';

  @override
  String get settingsPremiumThanksHelp =>
      'Tutti i temi e le future funzioni Premium sono tuoi.';

  @override
  String settingsGetPremiumHelp(String payOnce) {
    return '$payOnce: tutti i temi, sincronizzazione tra i tuoi dispositivi e altro.';
  }

  @override
  String get settingsAppearance => 'Aspetto';

  @override
  String get settingsCountdown => 'Stile del conto alla rovescia';

  @override
  String get settingsCountdownHelp =>
      'Come viene mostrato il tempo rimasto per ogni codice';

  @override
  String get settingsEasyFont => 'Font facile da leggere';

  @override
  String get settingsEasyFontHelp =>
      'Atkinson Hyperlegible, creato dal Braille Institute perché lettere e numeri siano difficili da confondere';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsAccountsList => 'Elenco account';

  @override
  String get settingsCompact => 'Schede compatte';

  @override
  String get settingsCompactHelp =>
      'Schede più piccole, così sullo schermo entrano più account';

  @override
  String get settingsSort => 'Ordina account';

  @override
  String settingsSortHelp(String sort) {
    return '$sort. I preferiti vengono sempre per primi.';
  }

  @override
  String get settingsSortCustom =>
      'Il tuo ordine. Tieni premuta una scheda, poi trascinala.';

  @override
  String get settingsSortRecent =>
      'Gli account da cui hai appena copiato un codice salgono in cima';

  @override
  String get settingsSortName => 'Per nome del servizio';

  @override
  String get settingsTidyHelp =>
      'Trasforma nomi come \"google.com:you@gmail.com\" in \"Google\". Vedi prima ogni modifica.';

  @override
  String get settingsHideCodes => 'Nascondi i codici finché non li tocchi';

  @override
  String get settingsHideCodesHelp =>
      'Mostra dei puntini al posto dei codici, così chi ti sta vicino non può leggerli';

  @override
  String get settingsShareCodes => 'Mostra i codici su widget e orologio';

  @override
  String get settingsShareCodesHelp =>
      'I codici dei tuoi preferiti compaiono nella schermata Home, nella schermata di blocco e sull\'orologio senza aprire questa app, quindi chiunque abbia in mano il tuo telefono sbloccato o il tuo orologio può leggerli. Aggiungi una stella a un account per renderlo un preferito.';

  @override
  String get settingsAutofill =>
      'Inserisci i codici con Riempimento automatico';

  @override
  String get settingsAutofillHelpIos =>
      'Quando un sito web o un\'app chiede un codice 2FA, l\'iPhone te lo propone sopra la tastiera, così non devi copiarlo. Gli account che chiedono prima richiedono Face ID prima dell\'inserimento. Gli account nascosti in modalità viaggio non vengono mai proposti.';

  @override
  String get settingsAutofillHelpAndroid =>
      'Quando un\'app o un sito web chiede un codice 2FA, il telefono te lo propone in un piccolo pop-up, così non devi copiarlo. Android permette la compilazione automatica a una sola app alla volta, quindi questa opzione sostituisce quella del tuo gestore di password. Se ti serve quella, lascia questa opzione disattivata.';

  @override
  String get settingsAutofillStepsTitle => 'Attiva il Riempimento automatico';

  @override
  String get settingsAutofillStepsIos =>
      'Richiede iOS 18 o successivo.\n\n1. Apri l\'app Impostazioni (l\'icona grigia a forma di ingranaggio).\n2. Tocca Generali, poi Riempimento automatico e password.\n3. Nell\'elenco delle app che possono usare il Riempimento automatico, attiva l\'interruttore accanto a Tanooki Auth.\n\nHa funzionato se l\'interruttore è verde. La prossima volta che un sito web o un\'app chiede un codice, tocca la casella del codice e poi il suggerimento di Tanooki Auth sopra la tastiera.';

  @override
  String get settingsAutofillStepsAndroid =>
      '1. Tocca Apri Impostazioni qui sotto. Si apre un elenco di app di compilazione automatica.\n2. Tocca Tanooki Auth, poi tocca OK se il telefono lo chiede.\n\nSe non si apre nessun elenco: apri l\'app Impostazioni, cerca \"Servizio di compilazione automatica\", toccalo e scegli Tanooki Auth.\n\nHa funzionato se ora Tanooki Auth risulta come servizio di compilazione automatica. La prossima volta che un\'app o un sito web chiede un codice, tocca la casella del codice e scegli Tanooki Auth nel pop-up.\n\nAndroid permette la compilazione automatica a una sola app alla volta. Scegliendo Tanooki Auth, il tuo gestore di password (come Google, Bitwarden o 1Password) smette di inserire le password. Per tornare indietro, sceglilo di nuovo nello stesso punto.';

  @override
  String get settingsAutofillOpen => 'Apri Impostazioni';

  @override
  String get settingsTrash => 'Cestino';

  @override
  String settingsTrashCount(int count) {
    return 'Cestino ($count)';
  }

  @override
  String get settingsTrashHelp =>
      'Gli account eliminati restano qui per 30 giorni';

  @override
  String get settingsWatchFace => 'Preferito sul quadrante';

  @override
  String get settingsWatchFacePremium => 'Preferito sul quadrante (Premium)';

  @override
  String get settingsWatchFaceNoFavorites =>
      'Prima aggiungi una stella a un account nell\'elenco principale. Solo i preferiti possono andare sul quadrante.';

  @override
  String get settingsNone => 'Nessuno';

  @override
  String get settingsCopying => 'Copia e scorciatoie';

  @override
  String get settingsCopyOnOpen => 'Copia all\'apertura';

  @override
  String get settingsCopyOnOpenHelp =>
      'Aprire o sbloccare l\'app copia il codice dell\'ultimo account usato. Gli account che chiedono prima di mostrare il codice vengono saltati.';

  @override
  String get settingsPasteOnce => 'Cancella dopo un incolla';

  @override
  String get settingsPasteOnceHelp =>
      'Il codice copiato si può incollare una sola volta, poi gli appunti si svuotano. Le app per la cronologia degli appunti possono contare come quell\'unico incolla. Su Windows, invece, i codici si cancellano dopo 30 secondi.';

  @override
  String get settingsSpotlight => 'Mostra gli account in Spotlight';

  @override
  String get settingsSpotlightHelp =>
      'Cerca il nome di un account da qualsiasi punto e vai subito lì. Vengono condivisi solo i nomi, mai i codici.';

  @override
  String get settingsLiveActivity =>
      'Codice sulla schermata di blocco dopo la copia';

  @override
  String get settingsLiveActivityPremium =>
      'Codice sulla schermata di blocco dopo la copia (Premium)';

  @override
  String get settingsLiveActivityHelp =>
      'Dopo aver copiato un codice, lo vedi sulla schermata di blocco e nella Dynamic Island con un conto alla rovescia fino alla scadenza.';

  @override
  String get settingsWatchFaceHelp =>
      'Scegli un preferito il cui codice compare sul quadrante dell\'Apple Watch. Richiede \"Mostra i codici su widget e orologio\" attivo.';

  @override
  String settingsWatchFaceChosen(String name) {
    return '$name. Aggiungi la complicazione di Tanooki Auth al quadrante per vederlo.';
  }

  @override
  String get settingsBrowserSection => 'Estensione del browser e launcher';

  @override
  String get settingsBridgeOff => 'Non in esecuzione';

  @override
  String get settingsBridgeOn => 'Pronto per l\'estensione del browser';

  @override
  String settingsBridgeOffHelp(String first, String last) {
    return 'Le porte $first–$last sono tutte occupate da altri programmi, quindi l\'estensione non può connettersi. Riavvia il computer e riprova.';
  }

  @override
  String settingsBridgeOnHelp(String port) {
    return 'In ascolto solo su questo computer (127.0.0.1:$port). Funziona mentre Tanooki Auth è aperta.';
  }

  @override
  String settingsPairedClient(String name) {
    return 'Abbinato: $name';
  }

  @override
  String get settingsPairedBrowser => 'Browser abbinato';

  @override
  String settingsExtensionId(String id) {
    return 'Estensione $id';
  }

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsSecurity => 'Sicurezza';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsExport => 'Esporta backup';

  @override
  String get settingsExportHelp =>
      'Un file cifrato, protetto da una passphrase scelta da te';

  @override
  String get settingsImport => 'Importa backup';

  @override
  String get settingsImportHelp =>
      'Aggiunge account da un file di backup; salta quelli che hai già';

  @override
  String get settingsTestBackup => 'Prova un backup';

  @override
  String get settingsTestBackupHelp =>
      'Controlla che un file di backup si apra con la tua passphrase. Non modifica nulla.';

  @override
  String get settingsMoveOut => 'Sposta su un\'altra app';

  @override
  String get settingsMoveOutHelp =>
      'Aegis, 2FAS, Google Authenticator o semplici link di configurazione';

  @override
  String get settingsPaper => 'Stampa backup cartaceo';

  @override
  String get settingsPaperHelp =>
      'Un PDF di codici QR e codici di recupero da tenere in un posto chiuso a chiave';

  @override
  String get settingsHelp => 'Aiuto';

  @override
  String get settingsGuidesHelp =>
      'Aiuto passo passo per attivare la 2FA sui siti popolari, sul nostro sito web';

  @override
  String get settingsTour => 'Mostra il tour di benvenuto';

  @override
  String get settingsFeedbackHelp =>
      'Racconta a Maddie un bug o un\'idea. Non include mai i tuoi account o codici.';

  @override
  String get settingsAbout => 'Info';

  @override
  String get settingsAboutMaddieHelp =>
      'Un messaggio dalla persona che crea Tanooki Auth';

  @override
  String get settingsCodesNotWorking => 'I codici non funzionano?';

  @override
  String settingsCodesNotWorkingHelp(String time) {
    return 'Ora del dispositivo $time. I codici dipendono dall\'orologio: tocca per confrontarlo con internet.';
  }

  @override
  String shareUiConfirmTitle(String name) {
    return 'Condividere $name?';
  }

  @override
  String get shareUiConfirmBody =>
      'La persona con cui lo condividi ottiene accesso completo: il suo telefono genererà gli stessi codici del tuo, finché lo tiene. Condividilo solo con qualcuno di cui ti fidi completamente, come un familiare.\n\nRimuoverlo dal tuo elenco in seguito non lo toglie a lei. Per escluderla, disattiva e riattiva l\'autenticazione a due fattori sul sito web.';

  @override
  String get shareUiConfirmButton => 'Ho capito, condividi';

  @override
  String get shareUiLocking => 'Proteggo la condivisione…';

  @override
  String shareUiTitle(String name) {
    return 'Condividi $name';
  }

  @override
  String get shareUiInstructions =>
      'Sul suo dispositivo: apri Tanooki Auth, tocca Aggiungi account, poi \"Scansiona codice QR\" (o \"Apri un account condiviso\" per il file). Poi digita questo codice:';

  @override
  String get shareUiTellCode =>
      'Comunica tu il codice, a voce o in un\'app diversa da quella del file.';

  @override
  String get shareUiSendFile => 'Invia invece come file';

  @override
  String get shareUiCopyLink => 'Copia come link';

  @override
  String get shareUiCopied =>
      'Copiato. Lo incolla con \"Incolla link di configurazione\".';

  @override
  String get shareUiWorksFor =>
      'Funziona per 24 ore, e solo con il codice. Niente passa per un server.';

  @override
  String get shareUiOpenTitle => 'Account condiviso';

  @override
  String get shareUiOpenBody =>
      'Digita il codice a 6 cifre che ti ha dato la persona che l\'ha condiviso.';

  @override
  String get shareUiUnlocking => 'Sblocco…';

  @override
  String get signatureLabel => 'Firmato, Maddie';

  @override
  String get syncUiQrCode => 'Codice QR';

  @override
  String get syncUiNotYet => 'Non ancora';

  @override
  String get syncUiJustNow => 'Proprio ora';

  @override
  String syncUiMinutesAgo(int minutes) {
    return '$minutes min fa';
  }

  @override
  String syncUiHoursAgo(int hours) {
    return '$hours h fa';
  }

  @override
  String syncUiDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get syncUiThisDevice => 'Questo dispositivo';

  @override
  String get syncUiAnotherDevice => 'Un altro dispositivo';

  @override
  String syncUiAdded(String when) {
    return 'Aggiunto $when';
  }

  @override
  String syncUiThisDeviceNamed(String name) {
    return 'Questo dispositivo ($name)';
  }

  @override
  String syncUiLastSyncedAgo(String when) {
    return 'Ultima sincronizzazione $when';
  }

  @override
  String get syncUiWhere => 'Dove vuoi sincronizzare i tuoi dispositivi?';

  @override
  String get syncUiICloudHelp =>
      'Solo per iPhone, iPad e Mac. Usa il tuo iCloud Drive.';

  @override
  String get syncUiRelay => 'Relay Tanooki';

  @override
  String get syncUiRelayHelp =>
      'Funziona con tutti i dispositivi, compresi Android e Windows. Il server conserva solo dati cifrati.';

  @override
  String get syncUiStartFreshTitle => 'Ricominciare da zero?';

  @override
  String get syncUiStartFreshBody =>
      'Se hai dimenticato la passphrase usata dagli altri tuoi dispositivi Apple, puoi avviare una nuova sincronizzazione con questa. Gli altri dispositivi dovranno poi disattivare e riattivare la sincronizzazione con la nuova passphrase.';

  @override
  String get syncUiStartFresh => 'Ricomincia da zero';

  @override
  String get syncUiOn => 'La sincronizzazione è attiva.';

  @override
  String get syncUiScanTitle => 'Scansiona il codice di sincronizzazione';

  @override
  String get syncUiScanWrong =>
      'Non è un codice di sincronizzazione. Sull\'altro dispositivo, apri Impostazioni, Sincronizzazione, Aggiungi un dispositivo.';

  @override
  String get syncUiNowSyncing => 'Ora questo dispositivo è sincronizzato.';

  @override
  String get syncUiPasteTitle => 'Incolla il link di sincronizzazione';

  @override
  String get syncUiPasteHint =>
      'tanookiauth://sync?…  (da Aggiungi un dispositivo sull\'altro dispositivo)';

  @override
  String get syncUiAddApple => 'Aggiungi un dispositivo Apple';

  @override
  String get syncUiAddAppleBody =>
      'Sull\'altro iPhone, iPad o Mac (con lo stesso Apple ID e iCloud Drive attivo), apri Tanooki Auth, vai in Impostazioni, poi Sincronizzazione, tocca \"Attiva sincronizzazione\", scegli iCloud e digita la stessa passphrase di sincronizzazione.\n\nVuoi aggiungere un telefono Android o un PC Windows? Disattiva la sincronizzazione su tutti i dispositivi, poi riattivala con il relay Tanooki.';

  @override
  String get syncUiAddDevice => 'Aggiungi un dispositivo';

  @override
  String get syncUiAddDeviceBody =>
      'Sul nuovo dispositivo, apri Tanooki Auth, vai in Impostazioni, poi Sincronizzazione, e tocca \"Unisciti da un altro dispositivo\". Scansiona questo codice, poi digita lì la tua passphrase di sincronizzazione.';

  @override
  String get syncUiAddDeviceNote =>
      'Funziona una volta, per 24 ore. Chi ha solo questo codice non può leggere nulla senza la tua passphrase.';

  @override
  String get syncUiLinkCopied =>
      'Link copiato. Incollalo sul nuovo dispositivo.';

  @override
  String get syncUiCopyLink => 'Copia invece il link';

  @override
  String get syncUiRemoveTitle =>
      'Rimuovere questo dispositivo dalla sincronizzazione?';

  @override
  String get syncUiRemoveBody =>
      'Smette di ricevere le modifiche. Se il dispositivo è stato perso o rubato, cambia anche la passphrase di sincronizzazione: disattiva la sincronizzazione su tutti i dispositivi, poi riattivala con una nuova passphrase, perché il dispositivo perso conosce ancora quella vecchia.';

  @override
  String get syncUiTurnOffTitle =>
      'Disattivare la sincronizzazione su questo dispositivo?';

  @override
  String get syncUiTurnOffBody =>
      'I tuoi account restano su questo dispositivo. Smette solo di inviare e ricevere modifiche. Gli altri tuoi dispositivi continuano a sincronizzarsi tra loro.';

  @override
  String get syncUiOff =>
      'La sincronizzazione è disattivata su questo dispositivo.';

  @override
  String get syncUiPremium => 'La sincronizzazione fa parte di Premium';

  @override
  String syncUiPremiumBody(String payOnce) {
    return 'Aggiungi un account su un dispositivo e compare su tutti, con cifratura end-to-end. $payOnce, nessun abbonamento.';
  }

  @override
  String get syncUiIntro =>
      'La sincronizzazione mantiene i tuoi account uguali su tutti i dispositivi. Prima che qualcosa lasci questo dispositivo viene protetto con la tua passphrase di sincronizzazione, quindi iCloud o il nostro server conservano solo dati cifrati. Nessun altro può leggerli, nemmeno noi.';

  @override
  String get syncUiTurnOn => 'Attiva sincronizzazione';

  @override
  String get syncUiJoin => 'Unisciti da un altro dispositivo';

  @override
  String get syncUiJoinHelp =>
      'Usa \"Unisciti\" quando un altro dispositivo si sincronizza già con il relay Tanooki.';

  @override
  String get syncUiSyncingRelay => 'Sincronizzazione con il relay Tanooki';

  @override
  String get syncUiSyncingICloud => 'Sincronizzazione con iCloud';

  @override
  String get syncUiSyncingNow => 'Sincronizzazione in corso…';

  @override
  String syncUiSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementi sincronizzati non sono leggibili',
      one: '1 elemento sincronizzato non è leggibile',
    );
    return '$_temp0';
  }

  @override
  String get syncUiSkippedHelp =>
      'Potrebbero essere stati modificati da qualcun altro o creati con un\'altra passphrase. Non è stato eliminato nulla per causa loro.';

  @override
  String get syncUiDevices => 'Dispositivi';

  @override
  String get syncUiLoading => 'Caricamento…';

  @override
  String get syncUiAddDeviceRelay =>
      'Mostra un codice da scansionare sul nuovo dispositivo';

  @override
  String get syncUiAddDeviceApple => 'Un altro iPhone, iPad o Mac';

  @override
  String get syncUiTurnOffButton =>
      'Disattiva la sincronizzazione su questo dispositivo';

  @override
  String get syncUiPassphraseNoteRelay =>
      'La passphrase di sincronizzazione non si può recuperare. Se la dimentichi, disattiva la sincronizzazione su tutti i dispositivi e ricomincia con una nuova. I tuoi account restano dove sono.';

  @override
  String get syncUiPassphraseNoteICloud =>
      'La sincronizzazione usa il tuo iCloud Drive. La passphrase di sincronizzazione non si può recuperare; se la dimentichi, ricomincia da zero con una nuova. I tuoi account restano dove sono.';

  @override
  String get syncUiTitle => 'Sincronizzazione';

  @override
  String get syncUiTooShort =>
      'Usa almeno 10 caratteri. Qualche parola a caso funziona bene.';

  @override
  String get syncUiMismatch => 'Le due passphrase non corrispondono.';

  @override
  String get syncUiChoosePassphrase =>
      'Scegli una passphrase di sincronizzazione';

  @override
  String get syncUiTypePassphrase =>
      'Digita la tua passphrase di sincronizzazione';

  @override
  String get syncUiChooseHelp =>
      'La digiterai una volta su ogni dispositivo che aggiungi. Protegge i tuoi account prima che lascino questo dispositivo.\n\nScrivila in un posto sicuro. Non si può recuperare né reimpostare, né da te né da noi.';

  @override
  String get syncUiTypeHelp =>
      'La stessa passphrase che hai scelto quando hai attivato la sincronizzazione sul tuo primo dispositivo.';

  @override
  String get syncUiPassphrase => 'Passphrase di sincronizzazione';

  @override
  String get syncUiTypeAgain => 'Digitala di nuovo';

  @override
  String get syncUiSectionTitle => 'Sincronizzazione e telefono';

  @override
  String get syncUiTitlePremium => 'Sincronizzazione (Premium)';

  @override
  String get syncUiOnRelay => 'Attiva, con il relay Tanooki';

  @override
  String get syncUiOnICloud => 'Attiva, con iCloud';

  @override
  String get syncUiOffHelp =>
      'Mantieni i tuoi account uguali su tutti i dispositivi';

  @override
  String get syncUiBrowser => 'Usa con un browser';

  @override
  String get syncUiBrowserPremium => 'Usa con un browser (Premium)';

  @override
  String get syncUiBrowserHelp =>
      'Approva i codici su questo telefono per un browser su qualsiasi computer';

  @override
  String get teamUiCreateTitle => 'Crea il tuo team';

  @override
  String get teamUiCreateHint => 'TT1.…  (dalla pagina dopo l\'abbonamento)';

  @override
  String get teamUiCreateButton => 'Crea team';

  @override
  String get teamUiReady =>
      'Il tuo team è pronto. Invita persone con \"Invita qualcuno\".';

  @override
  String get teamUiScanTitle => 'Scansiona l\'invito al team';

  @override
  String get teamUiScanWrong =>
      'Non è un invito a un team. Chiedi all\'admin del team di aprire Impostazioni, Cassaforte del team, Invita qualcuno.';

  @override
  String get teamUiJoinTitle => 'Unisciti a un team';

  @override
  String get teamUiJoinHint =>
      'tanookiauth://team?…  (il link d\'invito dall\'admin del team)';

  @override
  String get teamUiJoinButton => 'Unisciti';

  @override
  String get teamUiJoinedTeam =>
      'Sei nel team. Gli account del team compaiono quando l\'app dell\'admin condivide la chiave del team con questo dispositivo.';

  @override
  String get teamUiInvite => 'Invita qualcuno';

  @override
  String get teamUiInviteHelp =>
      'Sul suo dispositivo: Impostazioni, Cassaforte del team, poi \"Scansiona un codice QR d\'invito\" o \"Incolla un link d\'invito\". L\'invito funziona una volta e dura 7 giorni.';

  @override
  String get teamUiRemovePersonTitle => 'Rimuovere questa persona?';

  @override
  String get teamUiRemovePersonBody =>
      'Perde subito l\'accesso, e il team riceve una nuova chiave così non può leggere nulla di quanto aggiunto o modificato da ora in poi. Potrebbe aver conservato copie dei codici che già vedeva, quindi cambia la configurazione a due fattori degli account importanti.';

  @override
  String get teamUiRemoved => 'Rimossa. Il team ha una nuova chiave.';

  @override
  String get teamUiDeleteTitle => 'Eliminare il team?';

  @override
  String get teamUiLeaveTitle => 'Uscire dal team?';

  @override
  String get teamUiDeleteBody =>
      'Tutti gli account del team vengono eliminati per tutti i membri. Gli account personali di ognuno restano intatti.';

  @override
  String get teamUiLeaveBody =>
      'Gli account del team spariscono da questo dispositivo. I tuoi account personali restano intatti.';

  @override
  String get teamUiDeleteButton => 'Elimina team';

  @override
  String get teamUiLeaveButton => 'Esci';

  @override
  String get teamUiDeleted => 'Team eliminato.';

  @override
  String get teamUiLeft => 'Sei uscito dal team.';

  @override
  String get teamUiAddFirst =>
      'Prima aggiungi l\'account a Tanooki Auth, poi copialo qui nel team.';

  @override
  String get teamUiCopyInTitle => 'Copia uno dei tuoi account nel team';

  @override
  String teamUiCopiedIn(String name) {
    return '$name ora è nel team. La tua copia resta dov\'era.';
  }

  @override
  String get teamUiRenameTitle => 'Rinomina account del team';

  @override
  String get teamUiRenameHint => 'Nome, es. AWS';

  @override
  String teamUiRemoveAccountTitle(String name) {
    return 'Rimuovere $name dal team?';
  }

  @override
  String get teamUiRemoveAccountBody => 'Sparisce per tutti i membri del team.';

  @override
  String get teamUiIntro =>
      'Una cassaforte del team condivide i codici per accedere con un massimo di 10 persone, a 20 \$ all\'anno. Tutti nel team possono vedere, aggiungere e modificare gli account del team. Sono cifrati sui tuoi dispositivi con una chiave che ha solo il team, quindi il nostro server non può leggerli. Gli account del team stanno nella loro sezione Team e non si mescolano mai con i tuoi account.';

  @override
  String get teamUiStart => 'Crea un team';

  @override
  String get teamUiBuy => 'Acquista un piano team — 20 \$ all\'anno';

  @override
  String get teamUiPlanSoon => 'Piano team in arrivo';

  @override
  String get teamUiHaveLicense => 'Ho una licenza team: crea il team';

  @override
  String get teamUiJoinHelp =>
      'Chiedi un invito all\'admin del team. Entrare è gratis.';

  @override
  String get teamUiScanInvite => 'Scansiona un codice QR d\'invito';

  @override
  String get teamUiPasteInvite => 'Incolla un link d\'invito';

  @override
  String get teamUiYouRun => 'Gestisci tu questo team';

  @override
  String get teamUiYoureIn => 'Fai parte di un team';

  @override
  String teamUiPeopleCount(int count, int max) {
    return '$count di $max persone';
  }

  @override
  String teamUiLastSynced(String when) {
    return 'Ultima sincronizzazione: $when';
  }

  @override
  String teamUiPaidUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Pagato fino al $dateString';
  }

  @override
  String get teamUiSyncNow => 'Sincronizza ora';

  @override
  String get teamUiWaitingForKey =>
      'In attesa che l\'app dell\'admin del team condivida la chiave del team con questo dispositivo. Succede la prossima volta che l\'admin apre Tanooki Auth.';

  @override
  String get teamUiAccounts => 'Account del team';

  @override
  String get teamUiAddMine => 'Aggiungi uno dei miei';

  @override
  String get teamUiNoAccounts => 'Ancora nessun account del team.';

  @override
  String get teamUiChange => 'Modifica';

  @override
  String get teamUiRename => 'Rinomina';

  @override
  String get teamUiRemoveFromTeam => 'Rimuovi dal team';

  @override
  String get teamUiPeople => 'Persone';

  @override
  String get teamUiThisDevice => 'Questo dispositivo (admin)';

  @override
  String teamUiDevice(String id) {
    return 'Dispositivo $id';
  }

  @override
  String teamUiJoined(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Entrato il $dateString';
  }

  @override
  String teamUiJoinedGettingKey(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Entrato il $dateString · ricezione della chiave del team';
  }

  @override
  String get teamUiDeleteTeam => 'Elimina il team';

  @override
  String get teamUiLeaveTeam => 'Esci dal team';

  @override
  String get teamUiTitle => 'Cassaforte del team';

  @override
  String teamUiCopiedCode(String name) {
    return 'Codice di $name copiato. Gli appunti si cancellano tra 30 secondi.';
  }

  @override
  String teamUiSection(int count) {
    return 'Team · $count';
  }

  @override
  String get teamUiWaitingShort =>
      'In attesa che l\'admin del team condivida la chiave del team con questo dispositivo.';

  @override
  String get teamUiNoAccountsHint =>
      'Ancora nessun account del team. Aggiungili in Impostazioni, Cassaforte del team.';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themePink => 'Rosa pastello';

  @override
  String get themeBlue => 'Azzurro pastello';

  @override
  String get themeLavender => 'Lavanda';

  @override
  String get themeMint => 'Menta';

  @override
  String get themeMidnight => 'Mezzanotte';

  @override
  String get themeSunset => 'Tramonto';

  @override
  String get themePeach => 'Pesca';

  @override
  String get themeForest => 'Foresta';

  @override
  String get themeOcean => 'Oceano';

  @override
  String get themeMono => 'Mono';

  @override
  String get tidyNoName => '(senza nome)';

  @override
  String tidyDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nomi riordinati.',
      one: '1 nome riordinato.',
    );
    return '$_temp0';
  }

  @override
  String get tidyTitle => 'Riordina i nomi degli account';

  @override
  String get tidyNothing => 'I nomi dei tuoi account sono già in ordine.';

  @override
  String get tidyIntro =>
      'Questi nomi contengono indirizzi di siti web o parti in più. Togli la spunta a quelli che vuoi lasciare così, poi tocca Applica. I tuoi codici non cambiano.';

  @override
  String tidyWas(String name) {
    return 'Prima: $name';
  }

  @override
  String get tidyNothingTicked => 'Nessuno selezionato';

  @override
  String tidyApply(int count) {
    return 'Applica $count';
  }

  @override
  String get emergencyNotContactCode =>
      'Non è un codice contatto di Tanooki Auth. Chiedi alla persona di aprire Tanooki Auth, andare in Impostazioni > Accesso d\'emergenza e condividere il suo codice contatto.';

  @override
  String get emergencyCopyWontOpen =>
      'Non è stato possibile aprire la copia d\'emergenza con la chiave di questo dispositivo. È stata creata per un altro dispositivo, oppure è danneggiata.';

  @override
  String get emergencyGone =>
      'Questa copia d\'emergenza non esiste più. Il proprietario l\'ha rimossa.';

  @override
  String get emergencyWaitNotOver =>
      'L\'attesa di 7 giorni non è ancora finita.';

  @override
  String get emergencyNotOwnerOrContact =>
      'Questo dispositivo non è né il proprietario né il contatto di quella copia d\'emergenza.';

  @override
  String get emergencyNoRequestToDeny =>
      'Non c\'è più nessuna richiesta da rifiutare.';

  @override
  String get emergencyAskFirst => 'Prima chiedi l\'accesso.';

  @override
  String get emergencyTooBig =>
      'I tuoi account sono troppo grandi per lasciarli come copia d\'emergenza (il limite è circa 500 KB).';

  @override
  String get emergencyTooManyTries =>
      'Troppi tentativi in un minuto. Aspetta un minuto e riprova.';

  @override
  String emergencyServerSaidNo(String status) {
    return 'Il server di sincronizzazione ha rifiutato (HTTP $status).';
  }

  @override
  String emergencyServerSaidNoWhy(String status, String reason) {
    return 'Il server di sincronizzazione ha rifiutato (HTTP $status: $reason).';
  }

  @override
  String get emergencyNotEmergencyCode =>
      'Non è un codice d\'emergenza di Tanooki Auth. Chiedi alla persona che ti ha scelto di inviarlo di nuovo da Impostazioni > Accesso d\'emergenza.';

  @override
  String get emergencyLessThanMinute => 'meno di un minuto';

  @override
  String emergencyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni',
      one: '1 giorno',
    );
    return '$_temp0';
  }

  @override
  String emergencyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ore',
      one: '1 ora',
    );
    return '$_temp0';
  }

  @override
  String emergencyMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String emergencyDaysHours(int days, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni',
      one: '1 giorno',
    );
    String _temp1 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours ore',
      one: '1 ora',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get emergencyUiExplainer =>
      'Scegli una persona di fiducia. Se ti succede qualcosa, potrà chiedere i tuoi account. I tuoi dispositivi ricevono una notifica e hai 7 giorni per dire di no. Se nessuno dice di no, riceverà una copia.\n\nIl server di Tanooki Auth fa solo rispettare l\'attesa di 7 giorni. La copia è protetta con una chiave che ha solo il suo dispositivo, quindi il server non può leggerla, e nemmeno chi dovesse violare il server.';

  @override
  String emergencyUiPushNotWorking(String reason) {
    return 'Le notifiche non funzionano ancora ($reason). Tanooki Auth controlla le richieste ogni volta che lo apri.';
  }

  @override
  String get emergencyUiScanTheirQr => 'Scansiona il suo codice QR';

  @override
  String get emergencyUiPasteCode => 'Incolla un codice che ti ha inviato';

  @override
  String get emergencyUiWrongCode => 'Non è il codice giusto.';

  @override
  String get emergencyUiCopiedCode =>
      'Copiato. Invialo come preferisci: non contiene segreti.';

  @override
  String get emergencyUiCopyAsText => 'Copia come testo';

  @override
  String get emergencyUiTheirContactCode => 'Il suo codice contatto';

  @override
  String get emergencyUiNotContactCodeShort =>
      'Non è un codice contatto di Tanooki Auth.';

  @override
  String get emergencyUiMakeThemContact =>
      'Renderlo il tuo contatto d\'emergenza?';

  @override
  String emergencyUiMakeNamedContact(String name) {
    return 'Rendere $name il tuo contatto d\'emergenza?';
  }

  @override
  String get emergencyUiCopyLeftOnServer =>
      'Una copia di tutti i tuoi account viene protetta per il suo dispositivo e lasciata sul server di Tanooki Auth. Si aggiorna quando modifichi i tuoi account.';

  @override
  String get emergencyUiYourNameWhose =>
      'Il tuo nome (così sa di chi è la copia)';

  @override
  String get emergencyUiDoneGiveCode =>
      'Fatto. Ora dagli il codice su questa schermata.';

  @override
  String get emergencyUiStopTitle => 'Interrompere l\'accesso d\'emergenza?';

  @override
  String get emergencyUiStopBody =>
      'La copia viene eliminata dal server e non potrà più richiederla.';

  @override
  String get emergencyUiChooseContact => 'Scegli un contatto d\'emergenza';

  @override
  String get emergencyUiChooseContactPremium =>
      'Scegli un contatto d\'emergenza (Premium)';

  @override
  String get emergencyUiChooseContactHow =>
      'Apre Tanooki Auth sul suo dispositivo, va in Impostazioni > Accesso d\'emergenza e ti mostra il suo codice contatto.';

  @override
  String get emergencyUiYourContact => 'Il tuo contatto';

  @override
  String get emergencyUiChecking => 'Verifica con il server…';

  @override
  String get emergencyUiIdleJustNow =>
      'Nessuno ha chiesto. Copia aggiornata proprio ora.';

  @override
  String emergencyUiIdleUpdated(String day) {
    return 'Nessuno ha chiesto. Copia aggiornata $day.';
  }

  @override
  String emergencyUiWaiting(String who, String day, String left) {
    return '$who ha chiesto il $day. Potrà aprire la copia tra $left, a meno che tu non rifiuti.';
  }

  @override
  String emergencyUiReleased(String who) {
    return '$who ha chiesto e l\'attesa è finita: ora può aprire la copia. Rifiuta per impedirlo.';
  }

  @override
  String emergencyUiContactIs(String who) {
    return 'Contatto d\'emergenza: $who';
  }

  @override
  String get emergencyUiDenied =>
      'Rifiutato. Non può aprire i tuoi account. Potrà chiedere di nuovo più avanti.';

  @override
  String get emergencyUiCopyUpdated => 'Copia aggiornata.';

  @override
  String get emergencyUiCouldntUpdate => 'Impossibile aggiornare la copia.';

  @override
  String get emergencyUiUpdateNow => 'Aggiorna la copia ora';

  @override
  String emergencyUiGiveCode(String who) {
    return 'Dai questo codice a $who. In Tanooki Auth deve andare in Impostazioni > Accesso d\'emergenza > \"Aggiungi un codice ricevuto\".';
  }

  @override
  String get emergencyUiCodeTheyGave => 'Codice ricevuto';

  @override
  String get emergencyUiNotEmergencyCodeShort =>
      'Non è un codice d\'emergenza di Tanooki Auth.';

  @override
  String get emergencyUiAddedTheir =>
      'Aggiunto. Se mai ti servisse, puoi chiedere i suoi account da qui.';

  @override
  String emergencyUiAddedNamed(String name) {
    return 'Aggiunto. Se mai ti servisse, puoi chiedere gli account di $name da qui.';
  }

  @override
  String get emergencyUiTheOwner => 'il proprietario';

  @override
  String get emergencyUiAskTitle => 'Chiedere l\'accesso d\'emergenza?';

  @override
  String emergencyUiAskBody(String who) {
    return '$who riceve una notifica e ha 7 giorni per dire di no. Se non lo fa, potrai aprire qui una copia dei suoi account. Chiedi solo se ti serve davvero.';
  }

  @override
  String get emergencyUiAsk => 'Chiedi';

  @override
  String get emergencyUiAsked =>
      'Richiesta inviata. L\'attesa di 7 giorni è iniziata.';

  @override
  String emergencyUiAddTheirAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aggiungere i suoi $count account?',
      one: 'Aggiungere il suo account?',
    );
    return '$_temp0';
  }

  @override
  String emergencyUiAddNamedAccounts(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aggiungere i $count account di $name?',
      one: 'Aggiungere l\'account di $name?',
    );
    return '$_temp0';
  }

  @override
  String get emergencyUiSomeone => 'Qualcuno';

  @override
  String get emergencyUiCheckingShort => 'Verifica…';

  @override
  String get emergencyUiNotAsked => 'Non hai chiesto.';

  @override
  String get emergencyUiRequestAccess => 'Richiedi accesso';

  @override
  String emergencyUiOpensIn(String left, String day) {
    return 'Hai chiesto. Si apre tra $left ($day), a meno che non dica di no.';
  }

  @override
  String get emergencyUiWaitOver => 'L\'attesa è finita.';

  @override
  String get emergencyUiOpenCopy => 'Apri la copia d\'emergenza';

  @override
  String emergencyUiPersonAccounts(String who) {
    return 'Account di $who';
  }

  @override
  String get emergencyUiYourContactCode => 'Il tuo codice contatto';

  @override
  String get emergencyUiShowThis =>
      'Se qualcuno ti vuole come contatto d\'emergenza, mostragli questo. Non contiene segreti.';

  @override
  String get emergencyUiYourNameItsYou => 'Il tuo nome (così sa che sei tu)';

  @override
  String get emergencyUiShowMyCode => 'Mostra il mio codice contatto';

  @override
  String get emergencyUiLetThemScan =>
      'Fallo scansionare in Tanooki Auth, oppure copialo e invialo.';

  @override
  String get emergencyUiAddCodeGiven => 'Aggiungi un codice ricevuto';

  @override
  String get emergencyUiAddCodeGivenHow =>
      'Dopo che ti ha scelto, la sua app mostra un codice per te';

  @override
  String get emergencyUiTitle => 'Accesso d\'emergenza';

  @override
  String get emergencyUiYourEmergencyContact => 'Il tuo contatto d\'emergenza';

  @override
  String get emergencyUiPeopleWhoChoseYou => 'Persone che ti hanno scelto';

  @override
  String get securityUiProofWindows => 'Windows Hello';

  @override
  String get securityUiProofMac => 'Touch ID o la tua password';

  @override
  String get securityUiProofIos => 'Face ID o codice';

  @override
  String get securityUiProofOther => 'impronta digitale o PIN';

  @override
  String securityUiPasscodeAtLeast(int count) {
    return 'Codice d\'accesso (almeno $count cifre)';
  }

  @override
  String get securityUiTypeAgain => 'Digitalo di nuovo';

  @override
  String get securityUiPasscodesDontMatch =>
      'I due codici d\'accesso non corrispondono.';

  @override
  String get securityUiPickDifferent =>
      'Scegli un codice d\'accesso diverso dall\'altro.';

  @override
  String get securityUiEnterPasscode =>
      'Inserisci il codice d\'accesso dell\'app';

  @override
  String get securityUiPasscode => 'Codice d\'accesso';

  @override
  String get securityUiWrongPasscode => 'Non è il tuo codice d\'accesso.';

  @override
  String get securityUiCheckupTitle => 'Controllo di sicurezza';

  @override
  String get securityUiAllGood => 'Tutto a posto';

  @override
  String get securityUiAllGoodBody =>
      'L\'app è bloccata, hai un backup recente e ogni account ha i codici di recupero.';

  @override
  String get securityUiLockOffTitle => 'L\'app non è bloccata';

  @override
  String get securityUiLockOffBody =>
      'Chiunque prenda il tuo dispositivo sbloccato può vedere i tuoi codici. Attiva \"Blocca l\'app\" o un codice d\'accesso in Impostazioni.';

  @override
  String get securityUiNoPasscodeTitle => 'Nessun codice d\'accesso';

  @override
  String get securityUiNoPasscodeBody =>
      'Un codice d\'accesso ti permette di aprire Tanooki Auth anche se Face ID o l\'impronta digitale smettono di funzionare. Impostalo in Impostazioni.';

  @override
  String get securityUiAutoBackupFailed => 'Backup automatico non riuscito';

  @override
  String get securityUiOpenAutoBackups => 'Apri backup automatici';

  @override
  String get securityUiNoBackupTitle => 'Nessun backup negli ultimi 30 giorni';

  @override
  String get securityUiNoBackupBody =>
      'Se questo dispositivo si perde o si rompe, un backup è l\'unico modo per recuperare i tuoi account.';

  @override
  String get securityUiMakeBackupNow => 'Fai un backup ora';

  @override
  String securityUiNoRecoveryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count account non hanno codici di recupero',
      one: '1 account non ha codici di recupero',
    );
    return '$_temp0';
  }

  @override
  String securityUiNoRecoveryBody(String names) {
    return 'I codici di recupero ti fanno entrare in un sito web se perdi questa app. Li trovi nelle impostazioni di sicurezza di ogni sito, poi aggiungili con ⋯ > Codici di recupero sull\'account.\n\n$names';
  }

  @override
  String get securityUiRecoveryKit => 'Il tuo kit di recupero';

  @override
  String get securityUiRecoveryKitSub =>
      'Backup, codici di recupero e una copia cartacea, passo passo';

  @override
  String securityUiBreachSnack(String sites) {
    return '$sites ha subito una violazione di dati. Cambia lì la tua password.';
  }

  @override
  String get securityUiBreachDownloadFailed =>
      'Impossibile scaricare l\'elenco delle violazioni. Controlla la connessione a internet e riprova.';

  @override
  String get securityUiBreachAlerts => 'Avvisi di violazione';

  @override
  String get securityUiBreachAlertsPremium => 'Avvisi di violazione (Premium)';

  @override
  String get securityUiBreachAlertsSub =>
      'Una volta a settimana, ti avvisa se un sito web che usi ha subito una violazione di dati';

  @override
  String get securityUiBreachHow =>
      'Come funziona: Tanooki Auth scarica da haveibeenpwned.com l\'elenco pubblico delle violazioni note e lo confronta con i siti web salvati su questo dispositivo. Non viene inviato nulla su di te o sui tuoi account: il download è uguale per tutti. È l\'unico momento in cui l\'app va su internet, a parte la sincronizzazione e l\'acquisto di Premium.';

  @override
  String securityUiNoWebsite(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count dei tuoi account non hanno un sito web salvato, quindi non possono essere controllati. Aggiungilo con ⋯ > Modifica.',
      one: '1 dei tuoi account non ha un sito web salvato, quindi non può essere controllato. Aggiungilo con ⋯ > Modifica.',
    );
    return '$_temp0';
  }

  @override
  String get securityUiCheckNow => 'Controlla ora';

  @override
  String get securityUiNoBreaches =>
      'Nessuna violazione nota per i tuoi siti web salvati.';

  @override
  String get securityUiBreached =>
      'Violato. Se hai creato la password prima di allora, cambiala lì.';

  @override
  String securityUiBreachedOn(String date) {
    return 'Violato il $date. Se hai creato la password prima di allora, cambiala lì.';
  }

  @override
  String securityUiBreachedLeaked(String data) {
    return 'Violato. Dati esposti: $data. Se hai creato la password prima di allora, cambiala lì.';
  }

  @override
  String securityUiBreachedOnLeaked(String date, String data) {
    return 'Violato il $date. Dati esposti: $data. Se hai creato la password prima di allora, cambiala lì.';
  }

  @override
  String get securityUiKitIntro =>
      'Se perdi questo dispositivo, ecco come rientrare nei tuoi account. Ognuno richiede un minuto. Se non hai ancora aggiunto account, aggiungili prima, poi torna qui da Impostazioni > Controllo di sicurezza.';

  @override
  String get securityUiKitBackupTitle => 'Fai un backup';

  @override
  String get securityUiKitBackupBody =>
      'Un file cifrato, protetto da una passphrase scelta da te. Tienilo in un posto diverso da questo dispositivo, come iCloud Drive, Google Drive o una chiavetta USB.';

  @override
  String get securityUiKitBackupButton => 'Fai un backup';

  @override
  String get securityUiKitCodesTitle => 'Salva i tuoi codici di recupero';

  @override
  String get securityUiKitCodesBody =>
      'Quando attivi l\'accesso a due fattori, la maggior parte dei siti web ti dà un elenco di codici di recupero monouso. Aggiungili a ogni account con ⋯ > Codici di recupero, così finiscono anche nel tuo backup.';

  @override
  String get securityUiKitPaperTitle => 'Stampa un backup cartaceo';

  @override
  String get securityUiKitPaperBody =>
      'Facoltativo. Una pagina stampata di codici QR funziona anche se tutti i dispositivi sono spariti. Tienila sotto chiave: chiunque la possieda può generare i tuoi codici.';

  @override
  String get securityUiKitPaperButton => 'Stampa backup cartaceo';

  @override
  String get securityUiSkipForNow => 'Salta per ora';

  @override
  String get securityExtrasPrivacy =>
      'Nessun account, nessun tracciamento. Le tue chiavi di configurazione sono conservate cifrate su questo dispositivo. L\'app va online solo per: un controllo dell\'orologio (chiede l\'ora al server di Tanooki Auth, al massimo una volta all\'ora mentre i codici sono sullo schermo e quando tocchi \"I codici non funzionano?\"; non viene inviato nulla su di te o sui tuoi account), gli avvisi di violazione se li attivi (scarica l\'elenco pubblico delle violazioni), la sincronizzazione, il collegamento al telefono e l\'accesso d\'emergenza se li configuri (trasportano solo dati cifrati che il server non può leggere), l\'acquisto di Premium e i feedback che scegli di inviare (il tuo messaggio, la tua email se la scrivi, e la versione dell\'app e il tipo di dispositivo se lasci la spunta; mai i tuoi account, codici o altro nell\'app). Le guide 2FA si aprono nel browser.';

  @override
  String get securityExtrasMonthlyBody =>
      'Il tuo riepilogo di sicurezza mensile è pronto. Apri Tanooki Auth per vederlo.';

  @override
  String get securityExtrasNotificationsOffIos =>
      'Le notifiche sono disattivate per Tanooki Auth. Attivale nell\'app Impostazioni dell\'iPhone, in Notifiche, poi riprova.';

  @override
  String get securityExtrasNotificationsOffMac =>
      'Le notifiche sono disattivate per Tanooki Auth. Attivale in Impostazioni di Sistema, in Notifiche, poi riprova.';

  @override
  String securityExtrasReminderFailed(String reason) {
    return 'Impossibile impostare il promemoria ($reason).';
  }

  @override
  String get securityExtrasRemindersUnavailable =>
      'I promemoria non sono ancora disponibili su questo dispositivo.';

  @override
  String securityExtrasDayTime(String day, String time) {
    return '$day, $time';
  }

  @override
  String get securityExtrasClearTitle => 'Cancellare la cronologia attività?';

  @override
  String get securityExtrasClearBody =>
      'Ogni voce viene rimossa da questo dispositivo. I tuoi account restano intatti.';

  @override
  String get securityExtrasActivityTitle => 'Cronologia attività';

  @override
  String securityExtrasActivityPitch(int count) {
    return 'La cronologia attività fa parte di Premium. Conserva le ultime $count volte in cui un codice è stato copiato, inserito in un sito web, digitato, mostrato come codice QR o esportato, solo su questo dispositivo.';
  }

  @override
  String get securityExtrasNothingYet =>
      'Ancora niente. Qui compaiono copie, inserimenti, digitazioni, codici QR mostrati ed esportazioni.';

  @override
  String get securityExtrasAllAccounts => 'Tutti gli account';

  @override
  String get securityExtrasDeletedAccount => 'Un account eliminato';

  @override
  String securityExtrasActivityLine(String kind, String what) {
    return '$kind: $what';
  }

  @override
  String get securityExtrasGetPremium => 'Ottieni Premium';

  @override
  String get securityExtrasAddKey => 'Aggiungi una chiave di sicurezza';

  @override
  String get securityExtrasAddKeyPremium =>
      'Aggiungi una chiave di sicurezza (Premium)';

  @override
  String get securityExtrasAddKeyIos =>
      'Poi, quando richiesto, avvicina la chiave alla parte superiore dell\'iPhone o collegala. Potresti doverla toccare due volte.';

  @override
  String get securityExtrasAddKeyOther =>
      'Poi collega la chiave e toccala quando lampeggia. Potresti doverla toccare due volte e digitare il suo PIN, se ne ha uno.';

  @override
  String get securityExtrasKeyName => 'Nome (per distinguere le tue chiavi)';

  @override
  String securityExtrasKeyAdded(String name) {
    return '\"$name\" aggiunta. Ora puoi sbloccare Tanooki Auth con questa chiave su questo dispositivo.';
  }

  @override
  String securityExtrasKeyRemoved(String name) {
    return '\"$name\" rimossa. Non può più sbloccare Tanooki Auth.';
  }

  @override
  String get securityExtrasKeysTitle => 'Chiavi di sicurezza';

  @override
  String securityExtrasKeysIntro(String usual) {
    return 'Una chiave di sicurezza (come una YubiKey) può sbloccare Tanooki Auth al posto di $usual. La chiave contiene un segreto che non la lascia mai, e l\'app lo usa per proteggere la chiave dei tuoi account. Se perdi la chiave, puoi comunque sbloccare nel solito modo.';
  }

  @override
  String securityExtrasKeyAddedOn(String day) {
    return 'Aggiunta $day';
  }

  @override
  String get securityExtrasLockOffNote =>
      'Il blocco dell\'app è disattivato, quindi l\'app si apre senza chiedere nulla. Attiva \"Blocca l\'app\" o un codice d\'accesso in Impostazioni per usare la chiave.';

  @override
  String get securityExtrasLockWordWindows =>
      'Windows Hello o il codice d\'accesso';

  @override
  String get securityExtrasLockWordMac => 'Touch ID o il codice d\'accesso';

  @override
  String get securityExtrasLockWordOther => 'Face ID o il codice d\'accesso';

  @override
  String get securityLockImmediately => 'Subito';

  @override
  String get securityLockAfter30s => 'Dopo 30 secondi';

  @override
  String get securityLockAfter1m => 'Dopo 1 minuto';

  @override
  String get securityLockAfter5m => 'Dopo 5 minuti';

  @override
  String get securityNumbersOnly => 'Usa solo numeri.';

  @override
  String securityAtLeastNumbers(int count) {
    return 'Usa almeno $count cifre.';
  }

  @override
  String get securitySameNumber => 'Non usare sempre lo stesso numero.';

  @override
  String get securityNumbersInRow =>
      'Non usare numeri in sequenza come 123456.';

  @override
  String get securityPanicNeedsPasscode =>
      'Prima imposta un codice d\'accesso. La cancellazione d\'emergenza conta i codici d\'accesso errati.';

  @override
  String get securityPanicNeedsBackup =>
      'Prima fai un backup (Impostazioni > Esporta backup). La cancellazione d\'emergenza cancella tutti gli account, quindi si attiva solo se hai fatto un backup negli ultimi 30 giorni.';

  @override
  String get securityKeyDefaultName => 'Chiave di sicurezza';

  @override
  String get securityKeyNotYours =>
      'Quella chiave di sicurezza non è tra quelle che hai aggiunto a Tanooki Auth su questo dispositivo.';

  @override
  String get securityKeyNotAvailable =>
      'Non ancora disponibile su questo dispositivo.';

  @override
  String get securityKeyWindowsTooOld =>
      'Non ancora disponibile su questa versione di Windows. Installa gli ultimi aggiornamenti di Windows 11.';

  @override
  String get securityKeyIosTooOld =>
      'Richiede iOS 26.4 o successivo. Aggiorna dall\'app Impostazioni, poi riprova.';

  @override
  String get securityKeyMacTooOld =>
      'Richiede macOS 26.4 o successivo. Aggiorna dall\'app Impostazioni, poi riprova.';

  @override
  String get securityKeyDidntWork =>
      'La chiave di sicurezza non ha funzionato. Riprova.';

  @override
  String securityKeyDidntWorkWhy(String reason) {
    return 'La chiave di sicurezza non ha funzionato ($reason). Riprova.';
  }

  @override
  String get securityKeyCanceled => 'Annullato. Non è cambiato nulla.';

  @override
  String get securityKeyNoPrf =>
      'Questa chiave di sicurezza non può sbloccare le app in questo modo (non ha la funzione \"hmac-secret\"). Le YubiKey serie 5 e la maggior parte delle chiavi FIDO2 degli ultimi anni ce l\'hanno.';

  @override
  String get securityKeyNotAllowed =>
      'La chiave di sicurezza non ha risposto, oppure non è una di quelle aggiunte qui. Collegala (o avvicinala alla parte superiore del telefono) e toccala quando lampeggia.';

  @override
  String get securityKeyNotAssociated =>
      'Questa copia di Tanooki Auth non può ancora usare le chiavi di sicurezza: Apple richiede prima che l\'app sia collegata ad auth.tanookistudios.com. Dipende da noi, non da te.';

  @override
  String get securityKeyExists =>
      'Questa chiave di sicurezza è già stata aggiunta.';

  @override
  String get securityKeyPin =>
      'La chiave di sicurezza richiede il suo PIN, che non è stato inserito. Riprova e digita il PIN della chiave quando richiesto.';

  @override
  String get securityKeyVaultKeyMissing =>
      'Manca la chiave che sblocca i tuoi account, quindi non è possibile aggiungere una chiave di sicurezza.';

  @override
  String get securityKeyNoneAdded =>
      'Nessuna chiave di sicurezza aggiunta su questo dispositivo.';

  @override
  String get securityKeyBeforeReset =>
      'Quella chiave di sicurezza è stata aggiunta prima che i tuoi account venissero reimpostati, quindi non può aprirli. Rimuovila e aggiungila di nuovo.';

  @override
  String get backupUiChoosePassphrase => 'Scegli una passphrase per il backup';

  @override
  String get backupUiPassphraseTitle => 'Passphrase del backup';

  @override
  String get backupUiPassphraseWarning =>
      'Ti servirà per ripristinare il backup. Nessuno, nemmeno noi, può recuperarla se la dimentichi. Scrivila in un posto sicuro.';

  @override
  String get backupUiPassphrase => 'Passphrase';

  @override
  String get backupUiTypeAgain => 'Digitala di nuovo';

  @override
  String get backupUiTooShort =>
      'Usa almeno 8 caratteri. Qualche parola a caso funziona bene.';

  @override
  String get backupUiNoMatch => 'Le due passphrase non corrispondono.';

  @override
  String get backupUiTypePassphrase => 'Digita la passphrase.';

  @override
  String get backupUiNothingToBackUp =>
      'Non ci sono ancora account di cui fare il backup.';

  @override
  String get backupUiEncrypting => 'Cifratura del backup…';

  @override
  String backupUiSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Backup di $count account salvato.',
      one: 'Backup di 1 account salvato.',
    );
    return '$_temp0';
  }

  @override
  String get backupUiNotABackup => 'Quel file non è un backup di Tanooki Auth.';

  @override
  String get backupUiUnlocking => 'Sblocco del backup…';

  @override
  String backupUiImported(int count) {
    return 'Importati: $count.';
  }

  @override
  String backupUiImportedSkipped(int added, int skipped) {
    return 'Importati: $added, saltati: $skipped.';
  }

  @override
  String backupUiImportedSkippedAlready(int added, int skipped) {
    return 'Importati: $added, saltati: $skipped già nel tuo elenco.';
  }

  @override
  String backupUiAdded(int count) {
    return 'Aggiunti: $count.';
  }

  @override
  String backupUiAddedSkipped(int added, int skipped) {
    return 'Aggiunti: $added, saltati: $skipped.';
  }

  @override
  String backupUiAddedSkippedAlready(int added, int skipped) {
    return 'Aggiunti: $added, saltati: $skipped già nel tuo elenco.';
  }

  @override
  String backupUiAlreadyInList(int count) {
    return '• $count già nel tuo elenco';
  }

  @override
  String get backupUiImport => 'Importa';

  @override
  String backupUiImportFromGoogle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importare $count account da Google Authenticator?',
      one: 'Importare 1 account da Google Authenticator?',
    );
    return '$_temp0';
  }

  @override
  String get backupUiGoogleMoreCodes =>
      'Se Google Authenticator ha mostrato più di un codice QR, scansionali tutti.';

  @override
  String get backupUiNothingToExport =>
      'Non ci sono ancora account da esportare.';

  @override
  String get backupUiPlainWhat =>
      'Questo salva ogni chiave di configurazione come testo normale, per passare a un\'altra app di autenticazione.';

  @override
  String get backupUiPlainTitle => 'Esportare senza cifratura?';

  @override
  String backupUiPlainBody(String what) {
    return '$what Chiunque ottenga questo file può generare i tuoi codici per accedere. Importalo, poi eliminalo subito. Per un backup normale, usa invece \"Esporta backup\".';
  }

  @override
  String get backupUiUnderstandExport => 'Ho capito, esporta';

  @override
  String get backupUiNothingToPrint =>
      'Non ci sono ancora account da stampare.';

  @override
  String get backupUiPaperTitle => 'Stampare un backup cartaceo?';

  @override
  String get backupUiPaperBody =>
      'Questo crea un PDF con un codice QR per ogni account, più i tuoi codici di recupero non usati. Chiunque veda o fotografi quel foglio può generare i tuoi codici per accedere, per sempre, senza il tuo telefono o la tua password.\n\nStampalo, poi elimina il PDF. Tieni il foglio in un posto chiuso a chiave, come una cassaforte o insieme ai documenti importanti. Non inviarlo per email e non salvarlo in una cartella condivisa.';

  @override
  String get backupUiUnderstandPdf => 'Ho capito, crea il PDF';

  @override
  String get backupUiMakingPdf => 'Creazione del PDF…';

  @override
  String get backupUiPdfReady => 'PDF pronto. Stampalo, poi elimina il file.';

  @override
  String get backupUiWorksTitle => 'Il backup funziona';

  @override
  String backupUiWorksBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Questo backup si apre correttamente e contiene $count account. Non è stato aggiunto né modificato nulla.',
      one: 'Questo backup si apre correttamente e contiene 1 account. Non è stato aggiunto né modificato nulla.',
    );
    return '$_temp0';
  }

  @override
  String get backupWrongVersion =>
      'Questo backup è stato creato da una versione più recente di Tanooki Auth. Aggiorna l\'app e riprova.';

  @override
  String get backupWrongPassphrase =>
      'Passphrase errata, oppure il file di backup è danneggiato.';

  @override
  String get backupDamaged =>
      'Il backup è stato sbloccato ma il suo contenuto è danneggiato.';

  @override
  String get paperBackupTitle => 'Backup cartaceo di Tanooki Auth';

  @override
  String paperBackupHeader(String date) {
    return 'Backup cartaceo di Tanooki Auth, $date';
  }

  @override
  String get paperBackupWarning =>
      'TIENILO SEGRETO. Chiunque abbia questo foglio può generare i tuoi codici per accedere. Conservalo sotto chiave; distruggilo quando ne crei uno nuovo. Per ripristinare: in qualsiasi app di autenticazione, scegli \"Scansiona codice QR\" e scansiona ogni codice qui sotto.';

  @override
  String paperBackupSetupKey(String key) {
    return 'Chiave di configurazione: $key';
  }

  @override
  String get paperBackupRecoveryCodes =>
      'Codici di recupero (ognuno funziona una volta):';

  @override
  String get autoBackupUiChooseFolderDialog =>
      'Scegli una cartella per i backup automatici';

  @override
  String autoBackupUiToday(String time) {
    return 'Oggi alle $time';
  }

  @override
  String autoBackupUiYesterday(String time) {
    return 'Ieri alle $time';
  }

  @override
  String autoBackupUiOnDay(String date, String time) {
    return '$date alle $time';
  }

  @override
  String get autoBackupUiBackingUp => 'Backup in corso…';

  @override
  String autoBackupUiBackedUp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Backup di $count account completato.',
      one: 'Backup di 1 account completato.',
    );
    return '$_temp0';
  }

  @override
  String get autoBackupUiCouldntUseFolder =>
      'Impossibile usare quella cartella.';

  @override
  String autoBackupUiCouldntUseFolderWhy(String reason) {
    return 'Impossibile usare quella cartella. $reason';
  }

  @override
  String get autoBackupUiTurnOffTitle => 'Disattivare i backup automatici?';

  @override
  String get autoBackupUiTurnOffBody =>
      'I backup già presenti nella cartella restano lì. La passphrase del backup viene dimenticata, quindi ne sceglierai una nuova se riattivi questa opzione.';

  @override
  String get autoBackupUiTitle => 'Backup automatici';

  @override
  String get autoBackupUiTitlePremium => 'Backup automatici (Premium)';

  @override
  String autoBackupUiIntro(int count) {
    return 'Una volta al giorno, Tanooki Auth salva un backup cifrato in una cartella scelta da te. Scegli la tua cartella di iCloud Drive, Google Drive o Dropbox e i tuoi backup saranno anche fuori da questo dispositivo. Vengono conservati i $count più recenti; quelli più vecchi vengono eliminati.\n\nRipristinane uno con Impostazioni > Importa backup e la tua passphrase del backup.';
  }

  @override
  String get autoBackupUiLastFailed =>
      'L\'ultimo backup automatico non è riuscito';

  @override
  String get autoBackupUiChooseFolder => 'Scegli una cartella';

  @override
  String get autoBackupUiBackupFolder => 'Cartella di backup';

  @override
  String get autoBackupUiNoBackupYet => 'Ancora nessun backup';

  @override
  String autoBackupUiLastBackup(String when) {
    return 'Ultimo backup: $when';
  }

  @override
  String get autoBackupUiBackUpNow => 'Esegui backup ora';

  @override
  String get autoBackupUiChangeFolder => 'Cambia cartella';

  @override
  String get autoBackupUiOffSubtitle =>
      'Disattivati. Un backup cifrato giornaliero su iCloud Drive, Google Drive, Dropbox o qualsiasi cartella.';

  @override
  String autoBackupUiOnNoBackup(String folder) {
    return 'Attivi, in $folder. Ancora nessun backup.';
  }

  @override
  String autoBackupUiOnLast(String folder, String when) {
    return 'Attivi, in $folder. Ultimo backup: $when.';
  }

  @override
  String get autoBackupFolderGone =>
      'La cartella di backup non c\'è più. Potrebbe essere stata eliminata, rinominata fuori dall\'app, oppure il suo disco è scollegato. Scegli di nuovo la cartella.';

  @override
  String get autoBackupPermissionLost =>
      'Tanooki Auth non ha più il permesso di scrivere nella cartella di backup. Scegli di nuovo la cartella per ridare il permesso.';

  @override
  String get autoBackupDiskFull =>
      'Il disco della cartella di backup è pieno. Libera un po\' di spazio, poi tocca Esegui backup ora.';

  @override
  String get autoBackupOther =>
      'Impossibile salvare il backup. Tocca Esegui backup ora per riprovare.';

  @override
  String autoBackupOtherWhy(String reason) {
    return 'Impossibile salvare il backup ($reason). Tocca Esegui backup ora per riprovare.';
  }

  @override
  String get importUiDeleteNote =>
      'Quando hai finito, elimina il file esportato: chiunque lo ottenga può generare i tuoi codici.';

  @override
  String get importUiStepsAegis =>
      'In Aegis sul tuo telefono Android:\n\n1. Tocca ⋮, poi Impostazioni, poi \"Importa ed esporta\".\n2. Tocca \"Esporta\", scegli \"Aegis (.JSON)\".\n3. Se vuoi, lascia attivo \"Cripta la cassaforte\"; digiterai quella password qui.\n4. Salva il file in un posto che questo dispositivo può aprire (per esempio Google Drive, o invialo a te stesso per email).\n\nPoi scegli quel file qui.';

  @override
  String get importUiStepsTwoFas =>
      'In 2FAS:\n\n1. Apri Impostazioni, poi \"Backup 2FAS\".\n2. Tocca \"Esporta su file\". Se chiede una password, digiterai la stessa qui.\n3. Salva il file .2fas in un posto che questo dispositivo può aprire.\n\nPoi scegli quel file qui.';

  @override
  String get importUiStepsAuthy =>
      'Authy non ha un pulsante per esportare, e Authy per computer è stato chiuso nel 2024.\n\nSe hai già estratto i tuoi account con uno strumento come \"authy-export\", scegli il file che ha creato (un file .json, o un elenco .txt di link otpauth://).\n\nAltrimenti, il modo sicuro è un account alla volta: accedi a ogni sito web, disattiva e riattiva l\'accesso a due fattori e scansiona il nuovo codice QR con Tanooki Auth. Tieni Authy finché ogni account non funziona qui.';

  @override
  String get importUiStepsBitwarden =>
      'In Bitwarden (sito web o app desktop):\n\n1. Vai in Strumenti, poi \"Esporta cassaforte\".\n2. Scegli \".json\" o \".csv\". Non \"cifrato\".\n3. Salva il file.\n\nPoi scegli quel file qui. Vengono trasferiti solo i login con una chiave di autenticazione; le tue password vengono ignorate.';

  @override
  String get importUiStepsOnePassword =>
      'Nell\'app 1Password per Mac o Windows:\n\n1. Fai clic su File, poi Esporta, poi scegli il tuo account.\n2. Scegli \"CSV\" come formato e salva.\n\nPoi scegli quel file qui. Vengono trasferiti solo gli elementi con una password monouso; le tue password vengono ignorate.';

  @override
  String get importUiStepsApple =>
      'Ti serve un Mac; l\'iPhone non può salvare il file.\n\nSu un Mac con macOS Sequoia o successivo:\n1. Apri l\'app Password.\n2. Nella barra dei menu, fai clic su File, poi \"Esporta tutte le password…\".\n3. Fai clic su \"Esporta password\", digita la password del Mac se richiesta e salva il file.\n\nSu un Mac meno recente: apri Safari, poi Safari > Impostazioni > Password, fai clic sul pulsante ⋯ e scegli \"Esporta tutte le password…\".\n\nPoi scegli quel file qui. Vengono trasferiti solo gli elementi con un codice di verifica; le tue password vengono ignorate.';

  @override
  String get importUiStepsMicrosoft =>
      'Microsoft Authenticator non può esportare i tuoi account, quindi non si possono spostare in un colpo solo.\n\nPer ogni account:\n1. Accedi a quel sito web da un computer.\n2. Trova le sue impostazioni di sicurezza o di autenticazione a due fattori.\n3. Disattiva e riattiva l\'accesso a due fattori (o scegli \"aggiungi una nuova app di autenticazione\").\n4. Scansiona il nuovo codice QR con Tanooki Auth e digita il codice che mostra per finire.\n\nTieni Microsoft Authenticator finché ogni account non funziona in Tanooki Auth. Anche il tuo account Microsoft può usare Tanooki Auth: aggiungilo su account.microsoft.com, in Sicurezza.';

  @override
  String get importUiTitle => 'Trasferisci da un\'altra app';

  @override
  String get importUiCantExport =>
      'Esportazione impossibile: come spostare ogni account';

  @override
  String get importUiFromExportFile => 'Da un file esportato';

  @override
  String importUiMoveFrom(String app) {
    return 'Trasferisci da $app';
  }

  @override
  String get importUiGotIt => 'Ho capito';

  @override
  String get importUiPickFile => 'Scegli file';

  @override
  String get importUiCouldntRead => 'Impossibile leggere quel file.';

  @override
  String importUiReading(String app) {
    return 'Lettura del file esportato da $app…';
  }

  @override
  String get importUiNoAccountsInFile =>
      'Quel file non conteneva account a due fattori.';

  @override
  String importUiImportFrom(int count, String app) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importare $count account da $app?',
      one: 'Importare 1 account da $app?',
    );
    return '$_temp0';
  }

  @override
  String importUiExportPassword(String app) {
    return 'Password dell\'esportazione di $app';
  }

  @override
  String get importUiPasswordHint =>
      'La password che hai scelto durante l\'esportazione';

  @override
  String importersNotAnExport(String app) {
    return 'Quel file non è un\'esportazione di $app.';
  }

  @override
  String importersLine(String line, String problem) {
    return 'Riga $line: $problem';
  }

  @override
  String get importersEmpty => 'Quel file è vuoto.';

  @override
  String get importersNotAuthy => 'Quel file non è un\'esportazione di Authy.';

  @override
  String get importersAnAccount => 'Un account';

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
      'Questa esportazione di Aegis è protetta da password.';

  @override
  String get importersAegisBiometricOnly =>
      'Questa esportazione di Aegis si può aprire solo con l\'impronta digitale sul telefono che l\'ha creata. In Aegis, esporta di nuovo e scegli una password.';

  @override
  String get importersAegisWrongPassword =>
      'Password errata per questa esportazione di Aegis.';

  @override
  String get importersAegisDamaged =>
      'L\'esportazione di Aegis è stata sbloccata ma il suo contenuto è danneggiato.';

  @override
  String get importersNotAegis => 'Quel file non è un\'esportazione di Aegis.';

  @override
  String importersUnsupportedType(String type) {
    return 'usa codici $type, che Tanooki Auth non supporta';
  }

  @override
  String get importersNotTwoFas => 'Quel file non è un backup di 2FAS.';

  @override
  String get importersTwoFasPassword =>
      'Questo backup di 2FAS è protetto da password.';

  @override
  String get importersTwoFasDamaged => 'Questo backup di 2FAS è danneggiato.';

  @override
  String get importersTwoFasWrongPassword =>
      'Password errata per questo backup di 2FAS.';

  @override
  String get importersBitwardenEncrypted =>
      'Quell\'esportazione di Bitwarden è cifrata. In Bitwarden, esporta di nuovo e scegli il formato \".json\" (non \"cifrato\").';

  @override
  String get importersOnePux =>
      'Sembra un file .1pux di 1Password. In 1Password, esporta di nuovo e scegli CSV.';

  @override
  String importersNoCodeColumn(String app) {
    return 'Quel file non ha una colonna per i codici monouso, quindi non è un\'esportazione di $app con dei codici.';
  }

  @override
  String importersCantReadCode(String reason) {
    return 'ha un codice monouso che Tanooki Auth non riesce a leggere ($reason)';
  }

  @override
  String get importersNoSecret => 'non ha una chiave segreta';

  @override
  String get importersBadSecret => 'ha una chiave segreta non valida';

  @override
  String importersUnsupportedDigits(int count) {
    return 'usa codici a $count cifre, che Tanooki Auth non supporta';
  }

  @override
  String get importersBadPeriod => 'ha un periodo di tempo non valido';

  @override
  String importersUnsupportedAlgorithm(String algorithm) {
    return 'usa l\'algoritmo $algorithm, che Tanooki Auth non supporta';
  }

  @override
  String get exportUiTitle => 'Sposta su un\'altra app';

  @override
  String get exportUiAegisLocked => 'Aegis, con password';

  @override
  String get exportUiAegisLockedSub =>
      'La più sicura. Aegis chiede la password durante l\'importazione.';

  @override
  String get exportUiAegisPlain => 'Aegis, non cifrato';

  @override
  String get exportUiAegisPlainSub =>
      'Per le app che leggono i file di Aegis ma non aprono quelli protetti.';

  @override
  String get exportUiTwoFasSub => 'Un file .2fas senza password.';

  @override
  String get exportUiGoogleSub =>
      'Codici QR da scansionare con Google Authenticator.';

  @override
  String get exportUiLinks => 'Link di configurazione (testo normale)';

  @override
  String get exportUiLinksSub =>
      'Un link otpauth:// per riga, per qualsiasi altra app.';

  @override
  String get exportUiConfirmReason => 'Esporta i tuoi account';

  @override
  String get exportUiEncryptingAegis => 'Cifratura per Aegis…';

  @override
  String get exportUiAegisPlainWhat =>
      'Questo salva ogni chiave di configurazione in un file Aegis non cifrato.';

  @override
  String get exportUiTwoFasWhat =>
      'Questo salva ogni chiave di configurazione in un file 2FAS senza password.';

  @override
  String get exportUiGoogleTitle =>
      'Mostrare i codici QR per Google Authenticator?';

  @override
  String get exportUiGoogleBody =>
      'La prossima schermata mostra codici QR che contengono ogni chiave di configurazione. Chiunque li veda o li fotografi può generare i tuoi codici per accedere. Fallo in un posto riservato.\n\nIn Google Authenticator: tocca +, poi \"Scansiona un codice QR\", e scansiona i codici uno alla volta.';

  @override
  String get exportUiShowCodes => 'Mostra i codici';

  @override
  String exportUiExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count account esportati. Importa il file nell\'altra app, poi eliminalo.',
      one: '1 account esportato. Importa il file nell\'altra app, poi eliminalo.',
    );
    return '$_temp0';
  }

  @override
  String get exportUiNoneForGoogle =>
      'Nessuno dei tuoi account può andare in Google Authenticator.';

  @override
  String get exportUiScanThisCode => 'Scansiona questo codice';

  @override
  String exportUiCodeOf(int n, int total) {
    return 'Codice $n di $total';
  }

  @override
  String get exportUiNextCode => 'Codice successivo';

  @override
  String exportUiLeftOut(int count) {
    return 'Esclusi ($count). Google Authenticator non può generare questi codici, quindi aggiungili a un\'altra app:';
  }

  @override
  String get appIconClassic => 'Classica';

  @override
  String get appIconPink => 'Rosa pastello';

  @override
  String get appIconBlue => 'Azzurro pastello';

  @override
  String get appIconLavender => 'Lavanda';

  @override
  String get appIconMint => 'Menta';

  @override
  String get appIconMidnight => 'Mezzanotte';

  @override
  String get appIconSunset => 'Tramonto';

  @override
  String get appIconSpooky => 'Spettrale (autunno)';

  @override
  String get appIconCozy => 'Accogliente (inverno)';

  @override
  String get appIconSpring => 'Primavera';

  @override
  String get serverBrowserExtension => 'Estensione del browser';

  @override
  String get serverBadRequest => 'Tanooki Auth non ha capito quella richiesta.';

  @override
  String get serverLocked => 'Tanooki Auth è bloccata. Sbloccala, poi riprova.';

  @override
  String get serverNotPaired => 'Questa app non è abbinata a Tanooki Auth.';

  @override
  String get serverNotFound => 'Quell\'account non è più in Tanooki Auth.';

  @override
  String get serverRateLimited => 'Troppe richieste.';

  @override
  String get serverDenied =>
      'Non consentito: questo account chiede prima, e Tanooki Auth non è stata sbloccata per questo.';

  @override
  String get serverUnknownScreen => 'Schermata sconosciuta.';

  @override
  String get serverNoWebsite => 'Nessun sito web indicato.';

  @override
  String serverUnknownRequest(String type) {
    return 'Richiesta sconosciuta \"$type\".';
  }

  @override
  String get serverPairingTimedOut =>
      'L\'abbinamento è scaduto o è stato chiuso. Ricomincia l\'abbinamento.';

  @override
  String get serverThreeWrongCodes =>
      'Tre codici errati. Ricomincia l\'abbinamento.';

  @override
  String get serverWrongCode =>
      'Quel codice non corrisponde. Controlla il codice mostrato in Tanooki Auth.';

  @override
  String get serverNoLink => 'Non è stato inviato nessun link otpauth://.';

  @override
  String get serverAlreadyThere => 'Quell\'account è già in Tanooki Auth.';

  @override
  String get serverAlreadyThereMany =>
      'Quegli account sono già in Tanooki Auth.';

  @override
  String get autoBackupNotSupported => 'non supportato su questo dispositivo';

  @override
  String homeProveCopy(String name) {
    return 'Copia il codice di $name';
  }

  @override
  String homeProveReadAloud(String name) {
    return 'Leggi ad alta voce il codice di $name';
  }

  @override
  String homeProveEdit(String name) {
    return 'Modifica $name';
  }

  @override
  String homeProveShare(String name) {
    return 'Condividi $name';
  }

  @override
  String homeProveRecoveryCodes(String name) {
    return 'Vedi i codici di recupero di $name';
  }

  @override
  String homeCopied(String name) {
    return 'Codice di $name copiato. Gli appunti si cancellano tra 30 secondi.';
  }

  @override
  String get homeEditAccount => 'Modifica account';

  @override
  String homeShowQrFor(String name) {
    return 'Mostra il codice QR di $name';
  }

  @override
  String homeMovedToTrash(String name) {
    return '$name spostato nel Cestino. Puoi ripristinarlo da Impostazioni per 30 giorni.';
  }

  @override
  String get homeUndo => 'Annulla';

  @override
  String homeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count account',
      one: '1 account',
    );
    return '$_temp0';
  }

  @override
  String homeAddTagTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aggiungi un tag a $count account',
      one: 'Aggiungi un tag a 1 account',
    );
    return '$_temp0';
  }

  @override
  String get homeTagHint => 'Tag (es. lavoro)';

  @override
  String get homeAddTag => 'Aggiungi tag';

  @override
  String homeTagged(int count, String tag) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tag \"$tag\" aggiunto a $count account.',
      one: 'Tag \"$tag\" aggiunto a 1 account.',
    );
    return '$_temp0';
  }

  @override
  String homeMoveToFolderTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sposta $count account in una cartella',
      one: 'Sposta 1 account in una cartella',
    );
    return '$_temp0';
  }

  @override
  String get homeNoFolder => 'Nessuna cartella';

  @override
  String get homeNewFolderHint => 'Oppure una nuova cartella (es. Lavoro)';

  @override
  String get homeMoveToNewFolder => 'Sposta in una nuova cartella';

  @override
  String homeTookOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count account tolti dalle loro cartelle.',
      one: '1 account tolto dalla sua cartella.',
    );
    return '$_temp0';
  }

  @override
  String homeMovedTo(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count account spostati in $folder.',
      one: '1 account spostato in $folder.',
    );
    return '$_temp0';
  }

  @override
  String homeAddedToFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count account aggiunti ai preferiti.',
      one: '1 account aggiunto ai preferiti.',
    );
    return '$_temp0';
  }

  @override
  String homeRemovedFromFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count account rimossi dai preferiti.',
      one: '1 account rimosso dai preferiti.',
    );
    return '$_temp0';
  }

  @override
  String homeBulkTrashed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count account spostati nel Cestino. Puoi ripristinarli da Impostazioni per 30 giorni.',
      one: '1 account spostato nel Cestino. Puoi ripristinarlo da Impostazioni per 30 giorni.',
    );
    return '$_temp0';
  }

  @override
  String get homeDoneSelecting => 'Fine selezione';

  @override
  String get homeTapToSelect => 'Tocca gli account per selezionarli';

  @override
  String homeSelectedCount(int count) {
    return '$count selezionati';
  }

  @override
  String get homeSelectNone => 'Deseleziona tutto';

  @override
  String get homeSelectAll => 'Seleziona tutto';

  @override
  String get homeAddATag => 'Aggiungi un tag';

  @override
  String get homeMoveToFolder => 'Sposta in cartella';

  @override
  String get homeRemoveFromFavorites => 'Rimuovi dai preferiti';

  @override
  String get homeAddToFavorites => 'Aggiungi ai preferiti';

  @override
  String get homeMoveToTrash => 'Sposta nel Cestino';

  @override
  String get homeSelectFirst =>
      'Prima seleziona qualche account: toccali nell\'elenco.';

  @override
  String homeSectionOpen(String name, String accounts) {
    return '$name, $accounts, tocca per chiudere';
  }

  @override
  String homeSectionClosed(String name, String accounts) {
    return '$name, $accounts, tocca per mostrare';
  }

  @override
  String get homeSearchHint => 'Cerca account o siti web…';

  @override
  String get homeAllTags => 'Tutti';

  @override
  String get homeNoAccountsYet =>
      'Ancora nessun account.\nAggiungine uno per scansionare un codice QR di configurazione.';

  @override
  String get homeNoTagMatches => 'Nessun account con questo tag.';

  @override
  String get homeNoSearchMatches => 'Nessun account corrisponde alla ricerca.';

  @override
  String get homeSelectAccounts => 'Seleziona account';

  @override
  String get homeSettings => 'Impostazioni';

  @override
  String get homeAddAccount => 'Aggiungi account';

  @override
  String get homeAccounts => 'Account';

  @override
  String get homeYourAccounts => 'I tuoi account';

  @override
  String get homeSelect => 'Seleziona';

  @override
  String get homeKeysTouch => 'Tocca (Copia) · Invio (Copia) · Frecce (Naviga)';

  @override
  String get homeKeysClick => 'Clic (Copia) · Invio (Copia) · Frecce (Naviga)';

  @override
  String get homePickOnLeft => 'Scegli un account a sinistra per vederlo qui.';

  @override
  String homeQrFor(String name) {
    return 'Codice QR di $name';
  }

  @override
  String get homeQrWarning =>
      'Scansionalo con un\'altra app di autenticazione per aggiungere lì lo stesso account. Chiunque lo veda o lo fotografi può generare i tuoi codici, quindi tienilo riservato.';

  @override
  String homeVersionNote(Object version) {
    return 'v$version · resta su questo dispositivo';
  }

  @override
  String homeSelectName(String name) {
    return 'Seleziona $name';
  }

  @override
  String get homeMore => 'Altro';

  @override
  String get homeRecoveryCodes => 'Codici di recupero';

  @override
  String homeRecoveryCodesLeft(int count) {
    return 'Codici di recupero ($count rimasti)';
  }

  @override
  String get homeShareSecurely => 'Condividi in modo sicuro';

  @override
  String get homeShowQr => 'Mostra codice QR';

  @override
  String get homeMoveEarlier => 'Sposta prima';

  @override
  String get homeMoveLater => 'Sposta dopo';

  @override
  String homeNextCodeShort(String code) {
    return 'Succ. $code';
  }

  @override
  String get homeNextCode => 'Codice successivo';

  @override
  String get homeFavorite => 'Preferito';

  @override
  String get homeCodeHiddenAsk =>
      'Codice nascosto finché non confermi che sei tu';

  @override
  String get homeCodeHidden => 'Codice nascosto';

  @override
  String homeNextCodeSpoken(String code) {
    return 'Codice successivo $code';
  }

  @override
  String homeKindTotp(int count, int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cifre',
      one: '1 cifra',
    );
    return 'TOTP · $_temp0 · ${seconds}s';
  }

  @override
  String homeKindSteam(int seconds) {
    return 'Steam · 5 caratteri · ${seconds}s';
  }

  @override
  String homeKindHotp(int count, String counter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cifre',
      one: '1 cifra',
    );
    return 'HOTP · $_temp0 · #$counter';
  }

  @override
  String get homeAccountHeading => 'Account';

  @override
  String get homeHintUnselect => 'deseleziona';

  @override
  String get homeHintSelect => 'seleziona';

  @override
  String get homeHintCopy => 'copia il codice';

  @override
  String get homeReadCodeAloud => 'Leggi il codice ad alta voce';

  @override
  String get homeMoreOptions => 'Altre opzioni';

  @override
  String get mainPairRaycastTitle => 'Abbina con Raycast';

  @override
  String get mainPairRaycastBody => 'Digita questo codice in Raycast:';

  @override
  String get mainPairRaycastWarning =>
      'Fallo solo se hai appena avviato tu l\'abbinamento in Raycast.';

  @override
  String get mainPairAlfredTitle => 'Abbina con Alfred';

  @override
  String get mainPairAlfredBody => 'Digita 2fa-pair e questo codice in Alfred:';

  @override
  String get mainPairAlfredWarning =>
      'Fallo solo se hai appena digitato tu 2fa-pair in Alfred.';

  @override
  String get mainPairPowerToysTitle => 'Abbina con PowerToys';

  @override
  String get mainPairPowerToysBody =>
      'Digita questo codice nel Command Palette di PowerToys:';

  @override
  String get mainPairPowerToysWarning =>
      'Fallo solo se hai appena avviato tu l\'abbinamento in PowerToys.';

  @override
  String get mainPairBrowserTitle => 'Abbina con il tuo browser';

  @override
  String get mainPairBrowserBody =>
      'Digita questo codice nell\'estensione del browser di Tanooki Auth:';

  @override
  String get mainPairBrowserWarning =>
      'Fallo solo se hai appena fatto clic tu su \"Abbina\" nell\'estensione.';

  @override
  String mainSendCodeTo(String name, String client) {
    return 'Invia il codice di $name a $client';
  }

  @override
  String mainWrongPasscodeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Codice d\'accesso errato. Ancora $count tentativi sbagliati e verrà cancellato tutto.',
      one: 'Codice d\'accesso errato. Ancora 1 tentativo sbagliato e verrà cancellato tutto.',
    );
    return '$_temp0';
  }

  @override
  String get mainWrongPasscode => 'Codice d\'accesso errato.';

  @override
  String get mainBiometricWindows => 'Windows Hello';

  @override
  String get mainBiometricMac => 'Touch ID';

  @override
  String get mainBiometricOther => 'Face ID o impronta digitale';

  @override
  String get mainLockTitle => 'Bloccare Tanooki Auth?';

  @override
  String get mainLockBody =>
      'Chiedi il tuo volto, l\'impronta digitale o il codice d\'accesso all\'apertura dell\'app, così chi ha in mano il tuo telefono sbloccato non può leggere i tuoi codici. Puoi cambiarlo più tardi in Impostazioni.';

  @override
  String get mainTurnOnLock => 'Attiva il blocco';

  @override
  String get mainUnlockReason => 'Sblocca Tanooki Auth';

  @override
  String get mainStartOverTitle => 'Creare una nuova cassaforte vuota?';

  @override
  String get mainStartOverBody =>
      'Questo sostituisce per sempre quel che resta dei tuoi vecchi account. Fallo solo se non hai un backup da ripristinare, o se hai già disattivato l\'accesso a due fattori su quei siti.';

  @override
  String get mainEraseStartOver => 'Cancella e ricomincia';

  @override
  String get mainRestoreFromBackup => 'Ripristina da backup';

  @override
  String get mainStartNewVault => 'Crea una nuova cassaforte vuota';

  @override
  String get mainLocked => 'Tanooki Auth è bloccata';

  @override
  String mainUseBiometric(String method) {
    return 'Usa $method';
  }

  @override
  String get mainUseSecurityKey => 'Usa la chiave di sicurezza';

  @override
  String homeHidesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Si nasconde tra $count secondi',
      one: 'Si nasconde tra 1 secondo',
    );
    return '$_temp0';
  }

  @override
  String homeCardsMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      'm1': 'gennaio',
      'm2': 'febbraio',
      'm3': 'marzo',
      'm4': 'aprile',
      'm5': 'maggio',
      'm6': 'giugno',
      'm7': 'luglio',
      'm8': 'agosto',
      'm9': 'settembre',
      'm10': 'ottobre',
      'm11': 'novembre',
      'm12': 'dicembre',
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
      'Rifiutato. Non può aprire i tuoi account. Potrà chiedere di nuovo più avanti, e ti verrà chiesto di nuovo.';

  @override
  String get homeCardsClockRight =>
      'Ora l\'orologio è giusto. I codici dovrebbero funzionare.';

  @override
  String get homeCardsCheckAgain => 'Controlla di nuovo';

  @override
  String get homeCardsYourContact => 'Il tuo contatto d\'emergenza';

  @override
  String homeCardsEmergencyWaiting(String who, String left, String day) {
    return '$who ha chiesto l\'accesso d\'emergenza ai tuoi account. A meno che tu non rifiuti, potrà aprirne una copia tra $left ($day).';
  }

  @override
  String homeCardsEmergencyReleased(String who) {
    return '$who ha chiesto l\'accesso d\'emergenza e l\'attesa di 7 giorni è finita, quindi ora può aprire una copia dei tuoi account. Rifiuta per impedirlo.';
  }

  @override
  String get homeCardsBackupNudge =>
      'I tuoi account sono cambiati dall\'ultimo backup. Un file di backup è il modo per recuperarli se perdi questo dispositivo.';

  @override
  String get homeCardsBackUpNow => 'Esegui backup ora';

  @override
  String homeCardsSummaryNew(int count, String month) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il tuo riepilogo di $month: $count nuovi account.',
      one: 'Il tuo riepilogo di $month: 1 nuovo account.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryNoBackup => 'Ancora nessun backup.';

  @override
  String homeCardsSummaryLastBackup(String day) {
    return 'Ultimo backup $day.';
  }

  @override
  String get homeCardsSummaryAllCodes =>
      'Ogni account ha i codici di recupero.';

  @override
  String homeCardsSummaryMissingCodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count account senza codici di recupero.',
      one: '1 account senza codici di recupero.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryCheckupGood =>
      'Controllo di sicurezza: tutto a posto.';

  @override
  String homeCardsSummaryCheckupFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Controllo di sicurezza: $count cose da sistemare.',
      one: 'Controllo di sicurezza: 1 cosa da sistemare.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsOpenCheckup => 'Apri controllo';

  @override
  String get quickPickSelf =>
      'Tanooki Auth era ancora in primo piano, quindi non è stato digitato nulla. Fai clic nella casella da compilare, poi usa di nuovo l\'icona nella barra dei menu.';

  @override
  String quickPickTypeFailed(String reason) {
    return 'Impossibile digitare il codice ($reason). Copialo invece.';
  }

  @override
  String get quickPickTypeUnavailable =>
      'La digitazione dei codici non è disponibile su questo computer. Copialo invece.';

  @override
  String quickPickUseCodeFor(String name) {
    return 'Usa il codice di $name';
  }

  @override
  String get quickPickAllowTitle => 'Consenti a Tanooki Auth di digitare';

  @override
  String get quickPickAllowBody =>
      'Per digitare un codice in un\'altra app, il Mac deve consentire a Tanooki Auth di premere i tasti al posto tuo.\n\n1. Fai clic su \"Apri Impostazioni di Sistema\" qui sotto.\n2. Vedrai un elenco chiamato Accessibilità. Trova Tanooki Auth e attiva il suo interruttore (blu).\n3. Se il Mac chiede la password o Touch ID, forniscili.\n4. Torna qui e fai di nuovo clic su Digita.\n\nTanooki Auth preme i tasti solo quando fai clic su Digita, e digita solo il codice.';

  @override
  String get quickPickOpenSystemSettings => 'Apri Impostazioni di Sistema';

  @override
  String get quickPickTitle => 'Scelta rapida';

  @override
  String get quickPickSearch => 'Cerca account';

  @override
  String get quickPickLinuxNote =>
      'Su Linux non è possibile digitare i codici in altre app. Fai clic su un account per copiarne il codice.';

  @override
  String get quickPickNoMatches => 'Nessun account corrispondente';

  @override
  String get quickPickAsksFirst => '••• •••  (chiede prima)';

  @override
  String get quickPickHiddenAsks => 'Codice nascosto, chiede prima';

  @override
  String get quickPickType => 'Digita';

  @override
  String get codeViewRing => 'Anello';

  @override
  String get codeViewBar => 'Barra';

  @override
  String get codeViewNumber => 'Numero';

  @override
  String codeViewSpoken(String code) {
    return 'Codice $code';
  }

  @override
  String codeViewSpokenLeft(int count, String code) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Codice $code, $count secondi rimasti',
      one: 'Codice $code, 1 secondo rimasto',
    );
    return '$_temp0';
  }

  @override
  String get codeViewReadAloud => 'Leggi il codice ad alta voce';

  @override
  String codeViewSecondsShort(int count) {
    return '${count}s';
  }

  @override
  String get codeViewColorBlue => 'Blu';

  @override
  String get codeViewColorPurple => 'Viola';

  @override
  String get codeViewColorPink => 'Rosa';

  @override
  String get codeViewColorRed => 'Rosso';

  @override
  String get codeViewColorOrange => 'Arancione';

  @override
  String get codeViewColorGold => 'Oro';

  @override
  String get codeViewColorGreen => 'Verde';

  @override
  String get codeViewColorTeal => 'Verde acqua';

  @override
  String get codeViewColorGray => 'Grigio';

  @override
  String trashRestored(String name) {
    return '$name è di nuovo nel tuo elenco.';
  }

  @override
  String trashDeleteTitle(String name) {
    return 'Eliminare $name per sempre?';
  }

  @override
  String get trashDeleteBody =>
      'Non si può annullare. Prima di eliminare, disattiva l\'accesso a due fattori su quel sito web o assicurati di avere i suoi codici di recupero, altrimenti potresti restare chiuso fuori.';

  @override
  String get trashDeleteForGood => 'Elimina per sempre';

  @override
  String get trashTitle => 'Cestino';

  @override
  String get trashEmpty =>
      'Il Cestino è vuoto.\nGli account eliminati restano qui per 30 giorni.';

  @override
  String get trashNote =>
      'Gli account eliminati restano qui per 30 giorni, poi vengono rimossi per sempre.';

  @override
  String get trashRemovedNextOpen =>
      'Verrà rimosso alla prossima apertura dell\'app';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni rimasti',
      one: '1 giorno rimasto',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => 'Ripristina';

  @override
  String get recoveryAddTitle => 'Aggiungi codici di recupero';

  @override
  String get recoveryPasteHint =>
      'Incolla i codici che ti ha dato il sito web, uno per riga';

  @override
  String get recoveryNoneNew =>
      'Nessun nuovo codice trovato in quello che hai incollato.';

  @override
  String recoveryAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count codici aggiunti.',
      one: '1 codice aggiunto.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryCopiedUsed =>
      'Copiato. Attenzione: hai segnato questo codice come usato, quindi probabilmente non funzionerà più.';

  @override
  String get recoveryCopied =>
      'Copiato. Gli appunti si cancellano tra 30 secondi. Segnalo come usato dopo aver effettuato l\'accesso.';

  @override
  String get recoveryRemoveTitle => 'Rimuovere questo codice?';

  @override
  String recoveryRemoveBody(String code) {
    return '$code\n\nRimuovilo solo se il sito web non lo accetta più.';
  }

  @override
  String recoveryTitle(String name) {
    return 'Codici di recupero di $name';
  }

  @override
  String get recoveryAddCodes => 'Aggiungi codici';

  @override
  String get recoveryIntro =>
      'Quando attivi l\'accesso a due fattori, la maggior parte dei siti web ti dà anche un elenco di codici di backup. Ognuno ti fa entrare una volta se dovessi perdere questa app. Incollali qui così restano al sicuro con l\'account.';

  @override
  String recoveryUnusedOf(String unused, int total) {
    return '$unused di $total non usati. Tocca un codice per copiarlo, e spuntalo dopo averlo usato.';
  }

  @override
  String get recoveryUsed => 'Usato';

  @override
  String get detailsEditAccount => 'Modifica account';

  @override
  String get detailsCopyCode => 'Copia codice';

  @override
  String get detailsReadAloud => 'Leggi ad alta voce';

  @override
  String get detailsFolderAndTags => 'Cartella e tag';

  @override
  String get detailsWebsites => 'Siti web';

  @override
  String get detailsNotes => 'Note';

  @override
  String get detailsNotesHidden => 'Nascoste finché non confermi che sei tu.';

  @override
  String get detailsNoNotes => 'Nessuna nota. Aggiungine con Modifica.';

  @override
  String get accountSortCustom => 'Personalizzato (trascina per ordinare)';

  @override
  String get accountSortRecent => 'Usati di recente';

  @override
  String get accountSortName => 'Dalla A alla Z';

  @override
  String get activityCopied => 'Copiato';

  @override
  String get activityFilled => 'Inserito';

  @override
  String get activityTyped => 'Digitato';

  @override
  String get activityShownQr => 'Codice QR mostrato';

  @override
  String get activityExported => 'Esportato';

  @override
  String get activityPlaceThisApp => 'Questa app';

  @override
  String get activityPlaceBackupFile => 'File di backup';

  @override
  String get activityPlaceSetupLinks => 'File di link di configurazione';

  @override
  String get activityPlacePaperBackup => 'PDF del backup cartaceo';

  @override
  String get activityPlaceGoogleQr => 'Codici QR di Google Authenticator';

  @override
  String totpBadCharacter(String char) {
    return 'Non è una chiave segreta base32 valida (carattere non valido \"$char\")';
  }

  @override
  String get totpEmpty => 'La chiave segreta è vuota';

  @override
  String get vaultFileMissing =>
      'Il file dei tuoi account manca. Se hai un backup, ripristinalo. Altrimenti puoi creare una nuova cassaforte vuota.';

  @override
  String get vaultKeyMissing =>
      'La chiave che sblocca i tuoi account manca dall\'archivio sicuro di questo dispositivo. Ripristina un backup per recuperare i tuoi account.';

  @override
  String get vaultDecryptFailed =>
      'Impossibile sbloccare il file dei tuoi account. Potrebbe essere danneggiato o modificato fuori dall\'app. Ripristina un backup.';

  @override
  String get vaultBadJson =>
      'Il file dei tuoi account è stato sbloccato ma il suo contenuto è danneggiato. Ripristina un backup.';

  @override
  String clockCheckBadAnswer(String status) {
    return 'Il server dell\'ora ha inviato una risposta che l\'app non capisce (HTTP $status).';
  }

  @override
  String clockCheckOff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'L\'orologio del dispositivo è indietro o avanti di circa $count minuti, quindi i codici non funzioneranno. Attiva l\'ora automatica in Impostazioni.',
      one: 'L\'orologio del dispositivo è indietro o avanti di circa 1 minuto, quindi i codici non funzioneranno. Attiva l\'ora automatica in Impostazioni.',
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
  String get keysTitle => 'Scorciatoie da tastiera';

  @override
  String get keysWhere => 'Nell\'elenco degli account e in Scelta rapida.';

  @override
  String get keysMove => 'Spostati su e giù nell\'elenco';

  @override
  String get keysEnter => 'Invio';

  @override
  String get keysCopy => 'Copia il codice evidenziato';

  @override
  String get keysAnyLetter => 'Una lettera';

  @override
  String get keysSearch => 'Inizia a cercare';

  @override
  String get keysEsc => 'Esc';

  @override
  String get keysClear => 'Cancella la ricerca';

  @override
  String get keysShowList => 'Mostra questo elenco';

  @override
  String get settingsKeysShortcutMac => 'Premi ⌘/ ovunque per vederle';

  @override
  String get settingsKeysShortcutOther => 'Premi Ctrl+/ ovunque per vederle';

  @override
  String trayTooltip(String name, int seconds) {
    return 'Tanooki Auth: $name, $seconds s rimasti';
  }

  @override
  String get settingsTrayCountdownMac =>
      'Mostra il conto alla rovescia nella barra dei menu';

  @override
  String get settingsTrayCountdownMacHelp =>
      'I secondi rimasti per il tuo primo preferito, accanto all\'icona nella barra dei menu. Mai il codice stesso.';

  @override
  String get settingsTrayCountdownWindows =>
      'Mostra il conto alla rovescia sull\'icona nell\'area di notifica';

  @override
  String get settingsTrayCountdownWindowsHelp =>
      'Punta l\'icona di Tanooki Auth vicino all\'orologio per vedere quanti secondi restano al tuo primo preferito. Mai il codice stesso.';

  @override
  String get unusedTitle => 'Account che non usi mai';

  @override
  String get settingsUnusedHelp => 'Nessun codice copiato da 6 mesi o più';

  @override
  String get unusedIntro =>
      'Per questi account non è stato copiato un codice in questa app da 6 mesi o più. Se non usi più il sito web, prima disattiva lì l\'accesso a due fattori, poi fai ordine qui. Il Cestino li conserva per 30 giorni.';

  @override
  String get unusedNone =>
      'Ogni account è stato usato negli ultimi 6 mesi. Niente da riordinare.';

  @override
  String unusedLastUsed(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Ultimo uso $dateString';
  }

  @override
  String unusedNeverUsed(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Mai usato qui. Aggiunto $dateString';
  }

  @override
  String get unusedPickFirst => 'Prima spunta uno o più account.';

  @override
  String get unusedTagSuggestion => 'inutilizzato';

  @override
  String checkupUnusedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count account che non usi mai',
      one: '1 account che non usi mai',
    );
    return '$_temp0';
  }

  @override
  String get checkupUnusedBody =>
      'Nessun codice copiato da 6 mesi o più. È facile non accorgersi se un vecchio account dimenticato viene violato.';

  @override
  String get checkupUnusedReview => 'Controllali';

  @override
  String get halvesTitle => 'Backup cartaceo in due metà';

  @override
  String get settingsHalvesHelp =>
      'Due serie di pagine. Ogni metà da sola non rivela nulla';

  @override
  String get halvesRestoreTitle => 'Ripristina da due metà';

  @override
  String get settingsHalvesRestoreHelp =>
      'Scansiona i codici su entrambe le metà di un backup cartaceo';

  @override
  String get halvesExplain =>
      'Questo stampa il tuo backup cifrato come due serie di pagine separate, Metà A e Metà B.\n\nOgni metà da sola è solo rumore casuale: nessuno può ricavarne nulla, nemmeno con la tua passphrase. Per ripristinare servono entrambe le metà e la passphrase.\n\nTieni le metà in due posti diversi, per esempio una a casa e una presso una persona di fiducia.';

  @override
  String get halvesHalfA => 'Metà A di 2';

  @override
  String get halvesHalfB => 'Metà B di 2';

  @override
  String halvesPart(String which, int part, int parts) {
    return 'Metà $which · parte $part di $parts';
  }

  @override
  String halvesPdfHeader(String date) {
    return 'Backup cartaceo di Tanooki Auth, creato il $date';
  }

  @override
  String get halvesPdfExplain =>
      'Questa metà da sola è inutile. Per ripristinare: in Tanooki Auth, apri Impostazioni > Ripristina da due metà, scansiona ogni codice su entrambe le metà, poi digita la passphrase del backup. Tieni le due metà in posti diversi.';

  @override
  String halvesPdfPage(String half, int page, int pages) {
    return '$half, pagina $page di $pages';
  }

  @override
  String get halvesNowB => 'Ora salva la Metà B';

  @override
  String get halvesNowBBody =>
      'La Metà A è salvata. La Metà B è l\'altra metà: stampa anche questa e tienila in un altro posto.';

  @override
  String get halvesSaveB => 'Salva la Metà B';

  @override
  String get halvesOnlyA =>
      'È stata salvata solo la Metà A. La Metà A da sola non può ripristinare nulla, quindi crea di nuovo entrambe le metà quando sei pronto.';

  @override
  String get halvesReady =>
      'Entrambe le metà sono pronte. Stampale e tienile in posti diversi.';

  @override
  String get halvesRestoreIntro =>
      'Scansiona ogni codice su entrambe le metà, in qualsiasi ordine. Quando sono complete, digita la passphrase che hai scelto quando hai creato il backup.';

  @override
  String halvesNotStarted(String half) {
    return '$half: ancora nessun codice scansionato';
  }

  @override
  String halvesProgress(String half, int have, int total) {
    return '$half: $have di $total codici';
  }

  @override
  String get halvesScan => 'Scansiona codici';

  @override
  String get halvesScanTitle => 'Scansiona entrambe le metà';

  @override
  String get halvesPictures => 'Apri immagini dei codici';

  @override
  String halvesSomeUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'In $count immagini non c\'era un codice leggibile da questa app. Prova con un\'immagine più ravvicinata di un solo codice.',
      one: 'In 1 immagine non c\'era un codice leggibile da questa app. Prova con un\'immagine più ravvicinata di un solo codice.',
    );
    return '$_temp0';
  }

  @override
  String get halvesNotAHalf =>
      'Non è un codice di un backup cartaceo in due metà.';

  @override
  String get halvesOtherSet =>
      'Quel codice appartiene a un altro backup cartaceo. Usa entrambe le metà della stessa stampa.';

  @override
  String get halvesAlreadyHave =>
      'Già scansionato. Passa al codice successivo.';

  @override
  String get halvesDontFit =>
      'Queste metà non combaciano. Un codice potrebbe essere stato letto male, oppure le metà vengono da backup diversi. Ricomincia la scansione.';

  @override
  String get halvesRestoreNow => 'Entrambe le metà scansionate: ripristina';

  @override
  String get healthTitle => 'Stato generale';

  @override
  String get settingsHealthHelp =>
      'Sincronizzazione, backup, orologio, blocco e codici di recupero in una sola schermata';

  @override
  String get healthIntro =>
      'Verde significa tutto a posto. Giallo merita un\'occhiata, e il suo pulsante lo sistema.';

  @override
  String get healthGood => 'A posto';

  @override
  String get healthLook => 'Da controllare';

  @override
  String get healthSync => 'Sincronizzazione';

  @override
  String get healthSyncOff =>
      'Non configurata. La sincronizzazione mantiene i tuoi account uguali su tutti i dispositivi.';

  @override
  String healthSyncOk(String when) {
    return 'Ultima sincronizzazione $when';
  }

  @override
  String healthSyncStale(String when) {
    return 'Ultima sincronizzazione $when. È passato un po\': apri Sincronizzazione per vedere cosa non va.';
  }

  @override
  String get healthOpenSync => 'Apri Sincronizzazione';

  @override
  String get healthSetUp => 'Configura';

  @override
  String get healthOpen => 'Apri';

  @override
  String get healthBackup => 'Backup';

  @override
  String get healthBackupNever =>
      'Ancora nessun backup. Se perdi questo dispositivo, i tuoi account se ne vanno con lui.';

  @override
  String healthBackupOk(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Ultimo backup $dateString';
  }

  @override
  String healthBackupOld(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Ultimo backup $dateString. Sono passati più di 30 giorni: fanne uno nuovo.';
  }

  @override
  String get healthClock => 'Orologio';

  @override
  String get healthClockNotChecked =>
      'Non ancora controllato. I codici funzionano solo se l\'orologio di questo dispositivo è giusto.';

  @override
  String healthClockOk(String when) {
    return 'L\'orologio è giusto (controllato $when).';
  }

  @override
  String get healthCheckNow => 'Controlla ora';

  @override
  String get healthPhoneLink => 'Collegamento al telefono';

  @override
  String healthPhoneLinkOk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abbinato a $count browser',
      one: 'Abbinato a 1 browser',
    );
    return '$_temp0';
  }

  @override
  String get healthPhoneLinkOff =>
      'Non abbinato. Abbina il browser del tuo computer per approvare i codici per accedere da questo telefono.';

  @override
  String get healthLock => 'Blocco';

  @override
  String get healthLockOn =>
      'Attivo. L\'app chiede chi sei prima di mostrare i codici.';

  @override
  String get healthLockOff =>
      'Disattivo. Chiunque prenda questo dispositivo può vedere i tuoi codici.';

  @override
  String get healthGoToSettings => 'Vai all\'interruttore del blocco';

  @override
  String get healthRecovery => 'Codici di recupero';

  @override
  String healthRecoveryCount(int count, int total) {
    return '$count account su $total hanno codici di recupero salvati.';
  }

  @override
  String get healthRecoveryNoAccounts => 'Ancora nessun account.';

  @override
  String get healthAddCodes => 'Aggiungi codici';

  @override
  String get syncErrorWiped =>
      'Un altro dispositivo ha cancellato Tanooki Auth su questo dispositivo. Tutto ciò che conteneva è stato eliminato ed è uscito dalla sincronizzazione.';

  @override
  String get syncUiEraseDevice => 'Cancella questo dispositivo';

  @override
  String get syncUiEraseTitle => 'Cancellare questo dispositivo?';

  @override
  String get syncUiEraseBody =>
      'La prossima volta che quel dispositivo va online, Tanooki Auth su di esso elimina tutto: account, impostazioni, widget e voci di ricerca. Esce anche dalla sincronizzazione per sempre. Non si può annullare. Su questo dispositivo e sugli altri tuoi dispositivi non cambia nulla.';

  @override
  String get syncUiEraseButton => 'Cancellalo';

  @override
  String get syncUiErased =>
      'Fatto. Quel dispositivo si cancellerà la prossima volta che va online.';

  @override
  String syncUiClashes(int count) {
    return 'Conflitti di sincronizzazione ($count)';
  }

  @override
  String get syncUiClashesHelp =>
      'Un account è stato modificato su due dispositivi prima che si sincronizzassero. Scegli quale versione tenere.';

  @override
  String get syncUiClashTitle => 'Conflitti di sincronizzazione';

  @override
  String get syncUiClashIntro =>
      'Ogni account qui sotto è stato modificato su due dispositivi prima che si sincronizzassero. La sincronizzazione ha usato la modifica più recente. Se vuoi l\'altra versione, tocca Tieni questa sotto di essa.';

  @override
  String get syncUiClashNone => 'Nessun conflitto. Niente da scegliere.';

  @override
  String get syncUiClashInUse => 'In uso ora';

  @override
  String get syncUiClashOther => 'Altra versione';

  @override
  String get syncUiClashKeep => 'Tieni questa';

  @override
  String get syncUiClashKept =>
      'Fatto. Gli altri tuoi dispositivi riceveranno questa versione alla prossima sincronizzazione.';

  @override
  String syncUiClashEdited(String when) {
    return 'Modificato $when';
  }

  @override
  String get syncUiClashName => 'Nome';

  @override
  String get syncUiClashAccount => 'Account';

  @override
  String get syncUiClashFolder => 'Cartella';

  @override
  String get syncUiClashNotes => 'Note';

  @override
  String get syncUiClashInTrash => 'Nel Cestino';

  @override
  String get syncUiClashSecret => 'Chiave di configurazione';

  @override
  String get syncUiClashSecretDifferent => 'diversa';

  @override
  String get syncUiClashYes => 'Sì';

  @override
  String get syncUiClashNo => 'No';

  @override
  String get syncUiClashOtherDiffers =>
      'Anche altre impostazioni sono diverse, come l\'aspetto, il sito web o i codici di recupero.';

  @override
  String get teamRoleAdmin => 'Admin';

  @override
  String get teamRoleMember => 'Membro';

  @override
  String get teamRoleViewer => 'Sola lettura';

  @override
  String get teamRoleOwner => 'Proprietario';

  @override
  String get teamUiMakeAdmin => 'Rendi admin';

  @override
  String get teamUiMakeMember => 'Rendi membro';

  @override
  String get teamUiMakeViewer => 'Rendi sola lettura';

  @override
  String get teamUiRoleChanged => 'Ruolo cambiato.';

  @override
  String get teamUiInviteRole => 'Entra come';

  @override
  String get teamUiRoleHelp =>
      'Gli admin invitano e rimuovono persone e vedono il registro attività. I membri usano e modificano gli account del team. Chi è in sola lettura può usare gli account ma non modificarli.';

  @override
  String get teamUiInviteEmailLabel => 'La sua email (facoltativa)';

  @override
  String get teamUiInviteEmailHint => 'nome@esempio.com';

  @override
  String get teamUiInviteMake => 'Crea invito';

  @override
  String teamUiInviteEmailed(String email) {
    return 'Invito inviato a $email.';
  }

  @override
  String get teamUiEmailNotSetUp =>
      'L\'invio di email non è ancora configurato. Copia il link qui sotto e invialo tu.';

  @override
  String teamUiEmailFailed(String reason) {
    return 'L\'email non è partita ($reason). Copia il link qui sotto e invialo tu.';
  }

  @override
  String get teamUiYoureAdmin => 'Sei admin di questo team';

  @override
  String get teamUiYoureViewer => 'Fai parte di un team (sola lettura)';

  @override
  String get teamUiViewOnly =>
      'Puoi usare questi account, ma solo admin e membri possono modificarli.';

  @override
  String get teamUiActivity => 'Attività';

  @override
  String get teamUiActivityTitle => 'Attività del team';

  @override
  String get teamUiActivityHelp =>
      'Chi ha copiato o modificato gli account del team, e quando. Lo vedono solo gli admin. Conservata per 90 giorni, fino alle ultime 2.000 voci.';

  @override
  String get teamUiActivityEmpty =>
      'Ancora niente. Qui compaiono copie e modifiche agli account del team.';

  @override
  String teamActCopy(String name) {
    return 'Ha copiato un codice di $name';
  }

  @override
  String teamActFill(String name) {
    return 'Ha inserito un codice di $name';
  }

  @override
  String teamActAdd(String name) {
    return 'Ha aggiunto $name';
  }

  @override
  String teamActEdit(String name) {
    return 'Ha modificato $name';
  }

  @override
  String teamActDelete(String name) {
    return 'Ha rimosso $name';
  }

  @override
  String get teamUiBuyBusiness => 'Piano Business: 3 \$ a persona all\'anno';

  @override
  String get teamUiBusinessSoon =>
      'Piano Business per team di più di 10 persone (3 \$ a persona all\'anno): in arrivo.';

  @override
  String themeCustom(int n) {
    return 'Il mio tema $n';
  }

  @override
  String get themeMakeOwn => 'Crea il tuo';

  @override
  String get themeMakeOwnPremium => 'Crea il tuo tema, Premium';

  @override
  String get themeEditOwn => 'Modifica questo tema';

  @override
  String get themeEditorTitle => 'Il tuo tema';

  @override
  String get themeEditorAccent => 'Colore principale';

  @override
  String get themeEditorBackground => 'Sfondo';

  @override
  String get themeEditorCard => 'Schede';

  @override
  String get themeEditorText => 'Testo';

  @override
  String get themeEditorHue => 'Tonalità';

  @override
  String themeEditorSwatch(String hex) {
    return 'Colore $hex';
  }

  @override
  String get themeEditorPreview => 'Anteprima';

  @override
  String get themeEditorSample => 'Account di esempio';

  @override
  String get themeEditorSampleHint => 'Tocca per copiare';

  @override
  String get themeEditorSave => 'Salva tema';

  @override
  String get themeEditorDelete => 'Elimina tema';

  @override
  String get themeEditorAdjusted =>
      'Alcuni colori sono stati regolati perché testo e pulsanti restino facili da leggere.';

  @override
  String get themeEditorUnreadable =>
      'Con questi colori il testo non può essere facile da leggere. Prova un colore delle schede più vicino allo sfondo.';

  @override
  String get themeEditorFull =>
      'Hai già 3 temi. Eliminane uno per crearne un altro.';

  @override
  String get settingsSeasonal => 'Cambia con le stagioni';

  @override
  String get settingsSeasonalPremium => 'Cambia con le stagioni (Premium)';

  @override
  String get settingsSeasonalHelp =>
      'Spettrale in autunno, Accogliente in inverno e Primavera in primavera; la tua scelta in estate. Anche l\'icona stagionale dell\'app cambia di conseguenza.';

  @override
  String get helpNew040a =>
      'Inserisci i codici con la compilazione automatica su iPhone e Android.';

  @override
  String get helpNew040b =>
      'Condividi un\'immagine QR con l\'app per aggiungere un account. Su Mac, trascinala nella finestra.';

  @override
  String get helpNew040c =>
      'Frecce, Invio e un elenco di scorciatoie (⌘/ o Ctrl+/) sul computer, più un conto alla rovescia nella barra dei menu.';

  @override
  String get helpNew040d =>
      'Trova gli account che non usi mai e stampa un backup cartaceo in due metà.';

  @override
  String get helpNew040e => 'Nuova schermata Controllo stato.';

  @override
  String get helpNew040f =>
      'Cancella un dispositivo perso da un altro e risolvi i conflitti di sincronizzazione.';

  @override
  String get helpNew040g =>
      'Ruoli nel team, registro attività del team, inviti via email e un piano Business (in arrivo).';

  @override
  String get helpNew040h =>
      'Crea il tuo tema, temi stagionali e un widget Smart Stack per Apple Watch.';

  @override
  String get helpNew040i =>
      'Cinque lingue in più: portoghese, italiano, coreano, cinese e olandese.';
}
