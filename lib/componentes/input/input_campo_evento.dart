part of pocket_church.componentes;

class InputCampoEvento extends StatelessWidget {
  final CampoEvento campo;
  final ValorInscricaoEvento valor;

  InputCampoEvento({this.campo, this.valor});

  @override
  Widget build(BuildContext context) {
    switch (campo.tipo) {
      case TipoCampoEvento.NUMERO:
        return _buildInputNumero(context);
        break;
      case TipoCampoEvento.DATA:
        return _buildInputData(context);
        break;
      case TipoCampoEvento.MULTIPLA_ESCOLHA:
        return _buildSelectOpcoes(context);
        break;
      case TipoCampoEvento.ANEXO:
        return _buildInputAnexo(context);
        break;
      case TipoCampoEvento.TEXTO:
        return _buildInputText(context);
        break;
    }

    return Container();
  }

  Widget _buildSelectOpcoes(BuildContext context) {
    Bundle bundle = ConfiguracaoApp.of(context).bundle;

    return DropdownButtonFormField<String>(
      validator: campo.validacao != null
          ? validate([
              if (campo.validacao[TipoValidacaoCampo.OBRIGATORIO] != null)
                notEmpty(),
            ], bundle: bundle)
          : null,
      onSaved: (val) {
        valor.valorTexto = val;
      },
      items: [
        for (String opcao in campo.opcoes ?? [])
          DropdownMenuItem(
            child: Text(opcao),
            value: opcao,
          ),
      ],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        labelText: campo.nome,
      ),
      onChanged: (String value) {},
    );
  }

  Widget _buildInputData(BuildContext context) {
    Bundle bundle = ConfiguracaoApp.of(context).bundle;

    return InputData(
      validator: campo.validacao != null
          ? validate([
              if (campo.validacao[TipoValidacaoCampo.OBRIGATORIO] != null)
                notNull(),
              if (campo.validacao[TipoValidacaoCampo.VALOR_MINIMO] != null ||
                  campo.validacao[TipoValidacaoCampo.VALOR_MAXIMO] != null)
                dateRange(
                  min: campo.validacao[TipoValidacaoCampo.VALOR_MINIMO] != null
                      ? DateTime.parse(campo
                          .validacao[TipoValidacaoCampo.VALOR_MINIMO]
                          .toString())
                      : null,
                  max: campo.validacao[TipoValidacaoCampo.VALOR_MAXIMO] != null
                      ? DateTime.parse(campo
                          .validacao[TipoValidacaoCampo.VALOR_MAXIMO]
                          .toString())
                      : null,
                ),
            ], bundle: bundle)
          : null,
      onSaved: (val) {
        valor.valorData = val;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        labelText: campo.nome,
      ),
    );
  }

  Widget _buildInputNumero(BuildContext context) {
    Bundle bundle = ConfiguracaoApp.of(context).bundle;

    return InputNumero(
      validator: campo.validacao != null
          ? validate([
              if (campo.validacao[TipoValidacaoCampo.OBRIGATORIO] != null)
                notNull(),
              if (campo.validacao[TipoValidacaoCampo.VALOR_MINIMO] != null ||
                  campo.validacao[TipoValidacaoCampo.VALOR_MAXIMO] != null)
                range(
                    min:
                        campo.validacao[TipoValidacaoCampo.VALOR_MINIMO] != null
                            ? double.parse(campo
                                .validacao[TipoValidacaoCampo.VALOR_MINIMO]
                                .toString())
                            : null,
                    max:
                        campo.validacao[TipoValidacaoCampo.VALOR_MAXIMO] != null
                            ? double.parse(campo
                                .validacao[TipoValidacaoCampo.VALOR_MAXIMO]
                                .toString())
                            : null,
                    toString: (val) {
                      if (campo.formato == FormatoCampoEvento.MONETARIO) {
                        return StringUtil.formataCurrency(val);
                      }

                      return val.toString();
                    }),
            ], bundle: bundle)
          : null,
      inputFormatters: [
        if (campo.formato == FormatoCampoEvento.MONETARIO)
          services.TextInputFormatter.withFunction(
              TextFormatUtil.formatCurrency),
        if (campo.formato == FormatoCampoEvento.NUMERO_INTEIRO)
          services.TextInputFormatter.withFunction(TextFormatUtil.formatInt),
      ],
      onSaved: (val) {
        valor.valorNumero = val;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        labelText: campo.nome,
      ),
    );
  }

  Widget _buildInputText(BuildContext context) {
    Bundle bundle = ConfiguracaoApp.of(context).bundle;

    return TextFormField(
      validator: campo.validacao != null
          ? validate([
              if (campo.validacao[TipoValidacaoCampo.OBRIGATORIO] != null)
                notEmpty(),
              if (campo.validacao[TipoValidacaoCampo.COMPRIMENTO_MINIMO] !=
                      null ||
                  campo.validacao[TipoValidacaoCampo.COMPRIMENTO_MAXIMO] !=
                      null)
                length(
                  min: campo.validacao[TipoValidacaoCampo.COMPRIMENTO_MINIMO] !=
                          null
                      ? int.parse(campo
                          .validacao[TipoValidacaoCampo.COMPRIMENTO_MINIMO]
                          .toString())
                      : null,
                  max: campo.validacao[TipoValidacaoCampo.COMPRIMENTO_MAXIMO] !=
                          null
                      ? int.parse(campo
                          .validacao[TipoValidacaoCampo.COMPRIMENTO_MAXIMO]
                          .toString())
                      : null,
                ),
            ], bundle: bundle)
          : null,
      inputFormatters: [
        if (campo.formato == FormatoCampoEvento.CEP)
          services.TextInputFormatter.withFunction(TextFormatUtil.formatCEP),
        if (campo.formato == FormatoCampoEvento.CPF_CNPJ)
          services.TextInputFormatter.withFunction(
              TextFormatUtil.formatCpfCnpj),
      ],
      onSaved: (val) {
        if (campo.formato != FormatoCampoEvento.NENHUM) {
          valor.valorTexto = StringUtil.unformat(val);
        } else {
          valor.valorTexto = val;
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        labelText: campo.nome,
      ),
    );
  }

  Widget _buildInputAnexo(BuildContext context) {
    Bundle bundle = ConfiguracaoApp.of(context).bundle;

    return InputAnexo(
      validator: campo.validacao != null
          ? validate([
              if (campo.validacao[TipoValidacaoCampo.OBRIGATORIO] != null)
                notNull(),
            ], bundle: bundle)
          : null,
      onSaved: (val) {
        valor.valorAnexo = val;
      },
      tipoAnexo: valor.formato == FormatoCampoEvento.IMAGEM
          ? TipoAnexo.IMAGEM
          : TipoAnexo.TODOS,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        labelText: campo.nome,
      ),
    );
  }
}
