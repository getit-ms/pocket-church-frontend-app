part of pocket_church.widgets_reativos;

class WidgetPublicacoes extends StatelessWidget {
  const WidgetPublicacoes();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: IntlText("publicacao.publicacoes"),
      onMore: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) =>
              PageListaPublicacoes(),
        );
      },
      body: Container(
        padding: EdgeInsets.all(10),
        child: IntlBuilder(
          text: "global.buscar",
          builder: (context, snapshot) {
            return new TypeAheadFormField<Boletim>(
              noItemsFoundBuilder: (context) => Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const IntlText(
                  "global.nenhum_registro_encontrado",
                  textAlign: TextAlign.center,
                ),
              ),
              autoFlipDirection: true,
              suggestionsCallback: (filtro) async {
                Pagina<Boletim> resultado = await boletimApi.consulta(
                  tipo: 'PUBLICACAO',
                  filtro: filtro,
                  tamanhoPagina: 5,
                );
                return resultado.resultados ?? [];
              },
              onSuggestionSelected: (publicacao) async {
                NavigatorUtil.navigate(
                  context,
                  builder: (context) => PagePublicacao(
                    publicacao: publicacao,
                  ),
                );
              },
              itemBuilder: (context, publicacao) {
                return Material(
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(publicacao.titulo),
                  ),
                );
              },
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: snapshot.data ?? "",
                    border: const OutlineInputBorder()),
              ),
            );
          },
        ),
      ),
    );
  }
}
