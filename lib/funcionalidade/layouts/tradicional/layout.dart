part of pocket_church.layout_tradicional;

class LayoutTradicional extends StatefulWidget {
  @override
  _LayoutTradicionalState createState() => _LayoutTradicionalState();
}

class _LayoutTradicionalState extends State<LayoutTradicional> {
  bool isAlerting = false;

  GlobalKey<PageTemplateState> _template = new GlobalKey();

  @override
  void didUpdateWidget(LayoutTradicional oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return WillPopScope(
      onWillPop: () async {
        if (isAlerting) {
          return true;
        }

        MessageHandler.info(
          _template.currentState.scaffold,
          const IntlText("global.confirmacao_saida_app"),
          duration: const Duration(milliseconds: 1500),
        );

        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            isAlerting = false;
          });
        });

        setState(() {
          isAlerting = true;
        });

        return false;
      },
      child: PageTemplate(
        key: _template,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: tema.homeBackground,
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              _buildBannerHome(tema),
              LinksInstitucional(),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: tema.topContentBorder,
                          width: 3,
                        ),
                      ),
                    ),
                    child: DivulgacaoInstitucional()),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerHome(Tema tema) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Image(
        image: tema.homeLogo,
        height: 55,
      ),
    );
  }
}
