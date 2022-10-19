part of pocket_church.inicio;

class BodyAudio extends StatefulWidget {
  final ItemEvento item;

  const BodyAudio({Key key, this.item}) : super(key: key);

  @override
  _BodyAudioState createState() => _BodyAudioState();
}

class _BodyAudioState extends State<BodyAudio> {
  bool _loading = false;

  get item => widget.item;

  get playingItem => player.audio?.id?.toString() == item.id;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return InkWell(
      onTap: _loading
          ? null
          : playingItem
              ? () {
                  player.pause();
                }
              : () async {
                  try {
                    setState(() {
                      _loading = true;
                    });

                    Audio audio = await audioApi.detalha(int.parse(item.id));

                    player.play(audio);
                  } finally {
                    setState(() {
                      _loading = false;
                    });
                  }
                },
      child: Padding(
        padding: const EdgeInsets.only(
          right: 10,
          left: 10,
          bottom: 20,
        ),
        child: Row(
          children: [
            SizedBox(
              height: 140,
              width: 140,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Stack(
                  children: [
                    FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                      image: item.ilustracao != null
                          ? ArquivoImageProvider(item.ilustracao.id)
                          : tema.homeLogo,
                    ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.black26,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: _loading
                          ? SizedBox(
                              width: 100,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 10,
                              ),
                            )
                          : Icon(
                              playingItem
                                  ? Icons.pause_circle_outline
                                  : Icons.play_circle_outline,
                              size: 100,
                              color: Colors.white,
                            ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                item.titulo,
                style: TextStyle(
                  color: tema.primary,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
