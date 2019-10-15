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
          builder: (context) => PageListaPublicacoes(),
        );
      },
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
            )
          ],
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
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
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
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
