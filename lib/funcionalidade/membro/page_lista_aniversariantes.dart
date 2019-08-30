part of pocket_church.membro;

class PageListaAniversariantes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: IntlText("contato.aniversariantes"),
      deveEstarAutenticado: true,
      body: FutureBuilder<List<Membro>>(
        future: membroApi.buscaAniversariantes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return _buildAniversariantes(context, snapshot.data);
            } else if (snapshot.hasError) {
              return _buildError(snapshot.error);
            } else {
              return _buildSemRegistros();
            }
          }

          return _buildLoading();
        },
      ),
    );
  }

  Widget _buildAniversariantes(BuildContext context,
      List<Membro> aniversariantes) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildAniversariantesDia(context, aniversariantes),
          _buildOutrosAniversariantes(context, aniversariantes)
        ],
      ),
    );
  }

  Widget _buildSemRegistros() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            FontAwesomeIcons.birthdayCake,
            color: Colors.black38,
            size: 66,
          ),
          const SizedBox(
            height: 10,
          ),
          const IntlText("global.nenhum_registro_encontrado")
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(dynamic ex) {
    return Container(
      padding: EdgeInsets.all(50),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            error.resolveIcon(ex),
            color: Colors.black38,
            size: 66,
          ),
          const SizedBox(
            height: 10,
          ),
          DefaultTextStyle(
            style: TextStyle(),
            textAlign: TextAlign.center,
            child: error.resolveMessage(ex),
          )
        ],
      ),
    );
  }

  _buildAniversariantesDia(BuildContext context, List<Membro> aniversariantes) {
    DateTime hoje = DateTime.now().toLocal();

    int nivHoje = hoje.month * 100 + hoje.day;

    List<Membro> aniversariantesHoje = aniversariantes
        .where((membro) => nivHoje == membro.diaAniversario)
        .toList();

    if (aniversariantesHoje.isNotEmpty) {
      return Column(
        children: <Widget>[
          InfoDivider(
            child: IntlText("global.hoje"),
          ),
          Card(
            child: Wrap(
              runSpacing: 20,
              spacing: 20,
              children: aniversariantesHoje.map((membro) {
                return SizedBox(
                  width: 120,
                  child: RawMaterialButton(
                    onPressed: () {
                      NavigatorUtil.navigate(
                        context,
                        builder: (context) =>
                            PageContato(
                              membro: membro,
                            ),
                      );
                    },
                    elevation: 0,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        ClipRRect(
                          child: FotoMembro(
                            membro.foto,
                            size: 100,
                          ),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(50)),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          StringUtil.nomeResumido(membro.nome),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    }

    return Container();
  }

  _buildOutrosAniversariantes(BuildContext context,
      List<Membro> aniversariantes) {
    DateTime hoje = DateTime.now().toLocal();

    int nivHoje = hoje.month * 100 + hoje.day;

    List<Membro> outrosAniversariantes = aniversariantes
        .where((membro) => nivHoje != membro.diaAniversario)
        .toList();

    List<List<Membro>> agrupados = [];

    List<Membro> grupo = null;
    for (Membro membro in outrosAniversariantes) {
      if (grupo == null || grupo[0].diaAniversario != membro.diaAniversario) {
        agrupados.add(grupo = [membro]);
      } else {
        grupo.add(membro);
      }
    }

    return Container(
      child: Column(
        children: agrupados.map((grupo) {
          return Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InfoDivider(
                  child: _buildLabel(grupo[0].diaAniversario),
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runSpacing: 5,
                  spacing: 5,
                  children: grupo.map((membro) {
                    return SizedBox(
                      width: 90,
                      child: RawMaterialButton(
                        fillColor: Colors.white,
                        onPressed: () {
                          NavigatorUtil.navigate(
                            context,
                            builder: (context) =>
                                PageContato(
                                  membro: membro,
                                ),
                          );
                        },
                        elevation: 0,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            ClipRRect(
                              child: FotoMembro(
                                membro.foto,
                                size: 50,
                              ),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              StringUtil.nomeResumido(membro.nome),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLabel(int diaAniversario) {
    DateTime amanha = DateTime.now().toLocal().add(Duration(days: 1));

    if (diaAniversario == amanha.month * 100 + amanha.day) {
      return IntlText("global.amanha");
    }

    return Text(StringUtil.formatData(
      DateTime(amanha.year, (diaAniversario / 100).round(), diaAniversario % 100),
      pattern: "dd MMMM",),);
  }
}
