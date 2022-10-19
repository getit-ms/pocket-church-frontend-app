part of pocket_church.inicio;

class TabCalendario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Builder(builder: _calendario),
        Builder(builder: _listaEventos),
      ],
    );
  }

  Widget _calendario(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ClipRect(
      child: Container(
        color: isDark ? Colors.grey[900] : Colors.black12,
        child: SelecaoCalendario(
          width: MediaQuery.of(context).size.width - 20,
          selectedDate: calendarioBloc.dataSelecionada,
          viewType: calendarioBloc.viewType,
          dateBuilder: (date, {selected, currentSlide}) {
            return StreamBuilder<List<ItemEvento>>(
                stream: calendarioBloc.calendario,
                builder: (context, snapshot) {
                  List<ItemEvento> eventos = snapshot.data ?? [];
                  int count = eventos
                      .where((evento) => DateUtil.equalsDateOnly(
                          evento.dataHoraReferencia, date))
                      .length;

                  Tema tema = ConfiguracaoApp.of(context).tema;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Text(DateFormat("dd").format(date)),
                      if (currentSlide && count > 0)
                        Positioned(
                          top: -5,
                          right: -8,
                          child: AnimatedContainer(
                            height: 15,
                            width: 15,
                            duration: const Duration(milliseconds: 300),
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              color: selected ? Colors.white : tema.primary,
                              shape: const CircleBorder(),
                            ),
                            child: AnimatedDefaultTextStyle(
                              style: TextStyle(
                                fontSize: 9,
                                color: selected ? tema.primary : Colors.white,
                              ),
                              duration: const Duration(milliseconds: 300),
                              child: Text(count.toString()),
                            ),
                          ),
                        ),
                    ],
                  );
                });
          },
          onViewTypeChange: calendarioBloc.trocaViewType,
          onDateSelect: calendarioBloc.selecionaData,
          onPeriodChange: (di, df) {
            calendarioBloc.trocaPeriodo(dataInicio: di, dataTermino: df);
          },
        ),
      ),
    );
  }

  Widget _listaEventos(BuildContext context) {
    return StreamBuilder<List<ItemEvento>>(
      stream: calendarioBloc.eventosData,
      builder: (context, snapshot) {
        if (snapshot.data?.isEmpty ?? true) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 75,
            ),
            child: const Text("Nenhum evento encontrado."),
          );
        }

        return Column(children: [
          for (ItemEvento item in snapshot.data) ItemEventoCard(item: item),
        ]);
      },
    );
  }
}
