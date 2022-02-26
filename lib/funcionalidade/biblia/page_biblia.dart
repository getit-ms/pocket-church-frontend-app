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
          BarraProgressoSincronizacao(),
          BarraNavegacaoBiblia(
            value: _livro,
            onChange: _set,
          ),
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
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      width: double.infinity,
      color: isDark ? Colors.grey[900] : Colors.white,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: _anterior,
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: isDark ? Colors.white70 : Colors.black87,
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
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              onPressed: () async {
                showBottomSheet<LivroCapitulo>(
                  context: context,
                  builder: (context) => SelecaoCapitulo(
                    livro: value,
                    onSelected: onChange,
                  ),
                );
              },
            ),
          ),
          IconButton(
            onPressed: _proximo,
            icon: Icon(
              Icons.keyboard_arrow_right,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
