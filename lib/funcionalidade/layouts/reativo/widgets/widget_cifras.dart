part of pocket_church.widgets_reativos;

class WidgetCifras extends StatelessWidget {

  const WidgetCifras();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText("cifra.cifras"),
      onMore: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageListaCifras(),
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
              onSuggestionSelected: (cifra) async {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => GaleriaPDF(
                    titulo: cifra.titulo,
                    arquivo: cifra.cifra,
                  ),
                );
              },
              itemBuilder: (context, cifra) {
                return Material(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(cifra.titulo),
                    subtitle: Text(cifra.autor ?? ""),
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

