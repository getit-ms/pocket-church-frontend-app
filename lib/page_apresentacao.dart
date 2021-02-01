import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocket_church/componentes/componentes.dart';
import 'package:pocket_church/funcionalidade/layouts/reativo/reativo.dart';
import 'package:pocket_church/funcionalidade/layouts/tradicional/tradicional.dart';
import 'package:pocket_church/infra/infra.dart';

class PageApresentacao extends StatefulWidget {
  final bool trocaTemplate;

  const PageApresentacao({this.trocaTemplate = false});

  @override
  _PageApresentacaoState createState() => _PageApresentacaoState();
}

class _PageApresentacaoState extends State<PageApresentacao>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.trocaTemplate ? 2 : 0);
  }

  @override
  void didUpdateWidget(PageApresentacao oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    Configuracao config = ConfiguracaoApp.of(context).config;

    return Material(
      child: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(image: tema.homeBackground, fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 1,
              colors: [
                tema.buttonBackground.withOpacity(0.65),
                tema.buttonBackground.withOpacity(0.35),
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[
              TabBarView(
                key: Key('tab_view_apresentacao'),
                controller: _tabController,
                physics: widget.trocaTemplate ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  _primeiraPagina(config, tema),
                  _segundaPagina(tema),
                  _terceiraPagina(tema),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20
                  ),
                  child: TabPageSelector(
                    indicatorSize: 15,
                    controller: _tabController,
                    selectedColor: tema.buttonText,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _terceiraPagina(Tema tema) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.trocaTemplate ? Container() : IntlText(
            "inicio.pagina3",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tema.buttonText,
              fontSize: 18,
            ),
          ),
          widget.trocaTemplate ? Container() : const SizedBox(
            height: 20,
          ),
          RawMaterialButton(
            key: Key('opcao_tradicional'),
            onPressed: () {
              Configuracao config = configuracaoBloc.currentConfig;
              configuracaoBloc.update(
                config.copyWith(template: 'tradicional'),
              );
              NavigatorUtil.navigate(
                context,
                builder: (context) => LayoutTradicional(),
                replace: true,
              );
            },
            padding: const EdgeInsets.all(10),
            textStyle: TextStyle(
              color: tema.buttonText,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                side: BorderSide(
                  color: tema.buttonText,
                  width: 1,
                )),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Row(
                children: <Widget>[
                  const _IlustracaoMenuLateral(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IntlText(
                          "inicio.tradicional.nome",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        IntlText("inicio.tradicional.descricao",
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RawMaterialButton(
            key: Key('opcao_reativa'),
            onPressed: () {
              Configuracao config = configuracaoBloc.currentConfig;
              configuracaoBloc.update(
                config.copyWith(template: 'reativo'),
              );
              NavigatorUtil.navigate(
                context,
                builder: (context) => LayoutReativo(),
                replace: true,
              );
            },
            padding: const EdgeInsets.all(10),
            textStyle: TextStyle(
              color: tema.buttonText,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                side: BorderSide(
                  color: tema.buttonText,
                  width: 1,
                )),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Row(
                children: <Widget>[
                  const _IlustracaoMenuAbas(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IntlText(
                          "inicio.reativo.nome",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        IntlText("inicio.reativo.descricao",
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _segundaPagina(Tema tema) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.newspaper,
                size: 50,
                color: tema.buttonText,
              ),
              SizedBox(
                width: 30,
              ),
              Icon(
                FontAwesomeIcons.video,
                size: 50,
                color: tema.buttonText,
              ),
              SizedBox(
                width: 30,
              ),
              Icon(
                FontAwesomeIcons.music,
                size: 50,
                color: tema.buttonText,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                FontAwesomeIcons.file,
                size: 50,
                color: tema.buttonText,
              ),
              SizedBox(
                width: 30,
              ),
              Icon(
                FontAwesomeIcons.bell,
                size: 50,
                color: tema.buttonText,
              ),
              SizedBox(
                width: 30,
              ),
              Icon(
                FontAwesomeIcons.ellipsisH,
                size: 50,
                color: tema.buttonText,
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          IntlText(
            "inicio.pagina2",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tema.buttonText,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _primeiraPagina(Configuracao config, Tema tema) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: tema.homeLogo,
            width: 200,
          ),
          const SizedBox(
            height: 50,
          ),
          IntlText(
            "inicio.pagina1",
            args: {
              'nomeAplicativo': config.nomeAplicativo,
              'nomeIgreja': config.nomeIgreja
            },
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tema.buttonText,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _IlustracaoMenuAbas extends StatelessWidget {
  const _IlustracaoMenuAbas({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Container(
      height: 100,
      width: 65,
      alignment: Alignment.centerLeft,
      color: tema.buttonText.withOpacity(.5),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  color: tema.buttonText.withOpacity(.25),
                  height: 30,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  color: tema.buttonText.withOpacity(.25),
                  height: 10,
                  width: double.infinity,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  color: tema.buttonText.withOpacity(.25),
                  height: 20,
                  width: double.infinity,
                ),
              ],
            ),
          ),
          Container(
            color: tema.buttonText.withOpacity(.5),
            height: 15,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  color: tema.buttonText.withOpacity(.5),
                  height: 10,
                  width: 10,
                ),
                Container(
                  color: tema.buttonText.withOpacity(.5),
                  height: 10,
                  width: 10,
                ),
                Container(
                  color: tema.buttonText.withOpacity(.5),
                  height: 10,
                  width: 10,
                ),
                Container(
                  color: tema.buttonText.withOpacity(.5),
                  height: 10,
                  width: 10,
                ),
                Container(
                  color: tema.buttonText.withOpacity(.5),
                  height: 10,
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IlustracaoMenuLateral extends StatelessWidget {
  const _IlustracaoMenuLateral({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Container(
      height: 100,
      width: 65,
      alignment: Alignment.centerLeft,
      color: tema.buttonText.withOpacity(.5),
      child: Container(
        height: 100,
        width: 45,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(5),
        color: tema.buttonText.withOpacity(.5),
        child: Column(
          children: <Widget>[
            Container(
              color: tema.buttonText.withOpacity(.5),
              height: 30,
              width: double.infinity,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              color: tema.buttonText.withOpacity(.5),
              height: 10,
              width: double.infinity,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              color: tema.buttonText.withOpacity(.5),
              height: 10,
              width: double.infinity,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              color: tema.buttonText.withOpacity(.5),
              height: 10,
              width: double.infinity,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              color: tema.buttonText.withOpacity(.5),
              height: 10,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
