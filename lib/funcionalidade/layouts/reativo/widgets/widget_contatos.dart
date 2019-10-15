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
