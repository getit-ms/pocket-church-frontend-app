part of pocket_church.evento;

class PageListaEventos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      deveEstarAutenticado: true,
      title: IntlText("evento.eventos"),
      body: InfiniteList<Evento>(
        provider: _provider,
        builder: _builder,
      ),
    );
  }

  Widget _builder(BuildContext context, List<Evento> eventos, int index) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    Evento evento = eventos[index];

    return Material(
      color: Colors.white,
      shape: Border(
        bottom: const BorderSide(
          color: Colors.black54,
          width: .5,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        trailing: Container(
          decoration: BoxDecoration(
            color: _colorBadge(evento),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: _contentBadge(evento),
          ),
        ),
        title: Text(
          evento.nome,
          style: TextStyle(
            color: tema.primary,
          ),
        ),
        subtitle: Text(
          StringUtil.formatData(
                evento.dataHoraInicio,
                pattern: "dd MMMM yyyy HH:mm",
              ) +
              " - " +
              StringUtil.formatData(
                evento.dataHoraTermino,
                pattern: DateUtil.equalsDateOnly(
                        evento.dataHoraInicio, evento.dataHoraTermino)
                    ? "HH:mm"
                    : "dd MMMM yyyy HH:mm",
              ),
        ),
        onTap: () {
          NavigatorUtil.navigate(
            context,
            builder: (context) => PageEvento(
              evento: evento,
            ),
          );
        },
      ),
    );
  }

  Future<Pagina<Evento>> _provider(int pagina, int tamanhoPagina) async {
    return await eventoApi.consulta(
        tipoEvento: TipoEvento.EVENTO,
        pagina: pagina,
        tamanhoPagina: tamanhoPagina);
  }

  Color _colorBadge(Evento evento) {
    if (evento.inscricoesFuturas ?? false) {
      return Colors.blueAccent;
    }

    if (evento.inscricoesPassadas ?? false) {
      return Colors.black26;
    }

    if (evento.vagasRestantes == 0) {
      return Colors.orangeAccent;
    }

    return Colors.green;
  }

  Widget _contentBadge(Evento evento) {
    if (evento.inscricoesFuturas ?? false) {
      return IntlText("evento.inscricoes_ainda_nao_disponiveis");
    }

    if (evento.inscricoesPassadas ?? false) {
      return IntlText("evento.inscricoes_encerradas");
    }

    if (evento.vagasRestantes == 0) {
      return IntlText("evento.vagas_esgotadas");
    }

    if (evento.vagasRestantes == 1) {
      return IntlText("evento.uma_vaga_restante");
    }

    return IntlText(
      "evento.n_vagas_restantes",
      args: {'vagas': evento.vagasRestantes.toString()},
    );
  }
}
