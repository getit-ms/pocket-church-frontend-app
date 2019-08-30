part of pocket_church.enquete;

class PageResultadoEnquete extends StatelessWidget {
  final Enquete enquete;

  const PageResultadoEnquete({this.enquete});

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: Text(enquete.nome),
      body: ResultadoForm(
        enquete: enquete,
      ),
    );
  }
}


class ResultadoForm extends StatefulWidget {

  final Enquete enquete;

  const ResultadoForm({this.enquete});

  @override
  State<StatefulWidget> createState() => ResultadoFormState();

}

class ResultadoFormState extends State<ResultadoForm> with TickerProviderStateMixin {


  ResultadoEnquete resultado;
  List<Color> cores;

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    enqueteApi
        .resultado(widget.enquete.id)
        .then((resultado) {

      _tabController = TabController(length: resultado.questoes.length, vsync: this);

      setState(() {
        this.resultado = resultado;
        this.cores = _generateColors(resultado.questoes.map((q) => q.validos.length).reduce((c1, c2) => c1 > c2 ? c1 : c2));
      });

    });
  }

  List<Color> _generateColors(int count) {
    Random _random = Random(count);

    List<Color> cs = [];

    for (var i=0;i<count;i++) {
      cs.add(Color.fromARGB(0xff, _random.nextInt(0xff), _random.nextInt(0xff), _random.nextInt(0xff)));
    }

    return cs;
  }

  @override
  Widget build(BuildContext context) {
    if (resultado == null) {
      return const Center(
          child: CircularProgressIndicator()
      );
    }

    return _content();
  }

  Widget _content() {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Column(
      children: <Widget>[
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: resultado.questoes.map(_resultadoQuestao).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TabPageSelector(
            controller: _tabController,
            color: tema.primary.withOpacity(.5),
            selectedColor: tema.primary,
          ),
        )
      ],
    );
  }

  Widget _resultadoQuestao(ResultadoQuestao questao) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text("${resultado.questoes.indexOf(questao) + 1}"),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black26
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Flexible(
                          child: Text(questao.questao,
                            style: const TextStyle(
                                fontSize: 17
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: charts.PieChart([
                        charts.Series(
                            id: questao.toString(),
                            data: questao.validos,
                            measureFn: (o, i) => o.resultado,
                            domainFn: (o, i) => o.opcao,
                            colorFn: (o, i) => charts.Color.fromHex(
                                code: "#${(cores[i].value & 0x00FFFFFF).toRadixString(16)}"
                            )
                        )
                      ]),
                    ),
                    _buildLegenda(questao)
                  ],
                )
            )
        ),
      ),
    );
  }

  Container _buildLegenda(ResultadoQuestao questao) {
    return Container(
      decoration: BoxDecoration(
          border: const Border(
              bottom: BorderSide(
                  width: .5,
                  color: Colors.black12
              ),
              top: BorderSide(
                  width: .5,
                  color: Colors.black12
              )
          )
      ),
      child: Column(
        children: questao.validos.map((o) => _buildItemLegenda(questao: questao, opcao: o)).toList(),
      ),
    );
  }

  Widget _buildItemLegenda({
    ResultadoQuestao questao,
    ResultadoOpcao opcao
  }) {
    return Container(
      decoration: BoxDecoration(
          border: const Border(
              bottom: BorderSide(
                  width: .5,
                  color: Colors.black12
              ),
              top: BorderSide(
                  width: .5,
                  color: Colors.black12
              )
          )
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            height: 25,
            width: 25,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cores[questao.validos.indexOf(opcao)],
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Text(opcao.opcao),
          ),
          const SizedBox(width: 10,),
          SizedBox(
            width: 50,
            child: Text(opcao.resultado.toString(),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}