part of pocket_church.culto;

class PageListaCultos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: IntlText("culto.cultos"),
      body: InfiniteList<Evento>(
        provider: _provider,
        builder: _builder,
      ),
    );
  }

  Widget _builder(BuildContext context, List<Evento> cultos, int index) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    Evento culto = cultos[index];

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
            color: _colorBadge(culto),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: _contentBadge(culto),
          ),
        ),
        title: Text(
          culto.nome,
          style: TextStyle(
            color: tema.primary,
          ),
        ),
        subtitle: Text(
          StringUtil.formatData(
                culto.dataHoraInicio,
                pattern: "dd MMMM yyyy HH:mm",
              ) +
              " - " +
              StringUtil.formatData(
                culto.dataHoraTermino,
                pattern: DateUtil.equalsDateOnly(
                        culto.dataHoraInicio, culto.dataHoraTermino)
                    ? "HH:mm"
                    : "dd MMMM yyyy HH:mm",
              ),
        ),
        onTap: () {
          NavigatorUtil.navigate(
            context,
            builder: (context) => PageCulto(
              culto: culto,
            ),
          );
        },
      ),
    );
  }

  Future<Pagina<Evento>> _provider(int pagina, int tamanhoPagina) async {
    return await eventoApi.consulta(
        tipoEvento: TipoEvento.CULTO,
        pagina: pagina,
        tamanhoPagina: tamanhoPagina);
  }

  Color _colorBadge(Evento culto) {
    if (culto.inscricoesFuturas ?? false) {
      return Colors.blueAccent;
    }

    if (culto.inscricoesPassadas ?? false) {
      return Colors.black26;
    }

    if (culto.vagasRestantes == 0) {
      return Colors.orangeAccent;
    }

    return Colors.green;
  }

  Widget _contentBadge(Evento culto) {
    if (culto.inscricoesFuturas ?? false) {
      return IntlText("culto.inscricoes_ainda_nao_disponiveis");
    }

    if (culto.inscricoesPassadas ?? false) {
      return IntlText("culto.inscricoes_encerradas");
    }

    if (culto.vagasRestantes == 0) {
      return IntlText("culto.vagas_esgotadas");
    }

    if (culto.vagasRestantes == 1) {
      return IntlText("culto.uma_vaga_restante");
    }

    return IntlText(
      "culto.n_vagas_restantes",
      args: {'vagas': culto.vagasRestantes.toString()},
    );
  }
}
