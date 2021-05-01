part of pocket_church.ebd;

class PageEBD extends StatelessWidget {
  final Evento ebd;

  PageEBD({this.ebd});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: IntlText("ebd.ebd"),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<Evento>(
            future: eventoApi.detalha(ebd.id),
            builder: (context, snapshot) {
              return new EBDContent(ebd: snapshot.data ?? ebd);
            }),
      ),
    );
  }
}

class EBDContent extends StatefulWidget {
  const EBDContent({
    Key key,
    @required this.ebd,
  }) : super(key: key);

  final Evento ebd;

  @override
  _EBDContentState createState() => _EBDContentState();
}

class _EBDContentState extends State<EBDContent> {
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
              widget.ebd.nome,
              style: TextStyle(
                color: tema.primary,
                fontSize: 22,
              ),
            ),
          ),
          widget.ebd.banner != null
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
                            title: const IntlText("ebd.ebd"),
                            images: [
                              ImageView(
                                heroTag: "banner",
                                image:
                                    ArquivoImageProvider(widget.ebd.banner.id),
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
                        image: ArquivoImageProvider(widget.ebd.banner.id),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                )
              : Container(),
          ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              widget.ebd.descricao ?? "",
            ),
          ),
          new ItemEBD(
            label: IntlText("ebd.dataHoraInicio"),
            value: Text(
              StringUtil.formatData(
                widget.ebd.dataHoraInicio,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          new ItemEBD(
            label: IntlText("ebd.dataHoraTermino"),
            value: Text(
              StringUtil.formatData(
                widget.ebd.dataHoraTermino,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          InfoDivider(
            child: IntlText("ebd.inscricao"),
          ),
          new ItemEBD(
            label: IntlText("ebd.vagas"),
            value: Text(
              widget.ebd.limiteInscricoes.toString(),
            ),
          ),
          new ItemEBD(
            label: IntlText("ebd.dataHoraInicioInscricao"),
            value: Text(
              StringUtil.formatData(
                widget.ebd.dataInicioInscricao,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          new ItemEBD(
            label: IntlText("ebd.dataHoraTerminoInscricao"),
            value: Text(
              StringUtil.formatData(
                widget.ebd.dataTerminoInscricao,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          widget.ebd.exigePagamento
              ? new ItemEBD(
                  label: IntlText("ebd.valor"),
                  value: Text(
                    StringUtil.formataCurrency(
                      widget.ebd.valor ?? 0,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: widget.ebd.inscricoesAbertas &&
                        widget.ebd.vagasRestantes > 0
                    ? () {
                        NavigatorUtil.navigate(
                          context,
                          builder: (context) => PageInscricaoEBD(
                            ebd: widget.ebd,
                          ),
                        ).then((sucesso) {
                          if (sucesso != null && sucesso) {
                            MessageHandler.success(
                              Scaffold.of(context),
                              IntlText("mensagens.MSG-001"),
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
                fillColor: widget.ebd.inscricoesAbertas &&
                        widget.ebd.vagasRestantes > 0
                    ? tema.buttonBackground
                    : Colors.black45,
              ),
            ),
          ),
          _listaInscricoes(context),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
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
        widget.ebd.id,
        pagina: 1,
        tamanhoPagina: 50,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.totalResultados > 0) {
          return Column(
            children: <Widget>[
              InfoDivider(
                child: IntlText("ebd.minhas_inscricoes"),
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
                    title: Text(
                      inscricao.nomeInscrito,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      inscricao.emailInscrito,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Column(
                      children: [
                        inscricao.status == 'PENDENTE'
                            ? Icon(
                                Icons.pending,
                                size: 32,
                                color: Colors.orangeAccent,
                              )
                            : inscricao.status == 'CONFIRMADA'
                                ? Icon(
                                    Icons.check_circle,
                                    size: 32,
                                    color: const Color(0xFF148918),
                                  )
                                : Icon(
                                    Icons.cancel,
                                    size: 32,
                                    color: Colors.grey,
                                  ),
                        const SizedBox(height: 5),
                        IntlText(
                          "ebd.status_inscricao." + inscricao.status,
                          style: TextStyle(fontSize: 9),
                        ),
                      ],
                    ),
                    trailing: inscricao.status != 'CANCELADA' &&
                            widget.ebd.dataHoraInicio.isAfter(DateTime.now())
                        ? CommandButton<void>(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            background: Colors.red,
                            onPressed: (loading) async {
                              bool confirmado = await NavigatorUtil.confirma(
                                context,
                                message: IntlText("mensagens.MSG-067"),
                                title: IntlText("ebd.cancelamento"),
                              );

                              if (confirmado) {
                                await loading(eventoApi.cancelaInscricao(
                                    widget.ebd.id, inscricao.id));

                                setState(() {
                                  inscricao.status = 'CANCELADA';
                                  widget.ebd.vagasRestantes += 1;
                                });
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                IntlText("global.cancelar"),
                              ],
                            ),
                          )
                        : null,
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
                            ebd: widget.ebd,
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
                            "ebd.comprovantes",
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
    if (widget.ebd.inscricoesFuturas) {
      return "ebd.inscricoes_ainda_nao_disponiveis";
    } else if (widget.ebd.inscricoesPassadas) {
      return "ebd.inscricoes_encerradas";
    }

    if (widget.ebd.vagasRestantes == 0) {
      return "ebd.sem_vagas";
    }

    return "ebd.realizar_inscricao";
  }
}
