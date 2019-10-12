part of pocket_church.infra;

typedef FeedbackWidgetBuilder = Widget Function(BuildContext context, CurrentTrackDataSnapshot snapshot);

enum UpdateEvent {
  LIVRO,
  STATUS,
  PROGRESS,
  SPEED,
}

class PlayerFeedback extends StatefulWidget {

  final FeedbackWidgetBuilder builder;
  final List<UpdateEvent> updateOn;

  const PlayerFeedback({this.builder, this.updateOn = const []});

  @override
  State<StatefulWidget> createState() => PlayerFeedbackState();

}

class PlayerFeedbackState extends State<PlayerFeedback> {

  CurrentTrackDataSnapshot _snapshot;
  Timer _speedCheck;
  StreamSubscription<CurrentTrackDataSnapshot> _subscription;

  @override
  void initState() {
    super.initState();

    _snapshot = new CurrentTrackDataSnapshot(
        audio: player.audio,
        status: player.currentStatus,
        duration: player.audio?.tempoAudio?.toDouble()??0.0
    );

    _subscription = player.trackStream.listen((snapshot) {
      if (_didStatusChanged(snapshot)) {
        setState(() {
          _snapshot = snapshot;
        });
      }
    });

    if (widget.updateOn.contains(UpdateEvent.SPEED)) {
      this._speedCheck = Timer.periodic(new Duration(seconds: 1), _checkSpeed);
    }
  }

  @override
  void didUpdateWidget(PlayerFeedback oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.updateOn.contains(UpdateEvent.SPEED)) {
      if (_speedCheck == null) {
        this._speedCheck =
            Timer.periodic(new Duration(seconds: 1), _checkSpeed);
      }
    } else if (_speedCheck != null) {
      _speedCheck.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();

    if (_speedCheck != null) {
      _speedCheck.cancel();
    }

    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  _checkSpeed(timer) async {

    try {

      double speed =  (await player.getPlaybackRate()).toDouble();

      if (speed != _snapshot.speed) {
        setState(() {
          _snapshot = new CurrentTrackDataSnapshot(
            audio: _snapshot.audio,
            position: _snapshot.position,
            status: _snapshot.status,
            progress: _snapshot.progress,
            buffer: _snapshot.buffer,
            duration: _snapshot.duration,
            speed: speed,
          );
        });
      }

    } catch (ex) {
      print(ex);
    }

  }

  _didStatusChanged(CurrentTrackDataSnapshot newSnapshot) {
    if (widget.updateOn.contains(UpdateEvent.STATUS) &&
        _snapshot.status != newSnapshot.status) {
      return true;
    }

    if (widget.updateOn.contains(UpdateEvent.LIVRO) &&
        (_snapshot.audio?.id != newSnapshot.audio?.id)) {
      return true;
    }

    if (widget.updateOn.contains(UpdateEvent.PROGRESS) &&
        (_snapshot.progress != newSnapshot.progress ||
            _snapshot.duration != newSnapshot.duration ||
            _snapshot.position != newSnapshot.position ||
            _snapshot.buffer != newSnapshot.buffer)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _snapshot);
  }

}

