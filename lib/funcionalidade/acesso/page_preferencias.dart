part of pocket_church.funcionalidade_acesso;

class PagePreferencias extends StatefulWidget {
  @override
  _PagePreferenciasState createState() => _PagePreferenciasState();
}

class _PagePreferenciasState extends State<PagePreferencias> {
  List<Ministerio> _ministerios;
  Preferencias _preferencias;

  GlobalKey<comp.PageTemplateState> _pageTemplate = new GlobalKey();

  Timer _timer;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    Preferencias prefs = await acessoApi.buscaPreferencias();

    setState(() {
      _preferencias = prefs;
    });

    List<Ministerio> mins = await acessoApi.buscaMinisterios();

    setState(() {
      _ministerios = mins;
    });
  }

  @override
  Widget build(BuildContext context) {
    return comp.PageTemplate(
      backgroundColor: Colors.white,
      key: _pageTemplate,
      title: const IntlText("preferencias.preferencias"),
      body: _content(),
    );
  }

  _save() async {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(
      const Duration(milliseconds: 500),
      () async {
        await acessoApi.salvaPreferencias(_preferencias);

        comp.MessageHandler.success(
          _pageTemplate.currentState.scaffold,
          const IntlText("mensagens.MSG-001"),
        );
      },
    );
  }

  _content() {
    if (_preferencias == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _indicadorVisibilidadeDados(),
          _receberNotificacoesVideos(),
          _versiculoDiario(),
          _leituraBiblica(),
          _notificacaoDevocionario(),
          _ministeriosNotificacao(),
          const InfoDivider(
            child: IntlText("preferencias.outros"),
          ),
          _templateAplicativo(),
          _politicaPrivacidade(),
        ],
      ),
    );
  }

  Widget _politicaPrivacidade() {
    return RawMaterialButton(
      onPressed: () {
        LaunchUtil.site(
            "https://getitmobilesolutions.com/politica-privacidade.html");
      },
      child: ItemPreferencias(
        icon: Icons.assignment,
        label: const IntlText("preferencias.politica_privacidade"),
      ),
    );
  }

  Widget _ministeriosNotificacao() {
    if (_ministerios?.isNotEmpty ?? false) {
      return Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const InfoDivider(
            child: const IntlText("preferencias.ministerios_interesse"),
          ),
          OpcaoPreferencias(
            label: const IntlText("preferencias.todos_ministerios"),
            value: _preferencias.ministeriosInteresse?.length ==
                _ministerios.length,
            onChanged: (selected) {
              setState(() {
                if (selected) {
                  _preferencias.ministeriosInteresse =
                      <Ministerio>[].followedBy(_ministerios).toList();
                } else {
                  _preferencias.ministeriosInteresse.clear();
                }
              });

              _save();
            },
          )
        ]
            .followedBy(_ministerios.map((min) => OpcaoPreferencias(
                  label: Text(min.nome),
                  value: _preferencias.ministeriosInteresse?.contains(min) ??
                      false,
                  onChanged: (selected) {
                    setState(() {
                      if (selected) {
                        _preferencias.ministeriosInteresse = <Ministerio>[]
                            .followedBy(
                                _preferencias.ministeriosInteresse ?? [])
                            .followedBy([min]).toList();
                      } else {
                        _preferencias.ministeriosInteresse.remove(min);
                      }
                    });

                    _save();
                  },
                )))
            .toList(),
      );
    }

    return Container();
  }

  Widget _indicadorVisibilidadeDados() {
    return OpcaoPreferencias(
      icon: (_preferencias.dadosDisponiveis ?? false)
          ? Icons.visibility
          : Icons.visibility_off,
      label: IntlText("preferencias.deseja_disponibilizar_dados"),
      value: _preferencias.dadosDisponiveis ?? false,
      onChanged: (selected) {
        setState(() {
          _preferencias.dadosDisponiveis = selected;
        });

        _save();
      },
    );
  }

  Widget _receberNotificacoesVideos() {
    if (acessoBloc.temAcesso(Funcionalidade.YOUTUBE)) {
      return OpcaoPreferencias(
        icon: Icons.ondemand_video,
        label: IntlText("preferencias.deseja_receber_notificacoes_video"),
        value: _preferencias.desejaReceberNotificacoesVideos ?? false,
        onChanged: (selected) {
          setState(() {
            _preferencias.desejaReceberNotificacoesVideos = selected;
          });

          _save();
        },
      );
    }

    return Container();
  }

  _templateAplicativo() {
    return RawMaterialButton(
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
        NavigatorUtil.navigate(
          context,
          replace: true,
          builder: (context) => PageApresentacao(
            trocaTemplate: true,
          ),
        );
      },
      child: ItemPreferencias(
        icon: Icons.compare_arrows,
        label: const IntlText("preferencias.trocar_template"),
      ),
    );
  }

  _versiculoDiario() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        const InfoDivider(
          child: IntlText("preferencias.versiculo_diario"),
        ),
        OpcaoPreferencias(
          icon: Icons.add_alert,
          label: IntlText("preferencias.deseja_receber_versiculos"),
          value: _preferencias.desejaReceberVersiculosDiarios ?? false,
          onChanged: (selected) {
            setState(() {
              _preferencias.desejaReceberVersiculosDiarios = selected;
            });

            _save();
          },
        ),
        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: SelectOpcao<String>(
            value: _preferencias.horaVersiculoDiario,
            onChange: (hora) {
              setState(() {
                _preferencias.horaVersiculoDiario = hora;
              });

              _save();
            },
            opcoes: [
              Opcao(intlLabel: "preferencias.hora._08_00", valor: "_08_00"),
              Opcao(intlLabel: "preferencias.hora._14_00", valor: "_14_00"),
              Opcao(intlLabel: "preferencias.hora._20_00", valor: "_20_00"),
            ],
          ),
          crossFadeState: _preferencias.desejaReceberVersiculosDiarios
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  _leituraBiblica() {
    if (acessoBloc.temAcesso(Funcionalidade.CONSULTAR_PLANOS_LEITURA_BIBLICA)) {
      return Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const InfoDivider(
            child: IntlText("preferencias.leitura_biblica"),
          ),
          OpcaoPreferencias(
            icon: Icons.chrome_reader_mode,
            label: IntlText("preferencias.deseja_receber_lembrete_leitura"),
            value: _preferencias.desejaReceberLembreteLeitura ?? false,
            onChanged: (selected) {
              setState(() {
                _preferencias.desejaReceberLembreteLeitura = selected;
              });

              _save();
            },
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: SelectOpcao<String>(
              value: _preferencias.horaLembreteLeitura,
              onChange: (hora) {
                setState(() {
                  _preferencias.horaLembreteLeitura = hora;
                });

                _save();
              },
              opcoes: [
                Opcao(intlLabel: "preferencias.hora._08_00", valor: "_08_00"),
                Opcao(intlLabel: "preferencias.hora._14_00", valor: "_14_00"),
                Opcao(intlLabel: "preferencias.hora._20_00", valor: "_20_00"),
              ],
            ),
            crossFadeState: _preferencias.desejaReceberLembreteLeitura
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      );
    }

    return Container();
  }

  _notificacaoDevocionario() {
    if (acessoBloc.temAcesso(Funcionalidade.DEVOCIONARIO)) {
      return Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const InfoDivider(
            child: IntlText("preferencias.devocionario"),
          ),
          OpcaoPreferencias(
            icon: Icons.calendar_today,
            label: IntlText("preferencias.deseja_receber_lembrete_devocionario"),
            value: _preferencias.desejaReceberNotificacoesDevocionario ?? false,
            onChanged: (selected) {
              setState(() {
                _preferencias.desejaReceberNotificacoesDevocionario = selected;
              });

              _save();
            },
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: SelectOpcao<String>(
              value: _preferencias.horaNotificacoesDevocional,
              onChange: (hora) {
                setState(() {
                  _preferencias.horaNotificacoesDevocional = hora;
                });

                _save();
              },
              opcoes: [
                Opcao(intlLabel: "preferencias.hora._08_00", valor: "_08_00"),
                Opcao(intlLabel: "preferencias.hora._14_00", valor: "_14_00"),
                Opcao(intlLabel: "preferencias.hora._20_00", valor: "_20_00"),
              ],
            ),
            crossFadeState: _preferencias.desejaReceberNotificacoesDevocionario ?? false
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      );
    }

    return Container();
  }
}

class ItemPreferencias extends StatelessWidget {
  final IconData icon;
  final Widget label;
  final Widget trailing;

  const ItemPreferencias({this.icon, this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          icon != null
              ? Icon(
                  icon,
                  size: 30,
                  color: Colors.black38,
                )
              : Container(),
          icon != null
              ? SizedBox(
                  width: 20,
                )
              : Container(),
          Expanded(
            child: label,
          ),
          trailing != null
              ? const SizedBox(
                  width: 10,
                )
              : Container(),
          trailing ?? Container()
        ],
      ),
    );
  }
}

class OpcaoPreferencias extends StatelessWidget {
  final IconData icon;
  final Widget label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const OpcaoPreferencias({this.icon, this.label, this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return ItemPreferencias(
      icon: icon,
      label: label,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: tema.primary,
      ),
    );
  }
}
