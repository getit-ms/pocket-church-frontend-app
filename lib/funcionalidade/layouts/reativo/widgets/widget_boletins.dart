part of pocket_church.widgets_reativos;


class WidgetBoletins extends StatelessWidget {

  const WidgetBoletins();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText("boletim.boletins",),
      onMore: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageListaBoletins(),
        );
      },
      body: Container(
        height: 250,
        child: InfiniteList(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
          scrollDirection: Axis.horizontal,
          provider: (int pagina, int tamanhoPagina) async {
            return await boletimApi.consulta(pagina: pagina, tamanhoPagina: tamanhoPagina);
          },
          builder: (context, itens, index) {
            Boletim boletim = itens[index];
            return new _ItemBoletimWidget(boletim: boletim);
          },
          placeholderSize: 190,
          placeholderBuilder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: SizedBox(
                height: double.infinity,
                width: 180,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
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

class _ItemBoletimWidget extends StatelessWidget {
  const _ItemBoletimWidget({
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
        height: double.infinity,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 5
            )
          ],
          image: DecorationImage(
              image: ArquivoImageProvider(boletim.thumbnail.id),
              fit: BoxFit.cover
          ),
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
                      colors: [
                        Colors.white12,
                        Colors.white
                      ]
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(boletim.titulo,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: tema.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(StringUtil.formatData(boletim.data, pattern: "dd MMM"))
                ],
              ),
              padding: EdgeInsets.all(10),
            ),
            onPressed: (){
              NavigatorUtil.navigate(
                context,
                builder: (context) => PageBoletim(boletim: boletim,),
              );
            },
          ),
        ),
      ),
    );
  }
}

