part of pocket_church.biblia;

class SelecaoCapitulo extends StatefulWidget {
  final LivroCapitulo livro;
  final Function(LivroCapitulo) onSelected;

  const SelecaoCapitulo({
    this.livro,
    this.onSelected,
  });

  @override
  _SelecaoCapituloState createState() => _SelecaoCapituloState();
}

class _SelecaoCapituloState extends State<SelecaoCapitulo>
    with TickerProviderStateMixin {
  LivroCapitulo _livro;
  TabController _tabController;

  List<LivroBiblia> _livrosNovo = [];
  List<LivroBiblia> _livrosAntigo = [];
  List<int> _capitulos = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    bibliaDAO.findLivrosBibliaByTestamento('VELHO').then((livros) {
      setState(() {
        _livrosAntigo = livros;
      });
    });

    bibliaDAO.findLivrosBibliaByTestamento('NOVO').then((livros) {
      setState(() {
        _livrosNovo = livros;
      });
    });

    _seleciona(widget.livro);
  }

  _seleciona(LivroCapitulo livro) async {
    List<int> capitulos =
        await bibliaDAO.findCapitulosLivroBiblia(livro.livro.id);

    print("${livro.livro.id} ${livro.livro.nome} - ${capitulos.length}");

    setState(() {
      _livro = livro;
      _capitulos = capitulos;
    });
  }

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    var mediaQueryData = MediaQuery.of(context);
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      padding: mediaQueryData.padding,
      height: mediaQueryData.size.height,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : const Color(0xFFE9E9E9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 5,
                )
              ],
            ),
            child: RawMaterialButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    (_livro?.livro?.nome ?? "") +
                        " " +
                        (_livro?.capitulo?.toString() ?? ""),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
              textStyle: TextStyle(
                fontSize: 17,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              onPressed: () {
                Navigator.of(context).pop(_livro);
                if (widget.onSelected != null) {
                  widget.onSelected(_livro);
                }
              },
            ),
          ),
          Container(
            height: 50,
            color: isDark ? Colors.grey[900] : Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: tema.primary,
              tabs: <Widget>[
                Tab(
                  child: IntlText(
                    "biblia.livros",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
                Tab(
                  child: IntlText(
                    "biblia.capitulos",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _tabLivros(),
                _tabCapitulos(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _tabLivros() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: const TestamentoHeader(
              child: const IntlText("biblia.velho_testamento")),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                _buildButtonLivro('VELHO', _livrosAntigo[index]),
            childCount: _livrosAntigo.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: const TestamentoHeader(
              child: const IntlText("biblia.novo_testamento")),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildButtonLivro('NOVO', _livrosNovo[index]),
            childCount: _livrosNovo.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonLivro(String testamento, LivroBiblia livro) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return RawMaterialButton(
      child: Text(
        livro.nome,
        style: TextStyle(
          fontSize: 16,
          color: _livro?.livro == livro
              ? tema.primary
              : isDark
                  ? Colors.white70
                  : Colors.black87,
          fontWeight:
              _livro?.livro == livro ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onPressed: () async {
        await _seleciona(LivroCapitulo(
          testamento: testamento,
          livro: livro,
          capitulo: 1,
        ));

        _tabController.animateTo(1);
      },
    );
  }

  Widget _buildButtonCapitulo(int capitulo) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return RawMaterialButton(
      child: Text(
        capitulo.toString(),
        style: TextStyle(
          fontSize: 16,
          color: _livro.capitulo == capitulo
              ? tema.primary
              : isDark
                  ? Colors.white70
                  : Colors.black87,
          fontWeight:
              _livro.capitulo == capitulo ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onPressed: () async {
        await _seleciona(LivroCapitulo(
          testamento: _livro.testamento,
          livro: _livro?.livro,
          capitulo: capitulo,
        ));

        Navigator.of(context).pop(_livro);
        if (widget.onSelected != null) {
          widget.onSelected(_livro);
        }
      },
    );
  }

  Widget _tabCapitulos() {
    return GridView.builder(
      itemBuilder: ((context, index) => index >= _capitulos.length ? null : _buildButtonCapitulo(_capitulos[index])),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.5,
      ),
    );
  }
}

class TestamentoHeader extends SliverPersistentHeaderDelegate {
  final Widget child;

  const TestamentoHeader({this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      color: isDark ? Colors.grey[800] : const Color(0xFFE9E9E9),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: DefaultTextStyle(
        child: child,
        style: TextStyle(
          fontSize: 17,
          color: isDark ? Colors.white70 : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
