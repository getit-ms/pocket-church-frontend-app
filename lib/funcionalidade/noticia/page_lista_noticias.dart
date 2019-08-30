part of pocket_church.funcionalidade_noticia;

class PageListaNoticias extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("noticia.noticias"),
      body: InfiniteList(
        provider: (int pagina, int tamanhoPagina) async {
          return await noticiaApi.consulta(pagina: pagina, tamanhoPagina: tamanhoPagina);
        },
        padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15
        ),
        builder: (context, itens, index) {
          return new _ItemNoticiaLista(
            noticia: itens[index],
          );
        },
      ),
    );
  }

}

class _ItemNoticiaLista extends StatelessWidget {
  final Noticia noticia;

  const _ItemNoticiaLista({
    Key key,
    this.noticia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tema = ConfiguracaoApp.of(context).tema;

    return Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: RawMaterialButton(
          fillColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Hero(
              tag: 'noticia_' + noticia.id.toString(),
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: noticia.ilustracao == null ? tema?.institucionalBackground : ArquivoImageProvider(noticia.ilustracao.id),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter
                            )
                        ),
                        child: Container(
                            height: 200,
                            decoration: const BoxDecoration(
                                gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white24,
                                      Colors.white,
                                    ]
                                )
                            ),
                            padding: EdgeInsets.all(20),
                            alignment: Alignment.bottomLeft,
                            child: Text(noticia.titulo,
                              style: TextStyle(
                                fontSize: 24,
                                color: tema?.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: const Radius.circular(15),
                        bottomRight: const Radius.circular(15),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(noticia.resumo,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: <Widget>[
                                Text(noticia.autor.nome),
                                const Text(" | "),
                                Text(StringUtil.formatData(noticia.dataPublicacao, pattern: "dd MMM yyyy"),),
                                Expanded(
                                  child: Container(),
                                ),
                                IntlText("Continuar Lendo",
                                  style: TextStyle(
                                    color: tema?.primary,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ),
          onPressed: (){
            Navigator.of(context).push(
              new MaterialPageRoute(
                  builder: (context) => PageNoticia(noticia: noticia,)
              )
            );
          },
        )
    );
  }
}