part of pocket_church.inicio;

class PageFiltro extends StatefulWidget {
  @override
  _PageFiltroState createState() => _PageFiltroState();
}

class _PageFiltroState extends State<PageFiltro> {
  FiltroBloc filtroBloc;

  @override
  void initState() {
    super.initState();

    filtroBloc = FiltroBloc();
  }

  @override
  void dispose() {
    super.dispose();

    filtroBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Bundle bundle = ConfiguracaoApp.of(context).bundle;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: filtroBloc.filtra,
          decoration: InputDecoration(
            hintText: bundle['filtro.placeholder'],
          ),
        ),
      ),
      body: StreamBuilder<StatusFiltro>(
        stream: filtroBloc.status,
        initialData: StatusFiltro.vazio,
        builder: (context, snapshot) {
          if (snapshot.data == StatusFiltro.vazio) return _bodyVazio(context);

          return _bodyConteudo(snapshot.data);
        },
      ),
    );
  }

  Widget _bodyConteudo(StatusFiltro status) {
    if (status == StatusFiltro.nao_econtrado) {
      return Padding(
        padding: const EdgeInsets.all(35),
        child: Center(
          child: IntlText(
            "global.nenhum_registro_encontrado",
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? Colors.black45
                      : Colors.white54,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return ListView(
      children: [
        ListaFuncionalidades(bloc: filtroBloc, status: status),
        ListaMembroes(bloc: filtroBloc, status: status),
        ListaItensEvento(bloc: filtroBloc, status: status),
      ],
    );
  }

  Widget _bodyVazio(BuildContext) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(
              color: isDark ? Colors.white54 : Colors.black45,
              size: 60,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.menu),
                const SizedBox(width: 20),
                Icon(Icons.article),
                const SizedBox(width: 20),
                Icon(Icons.person),
              ],
            ),
          ),
          const SizedBox(height: 20),
          IntlText(
            "filtro.descricao",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.black45,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
