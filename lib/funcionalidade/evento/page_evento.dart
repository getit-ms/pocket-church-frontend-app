part of pocket_church.evento;

class PageEvento extends StatelessWidget {
  final Evento evento;

  PageEvento({this.evento});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: IntlText("evento.evento"),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<Evento>(
            future: eventoApi.detalha(evento.id),
            builder: (context, snapshot) {
              return new EventoContent(evento: snapshot.data ?? evento);
            }),
      ),
    );
  }
}

class EventoContent extends StatefulWidget {
  const EventoContent({
    Key key,
    @required this.evento,
  }) : super(key: key);

  final Evento evento;

  @override
  _EventoContentState createState() => _EventoContentState();
}

class _EventoContentState extends State<EventoContent> {
  Key _futureKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              widget.evento.nome,
              style: TextStyle(
                color: tema.primary,
                fontSize: 22,
              ),
            ),
          ),
          widget.evento.banner != null
              ? SizedBox(
                  width: double.infinity,
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        new PageRouteBuilder(
                          opaque: false,
                          barrierDismissible: true,
                          barrierColor: Colors.black87,
                          pageBuilder: (BuildContext context, _, __) =>
                              PhotoViewPage(
                            title: const IntlText("evento.evento"),
                            images: [
                              ImageView(
                                heroTag: "banner",
                                image: ArquivoImageProvider(
                                    widget.evento.banner.id),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: "banner",
                      child: Image(
                        width: double.infinity,
                        image: ArquivoImageProvider(widget.evento.banner.id),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                )
              : Container(),
          ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              widget.evento.descricao ?? "",
            ),
          ),
          new ItemEvento(
            label: IntlText("evento.dataHoraInicio"),
            value: Text(
              StringUtil.formatData(
                widget.evento.dataHoraInicio,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          new ItemEvento(
            label: IntlText("evento.dataHoraTermino"),
            value: Text(
              StringUtil.formatData(
                widget.evento.dataHoraTermino,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          InfoDivider(
            child: IntlText("evento.inscricao"),
          ),
          new ItemEvento(
            label: IntlText("evento.vagas"),
            value: Text(
              widget.evento.limiteInscricoes.toString(),
            ),
          ),
          new ItemEvento(
            label: IntlText("evento.dataHoraInicioInscricao"),
            value: Text(
              StringUtil.formatData(
                widget.evento.dataInicioInscricao,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          new ItemEvento(
            label: IntlText("evento.dataHoraTerminoInscricao"),
            value: Text(
              StringUtil.formatData(
                widget.evento.dataTerminoInscricao,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          widget.evento.exigePagamento
              ? new ItemEvento(
                  label: IntlText("evento.valor"),
                  value: Text(
                    StringUtil.formataCurrency(
                      widget.evento.valor ?? 0,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: widget.evento.inscricoesAbertas &&
                        widget.evento.vagasRestantes > 0
                    ? () {
                        NavigatorUtil.navigate(
                          context,
                          builder: (context) => PageInscricaoEvento(
                            evento: widget.evento,
                          ),
                        ).then((sucesso) {
                          if (sucesso != null && sucesso) {
                            MessageHandler.success(
                              Scaffold.of(context),
                              const IntlText("mensagens.MSG-001"),
                            );

                            setState(() {
                              _futureKey = GlobalKey();
                            });
                          }
                        });
                      }
                    : null,
                padding: const EdgeInsets.all(15),
                shape: const RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: IntlText(
                  _textButton(),
                  style: TextStyle(
                    color: tema.buttonText,
                  ),
                ),
                fillColor: widget.evento.inscricoesAbertas &&
                        widget.evento.vagasRestantes > 0
                    ? tema.buttonBackground
                    : Colors.black45,
              ),
            ),
          ),
          _listaInscricoes(context)
        ],
      ),
    );
  }

  FutureBuilder<Pagina<InscricaoEvento>> _listaInscricoes(
      BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return FutureBuilder<Pagina<InscricaoEvento>>(
      key: _futureKey,
      future: eventoApi.consultaMinhasInscricoes(
        widget.evento.id,
        pagina: 1,
        tamanhoPagina: 50,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.totalResultados > 0) {
          return Column(
            children: <Widget>[
              InfoDivider(
                child: IntlText("evento.minhas_inscricoes"),
              ),
              for (InscricaoEvento inscricao in snapshot.data.resultados)
                Material(
                  color: Colors.white,
                  shape: Border(
                    top: BorderSide(
                      color: Colors.black54,
                      width: .5,
                    ),
                    bottom: BorderSide(
                      color: Colors.black54,
                      width: .5,
                    ),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    title: Text(inscricao.nomeInscrito),
                    subtitle: Text(inscricao.emailInscrito),
                    trailing:
                        IntlText("evento.status_inscricao." + inscricao.status),
                  ),
                ),
              if (snapshot.data.resultados
                  .any((insc) => insc.status == 'CONFIRMADA'))
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: RawMaterialButton(
                      onPressed: () {
                        NavigatorUtil.navigate(
                          context,
                          builder: (context) => PageComprovantesInscricao(
                            evento: widget.evento,
                            inscricoes: snapshot.data.resultados
                                .where(
                                  (insc) => insc.status == 'CONFIRMADA',
                                )
                                .toList(),
                          ),
                        );
                      },
                      padding: const EdgeInsets.all(15),
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.description),
                          const SizedBox(width: 5),
                          IntlText(
                            "evento.comprovantes",
                            style: TextStyle(
                              color: tema.buttonText,
                            ),
                          ),
                        ],
                      ),
                      fillColor: tema.buttonBackground,
                    ),
                  ),
                ),
            ],
          );
        }

        return Container();
      },
    );
  }

  String _textButton() {
    if (widget.evento.inscricoesFuturas) {
      return "evento.inscricoes_ainda_nao_disponiveis";
    } else if (widget.evento.inscricoesPassadas) {
      return "evento.inscricoes_encerradas";
    }

    if (widget.evento.vagasRestantes == 0) {
      return "evento.sem_vagas";
    }

    return "evento.realizar_inscricao";
  }
}
