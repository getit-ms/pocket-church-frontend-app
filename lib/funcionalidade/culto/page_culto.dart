part of pocket_church.culto;

class PageCulto extends StatelessWidget {
  final Evento culto;

  PageCulto({this.culto});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: IntlText("culto.culto"),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<Evento>(
            future: eventoApi.detalha(culto.id),
            builder: (context, snapshot) {
              return new CultoContent(culto: snapshot.data ?? culto);
            }),
      ),
    );
  }
}

class CultoContent extends StatefulWidget {
  const CultoContent({
    Key key,
    @required this.culto,
  }) : super(key: key);

  final Evento culto;

  @override
  _CultoContentState createState() => _CultoContentState();
}

class _CultoContentState extends State<CultoContent> {
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
              widget.culto.nome,
              style: TextStyle(
                color: tema.primary,
                fontSize: 22,
              ),
            ),
          ),
          widget.culto.banner != null
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
                            title: const IntlText("culto.culto"),
                            images: [
                              ImageView(
                                heroTag: "banner",
                                image: ArquivoImageProvider(
                                    widget.culto.banner.id),
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
                        image: ArquivoImageProvider(widget.culto.banner.id),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                )
              : Container(),
          ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              widget.culto.descricao ?? "",
            ),
          ),
          new ItemCulto(
            label: IntlText("culto.dataHoraInicio"),
            value: Text(
              StringUtil.formatData(
                widget.culto.dataHoraInicio,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          new ItemCulto(
            label: IntlText("culto.dataHoraTermino"),
            value: Text(
              StringUtil.formatData(
                widget.culto.dataHoraTermino,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          InfoDivider(
            child: IntlText("culto.inscricao"),
          ),
          new ItemCulto(
            label: IntlText("culto.vagas"),
            value: Text(
              widget.culto.limiteInscricoes.toString(),
            ),
          ),
          new ItemCulto(
            label: IntlText("culto.dataHoraInicioInscricao"),
            value: Text(
              StringUtil.formatData(
                widget.culto.dataInicioInscricao,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          new ItemCulto(
            label: IntlText("culto.dataHoraTerminoInscricao"),
            value: Text(
              StringUtil.formatData(
                widget.culto.dataTerminoInscricao,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          widget.culto.exigePagamento
              ? new ItemCulto(
                  label: IntlText("culto.valor"),
                  value: Text(
                    StringUtil.formataCurrency(
                      widget.culto.valor ?? 0,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: widget.culto.inscricoesAbertas &&
                        widget.culto.vagasRestantes > 0
                    ? () {
                        NavigatorUtil.navigate(
                          context,
                          builder: (context) => PageInscricaoCulto(
                            culto: widget.culto,
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
                fillColor: widget.culto.inscricoesAbertas &&
                        widget.culto.vagasRestantes > 0
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
        widget.culto.id,
        pagina: 1,
        tamanhoPagina: 50,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.totalResultados > 0) {
          return Column(
            children: <Widget>[
              InfoDivider(
                child: IntlText("culto.minhas_inscricoes"),
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
                          "culto.status_inscricao." + inscricao.status,
                          style: TextStyle(fontSize: 9),
                        ),
                      ],
                    ),
                    trailing: inscricao.status != 'CANCELADA' &&
                            widget.culto.dataHoraInicio.isAfter(DateTime.now())
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
                                title: IntlText("culto.cancelamento"),
                              );

                              if (confirmado) {
                                await loading(eventoApi.cancelaInscricao(
                                    widget.culto.id, inscricao.id));

                                setState(() {
                                  inscricao.status = 'CANCELADA';
                                  widget.culto.vagasRestantes += 1;
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
                            culto: widget.culto,
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
                            "culto.comprovantes",
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
    if (widget.culto.inscricoesFuturas) {
      return "culto.inscricoes_ainda_nao_disponiveis";
    } else if (widget.culto.inscricoesPassadas) {
      return "culto.inscricoes_encerradas";
    }

    if (widget.culto.vagasRestantes == 0) {
      return "culto.sem_vagas";
    }

    return "culto.realizar_inscricao";
  }
}
