part of pocket_church.publicacao;

class PageListaPublicacoes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("publicacao.publicacoes"),
      body: InfiniteList<Boletim>(
        tamanhoPagina: 30,
        provider: (pagina, tamanhoPagina) async {
          return await boletimApi.consulta(
            tipo: 'PUBLICACAO',
            pagina: pagina,
            tamanhoPagina: tamanhoPagina,
          );
        },
        builder: (context, itens, index) {
          Boletim publicacao = itens[index];
          return Column(
            children: <Widget>[
              index == 0 ||
                  itens[index - 1].titulo[0].toUpperCase() !=
                      publicacao.titulo[0].toUpperCase()
                  ? InfoDivider(
                child: Text(publicacao.titulo[0]),
              )
                  : Container(),
              Material(
                color: Colors.white,
                child: ListTile(
                  title: Text(publicacao.titulo),
                  onTap: () {
                    NavigatorUtil.navigate(
                      context,
                      builder: (context) => PagePublicacao(
                        publicacao: publicacao,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
