part of pocket_church.infra;

class MessagingService {
  BehaviorSubject<AppNotification> _resumeNotificationSubject =
      new BehaviorSubject<AppNotification>();
  BehaviorSubject<AppNotification> _notificationSubject =
      new BehaviorSubject<AppNotification>();

  init({bool requestPushPermission = true}) {
    if (requestPushPermission) {
      firebase.FirebaseMessaging.instance.requestPermission();
    }

    firebase.FirebaseMessaging.onMessage.listen(_onMessage);
    firebase.FirebaseMessaging.onMessageOpenedApp.listen(_onResume);
    firebase.FirebaseMessaging.onBackgroundMessage(_onLaunch);
  }

  get onResume => _resumeNotificationSubject.stream;

  get onNotification => _notificationSubject.stream;

  register() async {
    Configuracao config = configuracaoBloc.currentConfig;

    var token = await firebase.FirebaseMessaging.instance.getToken();

    await acessoApi.registerPush(
      pushkey: token,
      version: config.version,
      tipoDispositivo:
          Platform.isIOS ? TipoDispositivo.IOS : TipoDispositivo.ANDROID,
    );
  }

  Future<dynamic> _onLaunch(event) async {
    _resumeNotificationSubject.add(AppNotification(
        title: event['notification']['title'],
        message: event['notification']['body'],
        data: event['data']));
  }

  Future<dynamic> _onMessage(event) async {
    _notificationSubject.add(AppNotification(
        title: event['notification']['title'],
        message: event['notification']['body'],
        data: event['data']));
  }

  Future<dynamic> _onResume(event) async {
    _resumeNotificationSubject.add(AppNotification(
        title: event['notification']['title'],
        message: event['notification']['body'],
        data: event['data']));
  }
}

class AppNotification {
  String title;
  String message;
  Map<dynamic, dynamic> data;

  AppNotification({this.title, this.message, this.data});
}

MessagingService messagingService = MessagingService();
