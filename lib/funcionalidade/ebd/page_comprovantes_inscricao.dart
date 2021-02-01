part of pocket_church.ebd;

class PageComprovantesInscricao extends StatefulWidget {
  final Evento ebd;
  final List<InscricaoEvento> inscricoes;

  const PageComprovantesInscricao({
    Key key,
    this.ebd,
    this.inscricoes,
  }) : super(key: key);

  @override
  _PageComprovantesInscricaoState createState() =>
      _PageComprovantesInscricaoState();
}

class _PageComprovantesInscricaoState extends State<PageComprovantesInscricao> {
  PageController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PageController(viewportFraction: .9);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: IntlText("ebd.comprovantes"),
      body: PageView(
        controller: _controller,
        children: <Widget>[
          for (InscricaoEvento inscricao in widget.inscricoes)
            ComprovanteInscricaoEvento(
              ebd: widget.ebd,
              inscricao: inscricao,
            ),
        ],
      ),
    );
  }
}

class ComprovanteInscricaoEvento extends StatelessWidget {
  final Evento ebd;
  final InscricaoEvento inscricao;

  const ComprovanteInscricaoEvento({
    Key key,
    this.ebd,
    this.inscricao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tema tema = configuracaoBloc.currentTema;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 500),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 5,
                    ),
                  ],
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 20,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: tema.menuBackground,
                            fit: BoxFit.fill,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Image(
                          image: tema.menuLogo,
                          height: 50,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                ebd.nome,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Divider(
                                color: Colors.black26,
                                indent: 10,
                                endIndent: 20,
                                height: 2,
                              ),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.event_available,
                                    color: Colors.black26,
                                    size: 35,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        StringUtil.formatData(
                                          ebd.dataHoraInicio,
                                          pattern: "dd MMMM yyyy",
                                        ),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        StringUtil.formatData(
                                              ebd.dataHoraInicio,
                                              pattern: 'HH:mm',
                                            ) +
                                            " - " +
                                            StringUtil.formatData(
                                              ebd.dataHoraTermino,
                                              pattern: 'HH:mm',
                                            ),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(width: 10),
                              Divider(
                                color: Colors.black26,
                                indent: 10,
                                endIndent: 20,
                                height: 2,
                              ),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.person,
                                    color: Colors.black26,
                                    size: 35,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    inscricao.nomeInscrito,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 28,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.black12,
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              StringUtil.formatData(
                                inscricao.data,
                                pattern: "dd/MM/yyyy HH:mm",
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "#${ebd.id.toRadixString(36).toUpperCase()}-${inscricao.id.toRadixString(36).toUpperCase()}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 5,
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green.withOpacity(.35),
                  size: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelValor({Widget label, String valor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DefaultTextStyle(
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 7,
            ),
            child: label,
          ),
          const SizedBox(width: 2),
          Text(
            valor,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _valorFormatado(ValorInscricaoEvento valor) {
    if (valor.valorTexto != null) {
      if (valor.formato == FormatoCampoEvento.CPF_CNPJ) {
        return StringUtil.formatCpfCnpj(valor.valorTexto);
      } else if (valor.formato == FormatoCampoEvento.CEP) {
        return StringUtil.formataCep(valor.valorTexto);
      } else {
        return valor.valorTexto;
      }
    } else if (valor.valorData != null) {
      return StringUtil.formatData(valor.valorData);
    } else if (valor.valorNumero != null) {
      if (valor.formato == FormatoCampoEvento.NUMERO_INTEIRO) {
        return valor.valorNumero.toInt().toString();
      } else if (valor.formato == FormatoCampoEvento.MONETARIO) {
        return StringUtil.formataCurrency(valor.valorNumero);
      }

      return valor.valorNumero.toString();
    } else if (valor.valorAnexo != null) {
      return valor.valorAnexo.nome;
    }

    return "";
  }
}
