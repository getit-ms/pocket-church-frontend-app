part of pocket_church.widgets_reativos;

class WidgetAniversariantes extends StatelessWidget {
  const WidgetAniversariantes();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText("contato.aniversariantes"),
      onMore: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageListaAniversariantes(),
        );
      },
      body: Container(
        height: 180,
        child: InfiniteList(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 20,
          ),
          provider: _provider,
          builder: _builder,
          scrollDirection: Axis.horizontal,
          placeholderSize: 160,
          placeholderBuilder: (context) => Container(
            width: 130,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, List<Membro> itens, int index) {
    Membro item = itens[index];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      child: RawMaterialButton(
        elevation: 10,
        fillColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Container(
          width: 130,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: FotoMembro(
                    item.foto,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                StringUtil.nomeResumido(item.nome),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          NavigatorUtil.navigate(
            context,
            builder: (context) => PageContato(
              membro: item,
            ),
          );
        },
      ),
    );
  }

  Future<Pagina<Membro>> _provider(int pagina, int tamanhoPagina) async {
    List<Membro> aniv = await membroApi.buscaAniversariantes();

    int hoje = DateTime.now().month * 100 + DateTime.now().day;

    return Pagina(
      resultados: aniv.where((m) => m.diaAniversario == hoje).toList(),
      pagina: pagina,
      hasProxima: false,
    );
  }
}
