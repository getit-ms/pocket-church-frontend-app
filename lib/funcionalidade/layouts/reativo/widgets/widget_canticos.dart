part of pocket_church.widgets_reativos;

class WidgetCanticos extends StatelessWidget {
  const WidgetCanticos();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: IntlText("cantico.canticos"),
      onMore: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageListaCanticos(),
        );
      },
      body: Container(
        padding: const EdgeInsets.all(10),
        child: IntlBuilder(
          text: "global.buscar",
          builder: (context, snapshot) {
            return new TypeAheadFormField<Cantico>(
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
                Pagina<Cantico> resultado = await canticoApi.consulta(
                  filtro: filtro,
                  tamanhoPagina: 5,
                );
                return resultado.resultados ?? [];
              },
              onSuggestionSelected: (cantico) async {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => GaleriaPDF(
                    titulo: cantico.titulo,
                    arquivo: cantico.cifra,
                  ),
                );
              },
              itemBuilder: (context, cantico) {
                return Material(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(cantico.titulo),
                    subtitle: Text(cantico.autor ?? ""),
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
