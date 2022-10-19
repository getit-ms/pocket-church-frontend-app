part of pocket_church.agenda;

class PageListaAconselhamentos extends StatefulWidget {
  @override
  _PageListaAconselhamentosState createState() =>
      _PageListaAconselhamentosState();
}

class _PageListaAconselhamentosState extends State<PageListaAconselhamentos> {
  Membro _membro;
  GlobalKey<InfiniteListState> _list = new GlobalKey();

  @override
  void initState() {
    super.initState();

    _membro = acessoBloc.currentMembro;
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return PageTemplate(
      deveEstarAutenticado: true,
      title: IntlText("agenda.agendamentos"),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InfiniteList<Aconselhamento>(
              key: _list,
              provider: _provider,
              builder: _builder,
            ),
          ),
          _buildNovoAgendamento(context),
          SizedBox(height: mq.padding.bottom),
        ],
      ),
    );
  }

  Widget _buildNovoAgendamento(BuildContext context) {
    if (pastor) {
      return Container();
    }

    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        boxShadow: [
          const BoxShadow(offset: Offset(0, -1), blurRadius: 3, color: Colors.black26)
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: CommandButton(
        child: const IntlText("agenda.novo_agendamento"),
        onPressed: (loading) async {
          await NavigatorUtil.navigate(
            context,
            builder: (context) => PageAgendamentoAconselhamento(),
          );

          _list.currentState.refresh();
        },
      ),
    );
  }

  bool get pastor {
    return _membro?.pastor ?? false;
  }

  Widget _builder(BuildContext context, List<Aconselhamento> itens, int index) {
    Aconselhamento item = itens[index];

    return ItemAconselhamento(
      item: item,
      usuarioPastor: pastor,
      onCancela: !item.concluido
          ? (loading) => _doCancela(context, item, loading)
          : null,
      onConfirma: pastor && !item.confirmado && !item.concluido
          ? (loading) => _doConfirma(loading, item, context)
          : null,
    );
  }

  Future _doConfirma(AsyncLoading<Aconselhamento> loading, Aconselhamento item,
      BuildContext context) async {
    await loading(
      agendaApi.confirma(
        calendario: item.calendario.id,
        agendamento: item.id,
      ),
    );

    _list.currentState.refresh();

    MessageHandler.success(
      Scaffold.of(context),
      const IntlText("mensagens.MSG-001"),
    );
  }

  Future _doCancela(BuildContext context, Aconselhamento item,
      AsyncLoading<Aconselhamento> loading) async {
    bool confirmado = await NavigatorUtil.confirma(
      context,
      title: IntlText("agenda.confirmacao_cancelamento"),
      message: IntlText(
        "mensagens.MSG-035",
        args: {
          'data': StringUtil.formatData(item.dataHoraInicio,
              pattern: "dd MMMM yyyy"),
          'horaInicio':
              StringUtil.formatData(item.dataHoraInicio, pattern: "HH:mm"),
          'horaFim': StringUtil.formatData(item.dataHoraFim, pattern: "HH:mm"),
        },
      ),
    );

    if (confirmado) {
      await loading(
        agendaApi.cancelar(
          calendario: item.calendario.id,
          agendamento: item.id,
        ),
      );

      _list.currentState.refresh();

      MessageHandler.success(
        Scaffold.of(context),
        const IntlText("mensagens.MSG-001"),
      );
    }
  }

  Future<Pagina<Aconselhamento>> _provider(
      int pagina, int tamanhoPagina) async {
    Pagina<Aconselhamento> resultado =
        await agendaApi.consultarMeusAgendamentos(
      pagina: pagina,
      tamanhoPagina: tamanhoPagina,
    );

    if (!pastor && (resultado.resultados?.isEmpty ?? true)) {
      NavigatorUtil.navigate(
        context,
        replace: true,
        builder: (context) => PageAgendamentoAconselhamento(),
      );
    }

    return resultado;
  }
}

typedef ActionCallback = Function(AsyncLoading<Aconselhamento> loading);

class ItemAconselhamento extends StatelessWidget {
  final Aconselhamento item;
  final bool usuarioPastor;
  final ActionCallback onConfirma;
  final ActionCallback onCancela;

  const ItemAconselhamento({
    this.item,
    this.usuarioPastor,
    this.onConfirma,
    this.onCancela,
  });

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      title: Text(
        StringUtil.formatData(item.dataHoraInicio, pattern: "dd MMMM yyyy") +
            " | " +
            StringUtil.formatData(item.dataHoraInicio, pattern: "HH:mm") +
            " - " +
            StringUtil.formatData(item.dataHoraFim, pattern: "HH:mm"),
        style: TextStyle(
          color: tema.primary,
          fontSize: 20,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: FotoMembro(
                      usuarioPastor
                          ? item.membro.foto
                          : item.calendario.pastor.foto,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DefaultTextStyle(
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black38,
                        ),
                        child: usuarioPastor
                            ? const IntlText("agenda.membro")
                            : const IntlText("agenda.pastor"),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        usuarioPastor
                            ? item.membro.nome
                            : item.calendario.pastor.nome,
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                IntlText("agenda.status." + item.status),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                onConfirma != null
                    ? CommandButton<Aconselhamento>(
                        background: isDark ? Colors.grey[900] : Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            side: BorderSide(
                              color: Colors.green,
                              width: 1,
                            )),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        textStyle: TextStyle(color: Colors.green),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            const IntlText("agenda.confirmar_agendamento")
                          ],
                        ),
                        onPressed: onConfirma,
                      )
                    : Container(),
                const SizedBox(
                  width: 5,
                ),
                onCancela != null
                    ? CommandButton<Aconselhamento>(
                        background: isDark ? Colors.grey[900] : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        textStyle: TextStyle(color: Colors.red),
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.close, color: Colors.red),
                            const IntlText("agenda.cancelar_agendamento")
                          ],
                        ),
                        onPressed: onCancela,
                      )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }
}
