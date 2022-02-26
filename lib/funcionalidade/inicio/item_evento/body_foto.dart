part of pocket_church.inicio;

class BodyFoto extends StatelessWidget {
  final ItemEvento item;

  const BodyFoto({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageListaFotos(
            galeria: GaleriaFotos(
              id: item.id,
              nome: item.titulo,
              descricao: item.apresentacao,
              fotoPrimaria: Foto(
                urlImagemNormal: item.urlIlustracao,
              ),
            ),
          ),
        );
      },
      child: SizedBox(
        height: 280,
        width: double.infinity,
        child: Stack(
          children: [
            FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: item.urlIlustracao,
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      item.titulo,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    if (item.apresentacao != null) const SizedBox(height: 10),
                    if (item.apresentacao != null)
                      Text(
                        item.apresentacao,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
