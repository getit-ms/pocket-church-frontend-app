part of pocket_church.sugestao;

class PageSugestao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("chamado.chamados"),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormSugestao(),
            HistoricoSugestao(),
          ],
        ),
      ),
    );
  }
}
