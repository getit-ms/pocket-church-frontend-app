part of pocket_church.calendario;

class PageCalendario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("calendario.agenda"),
      body: InfiniteList<DiaEvento>(
        tamanhoPagina: 30,
        provider: _provider,
        builder: _builder,
        merger: _merger,
      ),
    );
  }

  Future<Pagina<DiaEvento>> _provider(int pagina, int tamanhoPagina) async {
    Pagina<EventoCalendario> resultado =
        await calendarioApi.consulta(pagina, tamanhoPagina);

    List<List<EventoCalendario>> agrupado = [];

    if (resultado.resultados?.isNotEmpty ?? false) {
      List<EventoCalendario> grupo;
      for (EventoCalendario evento in resultado.resultados) {
        if (grupo == null ||
            !DateUtil.equalsDateOnly(grupo[0].inicio, evento.inicio)) {
          agrupado.add(grupo = [evento]);
        } else {
          grupo.add(evento);
        }
      }
    }

    return Pagina(
        pagina: pagina,
        resultados: agrupado
            .map((grupo) => DiaEvento(data: grupo[0].inicio, eventos: grupo))
            .toList(),
        hasProxima: resultado.hasProxima);
  }

  Widget _builder(BuildContext context, List<DiaEvento> itens, int index) {
    DiaEvento dia = itens[index];
    return Column(
      children: <Widget>[
        _buildDivider(index, dia, itens),
        new ItemDiaEvento(dia),
      ],
    );
  }

  StatelessWidget _buildDivider(
      int index, DiaEvento dia, List<DiaEvento> itens) {
    if (index == 0 ||
        !DateUtil.equalsMonthOnly(dia.data, itens[index - 1].data)) {
      return InfoDivider(
        child: Text(
          StringUtil.formatData(
            dia.data,
            pattern: "MMMM yyyy",
          ).toUpperCase(),
        ),
      );
    }

    return Container();
  }

  List<DiaEvento> _merger(List<DiaEvento> oldData, List<DiaEvento> newData) {
    List<DiaEvento> merged = []..addAll(oldData);

    if (newData.isNotEmpty) {
      if (merged.isNotEmpty &&
          DateUtil.equalsDateOnly(
              merged[merged.length - 1].data, newData[0].data)) {
        merged[merged.length - 1].eventos.addAll(newData[0].eventos);

        if (newData.length > 1) {
          merged.addAll(newData.sublist(1));
        }
      } else {
        merged.addAll(newData);
      }
    }

    return merged;
  }
}

class ItemDiaEvento extends StatelessWidget {
  const ItemDiaEvento(
    this.dia, {
    Key key,
  }) : super(key: key);

  final DiaEvento dia;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool hoje = DateUtil.equalsDateOnly(dia.data, DateTime.now().toLocal());

    return Material(
      color: Colors.white,
      shape: Border(
        left: BorderSide(
          color: tema.primary,
          width: hoje ? 10 : 0,
        ),
        top: BorderSide(
          color: tema.primary,
          width: .5,
        ),
        bottom: BorderSide(
          color: tema.primary,
          width: .5,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              StringUtil.formatData(dia.data, pattern: "dd"),
              style: TextStyle(
                fontSize: 30,
                color: tema.primary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children:
                  dia.eventos.map((evento) => new ItemEvento(evento)).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class ItemEvento extends StatelessWidget {
  final EventoCalendario evento;

  const ItemEvento(
    this.evento, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: const BorderSide(
          color: Colors.black12,
          width: .5,
        ),
        bottom: const BorderSide(
          color: Colors.black12,
          width: .5,
        ),
      )),
      child: ListTile(
        onTap: () {
          CalendarioUtil.addEvento(
            context,
            evento: evento,
          );
        },
        title: Text(evento.descricao),
        subtitle: Text(evento.local ?? ""),
        trailing: Text(StringUtil.formatData(evento.inicio, pattern: "HH:mm") +
            " - " +
            StringUtil.formatData(evento.termino, pattern: "HH:mm")),
      ),
    );
  }
}

class DiaEvento {
  final DateTime data;
  final List<EventoCalendario> eventos;

  DiaEvento({this.data, this.eventos});
}
