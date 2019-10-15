part of pocket_church.widgets_reativos;

class WidgetHinario extends StatelessWidget {
  const WidgetHinario();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: IntlText("hino.hinos"),
      onMore: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageListaHinos(),
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
            return new TypeAheadFormField<Hino>(
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
                Pagina<Hino> resultado = await hinoDAO.findHinosByFiltro(
                  filtro: filtro,
                  tamanhoPagina: 5,
                );
                return resultado.resultados ?? [];
              },
              onSuggestionSelected: (hino) async {
                NavigatorUtil.navigate(
                  context,
                  builder: (context) => PageHino(
                    hino: hino,
                  ),
                );
              },
              itemBuilder: (context, hino) {
                return Material(
                  color: Colors.white,
                  child: ListTile(
                    leading: Text(
                      hino.numero,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    title: Text(hino.nome),
                    subtitle: Text(hino.autor ?? ""),
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
