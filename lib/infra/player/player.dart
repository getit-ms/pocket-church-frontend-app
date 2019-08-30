part of pocket_church.infra;

class Player {
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
    });
  }

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

    await rmxAudioPlayer.setPlaylistItems([
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
            startPaused: false, playFromPosition: position));
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

  subscribe(AudioPlayerEventHandler handler) {
    rmxAudioPlayer.on('status', handler);
  }

  unsubscribe(AudioPlayerEventHandler handler) {
    rmxAudioPlayer.off('status', handler);
  }
}

Player player = new Player();
