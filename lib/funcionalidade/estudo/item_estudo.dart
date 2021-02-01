part of pocket_church.estudo;

class ItemEstudo extends StatelessWidget {
  final Estudo estudo;

  const ItemEstudo({this.estudo});

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: CustomElevatedButton(
        onPressed: () {
          NavigatorUtil.navigate(
            context,
            builder: (context) => PageEstudo(
              estudo: estudo,
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            width: 160,
            decoration: BoxDecoration(
              image: estudo.thumbnail != null
                  ? DecorationImage(
                      image: ArquivoImageProvider(estudo.thumbnail.id),
                      fit: BoxFit.cover,
                    )
                  : null,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  tema.primary,
                  tema.secondary,
                ],
              ),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.insert_drive_file,
                    size: 120,
                    color: tema.buttonText.withOpacity(.5),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        tema.buttonBackground,
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        estudo.titulo,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: TextStyle(
                          color: tema.buttonText,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        estudo.autor,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: tema.buttonText.withOpacity(.7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
