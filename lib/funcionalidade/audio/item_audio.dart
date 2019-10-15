part of pocket_church.audio;

class ItemAudio extends StatelessWidget {
  final Audio audio;
  final double width;

  const ItemAudio({
    this.audio,
    this.width = 220,
  });

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Container(
      width: width,
      child: RawMaterialButton(
        onPressed: () async {
          if (player.audio == audio) {
            if (player.currentStatus == 'playing') {
              await player.pause();
            } else {
              await player.unpause();
            }
          } else {
            await player.play(audio);
          }
        },
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Expanded(
              child: PlayerFeedback(
                updateOn: [
                  UpdateEvent.LIVRO,
                  UpdateEvent.STATUS,
                ],
                builder: (context, snapshot) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10,
                        )
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      gradient: RadialGradient(
                        center: Alignment.topRight,
                        radius: 2,
                        colors: [
                          tema.primary,
                          tema.primary.withOpacity(.25),
                        ],
                      ),
                      image: DecorationImage(
                        image: audio.capa == null
                            ? tema.menuBackground
                            : ArquivoImageProvider(audio.capa.id),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        color: Colors.black26,
                      ),
                      child: Icon(
                        snapshot.audio == audio &&
                                player.currentStatus == 'playing'
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                        color: Colors.white,
                        size: 45,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    audio.nome,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: tema.primary, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    audio.autor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
