part of pocket_church.layout_tradicional;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return PageTemplate(
      actions: <Widget>[
        IconUsuario(
          color: Colors.white,
          size: 22,
        )
      ],
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: tema.homeLogo, fit: BoxFit.cover)),
        child: Column(
          children: <Widget>[
            _buildBannerHome(tema),
            LinksInstitucional(),
            Expanded(
              child: DivulgacaoInstitucional(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBannerHome(Tema tema) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Image(
        image: tema.homeBackground,
        height: 55,
      ),
    );
  }
}
