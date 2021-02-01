part of pocket_church.infra;

typedef NotificacaoCallback = Function(AppNotification notification);

class MessagingListener {

  bool loaded = false;
  List<NotificacaoCallback> onResume = [];
  List<NotificacaoCallback> onNotificationAlways = [];
  List<NotificacaoCallback> onNotificationOnTop = [];

  StreamSubscription<AppNotification> _onResumeSubscription;
  StreamSubscription<AppNotification> _onNotificationbscription;

  _load() {
    if (!loaded) {
      loaded = true;

      this._onResumeSubscription = messagingService.onResume.listen(_onResume,
          onError: (err) => print(err)
      );
      this._onNotificationbscription = messagingService.onNotification.listen(_onNotification,
          onError: (err) => print(err)
      );
    }
  }

  _unload() {
    if (loaded && onResume.isNotEmpty &&
        onNotificationAlways.isNotEmpty &&
        onNotificationOnTop.isNotEmpty) {
      loaded = false;

      _onResumeSubscription.cancel();
      _onNotificationbscription.cancel();
    }
  }

  delegateOnResume(AppNotification notification) => _onResume(notification);

  _onResume(AppNotification notification) {
    onResume.forEach((callback) => callback(notification));
  }

  _onNotification(AppNotification notification) {
    if (onNotificationOnTop.isNotEmpty) {
      onNotificationOnTop[onNotificationOnTop.length - 1](notification);
    }

    onNotificationAlways.forEach((callback) => callback(notification));
  }

  addWhenNotificatoinOnTop(NotificacaoCallback callback) {
    onNotificationOnTop.add(callback);

    _load();
  }

  addWhenResume(NotificacaoCallback callback) {
    onResume.add(callback);

    _load();
  }

  removeWhenNotificatoinOnTop(NotificacaoCallback callback) {
    onNotificationOnTop.add(callback);

    _load();
  }

  removeWhenResume(NotificacaoCallback callback) {
    _unload();

    onResume.remove(callback);
  }

  addWhenNotificatoinAlways(NotificacaoCallback callback) {
    _unload();

    onNotificationOnTop.remove(callback);
  }

  removeWhenNotificatoinAlways(NotificacaoCallback callback) {
    _unload();

    onNotificationOnTop.remove(callback);
  }

}

MessagingListener messagingListener = MessagingListener();