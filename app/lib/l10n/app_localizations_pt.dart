// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRemove => 'Remover';

  @override
  String get commonUnlock => 'Desbloquear';

  @override
  String get commonTurnOff => 'Desativar';

  @override
  String get commonNotNow => 'Agora não';

  @override
  String get commonNext => 'Próximo';

  @override
  String get commonDone => 'Pronto';

  @override
  String get commonDeny => 'Negar';

  @override
  String get commonAllow => 'Permitir';

  @override
  String get commonTryAgain => 'Tentar de novo';

  @override
  String get commonStop => 'Parar';

  @override
  String get commonShare => 'Compartilhar';

  @override
  String get commonOpen => 'Abrir';

  @override
  String get commonCopy => 'Copiar';

  @override
  String get commonContinueLabel => 'Continuar';

  @override
  String get commonClear => 'Limpar';

  @override
  String get commonBack => 'Voltar';

  @override
  String get commonAdd => 'Adicionar';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonDelete => 'Apagar';

  @override
  String get commonClose => 'Fechar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonYes => 'Sim';

  @override
  String get commonNo => 'Não';

  @override
  String get commonSeePremium => 'Ver o Premium';

  @override
  String get commonPremiumBadge => 'Premium';

  @override
  String get commonAppName => 'Tanooki Auth';

  @override
  String get googleMigrationUnreadable =>
      'Não foi possível ler esse código do Google Authenticator.';

  @override
  String get googleMigrationDamaged =>
      'Esse código do Google Authenticator está danificado.';

  @override
  String get googleMigrationEmpty =>
      'Esse código do Google Authenticator não tem nenhuma conta.';

  @override
  String get googleMigrationNoSecret =>
      'Uma conta nesse código não tem chave secreta.';

  @override
  String get googleMigrationMd5 =>
      'Uma conta nesse código usa MD5, que o Tanooki Auth não suporta.';

  @override
  String get googleCantTakeSteam => 'códigos Steam';

  @override
  String googleCantTakeDigits(int digits) {
    return 'códigos de $digits dígitos';
  }

  @override
  String googleCantTakePeriod(int seconds) {
    return 'códigos que mudam a cada $seconds segundos';
  }

  @override
  String get otpauthNotALink => 'Isso não é um link otpauth://.';

  @override
  String get otpauthNoSecret => 'O link não tem chave secreta.';

  @override
  String otpauthUnsupportedType(String type) {
    return 'Tipo de código não suportado: \"$type\".';
  }

  @override
  String otpauthUnsupportedAlgorithm(String algorithm) {
    return 'Algoritmo não suportado: \"$algorithm\".';
  }

  @override
  String get otpauthBadDigits => 'Os dígitos precisam ser 6, 7 ou 8.';

  @override
  String get otpauthBadPeriod => 'O período precisa ser um número positivo.';

  @override
  String get otpauthBadCounter => 'O contador precisa ser zero ou mais.';

  @override
  String get phoneLinkNotAPairingCode =>
      'Isso não é um código de pareamento de navegador do Tanooki Auth.';

  @override
  String phoneLinkNotSavedFor(String host) {
    return 'Essa conta não está salva para $host.';
  }

  @override
  String get phoneLinkPushNotSetUp =>
      'As notificações ainda não estão configuradas no servidor do Tanooki Auth, então os pedidos só aparecem com o app aberto.';

  @override
  String phoneLinkPushFailed(int status) {
    return 'Não foi possível ativar as notificações (HTTP $status).';
  }

  @override
  String get qrImageNotAPicture =>
      'Esse arquivo não é uma imagem que este app consegue ler.';

  @override
  String get qrImageNoQr => 'Nenhum código QR encontrado nessa imagem.';

  @override
  String relayBadAnswer(int status) {
    return 'O servidor de sincronização mandou uma resposta que o app não entende (HTTP $status).';
  }

  @override
  String get relayUnreachable =>
      'Não foi possível acessar o servidor de sincronização. Verifique sua conexão com a internet.';

  @override
  String get relayTimeout =>
      'O servidor de sincronização não respondeu a tempo. Verifique sua conexão com a internet.';

  @override
  String get relayInsecure =>
      'Não foi possível criar uma conexão segura com o servidor de sincronização.';

  @override
  String relaySaidNo(int status) {
    return 'O servidor de sincronização recusou (HTTP $status).';
  }

  @override
  String get shareNotAShare =>
      'Isso não é uma conta compartilhada do Tanooki Auth.';

  @override
  String get shareExpired =>
      'Este compartilhamento expirou (eles só duram 24 horas). Peça um novo.';

  @override
  String get shareWrongCode =>
      'Código errado, ou o compartilhamento está danificado. Confira os 6 dígitos e tente de novo.';

  @override
  String get storeServerUnreachable =>
      'Não foi possível acessar o servidor do Tanooki Auth. Verifique sua conexão com a internet e tente de novo.';

  @override
  String get storeBadKey =>
      'O servidor mandou uma chave de licença que este app não aceita.';

  @override
  String storeReportedProblem(String problem) {
    return 'A loja informou um problema: $problem';
  }

  @override
  String get storeGooglePlayUnavailable =>
      'O Google Play não está disponível neste aparelho, então não dá para comprar o Premium aqui. Se você comprou o Premium em outro lugar, digite sua chave de licença abaixo.';

  @override
  String get storeAppStoreUnavailable =>
      'A App Store não está disponível agora. Verifique sua conexão com a internet e tente de novo.';

  @override
  String storeNotListed(String store) {
    return 'A $store não mostrou o Premium agora. Tente de novo daqui a pouco.';
  }

  @override
  String storeNotListedWithError(String store, String problem) {
    return 'A $store não mostrou o Premium agora ($problem). Tente de novo daqui a pouco.';
  }

  @override
  String storePricesFailed(String problem) {
    return 'Não foi possível carregar os preços da loja: $problem';
  }

  @override
  String storePurchaseCouldNotStart(String problem) {
    return 'Não foi possível iniciar a compra: $problem';
  }

  @override
  String storeNothingToRestore(String store) {
    return 'Nenhuma compra do Premium foi encontrada nesta conta da $store.';
  }

  @override
  String storeRestoreFailed(String problem) {
    return 'Não foi possível restaurar as compras: $problem';
  }

  @override
  String get storePending =>
      'Aguardando a aprovação do pagamento. O Premium é liberado assim que for aprovado.';

  @override
  String get storeCanceled => 'Compra cancelada. Nada foi cobrado.';

  @override
  String storeFailed(String problem) {
    return 'A compra não foi concluída: $problem. Nada foi cobrado.';
  }

  @override
  String get storeFailedNoReason =>
      'A compra não foi concluída: a loja não deu um motivo. Nada foi cobrado.';

  @override
  String get storeUnlocked => 'Premium liberado. Muito obrigada!';

  @override
  String get storeUnlockedWithKey =>
      'Premium liberado. Sua chave de licença para os seus computadores está abaixo.';

  @override
  String storeUnlockedKeyFailed(String problem) {
    return 'O Premium está liberado neste aparelho. Ainda não foi possível criar a chave para os seus computadores: $problem Toque em Restaurar compras mais tarde para tentar de novo.';
  }

  @override
  String storeServerSaidNo(int status) {
    return 'O servidor recusou (HTTP $status).';
  }

  @override
  String get syncGroupExists =>
      'Já existe um grupo de sincronização com essa frase secreta. Em um aparelho que já está sincronizando, toque em \"Adicionar um aparelho\" e escaneie o código dele.';

  @override
  String get syncNotASyncCode =>
      'Isso não é um código de sincronização do Tanooki Auth. Em um aparelho que já está sincronizando, abra Ajustes, Sincronização, Adicionar um aparelho.';

  @override
  String get syncWrongPassphrase =>
      'Essa frase secreta não é a mesma que seus outros aparelhos usam. Confira e tente de novo.';

  @override
  String get syncICloudOtherPassphrase =>
      'Seus outros aparelhos Apple sincronizam com outra frase secreta. Digite essa, ou comece do zero com esta.';

  @override
  String get syncErrorRemoved =>
      'Este aparelho foi removido da sincronização em outro aparelho. Desative a sincronização e ative de novo para voltar.';

  @override
  String get syncErrorTurnedOff =>
      'A sincronização foi desativada em outro aparelho. Desative aqui também e ative de novo para recomeçar.';

  @override
  String get syncErrorTooOften =>
      'Sincronizando com frequência demais. Vai tentar de novo em alguns minutos.';

  @override
  String get syncErrorLimit =>
      'Você chegou ao limite de sincronização (2.000 contas, incluindo as apagadas).';

  @override
  String syncErrorICloud(String problem) {
    return 'O iCloud Drive teve um problema: $problem.';
  }

  @override
  String syncErrorUnexpected(String problem) {
    return 'A sincronização parou por causa de um problema inesperado: $problem';
  }

  @override
  String get syncICloudAppleOnly =>
      'O iCloud só funciona no iPhone, iPad e Mac.';

  @override
  String get syncICloudSignedOut =>
      'O iCloud Drive está desativado neste aparelho. Entre no iCloud e ative o iCloud Drive nos Ajustes para usá-lo.';

  @override
  String get syncICloudNotInBuild =>
      'A sincronização pelo iCloud ainda não está ativada nesta versão do Tanooki Auth. Use o relay do Tanooki por enquanto; ele funciona em todos os aparelhos.';

  @override
  String get teamKeyUnopenable =>
      'Não foi possível abrir a chave da equipe enviada para este aparelho. Peça ao admin da equipe para remover este aparelho e convidá-lo de novo.';

  @override
  String get teamNotAnInvite =>
      'Isso não é um convite de equipe do Tanooki Auth. Peça ao admin da equipe um novo link ou código QR de convite.';

  @override
  String get teamNotInTeam => 'Este aparelho não está em uma equipe.';

  @override
  String get teamDeletedByAdmin => 'Esta equipe foi apagada pelo admin.';

  @override
  String get teamDeviceRemoved => 'Este aparelho foi removido da equipe.';

  @override
  String get teamAlreadyInTeam => 'Este aparelho já está em uma equipe.';

  @override
  String get teamNotALicense =>
      'Isso não é uma licença de equipe. Ela começa com TT1. e vem da página que o Stripe mostra depois que você assina.';

  @override
  String get teamAlreadyInTeamLeaveFirst =>
      'Este aparelho já está em uma equipe. Saia dela primeiro.';

  @override
  String get teamGone =>
      'Essa equipe não existe mais. Peça ao admin da equipe um novo convite.';

  @override
  String get teamInviteUsed =>
      'Esse convite já foi usado ou expirou (eles duram 7 dias e funcionam uma vez). Peça um novo ao admin da equipe.';

  @override
  String get teamFull =>
      'Essa equipe está cheia (10 pessoas). O admin precisa remover alguém primeiro.';

  @override
  String get aboutTitle => 'Sobre a Maddie';

  @override
  String get aboutP1 =>
      'Eu sou a Maddie, uma desenvolvedora autista que se importa, talvez um pouco demais, em acertar os pequenos detalhes.';

  @override
  String get aboutP2 =>
      'Eu acredito muito em privacidade. As chaves que protegem suas contas são dos dados mais pessoais que existem, então o Tanooki Auth as mantém criptografadas no seu próprio aparelho. Sem cadastro, sem anúncios, sem rastreamento, e nada é enviado para mim.';

  @override
  String get aboutP3 =>
      'O Tanooki Auth é gratuito, e eu quero que continue assim. É o seu apoio que me permite continuar fazendo apps de privacidade gratuitos como este. Se o Tanooki Auth combina com você, os outros também podem combinar — eles estão em madilynthomas.com.';

  @override
  String get aboutP4 =>
      'Então, de mim para você: obrigada. Você não está só usando um app — está tornando possível todo esse jeito de viver.';

  @override
  String get aboutSupportAddress =>
      'Apoie meu trabalho: tanookistudios.com/support';

  @override
  String get aboutSupport => 'Apoie meu trabalho';

  @override
  String get aboutCredits => 'Créditos';

  @override
  String get aboutCreditsBody =>
      'Os códigos QR são lidos com jsQR (Apache 2.0) na extensão do navegador e com ZXing no app. Sem vínculo com Google, Twilio ou Authy; Google Authenticator é uma marca registrada da Google LLC.';

  @override
  String get addFromBrowserOne => 'Adicionar do seu navegador?';

  @override
  String addFromBrowserMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Adicionar $count contas do seu navegador?',
      one: 'Adicionar 1 conta do seu navegador?',
    );
    return '$_temp0';
  }

  @override
  String get addFromGoogleTransfer =>
      'De um código de transferência do Google Authenticator:';

  @override
  String addCount(int count) {
    return 'Adicionar $count';
  }

  @override
  String get addNoColor => 'Sem cor';

  @override
  String addColorName(String name) {
    return 'Cor $name';
  }

  @override
  String get addServiceLabel => 'Serviço (ex.: GitHub)';

  @override
  String get addAccountLabel => 'Conta (ex.: seu e-mail)';

  @override
  String get addWebsiteLabel => 'Site (opcional)';

  @override
  String get addWebsiteHelp =>
      'ex.: github.com. A extensão do navegador só preenche códigos aqui.';

  @override
  String get addTagsLabel => 'Etiquetas (opcional)';

  @override
  String get addTagsHelp => 'ex.: trabalho, jogos. Separe com vírgulas.';

  @override
  String get addFolderLabel => 'Pasta (opcional)';

  @override
  String get addFolderHelp =>
      'ex.: Trabalho. Deixe em branco para nenhuma pasta.';

  @override
  String get addPickFolder => 'Escolha uma pasta';

  @override
  String get addNoFolder => 'Nenhuma pasta';

  @override
  String get addNotesLabel => 'Notas (opcional)';

  @override
  String get addColorLabel => 'Cor (opcional)';

  @override
  String get addEmojiLabel => 'Emoji (opcional)';

  @override
  String get addEmojiHelp =>
      'Aparece no lugar do logo, aqui, nos widgets e no relógio.';

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
      'O código fica escondido na lista, e os widgets, o relógio e a Escolha rápida nunca o mostram.';

  @override
  String get addTravelHide => 'Esconder no modo viagem';

  @override
  String get addTravelHidePremium => 'Esconder no modo viagem (Premium)';

  @override
  String get addTravelHideHelp =>
      'Quando o modo viagem está ativado (Ajustes), esta conta some do app até você desativá-lo.';

  @override
  String get addTravelNeedsPremium =>
      'O modo viagem faz parte do Premium. Obtenha em Ajustes > Obter o Premium.';

  @override
  String get addAdvanced => 'Avançado';

  @override
  String get addAdvancedExisting =>
      'Só mude isto se o site pediu. Configurações erradas geram códigos errados, e o site vai recusá-los.';

  @override
  String get addAdvancedNew =>
      'A maioria dos sites usa as configurações normais. Só mude isto se o site pediu.';

  @override
  String get addType => 'Tipo';

  @override
  String get addTypeTotp => 'Por tempo (normal)';

  @override
  String get addTypeHotp => 'Por contador (novo código quando você pede)';

  @override
  String get addDigits => 'Dígitos';

  @override
  String get addAlgorithm => 'Algoritmo';

  @override
  String get addSha1Normal => 'SHA-1 (normal)';

  @override
  String get addPeriod => 'Novo código a cada';

  @override
  String addSeconds(int seconds) {
    return '$seconds segundos';
  }

  @override
  String get addCounter => 'Contador';

  @override
  String get addCounterHelp => 'Quantos códigos já foram usados até agora';

  @override
  String get addNotASharedFile =>
      'Esse arquivo não é uma conta compartilhada do Tanooki Auth. Peça para a pessoa compartilhar de novo.';

  @override
  String addAlreadyInList(String name) {
    return '$name já está na sua lista.';
  }

  @override
  String get addThisAccount => 'Adicionar esta conta?';

  @override
  String get addNoCameraWindows =>
      'O Windows não consegue usar uma câmera no Tanooki Auth. Abra uma imagem do código QR ou cole o link de configuração.';

  @override
  String get addFromGoogle => 'Trazer do Google Authenticator';

  @override
  String get addFromGoogleSteps =>
      'No aparelho com o Google Authenticator:\n\n1. Abra o Google Authenticator.\n2. Toque no menu (☰ ou ⋮), depois em \"Transferir contas\" e em \"Exportar contas\".\n3. Escolha as contas e toque em Avançar. Ele mostra um código QR.\n\nDepois escaneie esse código QR aqui. Se ele mostrar vários códigos QR, escaneie cada um.';

  @override
  String get addScan => 'Escanear';

  @override
  String get addOpenPicture => 'Abrir imagem';

  @override
  String get addLookingOnScreen => 'Procurando um código QR na sua tela…';

  @override
  String get addScreenNoQr =>
      'Nenhum código QR encontrado na sua tela. Confira se o código inteiro está visível e não está coberto por outra janela, e tente de novo.';

  @override
  String get addScreenUnsupported =>
      'Escanear a tela precisa do macOS 14 (Sonoma) ou mais novo. Tire uma captura de tela e use \"Abrir uma imagem\".';

  @override
  String get addScreenFailed =>
      'Não foi possível capturar a tela. Tire uma captura de tela e use \"Abrir uma imagem\".';

  @override
  String get addScreenWrongQr =>
      'Encontramos um código QR na sua tela, mas ele não é um código de configuração de dois fatores.';

  @override
  String get addScreenPermissionTitle => 'Deixe o Tanooki Auth ver sua tela';

  @override
  String get addScreenPermissionSteps =>
      'Para ler um código QR na sua tela, o Mac precisa deixar o Tanooki Auth capturar a tela. O Tanooki Auth só olha quando você aperta \"Escanear minha tela\", e a imagem nunca sai deste Mac.\n\n1. Abra os Ajustes do Sistema (o ícone de engrenagem no Dock, ou menu Apple > Ajustes do Sistema).\n2. Clique em \"Privacidade e Segurança\" na coluna da esquerda.\n3. Clique em \"Gravação de Tela e Áudio do Sistema\".\n4. Ative a chave ao lado do Tanooki Auth. Se ele não estiver na lista, clique em +, escolha o Tanooki Auth em Aplicativos e ative.\n5. O Mac vai pedir para encerrar o Tanooki Auth. Clique em \"Encerrar e Reabrir\" e depois aperte \"Escanear minha tela\" de novo.';

  @override
  String get addPasteLinksTitle => 'Colar links de configuração';

  @override
  String get addPasteLinksHint =>
      'otpauth://totp/...\nUm link por linha. Você pode colar vários de uma vez.';

  @override
  String addManyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Adicionar $count contas?',
      one: 'Adicionar 1 conta?',
    );
    return '$_temp0';
  }

  @override
  String addManyBadLines(int count) {
    return '$count linha(s) não pode(m) ser usada(s); você vai ver quais depois.';
  }

  @override
  String get addEnterKey => 'Digitar chave de configuração';

  @override
  String get addSetupKey => 'Chave de configuração';

  @override
  String get addSetupKeyHelp => 'As letras e números que o site mostra';

  @override
  String get addBadKey =>
      'Essa chave de configuração não é válida. Ela só deve ter letras de A a Z e números de 2 a 7.';

  @override
  String get addTitle => 'Adicionar conta';

  @override
  String get addScanQr => 'Escanear código QR';

  @override
  String get addScanQrHelp => 'Aponte a câmera para o código que o site mostra';

  @override
  String addNoCameraOn(String platform) {
    return 'Sem suporte a câmera no $platform';
  }

  @override
  String get addScanScreen => 'Escanear minha tela';

  @override
  String get addScanScreenHelp =>
      'Lê um código QR que aparece em qualquer lugar da sua tela';

  @override
  String get addScanScreenLinux =>
      'Ainda não disponível no Linux. Abra uma captura de tela do código QR.';

  @override
  String get addFromPhotos => 'Escanear um código QR das suas fotos';

  @override
  String get addFromPicture => 'Abrir uma imagem de um código QR';

  @override
  String get addFromPhotosHelp =>
      'Escolha uma captura de tela da página de configuração';

  @override
  String get addFromPictureHelp =>
      'Uma captura de tela da página de configuração funciona';

  @override
  String get addPasteLink => 'Colar link de configuração';

  @override
  String get addPasteLinkHelp =>
      'Links que começam com otpauth://, um ou vários';

  @override
  String get addOpenShared => 'Abrir uma conta compartilhada';

  @override
  String addOpenSharedHelp(String extension) {
    return 'Um arquivo .$extension que alguém te mandou';
  }

  @override
  String get addFromGoogleHelp => 'Traga todas as suas contas de uma vez';

  @override
  String get addFromOtherApp => 'Trazer de outro app';

  @override
  String get addFromOtherAppHelp =>
      'Aegis, 2FAS, Authy, Bitwarden, 1Password, Senhas da Apple, Microsoft';

  @override
  String get addEnterKeyHelp =>
      'Digite a chave que aparece em \"não consegue escanear o código?\"';

  @override
  String get addWrongQr =>
      'Esse código QR não é um código de configuração de dois fatores.';

  @override
  String get addCameraDenied =>
      'O Tanooki Auth não tem permissão para usar a câmera. Ative o acesso à câmera para o Tanooki Auth nos Ajustes do aparelho, ou volte e use uma imagem ou a chave de configuração.';

  @override
  String addCameraFailed(String problem) {
    return 'A câmera não conseguiu iniciar ($problem). Volte e use uma imagem ou a chave de configuração.';
  }

  @override
  String get helpNew030a =>
      'Guias passo a passo para ativar a 2FA em 40 sites populares. Quando você adiciona ou edita uma conta que tem guia, aparece um link para ele.';

  @override
  String get helpNew030b =>
      'Um tour rápido de boas-vindas na primeira vez que você abre o app. Veja de novo em Ajustes > Ajuda.';

  @override
  String get helpNew030c =>
      'Envie sua opinião em Ajustes > Ajuda. Ela nunca inclui suas contas ou códigos.';

  @override
  String get helpNew030d => 'Esta página de Novidades.';

  @override
  String get helpNew030e =>
      'Importe das Senhas da Apple e leve suas contas para o Aegis, 2FAS ou Google Authenticator.';

  @override
  String get helpNew030f =>
      'Códigos do Steam Guard, códigos por contador com um botão \"Próximo código\", e configurações avançadas de código com prévia ao vivo.';

  @override
  String get helpNew030g =>
      'Pastas, seleção de várias contas de uma vez, ordem de A a Z ou por uso recente, e \"Arrumar nomes das contas\".';

  @override
  String get helpNew030h =>
      'Mostre o código QR de uma conta (depois do Face ID ou do seu código de acesso) para levá-la para outro aparelho.';

  @override
  String get helpNew030i =>
      'Desbloqueie com uma chave de segurança como a YubiKey (Premium), em iPhones, Macs e PCs com Windows mais novos.';

  @override
  String get helpNew030j =>
      'Contas \"Perguntar antes\", que pedem Face ID ou seu código de acesso antes de mostrar o código, e o modo viagem para esconder as contas que você escolher (Premium).';

  @override
  String get helpNew030k =>
      'Histórico de atividade (Premium), verificação do relógio em \"Os códigos não funcionam?\", Testar um backup, bloqueio ao dormir e lembretes de backup.';

  @override
  String get helpNew030l =>
      'Acesso de emergência: deixe alguém de confiança pedir suas contas, com dias para você dizer não.';

  @override
  String get helpNew030m =>
      'Busca do Spotlight, uma Atividade ao Vivo do código copiado e uma complicação no mostrador do relógio (Premium), Copiar ao abrir e \"Limpar depois de colar uma vez\" no Mac.';

  @override
  String get helpNew030n =>
      'Estilos de contagem regressiva, uma cor ou emoji para cada conta, Ler em voz alta, uma fonte fácil de ler e melhor suporte a leitores de tela.';

  @override
  String get helpNew030o =>
      'Um layout largo para janelas grandes, e ícones Premium sazonais.';

  @override
  String get helpNew030p =>
      'Compre o Premium dentro do app no iPhone e no Android, dê de presente e convide amigos.';

  @override
  String get helpNew030q =>
      'Cofre da equipe para compartilhar códigos com até 10 pessoas. O plano de equipe em si chega em breve.';

  @override
  String get helpNew030r => 'O plano Família chega em breve.';

  @override
  String get helpNew030s =>
      'O app para computador agora roda no Linux também. Os downloads para Linux chegam em breve.';

  @override
  String get helpNew020a =>
      'Sincronização entre seus aparelhos, link com o celular para a extensão do navegador e compartilhamento seguro de uma conta.';

  @override
  String get helpNew020b =>
      'Código de acesso, bloqueio automático, apagamento de emergência, código de acesso falso, bloqueio de capturas de tela, verificação e alertas de vazamento.';

  @override
  String get helpNew020c =>
      'Widgets, apps para Apple Watch e Wear OS, a barra de menus do Mac e a bandeja do Windows, e backups criptografados automáticos (Premium).';

  @override
  String get helpNew020d =>
      'Importação do Aegis, 2FAS, Authy, Bitwarden e 1Password, além de favoritos, etiquetas, notas, códigos de recuperação e Lixeira.';

  @override
  String get helpNew010a =>
      'A primeira versão: escanear ou colar contas, ver códigos, backups criptografados e a extensão do navegador.';

  @override
  String helpNoBrowser(String url) {
    return 'Não foi possível abrir seu navegador. A página é $url';
  }

  @override
  String helpGuideFor(String name) {
    return 'Como ativar a 2FA no $name';
  }

  @override
  String get helpTourWelcome => 'Boas-vindas ao Tanooki Auth';

  @override
  String get helpTourWelcomeBody =>
      'Muitos sites podem pedir um código de 6 dígitos além da sua senha. Isso é a autenticação de dois fatores, ou 2FA. O Tanooki Auth cria esses códigos para você, aqui mesmo no seu aparelho, então quem tiver só a sua senha ainda não consegue entrar.';

  @override
  String get helpTourAdd => 'Adicione sua primeira conta';

  @override
  String get helpTourAddBody =>
      'Ative a 2FA nos ajustes de segurança de um site. Ele mostra um código QR: escaneie aqui, ou copie o link de configuração e cole. Já usa outro app autenticador? Traga suas contas de uma vez só.';

  @override
  String get helpTourScanOrPaste => 'Escanear um código QR ou colar um link';

  @override
  String get helpTourImport => 'Importar de outro app';

  @override
  String get helpTourPopular => 'Sites populares para proteger primeiro';

  @override
  String get helpTourPopularBody =>
      'Seu e-mail, suas redes sociais e qualquer lugar com o seu dinheiro são os mais importantes. Nossos guias passo a passo mostram onde fica a opção de 2FA em cada site.';

  @override
  String get helpAllGuides => 'Todos os guias de 2FA';

  @override
  String helpTourStep(int step, int total) {
    return 'Passo $step de $total';
  }

  @override
  String get helpTourSkip => 'Pular tour';

  @override
  String get helpWhatsNew => 'Novidades';

  @override
  String helpVersion(String version) {
    return 'Versão $version';
  }

  @override
  String helpVersionThis(String version) {
    return 'Versão $version (esta versão)';
  }

  @override
  String get helpFeedbackEmpty => 'Digite uma mensagem primeiro.';

  @override
  String get helpFeedbackSent =>
      'Enviado. Obrigada! A Maddie lê todas as mensagens.';

  @override
  String get helpFeedbackTooLong =>
      'Está longo demais para enviar. Deixe mais curto (umas 4.000 letras no máximo).';

  @override
  String get helpFeedbackTooMany =>
      'Você mandou muitas opiniões na última hora. Tente de novo daqui a uma hora.';

  @override
  String get helpFeedbackOffline =>
      'Não foi possível acessar a internet. Verifique sua conexão e tente de novo. Sua mensagem continua aqui.';

  @override
  String get helpFeedbackServerError =>
      'O servidor de opiniões teve um problema e não recebeu sua mensagem. Tente de novo mais tarde. Sua mensagem continua aqui.';

  @override
  String get helpFeedbackTitle => 'Enviar opinião';

  @override
  String get helpFeedbackIntro =>
      'Achou um bug, ou queria que o app fizesse algo? Conte para a Maddie aqui.';

  @override
  String get helpFeedbackMessage => 'Sua mensagem';

  @override
  String get helpFeedbackEmail => 'Seu e-mail (opcional)';

  @override
  String get helpFeedbackEmailHelp => 'Só se você quiser uma resposta.';

  @override
  String get helpFeedbackDevice => 'Incluir versão do app e tipo de aparelho';

  @override
  String get helpFeedbackDeviceHelp =>
      'Por exemplo \"0.3.0\" e \"iOS\". Ajuda a encontrar bugs.';

  @override
  String get helpFeedbackNeverSent =>
      'Nunca enviados: suas contas, os nomes delas, códigos, chaves de configuração, etiquetas, notas ou qualquer outra coisa do app.';

  @override
  String get helpFeedbackSend => 'Enviar';

  @override
  String get phoneUiPushAndroid =>
      'As notificações no Android ainda não estão configuradas, então os pedidos aparecem com o Tanooki Auth aberto.';

  @override
  String get phoneUiPushThisDevice =>
      'Este aparelho recebe pedidos com o Tanooki Auth aberto.';

  @override
  String get phoneUiPushNoToken =>
      'O iPhone não deu ao app um token de notificação.';

  @override
  String get phoneUiPushDenied =>
      'As notificações estão desativadas para o Tanooki Auth. Ative nos Ajustes do iPhone, em Notificações, para receber pedidos com o app fechado.';

  @override
  String phoneUiPushFailed(String problem) {
    return 'Não foi possível ativar as notificações: $problem. Os pedidos continuam aparecendo com o Tanooki Auth aberto.';
  }

  @override
  String get phoneUiPushNotInBuild =>
      'As notificações não estão disponíveis nesta versão. Os pedidos aparecem com o Tanooki Auth aberto.';

  @override
  String get phoneUiPushChecking => 'Verificando se as notificações funcionam…';

  @override
  String get phoneUiRequest => 'Pedido de código de login';

  @override
  String get phoneUiNoAccount =>
      'Nenhuma conta está salva para este site, então não há nada para enviar. Se você esperava uma, pode ser um site falso se passando por um verdadeiro.';

  @override
  String get phoneUiWantsCode =>
      'Seu navegador pareado quer o código deste site. Só aprove se você estiver entrando agora.';

  @override
  String get phoneUiApprove => 'Aprovar';

  @override
  String phoneUiApproveAccount(String name) {
    return 'Aprovar: $name';
  }

  @override
  String get phoneUiScanTitle => 'Escaneie o código do navegador';

  @override
  String get phoneUiScanWrong =>
      'Isso não é um código de pareamento de navegador. No navegador, clique na extensão do Tanooki Auth e depois em \"Usar meu celular\".';

  @override
  String get phoneUiPasteTitle => 'Cole o link de pareamento';

  @override
  String get phoneUiPair => 'Parear';

  @override
  String get phoneUiPaired =>
      'Pareado. Quando aquele navegador pedir um código, você vai ver aqui.';

  @override
  String get phoneUiExpired =>
      'Esse código expirou. No navegador, crie um novo e escaneie de novo.';

  @override
  String get phoneUiPremium =>
      'Usar o celular com um navegador faz parte do Premium';

  @override
  String get phoneUiIntro =>
      'Preencha códigos em um navegador de qualquer computador, mesmo um sem o app Tanooki Auth. A extensão do navegador pede, e você toca em Aprovar aqui. Os códigos viajam com criptografia de ponta a ponta, e só para o site em que cada conta está salva.';

  @override
  String get phoneUiPairBrowser => 'Parear um navegador';

  @override
  String get phoneUiPairHelp =>
      'No navegador, clique na extensão do Tanooki Auth e depois em \"Usar meu celular\" para mostrar o código.';

  @override
  String get phoneUiPairedBrowsers => 'Navegadores pareados';

  @override
  String get phoneUiNoneYet => 'Nenhum ainda';

  @override
  String get phoneUiBrowser => 'Navegador';

  @override
  String phoneUiPairedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Pareado em $dateString';
  }

  @override
  String get phoneUiUnpair => 'Desparear';

  @override
  String get phoneUiPushOn => 'Notificações ativadas';

  @override
  String get phoneUiPushOff => 'Os pedidos aparecem com o app aberto';

  @override
  String get phoneUiPushOnHelp =>
      'Você vai receber uma notificação para cada pedido, mesmo com o Tanooki Auth fechado.';

  @override
  String phoneUiSendCodeFor(String name) {
    return 'Enviar o código de $name';
  }

  @override
  String get phoneUiActivityWhere => 'Navegador, por este celular';

  @override
  String get premiumFiveOnce => 'US\$ 5 uma vez';

  @override
  String get premiumPayOnce => 'Pague uma vez';

  @override
  String get premiumCheckoutSoon =>
      'O pagamento ainda não está aberto; chega muito em breve. Obrigada por querer apoiar o Tanooki Auth!';

  @override
  String get premiumEnterKeyTitle => 'Digitar chave de licença';

  @override
  String get premiumEnterKeyHint => 'TA1.…  (do seu e-mail de compra)';

  @override
  String get premiumBadKey =>
      'Essa chave de licença não é válida. Copie a chave inteira do seu e-mail de compra e tente de novo.';

  @override
  String premiumInvitesNowFamily(int count) {
    return '$count amigos compraram o Premium com seu link, então sua chave agora é uma chave Família para até 5 pessoas. Ela já está instalada neste aparelho. Copie a nova chave abaixo e digite nos seus outros aparelhos também.';
  }

  @override
  String premiumInvitesAlreadyFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count amigos compraram o Premium com seu link. Sua chave já é uma chave Família.',
      one: '1 amigo comprou o Premium com seu link. Sua chave já é uma chave Família.',
    );
    return '$_temp0';
  }

  @override
  String premiumInvitesProgress(int count, int needed, int left) {
    return '$count de $needed amigos compraram o Premium com seu link. Faltam $left e sua chave vira uma chave Família.';
  }

  @override
  String get premiumInviteLinkCopied => 'Link de convite copiado.';

  @override
  String get premiumKeyCopied => 'Chave de licença copiada.';

  @override
  String premiumJustMe(String price) {
    return 'Só eu — $price';
  }

  @override
  String premiumFamilyPrice(String price) {
    return 'Família (até 5 pessoas) — $price';
  }

  @override
  String get premiumFamilyApple =>
      'Família: compartilhado com sua família Apple pelo Compartilhamento Familiar, mais uma chave de licença para até 5 pessoas em qualquer aparelho.';

  @override
  String get premiumFamilyKey =>
      'Família: uma chave de licença que você compartilha com até 4 outras pessoas.';

  @override
  String get premiumYourKey => 'Sua chave de licença';

  @override
  String get premiumYourKeyHelp =>
      'Digite nos seus outros aparelhos: Ajustes → Obter o Premium → \"Já comprou? Digite sua chave de licença\".';

  @override
  String get premiumCopyKey => 'Copiar chave';

  @override
  String get premiumInviteFriends => 'Convidar amigos';

  @override
  String get premiumInviteHelp =>
      'Amigos ganham 20% de desconto. Quando 3 amigos comprarem, sua chave vira uma chave Família.';

  @override
  String get premiumGetInvite => 'Pegar meu link de convite';

  @override
  String get premiumCheckInvites => 'Ver meus convites';

  @override
  String get premiumYouHave => 'Você tem o Premium';

  @override
  String get premiumTitle => 'Tanooki Auth Premium';

  @override
  String get premiumOwnedFamily =>
      'Plano Família: compartilhe sua chave de licença com até 4 outras pessoas (5 no total). Obrigada por apoiar o Tanooki Auth.';

  @override
  String get premiumOwnedThanks => 'Obrigada por apoiar o Tanooki Auth.';

  @override
  String get premiumPitchStripe =>
      'US\$ 5 uma vez, ou US\$ 10 para toda a sua família. Seu para sempre.';

  @override
  String get premiumPitchStore =>
      'Pague uma vez para você, ou uma vez para toda a sua família. Seu para sempre.';

  @override
  String get premiumPerkThemes => 'Todos os temas Premium';

  @override
  String premiumPerkThemesBody(int count) {
    return 'Rosa Pastel, Azul Pastel e mais $count, temas sazonais que mudam sozinhos, até 3 temas seus, além de todo tema adicionado depois.';
  }

  @override
  String get premiumPerkIcons => 'Ícones do app';

  @override
  String premiumPerkIconsBody(int count) {
    return 'Escolha outro ícone para a tela de início no iPhone e no Android, em Rosa Pastel, Azul Pastel e mais $count cores, além de ícones sazonais de outono, inverno e primavera. No Mac, ele muda o ícone do Dock enquanto o app está aberto.';
  }

  @override
  String get premiumPerkSync => 'Sincronize entre seus aparelhos';

  @override
  String get premiumPerkSyncBody =>
      'Adicione uma conta em um aparelho e veja em todos, com criptografia de ponta a ponta. Pelo iCloud em aparelhos Apple, ou pelo relay do Tanooki para qualquer combinação.';

  @override
  String get premiumPerkApprove => 'Aprove códigos pelo celular';

  @override
  String get premiumPerkApproveBody =>
      'Use a extensão do navegador em qualquer computador: ela pergunta ao seu celular, você toca em Aprovar, e o código é preenchido.';

  @override
  String get premiumPerkBreach => 'Alertas de vazamento';

  @override
  String get premiumPerkBreachBody =>
      'Seja avisado quando um site em que você tem conta aparecer em um vazamento de dados conhecido. Verificado no seu aparelho; nada sobre você é enviado.';

  @override
  String get premiumPerkShare => 'Compartilhe uma conta com segurança';

  @override
  String get premiumPerkShareBody =>
      'Passe uma conta para alguém de confiança com um código QR e um código de 6 dígitos. Protegido, expira em 24 horas, sem servidor.';

  @override
  String get premiumPerkFamily => 'Plano Família';

  @override
  String get premiumPerkFamilyStripe =>
      'Por US\$ 10 em vez de US\$ 5, uma chave libera o Premium para até 5 pessoas. Mande para a sua família e eles digitam como você.';

  @override
  String get premiumPerkFamilyStore =>
      'Uma compra Família libera o Premium para até 5 pessoas. Mande sua chave de licença e eles digitam como você.';

  @override
  String get premiumPerkFuture => 'Todos os recursos Premium futuros';

  @override
  String get premiumPerkFutureBody =>
      'Pague uma vez e receba tudo o que o Premium virar. Nunca uma assinatura.';

  @override
  String get premiumPerkFree => 'Mantém os apps de privacidade gratuitos';

  @override
  String get premiumPerkFreeStripe =>
      'Seus US\$ 5 são o que me permite continuar fazendo apps gratuitos que não rastreiam você.';

  @override
  String get premiumPerkFreeStore =>
      'Comprar o Premium é o que me permite continuar fazendo apps gratuitos que não rastreiam você.';

  @override
  String get premiumFreeForever =>
      'Grátis para sempre, com ou sem Premium: contas ilimitadas, escaneamento, backups, a extensão do navegador e o bloqueio do app.';

  @override
  String get premiumFamilySoon => 'Plano Família em breve';

  @override
  String get premiumFamilyKeyEach =>
      'Família: uma chave de licença que você compartilha com até 4 outras pessoas. Cada uma digita no próprio Tanooki Auth.';

  @override
  String get premiumRestore => 'Restaurar compras';

  @override
  String get premiumAlreadyBought => 'Já comprou? Digite sua chave de licença';

  @override
  String get premiumDesktopKeySoon =>
      'Chave para computador em breve para compras no Android. O Premium já está liberado neste celular; uma chave de licença para seus computadores vai aparecer aqui em uma atualização futura.';

  @override
  String premiumGift(String price) {
    return 'Dar o Premium de presente — $price';
  }

  @override
  String premiumGiftFamily(String price) {
    return 'Dar o plano Família de presente — $price';
  }

  @override
  String get premiumGiftHelp =>
      'Depois de pagar, você recebe um vale-presente para imprimir com uma chave para a pessoa.';

  @override
  String get settingsIconFailed =>
      'Não foi possível mudar o ícone do app. Tente de novo ou reinicie o app.';

  @override
  String settingsIconFailedWhy(String problem) {
    return 'Não foi possível mudar o ícone do app ($problem). Tente de novo ou reinicie o app.';
  }

  @override
  String settingsIconSemantic(String name) {
    return 'Ícone do app $name';
  }

  @override
  String settingsIconSemanticPremium(String name) {
    return 'Ícone do app $name, Premium';
  }

  @override
  String get settingsAppIcon => 'Ícone do app';

  @override
  String get settingsAppIconPremium => 'Ícone do app (Premium)';

  @override
  String get settingsAppIconIos => 'O ícone na sua tela de início.';

  @override
  String get settingsAppIconAndroid =>
      'O ícone na sua tela de início. Ele pode sumir por um instante enquanto o celular faz a troca.';

  @override
  String get settingsAppIconMac =>
      'Muda o ícone do Dock enquanto o Tanooki Auth está aberto. O Mac não consegue manter outro ícone depois que o app fecha, então o Finder e o Launchpad continuam com o azul.';

  @override
  String get settingsAppIconOther =>
      'Os ícones do app podem ser trocados no iPhone e no Android.';

  @override
  String get settingsLockNameMac => 'Touch ID ou a senha do Mac';

  @override
  String get settingsLockNamePhone => 'Face ID, digital ou código de acesso';

  @override
  String settingsNoLockSetUp(String lock) {
    return 'Este aparelho não tem $lock configurado, então o app não pode ser bloqueado. Configure primeiro nos ajustes do sistema.';
  }

  @override
  String get settingsLockReasonOn => 'Ativar o bloqueio do app';

  @override
  String get settingsLockReasonOff => 'Desativar o bloqueio do app';

  @override
  String get settingsSetPasscode => 'Criar um código de acesso do app';

  @override
  String get settingsSetPasscodeIntro =>
      'Digite isto para abrir o Tanooki Auth. Também funciona quando o Face ID ou a digital não funcionam. Se você esquecer, o único jeito de entrar de novo é um backup.';

  @override
  String get settingsPasscodeOn => 'Código de acesso do app ativado.';

  @override
  String get settingsPasscode => 'Código de acesso do app';

  @override
  String get settingsChangePasscode => 'Mudar código de acesso';

  @override
  String get settingsPasscodeOff => 'Desativar código de acesso';

  @override
  String get settingsNewPasscode => 'Novo código de acesso do app';

  @override
  String get settingsPasscodeChanged => 'Código de acesso mudado.';

  @override
  String get settingsPasscodeIsOff => 'Código de acesso do app desativado.';

  @override
  String get settingsRemoveDecoyTitle => 'Remover o código de acesso falso?';

  @override
  String get settingsRemoveDecoyBody =>
      'As contas falsas são apagadas. Suas contas reais não são tocadas.';

  @override
  String get settingsSetDecoy => 'Criar um código de acesso falso';

  @override
  String get settingsSetDecoyIntro =>
      'Se alguém obrigar você a abrir o Tanooki Auth, digite este no lugar. Ele abre um conjunto separado e vazio de contas, e nada na tela mostra que não é o verdadeiro. Adicione algumas contas inofensivas lá para parecer usado.\n\nSeu código de acesso real continua abrindo suas contas reais.';

  @override
  String get settingsDecoySet => 'Código de acesso falso criado.';

  @override
  String settingsWipeTitle(int count) {
    return 'Apagar tudo depois de $count códigos de acesso errados?';
  }

  @override
  String settingsWipeBody(int count) {
    return 'Se alguém digitar o código de acesso do app errado $count vezes seguidas, o Tanooki Auth apaga todas as contas deste aparelho. Não dá para desfazer nem para parar depois que começa.';
  }

  @override
  String get settingsWipeSureTitle => 'Tem certeza?';

  @override
  String get settingsWipeSureBody =>
      'Uma criança brincando com seu celular, ou você em um dia ruim, pode disparar isso. Depois de apagar, o único jeito de voltar é o seu arquivo de backup. Sem ele, você pode ficar sem acesso a todos os sites que usam esses códigos.';

  @override
  String get settingsWipeTurnOn => 'Ativar apagamento de emergência';

  @override
  String get settingsTravelOffReason => 'Desativar o modo viagem';

  @override
  String get settingsTravelOnNone =>
      'Modo viagem ativado, mas nenhuma conta está marcada com \"Esconder no modo viagem\" ainda. Marque primeiro em ⋯ > Editar.';

  @override
  String settingsTravelOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Modo viagem ativado. $count contas estão escondidas.',
      one: 'Modo viagem ativado. 1 conta está escondida.',
    );
    return '$_temp0';
  }

  @override
  String get settingsTravelOff =>
      'Modo viagem desativado. Todas as contas voltaram.';

  @override
  String get settingsCheckingClock => 'Verificando seu relógio…';

  @override
  String get settingsClockRight =>
      'Seu relógio está certo, então não é isso. Confira se as configurações da conta (⋯ > Editar > Avançado) batem com o que o site disse.';

  @override
  String settingsClockFailed(String problem) {
    return 'Não foi possível verificar o relógio: $problem';
  }

  @override
  String get settingsLockApp => 'Bloquear o app';

  @override
  String settingsLockAppHelp(String lock) {
    return 'Pedir $lock quando o app abrir';
  }

  @override
  String get settingsPasscodeOnHelp =>
      'Ativado. Toque para mudar ou desativar.';

  @override
  String settingsPasscodeOffHelp(String lock) {
    return 'Desativado. Números que você digita para abrir o app, no lugar de ou junto com $lock.';
  }

  @override
  String get settingsLockAgain => 'Bloquear de novo';

  @override
  String settingsLockAgainHelp(String time) {
    return '$time em segundo plano';
  }

  @override
  String get settingsLockFirst =>
      'Ative o bloqueio ou um código de acesso primeiro';

  @override
  String get settingsDecoy => 'Código de acesso falso';

  @override
  String get settingsDecoyOn =>
      'Ativado. Abre um conjunto separado de contas. Toque para remover.';

  @override
  String get settingsDecoyOff =>
      'Um segundo código de acesso que abre um conjunto separado e vazio de contas';

  @override
  String settingsWipe(int count) {
    return 'Apagar após $count códigos de acesso errados';
  }

  @override
  String get settingsWipeHelp =>
      'Apagamento de emergência. Precisa de um backup feito nos últimos 30 dias.';

  @override
  String get settingsLockOnSleep => 'Bloquear quando o computador repousar';

  @override
  String get settingsLockOnSleepHelp =>
      'Também quando a tela bloqueia ou você sai da sessão por um momento';

  @override
  String get settingsLockOnSleepNeedsLock =>
      'Ative \"Bloquear o app\" ou um código de acesso do app primeiro, para ter algo a bloquear.';

  @override
  String get settingsTravel => 'Modo viagem';

  @override
  String get settingsTravelPremium => 'Modo viagem (Premium)';

  @override
  String get settingsTravelOnHelp =>
      'Ativado. As contas marcadas com \"Esconder no modo viagem\" somem das telas, widgets, relógio, extensão e exportações deste aparelho até você desativar. Elas não são apagadas.';

  @override
  String settingsTravelOffHelp(String proof) {
    return 'Antes de cruzar uma fronteira: esconde as contas que você marcou com \"Esconder no modo viagem\" (⋯ > Editar). Para desativar, é preciso $proof.';
  }

  @override
  String get settingsKeys => 'Chaves de segurança';

  @override
  String get settingsKeysPremium => 'Chaves de segurança (Premium)';

  @override
  String get settingsKeysHelp =>
      'Desbloqueie com uma YubiKey ou outra chave de segurança';

  @override
  String get settingsActivity => 'Histórico de atividade';

  @override
  String get settingsActivityPremium => 'Histórico de atividade (Premium)';

  @override
  String get settingsActivityHelp =>
      'Quais códigos foram copiados, preenchidos, digitados ou exportados, e quando. Fica só neste aparelho.';

  @override
  String get settingsEmergency => 'Acesso de emergência';

  @override
  String get settingsEmergencyPremium => 'Acesso de emergência (Premium)';

  @override
  String get settingsEmergencyHelp =>
      'Deixe uma pessoa de confiança receber suas contas se algo acontecer com você, depois de uma espera de 7 dias que você pode interromper';

  @override
  String get settingsTeamHelp =>
      'Compartilhe códigos de login com até 10 pessoas, com criptografia de ponta a ponta';

  @override
  String get settingsMonthly => 'Notificação de resumo mensal';

  @override
  String get settingsMonthlyPremium => 'Notificação de resumo mensal (Premium)';

  @override
  String get settingsMonthlyHelp =>
      'Um lembrete no dia 1º de cada mês para olhar seu cartão de resumo. Ele nunca diz nada sobre suas contas.';

  @override
  String get settingsBlockShots => 'Bloquear capturas de tela';

  @override
  String get settingsBlockShotsDesktop =>
      'Esconde esta janela de capturas de tela, gravação de tela e compartilhamento de tela';

  @override
  String get settingsBlockShotsPhone =>
      'Mantém os códigos fora de capturas de tela, gravação de tela e do seletor de apps';

  @override
  String get settingsCheckup => 'Verificação de segurança';

  @override
  String get settingsCheckupHelp =>
      'O que vale a pena corrigir, e seu kit de recuperação';

  @override
  String get settingsBreachPremium => 'Alertas de vazamento (Premium)';

  @override
  String get settingsBreachOn =>
      'Ativado. Verifica a lista pública de vazamentos toda semana.';

  @override
  String get settingsBreachOff =>
      'Desativado. Quando ativado, o app baixa a lista pública de vazamentos uma vez por semana.';

  @override
  String settingsThemeSemantic(String name) {
    return 'Tema $name';
  }

  @override
  String settingsThemeSemanticPremium(String name) {
    return 'Tema $name, Premium';
  }

  @override
  String get settingsPremiumThanks => 'Premium: obrigada!';

  @override
  String get settingsGetPremium => 'Obter o Premium';

  @override
  String get settingsPremiumThanksHelp =>
      'Todos os temas e recursos Premium futuros são seus.';

  @override
  String settingsGetPremiumHelp(String payOnce) {
    return '$payOnce: todos os temas, sincronização entre seus aparelhos e mais.';
  }

  @override
  String get settingsAppearance => 'Aparência';

  @override
  String get settingsCountdown => 'Estilo da contagem regressiva';

  @override
  String get settingsCountdownHelp =>
      'Como o tempo restante de cada código é mostrado';

  @override
  String get settingsEasyFont => 'Fonte fácil de ler';

  @override
  String get settingsEasyFontHelp =>
      'Atkinson Hyperlegible, feita pelo Braille Institute para que letras e números sejam difíceis de confundir';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsAccountsList => 'Lista de contas';

  @override
  String get settingsCompact => 'Cartões compactos';

  @override
  String get settingsCompactHelp =>
      'Cartões menores, para caber mais contas na tela';

  @override
  String get settingsSort => 'Ordenar contas';

  @override
  String settingsSortHelp(String sort) {
    return '$sort. Os favoritos sempre vêm primeiro.';
  }

  @override
  String get settingsSortCustom =>
      'Sua própria ordem. Toque e segure um cartão, depois arraste.';

  @override
  String get settingsSortRecent =>
      'Contas das quais você acabou de copiar um código vão para o topo';

  @override
  String get settingsSortName => 'Pelo nome do serviço';

  @override
  String get settingsTidyHelp =>
      'Transforma nomes como \"google.com:voce@gmail.com\" em \"Google\". Você vê cada mudança antes.';

  @override
  String get settingsHideCodes => 'Esconder códigos até tocar';

  @override
  String get settingsHideCodesHelp =>
      'Mostra pontos no lugar dos códigos, para que as pessoas por perto não consigam ler';

  @override
  String get settingsShareCodes => 'Mostrar códigos nos widgets e no relógio';

  @override
  String get settingsShareCodesHelp =>
      'Os códigos dos seus favoritos aparecem na Tela de Início, na Tela Bloqueada e no relógio sem abrir este app, então qualquer pessoa com seu celular desbloqueado ou seu relógio pode lê-los. Marque uma conta com estrela para torná-la favorita.';

  @override
  String get settingsAutofill =>
      'Preencher códigos com o Preenchimento Automático';

  @override
  String get settingsAutofillHelpIos =>
      'Quando um site ou app pede um código 2FA, seu iPhone oferece o código acima do teclado, então você não precisa copiar. Contas que perguntam antes precisam do Face ID para preencher. Contas escondidas no modo viagem nunca são oferecidas.';

  @override
  String get settingsAutofillHelpAndroid =>
      'Quando um app ou site pede um código 2FA, seu celular oferece o código em uma pequena janela, então você não precisa copiar. O Android só deixa um app fazer o preenchimento automático por vez, então isto substitui o preenchimento do seu gerenciador de senhas. Se você depende dele, deixe isto desativado.';

  @override
  String get settingsAutofillStepsTitle => 'Ativar o Preenchimento Automático';

  @override
  String get settingsAutofillStepsIos =>
      'Isto precisa do iOS 18 ou mais novo.\n\n1. Abra o app Ajustes (o ícone de engrenagem cinza).\n2. Toque em Geral, depois em Preenchimento Automático e Senhas.\n3. Na lista de apps que podem fazer o Preenchimento Automático, ative a chave ao lado do Tanooki Auth.\n\nDeu certo se a chave estiver verde. Na próxima vez que um site ou app pedir um código, toque na caixa do código e toque na sugestão do Tanooki Auth acima do teclado.';

  @override
  String get settingsAutofillStepsAndroid =>
      '1. Toque em Abrir Configurações abaixo. Uma lista de apps de preenchimento automático se abre.\n2. Toque em Tanooki Auth e depois em OK se o celular perguntar.\n\nSe nenhuma lista abrir: abra o app Configurações, pesquise \"Serviço de preenchimento automático\", toque nele e escolha Tanooki Auth.\n\nDeu certo se o Tanooki Auth agora aparece como serviço de preenchimento automático. Na próxima vez que um app ou site pedir um código, toque na caixa do código e escolha Tanooki Auth na janela.\n\nO Android só deixa um app fazer o preenchimento automático por vez. Escolher o Tanooki Auth impede que seu gerenciador de senhas (como Google, Bitwarden ou 1Password) preencha senhas. Para voltar, escolha ele de novo no mesmo lugar.';

  @override
  String get settingsAutofillOpen => 'Abrir Configurações';

  @override
  String get settingsTrash => 'Lixeira';

  @override
  String settingsTrashCount(int count) {
    return 'Lixeira ($count)';
  }

  @override
  String get settingsTrashHelp => 'Contas apagadas ficam aqui por 30 dias';

  @override
  String get settingsWatchFace => 'Favorito no mostrador do relógio';

  @override
  String get settingsWatchFacePremium =>
      'Favorito no mostrador do relógio (Premium)';

  @override
  String get settingsWatchFaceNoFavorites =>
      'Marque uma conta com estrela na lista principal primeiro. Só favoritos podem ir para o mostrador do relógio.';

  @override
  String get settingsNone => 'Nenhum';

  @override
  String get settingsCopying => 'Cópia e atalhos';

  @override
  String get settingsCopyOnOpen => 'Copiar ao abrir';

  @override
  String get settingsCopyOnOpenHelp =>
      'Abrir ou desbloquear o app copia o código da última conta que você usou. Contas que perguntam antes de mostrar o código são puladas.';

  @override
  String get settingsPasteOnce => 'Limpar depois de colar uma vez';

  @override
  String get settingsPasteOnceHelp =>
      'O código copiado funciona para uma colagem, depois a área de transferência é esvaziada. Apps de histórico da área de transferência podem contar como essa colagem. No Windows, os códigos são apagados depois de 30 segundos.';

  @override
  String get settingsSpotlight => 'Mostrar contas no Spotlight';

  @override
  String get settingsSpotlightHelp =>
      'Busque o nome de uma conta de qualquer lugar e vá direto para ela. Só os nomes são compartilhados, nunca os códigos.';

  @override
  String get settingsLiveActivity =>
      'Código na Tela Bloqueada depois de copiar';

  @override
  String get settingsLiveActivityPremium =>
      'Código na Tela Bloqueada depois de copiar (Premium)';

  @override
  String get settingsLiveActivityHelp =>
      'Depois que você copia um código, ele aparece na Tela Bloqueada e na Dynamic Island com uma contagem regressiva até expirar.';

  @override
  String get settingsWatchFaceHelp =>
      'Escolha um favorito cujo código aparece no mostrador do seu Apple Watch. Precisa de \"Mostrar códigos nos widgets e no relógio\" ativado.';

  @override
  String settingsWatchFaceChosen(String name) {
    return '$name. Adicione a complicação do Tanooki Auth ao mostrador do relógio para ver.';
  }

  @override
  String get settingsBrowserSection => 'Extensão do navegador e atalhos';

  @override
  String get settingsBridgeOff => 'Não está rodando';

  @override
  String get settingsBridgeOn => 'Pronto para a extensão do navegador';

  @override
  String settingsBridgeOffHelp(String first, String last) {
    return 'As portas $first–$last estão todas em uso por outros programas, então a extensão não consegue se conectar. Reinicie o computador e tente de novo.';
  }

  @override
  String settingsBridgeOnHelp(String port) {
    return 'Escutando só neste computador (127.0.0.1:$port). Funciona enquanto o Tanooki Auth está aberto.';
  }

  @override
  String settingsPairedClient(String name) {
    return 'Pareado: $name';
  }

  @override
  String get settingsPairedBrowser => 'Navegador pareado';

  @override
  String settingsExtensionId(String id) {
    return 'Extensão $id';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSecurity => 'Segurança';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsExport => 'Exportar backup';

  @override
  String get settingsExportHelp =>
      'Um arquivo criptografado, protegido com uma frase secreta que você escolhe';

  @override
  String get settingsImport => 'Importar backup';

  @override
  String get settingsImportHelp =>
      'Adiciona contas de um arquivo de backup; pula as que você já tem';

  @override
  String get settingsTestBackup => 'Testar um backup';

  @override
  String get settingsTestBackupHelp =>
      'Confere se um arquivo de backup abre com sua frase secreta. Não muda nada.';

  @override
  String get settingsMoveOut => 'Levar para outro app';

  @override
  String get settingsMoveOutHelp =>
      'Aegis, 2FAS, Google Authenticator ou links de configuração simples';

  @override
  String get settingsPaper => 'Imprimir backup em papel';

  @override
  String get settingsPaperHelp =>
      'Um PDF com códigos QR e códigos de recuperação para guardar em um lugar trancado';

  @override
  String get settingsHelp => 'Ajuda';

  @override
  String get settingsGuidesHelp =>
      'Ajuda passo a passo para ativar a 2FA em sites populares, no nosso site';

  @override
  String get settingsTour => 'Mostrar o tour de boas-vindas';

  @override
  String get settingsFeedbackHelp =>
      'Conte para a Maddie sobre um bug ou uma ideia. Nunca inclui suas contas ou códigos.';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get settingsAboutMaddieHelp =>
      'Um recado da pessoa que faz o Tanooki Auth';

  @override
  String get settingsCodesNotWorking => 'Os códigos não funcionam?';

  @override
  String settingsCodesNotWorkingHelp(String time) {
    return 'Hora do aparelho: $time. Os códigos dependem do relógio: toque para comparar com a internet.';
  }

  @override
  String shareUiConfirmTitle(String name) {
    return 'Compartilhar $name?';
  }

  @override
  String get shareUiConfirmBody =>
      'A pessoa com quem você compartilhar recebe acesso total: o celular dela vai gerar os mesmos códigos que o seu, enquanto ela guardar a conta. Só compartilhe com alguém em quem você confia totalmente, como a família.\n\nRemover a conta da sua lista depois não tira dela. Para cortar o acesso, desative e ative de novo a autenticação de dois fatores no site.';

  @override
  String get shareUiConfirmButton => 'Entendi, compartilhar';

  @override
  String get shareUiLocking => 'Protegendo o compartilhamento…';

  @override
  String shareUiTitle(String name) {
    return 'Compartilhar $name';
  }

  @override
  String get shareUiInstructions =>
      'No aparelho da pessoa: abra o Tanooki Auth, toque em Adicionar conta, depois em \"Escanear código QR\" (ou \"Abrir uma conta compartilhada\" para o arquivo). Depois ela digita este código:';

  @override
  String get shareUiTellCode =>
      'Diga o código você mesmo, em voz alta ou em um app diferente do arquivo.';

  @override
  String get shareUiSendFile => 'Enviar como arquivo';

  @override
  String get shareUiCopyLink => 'Copiar como link';

  @override
  String get shareUiCopied =>
      'Copiado. A pessoa cola com \"Colar link de configuração\".';

  @override
  String get shareUiWorksFor =>
      'Funciona por 24 horas, e só com o código. Nada passa por um servidor.';

  @override
  String get shareUiOpenTitle => 'Conta compartilhada';

  @override
  String get shareUiOpenBody =>
      'Digite o código de 6 dígitos que a pessoa que compartilhou te passou.';

  @override
  String get shareUiUnlocking => 'Desbloqueando…';

  @override
  String get signatureLabel => 'Com carinho, Maddie';

  @override
  String get syncUiQrCode => 'Código QR';

  @override
  String get syncUiNotYet => 'Ainda não';

  @override
  String get syncUiJustNow => 'Agora mesmo';

  @override
  String syncUiMinutesAgo(int minutes) {
    return 'há $minutes min';
  }

  @override
  String syncUiHoursAgo(int hours) {
    return 'há $hours h';
  }

  @override
  String syncUiDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get syncUiThisDevice => 'Este aparelho';

  @override
  String get syncUiAnotherDevice => 'Outro aparelho';

  @override
  String syncUiAdded(String when) {
    return 'Adicionado $when';
  }

  @override
  String syncUiThisDeviceNamed(String name) {
    return 'Este aparelho ($name)';
  }

  @override
  String syncUiLastSyncedAgo(String when) {
    return 'Última sincronização: $when';
  }

  @override
  String get syncUiWhere => 'Onde seus aparelhos devem sincronizar?';

  @override
  String get syncUiICloudHelp =>
      'Só para iPhone, iPad e Mac. Usa o seu próprio iCloud Drive.';

  @override
  String get syncUiRelay => 'Relay do Tanooki';

  @override
  String get syncUiRelayHelp =>
      'Funciona com todos os aparelhos, incluindo Android e Windows. O servidor só guarda dados embaralhados.';

  @override
  String get syncUiStartFreshTitle => 'Começar do zero?';

  @override
  String get syncUiStartFreshBody =>
      'Se você esqueceu a frase secreta que seus outros aparelhos Apple usam, pode começar uma nova sincronização com esta. Seus outros aparelhos vão precisar desativar e ativar a sincronização de novo com a nova frase secreta.';

  @override
  String get syncUiStartFresh => 'Começar do zero';

  @override
  String get syncUiOn => 'A sincronização está ativada.';

  @override
  String get syncUiScanTitle => 'Escaneie o código de sincronização';

  @override
  String get syncUiScanWrong =>
      'Isso não é um código de sincronização. No seu outro aparelho, abra Ajustes, Sincronização, Adicionar um aparelho.';

  @override
  String get syncUiNowSyncing => 'Este aparelho agora está sincronizando.';

  @override
  String get syncUiPasteTitle => 'Cole o link de sincronização';

  @override
  String get syncUiPasteHint =>
      'tanookiauth://sync?…  (de Adicionar um aparelho no seu outro aparelho)';

  @override
  String get syncUiAddApple => 'Adicionar um aparelho Apple';

  @override
  String get syncUiAddAppleBody =>
      'No seu outro iPhone, iPad ou Mac (com a mesma Conta Apple e o iCloud Drive ativado), abra o Tanooki Auth, vá em Ajustes, depois em Sincronização, toque em \"Ativar a sincronização\", escolha iCloud e digite a mesma frase secreta de sincronização.\n\nQuer adicionar um celular Android ou um PC com Windows? Desative a sincronização em todos os aparelhos e ative de novo com o relay do Tanooki.';

  @override
  String get syncUiAddDevice => 'Adicionar um aparelho';

  @override
  String get syncUiAddDeviceBody =>
      'No novo aparelho, abra o Tanooki Auth, vá em Ajustes, depois em Sincronização, e toque em \"Entrar por outro aparelho\". Escaneie este código e digite sua frase secreta de sincronização lá.';

  @override
  String get syncUiAddDeviceNote =>
      'Funciona uma vez, por 24 horas. Quem tiver só este código não consegue ler nada sem a sua frase secreta.';

  @override
  String get syncUiLinkCopied => 'Link copiado. Cole no novo aparelho.';

  @override
  String get syncUiCopyLink => 'Copiar link';

  @override
  String get syncUiRemoveTitle => 'Remover este aparelho da sincronização?';

  @override
  String get syncUiRemoveBody =>
      'Ele para de receber mudanças. Se o aparelho foi perdido ou roubado, mude também sua frase secreta de sincronização: desative a sincronização em todos os aparelhos e ative de novo com uma nova frase secreta, porque o aparelho perdido ainda conhece a antiga.';

  @override
  String get syncUiTurnOffTitle => 'Desativar a sincronização neste aparelho?';

  @override
  String get syncUiTurnOffBody =>
      'Suas contas continuam neste aparelho. Ele só para de enviar e receber mudanças. Seus outros aparelhos continuam sincronizando entre si.';

  @override
  String get syncUiOff => 'A sincronização está desativada neste aparelho.';

  @override
  String get syncUiPremium => 'A sincronização faz parte do Premium';

  @override
  String syncUiPremiumBody(String payOnce) {
    return 'Adicione uma conta em um aparelho e ela aparece em todos, com criptografia de ponta a ponta. $payOnce, sem assinatura.';
  }

  @override
  String get syncUiIntro =>
      'A sincronização mantém suas contas iguais em todos os seus aparelhos. Antes de qualquer coisa sair deste aparelho, ela é protegida com sua frase secreta de sincronização, então o iCloud ou nosso servidor só guardam dados embaralhados. Ninguém mais consegue ler, nem nós.';

  @override
  String get syncUiTurnOn => 'Ativar a sincronização';

  @override
  String get syncUiJoin => 'Entrar por outro aparelho';

  @override
  String get syncUiJoinHelp =>
      'Use \"Entrar\" quando outro aparelho já sincroniza com o relay do Tanooki.';

  @override
  String get syncUiSyncingRelay => 'Sincronizando com o relay do Tanooki';

  @override
  String get syncUiSyncingICloud => 'Sincronizando com o iCloud';

  @override
  String get syncUiSyncingNow => 'Sincronizando agora…';

  @override
  String syncUiSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens sincronizados não puderam ser lidos',
      one: '1 item sincronizado não pôde ser lido',
    );
    return '$_temp0';
  }

  @override
  String get syncUiSkippedHelp =>
      'Eles podem ter sido alterados por outra pessoa ou criados com outra frase secreta. Nada foi apagado por causa deles.';

  @override
  String get syncUiDevices => 'Aparelhos';

  @override
  String get syncUiLoading => 'Carregando…';

  @override
  String get syncUiAddDeviceRelay =>
      'Mostra um código para escanear no novo aparelho';

  @override
  String get syncUiAddDeviceApple => 'Outro iPhone, iPad ou Mac';

  @override
  String get syncUiTurnOffButton => 'Desativar a sincronização neste aparelho';

  @override
  String get syncUiPassphraseNoteRelay =>
      'Sua frase secreta de sincronização não pode ser recuperada. Se você esquecer, desative a sincronização em todos os aparelhos e comece de novo com uma nova. Suas contas continuam onde estão.';

  @override
  String get syncUiPassphraseNoteICloud =>
      'A sincronização usa o seu iCloud Drive. Sua frase secreta de sincronização não pode ser recuperada; se você esquecer, comece do zero com uma nova. Suas contas continuam onde estão.';

  @override
  String get syncUiTitle => 'Sincronização';

  @override
  String get syncUiTooShort =>
      'Use pelo menos 10 caracteres. Algumas palavras aleatórias funcionam bem.';

  @override
  String get syncUiMismatch => 'As duas frases secretas não são iguais.';

  @override
  String get syncUiChoosePassphrase =>
      'Escolha uma frase secreta de sincronização';

  @override
  String get syncUiTypePassphrase =>
      'Digite sua frase secreta de sincronização';

  @override
  String get syncUiChooseHelp =>
      'Você vai digitar isto uma vez em cada aparelho que adicionar. Ela protege suas contas antes de saírem deste aparelho.\n\nAnote em um lugar seguro. Ela não pode ser recuperada nem redefinida, nem por você nem por nós.';

  @override
  String get syncUiTypeHelp =>
      'A mesma frase secreta que você escolheu quando ativou a sincronização no primeiro aparelho.';

  @override
  String get syncUiPassphrase => 'Frase secreta de sincronização';

  @override
  String get syncUiTypeAgain => 'Digite de novo';

  @override
  String get syncUiSectionTitle => 'Sincronização e celular';

  @override
  String get syncUiTitlePremium => 'Sincronização (Premium)';

  @override
  String get syncUiOnRelay => 'Ativada, com o relay do Tanooki';

  @override
  String get syncUiOnICloud => 'Ativada, com o iCloud';

  @override
  String get syncUiOffHelp =>
      'Mantenha suas contas iguais em todos os seus aparelhos';

  @override
  String get syncUiBrowser => 'Usar com um navegador';

  @override
  String get syncUiBrowserPremium => 'Usar com um navegador (Premium)';

  @override
  String get syncUiBrowserHelp =>
      'Aprove códigos neste celular para um navegador em qualquer computador';

  @override
  String get teamUiCreateTitle => 'Crie sua equipe';

  @override
  String get teamUiCreateHint => 'TT1.…  (da página depois que você assinou)';

  @override
  String get teamUiCreateButton => 'Criar equipe';

  @override
  String get teamUiReady =>
      'Sua equipe está pronta. Convide pessoas com \"Convidar alguém\".';

  @override
  String get teamUiScanTitle => 'Escaneie o convite da equipe';

  @override
  String get teamUiScanWrong =>
      'Isso não é um convite de equipe. Peça ao admin da equipe para abrir Ajustes, Cofre da equipe, Convidar alguém.';

  @override
  String get teamUiJoinTitle => 'Entrar em uma equipe';

  @override
  String get teamUiJoinHint =>
      'tanookiauth://team?…  (o link de convite do admin da equipe)';

  @override
  String get teamUiJoinButton => 'Entrar';

  @override
  String get teamUiJoinedTeam =>
      'Você está na equipe. As contas da equipe aparecem assim que o app do admin compartilhar a chave da equipe com este aparelho.';

  @override
  String get teamUiInvite => 'Convidar alguém';

  @override
  String get teamUiInviteHelp =>
      'No aparelho da pessoa: Ajustes, Cofre da equipe, depois \"Escanear um código QR de convite\" ou \"Colar um link de convite\". O convite funciona uma vez e dura 7 dias.';

  @override
  String get teamUiRemovePersonTitle => 'Remover esta pessoa?';

  @override
  String get teamUiRemovePersonBody =>
      'Ela perde o acesso na hora, e a equipe ganha uma nova chave para que ela não consiga ler nada adicionado ou alterado de agora em diante. Ela pode ter guardado cópias dos códigos que já via, então mude a configuração de dois fatores de qualquer conta importante.';

  @override
  String get teamUiRemoved => 'Removido. A equipe tem uma nova chave.';

  @override
  String get teamUiDeleteTitle => 'Apagar a equipe?';

  @override
  String get teamUiLeaveTitle => 'Sair da equipe?';

  @override
  String get teamUiDeleteBody =>
      'Todas as contas da equipe são apagadas para todo mundo na equipe. As contas pessoais de cada um não são tocadas.';

  @override
  String get teamUiLeaveBody =>
      'As contas da equipe somem deste aparelho. Suas próprias contas não são tocadas.';

  @override
  String get teamUiDeleteButton => 'Apagar equipe';

  @override
  String get teamUiLeaveButton => 'Sair';

  @override
  String get teamUiDeleted => 'Equipe apagada.';

  @override
  String get teamUiLeft => 'Você saiu da equipe.';

  @override
  String get teamUiAddFirst =>
      'Adicione a conta ao Tanooki Auth primeiro, depois copie para a equipe aqui.';

  @override
  String get teamUiCopyInTitle => 'Copie uma das suas contas para a equipe';

  @override
  String teamUiCopiedIn(String name) {
    return '$name agora está na equipe. Sua própria cópia continua onde estava.';
  }

  @override
  String get teamUiRenameTitle => 'Renomear conta da equipe';

  @override
  String get teamUiRenameHint => 'Nome, ex.: AWS';

  @override
  String teamUiRemoveAccountTitle(String name) {
    return 'Remover $name da equipe?';
  }

  @override
  String get teamUiRemoveAccountBody => 'Ela some para todo mundo na equipe.';

  @override
  String get teamUiIntro =>
      'Um cofre da equipe compartilha códigos de login com até 10 pessoas, por US\$ 20 por ano. Todo mundo na equipe pode ver, adicionar e mudar as contas da equipe. Elas são criptografadas nos seus aparelhos com uma chave que só a equipe tem, então nosso servidor não consegue lê-las. As contas da equipe ficam em uma seção Equipe própria e nunca se misturam com as suas contas.';

  @override
  String get teamUiStart => 'Criar uma equipe';

  @override
  String get teamUiBuy => 'Comprar um plano de equipe — US\$ 20 por ano';

  @override
  String get teamUiPlanSoon => 'Plano de equipe em breve';

  @override
  String get teamUiHaveLicense => 'Tenho uma licença de equipe: criar a equipe';

  @override
  String get teamUiJoinHelp =>
      'Peça um convite ao admin da equipe. Entrar é grátis.';

  @override
  String get teamUiScanInvite => 'Escanear um código QR de convite';

  @override
  String get teamUiPasteInvite => 'Colar um link de convite';

  @override
  String get teamUiYouRun => 'Você administra esta equipe';

  @override
  String get teamUiYoureIn => 'Você está em uma equipe';

  @override
  String teamUiPeopleCount(int count, int max) {
    return '$count de $max pessoas';
  }

  @override
  String teamUiLastSynced(String when) {
    return 'Última sincronização: $when';
  }

  @override
  String teamUiPaidUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Pago até $dateString';
  }

  @override
  String get teamUiSyncNow => 'Sincronizar agora';

  @override
  String get teamUiWaitingForKey =>
      'Aguardando o app do admin da equipe compartilhar a chave da equipe com este aparelho. Isso acontece na próxima vez que o admin abrir o Tanooki Auth.';

  @override
  String get teamUiAccounts => 'Contas da equipe';

  @override
  String get teamUiAddMine => 'Adicionar uma minha';

  @override
  String get teamUiNoAccounts => 'Nenhuma conta da equipe ainda.';

  @override
  String get teamUiChange => 'Mudar';

  @override
  String get teamUiRename => 'Renomear';

  @override
  String get teamUiRemoveFromTeam => 'Remover da equipe';

  @override
  String get teamUiPeople => 'Pessoas';

  @override
  String get teamUiThisDevice => 'Este aparelho (admin)';

  @override
  String teamUiDevice(String id) {
    return 'Aparelho $id';
  }

  @override
  String teamUiJoined(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Entrou em $dateString';
  }

  @override
  String teamUiJoinedGettingKey(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Entrou em $dateString · recebendo a chave da equipe';
  }

  @override
  String get teamUiDeleteTeam => 'Apagar a equipe';

  @override
  String get teamUiLeaveTeam => 'Sair da equipe';

  @override
  String get teamUiTitle => 'Cofre da equipe';

  @override
  String teamUiCopiedCode(String name) {
    return 'Código de $name copiado. A área de transferência é limpa em 30 segundos.';
  }

  @override
  String teamUiSection(int count) {
    return 'Equipe · $count';
  }

  @override
  String get teamUiWaitingShort =>
      'Aguardando o admin da equipe compartilhar a chave da equipe com este aparelho.';

  @override
  String get teamUiNoAccountsHint =>
      'Nenhuma conta da equipe ainda. Adicione em Ajustes, Cofre da equipe.';

  @override
  String get themeAuto => 'Automático';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themePink => 'Rosa Pastel';

  @override
  String get themeBlue => 'Azul Pastel';

  @override
  String get themeLavender => 'Lavanda';

  @override
  String get themeMint => 'Menta';

  @override
  String get themeMidnight => 'Meia-noite';

  @override
  String get themeSunset => 'Pôr do sol';

  @override
  String get themePeach => 'Pêssego';

  @override
  String get themeForest => 'Floresta';

  @override
  String get themeOcean => 'Oceano';

  @override
  String get themeMono => 'Mono';

  @override
  String get tidyNoName => '(sem nome)';

  @override
  String tidyDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nomes arrumados.',
      one: '1 nome arrumado.',
    );
    return '$_temp0';
  }

  @override
  String get tidyTitle => 'Arrumar nomes das contas';

  @override
  String get tidyNothing =>
      'Todos os nomes das suas contas já estão arrumados.';

  @override
  String get tidyIntro =>
      'Estes nomes têm endereços de sites ou partes extras. Desmarque os que você quer manter como estão e toque em Aplicar. Seus códigos não mudam.';

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
      'Isso não é um código de contato do Tanooki Auth. Peça para a pessoa abrir o Tanooki Auth, ir em Ajustes > Acesso de emergência e compartilhar o código de contato dela.';

  @override
  String get emergencyCopyWontOpen =>
      'Não foi possível abrir a cópia de emergência com a chave deste aparelho. Ela foi feita para outro aparelho, ou está danificada.';

  @override
  String get emergencyGone =>
      'Esta cópia de emergência não existe mais. O dono a removeu.';

  @override
  String get emergencyWaitNotOver => 'A espera de 7 dias ainda não acabou.';

  @override
  String get emergencyNotOwnerOrContact =>
      'Este aparelho não é o dono nem o contato dessa cópia de emergência.';

  @override
  String get emergencyNoRequestToDeny =>
      'Não há mais nenhum pedido para negar.';

  @override
  String get emergencyAskFirst => 'Peça acesso primeiro.';

  @override
  String get emergencyTooBig =>
      'Suas contas são grandes demais para deixar como cópia de emergência (o limite é de uns 500 KB).';

  @override
  String get emergencyTooManyTries =>
      'Tentativas demais em um minuto. Espere um minuto e tente de novo.';

  @override
  String emergencyServerSaidNo(String status) {
    return 'O servidor de sincronização recusou (HTTP $status).';
  }

  @override
  String emergencyServerSaidNoWhy(String status, String reason) {
    return 'O servidor de sincronização recusou (HTTP $status: $reason).';
  }

  @override
  String get emergencyNotEmergencyCode =>
      'Isso não é um código de emergência do Tanooki Auth. Peça para a pessoa que escolheu você mandar de novo em Ajustes > Acesso de emergência.';

  @override
  String get emergencyLessThanMinute => 'menos de um minuto';

  @override
  String emergencyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '1 dia',
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
      other: '$days dias',
      one: '1 dia',
    );
    String _temp1 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours horas',
      one: '1 hora',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get emergencyUiExplainer =>
      'Escolha uma pessoa de confiança. Se algo acontecer com você, ela pode pedir suas contas. Seus aparelhos recebem uma notificação e você tem 7 dias para dizer não. Se ninguém disser não, ela recebe uma cópia.\n\nO servidor do Tanooki Auth só controla a espera de 7 dias. A cópia é protegida com uma chave que só o aparelho dela tem, então o servidor não consegue lê-la, nem quem invadir o servidor.';

  @override
  String emergencyUiPushNotWorking(String reason) {
    return 'As notificações ainda não estão funcionando ($reason). O Tanooki Auth procura pedidos toda vez que você o abre.';
  }

  @override
  String get emergencyUiScanTheirQr => 'Escanear o código QR da pessoa';

  @override
  String get emergencyUiPasteCode => 'Colar um código que a pessoa mandou';

  @override
  String get emergencyUiWrongCode => 'Esse não é o código certo.';

  @override
  String get emergencyUiCopiedCode =>
      'Copiado. Mande para a pessoa como quiser: ele não tem nenhum segredo.';

  @override
  String get emergencyUiCopyAsText => 'Copiar como texto';

  @override
  String get emergencyUiTheirContactCode => 'O código de contato da pessoa';

  @override
  String get emergencyUiNotContactCodeShort =>
      'Isso não é um código de contato do Tanooki Auth.';

  @override
  String get emergencyUiMakeThemContact =>
      'Tornar essa pessoa seu contato de emergência?';

  @override
  String emergencyUiMakeNamedContact(String name) {
    return 'Tornar $name seu contato de emergência?';
  }

  @override
  String get emergencyUiCopyLeftOnServer =>
      'Uma cópia de todas as suas contas é protegida para o aparelho da pessoa e fica no servidor do Tanooki Auth. Ela é atualizada quando você muda suas contas.';

  @override
  String get emergencyUiYourNameWhose =>
      'Seu nome (para a pessoa saber de quem é a cópia)';

  @override
  String get emergencyUiDoneGiveCode =>
      'Pronto. Agora passe para a pessoa o código desta tela.';

  @override
  String get emergencyUiStopTitle => 'Parar o acesso de emergência?';

  @override
  String get emergencyUiStopBody =>
      'A cópia é apagada do servidor, e a pessoa não pode mais pedi-la.';

  @override
  String get emergencyUiChooseContact => 'Escolher um contato de emergência';

  @override
  String get emergencyUiChooseContactPremium =>
      'Escolher um contato de emergência (Premium)';

  @override
  String get emergencyUiChooseContactHow =>
      'A pessoa abre o Tanooki Auth no aparelho dela, vai em Ajustes > Acesso de emergência e mostra para você o código de contato dela.';

  @override
  String get emergencyUiYourContact => 'Seu contato';

  @override
  String get emergencyUiChecking => 'Verificando com o servidor…';

  @override
  String get emergencyUiIdleJustNow =>
      'Ninguém pediu. Cópia atualizada agora mesmo.';

  @override
  String emergencyUiIdleUpdated(String day) {
    return 'Ninguém pediu. Cópia atualizada em $day.';
  }

  @override
  String emergencyUiWaiting(String who, String day, String left) {
    return '$who pediu em $day. A pessoa pode abrir a cópia em $left, a menos que você negue.';
  }

  @override
  String emergencyUiReleased(String who) {
    return '$who pediu e a espera acabou: a pessoa já pode abrir a cópia. Negue para impedir.';
  }

  @override
  String emergencyUiContactIs(String who) {
    return 'Contato de emergência: $who';
  }

  @override
  String get emergencyUiDenied =>
      'Negado. A pessoa não pode abrir suas contas. Ela pode pedir de novo depois.';

  @override
  String get emergencyUiCopyUpdated => 'Cópia atualizada.';

  @override
  String get emergencyUiCouldntUpdate => 'Não foi possível atualizar a cópia.';

  @override
  String get emergencyUiUpdateNow => 'Atualizar cópia agora';

  @override
  String emergencyUiGiveCode(String who) {
    return 'Passe este código para $who. No Tanooki Auth, a pessoa vai em Ajustes > Acesso de emergência > \"Adicionar um código que alguém te deu\".';
  }

  @override
  String get emergencyUiCodeTheyGave => 'Código que a pessoa te deu';

  @override
  String get emergencyUiNotEmergencyCodeShort =>
      'Isso não é um código de emergência do Tanooki Auth.';

  @override
  String get emergencyUiAddedTheir =>
      'Adicionado. Você pode pedir as contas da pessoa aqui se precisar um dia.';

  @override
  String emergencyUiAddedNamed(String name) {
    return 'Adicionado. Você pode pedir as contas de $name aqui se precisar um dia.';
  }

  @override
  String get emergencyUiTheOwner => 'o dono';

  @override
  String get emergencyUiAskTitle => 'Pedir acesso de emergência?';

  @override
  String emergencyUiAskBody(String who) {
    return '$who recebe uma notificação e tem 7 dias para dizer não. Se não disser, você pode abrir uma cópia das contas aqui. Só peça se realmente precisar.';
  }

  @override
  String get emergencyUiAsk => 'Pedir';

  @override
  String get emergencyUiAsked => 'Pedido feito. A espera de 7 dias começou.';

  @override
  String emergencyUiAddTheirAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Adicionar as $count contas da pessoa?',
      one: 'Adicionar a 1 conta da pessoa?',
    );
    return '$_temp0';
  }

  @override
  String emergencyUiAddNamedAccounts(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Adicionar as $count contas de $name?',
      one: 'Adicionar a 1 conta de $name?',
    );
    return '$_temp0';
  }

  @override
  String get emergencyUiSomeone => 'Alguém';

  @override
  String get emergencyUiCheckingShort => 'Verificando…';

  @override
  String get emergencyUiNotAsked => 'Você não pediu.';

  @override
  String get emergencyUiRequestAccess => 'Pedir acesso';

  @override
  String emergencyUiOpensIn(String left, String day) {
    return 'Você pediu. Abre em $left ($day), a menos que a pessoa diga não.';
  }

  @override
  String get emergencyUiWaitOver => 'A espera acabou.';

  @override
  String get emergencyUiOpenCopy => 'Abrir cópia de emergência';

  @override
  String emergencyUiPersonAccounts(String who) {
    return 'Contas de $who';
  }

  @override
  String get emergencyUiYourContactCode => 'Seu código de contato';

  @override
  String get emergencyUiShowThis =>
      'Se alguém quiser você como contato de emergência, mostre isto. Não tem nenhum segredo.';

  @override
  String get emergencyUiYourNameItsYou =>
      'Seu nome (para a pessoa saber que é você)';

  @override
  String get emergencyUiShowMyCode => 'Mostrar meu código de contato';

  @override
  String get emergencyUiLetThemScan =>
      'Deixe a pessoa escanear isto no Tanooki Auth, ou copie e mande para ela.';

  @override
  String get emergencyUiAddCodeGiven => 'Adicionar um código que alguém te deu';

  @override
  String get emergencyUiAddCodeGivenHow =>
      'Depois que a pessoa escolher você, o app dela mostra um código para você';

  @override
  String get emergencyUiTitle => 'Acesso de emergência';

  @override
  String get emergencyUiYourEmergencyContact => 'Seu contato de emergência';

  @override
  String get emergencyUiPeopleWhoChoseYou => 'Pessoas que escolheram você';

  @override
  String get securityUiProofWindows => 'Windows Hello';

  @override
  String get securityUiProofMac => 'Touch ID ou sua senha';

  @override
  String get securityUiProofIos => 'Face ID ou código de acesso';

  @override
  String get securityUiProofOther => 'digital ou PIN';

  @override
  String securityUiPasscodeAtLeast(int count) {
    return 'Código de acesso (pelo menos $count números)';
  }

  @override
  String get securityUiTypeAgain => 'Digite de novo';

  @override
  String get securityUiPasscodesDontMatch =>
      'Os dois códigos de acesso não são iguais.';

  @override
  String get securityUiPickDifferent =>
      'Escolha um código de acesso diferente do outro.';

  @override
  String get securityUiEnterPasscode => 'Digite o código de acesso do app';

  @override
  String get securityUiPasscode => 'Código de acesso';

  @override
  String get securityUiWrongPasscode => 'Esse não é o seu código de acesso.';

  @override
  String get securityUiCheckupTitle => 'Verificação de segurança';

  @override
  String get securityUiAllGood => 'Tudo certo';

  @override
  String get securityUiAllGoodBody =>
      'Seu app está bloqueado, você tem um backup recente e todas as contas têm códigos de recuperação.';

  @override
  String get securityUiLockOffTitle => 'O app não está bloqueado';

  @override
  String get securityUiLockOffBody =>
      'Qualquer pessoa que pegar seu aparelho desbloqueado pode ver seus códigos. Ative \"Bloquear o app\" ou um código de acesso do app em Ajustes.';

  @override
  String get securityUiNoPasscodeTitle => 'Sem código de acesso do app';

  @override
  String get securityUiNoPasscodeBody =>
      'Um código de acesso deixa você abrir o Tanooki Auth mesmo se o Face ID ou a digital pararem de funcionar. Crie um em Ajustes.';

  @override
  String get securityUiAutoBackupFailed => 'O backup automático falhou';

  @override
  String get securityUiOpenAutoBackups => 'Abrir backups automáticos';

  @override
  String get securityUiNoBackupTitle => 'Nenhum backup nos últimos 30 dias';

  @override
  String get securityUiNoBackupBody =>
      'Se este aparelho for perdido ou quebrar, um backup é o único jeito de recuperar suas contas.';

  @override
  String get securityUiMakeBackupNow => 'Fazer um backup agora';

  @override
  String securityUiNoRecoveryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contas não têm códigos de recuperação',
      one: '1 conta não tem códigos de recuperação',
    );
    return '$_temp0';
  }

  @override
  String securityUiNoRecoveryBody(String names) {
    return 'Os códigos de recuperação te deixam entrar em um site se você perder este app. Encontre-os nos ajustes de segurança de cada site e adicione com ⋯ > Códigos de recuperação na conta.\n\n$names';
  }

  @override
  String get securityUiRecoveryKit => 'Seu kit de recuperação';

  @override
  String get securityUiRecoveryKitSub =>
      'Backup, códigos de recuperação e uma cópia em papel, passo a passo';

  @override
  String securityUiBreachSnack(String sites) {
    return '$sites teve um vazamento de dados. Mude sua senha lá.';
  }

  @override
  String get securityUiBreachDownloadFailed =>
      'Não foi possível baixar a lista de vazamentos. Verifique sua conexão com a internet e tente de novo.';

  @override
  String get securityUiBreachAlerts => 'Alertas de vazamento';

  @override
  String get securityUiBreachAlertsPremium => 'Alertas de vazamento (Premium)';

  @override
  String get securityUiBreachAlertsSub =>
      'Uma vez por semana, avisa se um site que você usa teve um vazamento de dados';

  @override
  String get securityUiBreachHow =>
      'Como funciona: o Tanooki Auth baixa a lista pública de vazamentos conhecidos do haveibeenpwned.com e compara com os sites salvos neste aparelho. Nada sobre você ou suas contas é enviado: é o mesmo download para todo mundo. Esta é a única vez que o app acessa a internet, além da sincronização e da compra do Premium.';

  @override
  String securityUiNoWebsite(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count das suas contas não têm site salvo, então não podem ser verificadas. Adicione um em ⋯ > Editar.',
      one: '1 das suas contas não tem site salvo, então não pode ser verificada. Adicione um em ⋯ > Editar.',
    );
    return '$_temp0';
  }

  @override
  String get securityUiCheckNow => 'Verificar agora';

  @override
  String get securityUiNoBreaches =>
      'Nenhum vazamento conhecido para os seus sites salvos.';

  @override
  String get securityUiBreached =>
      'Vazado. Se você criou sua senha antes disso, mude-a lá.';

  @override
  String securityUiBreachedOn(String date) {
    return 'Vazado em $date. Se você criou sua senha antes disso, mude-a lá.';
  }

  @override
  String securityUiBreachedLeaked(String data) {
    return 'Vazado. Dados expostos: $data. Se você criou sua senha antes disso, mude-a lá.';
  }

  @override
  String securityUiBreachedOnLeaked(String date, String data) {
    return 'Vazado em $date. Dados expostos: $data. Se você criou sua senha antes disso, mude-a lá.';
  }

  @override
  String get securityUiKitIntro =>
      'Se você perder este aparelho, é assim que você volta para suas contas. Cada item leva um minuto. Se ainda não adicionou nenhuma conta, adicione primeiro e volte aqui em Ajustes > Verificação de segurança.';

  @override
  String get securityUiKitBackupTitle => 'Fazer um backup';

  @override
  String get securityUiKitBackupBody =>
      'Um arquivo criptografado, protegido com uma frase secreta que você escolhe. Guarde em outro lugar que não seja este aparelho, como o iCloud Drive, o Google Drive ou um pen drive.';

  @override
  String get securityUiKitBackupButton => 'Fazer um backup';

  @override
  String get securityUiKitCodesTitle => 'Salve seus códigos de recuperação';

  @override
  String get securityUiKitCodesBody =>
      'Quando você ativa o login em dois fatores, a maioria dos sites te dá uma lista de códigos de recuperação de uso único. Adicione-os a cada conta em ⋯ > Códigos de recuperação, para que fiquem no seu backup também.';

  @override
  String get securityUiKitPaperTitle => 'Imprimir um backup em papel';

  @override
  String get securityUiKitPaperBody =>
      'Opcional. Uma página impressa com códigos QR funciona mesmo se todos os aparelhos sumirem. Guarde trancada: qualquer pessoa com ela pode gerar seus códigos.';

  @override
  String get securityUiKitPaperButton => 'Imprimir backup em papel';

  @override
  String get securityUiSkipForNow => 'Pular por enquanto';

  @override
  String get securityExtrasPrivacy =>
      'Sem cadastro, sem rastreamento. Suas chaves de configuração ficam criptografadas neste aparelho. O app só acessa a internet para: verificar o relógio (ele pergunta a hora ao servidor do Tanooki Auth, no máximo uma vez por hora enquanto há códigos na tela e quando você toca em \"Os códigos não funcionam?\"; nada sobre você ou suas contas é enviado), alertas de vazamento se você ativar (baixa a lista pública de vazamentos), sincronização, link com o celular e acesso de emergência se você configurar (só levam dados criptografados que o servidor não consegue ler), compra do Premium e opiniões que você decidir enviar (sua mensagem, seu e-mail se você digitar um, e a versão do app e o tipo de aparelho se você deixar marcado; nunca suas contas, códigos ou qualquer outra coisa do app). Os guias de 2FA abrem no seu navegador.';

  @override
  String get securityExtrasMonthlyBody =>
      'Seu resumo mensal de segurança está pronto. Abra o Tanooki Auth para ver.';

  @override
  String get securityExtrasNotificationsOffIos =>
      'As notificações estão desativadas para o Tanooki Auth. Ative nos Ajustes do iPhone, em Notificações, e tente de novo.';

  @override
  String get securityExtrasNotificationsOffMac =>
      'As notificações estão desativadas para o Tanooki Auth. Ative nos Ajustes do Sistema, em Notificações, e tente de novo.';

  @override
  String securityExtrasReminderFailed(String reason) {
    return 'Não foi possível criar o lembrete ($reason).';
  }

  @override
  String get securityExtrasRemindersUnavailable =>
      'Os lembretes ainda não estão disponíveis neste aparelho.';

  @override
  String securityExtrasDayTime(String day, String time) {
    return '$day, $time';
  }

  @override
  String get securityExtrasClearTitle => 'Limpar o histórico de atividade?';

  @override
  String get securityExtrasClearBody =>
      'Todos os registros são removidos deste aparelho. Suas contas não são tocadas.';

  @override
  String get securityExtrasActivityTitle => 'Histórico de atividade';

  @override
  String securityExtrasActivityPitch(int count) {
    return 'O histórico de atividade faz parte do Premium. Ele guarda as últimas $count vezes que um código foi copiado, preenchido em um site, digitado, mostrado como código QR ou exportado, só neste aparelho.';
  }

  @override
  String get securityExtrasNothingYet =>
      'Nada ainda. Copiar, preencher, digitar, mostrar um código QR ou exportar aparece aqui.';

  @override
  String get securityExtrasAllAccounts => 'Todas as contas';

  @override
  String get securityExtrasDeletedAccount => 'Uma conta apagada';

  @override
  String securityExtrasActivityLine(String kind, String what) {
    return '$kind: $what';
  }

  @override
  String get securityExtrasGetPremium => 'Obter o Premium';

  @override
  String get securityExtrasAddKey => 'Adicionar uma chave de segurança';

  @override
  String get securityExtrasAddKeyPremium =>
      'Adicionar uma chave de segurança (Premium)';

  @override
  String get securityExtrasAddKeyIos =>
      'Depois, quando pedir, encoste a chave no topo do iPhone ou conecte-a. Talvez você precise tocar nela duas vezes.';

  @override
  String get securityExtrasAddKeyOther =>
      'Depois, conecte a chave e toque nela quando piscar. Talvez você precise tocar duas vezes e digitar o PIN dela, se tiver um.';

  @override
  String get securityExtrasKeyName =>
      'Nome (para você diferenciar suas chaves)';

  @override
  String securityExtrasKeyAdded(String name) {
    return '\"$name\" adicionada. Agora você pode desbloquear o Tanooki Auth com ela neste aparelho.';
  }

  @override
  String securityExtrasKeyRemoved(String name) {
    return '\"$name\" removida. Ela não desbloqueia mais o Tanooki Auth.';
  }

  @override
  String get securityExtrasKeysTitle => 'Chaves de segurança';

  @override
  String securityExtrasKeysIntro(String usual) {
    return 'Uma chave de segurança (como uma YubiKey) pode desbloquear o Tanooki Auth no lugar de $usual. A chave guarda um segredo que nunca sai dela, e o app o usa para proteger a chave das suas contas. Se perder a chave, você ainda pode desbloquear do jeito de sempre.';
  }

  @override
  String securityExtrasKeyAddedOn(String day) {
    return 'Adicionada em $day';
  }

  @override
  String get securityExtrasLockOffNote =>
      'O bloqueio do app está desativado, então o app abre sem perguntar. Ative \"Bloquear o app\" ou um código de acesso em Ajustes para usar sua chave.';

  @override
  String get securityExtrasLockWordWindows =>
      'Windows Hello ou seu código de acesso';

  @override
  String get securityExtrasLockWordMac => 'Touch ID ou seu código de acesso';

  @override
  String get securityExtrasLockWordOther => 'Face ID ou seu código de acesso';

  @override
  String get securityLockImmediately => 'Imediatamente';

  @override
  String get securityLockAfter30s => 'Depois de 30 segundos';

  @override
  String get securityLockAfter1m => 'Depois de 1 minuto';

  @override
  String get securityLockAfter5m => 'Depois de 5 minutos';

  @override
  String get securityNumbersOnly => 'Use só números.';

  @override
  String securityAtLeastNumbers(int count) {
    return 'Use pelo menos $count números.';
  }

  @override
  String get securitySameNumber => 'Não use o mesmo número várias vezes.';

  @override
  String get securityNumbersInRow =>
      'Não use números em sequência como 123456.';

  @override
  String get securityPanicNeedsPasscode =>
      'Crie um código de acesso do app primeiro. O apagamento de emergência conta os códigos de acesso errados.';

  @override
  String get securityPanicNeedsBackup =>
      'Faça um backup primeiro (Ajustes > Exportar backup). O apagamento de emergência apaga todas as contas, então só é ativado se você fez um backup nos últimos 30 dias.';

  @override
  String get securityKeyDefaultName => 'Chave de segurança';

  @override
  String get securityKeyNotYours =>
      'Essa chave de segurança não é uma das que você adicionou ao Tanooki Auth neste aparelho.';

  @override
  String get securityKeyNotAvailable => 'Ainda não disponível neste aparelho.';

  @override
  String get securityKeyWindowsTooOld =>
      'Ainda não disponível nesta versão do Windows. Instale as atualizações mais recentes do Windows 11.';

  @override
  String get securityKeyIosTooOld =>
      'Precisa do iOS 26.4 ou mais novo. Atualize no app Ajustes e tente de novo.';

  @override
  String get securityKeyMacTooOld =>
      'Precisa do macOS 26.4 ou mais novo. Atualize nos Ajustes do Sistema e tente de novo.';

  @override
  String get securityKeyDidntWork =>
      'A chave de segurança não funcionou. Tente de novo.';

  @override
  String securityKeyDidntWorkWhy(String reason) {
    return 'A chave de segurança não funcionou ($reason). Tente de novo.';
  }

  @override
  String get securityKeyCanceled => 'Cancelado. Nada mudou.';

  @override
  String get securityKeyNoPrf =>
      'Esta chave de segurança não consegue desbloquear apps desse jeito (ela não tem o recurso \"hmac-secret\"). A série YubiKey 5 e a maioria das chaves FIDO2 dos últimos anos têm.';

  @override
  String get securityKeyNotAllowed =>
      'A chave de segurança não respondeu, ou não é uma das adicionadas aqui. Conecte-a (ou encoste no topo do celular) e toque nela quando piscar.';

  @override
  String get securityKeyNotAssociated =>
      'Esta cópia do Tanooki Auth ainda não pode usar chaves de segurança: a Apple precisa que o app esteja vinculado a auth.tanookistudios.com primeiro. Isso é com a gente, não com você.';

  @override
  String get securityKeyExists => 'Esta chave de segurança já foi adicionada.';

  @override
  String get securityKeyPin =>
      'A chave de segurança precisa do PIN, e ele não foi digitado. Tente de novo e digite o PIN da chave quando pedir.';

  @override
  String get securityKeyVaultKeyMissing =>
      'A chave que desbloqueia suas contas está faltando, então não dá para adicionar uma chave de segurança.';

  @override
  String get securityKeyNoneAdded =>
      'Nenhuma chave de segurança foi adicionada neste aparelho.';

  @override
  String get securityKeyBeforeReset =>
      'Essa chave de segurança foi adicionada antes de suas contas serem redefinidas, então não consegue abri-las. Remova e adicione de novo.';

  @override
  String get backupUiChoosePassphrase =>
      'Escolha uma frase secreta para o backup';

  @override
  String get backupUiPassphraseTitle => 'Frase secreta do backup';

  @override
  String get backupUiPassphraseWarning =>
      'Você vai precisar dela para restaurar o backup. Ninguém, nem nós, consegue recuperá-la se você esquecer. Anote em um lugar seguro.';

  @override
  String get backupUiPassphrase => 'Frase secreta';

  @override
  String get backupUiTypeAgain => 'Digite de novo';

  @override
  String get backupUiTooShort =>
      'Use pelo menos 8 caracteres. Algumas palavras aleatórias funcionam bem.';

  @override
  String get backupUiNoMatch => 'As duas frases secretas não são iguais.';

  @override
  String get backupUiTypePassphrase => 'Digite a frase secreta.';

  @override
  String get backupUiNothingToBackUp =>
      'Ainda não há contas para fazer backup.';

  @override
  String get backupUiEncrypting => 'Criptografando o backup…';

  @override
  String backupUiSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Backup de $count contas salvo.',
      one: 'Backup de 1 conta salvo.',
    );
    return '$_temp0';
  }

  @override
  String get backupUiNotABackup =>
      'Esse arquivo não é um backup do Tanooki Auth.';

  @override
  String get backupUiUnlocking => 'Desbloqueando o backup…';

  @override
  String backupUiImported(int count) {
    return '$count importadas.';
  }

  @override
  String backupUiImportedSkipped(int added, int skipped) {
    return '$added importadas, $skipped puladas.';
  }

  @override
  String backupUiImportedSkippedAlready(int added, int skipped) {
    return '$added importadas, $skipped puladas por já estarem na sua lista.';
  }

  @override
  String backupUiAdded(int count) {
    return '$count adicionadas.';
  }

  @override
  String backupUiAddedSkipped(int added, int skipped) {
    return '$added adicionadas, $skipped puladas.';
  }

  @override
  String backupUiAddedSkippedAlready(int added, int skipped) {
    return '$added adicionadas, $skipped puladas por já estarem na sua lista.';
  }

  @override
  String backupUiAlreadyInList(int count) {
    return '• $count já na sua lista';
  }

  @override
  String get backupUiImport => 'Importar';

  @override
  String backupUiImportFromGoogle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importar $count do Google Authenticator?',
      one: 'Importar 1 do Google Authenticator?',
    );
    return '$_temp0';
  }

  @override
  String get backupUiGoogleMoreCodes =>
      'Se o Google Authenticator mostrou mais de um código QR, escaneie cada um.';

  @override
  String get backupUiNothingToExport => 'Ainda não há contas para exportar.';

  @override
  String get backupUiPlainWhat =>
      'Isto salva cada chave de configuração como texto simples, para levar para outro app autenticador.';

  @override
  String get backupUiPlainTitle => 'Exportar sem criptografia?';

  @override
  String backupUiPlainBody(String what) {
    return '$what Qualquer pessoa que pegar este arquivo pode gerar seus códigos de login. Importe e depois apague na hora. Para um backup normal, use \"Exportar backup\".';
  }

  @override
  String get backupUiUnderstandExport => 'Entendi, exportar';

  @override
  String get backupUiNothingToPrint => 'Ainda não há contas para imprimir.';

  @override
  String get backupUiPaperTitle => 'Imprimir um backup em papel?';

  @override
  String get backupUiPaperBody =>
      'Isto cria um PDF com um código QR para cada conta, mais seus códigos de recuperação não usados. Qualquer pessoa que vir ou fotografar esse papel pode gerar seus códigos de login, para sempre, sem seu celular nem sua senha.\n\nImprima e depois apague o PDF. Guarde o papel em um lugar trancado, como um cofre ou junto com documentos importantes. Não mande por e-mail e não salve em uma pasta compartilhada.';

  @override
  String get backupUiUnderstandPdf => 'Entendi, criar o PDF';

  @override
  String get backupUiMakingPdf => 'Criando o PDF…';

  @override
  String get backupUiPdfReady =>
      'PDF pronto. Imprima e depois apague o arquivo.';

  @override
  String get backupUiWorksTitle => 'O backup funciona';

  @override
  String backupUiWorksBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Este backup abre direitinho e tem $count contas. Nada foi adicionado ou mudado.',
      one: 'Este backup abre direitinho e tem 1 conta. Nada foi adicionado ou mudado.',
    );
    return '$_temp0';
  }

  @override
  String get backupWrongVersion =>
      'Este backup foi feito por uma versão mais nova do Tanooki Auth. Atualize o app e tente de novo.';

  @override
  String get backupWrongPassphrase =>
      'Frase secreta errada, ou o arquivo de backup está danificado.';

  @override
  String get backupDamaged =>
      'O backup foi desbloqueado, mas o conteúdo está danificado.';

  @override
  String get paperBackupTitle => 'Backup em papel do Tanooki Auth';

  @override
  String paperBackupHeader(String date) {
    return 'Backup em papel do Tanooki Auth, $date';
  }

  @override
  String get paperBackupWarning =>
      'MANTENHA EM SEGREDO. Qualquer pessoa com este papel pode gerar seus códigos de login. Guarde em um lugar trancado; destrua quando fizer um novo. Para restaurar: em qualquer app autenticador, escolha \"Escanear código QR\" e escaneie cada código abaixo.';

  @override
  String paperBackupSetupKey(String key) {
    return 'Chave de configuração: $key';
  }

  @override
  String get paperBackupRecoveryCodes =>
      'Códigos de recuperação (cada um funciona uma vez):';

  @override
  String get autoBackupUiChooseFolderDialog =>
      'Escolha uma pasta para os backups automáticos';

  @override
  String autoBackupUiToday(String time) {
    return 'Hoje às $time';
  }

  @override
  String autoBackupUiYesterday(String time) {
    return 'Ontem às $time';
  }

  @override
  String autoBackupUiOnDay(String date, String time) {
    return '$date às $time';
  }

  @override
  String get autoBackupUiBackingUp => 'Fazendo backup…';

  @override
  String autoBackupUiBackedUp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Backup de $count contas feito.',
      one: 'Backup de 1 conta feito.',
    );
    return '$_temp0';
  }

  @override
  String get autoBackupUiCouldntUseFolder =>
      'Não foi possível usar essa pasta.';

  @override
  String autoBackupUiCouldntUseFolderWhy(String reason) {
    return 'Não foi possível usar essa pasta. $reason';
  }

  @override
  String get autoBackupUiTurnOffTitle => 'Desativar os backups automáticos?';

  @override
  String get autoBackupUiTurnOffBody =>
      'Os backups que já estão na pasta continuam lá. A frase secreta do backup é esquecida, então você vai escolher uma nova se ativar isto de novo.';

  @override
  String get autoBackupUiTitle => 'Backups automáticos';

  @override
  String get autoBackupUiTitlePremium => 'Backups automáticos (Premium)';

  @override
  String autoBackupUiIntro(int count) {
    return 'Uma vez por dia, o Tanooki Auth salva um backup criptografado em uma pasta que você escolhe. Escolha sua pasta do iCloud Drive, Google Drive ou Dropbox e seus backups ficam fora deste aparelho também. Os $count mais novos são mantidos; os mais antigos são apagados.\n\nRestaure um em Ajustes > Importar backup com a sua frase secreta do backup.';
  }

  @override
  String get autoBackupUiLastFailed => 'O último backup automático falhou';

  @override
  String get autoBackupUiChooseFolder => 'Escolher uma pasta';

  @override
  String get autoBackupUiBackupFolder => 'Pasta de backup';

  @override
  String get autoBackupUiNoBackupYet => 'Nenhum backup ainda';

  @override
  String autoBackupUiLastBackup(String when) {
    return 'Último backup: $when';
  }

  @override
  String get autoBackupUiBackUpNow => 'Fazer backup agora';

  @override
  String get autoBackupUiChangeFolder => 'Mudar pasta';

  @override
  String get autoBackupUiOffSubtitle =>
      'Desativado. Um backup criptografado diário no iCloud Drive, Google Drive, Dropbox ou em qualquer pasta.';

  @override
  String autoBackupUiOnNoBackup(String folder) {
    return 'Ativado, em $folder. Nenhum backup ainda.';
  }

  @override
  String autoBackupUiOnLast(String folder, String when) {
    return 'Ativado, em $folder. Último backup: $when.';
  }

  @override
  String get autoBackupFolderGone =>
      'A pasta de backup sumiu. Ela pode ter sido apagada, renomeada fora do app, ou o disco dela foi desconectado. Escolha a pasta de novo.';

  @override
  String get autoBackupPermissionLost =>
      'O Tanooki Auth não tem mais permissão para gravar na pasta de backup. Escolha a pasta de novo para devolver a permissão.';

  @override
  String get autoBackupDiskFull =>
      'O disco da pasta de backup está cheio. Libere espaço e toque em Fazer backup agora.';

  @override
  String get autoBackupOther =>
      'Não foi possível salvar o backup. Toque em Fazer backup agora para tentar de novo.';

  @override
  String autoBackupOtherWhy(String reason) {
    return 'Não foi possível salvar o backup ($reason). Toque em Fazer backup agora para tentar de novo.';
  }

  @override
  String get importUiDeleteNote =>
      'Quando terminar, apague o arquivo exportado: qualquer pessoa que pegá-lo pode gerar seus códigos.';

  @override
  String get importUiStepsAegis =>
      'No Aegis, no seu celular Android:\n\n1. Toque em ⋮, depois em Configurações e em \"Importar e exportar\".\n2. Toque em \"Exportar\" e escolha \"Aegis (.JSON)\".\n3. Deixe \"Criptografar o cofre\" ativado se quiser; você vai digitar essa senha aqui.\n4. Salve o arquivo em um lugar que este aparelho consiga abrir (por exemplo, no Google Drive ou mande por e-mail para você mesmo).\n\nDepois escolha esse arquivo aqui.';

  @override
  String get importUiStepsTwoFas =>
      'No 2FAS:\n\n1. Abra Configurações, depois \"Backup do 2FAS\".\n2. Toque em \"Exportar para arquivo\". Se pedir uma senha, você vai digitar a mesma aqui.\n3. Salve o arquivo .2fas em um lugar que este aparelho consiga abrir.\n\nDepois escolha esse arquivo aqui.';

  @override
  String get importUiStepsAuthy =>
      'O Authy não tem botão de exportar, e o Authy para computador foi descontinuado em 2024.\n\nSe você já tirou suas contas com uma ferramenta como a \"authy-export\", escolha o arquivo que ela criou (um arquivo .json, ou uma lista .txt de links otpauth://).\n\nSe não, o jeito seguro é uma conta de cada vez: entre em cada site, desative e ative de novo o login em dois fatores, e escaneie o novo código QR com o Tanooki Auth. Mantenha o Authy até todas as contas funcionarem aqui.';

  @override
  String get importUiStepsBitwarden =>
      'No Bitwarden (site ou app para computador):\n\n1. Vá em Ferramentas, depois em \"Exportar cofre\".\n2. Escolha \".json\" ou \".csv\". Não \"criptografado\".\n3. Salve o arquivo.\n\nDepois escolha esse arquivo aqui. Só os logins com chave de autenticação são trazidos; suas senhas são ignoradas.';

  @override
  String get importUiStepsOnePassword =>
      'No app 1Password para Mac ou Windows:\n\n1. Clique em Arquivo, depois em Exportar e escolha sua conta.\n2. Escolha \"CSV\" como formato e salve.\n\nDepois escolha esse arquivo aqui. Só os itens com senha de uso único são trazidos; suas senhas são ignoradas.';

  @override
  String get importUiStepsApple =>
      'Você precisa de um Mac para isto; o iPhone não consegue salvar o arquivo.\n\nEm um Mac com macOS Sequoia ou mais novo:\n1. Abra o app Senhas.\n2. Na barra de menus, clique em Arquivo, depois em \"Exportar Todas as Senhas…\".\n3. Clique em \"Exportar Senhas\", digite a senha do Mac se pedir, e salve o arquivo.\n\nEm um Mac mais antigo: abra o Safari, depois Safari > Ajustes > Senhas, clique no botão ⋯ e escolha \"Exportar Todas as Senhas…\".\n\nDepois escolha esse arquivo aqui. Só os itens com código de verificação são trazidos; suas senhas são ignoradas.';

  @override
  String get importUiStepsMicrosoft =>
      'O Microsoft Authenticator não consegue exportar suas contas, então elas não podem ser trazidas de uma vez.\n\nPara cada conta:\n1. Entre nesse site em um computador.\n2. Encontre os ajustes de segurança ou de dois fatores.\n3. Desative e ative de novo o login em dois fatores (ou escolha \"adicionar um novo app autenticador\").\n4. Escaneie o novo código QR com o Tanooki Auth e digite o código que ele mostrar para terminar.\n\nMantenha o Microsoft Authenticator até todas as contas funcionarem no Tanooki Auth. Sua própria conta Microsoft também pode usar o Tanooki Auth: adicione em account.microsoft.com, em Segurança.';

  @override
  String get importUiTitle => 'Trazer de outro app';

  @override
  String get importUiCantExport => 'Não exporta: como trazer cada conta';

  @override
  String get importUiFromExportFile => 'De um arquivo exportado';

  @override
  String importUiMoveFrom(String app) {
    return 'Trazer do $app';
  }

  @override
  String get importUiGotIt => 'Entendi';

  @override
  String get importUiPickFile => 'Escolher arquivo';

  @override
  String get importUiCouldntRead => 'Não foi possível ler esse arquivo.';

  @override
  String importUiReading(String app) {
    return 'Lendo o arquivo exportado do $app…';
  }

  @override
  String get importUiNoAccountsInFile =>
      'Não havia contas de dois fatores nesse arquivo.';

  @override
  String importUiImportFrom(int count, String app) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Importar $count do $app?',
      one: 'Importar 1 do $app?',
    );
    return '$_temp0';
  }

  @override
  String importUiExportPassword(String app) {
    return 'Senha da exportação do $app';
  }

  @override
  String get importUiPasswordHint => 'A senha que você escolheu ao exportar';

  @override
  String importersNotAnExport(String app) {
    return 'Esse arquivo não é uma exportação do $app.';
  }

  @override
  String importersLine(String line, String problem) {
    return 'Linha $line: $problem';
  }

  @override
  String get importersEmpty => 'Esse arquivo está vazio.';

  @override
  String get importersNotAuthy => 'Esse arquivo não é uma exportação do Authy.';

  @override
  String get importersAnAccount => 'Uma conta';

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
      'Esta exportação do Aegis está protegida com senha.';

  @override
  String get importersAegisBiometricOnly =>
      'Esta exportação do Aegis só pode ser aberta com a digital no celular que a criou. No Aegis, exporte de novo e escolha uma senha.';

  @override
  String get importersAegisWrongPassword =>
      'Senha errada para esta exportação do Aegis.';

  @override
  String get importersAegisDamaged =>
      'A exportação do Aegis foi desbloqueada, mas o conteúdo está danificado.';

  @override
  String get importersNotAegis => 'Esse arquivo não é uma exportação do Aegis.';

  @override
  String importersUnsupportedType(String type) {
    return 'usa códigos $type, que o Tanooki Auth não suporta';
  }

  @override
  String get importersNotTwoFas => 'Esse arquivo não é um backup do 2FAS.';

  @override
  String get importersTwoFasPassword =>
      'Este backup do 2FAS está protegido com senha.';

  @override
  String get importersTwoFasDamaged => 'Este backup do 2FAS está danificado.';

  @override
  String get importersTwoFasWrongPassword =>
      'Senha errada para este backup do 2FAS.';

  @override
  String get importersBitwardenEncrypted =>
      'Essa exportação do Bitwarden está criptografada. No Bitwarden, exporte de novo e escolha o formato \".json\" (não \"criptografado\").';

  @override
  String get importersOnePux =>
      'Isso parece um arquivo .1pux do 1Password. No 1Password, exporte de novo e escolha CSV.';

  @override
  String importersNoCodeColumn(String app) {
    return 'Esse arquivo não tem uma coluna de código de uso único, então não é uma exportação do $app com códigos.';
  }

  @override
  String importersCantReadCode(String reason) {
    return 'tem um código de uso único que o Tanooki Auth não consegue ler ($reason)';
  }

  @override
  String get importersNoSecret => 'não tem chave secreta';

  @override
  String get importersBadSecret => 'tem uma chave secreta inválida';

  @override
  String importersUnsupportedDigits(int count) {
    return 'usa códigos de $count dígitos, que o Tanooki Auth não suporta';
  }

  @override
  String get importersBadPeriod => 'tem um período de tempo com defeito';

  @override
  String importersUnsupportedAlgorithm(String algorithm) {
    return 'usa o algoritmo $algorithm, que o Tanooki Auth não suporta';
  }

  @override
  String get exportUiTitle => 'Levar para outro app';

  @override
  String get exportUiAegisLocked => 'Aegis, com senha';

  @override
  String get exportUiAegisLockedSub =>
      'O mais seguro. O Aegis pede a senha quando você importa.';

  @override
  String get exportUiAegisPlain => 'Aegis, sem criptografia';

  @override
  String get exportUiAegisPlainSub =>
      'Para apps que leem arquivos do Aegis, mas não abrem os protegidos.';

  @override
  String get exportUiTwoFasSub => 'Um arquivo .2fas sem senha.';

  @override
  String get exportUiGoogleSub =>
      'Códigos QR para escanear com o Google Authenticator.';

  @override
  String get exportUiLinks => 'Links de configuração (texto simples)';

  @override
  String get exportUiLinksSub =>
      'Um link otpauth:// por linha, para qualquer outro app.';

  @override
  String get exportUiConfirmReason => 'Exportar suas contas';

  @override
  String get exportUiEncryptingAegis => 'Criptografando para o Aegis…';

  @override
  String get exportUiAegisPlainWhat =>
      'Isto salva cada chave de configuração em um arquivo do Aegis sem criptografia.';

  @override
  String get exportUiTwoFasWhat =>
      'Isto salva cada chave de configuração em um arquivo do 2FAS sem senha.';

  @override
  String get exportUiGoogleTitle =>
      'Mostrar códigos QR para o Google Authenticator?';

  @override
  String get exportUiGoogleBody =>
      'A próxima tela mostra códigos QR com todas as chaves de configuração. Qualquer pessoa que vir ou fotografar esses códigos pode gerar seus códigos de login. Faça isso em um lugar reservado.\n\nNo Google Authenticator: toque em +, depois em \"Ler código QR\", e escaneie cada código, um de cada vez.';

  @override
  String get exportUiShowCodes => 'Mostrar os códigos';

  @override
  String exportUiExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count contas exportadas. Importe o arquivo no outro app e depois apague-o.',
      one: '1 conta exportada. Importe o arquivo no outro app e depois apague-o.',
    );
    return '$_temp0';
  }

  @override
  String get exportUiNoneForGoogle =>
      'Nenhuma das suas contas pode ir para o Google Authenticator.';

  @override
  String get exportUiScanThisCode => 'Escaneie este código';

  @override
  String exportUiCodeOf(int n, int total) {
    return 'Código $n de $total';
  }

  @override
  String get exportUiNextCode => 'Próximo código';

  @override
  String exportUiLeftOut(int count) {
    return 'Deixadas de fora ($count). O Google Authenticator não consegue gerar estes códigos, então adicione-os a outro app:';
  }

  @override
  String get appIconClassic => 'Clássico';

  @override
  String get appIconPink => 'Rosa Pastel';

  @override
  String get appIconBlue => 'Azul Pastel';

  @override
  String get appIconLavender => 'Lavanda';

  @override
  String get appIconMint => 'Menta';

  @override
  String get appIconMidnight => 'Meia-noite';

  @override
  String get appIconSunset => 'Pôr do sol';

  @override
  String get appIconSpooky => 'Assustador (outono)';

  @override
  String get appIconCozy => 'Aconchegante (inverno)';

  @override
  String get appIconSpring => 'Primavera';

  @override
  String get serverBrowserExtension => 'Extensão do navegador';

  @override
  String get serverBadRequest => 'O Tanooki Auth não entendeu esse pedido.';

  @override
  String get serverLocked =>
      'O Tanooki Auth está bloqueado. Desbloqueie e tente de novo.';

  @override
  String get serverNotPaired => 'Este app não está pareado com o Tanooki Auth.';

  @override
  String get serverNotFound => 'Essa conta não está mais no Tanooki Auth.';

  @override
  String get serverRateLimited => 'Pedidos demais.';

  @override
  String get serverDenied =>
      'Não permitido: esta conta pergunta antes, e o Tanooki Auth não foi desbloqueado para ela.';

  @override
  String get serverUnknownScreen => 'Tela desconhecida.';

  @override
  String get serverNoWebsite => 'Nenhum site informado.';

  @override
  String serverUnknownRequest(String type) {
    return 'Pedido desconhecido \"$type\".';
  }

  @override
  String get serverPairingTimedOut =>
      'O pareamento expirou ou foi fechado. Comece o pareamento de novo.';

  @override
  String get serverThreeWrongCodes =>
      'Três códigos errados. Comece o pareamento de novo.';

  @override
  String get serverWrongCode =>
      'Esse código não confere. Confira o código mostrado no Tanooki Auth.';

  @override
  String get serverNoLink => 'Nenhum link otpauth:// foi enviado.';

  @override
  String get serverAlreadyThere => 'Essa conta já está no Tanooki Auth.';

  @override
  String get serverAlreadyThereMany => 'Essas contas já estão no Tanooki Auth.';

  @override
  String get autoBackupNotSupported => 'não suportado neste aparelho';

  @override
  String homeProveCopy(String name) {
    return 'Copiar o código de $name';
  }

  @override
  String homeProveReadAloud(String name) {
    return 'Ler em voz alta o código de $name';
  }

  @override
  String homeProveEdit(String name) {
    return 'Editar $name';
  }

  @override
  String homeProveShare(String name) {
    return 'Compartilhar $name';
  }

  @override
  String homeProveRecoveryCodes(String name) {
    return 'Ver os códigos de recuperação de $name';
  }

  @override
  String homeCopied(String name) {
    return 'Código de $name copiado. A área de transferência é limpa em 30 segundos.';
  }

  @override
  String get homeEditAccount => 'Editar conta';

  @override
  String homeShowQrFor(String name) {
    return 'Mostrar o código QR de $name';
  }

  @override
  String homeMovedToTrash(String name) {
    return '$name foi para a Lixeira. Você pode restaurar em Ajustes por 30 dias.';
  }

  @override
  String get homeUndo => 'Desfazer';

  @override
  String homeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contas',
      one: '1 conta',
    );
    return '$_temp0';
  }

  @override
  String homeAddTagTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Adicionar uma etiqueta a $count contas',
      one: 'Adicionar uma etiqueta a 1 conta',
    );
    return '$_temp0';
  }

  @override
  String get homeTagHint => 'Etiqueta (ex.: trabalho)';

  @override
  String get homeAddTag => 'Adicionar etiqueta';

  @override
  String homeTagged(int count, String tag) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contas receberam a etiqueta \"$tag\".',
      one: '1 conta recebeu a etiqueta \"$tag\".',
    );
    return '$_temp0';
  }

  @override
  String homeMoveToFolderTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mover $count contas para uma pasta',
      one: 'Mover 1 conta para uma pasta',
    );
    return '$_temp0';
  }

  @override
  String get homeNoFolder => 'Nenhuma pasta';

  @override
  String get homeNewFolderHint => 'Ou uma nova pasta (ex.: Trabalho)';

  @override
  String get homeMoveToNewFolder => 'Mover para nova pasta';

  @override
  String homeTookOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contas foram tiradas das pastas.',
      one: '1 conta foi tirada da pasta.',
    );
    return '$_temp0';
  }

  @override
  String homeMovedTo(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contas movidas para $folder.',
      one: '1 conta movida para $folder.',
    );
    return '$_temp0';
  }

  @override
  String homeAddedToFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contas adicionadas aos favoritos.',
      one: '1 conta adicionada aos favoritos.',
    );
    return '$_temp0';
  }

  @override
  String homeRemovedFromFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contas removidas dos favoritos.',
      one: '1 conta removida dos favoritos.',
    );
    return '$_temp0';
  }

  @override
  String homeBulkTrashed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count contas foram para a Lixeira. Você pode restaurar em Ajustes por 30 dias.',
      one: '1 conta foi para a Lixeira. Você pode restaurar em Ajustes por 30 dias.',
    );
    return '$_temp0';
  }

  @override
  String get homeDoneSelecting => 'Concluir seleção';

  @override
  String get homeTapToSelect => 'Toque nas contas para selecionar';

  @override
  String homeSelectedCount(int count) {
    return '$count selecionadas';
  }

  @override
  String get homeSelectNone => 'Selecionar nenhuma';

  @override
  String get homeSelectAll => 'Selecionar todas';

  @override
  String get homeAddATag => 'Adicionar uma etiqueta';

  @override
  String get homeMoveToFolder => 'Mover para pasta';

  @override
  String get homeRemoveFromFavorites => 'Remover dos favoritos';

  @override
  String get homeAddToFavorites => 'Adicionar aos favoritos';

  @override
  String get homeMoveToTrash => 'Mover para a Lixeira';

  @override
  String get homeSelectFirst =>
      'Selecione algumas contas primeiro: toque nelas na lista.';

  @override
  String homeSectionOpen(String name, String accounts) {
    return '$name, $accounts, toque para recolher';
  }

  @override
  String homeSectionClosed(String name, String accounts) {
    return '$name, $accounts, toque para mostrar';
  }

  @override
  String get homeSearchHint => 'Buscar contas ou sites…';

  @override
  String get homeAllTags => 'Todas';

  @override
  String get homeNoAccountsYet =>
      'Nenhuma conta ainda.\nAdicione uma para escanear um código QR de configuração.';

  @override
  String get homeNoTagMatches => 'Nenhuma conta com esta etiqueta.';

  @override
  String get homeNoSearchMatches => 'Nenhuma conta corresponde à sua busca.';

  @override
  String get homeSelectAccounts => 'Selecionar contas';

  @override
  String get homeSettings => 'Ajustes';

  @override
  String get homeAddAccount => 'Adicionar conta';

  @override
  String get homeAccounts => 'Contas';

  @override
  String get homeYourAccounts => 'Suas contas';

  @override
  String get homeSelect => 'Selecionar';

  @override
  String get homeKeysTouch =>
      'Toque (Copiar) · Enter (Copiar) · Setas (Navegar)';

  @override
  String get homeKeysClick =>
      'Clique (Copiar) · Enter (Copiar) · Setas (Navegar)';

  @override
  String get homePickOnLeft => 'Escolha uma conta à esquerda para vê-la aqui.';

  @override
  String homeQrFor(String name) {
    return 'Código QR de $name';
  }

  @override
  String get homeQrWarning =>
      'Escaneie isto com outro app autenticador para adicionar a mesma conta lá. Qualquer pessoa que vir ou fotografar pode gerar seus códigos, então mantenha em segredo.';

  @override
  String homeVersionNote(Object version) {
    return 'v$version · fica neste aparelho';
  }

  @override
  String homeSelectName(String name) {
    return 'Selecionar $name';
  }

  @override
  String get homeMore => 'Mais';

  @override
  String get homeRecoveryCodes => 'Códigos de recuperação';

  @override
  String homeRecoveryCodesLeft(int count) {
    return 'Códigos de recuperação ($count restantes)';
  }

  @override
  String get homeShareSecurely => 'Compartilhar com segurança';

  @override
  String get homeShowQr => 'Mostrar código QR';

  @override
  String get homeMoveEarlier => 'Mover para cima';

  @override
  String get homeMoveLater => 'Mover para baixo';

  @override
  String homeNextCodeShort(String code) {
    return 'Próximo $code';
  }

  @override
  String get homeNextCode => 'Próximo código';

  @override
  String get homeFavorite => 'Favorito';

  @override
  String get homeCodeHiddenAsk =>
      'Código escondido até você confirmar que é você';

  @override
  String get homeCodeHidden => 'Código escondido';

  @override
  String homeNextCodeSpoken(String code) {
    return 'Próximo código $code';
  }

  @override
  String homeKindTotp(int count, int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dígitos',
      one: '1 dígito',
    );
    return 'TOTP · $_temp0 · ${seconds}s';
  }

  @override
  String homeKindSteam(int seconds) {
    return 'Steam · 5 caracteres · ${seconds}s';
  }

  @override
  String homeKindHotp(int count, String counter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dígitos',
      one: '1 dígito',
    );
    return 'HOTP · $_temp0 · #$counter';
  }

  @override
  String get homeAccountHeading => 'Conta';

  @override
  String get homeHintUnselect => 'desmarcar';

  @override
  String get homeHintSelect => 'selecionar';

  @override
  String get homeHintCopy => 'copiar o código';

  @override
  String get homeReadCodeAloud => 'Ler o código em voz alta';

  @override
  String get homeMoreOptions => 'Mais opções';

  @override
  String get mainPairRaycastTitle => 'Parear com o Raycast';

  @override
  String get mainPairRaycastBody => 'Digite este código no Raycast:';

  @override
  String get mainPairRaycastWarning =>
      'Só faça isto se você mesmo acabou de começar o pareamento no Raycast.';

  @override
  String get mainPairAlfredTitle => 'Parear com o Alfred';

  @override
  String get mainPairAlfredBody => 'Digite 2fa-pair e este código no Alfred:';

  @override
  String get mainPairAlfredWarning =>
      'Só faça isto se você mesmo acabou de digitar 2fa-pair no Alfred.';

  @override
  String get mainPairPowerToysTitle => 'Parear com o PowerToys';

  @override
  String get mainPairPowerToysBody =>
      'Digite este código na Paleta de Comandos do PowerToys:';

  @override
  String get mainPairPowerToysWarning =>
      'Só faça isto se você mesmo acabou de começar o pareamento no PowerToys.';

  @override
  String get mainPairBrowserTitle => 'Parear com seu navegador';

  @override
  String get mainPairBrowserBody =>
      'Digite este código na extensão de navegador do Tanooki Auth:';

  @override
  String get mainPairBrowserWarning =>
      'Só faça isto se você mesmo acabou de clicar em \"Parear\" na extensão.';

  @override
  String mainSendCodeTo(String name, String client) {
    return 'Enviar o código de $name para $client';
  }

  @override
  String mainWrongPasscodeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Código de acesso errado. Mais $count tentativas erradas apagam tudo.',
      one: 'Código de acesso errado. Mais 1 tentativa errada apaga tudo.',
    );
    return '$_temp0';
  }

  @override
  String get mainWrongPasscode => 'Código de acesso errado.';

  @override
  String get mainBiometricWindows => 'Windows Hello';

  @override
  String get mainBiometricMac => 'Touch ID';

  @override
  String get mainBiometricOther => 'Face ID ou digital';

  @override
  String get mainLockTitle => 'Bloquear o Tanooki Auth?';

  @override
  String get mainLockBody =>
      'Peça seu rosto, sua digital ou seu código de acesso quando o app abrir, para que alguém com seu celular desbloqueado não consiga ler seus códigos. Você pode mudar isso depois em Ajustes.';

  @override
  String get mainTurnOnLock => 'Ativar bloqueio';

  @override
  String get mainUnlockReason => 'Desbloquear o Tanooki Auth';

  @override
  String get mainStartOverTitle => 'Começar um cofre novo e vazio?';

  @override
  String get mainStartOverBody =>
      'Isto substitui para sempre o que restou das suas contas antigas. Só faça isto se você não tem nenhum backup para restaurar, ou se já desativou o login em dois fatores nesses sites.';

  @override
  String get mainEraseStartOver => 'Apagar e começar de novo';

  @override
  String get mainRestoreFromBackup => 'Restaurar de um backup';

  @override
  String get mainStartNewVault => 'Começar um cofre novo e vazio';

  @override
  String get mainLocked => 'O Tanooki Auth está bloqueado';

  @override
  String mainUseBiometric(String method) {
    return 'Usar $method';
  }

  @override
  String get mainUseSecurityKey => 'Usar chave de segurança';

  @override
  String homeHidesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Esconde em $count segundos',
      one: 'Esconde em 1 segundo',
    );
    return '$_temp0';
  }

  @override
  String homeCardsMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      'm1': 'janeiro',
      'm2': 'fevereiro',
      'm3': 'março',
      'm4': 'abril',
      'm5': 'maio',
      'm6': 'junho',
      'm7': 'julho',
      'm8': 'agosto',
      'm9': 'setembro',
      'm10': 'outubro',
      'm11': 'novembro',
      'm12': 'dezembro',
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
      'Negado. A pessoa não pode abrir suas contas. Ela pode pedir de novo depois, e você será perguntado de novo.';

  @override
  String get homeCardsClockRight =>
      'Seu relógio está certo agora. Os códigos devem funcionar.';

  @override
  String get homeCardsCheckAgain => 'Verificar de novo';

  @override
  String get homeCardsYourContact => 'Seu contato de emergência';

  @override
  String homeCardsEmergencyWaiting(String who, String left, String day) {
    return '$who pediu acesso de emergência às suas contas. A menos que você negue, a pessoa pode abrir uma cópia em $left ($day).';
  }

  @override
  String homeCardsEmergencyReleased(String who) {
    return '$who pediu acesso de emergência e a espera de 7 dias acabou, então a pessoa já pode abrir uma cópia das suas contas. Negue para impedir.';
  }

  @override
  String get homeCardsBackupNudge =>
      'Suas contas mudaram desde o último backup. Um arquivo de backup é como você as recupera se este aparelho for perdido.';

  @override
  String get homeCardsBackUpNow => 'Fazer backup agora';

  @override
  String homeCardsSummaryNew(int count, String month) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seu resumo de $month: $count contas novas.',
      one: 'Seu resumo de $month: 1 conta nova.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryNoBackup => 'Nenhum backup ainda.';

  @override
  String homeCardsSummaryLastBackup(String day) {
    return 'Último backup em $day.';
  }

  @override
  String get homeCardsSummaryAllCodes =>
      'Todas as contas têm códigos de recuperação.';

  @override
  String homeCardsSummaryMissingCodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contas sem códigos de recuperação.',
      one: '1 conta sem códigos de recuperação.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryCheckupGood =>
      'Verificação de segurança: tudo certo.';

  @override
  String homeCardsSummaryCheckupFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Verificação de segurança: $count coisas para corrigir.',
      one: 'Verificação de segurança: 1 coisa para corrigir.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsOpenCheckup => 'Abrir verificação';

  @override
  String get quickPickSelf =>
      'O Tanooki Auth ainda estava na frente, então nada foi digitado. Clique na caixa que você quer preencher e use o ícone da barra de menus de novo.';

  @override
  String quickPickTypeFailed(String reason) {
    return 'Não foi possível digitar o código ($reason). Copie-o.';
  }

  @override
  String get quickPickTypeUnavailable =>
      'Digitar códigos não está disponível neste computador. Copie-o.';

  @override
  String quickPickUseCodeFor(String name) {
    return 'Usar o código de $name';
  }

  @override
  String get quickPickAllowTitle => 'Permita que o Tanooki Auth digite';

  @override
  String get quickPickAllowBody =>
      'Para digitar um código em outro app, o Mac precisa deixar o Tanooki Auth apertar teclas por você.\n\n1. Clique em \"Abrir Ajustes do Sistema\" abaixo.\n2. Você vai ver uma lista chamada Acessibilidade. Encontre o Tanooki Auth e ative a chave dele (azul).\n3. Se o Mac pedir sua senha ou o Touch ID, informe.\n4. Volte aqui e clique em Digitar de novo.\n\nO Tanooki Auth só aperta teclas quando você clica em Digitar, e só digita o código.';

  @override
  String get quickPickOpenSystemSettings => 'Abrir Ajustes do Sistema';

  @override
  String get quickPickTitle => 'Escolha rápida';

  @override
  String get quickPickSearch => 'Buscar contas';

  @override
  String get quickPickLinuxNote =>
      'Digitar códigos em outros apps não está disponível no Linux. Clique em uma conta para copiar o código.';

  @override
  String get quickPickNoMatches => 'Nenhuma conta encontrada';

  @override
  String get quickPickAsksFirst => '••• •••  (pergunta antes)';

  @override
  String get quickPickHiddenAsks => 'Código escondido, pergunta antes';

  @override
  String get quickPickType => 'Digitar';

  @override
  String get codeViewRing => 'Anel';

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
      other: 'Código $code, faltam $count segundos',
      one: 'Código $code, falta 1 segundo',
    );
    return '$_temp0';
  }

  @override
  String get codeViewReadAloud => 'Ler o código em voz alta';

  @override
  String codeViewSecondsShort(int count) {
    return '${count}s';
  }

  @override
  String get codeViewColorBlue => 'Azul';

  @override
  String get codeViewColorPurple => 'Roxo';

  @override
  String get codeViewColorPink => 'Rosa';

  @override
  String get codeViewColorRed => 'Vermelho';

  @override
  String get codeViewColorOrange => 'Laranja';

  @override
  String get codeViewColorGold => 'Dourado';

  @override
  String get codeViewColorGreen => 'Verde';

  @override
  String get codeViewColorTeal => 'Azul-petróleo';

  @override
  String get codeViewColorGray => 'Cinza';

  @override
  String trashRestored(String name) {
    return '$name voltou para a sua lista.';
  }

  @override
  String trashDeleteTitle(String name) {
    return 'Apagar $name para sempre?';
  }

  @override
  String get trashDeleteBody =>
      'Isso não pode ser desfeito. Antes de apagar, desative o login em dois fatores nesse site ou confira se você tem os códigos de recuperação, senão você pode ficar sem acesso.';

  @override
  String get trashDeleteForGood => 'Apagar para sempre';

  @override
  String get trashTitle => 'Lixeira';

  @override
  String get trashEmpty =>
      'A Lixeira está vazia.\nContas apagadas ficam aqui por 30 dias.';

  @override
  String get trashNote =>
      'Contas apagadas ficam aqui por 30 dias, depois são removidas para sempre.';

  @override
  String get trashRemovedNextOpen => 'Removida na próxima vez que o app abrir';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'faltam $count dias',
      one: 'falta 1 dia',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => 'Restaurar';

  @override
  String get recoveryAddTitle => 'Adicionar códigos de recuperação';

  @override
  String get recoveryPasteHint =>
      'Cole os códigos que o site te deu, um por linha';

  @override
  String get recoveryNoneNew =>
      'Nenhum código novo encontrado no que você colou.';

  @override
  String recoveryAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count códigos adicionados.',
      one: '1 código adicionado.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryCopiedUsed =>
      'Copiado. Atenção: você marcou este código como usado, então ele provavelmente não vai funcionar de novo.';

  @override
  String get recoveryCopied =>
      'Copiado. A área de transferência é limpa em 30 segundos. Marque como usado depois de entrar.';

  @override
  String get recoveryRemoveTitle => 'Remover este código?';

  @override
  String recoveryRemoveBody(String code) {
    return '$code\n\nSó remova se o site não aceita mais.';
  }

  @override
  String recoveryTitle(String name) {
    return 'Códigos de recuperação de $name';
  }

  @override
  String get recoveryAddCodes => 'Adicionar códigos';

  @override
  String get recoveryIntro =>
      'Quando você ativa o login em dois fatores, a maioria dos sites também te dá uma lista de códigos reserva. Cada um te deixa entrar uma vez se você perder este app. Cole-os aqui para que fiquem guardados com a conta.';

  @override
  String recoveryUnusedOf(String unused, int total) {
    return '$unused de $total não usados. Toque em um código para copiar e marque-o depois de usar.';
  }

  @override
  String get recoveryUsed => 'Usado';

  @override
  String get detailsEditAccount => 'Editar conta';

  @override
  String get detailsCopyCode => 'Copiar código';

  @override
  String get detailsReadAloud => 'Ler em voz alta';

  @override
  String get detailsFolderAndTags => 'Pasta e etiquetas';

  @override
  String get detailsWebsites => 'Sites';

  @override
  String get detailsNotes => 'Notas';

  @override
  String get detailsNotesHidden => 'Escondidas até você confirmar que é você.';

  @override
  String get detailsNoNotes => 'Sem notas. Adicione algumas em Editar.';

  @override
  String get accountSortCustom => 'Personalizada (arraste para organizar)';

  @override
  String get accountSortRecent => 'Usadas recentemente';

  @override
  String get accountSortName => 'A a Z';

  @override
  String get activityCopied => 'Copiado';

  @override
  String get activityFilled => 'Preenchido';

  @override
  String get activityTyped => 'Digitado';

  @override
  String get activityShownQr => 'Código QR mostrado';

  @override
  String get activityExported => 'Exportado';

  @override
  String get activityPlaceThisApp => 'Este app';

  @override
  String get activityPlaceBackupFile => 'Arquivo de backup';

  @override
  String get activityPlaceSetupLinks => 'Arquivo de links de configuração';

  @override
  String get activityPlacePaperBackup => 'PDF de backup em papel';

  @override
  String get activityPlaceGoogleQr => 'Códigos QR do Google Authenticator';

  @override
  String totpBadCharacter(String char) {
    return 'Não é uma chave secreta base32 válida (caractere inválido \"$char\")';
  }

  @override
  String get totpEmpty => 'A chave secreta está vazia';

  @override
  String get vaultFileMissing =>
      'O arquivo das suas contas está faltando. Se você tem um backup, restaure-o. Se não, pode começar um cofre novo e vazio.';

  @override
  String get vaultKeyMissing =>
      'A chave que desbloqueia suas contas está faltando no armazenamento seguro deste aparelho. Restaure um backup para recuperar suas contas.';

  @override
  String get vaultDecryptFailed =>
      'Não foi possível desbloquear o arquivo das suas contas. Ele pode estar danificado ou foi alterado fora do app. Restaure um backup.';

  @override
  String get vaultBadJson =>
      'O arquivo das suas contas foi desbloqueado, mas o conteúdo está danificado. Restaure um backup.';

  @override
  String clockCheckBadAnswer(String status) {
    return 'O servidor de hora mandou uma resposta que o app não entende (HTTP $status).';
  }

  @override
  String clockCheckOff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'O relógio do seu aparelho está cerca de $count minutos errado, então os códigos não vão funcionar. Ative a hora automática nos Ajustes.',
      one: 'O relógio do seu aparelho está cerca de 1 minuto errado, então os códigos não vão funcionar. Ative a hora automática nos Ajustes.',
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
  String get keysTitle => 'Atalhos de teclado';

  @override
  String get keysWhere => 'Na lista de contas e na Escolha rápida.';

  @override
  String get keysMove => 'Subir e descer na lista';

  @override
  String get keysEnter => 'Enter';

  @override
  String get keysCopy => 'Copiar o código destacado';

  @override
  String get keysAnyLetter => 'Uma letra';

  @override
  String get keysSearch => 'Começar a buscar';

  @override
  String get keysEsc => 'Esc';

  @override
  String get keysClear => 'Limpar a busca';

  @override
  String get keysShowList => 'Mostrar esta lista';

  @override
  String get settingsKeysShortcutMac =>
      'Aperte ⌘/ em qualquer lugar para vê-los';

  @override
  String get settingsKeysShortcutOther =>
      'Aperte Ctrl+/ em qualquer lugar para vê-los';

  @override
  String trayTooltip(String name, int seconds) {
    return 'Tanooki Auth: $name, faltam $seconds s';
  }

  @override
  String get settingsTrayCountdownMac =>
      'Mostrar contagem regressiva na barra de menus';

  @override
  String get settingsTrayCountdownMacHelp =>
      'Os segundos restantes do seu primeiro favorito, ao lado do ícone na barra de menus. Nunca o código em si.';

  @override
  String get settingsTrayCountdownWindows =>
      'Mostrar contagem regressiva no ícone da bandeja';

  @override
  String get settingsTrayCountdownWindowsHelp =>
      'Aponte para o ícone do Tanooki Auth perto do relógio para ver quantos segundos faltam no seu primeiro favorito. Nunca o código em si.';

  @override
  String get unusedTitle => 'Contas que você nunca usa';

  @override
  String get settingsUnusedHelp => 'Nenhum código copiado há 6 meses ou mais';

  @override
  String get unusedIntro =>
      'Estas contas não têm um código copiado neste app há 6 meses ou mais. Se você não usa mais o site, desative primeiro a verificação em duas etapas lá, depois arrume-as aqui. A Lixeira guarda as contas por 30 dias.';

  @override
  String get unusedNone =>
      'Todas as contas foram usadas nos últimos 6 meses. Nada para arrumar.';

  @override
  String unusedLastUsed(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Usada pela última vez em $dateString';
  }

  @override
  String unusedNeverUsed(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Nunca usada aqui. Adicionada em $dateString';
  }

  @override
  String get unusedPickFirst => 'Marque uma ou mais contas primeiro.';

  @override
  String get unusedTagSuggestion => 'sem uso';

  @override
  String checkupUnusedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contas que você nunca usa',
      one: '1 conta que você nunca usa',
    );
    return '$_temp0';
  }

  @override
  String get checkupUnusedBody =>
      'Nenhum código copiado há 6 meses ou mais. É fácil não perceber quando uma conta antiga esquecida é invadida.';

  @override
  String get checkupUnusedReview => 'Revisar';

  @override
  String get halvesTitle => 'Backup em papel em duas metades';

  @override
  String get settingsHalvesHelp =>
      'Dois conjuntos de páginas. Cada metade sozinha não revela nada';

  @override
  String get halvesRestoreTitle => 'Restaurar de duas metades';

  @override
  String get settingsHalvesRestoreHelp =>
      'Escaneie os códigos das duas metades de um backup em papel';

  @override
  String get halvesExplain =>
      'Isto imprime seu backup criptografado como dois conjuntos separados de páginas, Metade A e Metade B.\n\nCada metade sozinha é só ruído aleatório: ninguém consegue descobrir nada com ela, nem com a sua frase secreta. Para restaurar, você precisa das duas metades e da frase secreta.\n\nGuarde as metades em dois lugares diferentes, por exemplo uma em casa e outra com alguém de confiança.';

  @override
  String get halvesHalfA => 'Metade A de 2';

  @override
  String get halvesHalfB => 'Metade B de 2';

  @override
  String halvesPart(String which, int part, int parts) {
    return 'Metade $which · parte $part de $parts';
  }

  @override
  String halvesPdfHeader(String date) {
    return 'Backup em papel do Tanooki Auth, feito em $date';
  }

  @override
  String get halvesPdfExplain =>
      'Esta metade sozinha não serve para nada. Para restaurar: no Tanooki Auth, abra Ajustes > Restaurar de duas metades, escaneie todos os códigos das duas metades e digite a frase secreta do backup. Guarde as duas metades em lugares diferentes.';

  @override
  String halvesPdfPage(String half, int page, int pages) {
    return '$half, página $page de $pages';
  }

  @override
  String get halvesNowB => 'Agora salve a Metade B';

  @override
  String get halvesNowBBody =>
      'A Metade A foi salva. A Metade B é a outra metade: imprima também e guarde em outro lugar.';

  @override
  String get halvesSaveB => 'Salvar a Metade B';

  @override
  String get halvesOnlyA =>
      'Só a Metade A foi salva. A Metade A sozinha não restaura nada, então faça as duas metades de novo quando estiver pronto.';

  @override
  String get halvesReady =>
      'As duas metades estão prontas. Imprima e guarde em lugares diferentes.';

  @override
  String get halvesRestoreIntro =>
      'Escaneie todos os códigos das duas metades, em qualquer ordem. Quando as duas estiverem completas, digite a frase secreta que você escolheu ao fazer o backup.';

  @override
  String halvesNotStarted(String half) {
    return '$half: nenhum código escaneado ainda';
  }

  @override
  String halvesProgress(String half, int have, int total) {
    return '$half: $have de $total códigos';
  }

  @override
  String get halvesScan => 'Escanear códigos';

  @override
  String get halvesScanTitle => 'Escaneie as duas metades';

  @override
  String get halvesPictures => 'Abrir imagens dos códigos';

  @override
  String halvesSomeUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count imagens não tinham um código que este app conseguisse ler. Tente uma foto mais de perto de um código.',
      one: '1 imagem não tinha um código que este app conseguisse ler. Tente uma foto mais de perto de um código.',
    );
    return '$_temp0';
  }

  @override
  String get halvesNotAHalf =>
      'Esse não é um código de um backup em papel de duas metades.';

  @override
  String get halvesOtherSet =>
      'Esse código é de outro backup em papel. Use as duas metades da mesma impressão.';

  @override
  String get halvesAlreadyHave =>
      'Esse já foi escaneado. Vamos para o próximo código.';

  @override
  String get halvesDontFit =>
      'Estas metades não se encaixam. Um código pode ter sido lido errado, ou as metades são de backups diferentes. Comece a escanear de novo.';

  @override
  String get halvesRestoreNow => 'Duas metades escaneadas: restaurar';

  @override
  String get healthTitle => 'Checagem geral';

  @override
  String get settingsHealthHelp =>
      'Sincronização, backup, relógio, bloqueio e códigos de recuperação em uma tela';

  @override
  String get healthIntro =>
      'Verde quer dizer tudo bem. Amarelo vale uma olhada, e o botão dele resolve.';

  @override
  String get healthGood => 'Tudo bem';

  @override
  String get healthLook => 'Vale uma olhada';

  @override
  String get healthSync => 'Sincronização';

  @override
  String get healthSyncOff =>
      'Não configurada. A sincronização mantém suas contas iguais em todos os seus aparelhos.';

  @override
  String healthSyncOk(String when) {
    return 'Última sincronização: $when';
  }

  @override
  String healthSyncStale(String when) {
    return 'Última sincronização: $when. Já faz um tempo: abra a Sincronização para ver o que há de errado.';
  }

  @override
  String get healthOpenSync => 'Abrir Sincronização';

  @override
  String get healthSetUp => 'Configurar';

  @override
  String get healthOpen => 'Abrir';

  @override
  String get healthBackup => 'Backup';

  @override
  String get healthBackupNever =>
      'Nenhum backup ainda. Se este aparelho for perdido, suas contas vão junto.';

  @override
  String healthBackupOk(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Último backup em $dateString';
  }

  @override
  String healthBackupOld(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Último backup em $dateString. Isso foi há mais de 30 dias: faça um novo.';
  }

  @override
  String get healthClock => 'Relógio';

  @override
  String get healthClockNotChecked =>
      'Ainda não verificado. Os códigos só funcionam quando o relógio deste aparelho está certo.';

  @override
  String healthClockOk(String when) {
    return 'Seu relógio está certo (verificado $when).';
  }

  @override
  String get healthCheckNow => 'Verificar agora';

  @override
  String get healthPhoneLink => 'Link com o celular';

  @override
  String healthPhoneLinkOk(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pareado com $count navegadores',
      one: 'Pareado com 1 navegador',
    );
    return '$_temp0';
  }

  @override
  String get healthPhoneLinkOff =>
      'Não pareado. Pareie o navegador do seu computador para aprovar códigos de login por este celular.';

  @override
  String get healthLock => 'Bloqueio';

  @override
  String get healthLockOn =>
      'Ativado. O app pergunta quem é você antes de mostrar os códigos.';

  @override
  String get healthLockOff =>
      'Desativado. Qualquer pessoa que pegar este aparelho pode ver seus códigos.';

  @override
  String get healthGoToSettings => 'Ir para a chave de bloqueio';

  @override
  String get healthRecovery => 'Códigos de recuperação';

  @override
  String healthRecoveryCount(int count, int total) {
    return '$count de $total contas têm códigos de recuperação salvos.';
  }

  @override
  String get healthRecoveryNoAccounts => 'Nenhuma conta ainda.';

  @override
  String get healthAddCodes => 'Adicionar códigos';

  @override
  String get syncErrorWiped =>
      'Outro aparelho apagou o Tanooki Auth neste aparelho. Tudo nele foi apagado e ele saiu da sincronização.';

  @override
  String get syncUiEraseDevice => 'Apagar este aparelho';

  @override
  String get syncUiEraseTitle => 'Apagar este aparelho?';

  @override
  String get syncUiEraseBody =>
      'Na próxima vez que esse aparelho ficar on-line, o Tanooki Auth nele apaga tudo: as contas, os ajustes, os widgets e os itens de busca. Ele também sai da sincronização para sempre. Isso não pode ser desfeito. Nada muda neste aparelho nem nos seus outros aparelhos.';

  @override
  String get syncUiEraseButton => 'Apagar';

  @override
  String get syncUiErased =>
      'Pronto. Esse aparelho vai se apagar na próxima vez que ficar on-line.';

  @override
  String syncUiClashes(int count) {
    return 'Conflitos de sincronização ($count)';
  }

  @override
  String get syncUiClashesHelp =>
      'Uma conta foi alterada em dois aparelhos antes de eles sincronizarem. Escolha qual versão manter.';

  @override
  String get syncUiClashTitle => 'Conflitos de sincronização';

  @override
  String get syncUiClashIntro =>
      'Cada conta abaixo foi alterada em dois aparelhos antes de eles sincronizarem. A sincronização usou a mudança mais recente. Se a outra versão é a que você quer, toque em Manter esta embaixo dela.';

  @override
  String get syncUiClashNone => 'Nenhum conflito. Nada para escolher.';

  @override
  String get syncUiClashInUse => 'Em uso agora';

  @override
  String get syncUiClashOther => 'Outra versão';

  @override
  String get syncUiClashKeep => 'Manter esta';

  @override
  String get syncUiClashKept =>
      'Pronto. Seus outros aparelhos recebem esta versão na próxima sincronização.';

  @override
  String syncUiClashEdited(String when) {
    return 'Alterada $when';
  }

  @override
  String get syncUiClashName => 'Nome';

  @override
  String get syncUiClashAccount => 'Conta';

  @override
  String get syncUiClashFolder => 'Pasta';

  @override
  String get syncUiClashNotes => 'Notas';

  @override
  String get syncUiClashInTrash => 'Na Lixeira';

  @override
  String get syncUiClashSecret => 'Chave de configuração';

  @override
  String get syncUiClashSecretDifferent => 'diferente';

  @override
  String get syncUiClashYes => 'Sim';

  @override
  String get syncUiClashNo => 'Não';

  @override
  String get syncUiClashOtherDiffers =>
      'Outros ajustes também são diferentes, como a aparência, o site ou os códigos de recuperação.';

  @override
  String get teamRoleAdmin => 'Admin';

  @override
  String get teamRoleMember => 'Membro';

  @override
  String get teamRoleViewer => 'Só visualização';

  @override
  String get teamRoleOwner => 'Dono';

  @override
  String get teamUiMakeAdmin => 'Tornar admin';

  @override
  String get teamUiMakeMember => 'Tornar membro';

  @override
  String get teamUiMakeViewer => 'Tornar só visualização';

  @override
  String get teamUiRoleChanged => 'Função alterada.';

  @override
  String get teamUiInviteRole => 'A pessoa entra como';

  @override
  String get teamUiRoleHelp =>
      'Admins convidam e removem pessoas e veem o registro de atividade. Membros usam e mudam as contas da equipe. Pessoas com só visualização podem usar as contas, mas não mudá-las.';

  @override
  String get teamUiInviteEmailLabel => 'E-mail da pessoa (opcional)';

  @override
  String get teamUiInviteEmailHint => 'nome@exemplo.com';

  @override
  String get teamUiInviteMake => 'Criar convite';

  @override
  String teamUiInviteEmailed(String email) {
    return 'Convite enviado para $email.';
  }

  @override
  String get teamUiEmailNotSetUp =>
      'O envio de e-mail ainda não está configurado. Copie o link abaixo e mande você mesmo.';

  @override
  String teamUiEmailFailed(String reason) {
    return 'O e-mail não foi enviado ($reason). Copie o link abaixo e mande você mesmo.';
  }

  @override
  String get teamUiYoureAdmin => 'Você é admin desta equipe';

  @override
  String get teamUiYoureViewer => 'Você está em uma equipe (só visualização)';

  @override
  String get teamUiViewOnly =>
      'Você pode usar estas contas, mas só admins e membros podem mudá-las.';

  @override
  String get teamUiActivity => 'Atividade';

  @override
  String get teamUiActivityTitle => 'Atividade da equipe';

  @override
  String get teamUiActivityHelp =>
      'Quem copiou ou mudou contas da equipe, e quando. Só os admins veem isto. Guardado por 90 dias, até os últimos 2.000 registros.';

  @override
  String get teamUiActivityEmpty =>
      'Nada ainda. Cópias e mudanças nas contas da equipe aparecem aqui.';

  @override
  String teamActCopy(String name) {
    return 'Copiou um código de $name';
  }

  @override
  String teamActFill(String name) {
    return 'Preencheu um código de $name';
  }

  @override
  String teamActAdd(String name) {
    return 'Adicionou $name';
  }

  @override
  String teamActEdit(String name) {
    return 'Mudou $name';
  }

  @override
  String teamActDelete(String name) {
    return 'Removeu $name';
  }

  @override
  String get teamUiBuyBusiness => 'Plano Empresa: US\$ 3 por pessoa por ano';

  @override
  String get teamUiBusinessSoon =>
      'Plano Empresa para equipes com mais de 10 pessoas (US\$ 3 por pessoa por ano): em breve.';

  @override
  String themeCustom(int n) {
    return 'Meu tema $n';
  }

  @override
  String get themeMakeOwn => 'Criar o seu';

  @override
  String get themeMakeOwnPremium => 'Criar seu próprio tema, Premium';

  @override
  String get themeEditOwn => 'Editar este tema';

  @override
  String get themeEditorTitle => 'Seu tema';

  @override
  String get themeEditorAccent => 'Destaque';

  @override
  String get themeEditorBackground => 'Fundo';

  @override
  String get themeEditorCard => 'Cartões';

  @override
  String get themeEditorText => 'Texto';

  @override
  String get themeEditorHue => 'Matiz';

  @override
  String themeEditorSwatch(String hex) {
    return 'Cor $hex';
  }

  @override
  String get themeEditorPreview => 'Prévia';

  @override
  String get themeEditorSample => 'Conta de exemplo';

  @override
  String get themeEditorSampleHint => 'Toque para copiar';

  @override
  String get themeEditorSave => 'Salvar tema';

  @override
  String get themeEditorDelete => 'Apagar tema';

  @override
  String get themeEditorAdjusted =>
      'Algumas cores foram ajustadas para que o texto e os botões continuem fáceis de ler.';

  @override
  String get themeEditorUnreadable =>
      'Não dá para deixar estas cores fáceis de ler. Tente uma cor de cartão mais próxima do fundo.';

  @override
  String get themeEditorFull =>
      'Você já tem 3 temas. Apague um para criar outro.';

  @override
  String get settingsSeasonal => 'Mudar com as estações';

  @override
  String get settingsSeasonalPremium => 'Mudar com as estações (Premium)';

  @override
  String get settingsSeasonalHelp =>
      'Assustador no outono, Aconchegante no inverno e Primavera na primavera; sua escolha no verão. Um ícone sazonal do app muda junto.';
}
