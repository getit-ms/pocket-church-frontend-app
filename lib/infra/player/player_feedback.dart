part of pocket_church.infra;

class CurrentTrackDataSnapshot {
  final Audio audio;
  final double progress;
  final double position;
  final double duration;
  final double speed;
  final double buffer;
  final String status;

  const CurrentTrackDataSnapshot({
    this.audio,
    this.progress = 0,
    this.position = 0,
    this.duration = 0,
    this.speed = 1,
    this.buffer = 0,
    this.status = 'loading',
  });

  bool get loading {
    return status == 'loading';
  }

  bool get playing {
    return status == 'playing';
  }

  bool get seeking {
    return status == 'seeking';
  }

  bool get stopped {
    return status == 'stopped';
  }

  bool get paused {
    return status == 'paused';
  }

  bool get completed {
    return progress == 1;
  }
}

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

  @override
  void initState() {
    super.initState();

    _snapshot = new CurrentTrackDataSnapshot(
        audio: player.audio,
        status: player.currentStatus,
        duration: player.audio?.tempoAudio?.toDouble()??0.0
    );

    player.subscribe(_checkStatus);

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

    player.unsubscribe(_checkStatus);
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

  _checkStatus(String eventName, {dynamic args}) {

    try {
      if ((args as OnStatusCallbackData).value != null) {
        dynamic data = (args as OnStatusCallbackData).value;

        double position = (data['currentPosition'] ?? _snapshot.position)
            .toDouble();
        double duration = math.max(
            (data['duration'] ?? _snapshot.duration).toDouble(),
            _snapshot.audio?.tempoAudio?.toDouble() ?? 0.0
        );
        double progress = math.max(
          (data['playbackPercent'] ?? _snapshot.progress).toDouble(),
          position / duration * 100,
        );

        if ((args as OnStatusCallbackData).type ==
            RmxAudioStatusMessage.RMXSTATUS_COMPLETED) {
          position = duration;
          progress = 100;
        }

        var newSnapshot = new CurrentTrackDataSnapshot(
          audio: player.audio,
          status: data['status'] ?? _snapshot.status,
          position: position,
          progress: progress,
          buffer: (data['bufferPercent'] ?? _snapshot.buffer).toDouble(),
          duration: duration,
          speed: _snapshot.speed,
        );

        if (_didStatusChanged(newSnapshot)) {
          setState(() {
            _snapshot = newSnapshot;
          });
        }
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

