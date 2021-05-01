part of pocket_church.componentes;

class DetalhePlayer extends StatelessWidget {
  get audio => player.audio;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: audio?.capa != null
              ? ArquivoImageProvider(audio.capa.id)
              : tema.loginBackground,
          fit: BoxFit.cover,
        ),
      ),
      child: new BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                tema.primary.withOpacity(.75),
                tema.secondary.withOpacity(.75)
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              elevation: 0,
            ),
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _tituloResumo(),
                  _ilustracaoResumo(context),
                  _controleAudio(),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _controleAudio() {
    return Container(
      child: Column(
        children: <Widget>[
          PlayerFeedback(
            updateOn: [UpdateEvent.PROGRESS],
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    StringUtil.formatTime(snapshot.position),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    StringUtil.formatTime(snapshot.duration),
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              );
            },
          ),
          PlayerFeedback(
            updateOn: [UpdateEvent.PROGRESS],
            builder: (context, snapshot) {
              return AudioProgress(
                progress: snapshot.progress,
                duration: snapshot.duration,
                seeking: snapshot.seeking,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PlayerFeedback(
                updateOn: [UpdateEvent.PROGRESS],
                builder: (context, snapshot) {
                  return RawMaterialButton(
                    constraints: const BoxConstraints(
                      minWidth: 35,
                      minHeight: 35,
                    ),
                    shape: const CircleBorder(),
                    onPressed: () =>
                        player.seekTo(math.max(snapshot.position - 15, 0)),
                    child: Column(
                      children: const <Widget>[
                        const Icon(
                          FontAwesomeIcons.undo,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "15 seg.",
                          style:
                              const TextStyle(color: Colors.white, fontSize: 9),
                        )
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    PlayerFeedback(
                      updateOn: [UpdateEvent.LIVRO, UpdateEvent.STATUS],
                      builder: (context, snapshot) {
                        if (snapshot.completed) {
                          Navigator.of(context).pop();
                        }

                        if (snapshot.audio != null && snapshot.playing) {
                          return IconButton(
                            iconSize: 60,
                            color: Colors.white,
                            onPressed: player.pause,
                            icon: Icon(Icons.pause_circle_filled),
                          );
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RawMaterialButton(
                              constraints: const BoxConstraints(
                                minWidth: 35,
                                minHeight: 35,
                              ),
                              shape: const CircleBorder(),
                              onPressed: () {
                                player.seekTo(0);
                                player.play(
                                  player.audio,
                                );
                              },
                              child: Icon(
                                Icons.fast_rewind,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              iconSize: 60,
                              color: Colors.white,
                              onPressed: snapshot.waiting ? null : () {
                                if (snapshot.audio != null && !snapshot.completed) {
                                  player.unpause();
                                } else {
                                  player.play(player.audio);
                                }
                              },
                              icon: snapshot.waiting ? SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Colors.white),
                                  strokeWidth: 4,
                                ),
                              ) : Icon(Icons.play_circle_filled),
                            ),
                            RawMaterialButton(
                              constraints: const BoxConstraints(
                                minWidth: 35,
                                minHeight: 35,
                              ),
                              shape: const CircleBorder(),
                              onPressed: () {
                                player.stop();
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.stop,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    PlayerFeedback(
                      updateOn: [UpdateEvent.SPEED],
                      builder: (context, snapshot) {
                        if (Platform.isIOS) {
                          return Container();
                        }

                        return RawMaterialButton(
                          shape: const CircleBorder(),
                          onPressed: () {
                            double speed = snapshot.speed + 0.25;

                            if (speed > 2) {
                              speed = 1;
                            }

                            player.setPlaybackRate(speed);
                          },
                          child: Column(
                            children: <Widget>[
                              const Icon(
                                Icons.update,
                                color: Colors.white,
                              ),
                              Text(
                                snapshot.speed.toString() + "x",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 9),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              PlayerFeedback(
                updateOn: [UpdateEvent.PROGRESS],
                builder: (context, snapshot) {
                  return RawMaterialButton(
                    constraints: const BoxConstraints(
                      minWidth: 35,
                      minHeight: 35,
                    ),
                    shape: const CircleBorder(),
                    onPressed: () =>
                        player.seekTo(math.max(snapshot.position + 30, 0)),
                    child: Column(
                      children: const <Widget>[
                        const Icon(
                          FontAwesomeIcons.redo,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "30 seg.",
                          style:
                              const TextStyle(color: Colors.white, fontSize: 9),
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _tituloResumo() {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            audio?.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          ),
          Text(
            audio?.autor,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }

  Widget _ilustracaoResumo(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Container(
      decoration: const BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            const BoxShadow(
                color: Colors.black87, spreadRadius: 1, blurRadius: 2)
          ]),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Image(
          height: MediaQuery.of(context).size.height - 530,
          image: audio.capa != null
              ? ArquivoImageProvider(audio.capa.id)
              : tema.loginBackground,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
