part of pocket_church.widgets_reativos;

class WidgetContatos extends StatelessWidget {
  const WidgetContatos();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText("contato.contatos"),
      onMore: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageListaContatos(),
        );
      },
      body: Container(
        padding: EdgeInsets.all(10),
        child: IntlBuilder(
          text: "global.buscar",
          builder: (context, snapshot) {
            return new TypeAheadFormField<Membro>(
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
                Pagina<Membro> resultado = await membroApi.consulta(
                  filtro: filtro,
                  tamanhoPagina: 5,
                );
                return resultado.resultados ?? [];
              },
              onSuggestionSelected: (membro) async {
                NavigatorUtil.navigate(
                  context,
                  builder: (context) => PageContato(
                    membro: membro,
                  ),
                );
              },
              itemBuilder: (context, membro) {
                return Material(
                  color: Colors.white,
                  child: ListTile(
                    leading: FotoMembro(membro.foto),
                    title: Text(membro.nome),
                    subtitle: Text(membro.email ?? ""),
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
