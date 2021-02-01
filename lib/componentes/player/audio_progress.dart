part of pocket_church.componentes;

class AudioProgress extends StatefulWidget {

  final double progress;
  final double duration;
  final bool seeking;

  const AudioProgress({this.progress = 0, this.duration = 0, this.seeking = false});

  @override
  State<StatefulWidget> createState() => AudioProgressState();

}

class AudioProgressState extends State<AudioProgress> {

  double _actualProgress;
  double _seeking;

  @override
  void initState() {
    super.initState();

    _actualProgress = math.min(widget.progress / 100, 1);
  }

  @override
  void didUpdateWidget(AudioProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      if (_seeking != null && !widget.seeking) {
        _seeking = null;
      }

      _actualProgress = math.min(widget.progress / 100, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return new Slider(
        inactiveColor: Colors.black26,
        activeColor: Color.lerp(tema.primary, Colors.black, .5),
        value: _seeking??_actualProgress,
        onChangeEnd: (val) {
          player.seekTo(widget.duration * val);

          setState(() {
            _seeking = val;
          });
        },
        onChanged: (val) {
          setState(() {
            _seeking = val;
          });
        }
    );
  }

}