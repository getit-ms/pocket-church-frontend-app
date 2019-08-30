part of pocket_church.evento;

class PageEvento extends StatelessWidget {
  final Evento evento;

  PageEvento({this.evento});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      deveEstarAutenticado: true,
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

class EventoContent extends StatelessWidget {
  const EventoContent({
    Key key,
    @required this.evento,
  }) : super(key: key);

  final Evento evento;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              evento.nome,
              style: TextStyle(
                color: tema.primary,
                fontSize: 22,
              ),
            ),
          ),
          evento.banner != null
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
                            title: const IntlText("evento.edb"),
                            images: [
                              ImageView(
                                heroTag: "banner",
                                image: ArquivoImageProvider(evento.banner.id),
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
                        image: ArquivoImageProvider(evento.banner.id),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                )
              : Container(),
          ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              evento.descricao ?? "",
            ),
          ),
          new ItemEvento(
            label: IntlText("evento.dataHoraInicio"),
            value: Text(
              StringUtil.formatData(
                evento.dataHoraInicio,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          new ItemEvento(
            label: IntlText("evento.dataHoraTermino"),
            value: Text(
              StringUtil.formatData(
                evento.dataHoraTermino,
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
              evento.limiteInscricoes.toString(),
            ),
          ),
          new ItemEvento(
            label: IntlText("evento.dataHoraInicioInscricao"),
            value: Text(
              StringUtil.formatData(
                evento.dataInicioInscricao,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          new ItemEvento(
            label: IntlText("evento.dataHoraTerminoInscricao"),
            value: Text(
              StringUtil.formatData(
                evento.dataTerminoInscricao,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          evento.exigePagamento
              ? new ItemEvento(
                  label: IntlText("evento.valor"),
                  value: Text(
                    StringUtil.formataCurrency(
                      evento.valor ?? 0,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: evento.inscricoesAbertas && evento.vagasRestantes > 0
                    ? () {
                        NavigatorUtil.navigate(
                          context,
                          builder: (context) => PageInscricaoEvento(
                            evento: evento,
                          ),
                        );
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
                fillColor: evento.inscricoesAbertas && evento.vagasRestantes > 0
                    ? tema.buttonBackground
                    : Colors.black45,
              ),
            ),
          ),
          _listaInscricoes()
        ],
      ),
    );
  }

  FutureBuilder<Pagina<InscricaoEvento>> _listaInscricoes() {
    return FutureBuilder<Pagina<InscricaoEvento>>(
      future: eventoApi.consultaMinhasInscricoes(
        evento.id,
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
            ].followedBy(snapshot.data.resultados.map((inscricao) {
              return Material(
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
              );
            })).toList(),
          );
        }

        return Container();
      },
    );
  }

  String _textButton() {
    if (evento.inscricoesFuturas) {
      return "evento.inscricoes_ainda_nao_disponiveis";
    } else if (evento.inscricoesPassadas) {
      return "evento.inscricoes_encerradas";
    }

    if (evento.vagasRestantes == 0) {
      return "evento.sem_vagas";
    }

    return "evento.realizar_inscricao";
  }
}
