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
