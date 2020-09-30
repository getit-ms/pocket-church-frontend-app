part of pocket_church.leitura;

class CalendarioLeitura extends StatefulWidget {
  @override
  _CalendarioLeituraState createState() => _CalendarioLeituraState();
}

class _CalendarioLeituraState extends State<CalendarioLeitura> {
  PageController _pageController;
  List<DateTime> _datas;

  @override
  void initState() {
    super.initState();

    _pageController = new PageController(
      viewportFraction: .8,
    );

    _buscaDatas();
  }

  _buscaDatas() async {
    PeriodoDatas periodo = await leituraDAO.findRangeDatas();

    List<DateTime> datas = [];

    DateTime dataInicio = DateTime(periodo.dataInicio.year,
        periodo.dataInicio.month, periodo.dataInicio.day);
    DateTime dataTermino = DateTime(periodo.dataTermino.year,
        periodo.dataTermino.month, periodo.dataTermino.day);

    for (DateTime i = dataInicio;
        !i.isAfter(dataTermino);
        i = DateTime(i.year, i.month, i.day + 1)) {
      datas.add(i);
    }

    setState(() {
      _datas = datas;
    });

    Timer(const Duration(milliseconds: 500), _proximoNaoLido);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InfoDivider(child: const IntlText("leitura.leitura_biblica")),
        Container(
          height: 350,
          color: Colors.white,
          child: PageView(
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              children: _datas
                  .map((data) => Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        child: new CardLeitura(
                          data: data,
                          onLido: _proximoNaoLido,
                        ),
                      ))
                  .toList()),
        )
      ],
    );
  }

  _proximoNaoLido() async {
    DateTime data = await leituraDAO.findProximaDataNaoLida();

    int page = _datas.indexOf(data);

    if (page == _pageController.page + 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: const Interval(0, 1),
      );
    } else if (page >= 0) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 1500),
        curve: const ElasticOutCurve(.75),
      );
    }
  }
}

class CardLeitura extends StatefulWidget {
  const CardLeitura({
    Key key,
    this.data,
    this.onLido,
  }) : super(key: key);

  final DateTime data;
  final VoidCallback onLido;

  @override
  _CardLeituraState createState() => _CardLeituraState();
}

class _CardLeituraState extends State<CardLeitura> {
  Leitura _leitura;

  @override
  void initState() {
    super.initState();

    _buscaLeitura();
  }

  _buscaLeitura() async {
    Leitura found = await leituraDAO.findByData(widget.data);

    setState(() {
      _leitura = found;
    });
  }

  get lido => _leitura?.lido ?? true;

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return RawMaterialButton(
      onPressed: _onPressed,
      padding: const EdgeInsets.all(15),
      fillColor: lido ? tema.buttonBackground : Colors.grey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      elevation: 0,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    StringUtil.formatData(widget.data, pattern: "dd"),
                    style: TextStyle(
                      fontSize: 60,
                      color: tema.buttonText,
                    ),
                  ),
                  Text(
                    StringUtil.formatData(widget.data, pattern: "MMM / yy"),
                    style: TextStyle(
                      fontSize: 25,
                      color: tema.buttonText,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black26,
                      width: 2,
                    ),
                  ),
                  child: lido
                      ? Icon(
                          Icons.check,
                          size: 65,
                          color: tema.buttonBackground,
                        )
                      : const SizedBox(
                          height: 65,
                          width: 65,
                        ),
                ),
              )
            ],
          ),
          Expanded(
            child: Center(
              child: Text(
                _leitura?.dia?.descricao ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: tema.buttonText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onPressed() async {
    if (_leitura != null) {
      await leituraBloc.marcaLeitura(_leitura.dia.id, !lido);

      await _buscaLeitura();

      if (_leitura.lido && widget.onLido != null) {
        widget.onLido();
      }
    }
  }
}
