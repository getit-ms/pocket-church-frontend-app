part of pocket_church.widgets_reativos;

class WidgetDevocionario extends StatelessWidget {
  const WidgetDevocionario();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText(
        "devocionario.devocionario",
      ),
      onMore: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageDevocionario(),
        );
      },
      body: Container(
        height: 270,
        child: InfiniteList(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          scrollDirection: Axis.horizontal,
          provider: (int pagina, int tamanhoPagina) async {
            return await devocionarioApi.consulta(
              dataInicio: DateTime.now(),
              pagina: pagina,
              tamanhoPagina: tamanhoPagina,
            );
          },
          builder: (context, itens, index) {
            DiaDevocionario diaDevocionario = itens[index];
            return new _ItemDiaDevocionarioWidget(
                diaDevocionario: diaDevocionario);
          },
          placeholderSize: 190,
          placeholderBuilder: (context) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: double.infinity,
                width: 300,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ItemDiaDevocionarioWidget extends StatelessWidget {
  const _ItemDiaDevocionarioWidget({
    Key key,
    @required this.diaDevocionario,
  }) : super(key: key);

  final DiaDevocionario diaDevocionario;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: CustomElevatedButton(
        onPressed: () {
          NavigatorUtil.navigate(
            context,
            builder: (context) => GaleriaPDF(
              titulo: configuracaoBloc.currentBundle
                  .get('devocionario.devocionario'),
              arquivo: diaDevocionario.arquivo,
            ),
          );
        },
        child: Container(
          height: double.infinity,
          width: 300,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ArquivoImageProvider(diaDevocionario.thumbnail.id),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black38,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  StringUtil.formatData(diaDevocionario.data, pattern: "dd"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 75,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  StringUtil.formatData(diaDevocionario.data,
                      pattern: "MMM yy"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
