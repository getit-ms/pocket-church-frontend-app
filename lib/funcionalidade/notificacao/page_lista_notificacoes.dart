part of pocket_church.notificacao;

class PageListaNotificacoes extends StatefulWidget {
  @override
  _PageListaNotificacoesState createState() => _PageListaNotificacoesState();
}

class _PageListaNotificacoesState extends State<PageListaNotificacoes> {
  GlobalKey<InfiniteListState> _listKey = new GlobalKey();

  bool _removing = false;
  bool _removeAll = false;
  List<int> _selected = [];

  _prepareRemoving() {
    setState(() {
      _removing = true;
      _removeAll = false;
      _selected = [];
    });
  }

  _cancelRemoving() {
    setState(() {
      _removing = false;
      _removeAll = false;
      _selected = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    return PageTemplate(
      title: const IntlText("notificacao.notificacoes"),
      actions: <Widget>[
        AnimatedCrossFade(
          firstChild: IconButton(
            icon: Icon(Icons.delete),
            onPressed: _prepareRemoving,
          ),
          secondChild: SizedBox(
            width: 0,
          ),
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              _removing ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        )
      ],
      body: Column(
        children: <Widget>[
          AnimatedCrossFade(
            firstChild: SizedBox(
              height: 0,
            ),
            secondChild: Material(
              shape: Border(
                bottom: BorderSide(color: Colors.black54, width: .5),
              ),
              child: ListTile(
                leading: Checkbox(
                  value: _removeAll,
                  onChanged: (all) {
                    setState(() {
                      _selected = [];
                      _removeAll = all;
                    });
                  },
                ),
                title: IntlText("notificacao.selecionar_todos"),
                onTap: () {
                  setState(() {
                    _selected = [];
                    _removeAll = !_removeAll;
                  });
                },
              ),
            ),
            crossFadeState: _removing
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          Expanded(
            child: StreamBuilder<Bundle>(
                stream: configuracaoBloc.bundle,
                builder: (context, snapshot) {
                  return InfiniteList<Notificacao>(
                    key: _listKey,
                    tamanhoPagina: 30,
                    provider: (int pagina, int tamanhoPagina) async {
                      var resultado = await notificacaoApi.consulta(
                        pagina: pagina,
                        tamanhoPagina: tamanhoPagina,
                      );

                      if (pagina == 1) {
                        // Para que as badges sejam resetadas
                        acessoBloc.refreshMenu();
                      }

                      return resultado;
                    },
                    builder: (context, itens, index) {
                      Notificacao notificacao = itens[index];

                      if (index == 0 ||
                          !DateUtil.equalsDateOnly(
                              itens[index - 1].data, notificacao.data)) {
                        return Column(
                          children: <Widget>[
                            InfoDivider(
                              child: Text(
                                StringUtil.formatDataLegivel(
                                    notificacao.data, snapshot.data),
                              ),
                            ),
                            new ItemNotificacao(
                              notificacao: notificacao,
                              selected: _removing
                                  ? _removeAll !=
                                      _selected.contains(notificacao.id)
                                  : null,
                              onPressed: _removing
                                  ? () {
                                      setState(() {
                                        if (_selected
                                            .contains(notificacao.id)) {
                                          _selected.remove(notificacao.id);
                                        } else {
                                          _selected.add(notificacao.id);
                                        }
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        );
                      }

                      return new ItemNotificacao(
                        notificacao: notificacao,
                        selected: _removing
                            ? _removeAll != _selected.contains(notificacao.id)
                            : null,
                        onPressed: _removing
                            ? () {
                                setState(() {
                                  if (_selected.contains(notificacao.id)) {
                                    _selected.remove(notificacao.id);
                                  } else {
                                    _selected.add(notificacao.id);
                                  }
                                });
                              }
                            : null,
                      );
                    },
                  );
                }),
          ),
          AnimatedCrossFade(
            firstChild: SizedBox(
              height: 0,
            ),
            secondChild: Container(
              padding: const EdgeInsets.all(10) +
              EdgeInsets.only(bottom: mq.padding.bottom),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black54, width: .5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CommandButton<void>(
                      child: const IntlText("notificacao.excluir"),
                      onPressed: _removeAll || _selected.isNotEmpty
                          ? (loading) async {
                              if (_removeAll) {
                                bool confirmado = await NavigatorUtil.confirma(
                                  context,
                                  title: IntlText(
                                      "notificacao.confirmacao_exclusao"),
                                  message: IntlText("mensagens.MSG-062"),
                                );

                                if (confirmado) {
                                  _removeTodos(context, loading);
                                }
                              } else {
                                bool confirmado = await NavigatorUtil.confirma(
                                  context,
                                  title: IntlText(
                                      "notificacao.confirmacao_exclusao"),
                                  message: IntlText("mensagens.MSG-043"),
                                );

                                if (confirmado) {
                                  _removeLista(context, loading);
                                }
                              }
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CommandButton(
                      child: const IntlText("global.cancelar"),
                      onPressed: (loading) {
                        _cancelRemoving();
                      },
                      background: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            crossFadeState: _removing
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  _removeLista(BuildContext ctx, loading) async {
    Navigator.of(ctx).pop();

    for (int id in _selected) {
      await loading(
        notificacaoApi.remove(id),
      );
    }

    _cancelRemoving();

    _listKey.currentState.refresh();

    MessageHandler.success(
      Scaffold.of(context),
      IntlText("mensagens.MSG-001"),
    );
  }

  _removeTodos(BuildContext ctx, loading) async {
    await loading(
      notificacaoApi.clear(_selected),
    );

    _cancelRemoving();

    _listKey.currentState.refresh();

    MessageHandler.success(
      Scaffold.of(context),
      IntlText("mensagens.MSG-001"),
    );
  }
}

final RegExp REGEXP_LINK = RegExp("(https?://|www.)[^\\s]+");

class ItemNotificacao extends StatelessWidget {
  const ItemNotificacao({
    Key key,
    @required this.notificacao,
    this.selected,
    this.onPressed,
  }) : super(key: key);

  final Notificacao notificacao;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dto = json.decode(notificacao.notificacao);

    Tema tema = ConfiguracaoApp.of(context).tema;

    return RawMaterialButton(
      fillColor: Theme.of(context).cardColor,
      onPressed: _onTap(context, dto),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          _leading(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dto['title'],
                  style: TextStyle(
                    color: tema.primary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(dto['message']),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: _trailing(tema, dto),
            ),
            secondChild: Container(),
            crossFadeState: selected == null
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          )
        ],
      ),
    );
  }

  Widget _leading() {
    return AnimatedCrossFade(
      firstChild: Container(),
      secondChild: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Checkbox(
          value: selected ?? false,
          onChanged: (selected) {
            if (onPressed != null) {
              onPressed();
            }
          },
        ),
      ),
      crossFadeState: selected == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _trailing(Tema tema, Map<String, dynamic> dto) {
    if (dto['customData'] != null) {
      if (dto['customData']['compartilhavel'] ?? false) {
        return Icon(
          Icons.share,
          color: tema.primary,
        );
      }

      if (REGEXP_LINK.hasMatch(dto['message'])) {
        return Icon(
          Icons.link,
          color: tema.primary,
        );
      }

      if (dto['customData']['tipo'] != null) {
        switch (dto['customData']['tipo']) {
          case 'ACONSELHAMENTO':
          case 'BOLETIM':
          case 'PUBLICACAO':
          case 'ESTUDO':
          case 'NOTICIA':
          case 'EVENTO':
          case 'PEDIDO_ORACAO':
          case 'PLANO_LEITURA':
          case 'YOUTUBE':
            return Icon(
              Icons.keyboard_arrow_right,
              color: tema.primary,
            );
        }
      }
    }

    return Container();
  }

  VoidCallback _onTap(BuildContext context, Map<String, dynamic> dto) {
    if (onPressed != null) {
      return onPressed;
    }

    if (dto['customData'] != null) {
      if (dto['customData']['compartilhavel'] ?? false) {
        return () {
          Share.text(dto['title'], dto['message'], 'text/txt');
        };
      }

      if (REGEXP_LINK.hasMatch(dto['message'])) {
        return () {
          List<RegExpMatch> matches =
              REGEXP_LINK.allMatches(dto['message']).toList();

          if (matches.length > 1) {
            Scaffold.of(context).showBottomSheet(
              (context) => new BottomMenu(
                items: matches
                    .map((match) => BottomMenuItem(
                        icon: Icons.link,
                        label: Text(match.group(0)),
                        action: () {
                          LaunchUtil.site(match.group(0));
                        }))
                    .toList(),
              ),
            );
          } else {
            LaunchUtil.site(matches[0].group(0));
          }
        };
      }

      if (dto['customData']['tipo'] != null) {
        switch (dto['customData']['tipo']) {
          case 'ACONSELHAMENTO':
            return () => NavigatorUtil.navigate(context,
                builder: (context) => PageFactory.createPage(
                    context, Funcionalidade.AGENDAR_ACONSELHAMENTO));
          case 'BOLETIM':
            return () => NavigatorUtil.navigate(context,
                builder: (context) => PageFactory.createPage(
                    context, Funcionalidade.LISTAR_BOLETINS));
          case 'PUBLICACAO':
            return () => NavigatorUtil.navigate(context,
                builder: (context) => PageFactory.createPage(
                    context, Funcionalidade.LISTAR_PUBLICACOES));
          case 'ESTUDO':
            return () => NavigatorUtil.navigate(context,
                builder: (context) => PageFactory.createPage(
                    context, Funcionalidade.LISTAR_ESTUDOS));
          case 'NOTICIA':
            return () => NavigatorUtil.navigate(context,
                builder: (context) =>
                    PageFactory.createPage(context, Funcionalidade.NOTICIAS));
          case 'EVENTO':
            return () => NavigatorUtil.navigate(context,
                builder: (context) => PageFactory.createPage(
                    context, Funcionalidade.REALIZAR_INSCRICAO_EVENTO));
          case 'PEDIDO_ORACAO':
            return () => NavigatorUtil.navigate(context,
                builder: (context) => PageFactory.createPage(
                    context, Funcionalidade.PEDIR_ORACAO));
          case 'PLANO_LEITURA':
            return () => NavigatorUtil.navigate(context,
                builder: (context) => PageFactory.createPage(
                    context, Funcionalidade.CONSULTAR_PLANOS_LEITURA_BIBLICA));
          case 'YOUTUBE':
            return () => NavigatorUtil.navigate(context,
                builder: (context) =>
                    PageFactory.createPage(context, Funcionalidade.YOUTUBE));
        }
      }
    }

    return null;
  }
}
