part of pocket_church.inicio;

class BodyNoticia extends StatelessWidget {
  final ItemEvento item;

  const BodyNoticia({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _navigateNoticia(context, Noticia(
          id: int.parse(item.id),
          titulo: item.titulo,
          autor: item.autor,
          dataPublicacao: item.dataHoraPublicacao,
          resumo: item.apresentacao,
          ilustracao: item.ilustracao,
        ));
      },
      child: _content(context),
    );
  }

  _navigateNoticia(BuildContext context, Noticia noticia) {
    NavigatorUtil.navigate(
      context,
      builder: (context) => PageNoticia(
        noticia: noticia,
      ),
    );
  }

  Widget _content(BuildContext context) {
    if (item.ilustracao == null) {
      Tema tema = ConfiguracaoApp.of(context).tema;

      return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                item.titulo,
                style: TextStyle(
                  color: tema.primary,
                  fontSize: 22,
                ),
              ),
            ),
            if (item.apresentacao != null) const SizedBox(height: 10),
            if (item.apresentacao != null)
              Text(
                item.apresentacao,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        children: [
          FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: ArquivoImageProvider(item.ilustracao.id),
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
    );
  }
}
