part of pocket_church.componentes;

class BottomPlayerControl extends StatefulWidget {
  final bool safeArea;

  const BottomPlayerControl({
    Key key,
    this.safeArea = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BottomPlayerControlState();
}

class BottomPlayerControlState extends State<BottomPlayerControl>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _opacity;
  Animation<double> _size;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    _opacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: const Interval(.5, 1)));
    _size = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: const Interval(0, .75)));
  }

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return PlayerFeedback(
      updateOn: [UpdateEvent.PROGRESS, UpdateEvent.STATUS, UpdateEvent.LIVRO],
      builder: (context, snapshot) {
        if (!_animationController.isAnimating) {
          if (snapshot.audio != null && !snapshot.stopped) {
            if (_animationController.value < 1) {
              _animationController.forward();
            }
          } else {
            if (_animationController.value > 0) {
              _animationController.reverse();
            }
          }
        }

        return Opacity(
          opacity: _opacity.value,
          child: new Container(
              height: _size.value * (widget.safeArea ? 55 + MediaQuery.of(context).padding.bottom : 55),
              color: tema.primary,
              padding: EdgeInsets.only(
                bottom: widget.safeArea ? _size.value * MediaQuery.of(context).padding.bottom : 0
              ),
              child: new Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  new SizedBox(
                    height: _size.value * 55,
                    child: MaterialButton(
                      onPressed: () {
                        NavigatorUtil.navigate(
                          context,
                          builder: (context) => DetalhePlayer(),
                        );
                      },
                      child: new Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 10,
                          ),
                          new Text(
                            StringUtil.formatTime(snapshot.position),
                            style: new TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: new Text(
                              snapshot.audio?.nome ?? "",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          _playPause(snapshot),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -25,
                    left: -25,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width + 50,
                      child: AudioProgress(
                        duration: snapshot.duration,
                        progress: snapshot.progress,
                        seeking: snapshot.seeking,
                      ),
                    ),
                  )
                ],
              )),
        );
      },
    );
  }

  Widget _playPause(CurrentTrackDataSnapshot snapshot) {
    if (snapshot.audio != null && snapshot.playing) {
      return IconButton(
        iconSize: 35,
        color: Colors.white,
        onPressed: player.pause,
        icon: Icon(Icons.pause_circle_filled),
      );
    }

    return IconButton(
      iconSize: 35,
      color: Colors.white,
      onPressed: () {
        if (snapshot.audio != null && snapshot.paused) {
          player.unpause();
        } else {
          player.play(player.audio);
        }
      },
      icon: Icon(Icons.play_circle_filled),
    );
  }
}
