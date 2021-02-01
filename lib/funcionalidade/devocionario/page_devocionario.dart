part of pocket_church.devocionario;

class PageDevocionario extends StatelessWidget {
  final DiaDevocionario diaDevocionario;

  PageDevocionario({this.diaDevocionario});

  Future<List<DiaDevocionario>> _buscaDias(DateTime hoje) async {
    List<DiaDevocionario> dias = [];

    DateTime di = DateTime(hoje.year, hoje.month - 1, 1);
    DateTime df = DateTime(hoje.year, hoje.month + 4, 0);

    Pagina<DiaDevocionario> resultado = await devocionarioApi.consulta(
      dataInicio: di,
      dataTermino: df,
      pagina: 1,
      tamanhoPagina: dias.length,
    );

    if (resultado.resultados != null) {
      for (DateTime d = di;
          d.millisecondsSinceEpoch <= df.millisecondsSinceEpoch;
          d = DateTime(d.year, d.month, d.day + 1)) {
        dias.add(new DiaDevocionario(data: d));
      }

      resultado.resultados.forEach((dia) {
        int idx = dias.indexWhere((d) =>
            d.data.year == dia.data.year &&
            d.data.month == dia.data.month &&
            d.data.day == dia.data.day);

        if (idx >= 0) {
          dias.replaceRange(idx, idx + 1, [dia]);
        }
      });
    }

    return dias;
  }

  @override
  Widget build(BuildContext context) {
    DateTime hoje = DateTime.now();
    hoje = DateTime(hoje.year, hoje.month, hoje.day);

    return PageTemplate(
      title: const IntlText("devocionario.devocionario"),
      body: FutureBuilder<List<DiaDevocionario>>(
          future: _buscaDias(hoje),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data?.isNotEmpty ?? false) {
                return _buildDias(hoje, snapshot.data);
              } else {
                return _nenhumRegistroEncontrado();
              }
            } else if (snapshot.hasError) {
              return _buildError(snapshot.error);
            } else {
              return _buildLoading();
            }
          }),
    );
  }

  Container _buildError(ex) {
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
            child: error.resolveMessage(ex),
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: const CircularProgressIndicator());
  }

  Widget _buildDias(DateTime hoje, List<DiaDevocionario> dias) {
    PageController pageController = new PageController(
      initialPage: dias.indexWhere((d) => d.data == hoje),
      viewportFraction: .7,
    );

    return PageView.builder(
      scrollDirection: Axis.vertical,
      controller: pageController,
      itemCount: dias.length,
      itemBuilder: (context, index) => _buildDia(context, dias[index]),
    );
  }

  Widget _buildDia(BuildContext context, DiaDevocionario dia) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: CustomElevatedButton(
        onPressed: dia.id == null
            ? null
            : () {
                NavigatorUtil.navigate(
                  context,
                  builder: (context) => GaleriaPDF(
                    titulo: configuracaoBloc.currentBundle
                        .get('devocionario.devocionario'),
                    arquivo: dia.arquivo,
                  ),
                );
              },
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey[300],
                    Colors.grey[400],
                  ],
                ),
              ),
              child: dia.id == null
                  ? Container()
                  : Image(
                      image: ArquivoImageProvider(
                        dia.thumbnail.id,
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black45,
                    Colors.transparent,
                  ],
                ),
              ),
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              top: 15,
              right: 15,
              child: Column(
                children: <Widget>[
                  Text(
                    StringUtil.formatData(dia.data, pattern: 'dd'),
                    style: TextStyle(
                      fontSize: 55,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    StringUtil.formatData(dia.data, pattern: 'MMM yy'),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nenhumRegistroEncontrado() {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: IntlText(
        "global.nenhum_registro_encontrado",
        textAlign: TextAlign.center,
      ),
    );
  }
}
