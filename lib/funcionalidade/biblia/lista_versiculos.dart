part of pocket_church.biblia;

class ListaVersiculos extends StatefulWidget {
  final LivroCapitulo livro;

  const ListaVersiculos({
    this.livro,
  });

  @override
  _ListaVersiculosState createState() => _ListaVersiculosState();
}

class _ListaVersiculosState extends State<ListaVersiculos> {
  VersiculoBiblia _versiculoSelecionado;

  ScrollController _listController;

  @override
  void initState() {
    super.initState();

    _listController = new ScrollController()
      ..addListener(() {
        if (_versiculoSelecionado != null) {
          setState(() {
            _versiculoSelecionado = null;
          });
        }
      });
  }

  @override
  void didUpdateWidget(ListaVersiculos oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _versiculoSelecionado = null;
    });

    if (widget.livro?.livro != oldWidget.livro?.livro ||
        widget.livro?.capitulo != oldWidget.livro?.capitulo) {
      _listController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder<List<VersiculoBiblia>>(
            future: bibliaDAO.findVersiculosByLivroCapituloBiblia(
                widget.livro?.livro?.id ?? 0, widget.livro?.capitulo ?? 0),
            builder: (context, snapshot) {
              return ListView.builder(
                controller: _listController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _versiculoSelecionado = snapshot.data[index];
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 17,
                            height: 1.35,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  snapshot.data[index].versiculo.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " ",
                              style: TextStyle(letterSpacing: 20),
                            ),
                            TextSpan(
                              text: snapshot.data[index].texto,
                              style: TextStyle(
                                height: 2,
                                color: isDark ? Colors.white60 : Colors.black54,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data?.length ?? 0,
              );
            },
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: _opcoesVersiculo(),
          crossFadeState: _versiculoSelecionado == null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Container _opcoesVersiculo() {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Container(
      height: 75,
      color: const Color(0xFFD0D0D0),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CommandButton(
              onPressed: (loading) {
                Share.text(
                    "",
                    "\"${_versiculoSelecionado.texto}\" (${widget.livro?.livro.nome} ${widget.livro?.capitulo}:${_versiculoSelecionado.versiculo})",
                    "text/txt");

                setState(() {
                  _versiculoSelecionado = null;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.share),
                  const SizedBox(
                    width: 5,
                  ),
                  const IntlText("global.compartilhar"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
