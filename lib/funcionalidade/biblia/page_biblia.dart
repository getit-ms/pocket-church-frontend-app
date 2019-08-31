part of pocket_church.biblia;

final String _ULTIMO_ESTADO = "page_biblia.ultimo_estado";

class PageBiblia extends StatefulWidget {
  @override
  _PageBibliaState createState() => _PageBibliaState();
}

class _PageBibliaState extends State<PageBiblia> {
  LivroCapitulo _livro;

  @override
  void initState() {
    super.initState();

    _loadUltimoContexto();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("biblia.biblia"),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListaVersiculos(livro: _livro),
          ),
          BarraNavegacaoBiblia(
            value: _livro,
            onChange: _set,
          ),
          BarraProgressoSincronizacao(),
        ],
      ),
    );
  }

  _loadUltimoContexto() async {
    var sprefs = await SharedPreferences.getInstance();

    _set(await _getUltimoEstado(sprefs));
  }

  _set(LivroCapitulo livro) async {
    var sprefs = await SharedPreferences.getInstance();

    setState(() {
      _livro = livro;
    });

    if (livro != null) {
      sprefs.setString(_ULTIMO_ESTADO, json.encode(livro.toJson()));
    }
  }

  Future<LivroCapitulo> _getUltimoEstado(SharedPreferences sprefs) async {
    if (sprefs.containsKey(_ULTIMO_ESTADO)) {
      return LivroCapitulo.fromJson(
          json.decode(sprefs.getString(_ULTIMO_ESTADO)));
    }

    return await bibliaDAO.findPrimeiroLivro();
  }
}

class BarraNavegacaoBiblia extends StatelessWidget {
  final LivroCapitulo value;
  final Function(LivroCapitulo) onChange;

  const BarraNavegacaoBiblia({this.value, this.onChange});

  _anterior() async {
    LivroCapitulo capitulo = await bibliaDAO.findCapituloAnterior(
      value.testamento,
      value.livro.id,
      value.capitulo,
    );

    onChange(capitulo);
  }

  _proximo() async {
    LivroCapitulo capitulo = await bibliaDAO.findProximoCapitulo(
      value.testamento,
      value.livro.id,
      value.capitulo,
    );

    onChange(capitulo);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: _anterior,
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: RawMaterialButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    (value?.livro?.nome ?? "") +
                        " " +
                        (value?.capitulo?.toString() ?? ""),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(Icons.keyboard_arrow_up),
                ],
              ),
              textStyle: TextStyle(
                fontSize: 17,
                color: Colors.black87,
              ),
              onPressed: () async {
                PersistentBottomSheetController<LivroCapitulo> controller = showBottomSheet<LivroCapitulo>(
                  context: context,
                  builder: (context) => SelecaoCapitulo(
                    livro: value,
                  ),
                );

                controller.closed.then((selecionado) {
                  if (selecionado != null) {
                    onChange(selecionado);
                  }
                });
              },
            ),
          ),
          IconButton(
            onPressed: _proximo,
            icon: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
