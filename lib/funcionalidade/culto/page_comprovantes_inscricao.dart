part of pocket_church.culto;

class PageComprovantesInscricao extends StatefulWidget {
  final Evento culto;
  final List<InscricaoEvento> inscricoes;

  const PageComprovantesInscricao({
    Key key,
    this.culto,
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
      title: IntlText("culto.comprovantes"),
      body: PageView(
        controller: _controller,
        children: <Widget>[
          for (InscricaoEvento inscricao in widget.inscricoes)
            ComprovanteInscricaoEvento(
              evento: widget.culto,
              inscricao: inscricao,
            ),
        ],
      ),
    );
  }
}

class ComprovanteInscricaoEvento extends StatelessWidget {
  final Evento evento;
  final InscricaoEvento inscricao;

  const ComprovanteInscricaoEvento({
    Key key,
    this.evento,
    this.inscricao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shadows: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 20,
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                evento.nome,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    StringUtil.formatData(
                      evento.dataHoraInicio,
                      pattern: "dd MMMM yyyy",
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    StringUtil.formatData(
                          evento.dataHoraInicio,
                          pattern: 'HH:mm',
                        ) +
                        " - " +
                        StringUtil.formatData(
                          evento.dataHoraTermino,
                          pattern: 'HH:mm',
                        ),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black26,
                indent: 10,
                endIndent: 20,
                height: 2,
              ),
              Text(
                inscricao.nomeInscrito,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
              Divider(
                color: Colors.black26,
                indent: 10,
                endIndent: 20,
                height: 2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _labelValor(
                    label: IntlText("culto.email"),
                    valor: inscricao.emailInscrito,
                  ),
                  _labelValor(
                    label: IntlText("culto.telefone"),
                    valor:
                        StringUtil.formatTelefone(inscricao.telefoneInscrito),
                  ),
                  for (ValorInscricaoEvento valor in inscricao.valores ?? [])
                    _labelValor(
                      label: Text(valor.nome),
                      valor: _valorFormatado(valor),
                    ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 5,
          child: Icon(
            Icons.check_circle_outline,
            color: Colors.green.withOpacity(.54),
            size: 120,
          ),
        )
      ],
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
