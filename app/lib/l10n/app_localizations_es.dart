// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonOk => 'Aceptar';

  @override
  String get commonRemove => 'Quitar';

  @override
  String get commonUnlock => 'Desbloquear';

  @override
  String get commonTurnOff => 'Desactivar';

  @override
  String get commonNotNow => 'Ahora no';

  @override
  String get commonNext => 'Siguiente';

  @override
  String get commonDone => 'Listo';

  @override
  String get commonDeny => 'Denegar';

  @override
  String get commonAllow => 'Permitir';

  @override
  String get commonTryAgain => 'Intentar de nuevo';

  @override
  String get commonStop => 'Detener';

  @override
  String get commonShare => 'Compartir';

  @override
  String get commonOpen => 'Abrir';

  @override
  String get commonCopy => 'Copiar';

  @override
  String get commonContinueLabel => 'Continuar';

  @override
  String get commonClear => 'Borrar';

  @override
  String get commonBack => 'Atrás';

  @override
  String get commonAdd => 'Añadir';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonYes => 'Sí';

  @override
  String get commonNo => 'No';

  @override
  String get commonSeePremium => 'Ver Premium';

  @override
  String get commonPremiumBadge => 'Premium';

  @override
  String get commonAppName => 'Tanooki Auth';

  @override
  String get googleMigrationUnreadable =>
      'No se pudo leer ese código de Google Authenticator.';

  @override
  String get googleMigrationDamaged =>
      'Ese código de Google Authenticator está dañado.';

  @override
  String get googleMigrationEmpty =>
      'Ese código de Google Authenticator no contiene cuentas.';

  @override
  String get googleMigrationNoSecret =>
      'Una cuenta de ese código no tiene clave secreta.';

  @override
  String get googleMigrationMd5 =>
      'Una cuenta de ese código usa MD5, que Tanooki Auth no admite.';

  @override
  String get googleCantTakeSteam => 'códigos de Steam';

  @override
  String googleCantTakeDigits(int digits) {
    return 'códigos de $digits dígitos';
  }

  @override
  String googleCantTakePeriod(int seconds) {
    return 'códigos que cambian cada $seconds segundos';
  }

  @override
  String get otpauthNotALink => 'Eso no es un enlace otpauth://.';

  @override
  String get otpauthNoSecret => 'El enlace no tiene clave secreta.';

  @override
  String otpauthUnsupportedType(String type) {
    return 'Tipo de código no compatible: \"$type\".';
  }

  @override
  String otpauthUnsupportedAlgorithm(String algorithm) {
    return 'Algoritmo no compatible: \"$algorithm\".';
  }

  @override
  String get otpauthBadDigits => 'Los dígitos deben ser 6, 7 u 8.';

  @override
  String get otpauthBadPeriod => 'El intervalo debe ser un número positivo.';

  @override
  String get otpauthBadCounter => 'El contador debe ser cero o más.';

  @override
  String get phoneLinkNotAPairingCode =>
      'Eso no es un código de emparejamiento del navegador de Tanooki Auth.';

  @override
  String phoneLinkNotSavedFor(String host) {
    return 'Esa cuenta no está guardada para $host.';
  }

  @override
  String get phoneLinkPushNotSetUp =>
      'Las notificaciones aún no están configuradas en el servidor de Tanooki Auth, así que las solicitudes solo aparecen con la app abierta.';

  @override
  String phoneLinkPushFailed(int status) {
    return 'No se pudieron activar las notificaciones (HTTP $status).';
  }

  @override
  String get qrImageNotAPicture =>
      'Ese archivo no es una imagen que la app pueda leer.';

  @override
  String get qrImageNoQr => 'No se encontró ningún código QR en esa imagen.';

  @override
  String relayBadAnswer(int status) {
    return 'El servidor de sincronización envió una respuesta que la app no entiende (HTTP $status).';
  }

  @override
  String get relayUnreachable =>
      'No se puede conectar con el servidor de sincronización. Revisa tu conexión a internet.';

  @override
  String get relayTimeout =>
      'El servidor de sincronización no respondió a tiempo. Revisa tu conexión a internet.';

  @override
  String get relayInsecure =>
      'No se pudo establecer una conexión segura con el servidor de sincronización.';

  @override
  String relaySaidNo(int status) {
    return 'El servidor de sincronización lo rechazó (HTTP $status).';
  }

  @override
  String get shareNotAShare =>
      'Eso no es una cuenta compartida de Tanooki Auth.';

  @override
  String get shareExpired =>
      'Este enlace compartido caducó (solo duran 24 horas). Pide uno nuevo.';

  @override
  String get shareWrongCode =>
      'Código incorrecto o el enlace compartido está dañado. Revisa los 6 dígitos e inténtalo de nuevo.';

  @override
  String get storeServerUnreachable =>
      'No se puede conectar con el servidor de Tanooki Auth. Revisa tu conexión a internet e inténtalo de nuevo.';

  @override
  String get storeBadKey =>
      'El servidor envió una clave de licencia que esta app no acepta.';

  @override
  String storeReportedProblem(String problem) {
    return 'La tienda informó de un problema: $problem';
  }

  @override
  String get storeGooglePlayUnavailable =>
      'Google Play no está disponible en este dispositivo, así que Premium no se puede comprar aquí. Si compraste Premium en otro sitio, escribe tu clave de licencia abajo.';

  @override
  String get storeAppStoreUnavailable =>
      'El App Store no está disponible ahora mismo. Revisa tu conexión a internet e inténtalo de nuevo.';

  @override
  String storeNotListed(String store) {
    return '$store no mostró Premium en este momento. Inténtalo de nuevo en un rato.';
  }

  @override
  String storeNotListedWithError(String store, String problem) {
    return '$store no mostró Premium en este momento ($problem). Inténtalo de nuevo en un rato.';
  }

  @override
  String storePricesFailed(String problem) {
    return 'No se pudieron cargar los precios de la tienda: $problem';
  }

  @override
  String storePurchaseCouldNotStart(String problem) {
    return 'No se pudo iniciar la compra: $problem';
  }

  @override
  String storeNothingToRestore(String store) {
    return 'No se encontró ninguna compra de Premium en esta cuenta de $store.';
  }

  @override
  String storeRestoreFailed(String problem) {
    return 'No se pudieron restaurar las compras: $problem';
  }

  @override
  String get storePending =>
      'Esperando a que se apruebe el pago. Premium se desbloquea en cuanto se apruebe.';

  @override
  String get storeCanceled => 'Compra cancelada. No se te cobró nada.';

  @override
  String storeFailed(String problem) {
    return 'La compra no se completó: $problem. No se te cobró nada.';
  }

  @override
  String get storeFailedNoReason =>
      'La compra no se completó: la tienda no dio ningún motivo. No se te cobró nada.';

  @override
  String get storeUnlocked => 'Premium desbloqueado. ¡Muchísimas gracias!';

  @override
  String get storeUnlockedWithKey =>
      'Premium desbloqueado. Abajo tienes tu clave de licencia para tus computadoras.';

  @override
  String storeUnlockedKeyFailed(String problem) {
    return 'Premium está desbloqueado en este dispositivo. Aún no se pudo crear la clave para tus computadoras: $problem Toca Restaurar compras más tarde para intentarlo de nuevo.';
  }

  @override
  String storeServerSaidNo(int status) {
    return 'El servidor lo rechazó (HTTP $status).';
  }

  @override
  String get syncGroupExists =>
      'Ya existe un grupo de sincronización con esta frase de contraseña. En un dispositivo que ya sincroniza, toca \"Añadir un dispositivo\" y escanea su código.';

  @override
  String get syncNotASyncCode =>
      'Eso no es un código de sincronización de Tanooki Auth. En un dispositivo que ya sincroniza, abre Ajustes, Sincronización, Añadir un dispositivo.';

  @override
  String get syncWrongPassphrase =>
      'Esa frase de contraseña no coincide con la de tus otros dispositivos. Revísala e inténtalo de nuevo.';

  @override
  String get syncICloudOtherPassphrase =>
      'Tus otros dispositivos Apple sincronizan con otra frase de contraseña. Escribe esa o empieza de cero con esta.';

  @override
  String get syncErrorRemoved =>
      'Este dispositivo se quitó de la sincronización desde otro dispositivo. Desactiva la sincronización y vuelve a activarla para unirte de nuevo.';

  @override
  String get syncErrorTurnedOff =>
      'La sincronización se desactivó desde otro dispositivo. Desactívala aquí también y vuelve a activarla para empezar de nuevo.';

  @override
  String get syncErrorTooOften =>
      'Se está sincronizando con demasiada frecuencia. Volverá a intentarlo en unos minutos.';

  @override
  String get syncErrorLimit =>
      'Llegaste al límite de sincronización (2.000 cuentas, incluidas las eliminadas).';

  @override
  String syncErrorICloud(String problem) {
    return 'iCloud Drive tuvo un problema: $problem.';
  }

  @override
  String syncErrorUnexpected(String problem) {
    return 'La sincronización se detuvo por un problema inesperado: $problem';
  }

  @override
  String get syncICloudAppleOnly =>
      'iCloud solo funciona en iPhone, iPad y Mac.';

  @override
  String get syncICloudSignedOut =>
      'iCloud Drive está desactivado en este dispositivo. Inicia sesión en iCloud y activa iCloud Drive en Ajustes para usarlo.';

  @override
  String get syncICloudNotInBuild =>
      'La sincronización con iCloud aún no está activada en esta versión de Tanooki Auth. Por ahora usa el relay de Tanooki; funciona en todos los dispositivos.';

  @override
  String get teamKeyUnopenable =>
      'No se pudo abrir la clave del equipo enviada a este dispositivo. Pide al administrador del equipo que quite este dispositivo y lo vuelva a invitar.';

  @override
  String get teamNotAnInvite =>
      'Eso no es una invitación de equipo de Tanooki Auth. Pide al administrador del equipo un nuevo enlace o código QR de invitación.';

  @override
  String get teamNotInTeam => 'Este dispositivo no está en ningún equipo.';

  @override
  String get teamDeletedByAdmin => 'El administrador eliminó este equipo.';

  @override
  String get teamDeviceRemoved => 'Este dispositivo se quitó del equipo.';

  @override
  String get teamAlreadyInTeam => 'Este dispositivo ya está en un equipo.';

  @override
  String get teamNotALicense =>
      'Esa no es una licencia de equipo. Empieza por TT1. y aparece en la página que muestra Stripe después de suscribirte.';

  @override
  String get teamAlreadyInTeamLeaveFirst =>
      'Este dispositivo ya está en un equipo. Sal de él primero.';

  @override
  String get teamGone =>
      'Ese equipo ya no existe. Pide al administrador del equipo una nueva invitación.';

  @override
  String get teamInviteUsed =>
      'Esa invitación ya se usó o caducó (duran 7 días y sirven una sola vez). Pide una nueva al administrador del equipo.';

  @override
  String get teamFull =>
      'Ese equipo está lleno (10 personas). El administrador tiene que quitar a alguien primero.';

  @override
  String get aboutTitle => 'Sobre Maddie';

  @override
  String get aboutP1 =>
      'Soy Maddie, una desarrolladora autista a la que le importa, quizá un poco demasiado, hacer bien los pequeños detalles.';

  @override
  String get aboutP2 =>
      'Creo firmemente en la privacidad. Las claves que protegen tus cuentas son de los datos más personales que existen, así que Tanooki Auth las guarda cifradas en tu propio dispositivo. Sin cuenta, sin anuncios, sin rastreo, y nunca se me envía nada.';

  @override
  String get aboutP3 =>
      'Tanooki Auth es gratis y quiero que siga así. Tu apoyo es lo que me permite seguir creando apps de privacidad gratuitas como esta. Si Tanooki Auth te va bien, puede que las demás también: están en madilynthomas.com.';

  @override
  String get aboutP4 =>
      'Así que, de mí para ti: gracias. No solo estás usando una app: estás haciendo posible toda esta forma de vivir.';

  @override
  String get aboutSupportAddress =>
      'Apoya mi trabajo: tanookistudios.com/support';

  @override
  String get aboutSupport => 'Apoya mi trabajo';

  @override
  String get aboutCredits => 'Créditos';

  @override
  String get aboutCreditsBody =>
      'Los códigos QR se leen con jsQR (Apache 2.0) en la extensión del navegador y con ZXing en la app. Sin relación con Google, Twilio ni Authy; Google Authenticator es una marca comercial de Google LLC.';

  @override
  String get addFromBrowserOne => '¿Añadir desde tu navegador?';

  @override
  String addFromBrowserMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Añadir $count cuentas desde tu navegador?',
      one: '¿Añadir 1 cuenta desde tu navegador?',
    );
    return '$_temp0';
  }

  @override
  String get addFromGoogleTransfer =>
      'De un código de transferencia de Google Authenticator:';

  @override
  String addCount(int count) {
    return 'Añadir $count';
  }

  @override
  String get addNoColor => 'Sin color';

  @override
  String addColorName(String name) {
    return 'Color $name';
  }

  @override
  String get addServiceLabel => 'Servicio (p. ej., GitHub)';

  @override
  String get addAccountLabel => 'Cuenta (p. ej., tu correo)';

  @override
  String get addWebsiteLabel => 'Sitio web (opcional)';

  @override
  String get addWebsiteHelp =>
      'p. ej., github.com. La extensión del navegador solo rellena códigos aquí.';

  @override
  String get addTagsLabel => 'Etiquetas (opcional)';

  @override
  String get addTagsHelp => 'p. ej., trabajo, juegos. Sepáralas con comas.';

  @override
  String get addFolderLabel => 'Carpeta (opcional)';

  @override
  String get addFolderHelp =>
      'p. ej., Trabajo. Déjalo vacío para no usar carpeta.';

  @override
  String get addPickFolder => 'Elegir una carpeta';

  @override
  String get addNoFolder => 'Sin carpeta';

  @override
  String get addNotesLabel => 'Notas (opcional)';

  @override
  String get addColorLabel => 'Color (opcional)';

  @override
  String get addEmojiLabel => 'Emoji (opcional)';

  @override
  String get addEmojiHelp =>
      'Se muestra en lugar del logo, aquí, en los widgets y en el reloj.';

  @override
  String addUseEmoji(String emoji) {
    return 'Usar $emoji';
  }

  @override
  String addRequireAuth(String proof) {
    return 'Pedir $proof antes de mostrar este código';
  }

  @override
  String get addRequireAuthHelp =>
      'El código queda oculto en la lista, y los widgets, el reloj y Selección rápida nunca lo muestran.';

  @override
  String get addTravelHide => 'Ocultar en modo viaje';

  @override
  String get addTravelHidePremium => 'Ocultar en modo viaje (Premium)';

  @override
  String get addTravelHideHelp =>
      'Cuando el modo viaje está activado (Ajustes), esta cuenta desaparece de la app hasta que lo desactives.';

  @override
  String get addTravelNeedsPremium =>
      'El modo viaje es parte de Premium. Consíguelo en Ajustes > Obtener Premium.';

  @override
  String get addAdvanced => 'Avanzado';

  @override
  String get addAdvancedExisting =>
      'Cambia esto solo si el sitio web te lo indicó. Una configuración incorrecta genera códigos incorrectos y el sitio web los rechazará.';

  @override
  String get addAdvancedNew =>
      'La mayoría de los sitios web usan la configuración normal. Cámbiala solo si el sitio web te lo indicó.';

  @override
  String get addType => 'Tipo';

  @override
  String get addTypeTotp => 'Por tiempo (normal)';

  @override
  String get addTypeHotp => 'Por contador (código nuevo cuando lo pidas)';

  @override
  String get addDigits => 'Dígitos';

  @override
  String get addAlgorithm => 'Algoritmo';

  @override
  String get addSha1Normal => 'SHA-1 (normal)';

  @override
  String get addPeriod => 'Código nuevo cada';

  @override
  String addSeconds(int seconds) {
    return '$seconds segundos';
  }

  @override
  String get addCounter => 'Contador';

  @override
  String get addCounterHelp => 'Cuántos códigos se han usado hasta ahora';

  @override
  String get addNotASharedFile =>
      'Ese archivo no es una cuenta compartida de Tanooki Auth. Pide a la persona que la comparta de nuevo.';

  @override
  String addAlreadyInList(String name) {
    return '$name ya está en tu lista.';
  }

  @override
  String get addThisAccount => '¿Añadir esta cuenta?';

  @override
  String get addNoCameraWindows =>
      'En Windows, Tanooki Auth no puede usar la cámara. Abre una imagen del código QR o pega el enlace de configuración.';

  @override
  String get addFromGoogle => 'Traer desde Google Authenticator';

  @override
  String get addFromGoogleSteps =>
      'En el dispositivo con Google Authenticator:\n\n1. Abre Google Authenticator.\n2. Toca el menú (☰ o ⋮), luego \"Transferir cuentas\" y después \"Exportar cuentas\".\n3. Elige las cuentas y toca Siguiente. Aparecerá un código QR.\n\nLuego escanea ese código QR aquí. Si muestra varios códigos QR, escanéalos uno por uno.';

  @override
  String get addScan => 'Escanear';

  @override
  String get addOpenPicture => 'Abrir imagen';

  @override
  String get addLookingOnScreen => 'Buscando un código QR en tu pantalla…';

  @override
  String get addScreenNoQr =>
      'No se encontró ningún código QR en tu pantalla. Asegúrate de que el código se vea completo y no lo tape otra ventana, e inténtalo de nuevo.';

  @override
  String get addScreenUnsupported =>
      'Escanear la pantalla requiere macOS 14 (Sonoma) o posterior. Haz una captura de pantalla y usa \"Abrir una imagen\".';

  @override
  String get addScreenFailed =>
      'No se pudo capturar la pantalla. Haz una captura de pantalla y usa \"Abrir una imagen\".';

  @override
  String get addScreenWrongQr =>
      'Se encontró un código QR en tu pantalla, pero no es un código de configuración de verificación en dos pasos.';

  @override
  String get addScreenPermissionTitle =>
      'Deja que Tanooki Auth vea tu pantalla';

  @override
  String get addScreenPermissionSteps =>
      'Para leer un código QR de tu pantalla, tu Mac debe permitir que Tanooki Auth la capture. Tanooki Auth solo mira cuando pulsas \"Escanear mi pantalla\", y la imagen nunca sale de este Mac.\n\n1. Abre Ajustes del Sistema (el icono del engranaje en el Dock, o menú Apple > Ajustes del Sistema).\n2. Haz clic en \"Privacidad y seguridad\" en la columna de la izquierda.\n3. Haz clic en \"Grabación de pantalla y audio del sistema\".\n4. Activa el interruptor junto a Tanooki Auth. Si no está en la lista, haz clic en +, elige Tanooki Auth en Aplicaciones y actívalo.\n5. Tu Mac te pedirá salir de Tanooki Auth. Haz clic en \"Salir y volver a abrir\" y pulsa \"Escanear mi pantalla\" otra vez.';

  @override
  String get addPasteLinksTitle => 'Pegar enlaces de configuración';

  @override
  String get addPasteLinksHint =>
      'otpauth://totp/...\nUn enlace por línea. Puedes pegar muchos a la vez.';

  @override
  String addManyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Añadir $count cuentas?',
      one: '¿Añadir 1 cuenta?',
    );
    return '$_temp0';
  }

  @override
  String addManyBadLines(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count líneas no se pueden usar; después verás cuáles.',
      one: '1 línea no se puede usar; después verás cuál.',
    );
    return '$_temp0';
  }

  @override
  String get addEnterKey => 'Introducir clave de configuración';

  @override
  String get addSetupKey => 'Clave de configuración';

  @override
  String get addSetupKeyHelp => 'Las letras y números que muestra el sitio web';

  @override
  String get addBadKey =>
      'Esa clave de configuración no es válida. Solo debe contener letras de la A a la Z y números del 2 al 7.';

  @override
  String get addTitle => 'Añadir cuenta';

  @override
  String get addScanQr => 'Escanear código QR';

  @override
  String get addScanQrHelp =>
      'Apunta la cámara al código que muestra el sitio web';

  @override
  String addNoCameraOn(String platform) {
    return 'Sin cámara en $platform';
  }

  @override
  String get addScanScreen => 'Escanear mi pantalla';

  @override
  String get addScanScreenHelp =>
      'Lee un código QR que aparezca en cualquier parte de tu pantalla';

  @override
  String get addScanScreenLinux =>
      'Aún no disponible en Linux. Abre una captura de pantalla del código QR.';

  @override
  String get addFromPhotos => 'Escanear un código QR de tus fotos';

  @override
  String get addFromPicture => 'Abrir una imagen de un código QR';

  @override
  String get addFromPhotosHelp =>
      'Elige una captura de la página de configuración';

  @override
  String get addFromPictureHelp =>
      'Sirve una captura de la página de configuración';

  @override
  String get addPasteLink => 'Pegar enlace de configuración';

  @override
  String get addPasteLinkHelp =>
      'Enlaces que empiezan por otpauth://, uno o varios';

  @override
  String get addOpenShared => 'Abrir una cuenta compartida';

  @override
  String addOpenSharedHelp(String extension) {
    return 'Un archivo .$extension que alguien te envió';
  }

  @override
  String get addFromGoogleHelp => 'Trae todas tus cuentas de una vez';

  @override
  String get addFromOtherApp => 'Traer desde otra app';

  @override
  String get addFromOtherAppHelp =>
      'Aegis, 2FAS, Authy, Bitwarden, 1Password, Contraseñas de Apple, Microsoft';

  @override
  String get addEnterKeyHelp =>
      'Escribe la clave que aparece en \"¿no puedes escanear el código?\"';

  @override
  String get addWrongQr =>
      'Ese código QR no es un código de configuración de verificación en dos pasos.';

  @override
  String get addCameraDenied =>
      'Tanooki Auth no tiene permiso para usar la cámara. Activa el acceso a la cámara para Tanooki Auth en los Ajustes de tu dispositivo, o vuelve atrás y usa una imagen o la clave de configuración.';

  @override
  String addCameraFailed(String problem) {
    return 'No se pudo iniciar la cámara ($problem). Vuelve atrás y usa una imagen o la clave de configuración.';
  }

  @override
  String get helpNew030a =>
      'Guías paso a paso para activar la verificación en dos pasos en 40 sitios populares. Cuando añades o editas una cuenta que tiene guía, verás un enlace a ella.';

  @override
  String get helpNew030b =>
      'Un breve recorrido de bienvenida la primera vez que abres la app. Vuelve a verlo en Ajustes > Ayuda.';

  @override
  String get helpNew030c =>
      'Envía comentarios desde Ajustes > Ayuda. Nunca incluyen tus cuentas ni tus códigos.';

  @override
  String get helpNew030d => 'Esta página de Novedades.';

  @override
  String get helpNew030e =>
      'Importa desde Contraseñas de Apple y lleva tus cuentas a Aegis, 2FAS o Google Authenticator.';

  @override
  String get helpNew030f =>
      'Códigos de Steam Guard, códigos por contador con un botón \"Siguiente código\" y ajustes avanzados de código con vista previa en vivo.';

  @override
  String get helpNew030g =>
      'Carpetas, seleccionar muchas cuentas a la vez, ordenar de la A a la Z o por uso reciente, y \"Ordenar nombres de cuentas\".';

  @override
  String get helpNew030h =>
      'Muestra el código QR de una cuenta (tras Face ID o tu código) para pasarla a otro dispositivo.';

  @override
  String get helpNew030i =>
      'Desbloquea con una llave de seguridad como una YubiKey (Premium), en iPhone, Mac y PC con Windows recientes.';

  @override
  String get helpNew030j =>
      'Cuentas \"Preguntar antes\" que piden Face ID o tu código antes de mostrar el código, y modo viaje para ocultar las cuentas que elijas (Premium).';

  @override
  String get helpNew030k =>
      'Historial de actividad (Premium), comprobación del reloj \"¿Los códigos no funcionan?\", Probar una copia de seguridad, bloqueo al suspender y recordatorios de copia de seguridad.';

  @override
  String get helpNew030l =>
      'Acceso de emergencia: deja que alguien de confianza pida tus cuentas, con días de margen para que digas que no.';

  @override
  String get helpNew030m =>
      'Búsqueda con Spotlight, una Actividad en Vivo del código copiado y una complicación para la esfera del reloj (Premium), Copiar al abrir y \"Borrar tras pegar una vez\" en Mac.';

  @override
  String get helpNew030n =>
      'Estilos de cuenta atrás, un color o emoji para cada cuenta, Leer en voz alta, una fuente fácil de leer y mejor compatibilidad con lectores de pantalla.';

  @override
  String get helpNew030o =>
      'Un diseño ancho para ventanas grandes e iconos de temporada de Premium.';

  @override
  String get helpNew030p =>
      'Compra Premium dentro de la app en iPhone y Android, regálalo e invita a tus amigos.';

  @override
  String get helpNew030q =>
      'Bóveda de equipo para compartir códigos con hasta 10 personas. El plan de equipo llegará pronto.';

  @override
  String get helpNew030r => 'El plan Familia llegará pronto.';

  @override
  String get helpNew030s =>
      'La app de escritorio ahora también funciona en Linux. Las descargas para Linux llegarán pronto.';

  @override
  String get helpNew020a =>
      'Sincronización entre tus dispositivos, vínculo con el teléfono para la extensión del navegador y uso compartido seguro de una cuenta.';

  @override
  String get helpNew020b =>
      'Código de acceso, bloqueo automático, borrado de pánico, código señuelo, bloqueo de capturas de pantalla, revisión y alertas de filtraciones.';

  @override
  String get helpNew020c =>
      'Widgets, apps para Apple Watch y Wear OS, la barra de menús del Mac y la bandeja de Windows, y copias de seguridad cifradas automáticas (Premium).';

  @override
  String get helpNew020d =>
      'Importación desde Aegis, 2FAS, Authy, Bitwarden y 1Password, además de favoritos, etiquetas, notas, códigos de recuperación y Papelera.';

  @override
  String get helpNew010a =>
      'La primera versión: escanear o pegar cuentas, ver códigos, copias de seguridad cifradas y la extensión del navegador.';

  @override
  String helpNoBrowser(String url) {
    return 'No se pudo abrir tu navegador. La página es $url';
  }

  @override
  String helpGuideFor(String name) {
    return 'Cómo activar la verificación en dos pasos en $name';
  }

  @override
  String get helpTourWelcome => 'Te damos la bienvenida a Tanooki Auth';

  @override
  String get helpTourWelcomeBody =>
      'Muchos sitios web pueden pedirte un código de 6 dígitos además de tu contraseña. Eso es la verificación en dos pasos, o 2FA. Tanooki Auth genera esos códigos por ti, aquí mismo en tu dispositivo, así que alguien que solo tenga tu contraseña no podrá entrar.';

  @override
  String get helpTourAdd => 'Añade tu primera cuenta';

  @override
  String get helpTourAddBody =>
      'Activa la verificación en dos pasos en los ajustes de seguridad de un sitio web. Te mostrará un código QR: escanéalo aquí, o copia su enlace de configuración y pégalo. ¿Ya usas otra app de autenticación? Trae todas tus cuentas de una vez.';

  @override
  String get helpTourScanOrPaste => 'Escanear un código QR o pegar un enlace';

  @override
  String get helpTourImport => 'Importar desde otra app';

  @override
  String get helpTourPopular =>
      'Sitios populares que conviene proteger primero';

  @override
  String get helpTourPopularBody =>
      'Tu correo, tus redes sociales y cualquier sitio donde tengas dinero son lo más importante. Nuestras guías paso a paso te muestran dónde está el ajuste de verificación en dos pasos en cada sitio.';

  @override
  String get helpAllGuides => 'Todas las guías de 2FA';

  @override
  String helpTourStep(int step, int total) {
    return 'Paso $step de $total';
  }

  @override
  String get helpTourSkip => 'Saltar recorrido';

  @override
  String get helpWhatsNew => 'Novedades';

  @override
  String helpVersion(String version) {
    return 'Versión $version';
  }

  @override
  String helpVersionThis(String version) {
    return 'Versión $version (esta versión)';
  }

  @override
  String get helpFeedbackEmpty => 'Escribe un mensaje primero.';

  @override
  String get helpFeedbackSent =>
      'Enviado. ¡Gracias! Maddie lee todos los mensajes.';

  @override
  String get helpFeedbackTooLong =>
      'Es demasiado largo para enviarlo. Acórtalo un poco (unos 4.000 caracteres como máximo).';

  @override
  String get helpFeedbackTooMany =>
      'Enviaste muchos comentarios en la última hora. Vuelve a intentarlo dentro de una hora.';

  @override
  String get helpFeedbackOffline =>
      'No se pudo conectar a internet. Revisa tu conexión e inténtalo de nuevo. Tu mensaje sigue aquí.';

  @override
  String get helpFeedbackServerError =>
      'El servidor de comentarios tuvo un problema y no recibió tu mensaje. Inténtalo más tarde. Tu mensaje sigue aquí.';

  @override
  String get helpFeedbackTitle => 'Enviar comentarios';

  @override
  String get helpFeedbackIntro =>
      '¿Encontraste un error o te gustaría que la app hiciera algo? Cuéntaselo a Maddie aquí.';

  @override
  String get helpFeedbackMessage => 'Tu mensaje';

  @override
  String get helpFeedbackEmail => 'Tu correo (opcional)';

  @override
  String get helpFeedbackEmailHelp => 'Solo si quieres una respuesta.';

  @override
  String get helpFeedbackDevice =>
      'Incluir la versión de la app y el tipo de dispositivo';

  @override
  String get helpFeedbackDeviceHelp =>
      'Por ejemplo, \"0.3.0\" e \"iOS\". Ayuda a encontrar errores.';

  @override
  String get helpFeedbackNeverSent =>
      'Nunca se envía: tus cuentas, sus nombres, códigos, claves de configuración, etiquetas, notas ni nada más de la app.';

  @override
  String get helpFeedbackSend => 'Enviar';

  @override
  String get phoneUiPushAndroid =>
      'Las notificaciones en Android aún no están configuradas, así que las solicitudes aparecen mientras Tanooki Auth está abierta.';

  @override
  String get phoneUiPushThisDevice =>
      'Este dispositivo recibe solicitudes mientras Tanooki Auth está abierta.';

  @override
  String get phoneUiPushNoToken =>
      'El iPhone no le dio a la app un token de notificaciones.';

  @override
  String get phoneUiPushDenied =>
      'Las notificaciones de Tanooki Auth están desactivadas. Actívalas en la app Ajustes del iPhone, en Notificaciones, para recibir solicitudes con la app cerrada.';

  @override
  String phoneUiPushFailed(String problem) {
    return 'No se pudieron activar las notificaciones: $problem. Las solicitudes siguen apareciendo mientras Tanooki Auth está abierta.';
  }

  @override
  String get phoneUiPushNotInBuild =>
      'Las notificaciones no están disponibles en esta versión. Las solicitudes aparecen mientras Tanooki Auth está abierta.';

  @override
  String get phoneUiPushChecking =>
      'Comprobando si las notificaciones funcionan…';

  @override
  String get phoneUiRequest => 'Solicitud de código de inicio de sesión';

  @override
  String get phoneUiNoAccount =>
      'No hay ninguna cuenta guardada para este sitio web, así que no hay nada que enviar. Si esperabas una, puede que sea un sitio falso que se hace pasar por uno real.';

  @override
  String get phoneUiWantsCode =>
      'Tu navegador vinculado pide el código de este sitio web. Apruébalo solo si estás iniciando sesión ahora mismo.';

  @override
  String get phoneUiApprove => 'Aprobar';

  @override
  String phoneUiApproveAccount(String name) {
    return 'Aprobar: $name';
  }

  @override
  String get phoneUiScanTitle => 'Escanea el código del navegador';

  @override
  String get phoneUiScanWrong =>
      'Eso no es un código de emparejamiento del navegador. En el navegador, haz clic en la extensión de Tanooki Auth y luego en \"Usar mi teléfono\".';

  @override
  String get phoneUiPasteTitle => 'Pega el enlace de emparejamiento';

  @override
  String get phoneUiPair => 'Emparejar';

  @override
  String get phoneUiPaired =>
      'Emparejado. Cuando ese navegador pida un código, lo verás aquí.';

  @override
  String get phoneUiExpired =>
      'Ese código caducó. En el navegador, genera uno nuevo y escanéalo otra vez.';

  @override
  String get phoneUiPremium =>
      'Usar tu teléfono con un navegador es parte de Premium';

  @override
  String get phoneUiIntro =>
      'Rellena códigos en un navegador de cualquier computadora, aunque no tenga la app de Tanooki Auth. La extensión del navegador pregunta y tú tocas Aprobar aquí. Los códigos viajan con cifrado de extremo a extremo y solo para el sitio web de cada cuenta.';

  @override
  String get phoneUiPairBrowser => 'Emparejar un navegador';

  @override
  String get phoneUiPairHelp =>
      'En el navegador, haz clic en la extensión de Tanooki Auth y luego en \"Usar mi teléfono\" para mostrar el código.';

  @override
  String get phoneUiPairedBrowsers => 'Navegadores emparejados';

  @override
  String get phoneUiNoneYet => 'Ninguno todavía';

  @override
  String get phoneUiBrowser => 'Navegador';

  @override
  String phoneUiPairedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Emparejado el $dateString';
  }

  @override
  String get phoneUiUnpair => 'Desemparejar';

  @override
  String get phoneUiPushOn => 'Notificaciones activadas';

  @override
  String get phoneUiPushOff => 'Las solicitudes aparecen con la app abierta';

  @override
  String get phoneUiPushOnHelp =>
      'Recibirás una notificación por cada solicitud, aunque Tanooki Auth esté cerrada.';

  @override
  String phoneUiSendCodeFor(String name) {
    return 'Enviar el código de $name';
  }

  @override
  String get phoneUiActivityWhere => 'Navegador, a través de este teléfono';

  @override
  String get premiumFiveOnce => '\$5 un solo pago';

  @override
  String get premiumPayOnce => 'Un solo pago';

  @override
  String get premiumCheckoutSoon =>
      'El pago aún no está disponible; llegará muy pronto. ¡Gracias por querer apoyar a Tanooki Auth!';

  @override
  String get premiumEnterKeyTitle => 'Introducir clave de licencia';

  @override
  String get premiumEnterKeyHint => 'TA1.…  (del correo de tu compra)';

  @override
  String get premiumBadKey =>
      'Esa clave de licencia no es válida. Copia la clave completa del correo de tu compra e inténtalo de nuevo.';

  @override
  String premiumInvitesNowFamily(int count) {
    return '$count amigos compraron Premium con tu enlace, así que tu clave ahora es una clave Familia para hasta 5 personas. Ya está instalada en este dispositivo. Copia la nueva clave de abajo e introdúcela también en tus otros dispositivos.';
  }

  @override
  String premiumInvitesAlreadyFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count amigos compraron Premium con tu enlace. Tu clave ya es una clave Familia.',
      one: '1 amigo compró Premium con tu enlace. Tu clave ya es una clave Familia.',
    );
    return '$_temp0';
  }

  @override
  String premiumInvitesProgress(int count, int needed, int left) {
    return '$count de $needed amigos compraron Premium con tu enlace. $left más y tu clave se convertirá en una clave Familia.';
  }

  @override
  String get premiumInviteLinkCopied => 'Enlace de invitación copiado.';

  @override
  String get premiumKeyCopied => 'Clave de licencia copiada.';

  @override
  String premiumJustMe(String price) {
    return 'Solo yo — $price';
  }

  @override
  String premiumFamilyPrice(String price) {
    return 'Familia (hasta 5 personas) — $price';
  }

  @override
  String get premiumFamilyApple =>
      'Familia: se comparte con tu familia de Apple mediante En Familia, y además una clave de licencia para hasta 5 personas en cualquier dispositivo.';

  @override
  String get premiumFamilyKey =>
      'Familia: una clave de licencia que compartes con hasta otras 4 personas.';

  @override
  String get premiumYourKey => 'Tu clave de licencia';

  @override
  String get premiumYourKeyHelp =>
      'Introdúcela en tus otros dispositivos: Ajustes → Obtener Premium → \"¿Ya lo compraste? Introduce tu clave de licencia\".';

  @override
  String get premiumCopyKey => 'Copiar clave';

  @override
  String get premiumInviteFriends => 'Invitar a amigos';

  @override
  String get premiumInviteHelp =>
      'Tus amigos obtienen un 20 % de descuento. Cuando 3 amigos compren, tu clave se convertirá en una clave Familia.';

  @override
  String get premiumGetInvite => 'Obtener mi enlace de invitación';

  @override
  String get premiumCheckInvites => 'Ver mis invitaciones';

  @override
  String get premiumYouHave => 'Tienes Premium';

  @override
  String get premiumTitle => 'Tanooki Auth Premium';

  @override
  String get premiumOwnedFamily =>
      'Plan Familia: comparte tu clave de licencia con hasta otras 4 personas (5 en total). Gracias por apoyar a Tanooki Auth.';

  @override
  String get premiumOwnedThanks => 'Gracias por apoyar a Tanooki Auth.';

  @override
  String get premiumPitchStripe =>
      '\$5 un solo pago, o \$10 para toda tu familia. Para siempre.';

  @override
  String get premiumPitchStore =>
      'Paga una vez para ti, o una vez para toda tu familia. Para siempre.';

  @override
  String get premiumPerkThemes => 'Todos los temas Premium';

  @override
  String premiumPerkThemesBody(int count) {
    return 'Rosa pastel, Azul pastel y $count más, además de todos los temas que lleguen después.';
  }

  @override
  String get premiumPerkIcons => 'Iconos de la app';

  @override
  String premiumPerkIconsBody(int count) {
    return 'Elige otro icono para la pantalla de inicio en iPhone y Android, en Rosa pastel, Azul pastel y $count colores más, además de iconos de temporada para otoño, invierno y primavera. En un Mac cambia el icono del Dock mientras la app está abierta.';
  }

  @override
  String get premiumPerkSync => 'Sincroniza entre tus dispositivos';

  @override
  String get premiumPerkSyncBody =>
      'Añade una cuenta en un dispositivo y mírala en todos, con cifrado de extremo a extremo. Mediante iCloud en dispositivos Apple, o el relay de Tanooki para cualquier combinación.';

  @override
  String get premiumPerkApprove => 'Aprueba códigos desde tu teléfono';

  @override
  String get premiumPerkApproveBody =>
      'Usa la extensión del navegador en cualquier computadora: pregunta a tu teléfono, tocas Aprobar y el código se rellena.';

  @override
  String get premiumPerkBreach => 'Alertas de filtraciones';

  @override
  String get premiumPerkBreachBody =>
      'Recibe un aviso cuando un sitio web donde tienes cuenta aparezca en una filtración de datos conocida. Se comprueba en tu dispositivo; no se envía nada sobre ti.';

  @override
  String get premiumPerkShare => 'Comparte una cuenta de forma segura';

  @override
  String get premiumPerkShareBody =>
      'Da una cuenta a alguien de confianza con un código QR y un código de 6 dígitos. Protegida, caduca en 24 horas, sin servidor.';

  @override
  String get premiumPerkFamily => 'Plan Familia';

  @override
  String get premiumPerkFamilyStripe =>
      'Por \$10 en lugar de \$5, una clave desbloquea Premium para hasta 5 personas. Envíasela a tu familia y la introducen igual que tú.';

  @override
  String get premiumPerkFamilyStore =>
      'Una compra familiar desbloquea Premium para hasta 5 personas. Envíales tu clave de licencia y la introducen igual que tú.';

  @override
  String get premiumPerkFuture => 'Todas las funciones Premium futuras';

  @override
  String get premiumPerkFutureBody =>
      'Paga una vez y recibe todo lo que Premium llegue a ser. Sin suscripción, nunca.';

  @override
  String get premiumPerkFree => 'Mantiene gratis las apps de privacidad';

  @override
  String get premiumPerkFreeStripe =>
      'Tus \$5 son lo que me permite seguir creando apps gratuitas que no te rastrean.';

  @override
  String get premiumPerkFreeStore =>
      'Comprar Premium es lo que me permite seguir creando apps gratuitas que no te rastrean.';

  @override
  String get premiumFreeForever =>
      'Gratis para siempre, con o sin Premium: cuentas ilimitadas, escaneo, copias de seguridad, la extensión del navegador y el bloqueo de la app.';

  @override
  String get premiumFamilySoon => 'Plan Familia muy pronto';

  @override
  String get premiumFamilyKeyEach =>
      'Familia: una clave de licencia que compartes con hasta otras 4 personas. Cada una la introduce en su propio Tanooki Auth.';

  @override
  String get premiumRestore => 'Restaurar compras';

  @override
  String get premiumAlreadyBought =>
      '¿Ya lo compraste? Introduce tu clave de licencia';

  @override
  String get premiumDesktopKeySoon =>
      'La clave para computadoras llegará pronto para las compras en Android. Premium ya está desbloqueado en este teléfono; la clave de licencia para tus computadoras aparecerá aquí en una próxima actualización.';

  @override
  String premiumGift(String price) {
    return 'Regalar Premium — $price';
  }

  @override
  String premiumGiftFamily(String price) {
    return 'Regalar el plan Familia — $price';
  }

  @override
  String get premiumGiftHelp =>
      'Después de pagar recibes una tarjeta regalo imprimible con una clave para esa persona.';

  @override
  String get settingsIconFailed =>
      'No se pudo cambiar el icono de la app. Inténtalo de nuevo o reinicia la app.';

  @override
  String settingsIconFailedWhy(String problem) {
    return 'No se pudo cambiar el icono de la app ($problem). Inténtalo de nuevo o reinicia la app.';
  }

  @override
  String settingsIconSemantic(String name) {
    return 'Icono de la app $name';
  }

  @override
  String settingsIconSemanticPremium(String name) {
    return 'Icono de la app $name, Premium';
  }

  @override
  String get settingsAppIcon => 'Icono de la app';

  @override
  String get settingsAppIconPremium => 'Icono de la app (Premium)';

  @override
  String get settingsAppIconIos => 'El icono de tu pantalla de inicio.';

  @override
  String get settingsAppIconAndroid =>
      'El icono de tu pantalla de inicio. Puede desaparecer un momento mientras tu teléfono lo cambia.';

  @override
  String get settingsAppIconMac =>
      'Cambia el icono del Dock mientras Tanooki Auth está abierta. Los Mac no pueden conservar otro icono cuando la app se cierra, así que el Finder y Launchpad mantienen el azul.';

  @override
  String get settingsAppIconOther =>
      'Los iconos de la app se pueden cambiar en iPhone y Android.';

  @override
  String get settingsLockNameMac => 'Touch ID o la contraseña de tu Mac';

  @override
  String get settingsLockNamePhone => 'Face ID, huella digital o código';

  @override
  String settingsNoLockSetUp(String lock) {
    return 'Este dispositivo no tiene configurado $lock, así que la app no se puede bloquear. Configúralo primero en los ajustes del sistema.';
  }

  @override
  String get settingsLockReasonOn => 'Activar el bloqueo de la app';

  @override
  String get settingsLockReasonOff => 'Desactivar el bloqueo de la app';

  @override
  String get settingsSetPasscode => 'Establecer un código de la app';

  @override
  String get settingsSetPasscodeIntro =>
      'Escríbelo para abrir Tanooki Auth. También funciona cuando Face ID o tu huella no funcionan. Si lo olvidas, la única forma de volver a entrar es una copia de seguridad.';

  @override
  String get settingsPasscodeOn => 'Código de la app activado.';

  @override
  String get settingsPasscode => 'Código de la app';

  @override
  String get settingsChangePasscode => 'Cambiar código';

  @override
  String get settingsPasscodeOff => 'Desactivar código';

  @override
  String get settingsNewPasscode => 'Nuevo código de la app';

  @override
  String get settingsPasscodeChanged => 'Código cambiado.';

  @override
  String get settingsPasscodeIsOff => 'Código de la app desactivado.';

  @override
  String get settingsRemoveDecoyTitle => '¿Quitar el código señuelo?';

  @override
  String get settingsRemoveDecoyBody =>
      'Las cuentas señuelo se borran. Tus cuentas reales no se tocan.';

  @override
  String get settingsSetDecoy => 'Establecer un código señuelo';

  @override
  String get settingsSetDecoyIntro =>
      'Si alguien te obliga a abrir Tanooki Auth, escribe este en su lugar. Abre un conjunto de cuentas aparte y vacío, y nada en pantalla indica que no es el real. Añade un par de cuentas inofensivas para que parezca usado.\n\nTu código real sigue abriendo tus cuentas reales.';

  @override
  String get settingsDecoySet => 'Código señuelo establecido.';

  @override
  String settingsWipeTitle(int count) {
    return '¿Borrar todo tras $count códigos incorrectos?';
  }

  @override
  String settingsWipeBody(int count) {
    return 'Si alguien escribe mal el código de la app $count veces seguidas, Tanooki Auth borra todas las cuentas de este dispositivo. No se puede deshacer ni detener una vez que empieza.';
  }

  @override
  String get settingsWipeSureTitle => '¿Seguro?';

  @override
  String get settingsWipeSureBody =>
      'Un niño jugando con tu teléfono, o tú en un mal día, puede activarlo. Tras un borrado, la única forma de recuperar todo es tu archivo de copia de seguridad. Sin él podrías quedarte sin acceso a todos los sitios web que usan estos códigos.';

  @override
  String get settingsWipeTurnOn => 'Activar borrado de pánico';

  @override
  String get settingsTravelOffReason => 'Desactivar el modo viaje';

  @override
  String get settingsTravelOnNone =>
      'Modo viaje activado, pero aún no hay cuentas marcadas con \"Ocultar en modo viaje\". Márcalas primero con ⋯ > Editar.';

  @override
  String settingsTravelOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Modo viaje activado. $count cuentas están ocultas.',
      one: 'Modo viaje activado. 1 cuenta está oculta.',
    );
    return '$_temp0';
  }

  @override
  String get settingsTravelOff =>
      'Modo viaje desactivado. Todas las cuentas han vuelto.';

  @override
  String get settingsCheckingClock => 'Comprobando tu reloj…';

  @override
  String get settingsClockRight =>
      'Tu reloj está bien, así que no es eso. Comprueba que los ajustes de la cuenta (⋯ > Editar > Avanzado) coinciden con lo que indicó el sitio web.';

  @override
  String settingsClockFailed(String problem) {
    return 'No se pudo comprobar el reloj: $problem';
  }

  @override
  String get settingsLockApp => 'Bloquear la app';

  @override
  String settingsLockAppHelp(String lock) {
    return 'Pedir $lock al abrir la app';
  }

  @override
  String get settingsPasscodeOnHelp =>
      'Activado. Toca para cambiarlo o desactivarlo.';

  @override
  String settingsPasscodeOffHelp(String lock) {
    return 'Desactivado. Números que escribes para abrir la app, en lugar de $lock o además de ello.';
  }

  @override
  String get settingsLockAgain => 'Volver a bloquear';

  @override
  String settingsLockAgainHelp(String time) {
    return '$time en segundo plano';
  }

  @override
  String get settingsLockFirst => 'Activa primero el bloqueo o un código';

  @override
  String get settingsDecoy => 'Código señuelo';

  @override
  String get settingsDecoyOn =>
      'Activado. Abre un conjunto de cuentas aparte. Toca para quitarlo.';

  @override
  String get settingsDecoyOff =>
      'Un segundo código que abre un conjunto de cuentas aparte y vacío';

  @override
  String settingsWipe(int count) {
    return 'Borrar tras $count códigos incorrectos';
  }

  @override
  String get settingsWipeHelp =>
      'Borrado de pánico. Requiere una copia de seguridad de los últimos 30 días.';

  @override
  String get settingsLockOnSleep =>
      'Bloquear cuando la computadora entre en reposo';

  @override
  String get settingsLockOnSleepHelp =>
      'También cuando se bloquea la pantalla o cierras sesión un momento';

  @override
  String get settingsLockOnSleepNeedsLock =>
      'Activa primero \"Bloquear la app\" o un código de la app, para que haya algo que bloquear.';

  @override
  String get settingsTravel => 'Modo viaje';

  @override
  String get settingsTravelPremium => 'Modo viaje (Premium)';

  @override
  String get settingsTravelOnHelp =>
      'Activado. Las cuentas marcadas con \"Ocultar en modo viaje\" desaparecen de las pantallas, widgets, reloj, extensión y exportaciones de este dispositivo hasta que lo desactives. No se eliminan.';

  @override
  String settingsTravelOffHelp(String proof) {
    return 'Antes de cruzar una frontera: oculta las cuentas que marcaste con \"Ocultar en modo viaje\" (⋯ > Editar). Para desactivarlo se pide $proof.';
  }

  @override
  String get settingsKeys => 'Llaves de seguridad';

  @override
  String get settingsKeysPremium => 'Llaves de seguridad (Premium)';

  @override
  String get settingsKeysHelp =>
      'Desbloquea con una YubiKey u otra llave de seguridad';

  @override
  String get settingsActivity => 'Historial de actividad';

  @override
  String get settingsActivityPremium => 'Historial de actividad (Premium)';

  @override
  String get settingsActivityHelp =>
      'Qué códigos se copiaron, rellenaron, escribieron o exportaron, y cuándo. Solo se guarda en este dispositivo.';

  @override
  String get settingsEmergency => 'Acceso de emergencia';

  @override
  String get settingsEmergencyPremium => 'Acceso de emergencia (Premium)';

  @override
  String get settingsEmergencyHelp =>
      'Permite que una persona de confianza obtenga tus cuentas si te pasa algo, tras una espera de 7 días que puedes detener';

  @override
  String get settingsTeamHelp =>
      'Comparte códigos de inicio de sesión con hasta 10 personas, con cifrado de extremo a extremo';

  @override
  String get settingsMonthly => 'Notificación del resumen mensual';

  @override
  String get settingsMonthlyPremium =>
      'Notificación del resumen mensual (Premium)';

  @override
  String get settingsMonthlyHelp =>
      'Un recordatorio el día 1 de cada mes para mirar tu tarjeta de resumen. Nunca dice nada sobre tus cuentas.';

  @override
  String get settingsBlockShots => 'Bloquear capturas de pantalla';

  @override
  String get settingsBlockShotsDesktop =>
      'Oculta esta ventana de capturas, grabaciones y uso compartido de pantalla';

  @override
  String get settingsBlockShotsPhone =>
      'Mantiene los códigos fuera de capturas, grabaciones de pantalla y el selector de apps';

  @override
  String get settingsCheckup => 'Revisión de seguridad';

  @override
  String get settingsCheckupHelp =>
      'Cosas que conviene arreglar y tu kit de recuperación';

  @override
  String get settingsBreachPremium => 'Alertas de filtraciones (Premium)';

  @override
  String get settingsBreachOn =>
      'Activado. Revisa la lista pública de filtraciones cada semana.';

  @override
  String get settingsBreachOff =>
      'Desactivado. Al activarlo, la app descarga la lista pública de filtraciones una vez por semana.';

  @override
  String settingsThemeSemantic(String name) {
    return 'Tema $name';
  }

  @override
  String settingsThemeSemanticPremium(String name) {
    return 'Tema $name, Premium';
  }

  @override
  String get settingsPremiumThanks => 'Premium: ¡gracias!';

  @override
  String get settingsGetPremium => 'Obtener Premium';

  @override
  String get settingsPremiumThanksHelp =>
      'Todos los temas y las futuras funciones Premium son tuyos.';

  @override
  String settingsGetPremiumHelp(String payOnce) {
    return '$payOnce: todos los temas, sincronización entre tus dispositivos y más.';
  }

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsCountdown => 'Estilo de cuenta atrás';

  @override
  String get settingsCountdownHelp =>
      'Cómo se muestra el tiempo que le queda a cada código';

  @override
  String get settingsEasyFont => 'Fuente fácil de leer';

  @override
  String get settingsEasyFontHelp =>
      'Atkinson Hyperlegible, creada por el Braille Institute para que letras y números sean difíciles de confundir';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsAccountsList => 'Lista de cuentas';

  @override
  String get settingsCompact => 'Tarjetas compactas';

  @override
  String get settingsCompactHelp =>
      'Tarjetas más pequeñas para que quepan más cuentas en pantalla';

  @override
  String get settingsSort => 'Ordenar cuentas';

  @override
  String settingsSortHelp(String sort) {
    return '$sort. Los favoritos siempre van primero.';
  }

  @override
  String get settingsSortCustom =>
      'Tu propio orden. Mantén pulsada una tarjeta y arrástrala.';

  @override
  String get settingsSortRecent =>
      'Las cuentas de las que acabas de copiar un código suben arriba';

  @override
  String get settingsSortName => 'Por nombre del servicio';

  @override
  String get settingsTidyHelp =>
      'Convierte nombres como \"google.com:you@gmail.com\" en \"Google\". Primero ves cada cambio.';

  @override
  String get settingsHideCodes => 'Ocultar códigos hasta tocarlos';

  @override
  String get settingsHideCodesHelp =>
      'Muestra puntos en lugar de códigos, para que la gente cerca no pueda leerlos';

  @override
  String get settingsShareCodes => 'Mostrar códigos en widgets y reloj';

  @override
  String get settingsShareCodesHelp =>
      'Los códigos de tus favoritos se muestran en tu pantalla de inicio, pantalla bloqueada y reloj sin abrir esta app, así que cualquiera que tenga tu teléfono desbloqueado o tu reloj puede leerlos. Marca una cuenta con una estrella para hacerla favorita.';

  @override
  String get settingsTrash => 'Papelera';

  @override
  String settingsTrashCount(int count) {
    return 'Papelera ($count)';
  }

  @override
  String get settingsTrashHelp =>
      'Las cuentas eliminadas se quedan aquí 30 días';

  @override
  String get settingsWatchFace => 'Favorito de la esfera';

  @override
  String get settingsWatchFacePremium => 'Favorito de la esfera (Premium)';

  @override
  String get settingsWatchFaceNoFavorites =>
      'Primero marca una cuenta con una estrella en la lista principal. Solo los favoritos pueden ir en la esfera.';

  @override
  String get settingsNone => 'Ninguno';

  @override
  String get settingsCopying => 'Copiar y atajos';

  @override
  String get settingsCopyOnOpen => 'Copiar al abrir';

  @override
  String get settingsCopyOnOpenHelp =>
      'Al abrir o desbloquear la app se copia el código de la última cuenta que usaste. Se omiten las cuentas que preguntan antes de mostrar su código.';

  @override
  String get settingsPasteOnce => 'Borrar tras pegar una vez';

  @override
  String get settingsPasteOnceHelp =>
      'El código copiado sirve para pegarlo una vez y luego se vacía el portapapeles. Las apps de historial del portapapeles pueden contar como esa vez. En Windows, los códigos se borran a los 30 segundos.';

  @override
  String get settingsSpotlight => 'Mostrar cuentas en Spotlight';

  @override
  String get settingsSpotlightHelp =>
      'Busca el nombre de una cuenta desde cualquier lugar y ve directo a ella. Solo se comparten los nombres, nunca los códigos.';

  @override
  String get settingsLiveActivity =>
      'Código en la pantalla bloqueada al copiar';

  @override
  String get settingsLiveActivityPremium =>
      'Código en la pantalla bloqueada al copiar (Premium)';

  @override
  String get settingsLiveActivityHelp =>
      'Después de copiar un código, aparece en tu pantalla bloqueada y en la Dynamic Island con una cuenta atrás hasta que caduque.';

  @override
  String get settingsWatchFaceHelp =>
      'Elige un favorito cuyo código se muestre en la esfera de tu Apple Watch. Requiere tener activado \"Mostrar códigos en widgets y reloj\".';

  @override
  String settingsWatchFaceChosen(String name) {
    return '$name. Añade la complicación de Tanooki Auth a tu esfera para verlo.';
  }

  @override
  String get settingsBrowserSection => 'Extensión del navegador y lanzadores';

  @override
  String get settingsBridgeOff => 'No se está ejecutando';

  @override
  String get settingsBridgeOn => 'Lista para la extensión del navegador';

  @override
  String settingsBridgeOffHelp(String first, String last) {
    return 'Los puertos $first–$last están todos en uso por otros programas, así que la extensión no puede conectarse. Reinicia la computadora e inténtalo de nuevo.';
  }

  @override
  String settingsBridgeOnHelp(String port) {
    return 'Escuchando solo en esta computadora (127.0.0.1:$port). Funciona mientras Tanooki Auth está abierta.';
  }

  @override
  String settingsPairedClient(String name) {
    return 'Emparejado: $name';
  }

  @override
  String get settingsPairedBrowser => 'Navegador emparejado';

  @override
  String settingsExtensionId(String id) {
    return 'Extensión $id';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSecurity => 'Seguridad';

  @override
  String get settingsBackup => 'Copia de seguridad';

  @override
  String get settingsExport => 'Exportar copia de seguridad';

  @override
  String get settingsExportHelp =>
      'Un archivo cifrado, protegido con una frase de contraseña que tú eliges';

  @override
  String get settingsImport => 'Importar copia de seguridad';

  @override
  String get settingsImportHelp =>
      'Añade cuentas de un archivo de copia de seguridad; omite las que ya tienes';

  @override
  String get settingsTestBackup => 'Probar una copia de seguridad';

  @override
  String get settingsTestBackupHelp =>
      'Comprueba que un archivo de copia de seguridad se abre con tu frase de contraseña. No cambia nada.';

  @override
  String get settingsMoveOut => 'Pasar a otra app';

  @override
  String get settingsMoveOutHelp =>
      'Aegis, 2FAS, Google Authenticator o enlaces de configuración simples';

  @override
  String get settingsPaper => 'Imprimir copia en papel';

  @override
  String get settingsPaperHelp =>
      'Un PDF con códigos QR y códigos de recuperación para guardar bajo llave';

  @override
  String get settingsHelp => 'Ayuda';

  @override
  String get settingsGuidesHelp =>
      'Ayuda paso a paso para activar la verificación en dos pasos en sitios populares, en nuestro sitio web';

  @override
  String get settingsTour => 'Ver el recorrido de bienvenida';

  @override
  String get settingsFeedbackHelp =>
      'Cuéntale a Maddie un error o una idea. Nunca incluye tus cuentas ni tus códigos.';

  @override
  String get settingsAbout => 'Información';

  @override
  String get settingsAboutMaddieHelp =>
      'Una nota de la persona que crea Tanooki Auth';

  @override
  String get settingsCodesNotWorking => '¿Los códigos no funcionan?';

  @override
  String settingsCodesNotWorkingHelp(String time) {
    return 'Hora del dispositivo: $time. Los códigos dependen del reloj: toca para compararlo con internet.';
  }

  @override
  String shareUiConfirmTitle(String name) {
    return '¿Compartir $name?';
  }

  @override
  String get shareUiConfirmBody =>
      'La persona con quien lo compartas tendrá acceso total: su teléfono generará los mismos códigos que el tuyo mientras lo conserve. Compártelo solo con alguien en quien confíes plenamente, como tu familia.\n\nQuitarlo de tu lista después no se lo quita a esa persona. Para cortarle el acceso, desactiva y vuelve a activar la verificación en dos pasos en el sitio web.';

  @override
  String get shareUiConfirmButton => 'Entendido, compartir';

  @override
  String get shareUiLocking => 'Protegiendo lo compartido…';

  @override
  String shareUiTitle(String name) {
    return 'Compartir $name';
  }

  @override
  String get shareUiInstructions =>
      'En su dispositivo: abre Tanooki Auth, toca Añadir cuenta y luego \"Escanear código QR\" (o \"Abrir una cuenta compartida\" si es un archivo). Después escribe este código:';

  @override
  String get shareUiTellCode =>
      'Dile el código tú mismo, en voz alta o por una app distinta a la del archivo.';

  @override
  String get shareUiSendFile => 'Enviar como archivo';

  @override
  String get shareUiCopyLink => 'Copiar como enlace';

  @override
  String get shareUiCopied =>
      'Copiado. Lo pegan con \"Pegar enlace de configuración\".';

  @override
  String get shareUiWorksFor =>
      'Funciona durante 24 horas y solo con el código. Nada pasa por un servidor.';

  @override
  String get shareUiOpenTitle => 'Cuenta compartida';

  @override
  String get shareUiOpenBody =>
      'Escribe el código de 6 dígitos que te dio la persona que lo compartió.';

  @override
  String get shareUiUnlocking => 'Desbloqueando…';

  @override
  String get signatureLabel => 'Firmado, Maddie';

  @override
  String get syncUiQrCode => 'Código QR';

  @override
  String get syncUiNotYet => 'Todavía no';

  @override
  String get syncUiJustNow => 'Justo ahora';

  @override
  String syncUiMinutesAgo(int minutes) {
    return 'hace $minutes min';
  }

  @override
  String syncUiHoursAgo(int hours) {
    return 'hace $hours h';
  }

  @override
  String syncUiDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get syncUiThisDevice => 'Este dispositivo';

  @override
  String get syncUiAnotherDevice => 'Otro dispositivo';

  @override
  String syncUiAdded(String when) {
    return 'Añadido: $when';
  }

  @override
  String syncUiThisDeviceNamed(String name) {
    return 'Este dispositivo ($name)';
  }

  @override
  String syncUiLastSyncedAgo(String when) {
    return 'Última sincronización: $when';
  }

  @override
  String get syncUiWhere => '¿Dónde deben sincronizarse tus dispositivos?';

  @override
  String get syncUiICloudHelp =>
      'Solo para iPhone, iPad y Mac. Usa tu propio iCloud Drive.';

  @override
  String get syncUiRelay => 'Relay de Tanooki';

  @override
  String get syncUiRelayHelp =>
      'Funciona con todos los dispositivos, incluidos Android y Windows. El servidor solo guarda datos cifrados.';

  @override
  String get syncUiStartFreshTitle => '¿Empezar de cero?';

  @override
  String get syncUiStartFreshBody =>
      'Si olvidaste la frase de contraseña que usan tus otros dispositivos Apple, puedes empezar una sincronización nueva con esta. Después, tus otros dispositivos tendrán que desactivar y volver a activar la sincronización con la nueva frase.';

  @override
  String get syncUiStartFresh => 'Empezar de cero';

  @override
  String get syncUiOn => 'La sincronización está activada.';

  @override
  String get syncUiScanTitle => 'Escanea el código de sincronización';

  @override
  String get syncUiScanWrong =>
      'Eso no es un código de sincronización. En tu otro dispositivo, abre Ajustes, Sincronización, Añadir un dispositivo.';

  @override
  String get syncUiNowSyncing => 'Este dispositivo ya se está sincronizando.';

  @override
  String get syncUiPasteTitle => 'Pega el enlace de sincronización';

  @override
  String get syncUiPasteHint =>
      'tanookiauth://sync?…  (de Añadir un dispositivo en tu otro dispositivo)';

  @override
  String get syncUiAddApple => 'Añadir un dispositivo Apple';

  @override
  String get syncUiAddAppleBody =>
      'En tu otro iPhone, iPad o Mac (con la misma cuenta de Apple y iCloud Drive activado), abre Tanooki Auth, ve a Ajustes y luego a Sincronización, toca \"Activar sincronización\", elige iCloud y escribe la misma frase de contraseña.\n\n¿Quieres añadir un teléfono Android o un PC con Windows? Desactiva la sincronización en todos los dispositivos y vuelve a activarla con el relay de Tanooki.';

  @override
  String get syncUiAddDevice => 'Añadir un dispositivo';

  @override
  String get syncUiAddDeviceBody =>
      'En el dispositivo nuevo, abre Tanooki Auth, ve a Ajustes y luego a Sincronización, y toca \"Unirse desde otro dispositivo\". Escanea este código y escribe allí tu frase de contraseña.';

  @override
  String get syncUiAddDeviceNote =>
      'Sirve una vez, durante 24 horas. Alguien que solo tenga este código no puede leer nada sin tu frase de contraseña.';

  @override
  String get syncUiLinkCopied =>
      'Enlace copiado. Pégalo en el dispositivo nuevo.';

  @override
  String get syncUiCopyLink => 'Copiar el enlace';

  @override
  String get syncUiRemoveTitle =>
      '¿Quitar este dispositivo de la sincronización?';

  @override
  String get syncUiRemoveBody =>
      'Dejará de recibir cambios. Si el dispositivo se perdió o lo robaron, cambia también tu frase de contraseña: desactiva la sincronización en todos los dispositivos y vuelve a activarla con una frase nueva, porque el dispositivo perdido todavía conoce la anterior.';

  @override
  String get syncUiTurnOffTitle =>
      '¿Desactivar la sincronización en este dispositivo?';

  @override
  String get syncUiTurnOffBody =>
      'Tus cuentas se quedan en este dispositivo. Solo deja de enviar y recibir cambios. Tus otros dispositivos siguen sincronizándose entre sí.';

  @override
  String get syncUiOff =>
      'La sincronización está desactivada en este dispositivo.';

  @override
  String get syncUiPremium => 'La sincronización es parte de Premium';

  @override
  String syncUiPremiumBody(String payOnce) {
    return 'Añade una cuenta en un dispositivo y aparecerá en todos, con cifrado de extremo a extremo. $payOnce, sin suscripción.';
  }

  @override
  String get syncUiIntro =>
      'La sincronización mantiene tus cuentas iguales en todos tus dispositivos. Antes de salir de este dispositivo, todo se protege con tu frase de contraseña, así que iCloud o nuestro servidor solo guardan datos cifrados. Nadie más puede leerlos, ni siquiera nosotros.';

  @override
  String get syncUiTurnOn => 'Activar sincronización';

  @override
  String get syncUiJoin => 'Unirse desde otro dispositivo';

  @override
  String get syncUiJoinHelp =>
      'Usa \"Unirse\" cuando otro dispositivo ya se sincroniza con el relay de Tanooki.';

  @override
  String get syncUiSyncingRelay => 'Sincronizando con el relay de Tanooki';

  @override
  String get syncUiSyncingICloud => 'Sincronizando con iCloud';

  @override
  String get syncUiSyncingNow => 'Sincronizando…';

  @override
  String syncUiSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No se pudieron leer $count elementos sincronizados',
      one: 'No se pudo leer 1 elemento sincronizado',
    );
    return '$_temp0';
  }

  @override
  String get syncUiSkippedHelp =>
      'Puede que alguien más los haya cambiado o que se crearan con otra frase de contraseña. No se eliminó nada por ellos.';

  @override
  String get syncUiDevices => 'Dispositivos';

  @override
  String get syncUiLoading => 'Cargando…';

  @override
  String get syncUiAddDeviceRelay =>
      'Muestra un código para escanear en el dispositivo nuevo';

  @override
  String get syncUiAddDeviceApple => 'Otro iPhone, iPad o Mac';

  @override
  String get syncUiTurnOffButton =>
      'Desactivar la sincronización en este dispositivo';

  @override
  String get syncUiPassphraseNoteRelay =>
      'Tu frase de contraseña no se puede recuperar. Si la olvidas, desactiva la sincronización en todos los dispositivos y empieza de nuevo con otra. Tus cuentas no se mueven.';

  @override
  String get syncUiPassphraseNoteICloud =>
      'La sincronización usa tu iCloud Drive. Tu frase de contraseña no se puede recuperar; si la olvidas, empieza de cero con otra. Tus cuentas no se mueven.';

  @override
  String get syncUiTitle => 'Sincronización';

  @override
  String get syncUiTooShort =>
      'Usa al menos 10 caracteres. Unas cuantas palabras al azar funcionan bien.';

  @override
  String get syncUiMismatch => 'Las dos frases de contraseña no coinciden.';

  @override
  String get syncUiChoosePassphrase =>
      'Elige una frase de contraseña para sincronizar';

  @override
  String get syncUiTypePassphrase =>
      'Escribe tu frase de contraseña de sincronización';

  @override
  String get syncUiChooseHelp =>
      'La escribirás una vez en cada dispositivo que añadas. Protege tus cuentas antes de que salgan de este dispositivo.\n\nAnótala en un lugar seguro. No se puede recuperar ni restablecer, ni por ti ni por nosotros.';

  @override
  String get syncUiTypeHelp =>
      'La misma frase de contraseña que elegiste al activar la sincronización en tu primer dispositivo.';

  @override
  String get syncUiPassphrase => 'Frase de contraseña de sincronización';

  @override
  String get syncUiTypeAgain => 'Escríbela de nuevo';

  @override
  String get syncUiSectionTitle => 'Sincronización y teléfono';

  @override
  String get syncUiTitlePremium => 'Sincronización (Premium)';

  @override
  String get syncUiOnRelay => 'Activada, con el relay de Tanooki';

  @override
  String get syncUiOnICloud => 'Activada, con iCloud';

  @override
  String get syncUiOffHelp =>
      'Mantén tus cuentas iguales en todos tus dispositivos';

  @override
  String get syncUiBrowser => 'Usar con un navegador';

  @override
  String get syncUiBrowserPremium => 'Usar con un navegador (Premium)';

  @override
  String get syncUiBrowserHelp =>
      'Aprueba códigos en este teléfono para un navegador en cualquier computadora';

  @override
  String get teamUiCreateTitle => 'Crea tu equipo';

  @override
  String get teamUiCreateHint =>
      'TT1.…  (de la página que aparece tras suscribirte)';

  @override
  String get teamUiCreateButton => 'Crear equipo';

  @override
  String get teamUiReady =>
      'Tu equipo está listo. Invita a gente con \"Invitar a alguien\".';

  @override
  String get teamUiScanTitle => 'Escanea la invitación del equipo';

  @override
  String get teamUiScanWrong =>
      'Eso no es una invitación de equipo. Pide al administrador del equipo que abra Ajustes, Bóveda de equipo, Invitar a alguien.';

  @override
  String get teamUiJoinTitle => 'Unirse a un equipo';

  @override
  String get teamUiJoinHint =>
      'tanookiauth://team?…  (el enlace de invitación del administrador)';

  @override
  String get teamUiJoinButton => 'Unirse';

  @override
  String get teamUiJoinedTeam =>
      'Ya estás en el equipo. Las cuentas del equipo aparecerán cuando la app del administrador comparta la clave del equipo con este dispositivo.';

  @override
  String get teamUiInvite => 'Invitar a alguien';

  @override
  String get teamUiInviteHelp =>
      'En su dispositivo: Ajustes, Bóveda de equipo, y luego \"Escanear un código QR de invitación\" o \"Pegar un enlace de invitación\". La invitación sirve una vez y dura 7 días.';

  @override
  String get teamUiRemovePersonTitle => '¿Quitar a esta persona?';

  @override
  String get teamUiRemovePersonBody =>
      'Pierde el acceso de inmediato y el equipo recibe una clave nueva, así que no podrá leer nada que se añada o cambie a partir de ahora. Puede que haya guardado copias de los códigos que ya veía, así que cambia la configuración de verificación en dos pasos de las cuentas importantes.';

  @override
  String get teamUiRemoved => 'Quitado. El equipo tiene una clave nueva.';

  @override
  String get teamUiDeleteTitle => '¿Eliminar el equipo?';

  @override
  String get teamUiLeaveTitle => '¿Salir del equipo?';

  @override
  String get teamUiDeleteBody =>
      'Todas las cuentas del equipo se eliminan para todos los miembros. Las cuentas propias de cada persona no se tocan.';

  @override
  String get teamUiLeaveBody =>
      'Las cuentas del equipo desaparecen de este dispositivo. Tus propias cuentas no se tocan.';

  @override
  String get teamUiDeleteButton => 'Eliminar equipo';

  @override
  String get teamUiLeaveButton => 'Salir';

  @override
  String get teamUiDeleted => 'Equipo eliminado.';

  @override
  String get teamUiLeft => 'Saliste del equipo.';

  @override
  String get teamUiAddFirst =>
      'Primero añade la cuenta a Tanooki Auth y luego cópiala al equipo aquí.';

  @override
  String get teamUiCopyInTitle => 'Copia una de tus cuentas al equipo';

  @override
  String teamUiCopiedIn(String name) {
    return '$name ya está en el equipo. Tu copia sigue donde estaba.';
  }

  @override
  String get teamUiRenameTitle => 'Cambiar nombre de la cuenta del equipo';

  @override
  String get teamUiRenameHint => 'Nombre, p. ej., AWS';

  @override
  String teamUiRemoveAccountTitle(String name) {
    return '¿Quitar $name del equipo?';
  }

  @override
  String get teamUiRemoveAccountBody =>
      'Desaparece para todos los miembros del equipo.';

  @override
  String get teamUiIntro =>
      'Una bóveda de equipo comparte códigos de inicio de sesión con hasta 10 personas, por \$20 al año. Todos en el equipo pueden ver, añadir y cambiar las cuentas del equipo. Se cifran en tus dispositivos con una clave que solo tiene el equipo, así que nuestro servidor no puede leerlas. Las cuentas del equipo están en su propia sección Equipo y nunca se mezclan con las tuyas.';

  @override
  String get teamUiStart => 'Crear un equipo';

  @override
  String get teamUiBuy => 'Comprar un plan de equipo — \$20 al año';

  @override
  String get teamUiPlanSoon => 'Plan de equipo muy pronto';

  @override
  String get teamUiHaveLicense =>
      'Tengo una licencia de equipo: crear el equipo';

  @override
  String get teamUiJoinHelp =>
      'Pide una invitación al administrador del equipo. Unirse es gratis.';

  @override
  String get teamUiScanInvite => 'Escanear un código QR de invitación';

  @override
  String get teamUiPasteInvite => 'Pegar un enlace de invitación';

  @override
  String get teamUiYouRun => 'Administras este equipo';

  @override
  String get teamUiYoureIn => 'Estás en un equipo';

  @override
  String teamUiPeopleCount(int count, int max) {
    return '$count de $max personas';
  }

  @override
  String teamUiLastSynced(String when) {
    return 'Última sincronización: $when';
  }

  @override
  String teamUiPaidUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Pagado hasta el $dateString';
  }

  @override
  String get teamUiSyncNow => 'Sincronizar ahora';

  @override
  String get teamUiWaitingForKey =>
      'Esperando a que la app del administrador comparta la clave del equipo con este dispositivo. Ocurrirá la próxima vez que el administrador abra Tanooki Auth.';

  @override
  String get teamUiAccounts => 'Cuentas del equipo';

  @override
  String get teamUiAddMine => 'Añadir una mía';

  @override
  String get teamUiNoAccounts => 'Aún no hay cuentas del equipo.';

  @override
  String get teamUiChange => 'Cambiar';

  @override
  String get teamUiRename => 'Cambiar nombre';

  @override
  String get teamUiRemoveFromTeam => 'Quitar del equipo';

  @override
  String get teamUiPeople => 'Personas';

  @override
  String get teamUiThisDevice => 'Este dispositivo (administrador)';

  @override
  String teamUiDevice(String id) {
    return 'Dispositivo $id';
  }

  @override
  String teamUiJoined(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Se unió el $dateString';
  }

  @override
  String teamUiJoinedGettingKey(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Se unió el $dateString · recibiendo la clave del equipo';
  }

  @override
  String get teamUiDeleteTeam => 'Eliminar el equipo';

  @override
  String get teamUiLeaveTeam => 'Salir del equipo';

  @override
  String get teamUiTitle => 'Bóveda de equipo';

  @override
  String teamUiCopiedCode(String name) {
    return 'Código de $name copiado. El portapapeles se borrará en 30 segundos.';
  }

  @override
  String teamUiSection(int count) {
    return 'Equipo · $count';
  }

  @override
  String get teamUiWaitingShort =>
      'Esperando a que el administrador comparta la clave del equipo con este dispositivo.';

  @override
  String get teamUiNoAccountsHint =>
      'Aún no hay cuentas del equipo. Añádelas en Ajustes, Bóveda de equipo.';

  @override
  String get themeAuto => 'Automático';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themePink => 'Rosa pastel';

  @override
  String get themeBlue => 'Azul pastel';

  @override
  String get themeLavender => 'Lavanda';

  @override
  String get themeMint => 'Menta';

  @override
  String get themeMidnight => 'Medianoche';

  @override
  String get themeSunset => 'Atardecer';

  @override
  String get themePeach => 'Melocotón';

  @override
  String get themeForest => 'Bosque';

  @override
  String get themeOcean => 'Océano';

  @override
  String get themeMono => 'Mono';

  @override
  String get tidyNoName => '(sin nombre)';

  @override
  String tidyDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se ordenaron $count nombres.',
      one: 'Se ordenó 1 nombre.',
    );
    return '$_temp0';
  }

  @override
  String get tidyTitle => 'Ordenar nombres de cuentas';

  @override
  String get tidyNothing =>
      'Todos los nombres de tus cuentas ya están ordenados.';

  @override
  String get tidyIntro =>
      'Estos nombres incluyen direcciones web o partes de más. Desmarca los que quieras dejar como están y toca Aplicar. Tus códigos no cambian.';

  @override
  String tidyWas(String name) {
    return 'Antes: $name';
  }

  @override
  String get tidyNothingTicked => 'Nada marcado';

  @override
  String tidyApply(int count) {
    return 'Aplicar $count';
  }

  @override
  String get emergencyNotContactCode =>
      'Eso no es un código de contacto de Tanooki Auth. Pídele que abra Tanooki Auth, vaya a Ajustes > Acceso de emergencia y te comparta su código de contacto.';

  @override
  String get emergencyCopyWontOpen =>
      'No se pudo abrir la copia de emergencia con la clave de este dispositivo. Se hizo para otro dispositivo o está dañada.';

  @override
  String get emergencyGone =>
      'Esta copia de emergencia ya no existe. Su dueño la quitó.';

  @override
  String get emergencyWaitNotOver => 'La espera de 7 días aún no ha terminado.';

  @override
  String get emergencyNotOwnerOrContact =>
      'Este dispositivo no es ni el dueño ni el contacto de esa copia de emergencia.';

  @override
  String get emergencyNoRequestToDeny =>
      'Ya no hay ninguna solicitud que denegar.';

  @override
  String get emergencyAskFirst => 'Primero pide acceso.';

  @override
  String get emergencyTooBig =>
      'Tus cuentas ocupan demasiado para dejarlas como copia de emergencia (el límite es de unos 500 KB).';

  @override
  String get emergencyTooManyTries =>
      'Demasiados intentos en un minuto. Espera un minuto y vuelve a intentarlo.';

  @override
  String emergencyServerSaidNo(String status) {
    return 'El servidor de sincronización lo rechazó (HTTP $status).';
  }

  @override
  String emergencyServerSaidNoWhy(String status, String reason) {
    return 'El servidor de sincronización lo rechazó (HTTP $status: $reason).';
  }

  @override
  String get emergencyNotEmergencyCode =>
      'Eso no es un código de emergencia de Tanooki Auth. Pide a la persona que te eligió que te lo vuelva a enviar desde Ajustes > Acceso de emergencia.';

  @override
  String get emergencyLessThanMinute => 'menos de un minuto';

  @override
  String emergencyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String emergencyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count horas',
      one: '1 hora',
    );
    return '$_temp0';
  }

  @override
  String emergencyMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String emergencyDaysHours(int days, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
    );
    String _temp1 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours horas',
      one: '1 hora',
    );
    return '$_temp0 y $_temp1';
  }

  @override
  String get emergencyUiExplainer =>
      'Elige a una persona de confianza. Si te pasa algo, podrá pedir tus cuentas. Tus dispositivos reciben un aviso y tienes 7 días para decir que no. Si nadie lo rechaza, recibe una copia.\n\nEl servidor de Tanooki Auth solo hace cumplir la espera de 7 días. La copia está cerrada con una clave que solo tiene su dispositivo, así que el servidor no puede leerla, ni tampoco nadie que entre en el servidor.';

  @override
  String emergencyUiPushNotWorking(String reason) {
    return 'Las notificaciones aún no funcionan ($reason). Tanooki Auth busca solicitudes cada vez que lo abres.';
  }

  @override
  String get emergencyUiScanTheirQr => 'Escanear su código QR';

  @override
  String get emergencyUiPasteCode => 'Pegar un código que te envió';

  @override
  String get emergencyUiWrongCode => 'Ese no es el código correcto.';

  @override
  String get emergencyUiCopiedCode =>
      'Copiado. Envíaselo como quieras: no contiene ningún secreto.';

  @override
  String get emergencyUiCopyAsText => 'Copiar como texto';

  @override
  String get emergencyUiTheirContactCode => 'Su código de contacto';

  @override
  String get emergencyUiNotContactCodeShort =>
      'Eso no es un código de contacto de Tanooki Auth.';

  @override
  String get emergencyUiMakeThemContact =>
      '¿Hacerle tu contacto de emergencia?';

  @override
  String emergencyUiMakeNamedContact(String name) {
    return '¿Hacer de $name tu contacto de emergencia?';
  }

  @override
  String get emergencyUiCopyLeftOnServer =>
      'Una copia de todas tus cuentas queda cerrada para su dispositivo y guardada en el servidor de Tanooki Auth. Se actualiza cuando cambias tus cuentas.';

  @override
  String get emergencyUiYourNameWhose =>
      'Tu nombre (para que sepa de quién es la copia)';

  @override
  String get emergencyUiDoneGiveCode =>
      'Listo. Ahora dale el código de esta pantalla.';

  @override
  String get emergencyUiStopTitle => '¿Detener el acceso de emergencia?';

  @override
  String get emergencyUiStopBody =>
      'La copia se borra del servidor y ya no podrá pedirla.';

  @override
  String get emergencyUiChooseContact => 'Elegir un contacto de emergencia';

  @override
  String get emergencyUiChooseContactPremium =>
      'Elegir un contacto de emergencia (Premium)';

  @override
  String get emergencyUiChooseContactHow =>
      'Esa persona abre Tanooki Auth en su dispositivo, va a Ajustes > Acceso de emergencia y te muestra su código de contacto.';

  @override
  String get emergencyUiYourContact => 'Tu contacto';

  @override
  String get emergencyUiChecking => 'Consultando con el servidor…';

  @override
  String get emergencyUiIdleJustNow =>
      'Nadie lo ha pedido. Copia actualizada hace un momento.';

  @override
  String emergencyUiIdleUpdated(String day) {
    return 'Nadie lo ha pedido. Copia actualizada por última vez: $day.';
  }

  @override
  String emergencyUiWaiting(String who, String day, String left) {
    return '$who lo pidió el $day. Podrá abrir la copia en $left a menos que lo deniegues.';
  }

  @override
  String emergencyUiReleased(String who) {
    return '$who lo pidió y la espera terminó: ya puede abrir la copia. Deniégalo para impedirlo.';
  }

  @override
  String emergencyUiContactIs(String who) {
    return 'Contacto de emergencia: $who';
  }

  @override
  String get emergencyUiDenied =>
      'Denegado. No puede abrir tus cuentas. Puede volver a pedirlo más tarde.';

  @override
  String get emergencyUiCopyUpdated => 'Copia actualizada.';

  @override
  String get emergencyUiCouldntUpdate => 'No se pudo actualizar la copia.';

  @override
  String get emergencyUiUpdateNow => 'Actualizar copia ahora';

  @override
  String emergencyUiGiveCode(String who) {
    return 'Dale a $who este código. En Tanooki Auth, tiene que ir a Ajustes > Acceso de emergencia > \"Añadir un código que te dieron\".';
  }

  @override
  String get emergencyUiCodeTheyGave => 'Código que te dieron';

  @override
  String get emergencyUiNotEmergencyCodeShort =>
      'Eso no es un código de emergencia de Tanooki Auth.';

  @override
  String get emergencyUiAddedTheir =>
      'Añadido. Si alguna vez lo necesitas, puedes pedir sus cuentas aquí.';

  @override
  String emergencyUiAddedNamed(String name) {
    return 'Añadido. Si alguna vez lo necesitas, puedes pedir las cuentas de $name aquí.';
  }

  @override
  String get emergencyUiTheOwner => 'su dueño';

  @override
  String get emergencyUiAskTitle => '¿Pedir acceso de emergencia?';

  @override
  String emergencyUiAskBody(String who) {
    return '$who recibe un aviso y tiene 7 días para decir que no. Si no lo hace, podrás abrir aquí una copia de sus cuentas. Pídelo solo si de verdad lo necesitas.';
  }

  @override
  String get emergencyUiAsk => 'Pedir';

  @override
  String get emergencyUiAsked => 'Pedido. La espera de 7 días ha empezado.';

  @override
  String emergencyUiAddTheirAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Añadir sus $count cuentas?',
      one: '¿Añadir su cuenta?',
    );
    return '$_temp0';
  }

  @override
  String emergencyUiAddNamedAccounts(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Añadir las $count cuentas de $name?',
      one: '¿Añadir la cuenta de $name?',
    );
    return '$_temp0';
  }

  @override
  String get emergencyUiSomeone => 'Alguien';

  @override
  String get emergencyUiCheckingShort => 'Comprobando…';

  @override
  String get emergencyUiNotAsked => 'No lo has pedido.';

  @override
  String get emergencyUiRequestAccess => 'Pedir acceso';

  @override
  String emergencyUiOpensIn(String left, String day) {
    return 'Lo pediste. Se abre en $left ($day), salvo que diga que no.';
  }

  @override
  String get emergencyUiWaitOver => 'La espera terminó.';

  @override
  String get emergencyUiOpenCopy => 'Abrir copia de emergencia';

  @override
  String emergencyUiPersonAccounts(String who) {
    return 'Cuentas de $who';
  }

  @override
  String get emergencyUiYourContactCode => 'Tu código de contacto';

  @override
  String get emergencyUiShowThis =>
      'Si alguien te quiere como contacto de emergencia, enséñale esto. No contiene ningún secreto.';

  @override
  String get emergencyUiYourNameItsYou =>
      'Tu nombre (para que sepa que eres tú)';

  @override
  String get emergencyUiShowMyCode => 'Mostrar mi código de contacto';

  @override
  String get emergencyUiLetThemScan =>
      'Deja que lo escanee en Tanooki Auth, o cópialo y envíaselo.';

  @override
  String get emergencyUiAddCodeGiven => 'Añadir un código que te dieron';

  @override
  String get emergencyUiAddCodeGivenHow =>
      'Después de elegirte, su app muestra un código para ti';

  @override
  String get emergencyUiTitle => 'Acceso de emergencia';

  @override
  String get emergencyUiYourEmergencyContact => 'Tu contacto de emergencia';

  @override
  String get emergencyUiPeopleWhoChoseYou => 'Personas que te eligieron';

  @override
  String get securityUiProofWindows => 'Windows Hello';

  @override
  String get securityUiProofMac => 'Touch ID o tu contraseña';

  @override
  String get securityUiProofIos => 'Face ID o código';

  @override
  String get securityUiProofOther => 'huella o PIN';

  @override
  String securityUiPasscodeAtLeast(int count) {
    return 'Código (al menos $count números)';
  }

  @override
  String get securityUiTypeAgain => 'Escríbelo otra vez';

  @override
  String get securityUiPasscodesDontMatch => 'Los dos códigos no coinciden.';

  @override
  String get securityUiPickDifferent => 'Elige un código distinto del otro.';

  @override
  String get securityUiEnterPasscode => 'Escribe el código de la app';

  @override
  String get securityUiPasscode => 'Código';

  @override
  String get securityUiWrongPasscode => 'Ese no es tu código.';

  @override
  String get securityUiCheckupTitle => 'Revisión de seguridad';

  @override
  String get securityUiAllGood => 'Todo bien';

  @override
  String get securityUiAllGoodBody =>
      'La app está bloqueada, tienes una copia reciente y todas las cuentas tienen códigos de recuperación.';

  @override
  String get securityUiLockOffTitle => 'La app no está bloqueada';

  @override
  String get securityUiLockOffBody =>
      'Cualquiera que tome tu dispositivo desbloqueado puede ver tus códigos. Activa \"Bloquear la app\" o un código de la app en Ajustes.';

  @override
  String get securityUiNoPasscodeTitle => 'Sin código de la app';

  @override
  String get securityUiNoPasscodeBody =>
      'Un código te deja abrir Tanooki Auth aunque Face ID o tu huella dejen de funcionar. Ponlo en Ajustes.';

  @override
  String get securityUiAutoBackupFailed => 'La copia automática falló';

  @override
  String get securityUiOpenAutoBackups => 'Abrir copias automáticas';

  @override
  String get securityUiNoBackupTitle => 'Sin copia en los últimos 30 días';

  @override
  String get securityUiNoBackupBody =>
      'Si pierdes o se rompe este dispositivo, una copia es la única forma de recuperar tus cuentas.';

  @override
  String get securityUiMakeBackupNow => 'Hacer una copia ahora';

  @override
  String securityUiNoRecoveryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cuentas no tienen códigos de recuperación',
      one: '1 cuenta no tiene códigos de recuperación',
    );
    return '$_temp0';
  }

  @override
  String securityUiNoRecoveryBody(String names) {
    return 'Los códigos de recuperación te dejan entrar en una web si pierdes esta app. Búscalos en los ajustes de seguridad de cada sitio y añádelos con ⋯ > Códigos de recuperación en la cuenta.\n\n$names';
  }

  @override
  String get securityUiRecoveryKit => 'Tu kit de recuperación';

  @override
  String get securityUiRecoveryKitSub =>
      'Copia, códigos de recuperación y copia en papel, paso a paso';

  @override
  String securityUiBreachSnack(String sites) {
    return '$sites sufrió una filtración de datos. Cambia allí tu contraseña.';
  }

  @override
  String get securityUiBreachDownloadFailed =>
      'No se pudo descargar la lista de filtraciones. Revisa tu conexión a internet y vuelve a intentarlo.';

  @override
  String get securityUiBreachAlerts => 'Alertas de filtraciones';

  @override
  String get securityUiBreachAlertsPremium =>
      'Alertas de filtraciones (Premium)';

  @override
  String get securityUiBreachAlertsSub =>
      'Una vez por semana, te avisa si una web que usas sufrió una filtración';

  @override
  String get securityUiBreachHow =>
      'Cómo funciona: Tanooki Auth descarga la lista pública de filtraciones conocidas de haveibeenpwned.com y la compara en este dispositivo con tus webs guardadas. No se envía nada sobre ti ni tus cuentas: es la misma descarga para todos. Es la única vez que la app se conecta a internet, aparte de la sincronización y la compra de Premium.';

  @override
  String securityUiNoWebsite(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count de tus cuentas no tienen web guardada, así que no se pueden comprobar. Añádela con ⋯ > Editar.',
      one: '1 de tus cuentas no tiene web guardada, así que no se puede comprobar. Añádela con ⋯ > Editar.',
    );
    return '$_temp0';
  }

  @override
  String get securityUiCheckNow => 'Comprobar ahora';

  @override
  String get securityUiNoBreaches =>
      'No hay filtraciones conocidas en tus webs guardadas.';

  @override
  String get securityUiBreached =>
      'Filtrada. Si creaste tu contraseña antes de eso, cámbiala allí.';

  @override
  String securityUiBreachedOn(String date) {
    return 'Filtrada el $date. Si creaste tu contraseña antes de eso, cámbiala allí.';
  }

  @override
  String securityUiBreachedLeaked(String data) {
    return 'Filtrada. Datos expuestos: $data. Si creaste tu contraseña antes de eso, cámbiala allí.';
  }

  @override
  String securityUiBreachedOnLeaked(String date, String data) {
    return 'Filtrada el $date. Datos expuestos: $data. Si creaste tu contraseña antes de eso, cámbiala allí.';
  }

  @override
  String get securityUiKitIntro =>
      'Si pierdes este dispositivo, así es como vuelves a entrar en tus cuentas. Cada paso lleva un minuto. Si aún no has añadido cuentas, añádelas primero y luego vuelve aquí desde Ajustes > Revisión de seguridad.';

  @override
  String get securityUiKitBackupTitle => 'Haz una copia';

  @override
  String get securityUiKitBackupBody =>
      'Un archivo cifrado, protegido con una frase de contraseña que tú eliges. Guárdalo fuera de este dispositivo, por ejemplo en iCloud Drive, Google Drive o un USB.';

  @override
  String get securityUiKitBackupButton => 'Hacer una copia';

  @override
  String get securityUiKitCodesTitle => 'Guarda tus códigos de recuperación';

  @override
  String get securityUiKitCodesBody =>
      'Cuando activas el inicio de sesión en dos pasos, la mayoría de webs te dan una lista de códigos de recuperación de un solo uso. Añádelos a cada cuenta con ⋯ > Códigos de recuperación, así también quedan en tu copia.';

  @override
  String get securityUiKitPaperTitle => 'Imprime una copia en papel';

  @override
  String get securityUiKitPaperBody =>
      'Opcional. Una hoja impresa con códigos QR funciona aunque pierdas todos tus dispositivos. Guárdala bajo llave: cualquiera que la tenga puede generar tus códigos.';

  @override
  String get securityUiKitPaperButton => 'Imprimir copia en papel';

  @override
  String get securityUiSkipForNow => 'Omitir por ahora';

  @override
  String get securityExtrasPrivacy =>
      'Sin cuenta y sin rastreo. Tus claves de configuración se guardan cifradas en este dispositivo. La app solo se conecta a internet para: comprobar la hora (pide la hora al servidor de Tanooki Auth, como mucho una vez por hora mientras hay códigos en pantalla y cuando tocas \"¿Los códigos no funcionan?\"; no se envía nada sobre ti ni tus cuentas), las alertas de filtraciones si las activas (descarga la lista pública de filtraciones), la sincronización, el enlace con el teléfono y el acceso de emergencia si los configuras (solo llevan datos cifrados que el servidor no puede leer), comprar Premium y los comentarios que decidas enviar (tu mensaje, tu correo si lo escribes, y la versión de la app y el tipo de dispositivo si dejas esa casilla marcada; nunca tus cuentas, códigos ni nada más de la app). Las guías de 2FA se abren en tu navegador.';

  @override
  String get securityExtrasMonthlyBody =>
      'Tu resumen mensual de seguridad está listo. Abre Tanooki Auth para verlo.';

  @override
  String get securityExtrasNotificationsOffIos =>
      'Las notificaciones de Tanooki Auth están desactivadas. Actívalas en la app Ajustes del iPhone, en Notificaciones, y vuelve a intentarlo.';

  @override
  String get securityExtrasNotificationsOffMac =>
      'Las notificaciones de Tanooki Auth están desactivadas. Actívalas en Ajustes del Sistema, en Notificaciones, y vuelve a intentarlo.';

  @override
  String securityExtrasReminderFailed(String reason) {
    return 'No se pudo programar el recordatorio ($reason).';
  }

  @override
  String get securityExtrasRemindersUnavailable =>
      'Los recordatorios aún no están disponibles en este dispositivo.';

  @override
  String securityExtrasDayTime(String day, String time) {
    return '$day, $time';
  }

  @override
  String get securityExtrasClearTitle => '¿Borrar el historial de actividad?';

  @override
  String get securityExtrasClearBody =>
      'Se borran todas las entradas de este dispositivo. Tus cuentas no se tocan.';

  @override
  String get securityExtrasActivityTitle => 'Historial de actividad';

  @override
  String securityExtrasActivityPitch(int count) {
    return 'El historial de actividad es parte de Premium. Guarda las últimas $count veces que se copió un código, se rellenó en una web, se escribió, se mostró como código QR o se exportó, solo en este dispositivo.';
  }

  @override
  String get securityExtrasNothingYet =>
      'Aún no hay nada. Aquí aparecerá cuando copies, rellenes, escribas, muestres un código QR o exportes.';

  @override
  String get securityExtrasAllAccounts => 'Todas las cuentas';

  @override
  String get securityExtrasDeletedAccount => 'Una cuenta eliminada';

  @override
  String securityExtrasActivityLine(String kind, String what) {
    return '$kind: $what';
  }

  @override
  String get securityExtrasGetPremium => 'Obtener Premium';

  @override
  String get securityExtrasAddKey => 'Añadir una llave de seguridad';

  @override
  String get securityExtrasAddKeyPremium =>
      'Añadir una llave de seguridad (Premium)';

  @override
  String get securityExtrasAddKeyIos =>
      'Después, cuando se te pida, acerca la llave a la parte de arriba del iPhone o conéctala. Puede que tengas que tocarla dos veces.';

  @override
  String get securityExtrasAddKeyOther =>
      'Después, conecta la llave y tócala cuando parpadee. Puede que tengas que tocarla dos veces y escribir su PIN si tiene.';

  @override
  String get securityExtrasKeyName => 'Nombre (para distinguir tus llaves)';

  @override
  String securityExtrasKeyAdded(String name) {
    return 'Añadida \"$name\". Ya puedes desbloquear Tanooki Auth con ella en este dispositivo.';
  }

  @override
  String securityExtrasKeyRemoved(String name) {
    return 'Quitada \"$name\". Ya no puede desbloquear Tanooki Auth.';
  }

  @override
  String get securityExtrasKeysTitle => 'Llaves de seguridad';

  @override
  String securityExtrasKeysIntro(String usual) {
    return 'Una llave de seguridad (como una YubiKey) puede desbloquear Tanooki Auth en lugar de $usual. La llave guarda un secreto que nunca sale de ella, y la app lo usa para proteger la clave de tus cuentas. Si pierdes la llave, aún puedes desbloquear como siempre.';
  }

  @override
  String securityExtrasKeyAddedOn(String day) {
    return 'Añadida $day';
  }

  @override
  String get securityExtrasLockOffNote =>
      'El bloqueo está desactivado, así que la app se abre sin preguntar. Activa \"Bloquear la app\" o un código en Ajustes para usar tu llave.';

  @override
  String get securityExtrasLockWordWindows => 'Windows Hello o tu código';

  @override
  String get securityExtrasLockWordMac => 'Touch ID o tu código';

  @override
  String get securityExtrasLockWordOther => 'Face ID o tu código';

  @override
  String get securityLockImmediately => 'Inmediatamente';

  @override
  String get securityLockAfter30s => 'Tras 30 segundos';

  @override
  String get securityLockAfter1m => 'Tras 1 minuto';

  @override
  String get securityLockAfter5m => 'Tras 5 minutos';

  @override
  String get securityNumbersOnly => 'Usa solo números.';

  @override
  String securityAtLeastNumbers(int count) {
    return 'Usa al menos $count números.';
  }

  @override
  String get securitySameNumber => 'No uses el mismo número una y otra vez.';

  @override
  String get securityNumbersInRow => 'No uses números seguidos como 123456.';

  @override
  String get securityPanicNeedsPasscode =>
      'Primero pon un código de la app. El borrado de pánico cuenta los códigos incorrectos.';

  @override
  String get securityPanicNeedsBackup =>
      'Primero haz una copia (Ajustes > Exportar copia). El borrado de pánico elimina todas las cuentas, así que solo se activa si hiciste una copia en los últimos 30 días.';

  @override
  String get securityKeyDefaultName => 'Llave de seguridad';

  @override
  String get securityKeyNotYours =>
      'Esa llave de seguridad no es una de las que añadiste a Tanooki Auth en este dispositivo.';

  @override
  String get securityKeyNotAvailable =>
      'Aún no disponible en este dispositivo.';

  @override
  String get securityKeyWindowsTooOld =>
      'Aún no disponible en esta versión de Windows. Instala las últimas actualizaciones de Windows 11.';

  @override
  String get securityKeyIosTooOld =>
      'Necesita iOS 26.4 o posterior. Actualiza en la app Ajustes y vuelve a intentarlo.';

  @override
  String get securityKeyMacTooOld =>
      'Necesita macOS 26.4 o posterior. Actualiza en la app Ajustes y vuelve a intentarlo.';

  @override
  String get securityKeyDidntWork =>
      'La llave de seguridad no funcionó. Vuelve a intentarlo.';

  @override
  String securityKeyDidntWorkWhy(String reason) {
    return 'La llave de seguridad no funcionó ($reason). Vuelve a intentarlo.';
  }

  @override
  String get securityKeyCanceled => 'Cancelado. No ha cambiado nada.';

  @override
  String get securityKeyNoPrf =>
      'Esta llave de seguridad no puede desbloquear apps de esta forma (no tiene la función \"hmac-secret\"). La serie YubiKey 5 y la mayoría de llaves FIDO2 de los últimos años sí la tienen.';

  @override
  String get securityKeyNotAllowed =>
      'La llave de seguridad no respondió, o no es una de las añadidas aquí. Conéctala (o acércala a la parte de arriba del teléfono) y tócala cuando parpadee.';

  @override
  String get securityKeyNotAssociated =>
      'Esta copia de Tanooki Auth aún no puede usar llaves de seguridad: Apple necesita que la app esté vinculada a auth.tanookistudios.com primero. Es cosa nuestra, no tuya.';

  @override
  String get securityKeyExists => 'Esta llave de seguridad ya está añadida.';

  @override
  String get securityKeyPin =>
      'La llave de seguridad necesita su PIN y no se escribió. Vuelve a intentarlo y escribe el PIN de la llave cuando se te pida.';

  @override
  String get securityKeyVaultKeyMissing =>
      'Falta la clave que desbloquea tus cuentas, así que no se puede añadir una llave de seguridad.';

  @override
  String get securityKeyNoneAdded =>
      'No hay ninguna llave de seguridad añadida en este dispositivo.';

  @override
  String get securityKeyBeforeReset =>
      'Esa llave de seguridad se añadió antes de restablecer tus cuentas, así que no puede abrirlas. Quítala y vuelve a añadirla.';

  @override
  String get backupUiChoosePassphrase =>
      'Elige una frase de contraseña para la copia';

  @override
  String get backupUiPassphraseTitle => 'Frase de contraseña de la copia';

  @override
  String get backupUiPassphraseWarning =>
      'La necesitarás para restaurar la copia. Nadie, ni siquiera nosotros, puede recuperarla si la olvidas. Apúntala en un lugar seguro.';

  @override
  String get backupUiPassphrase => 'Frase de contraseña';

  @override
  String get backupUiTypeAgain => 'Escríbela otra vez';

  @override
  String get backupUiTooShort =>
      'Usa al menos 8 caracteres. Unas cuantas palabras al azar funcionan bien.';

  @override
  String get backupUiNoMatch => 'Las dos frases no coinciden.';

  @override
  String get backupUiTypePassphrase => 'Escribe la frase de contraseña.';

  @override
  String get backupUiNothingToBackUp => 'Aún no hay cuentas que copiar.';

  @override
  String get backupUiEncrypting => 'Cifrando la copia…';

  @override
  String backupUiSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Copia de $count cuentas guardada.',
      one: 'Copia de 1 cuenta guardada.',
    );
    return '$_temp0';
  }

  @override
  String get backupUiNotABackup =>
      'Ese archivo no es una copia de Tanooki Auth.';

  @override
  String get backupUiUnlocking => 'Desbloqueando la copia…';

  @override
  String backupUiImported(int count) {
    return 'Importadas: $count.';
  }

  @override
  String backupUiImportedSkipped(int added, int skipped) {
    return 'Importadas: $added. Omitidas: $skipped.';
  }

  @override
  String backupUiImportedSkippedAlready(int added, int skipped) {
    return 'Importadas: $added. Omitidas $skipped que ya estaban en tu lista.';
  }

  @override
  String backupUiAdded(int count) {
    return 'Añadidas: $count.';
  }

  @override
  String backupUiAddedSkipped(int added, int skipped) {
    return 'Añadidas: $added. Omitidas: $skipped.';
  }

  @override
  String backupUiAddedSkippedAlready(int added, int skipped) {
    return 'Añadidas: $added. Omitidas $skipped que ya estaban en tu lista.';
  }

  @override
  String backupUiAlreadyInList(int count) {
    return '• $count ya en tu lista';
  }

  @override
  String get backupUiImport => 'Importar';

  @override
  String backupUiImportFromGoogle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Importar $count desde Google Authenticator?',
      one: '¿Importar 1 desde Google Authenticator?',
    );
    return '$_temp0';
  }

  @override
  String get backupUiGoogleMoreCodes =>
      'Si Google Authenticator mostró más de un código QR, escanéalos todos.';

  @override
  String get backupUiNothingToExport => 'Aún no hay cuentas que exportar.';

  @override
  String get backupUiPlainWhat =>
      'Esto guarda todas las claves de configuración como texto sin cifrar, para pasarlas a otra app de autenticación.';

  @override
  String get backupUiPlainTitle => '¿Exportar sin cifrar?';

  @override
  String backupUiPlainBody(String what) {
    return '$what Cualquiera que consiga este archivo puede generar tus códigos de inicio de sesión. Impórtalo y bórralo enseguida. Para una copia normal, usa \"Exportar copia\".';
  }

  @override
  String get backupUiUnderstandExport => 'Entendido, exportar';

  @override
  String get backupUiNothingToPrint => 'Aún no hay cuentas que imprimir.';

  @override
  String get backupUiPaperTitle => '¿Imprimir una copia en papel?';

  @override
  String get backupUiPaperBody =>
      'Esto crea un PDF con un código QR por cuenta, más tus códigos de recuperación sin usar. Quien vea o fotografíe ese papel puede generar tus códigos de inicio de sesión para siempre, sin tu teléfono ni tu contraseña.\n\nImprímelo y luego borra el PDF. Guarda el papel bajo llave, por ejemplo en una caja fuerte o con documentos importantes. No lo envíes por correo ni lo guardes en una carpeta compartida.';

  @override
  String get backupUiUnderstandPdf => 'Entendido, crear el PDF';

  @override
  String get backupUiMakingPdf => 'Creando el PDF…';

  @override
  String get backupUiPdfReady =>
      'PDF listo. Imprímelo y luego borra el archivo.';

  @override
  String get backupUiWorksTitle => 'La copia funciona';

  @override
  String backupUiWorksBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Esta copia se abre bien y tiene $count cuentas. No se ha añadido ni cambiado nada.',
      one: 'Esta copia se abre bien y tiene 1 cuenta. No se ha añadido ni cambiado nada.',
    );
    return '$_temp0';
  }

  @override
  String get backupWrongVersion =>
      'Esta copia se hizo con una versión más nueva de Tanooki Auth. Actualiza la app y vuelve a intentarlo.';

  @override
  String get backupWrongPassphrase =>
      'Frase de contraseña incorrecta, o el archivo de copia está dañado.';

  @override
  String get backupDamaged =>
      'La copia se desbloqueó, pero su contenido está dañado.';

  @override
  String get paperBackupTitle => 'Copia en papel de Tanooki Auth';

  @override
  String paperBackupHeader(String date) {
    return 'Copia en papel de Tanooki Auth, $date';
  }

  @override
  String get paperBackupWarning =>
      'GUÁRDALO EN SECRETO. Cualquiera con este papel puede generar tus códigos de inicio de sesión. Guárdalo bajo llave y destrúyelo cuando hagas uno nuevo. Para restaurar: en cualquier app de autenticación, elige \"Escanear código QR\" y escanea cada código de abajo.';

  @override
  String paperBackupSetupKey(String key) {
    return 'Clave de configuración: $key';
  }

  @override
  String get paperBackupRecoveryCodes =>
      'Códigos de recuperación (cada uno sirve una vez):';

  @override
  String get autoBackupUiChooseFolderDialog =>
      'Elige una carpeta para las copias automáticas';

  @override
  String autoBackupUiToday(String time) {
    return 'Hoy a las $time';
  }

  @override
  String autoBackupUiYesterday(String time) {
    return 'Ayer a las $time';
  }

  @override
  String autoBackupUiOnDay(String date, String time) {
    return '$date a las $time';
  }

  @override
  String get autoBackupUiBackingUp => 'Haciendo la copia…';

  @override
  String autoBackupUiBackedUp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Copia hecha de $count cuentas.',
      one: 'Copia hecha de 1 cuenta.',
    );
    return '$_temp0';
  }

  @override
  String get autoBackupUiCouldntUseFolder => 'No se pudo usar esa carpeta.';

  @override
  String autoBackupUiCouldntUseFolderWhy(String reason) {
    return 'No se pudo usar esa carpeta. $reason';
  }

  @override
  String get autoBackupUiTurnOffTitle => '¿Desactivar las copias automáticas?';

  @override
  String get autoBackupUiTurnOffBody =>
      'Las copias que ya están en la carpeta se quedan ahí. La frase de contraseña se olvida, así que elegirás una nueva si vuelves a activarlo.';

  @override
  String get autoBackupUiTitle => 'Copias automáticas';

  @override
  String get autoBackupUiTitlePremium => 'Copias automáticas (Premium)';

  @override
  String autoBackupUiIntro(int count) {
    return 'Una vez al día, Tanooki Auth guarda una copia cifrada en la carpeta que elijas. Elige tu carpeta de iCloud Drive, Google Drive o Dropbox y tus copias también estarán fuera de este dispositivo. Se guardan las $count más recientes; las más antiguas se borran.\n\nRestaura una con Ajustes > Importar copia y tu frase de contraseña.';
  }

  @override
  String get autoBackupUiLastFailed => 'La última copia automática falló';

  @override
  String get autoBackupUiChooseFolder => 'Elegir una carpeta';

  @override
  String get autoBackupUiBackupFolder => 'Carpeta de copias';

  @override
  String get autoBackupUiNoBackupYet => 'Aún no hay copia';

  @override
  String autoBackupUiLastBackup(String when) {
    return 'Última copia: $when';
  }

  @override
  String get autoBackupUiBackUpNow => 'Hacer copia ahora';

  @override
  String get autoBackupUiChangeFolder => 'Cambiar carpeta';

  @override
  String get autoBackupUiOffSubtitle =>
      'Desactivado. Una copia cifrada diaria en iCloud Drive, Google Drive, Dropbox o cualquier carpeta.';

  @override
  String autoBackupUiOnNoBackup(String folder) {
    return 'Activado, en $folder. Aún no hay copia.';
  }

  @override
  String autoBackupUiOnLast(String folder, String when) {
    return 'Activado, en $folder. Última copia: $when.';
  }

  @override
  String get autoBackupFolderGone =>
      'La carpeta de copias ya no está. Puede que se haya borrado, renombrado fuera de la app o que su disco esté desconectado. Vuelve a elegir la carpeta.';

  @override
  String get autoBackupPermissionLost =>
      'Tanooki Auth ya no tiene permiso para escribir en la carpeta de copias. Vuelve a elegir la carpeta para darle permiso otra vez.';

  @override
  String get autoBackupDiskFull =>
      'El disco de la carpeta de copias está lleno. Libera algo de espacio y toca Hacer copia ahora.';

  @override
  String get autoBackupOther =>
      'No se pudo guardar la copia. Toca Hacer copia ahora para intentarlo de nuevo.';

  @override
  String autoBackupOtherWhy(String reason) {
    return 'No se pudo guardar la copia ($reason). Toca Hacer copia ahora para intentarlo de nuevo.';
  }

  @override
  String get importUiDeleteNote =>
      'Cuando termines, borra el archivo exportado: cualquiera que lo consiga puede generar tus códigos.';

  @override
  String get importUiStepsAegis =>
      'En Aegis, en tu teléfono Android:\n\n1. Toca ⋮, luego Ajustes y luego \"Importar y exportar\".\n2. Toca \"Exportar\" y elige \"Aegis (.JSON)\".\n3. Si quieres, deja activado \"Cifrar la bóveda\"; escribirás esa contraseña aquí.\n4. Guarda el archivo en un sitio que este dispositivo pueda abrir (por ejemplo Google Drive, o envíatelo por correo).\n\nLuego elige ese archivo aquí.';

  @override
  String get importUiStepsTwoFas =>
      'En 2FAS:\n\n1. Abre Ajustes y luego \"Copia de seguridad de 2FAS\".\n2. Toca \"Exportar a archivo\". Si te pide una contraseña, escribirás la misma aquí.\n3. Guarda el archivo .2fas en un sitio que este dispositivo pueda abrir.\n\nLuego elige ese archivo aquí.';

  @override
  String get importUiStepsAuthy =>
      'Authy no tiene botón de exportar, y Authy para ordenadores dejó de funcionar en 2024.\n\nSi ya sacaste tus cuentas con una herramienta como \"authy-export\", elige el archivo que creó (un archivo .json, o una lista .txt de enlaces otpauth://).\n\nSi no, lo seguro es ir cuenta por cuenta: entra en cada web, desactiva y vuelve a activar el inicio de sesión en dos pasos y escanea el nuevo código QR con Tanooki Auth. No borres Authy hasta que todas las cuentas funcionen aquí.';

  @override
  String get importUiStepsBitwarden =>
      'En Bitwarden (web o app de escritorio):\n\n1. Ve a Herramientas y luego \"Exportar caja fuerte\".\n2. Elige \".json\" o \".csv\". No \"cifrado\".\n3. Guarda el archivo.\n\nLuego elige ese archivo aquí. Solo se pasan los inicios de sesión con clave de autenticación; tus contraseñas se ignoran.';

  @override
  String get importUiStepsOnePassword =>
      'En la app 1Password para Mac o Windows:\n\n1. Haz clic en Archivo, luego Exportar, y elige tu cuenta.\n2. Elige \"CSV\" como formato y guarda.\n\nLuego elige ese archivo aquí. Solo se pasan los elementos con contraseña de un solo uso; tus contraseñas se ignoran.';

  @override
  String get importUiStepsApple =>
      'Para esto necesitas un Mac; el iPhone no puede guardar el archivo.\n\nEn un Mac con macOS Sequoia o posterior:\n1. Abre la app Contraseñas.\n2. En la barra de menús, haz clic en Archivo y luego \"Exportar todas las contraseñas…\".\n3. Haz clic en \"Exportar contraseñas\", escribe la contraseña del Mac si te la pide y guarda el archivo.\n\nEn un Mac más antiguo: abre Safari, luego Safari > Ajustes > Contraseñas, haz clic en el botón ⋯ y elige \"Exportar todas las contraseñas…\".\n\nLuego elige ese archivo aquí. Solo se pasan los elementos con código de verificación; tus contraseñas se ignoran.';

  @override
  String get importUiStepsMicrosoft =>
      'Microsoft Authenticator no puede exportar tus cuentas, así que no se pueden pasar todas de una vez.\n\nPara cada cuenta:\n1. Entra en esa web desde un ordenador.\n2. Busca sus ajustes de seguridad o de verificación en dos pasos.\n3. Desactiva y vuelve a activar el inicio de sesión en dos pasos (o elige \"añadir una nueva app de autenticación\").\n4. Escanea el nuevo código QR con Tanooki Auth y escribe el código que muestra para terminar.\n\nNo borres Microsoft Authenticator hasta que todas las cuentas funcionen en Tanooki Auth. Tu propia cuenta Microsoft también puede usar Tanooki Auth: añádela en account.microsoft.com, en Seguridad.';

  @override
  String get importUiTitle => 'Traer de otra app';

  @override
  String get importUiCantExport =>
      'No se puede exportar: cómo pasar cada cuenta';

  @override
  String get importUiFromExportFile => 'Desde un archivo exportado';

  @override
  String importUiMoveFrom(String app) {
    return 'Traer de $app';
  }

  @override
  String get importUiGotIt => 'Entendido';

  @override
  String get importUiPickFile => 'Elegir archivo';

  @override
  String get importUiCouldntRead => 'No se pudo leer ese archivo.';

  @override
  String importUiReading(String app) {
    return 'Leyendo la exportación de $app…';
  }

  @override
  String get importUiNoAccountsInFile =>
      'No había cuentas de dos pasos en ese archivo.';

  @override
  String importUiImportFrom(int count, String app) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '¿Importar $count desde $app?',
      one: '¿Importar 1 desde $app?',
    );
    return '$_temp0';
  }

  @override
  String importUiExportPassword(String app) {
    return 'Contraseña de la exportación de $app';
  }

  @override
  String get importUiPasswordHint => 'La contraseña que elegiste al exportar';

  @override
  String importersNotAnExport(String app) {
    return 'Ese archivo no es una exportación de $app.';
  }

  @override
  String importersLine(String line, String problem) {
    return 'Línea $line: $problem';
  }

  @override
  String get importersEmpty => 'Ese archivo está vacío.';

  @override
  String get importersNotAuthy => 'Ese archivo no es una exportación de Authy.';

  @override
  String get importersAnAccount => 'Una cuenta';

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
      'Esta exportación de Aegis está protegida con contraseña.';

  @override
  String get importersAegisBiometricOnly =>
      'Esta exportación de Aegis solo se puede abrir con la huella en el teléfono que la creó. En Aegis, vuelve a exportar y elige una contraseña.';

  @override
  String get importersAegisWrongPassword =>
      'Contraseña incorrecta para esta exportación de Aegis.';

  @override
  String get importersAegisDamaged =>
      'La exportación de Aegis se desbloqueó, pero su contenido está dañado.';

  @override
  String get importersNotAegis => 'Ese archivo no es una exportación de Aegis.';

  @override
  String importersUnsupportedType(String type) {
    return 'usa códigos $type, que Tanooki Auth no admite';
  }

  @override
  String get importersNotTwoFas => 'Ese archivo no es una copia de 2FAS.';

  @override
  String get importersTwoFasPassword =>
      'Esta copia de 2FAS está protegida con contraseña.';

  @override
  String get importersTwoFasDamaged => 'Esta copia de 2FAS está dañada.';

  @override
  String get importersTwoFasWrongPassword =>
      'Contraseña incorrecta para esta copia de 2FAS.';

  @override
  String get importersBitwardenEncrypted =>
      'Esa exportación de Bitwarden está cifrada. En Bitwarden, vuelve a exportar y elige el formato \".json\" (no \"cifrado\").';

  @override
  String get importersOnePux =>
      'Parece un archivo .1pux de 1Password. En 1Password, vuelve a exportar y elige CSV.';

  @override
  String importersNoCodeColumn(String app) {
    return 'Ese archivo no tiene columna de códigos de un solo uso, así que no es una exportación de $app con códigos.';
  }

  @override
  String importersCantReadCode(String reason) {
    return 'tiene un código de un solo uso que Tanooki Auth no puede leer ($reason)';
  }

  @override
  String get importersNoSecret => 'no tiene secreto';

  @override
  String get importersBadSecret => 'tiene un secreto que no es válido';

  @override
  String importersUnsupportedDigits(int count) {
    return 'usa códigos de $count dígitos, que Tanooki Auth no admite';
  }

  @override
  String get importersBadPeriod => 'tiene un periodo de tiempo roto';

  @override
  String importersUnsupportedAlgorithm(String algorithm) {
    return 'usa el algoritmo $algorithm, que Tanooki Auth no admite';
  }

  @override
  String get exportUiTitle => 'Pasar a otra app';

  @override
  String get exportUiAegisLocked => 'Aegis, con contraseña';

  @override
  String get exportUiAegisLockedSub =>
      'Lo más seguro. Aegis pide la contraseña al importar.';

  @override
  String get exportUiAegisPlain => 'Aegis, sin cifrar';

  @override
  String get exportUiAegisPlainSub =>
      'Para apps que leen archivos de Aegis pero no pueden abrir los protegidos.';

  @override
  String get exportUiTwoFasSub => 'Un archivo .2fas sin contraseña.';

  @override
  String get exportUiGoogleSub =>
      'Códigos QR para escanear con Google Authenticator.';

  @override
  String get exportUiLinks => 'Enlaces de configuración (texto sin cifrar)';

  @override
  String get exportUiLinksSub =>
      'Un enlace otpauth:// por línea, para cualquier otra app.';

  @override
  String get exportUiConfirmReason => 'Exportar tus cuentas';

  @override
  String get exportUiEncryptingAegis => 'Cifrando para Aegis…';

  @override
  String get exportUiAegisPlainWhat =>
      'Esto guarda todas las claves de configuración en un archivo de Aegis sin cifrar.';

  @override
  String get exportUiTwoFasWhat =>
      'Esto guarda todas las claves de configuración en un archivo de 2FAS sin contraseña.';

  @override
  String get exportUiGoogleTitle =>
      '¿Mostrar códigos QR para Google Authenticator?';

  @override
  String get exportUiGoogleBody =>
      'La siguiente pantalla muestra códigos QR con todas las claves de configuración. Quien los vea o fotografíe puede generar tus códigos de inicio de sesión. Hazlo en un lugar privado.\n\nEn Google Authenticator: toca +, luego \"Escanear un código QR\", y escanea cada código por turno.';

  @override
  String get exportUiShowCodes => 'Mostrar los códigos';

  @override
  String exportUiExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count cuentas exportadas. Importa el archivo en la otra app y luego bórralo.',
      one: '1 cuenta exportada. Importa el archivo en la otra app y luego bórralo.',
    );
    return '$_temp0';
  }

  @override
  String get exportUiNoneForGoogle =>
      'Ninguna de tus cuentas puede ir a Google Authenticator.';

  @override
  String get exportUiScanThisCode => 'Escanea este código';

  @override
  String exportUiCodeOf(int n, int total) {
    return 'Código $n de $total';
  }

  @override
  String get exportUiNextCode => 'Siguiente código';

  @override
  String exportUiLeftOut(int count) {
    return 'Fuera ($count). Google Authenticator no puede generar estos códigos, así que añádelos a otra app:';
  }

  @override
  String get appIconClassic => 'Clásico';

  @override
  String get appIconPink => 'Rosa pastel';

  @override
  String get appIconBlue => 'Azul pastel';

  @override
  String get appIconLavender => 'Lavanda';

  @override
  String get appIconMint => 'Menta';

  @override
  String get appIconMidnight => 'Medianoche';

  @override
  String get appIconSunset => 'Atardecer';

  @override
  String get appIconSpooky => 'Terrorífico (otoño)';

  @override
  String get appIconCozy => 'Acogedor (invierno)';

  @override
  String get appIconSpring => 'Primavera';

  @override
  String get serverBrowserExtension => 'Extensión del navegador';

  @override
  String get serverBadRequest => 'Tanooki Auth no entendió esa solicitud.';

  @override
  String get serverLocked =>
      'Tanooki Auth está bloqueado. Desbloquéalo y vuelve a intentarlo.';

  @override
  String get serverNotPaired => 'Esta app no está vinculada con Tanooki Auth.';

  @override
  String get serverNotFound => 'Esa cuenta ya no está en Tanooki Auth.';

  @override
  String get serverRateLimited => 'Demasiadas solicitudes.';

  @override
  String get serverDenied =>
      'No permitido: esta cuenta pide confirmación primero, y Tanooki Auth no se desbloqueó para ella.';

  @override
  String get serverUnknownScreen => 'Pantalla desconocida.';

  @override
  String get serverNoWebsite => 'No se indicó ninguna web.';

  @override
  String serverUnknownRequest(String type) {
    return 'Solicitud desconocida \"$type\".';
  }

  @override
  String get serverPairingTimedOut =>
      'La vinculación caducó o se cerró. Vuelve a empezar la vinculación.';

  @override
  String get serverThreeWrongCodes =>
      'Tres códigos incorrectos. Vuelve a empezar la vinculación.';

  @override
  String get serverWrongCode =>
      'Ese código no coincide. Revisa el código que muestra Tanooki Auth.';

  @override
  String get serverNoLink => 'No se envió ningún enlace otpauth://.';

  @override
  String get serverAlreadyThere => 'Esa cuenta ya está en Tanooki Auth.';

  @override
  String get serverAlreadyThereMany => 'Esas cuentas ya están en Tanooki Auth.';

  @override
  String get autoBackupNotSupported => 'no compatible con este dispositivo';

  @override
  String homeProveCopy(String name) {
    return 'Copiar el código de $name';
  }

  @override
  String homeProveReadAloud(String name) {
    return 'Leer en voz alta el código de $name';
  }

  @override
  String homeProveEdit(String name) {
    return 'Editar $name';
  }

  @override
  String homeProveShare(String name) {
    return 'Compartir $name';
  }

  @override
  String homeCopied(String name) {
    return 'Código de $name copiado. El portapapeles se borra en 30 segundos.';
  }

  @override
  String get homeEditAccount => 'Editar cuenta';

  @override
  String homeShowQrFor(String name) {
    return 'Mostrar el código QR de $name';
  }

  @override
  String homeMovedToTrash(String name) {
    return '$name se movió a la papelera. Puedes restaurarla desde Ajustes durante 30 días.';
  }

  @override
  String get homeUndo => 'Deshacer';

  @override
  String homeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cuentas',
      one: '1 cuenta',
    );
    return '$_temp0';
  }

  @override
  String homeAddTagTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Añadir una etiqueta a $count cuentas',
      one: 'Añadir una etiqueta a 1 cuenta',
    );
    return '$_temp0';
  }

  @override
  String get homeTagHint => 'Etiqueta (p. ej., trabajo)';

  @override
  String get homeAddTag => 'Añadir etiqueta';

  @override
  String homeTagged(int count, String tag) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se añadió la etiqueta \"$tag\" a $count cuentas.',
      one: 'Se añadió la etiqueta \"$tag\" a 1 cuenta.',
    );
    return '$_temp0';
  }

  @override
  String homeMoveToFolderTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mover $count cuentas a una carpeta',
      one: 'Mover 1 cuenta a una carpeta',
    );
    return '$_temp0';
  }

  @override
  String get homeNoFolder => 'Sin carpeta';

  @override
  String get homeNewFolderHint => 'O una carpeta nueva (p. ej., Trabajo)';

  @override
  String get homeMoveToNewFolder => 'Mover a una carpeta nueva';

  @override
  String homeTookOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se sacaron $count cuentas de sus carpetas.',
      one: 'Se sacó 1 cuenta de su carpeta.',
    );
    return '$_temp0';
  }

  @override
  String homeMovedTo(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se movieron $count cuentas a $folder.',
      one: 'Se movió 1 cuenta a $folder.',
    );
    return '$_temp0';
  }

  @override
  String homeAddedToFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se añadieron $count cuentas a favoritos.',
      one: 'Se añadió 1 cuenta a favoritos.',
    );
    return '$_temp0';
  }

  @override
  String homeRemovedFromFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se quitaron $count cuentas de favoritos.',
      one: 'Se quitó 1 cuenta de favoritos.',
    );
    return '$_temp0';
  }

  @override
  String homeBulkTrashed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Se movieron $count cuentas a la papelera. Puedes restaurarlas desde Ajustes durante 30 días.',
      one: 'Se movió 1 cuenta a la papelera. Puedes restaurarla desde Ajustes durante 30 días.',
    );
    return '$_temp0';
  }

  @override
  String get homeDoneSelecting => 'Terminar selección';

  @override
  String get homeTapToSelect => 'Toca cuentas para seleccionarlas';

  @override
  String homeSelectedCount(int count) {
    return '$count seleccionadas';
  }

  @override
  String get homeSelectNone => 'No seleccionar ninguna';

  @override
  String get homeSelectAll => 'Seleccionar todas';

  @override
  String get homeAddATag => 'Añadir una etiqueta';

  @override
  String get homeMoveToFolder => 'Mover a carpeta';

  @override
  String get homeRemoveFromFavorites => 'Quitar de favoritos';

  @override
  String get homeAddToFavorites => 'Añadir a favoritos';

  @override
  String get homeMoveToTrash => 'Mover a la papelera';

  @override
  String get homeSelectFirst =>
      'Primero selecciona algunas cuentas: tócalas en la lista.';

  @override
  String homeSectionOpen(String name, String accounts) {
    return '$name, $accounts, toca para plegar';
  }

  @override
  String homeSectionClosed(String name, String accounts) {
    return '$name, $accounts, toca para mostrar';
  }

  @override
  String get homeSearchHint => 'Buscar cuentas o webs…';

  @override
  String get homeAllTags => 'Todas';

  @override
  String get homeNoAccountsYet =>
      'Aún no hay cuentas.\nAñade una para escanear un código QR de configuración.';

  @override
  String get homeNoTagMatches => 'No hay cuentas con esta etiqueta.';

  @override
  String get homeNoSearchMatches => 'Ninguna cuenta coincide con tu búsqueda.';

  @override
  String get homeSelectAccounts => 'Seleccionar cuentas';

  @override
  String get homeSettings => 'Ajustes';

  @override
  String get homeAddAccount => 'Añadir cuenta';

  @override
  String get homeAccounts => 'Cuentas';

  @override
  String get homeYourAccounts => 'Tus cuentas';

  @override
  String get homeSelect => 'Seleccionar';

  @override
  String get homeKeysTouch =>
      'Tocar (Copiar) · Intro (Copiar) · Flechas (Moverse)';

  @override
  String get homeKeysClick =>
      'Clic (Copiar) · Intro (Copiar) · Flechas (Moverse)';

  @override
  String get homePickOnLeft =>
      'Elige una cuenta a la izquierda para verla aquí.';

  @override
  String homeQrFor(String name) {
    return 'Código QR de $name';
  }

  @override
  String get homeQrWarning =>
      'Escanéalo con otra app de autenticación para añadir allí la misma cuenta. Quien lo vea o fotografíe puede generar tus códigos, así que mantenlo en privado.';

  @override
  String homeVersionNote(Object version) {
    return 'v$version · se queda en este dispositivo';
  }

  @override
  String homeSelectName(String name) {
    return 'Seleccionar $name';
  }

  @override
  String get homeMore => 'Más';

  @override
  String get homeRecoveryCodes => 'Códigos de recuperación';

  @override
  String homeRecoveryCodesLeft(int count) {
    return 'Códigos de recuperación (quedan $count)';
  }

  @override
  String get homeShareSecurely => 'Compartir de forma segura';

  @override
  String get homeShowQr => 'Mostrar código QR';

  @override
  String get homeMoveEarlier => 'Subir';

  @override
  String get homeMoveLater => 'Bajar';

  @override
  String homeNextCodeShort(String code) {
    return 'Siguiente: $code';
  }

  @override
  String get homeNextCode => 'Siguiente código';

  @override
  String get homeFavorite => 'Favorito';

  @override
  String get homeCodeHiddenAsk =>
      'Código oculto hasta que confirmes que eres tú';

  @override
  String get homeCodeHidden => 'Código oculto';

  @override
  String homeNextCodeSpoken(String code) {
    return 'Siguiente código $code';
  }

  @override
  String homeKindTotp(int count, int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dígitos',
      one: '1 dígito',
    );
    return 'TOTP · $_temp0 · $seconds s';
  }

  @override
  String homeKindSteam(int seconds) {
    return 'Steam · 5 caracteres · $seconds s';
  }

  @override
  String homeKindHotp(int count, String counter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dígitos',
      one: '1 dígito',
    );
    return 'HOTP · $_temp0 · n.º $counter';
  }

  @override
  String get homeAccountHeading => 'Cuenta';

  @override
  String get homeHintUnselect => 'deseleccionar';

  @override
  String get homeHintSelect => 'seleccionar';

  @override
  String get homeHintCopy => 'copiar el código';

  @override
  String get homeReadCodeAloud => 'Leer el código en voz alta';

  @override
  String get homeMoreOptions => 'Más opciones';

  @override
  String get mainPairRaycastTitle => 'Vincular con Raycast';

  @override
  String get mainPairRaycastBody => 'Escribe este código en Raycast:';

  @override
  String get mainPairRaycastWarning =>
      'Hazlo solo si acabas de empezar tú la vinculación en Raycast.';

  @override
  String get mainPairAlfredTitle => 'Vincular con Alfred';

  @override
  String get mainPairAlfredBody => 'Escribe 2fa-pair y este código en Alfred:';

  @override
  String get mainPairAlfredWarning =>
      'Hazlo solo si acabas de escribir tú 2fa-pair en Alfred.';

  @override
  String get mainPairPowerToysTitle => 'Vincular con PowerToys';

  @override
  String get mainPairPowerToysBody =>
      'Escribe este código en la Paleta de comandos de PowerToys:';

  @override
  String get mainPairPowerToysWarning =>
      'Hazlo solo si acabas de empezar tú la vinculación en PowerToys.';

  @override
  String get mainPairBrowserTitle => 'Vincular con tu navegador';

  @override
  String get mainPairBrowserBody =>
      'Escribe este código en la extensión de navegador de Tanooki Auth:';

  @override
  String get mainPairBrowserWarning =>
      'Hazlo solo si acabas de hacer clic tú en \"Vincular\" en la extensión.';

  @override
  String mainSendCodeTo(String name, String client) {
    return 'Enviar el código de $name a $client';
  }

  @override
  String mainWrongPasscodeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Código incorrecto. $count intentos fallidos más lo borran todo.',
      one: 'Código incorrecto. 1 intento fallido más lo borra todo.',
    );
    return '$_temp0';
  }

  @override
  String get mainWrongPasscode => 'Código incorrecto.';

  @override
  String get mainBiometricWindows => 'Windows Hello';

  @override
  String get mainBiometricMac => 'Touch ID';

  @override
  String get mainBiometricOther => 'Face ID o huella';

  @override
  String get mainLockTitle => '¿Bloquear Tanooki Auth?';

  @override
  String get mainLockBody =>
      'Pedir tu cara, tu huella o tu código al abrir la app, para que nadie que tenga tu teléfono desbloqueado pueda leer tus códigos. Puedes cambiarlo más tarde en Ajustes.';

  @override
  String get mainTurnOnLock => 'Activar bloqueo';

  @override
  String get mainUnlockReason => 'Desbloquear Tanooki Auth';

  @override
  String get mainStartOverTitle => '¿Empezar una bóveda nueva y vacía?';

  @override
  String get mainStartOverBody =>
      'Esto reemplaza para siempre lo que quede de tus cuentas anteriores. Hazlo solo si no tienes ninguna copia que restaurar, o si ya desactivaste el inicio de sesión en dos pasos en esas webs.';

  @override
  String get mainEraseStartOver => 'Borrar y empezar de cero';

  @override
  String get mainRestoreFromBackup => 'Restaurar desde una copia';

  @override
  String get mainStartNewVault => 'Empezar una bóveda nueva y vacía';

  @override
  String get mainLocked => 'Tanooki Auth está bloqueado';

  @override
  String mainUseBiometric(String method) {
    return 'Usar $method';
  }

  @override
  String get mainUseSecurityKey => 'Usar llave de seguridad';

  @override
  String homeHidesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se oculta en $count segundos',
      one: 'Se oculta en 1 segundo',
    );
    return '$_temp0';
  }

  @override
  String homeCardsMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      'm1': 'enero',
      'm2': 'febrero',
      'm3': 'marzo',
      'm4': 'abril',
      'm5': 'mayo',
      'm6': 'junio',
      'm7': 'julio',
      'm8': 'agosto',
      'm9': 'septiembre',
      'm10': 'octubre',
      'm11': 'noviembre',
      'm12': 'diciembre',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String homeCardsDay(String month, String day) {
    return '$day de $month';
  }

  @override
  String get homeCardsDenied =>
      'Denegado. No puede abrir tus cuentas. Puede volver a pedirlo más tarde, y se te volverá a preguntar.';

  @override
  String get homeCardsClockRight =>
      'Tu reloj ya está en hora. Los códigos deberían funcionar.';

  @override
  String get homeCardsCheckAgain => 'Volver a comprobar';

  @override
  String get homeCardsYourContact => 'Tu contacto de emergencia';

  @override
  String homeCardsEmergencyWaiting(String who, String left, String day) {
    return '$who pidió acceso de emergencia a tus cuentas. Si no lo deniegas, podrá abrir una copia en $left ($day).';
  }

  @override
  String homeCardsEmergencyReleased(String who) {
    return '$who pidió acceso de emergencia y la espera de 7 días terminó, así que ya puede abrir una copia de tus cuentas. Deniégalo para impedirlo.';
  }

  @override
  String get homeCardsBackupNudge =>
      'Tus cuentas cambiaron desde tu última copia. Una copia es la forma de recuperarlas si pierdes este dispositivo.';

  @override
  String get homeCardsBackUpNow => 'Hacer copia ahora';

  @override
  String homeCardsSummaryNew(int count, String month) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tu resumen de $month: $count cuentas nuevas.',
      one: 'Tu resumen de $month: 1 cuenta nueva.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryNoBackup => 'Aún no hay copia.';

  @override
  String homeCardsSummaryLastBackup(String day) {
    return 'Última copia: $day.';
  }

  @override
  String get homeCardsSummaryAllCodes =>
      'Todas las cuentas tienen códigos de recuperación.';

  @override
  String homeCardsSummaryMissingCodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cuentas sin códigos de recuperación.',
      one: '1 cuenta sin códigos de recuperación.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryCheckupGood => 'Revisión de seguridad: todo bien.';

  @override
  String homeCardsSummaryCheckupFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Revisión de seguridad: $count cosas que arreglar.',
      one: 'Revisión de seguridad: 1 cosa que arreglar.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsOpenCheckup => 'Abrir revisión';

  @override
  String get quickPickSelf =>
      'Tanooki Auth seguía delante, así que no se escribió nada. Haz clic en el cuadro que quieres rellenar y vuelve a usar el icono de la barra de menús.';

  @override
  String quickPickTypeFailed(String reason) {
    return 'No se pudo escribir el código ($reason). Cópialo en su lugar.';
  }

  @override
  String get quickPickTypeUnavailable =>
      'Escribir códigos no está disponible en este ordenador. Cópialo en su lugar.';

  @override
  String quickPickUseCodeFor(String name) {
    return 'Usar el código de $name';
  }

  @override
  String get quickPickAllowTitle => 'Permitir que Tanooki Auth escriba';

  @override
  String get quickPickAllowBody =>
      'Para escribir un código en otra app, tu Mac tiene que dejar que Tanooki Auth pulse teclas por ti.\n\n1. Haz clic abajo en \"Abrir Ajustes del Sistema\".\n2. Verás una lista llamada Accesibilidad. Busca Tanooki Auth y activa su interruptor (azul).\n3. Si tu Mac te pide la contraseña o Touch ID, dáselos.\n4. Vuelve aquí y haz clic otra vez en Escribir.\n\nTanooki Auth solo pulsa teclas cuando haces clic en Escribir, y solo escribe el código.';

  @override
  String get quickPickOpenSystemSettings => 'Abrir Ajustes del Sistema';

  @override
  String get quickPickTitle => 'Selección rápida';

  @override
  String get quickPickSearch => 'Buscar cuentas';

  @override
  String get quickPickLinuxNote =>
      'Escribir códigos en otras apps no está disponible en Linux. Haz clic en una cuenta para copiar su código.';

  @override
  String get quickPickNoMatches => 'No hay cuentas que coincidan';

  @override
  String get quickPickAsksFirst => '••• •••  (pide confirmación)';

  @override
  String get quickPickHiddenAsks => 'Código oculto, pide confirmación';

  @override
  String get quickPickType => 'Escribir';

  @override
  String get codeViewRing => 'Anillo';

  @override
  String get codeViewBar => 'Barra';

  @override
  String get codeViewNumber => 'Número';

  @override
  String codeViewSpoken(String code) {
    return 'Código $code';
  }

  @override
  String codeViewSpokenLeft(int count, String code) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Código $code, quedan $count segundos',
      one: 'Código $code, queda 1 segundo',
    );
    return '$_temp0';
  }

  @override
  String get codeViewReadAloud => 'Leer el código en voz alta';

  @override
  String codeViewSecondsShort(int count) {
    return '$count s';
  }

  @override
  String get codeViewColorBlue => 'Azul';

  @override
  String get codeViewColorPurple => 'Morado';

  @override
  String get codeViewColorPink => 'Rosa';

  @override
  String get codeViewColorRed => 'Rojo';

  @override
  String get codeViewColorOrange => 'Naranja';

  @override
  String get codeViewColorGold => 'Dorado';

  @override
  String get codeViewColorGreen => 'Verde';

  @override
  String get codeViewColorTeal => 'Verde azulado';

  @override
  String get codeViewColorGray => 'Gris';

  @override
  String trashRestored(String name) {
    return '$name vuelve a estar en tu lista.';
  }

  @override
  String trashDeleteTitle(String name) {
    return '¿Eliminar $name para siempre?';
  }

  @override
  String get trashDeleteBody =>
      'No se puede deshacer. Antes de eliminarla, desactiva el inicio de sesión en dos pasos en esa web o asegúrate de tener sus códigos de recuperación, o podrías quedarte sin acceso.';

  @override
  String get trashDeleteForGood => 'Eliminar para siempre';

  @override
  String get trashTitle => 'Papelera';

  @override
  String get trashEmpty =>
      'La papelera está vacía.\nLas cuentas eliminadas se quedan aquí 30 días.';

  @override
  String get trashNote =>
      'Las cuentas eliminadas se quedan aquí 30 días y luego se borran para siempre.';

  @override
  String get trashRemovedNextOpen =>
      'Se borrará la próxima vez que abras la app';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Quedan $count días',
      one: 'Queda 1 día',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => 'Restaurar';

  @override
  String get recoveryAddTitle => 'Añadir códigos de recuperación';

  @override
  String get recoveryPasteHint =>
      'Pega los códigos que te dio la web, uno por línea';

  @override
  String get recoveryNoneNew =>
      'No se encontraron códigos nuevos en lo que pegaste.';

  @override
  String recoveryAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se añadieron $count códigos.',
      one: 'Se añadió 1 código.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryCopiedUsed =>
      'Copiado. Ojo: marcaste este código como usado, así que probablemente ya no funcione.';

  @override
  String get recoveryCopied =>
      'Copiado. El portapapeles se borra en 30 segundos. Márcalo como usado cuando hayas entrado.';

  @override
  String get recoveryRemoveTitle => '¿Quitar este código?';

  @override
  String recoveryRemoveBody(String code) {
    return '$code\n\nQuítalo solo si la web ya no lo acepta.';
  }

  @override
  String recoveryTitle(String name) {
    return 'Códigos de recuperación de $name';
  }

  @override
  String get recoveryAddCodes => 'Añadir códigos';

  @override
  String get recoveryIntro =>
      'Cuando activas el inicio de sesión en dos pasos, la mayoría de webs también te dan una lista de códigos de respaldo. Cada uno te deja entrar una vez si alguna vez pierdes esta app. Pégalos aquí para guardarlos a salvo con la cuenta.';

  @override
  String recoveryUnusedOf(String unused, int total) {
    return '$unused de $total sin usar. Toca un código para copiarlo y márcalo cuando lo hayas usado.';
  }

  @override
  String get recoveryUsed => 'Usado';

  @override
  String get detailsEditAccount => 'Editar cuenta';

  @override
  String get detailsCopyCode => 'Copiar código';

  @override
  String get detailsReadAloud => 'Leer en voz alta';

  @override
  String get detailsFolderAndTags => 'Carpeta y etiquetas';

  @override
  String get detailsWebsites => 'Webs';

  @override
  String get detailsNotes => 'Notas';

  @override
  String get detailsNotesHidden => 'Oculto hasta que confirmes que eres tú.';

  @override
  String get detailsNoNotes => 'Sin notas. Añade alguna con Editar.';

  @override
  String get accountSortCustom => 'Personalizado (arrastra para ordenar)';

  @override
  String get accountSortRecent => 'Usadas recientemente';

  @override
  String get accountSortName => 'De la A a la Z';

  @override
  String get activityCopied => 'Copiado';

  @override
  String get activityFilled => 'Rellenado';

  @override
  String get activityTyped => 'Escrito';

  @override
  String get activityShownQr => 'Código QR mostrado';

  @override
  String get activityExported => 'Exportado';

  @override
  String totpBadCharacter(String char) {
    return 'No es un secreto base32 válido (carácter incorrecto \"$char\")';
  }

  @override
  String get totpEmpty => 'El secreto está vacío';

  @override
  String get vaultFileMissing =>
      'Falta el archivo de tus cuentas. Si tienes una copia, restáurala. Si no, puedes empezar una bóveda nueva y vacía.';

  @override
  String get vaultKeyMissing =>
      'Falta en el almacenamiento seguro de este dispositivo la clave que desbloquea tus cuentas. Restaura una copia para recuperarlas.';

  @override
  String get vaultDecryptFailed =>
      'No se pudo desbloquear el archivo de tus cuentas. Puede estar dañado o haberse cambiado fuera de la app. Restaura una copia.';

  @override
  String get vaultBadJson =>
      'El archivo de tus cuentas se desbloqueó, pero su contenido está dañado. Restaura una copia.';

  @override
  String clockCheckBadAnswer(String status) {
    return 'El servidor de hora envió una respuesta que la app no entiende (HTTP $status).';
  }

  @override
  String clockCheckOff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'El reloj de tu dispositivo va desfasado más o menos $count minutos, así que los códigos no funcionarán. Activa la hora automática en Ajustes.',
      one: 'El reloj de tu dispositivo va desfasado más o menos 1 minuto, así que los códigos no funcionarán. Activa la hora automática en Ajustes.',
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
