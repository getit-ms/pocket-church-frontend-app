part of pocket_church.estudo;

class ItemEstudo extends StatelessWidget {
  final Estudo estudo;

  const ItemEstudo({this.estudo});

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: RawMaterialButton(
        onPressed: () {
          NavigatorUtil.navigate(
            context,
            builder: (context) => PageEstudo(
              estudo: estudo,
            ),
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        fillColor: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.insert_drive_file,
              color: Colors.black54,
              size: 45,
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    estudo.titulo,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: tema.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    estudo.autor,
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
