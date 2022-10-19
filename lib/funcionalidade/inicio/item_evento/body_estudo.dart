part of pocket_church.inicio;

class BodyEstudo extends StatelessWidget {
  final ItemEvento item;

  const BodyEstudo({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageEstudo(
            estudo: Estudo(
              id: int.parse(item.id),
              titulo: item.titulo,
              data: item.dataHoraReferencia,
              thumbnail: item.ilustracao,
            ),
          ),
        );
      },
      child: item.ilustracao != null
          ? _bodyIlustracao(context)
          : _bodyTexto(context),
    );
  }

  Widget _bodyIlustracao(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
        top: 10,
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 2,
            child: Container(
              width: MediaQuery.of(context).size.width / 2.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                  image: item.ilustracao != null
                      ? ArquivoImageProvider(item.ilustracao.id)
                      : tema.homeLogo,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                Text(
                  item.titulo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: tema.primary,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _bodyTexto(BuildContext context) {
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
}
