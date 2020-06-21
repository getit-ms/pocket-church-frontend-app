part of pocket_church.model.evento;

enum TipoCampoEvento {
  TEXTO,
  DATA,
  NUMERO,
  MULTIPLA_ESCOLHA,
  ANEXO,
}

enum FormatoCampoEvento {
  NENHUM,
  CEP,
  CPF_CNPJ,
  NUMERO_INTEIRO,
  NUMERO_REAL,
  MONETARIO,
  IMAGEM
}

enum TipoValidacaoCampo {
  OBRIGATORIO,
  COMPRIMENTO_MINIMO,
  COMPRIMENTO_MAXIMO,
  VALOR_MINIMO,
  VALOR_MAXIMO,
  EMAIL,
  CPF_CNPJ,
}

@JsonSerializable()
class CampoEvento {
  int id;
  String nome;
  TipoCampoEvento tipo;
  FormatoCampoEvento formato;
  List<String> opcoes;
  Map<TipoValidacaoCampo, String> validacao;

  CampoEvento({
    this.id,
    this.nome,
    this.tipo,
    this.formato,
    this.opcoes,
    this.validacao,
  });

  factory CampoEvento.fromJson(Map<String, dynamic> json) => _$CampoEventoFromJson(json);

  Map<String, dynamic> toJson() => _$CampoEventoToJson(this);

  @override
  bool operator ==(other) {
    return other is CampoEvento && other.id == id;
  }
}
