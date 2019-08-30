part of pocket_church.ebd;

class PageEBD extends StatelessWidget {
  final Evento ebd;

  PageEBD({this.ebd});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      deveEstarAutenticado: true,
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

class EBDContent extends StatelessWidget {
  const EBDContent({
    Key key,
    @required this.ebd,
  }) : super(key: key);

  final Evento ebd;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              ebd.nome,
              style: TextStyle(
                color: tema.primary,
                fontSize: 22,
              ),
            ),
          ),
          ebd.banner != null
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
                            title: const IntlText("ebd.edb"),
                            images: [
                              ImageView(
                                heroTag: "banner",
                                image: ArquivoImageProvider(ebd.banner.id),
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
                        image: ArquivoImageProvider(ebd.banner.id),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                )
              : Container(),
          ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              ebd.descricao ?? "",
            ),
          ),
          new ItemEBD(
            label: IntlText("ebd.dataHoraInicio"),
            value: Text(
              StringUtil.formatData(
                ebd.dataHoraInicio,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          new ItemEBD(
            label: IntlText("ebd.dataHoraTermino"),
            value: Text(
              StringUtil.formatData(
                ebd.dataHoraTermino,
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
              ebd.limiteInscricoes.toString(),
            ),
          ),
          new ItemEBD(
            label: IntlText("ebd.dataHoraInicioInscricao"),
            value: Text(
              StringUtil.formatData(
                ebd.dataInicioInscricao,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          new ItemEBD(
            label: IntlText("ebd.dataHoraTerminoInscricao"),
            value: Text(
              StringUtil.formatData(
                ebd.dataTerminoInscricao,
                pattern: "dd MMMM yyyy HH:mm",
              ),
            ),
          ),
          ebd.exigePagamento
              ? new ItemEBD(
                  label: IntlText("ebd.valor"),
                  value: Text(
                    StringUtil.formataCurrency(
                      ebd.valor ?? 0,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                onPressed: ebd.inscricoesAbertas && ebd.vagasRestantes > 0
                    ? () {
                        NavigatorUtil.navigate(
                          context,
                          builder: (context) => PageInscricaoEBD(
                            ebd: ebd,
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
                fillColor: ebd.inscricoesAbertas && ebd.vagasRestantes > 0
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
        ebd.id,
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
                      IntlText("ebd.status_inscricao." + inscricao.status),
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
    if (ebd.inscricoesFuturas) {
      return "ebd.inscricoes_ainda_nao_disponiveis";
    } else if (ebd.inscricoesPassadas) {
      return "ebd.inscricoes_encerradas";
    }

    if (ebd.vagasRestantes == 0) {
      return "ebd.sem_vagas";
    }

    return "ebd.realizar_inscricao";
  }
}
