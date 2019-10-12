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


class Player {
  BehaviorSubject<CurrentTrackDataSnapshot> _currentTrackSubject = new BehaviorSubject<CurrentTrackDataSnapshot>();

  RmxAudioPlayer rmxAudioPlayer = new RmxAudioPlayer();

  Audio _audio;

  Player() {
    rmxAudioPlayer.initialize();

    rmxAudioPlayer.on('status', (String eventName, {dynamic args}) {
      if (audio == null &&
          args.trackId != null &&
          (args.trackId as String).allMatches("^[0-9]+\$").isNotEmpty) {
        _reloadAudio(args.trackId);
      }

      _checkStatus(eventName, args: args);
    });
  }


  _checkStatus(String eventName, {dynamic args}) {

    CurrentTrackDataSnapshot snapshot = _currentTrackSubject.value ?? new CurrentTrackDataSnapshot();

    try {
      if (args is OnStatusCallbackData && args.value != null) {
        dynamic data = args.value;

        double position = (data['currentPosition'] ?? snapshot.position)
            .toDouble();
        double duration = math.max(
            (data['duration'] ?? snapshot.duration).toDouble(),
            snapshot.audio?.tempoAudio?.toDouble() ?? 0.0
        );
        double progress = math.max(
          (data['playbackPercent'] ?? snapshot.progress).toDouble(),
          position / duration * 100,
        );

        if (args.type ==
            RmxAudioStatusMessage.RMXSTATUS_COMPLETED) {
          position = duration;
          progress = 100;
        }

        String status = data['status'] ?? snapshot.status;

        if (args.type == RmxAudioStatusMessage.RMXSTATUS_BUFFERING ||
            args.type == RmxAudioStatusMessage.RMXSTATUS_LOADING ||
            args.type == RmxAudioStatusMessage.RMXSTATUS_STALLED) {
          status = 'loading';
        }

        var newSnapshot = new CurrentTrackDataSnapshot(
          audio: player.audio,
          status: status,
          position: position,
          progress: progress,
          buffer: (data['bufferPercent'] ?? snapshot.buffer).toDouble(),
          duration: duration,
          speed: snapshot.speed,
        );

        _currentTrackSubject.add(newSnapshot);
      }
    } catch (ex) {
      print(ex);
    }

  }

  Subject<CurrentTrackDataSnapshot> get trackStream => _currentTrackSubject.stream;

  _reloadAudio(String id) async {
    this._audio = await audioApi.detalha(int.parse(id));
  }

  get audio {
    if (_audio?.id?.toString() == rmxAudioPlayer.currentTrack?.trackId) {
      return _audio;
    }

    return null;
  }

  play(Audio audio, {int position}) async {
    _audio = audio;

    Configuracao config = configuracaoBloc.currentConfig;
    String assetURL = _resolveAssetURL(config, audio);
    String albumArt = await _resolveAlbumArt(config, audio);

    await rmxAudioPlayer.setPlaylistItems(
      [
        new AudioTrack(
          trackId: audio.id.toString(),
          title: audio.nome,
          artist: audio.autor,
          album: config.nomeIgreja,
          albumArt: albumArt,
          assetUrl: assetURL,
        )
      ],
      options: PlaylistItemOptions(
        startPaused: false,
        playFromPosition: position,
      ),
    );
  }

  String _resolveAssetURL(Configuracao config, Audio audio) {
    return "${config.basePath}/arquivo/stream/${audio.audio.id}/${audio.audio.filename}?Authorization=${config.authorization ?? ""}&Igreja=${config.chaveIgreja}&Dispositivo=${config.chaveDispositivo}";
  }

  Future<String> _resolveAlbumArt(Configuracao config, Audio audio) async {
    String albumArt = 'assets/imgs/institucional_background.png';
    if (audio.capa != null) {
      File ilustracao = await arquivoService.getFileLocation(audio.capa.id);

      if (ilustracao.existsSync()) {
        albumArt = ilustracao.path;
      } else {
        albumArt =
            "${config.basePath}/arquivo/download/${audio.capa.id}?Authorization=${config.authorization ?? ""}&Igreja=${config.chaveIgreja}&Dispositivo=${config.chaveDispositivo}";
      }
    }
    return albumArt;
  }

  unpause() async {
    return await rmxAudioPlayer.play();
  }

  pause() async {
    return await rmxAudioPlayer.pause();
  }

  stop() async {
    await rmxAudioPlayer.pause();
    await rmxAudioPlayer.clearAllItems();
  }

  Future<num> getPlaybackRate() async {
    return await rmxAudioPlayer.getPlaybackRate();
  }

  get currentStatus {
    return rmxAudioPlayer.currentState;
  }

  setPlaybackRate(double rate) async {
    return await rmxAudioPlayer.setPlaybackRate(rate);
  }

  seekTo(double position) async {
    return await rmxAudioPlayer.seekTo(position);
  }
}

Player player = new Player();
