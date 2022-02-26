part of pocket_church.boletim;

class PageListaBoletins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("boletim.boletins"),
      body: InfiniteList(
        padding: const EdgeInsets.all(10),
        provider: _provider,
        builder: _builder,
      ),
    );
  }

  Future<Pagina<Boletim>> _provider(
      int pagina, int tamanhoPagina) async {
    return await boletimApi.consulta(
      tipo: 'BOLETIM',
      pagina: pagina,
      tamanhoPagina: tamanhoPagina,
    );
  }

  Widget _builder(
      BuildContext context, List<Boletim> itens, int index) {
    if (index % 2 == 0) {
      return Row(
        children: <Widget>[
          Expanded(
            child: _ItemBoletim(
              boletim: itens[index],
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: index + 1 < itens.length
                ? _ItemBoletim(
              boletim: itens[index + 1],
            )
                : Container(),
          ),
        ],
      );
    }

    return const SizedBox(
      height: 15,
    );
  }
}

class _ItemBoletim extends StatelessWidget {
  const _ItemBoletim({
    Key key,
    @required this.boletim,
  }) : super(key: key);

  final Boletim boletim;

  @override
  Widget build(BuildContext context) {
    var tema = ConfiguracaoApp.of(context).tema;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Container(
        height: 250,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 5)],
          image: DecorationImage(
              image: ArquivoImageProvider(boletim.thumbnail.id),
              fit: BoxFit.cover),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: RawMaterialButton(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white12, Colors.white])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    boletim.titulo,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: tema.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(StringUtil.formatData(boletim.data, pattern: "dd MMM"))
                ],
              ),
              padding: EdgeInsets.all(10),
            ),
            onPressed: () {
              NavigatorUtil.navigate(
                context,
                builder: (context) => PageBoletim(
                  boletim: boletim,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
