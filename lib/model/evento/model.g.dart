// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.evento;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Evento _$EventoFromJson(Map<String, dynamic> json) {
  return Evento(
    id: json['id'] as int,
    nome: json['nome'] as String,
    descricao: json['descricao'] as String,
    limiteInscricoes: json['limiteInscricoes'] as int,
    tipo: json['tipo'] as String,
    dataHoraInicio: json['dataHoraInicio'] == null
        ? null
        : DateTime.parse(json['dataHoraInicio'] as String),
    dataHoraTermino: json['dataHoraTermino'] == null
        ? null
        : DateTime.parse(json['dataHoraTermino'] as String),
    valor: (json['valor'] as num)?.toDouble(),
    exigePagamento: json['exigePagamento'] as bool,
    dataInicioInscricao: json['dataInicioInscricao'] == null
        ? null
        : DateTime.parse(json['dataInicioInscricao'] as String),
    dataTerminoInscricao: json['dataTerminoInscricao'] == null
        ? null
        : DateTime.parse(json['dataTerminoInscricao'] as String),
    banner: json['banner'] == null
        ? null
        : Arquivo.fromJson(json['banner'] as Map<String, dynamic>),
    vagasRestantes: json['vagasRestantes'] as int,
    inscricoesFuturas: json['inscricoesFuturas'] as bool,
    inscricoesPassadas: json['inscricoesPassadas'] as bool,
    inscricoesAbertas: json['inscricoesAbertas'] as bool,
    filename: json['filename'] as String,
    comPagamento: json['comPagamento'] as bool,
    campos: (json['campos'] as List)
        ?.map((e) =>
            e == null ? null : CampoEvento.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EventoToJson(Evento instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'limiteInscricoes': instance.limiteInscricoes,
      'tipo': instance.tipo,
      'dataHoraInicio': instance.dataHoraInicio?.toIso8601String(),
      'dataHoraTermino': instance.dataHoraTermino?.toIso8601String(),
      'valor': instance.valor,
      'exigePagamento': instance.exigePagamento,
      'dataInicioInscricao': instance.dataInicioInscricao?.toIso8601String(),
      'dataTerminoInscricao': instance.dataTerminoInscricao?.toIso8601String(),
      'banner': instance.banner,
      'vagasRestantes': instance.vagasRestantes,
      'inscricoesFuturas': instance.inscricoesFuturas,
      'inscricoesPassadas': instance.inscricoesPassadas,
      'inscricoesAbertas': instance.inscricoesAbertas,
      'filename': instance.filename,
      'comPagamento': instance.comPagamento,
      'campos': instance.campos?.map((campo) => campo.toJson())?.toList(),
    };

InscricaoEvento _$InscricaoEventoFromJson(Map<String, dynamic> json) {
  return InscricaoEvento(
    id: json['id'] as int,
    membro: json['membro'] == null
        ? null
        : Membro.fromJson(json['membro'] as Map<String, dynamic>),
    nomeInscrito: json['nomeInscrito'] as String,
    emailInscrito: json['emailInscrito'] as String,
    telefoneInscrito: json['telefoneInscrito'] as String,
    referenciaCheckout: json['referenciaCheckout'] as String,
    chaveCheckout: json['chaveCheckout'] as String,
    data: json['data'] == null ? null : DateTime.parse(json['data'] as String),
    valor: (json['valor'] as num)?.toDouble(),
    status: json['status'] as String,
    confirmada: json['confirmada'] as bool,
    pendente: json['pendente'] as bool,
    valores: (json['valores'] as List)
        ?.map((e) => e == null
            ? null
            : ValorInscricaoEvento.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$InscricaoEventoToJson(InscricaoEvento instance) =>
    <String, dynamic>{
      'id': instance.id,
      'membro': instance.membro,
      'nomeInscrito': instance.nomeInscrito,
      'emailInscrito': instance.emailInscrito,
      'telefoneInscrito': instance.telefoneInscrito,
      'referenciaCheckout': instance.referenciaCheckout,
      'chaveCheckout': instance.chaveCheckout,
      'data': instance.data?.toIso8601String(),
      'valor': instance.valor,
      'status': instance.status,
      'confirmada': instance.confirmada,
      'pendente': instance.pendente,
      'valores': instance.valores?.map((e) => e.toJson())?.toList(),
    };

ResultadoInscricao _$ResultadoInscricaoFromJson(Map<String, dynamic> json) {
  return ResultadoInscricao(
    checkoutPagSeguro: json['checkoutPagSeguro'] as String,
    devePagar: json['devePagar'] as bool,
  );
}

Map<String, dynamic> _$ResultadoInscricaoToJson(ResultadoInscricao instance) =>
    <String, dynamic>{
      'checkoutPagSeguro': instance.checkoutPagSeguro,
      'devePagar': instance.devePagar,
    };

CampoEvento _$CampoEventoFromJson(Map<String, dynamic> json) {
  return CampoEvento(
    id: json['id'] as int,
    nome: json['nome'] as String,
    tipo: _$enumDecodeNullable(_$TipoCampoEventoEnumMap, json['tipo']),
    formato: _$enumDecodeNullable(_$FormatoCampoEventoEnumMap, json['formato']),
    opcoes: (json['opcoes'] as List)?.map((e) => e as String)?.toList(),
    validacao: (json['validacao'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          _$enumDecodeNullable(_$TipoValidacaoCampoEnumMap, k), e as String),
    ),
  );
}

Map<String, dynamic> _$CampoEventoToJson(CampoEvento instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'tipo': _$TipoCampoEventoEnumMap[instance.tipo],
      'formato': _$FormatoCampoEventoEnumMap[instance.formato],
      'opcoes': instance.opcoes,
      'validacao': instance.validacao
          ?.map((k, e) => MapEntry(_$TipoValidacaoCampoEnumMap[k], e)),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$TipoCampoEventoEnumMap = {
  TipoCampoEvento.TEXTO: 'TEXTO',
  TipoCampoEvento.DATA: 'DATA',
  TipoCampoEvento.NUMERO: 'NUMERO',
  TipoCampoEvento.MULTIPLA_ESCOLHA: 'MULTIPLA_ESCOLHA',
  TipoCampoEvento.ANEXO: 'ANEXO',
};

const _$FormatoCampoEventoEnumMap = {
  FormatoCampoEvento.NENHUM: 'NENHUM',
  FormatoCampoEvento.CEP: 'CEP',
  FormatoCampoEvento.CPF_CNPJ: 'CPF_CNPJ',
  FormatoCampoEvento.NUMERO_INTEIRO: 'NUMERO_INTEIRO',
  FormatoCampoEvento.NUMERO_REAL: 'NUMERO_REAL',
  FormatoCampoEvento.MONETARIO: 'MONETARIO',
  FormatoCampoEvento.IMAGEM: 'IMAGEM',
};

const _$TipoValidacaoCampoEnumMap = {
  TipoValidacaoCampo.OBRIGATORIO: 'OBRIGATORIO',
  TipoValidacaoCampo.COMPRIMENTO_MINIMO: 'COMPRIMENTO_MINIMO',
  TipoValidacaoCampo.COMPRIMENTO_MAXIMO: 'COMPRIMENTO_MAXIMO',
  TipoValidacaoCampo.VALOR_MINIMO: 'VALOR_MINIMO',
  TipoValidacaoCampo.VALOR_MAXIMO: 'VALOR_MAXIMO',
  TipoValidacaoCampo.EMAIL: 'EMAIL',
  TipoValidacaoCampo.CPF_CNPJ: 'CPF_CNPJ',
};

ValorInscricaoEvento _$ValorInscricaoEventoFromJson(Map<String, dynamic> json) {
  return ValorInscricaoEvento(
    nome: json['nome'] as String,
    formato: _$enumDecodeNullable(_$FormatoCampoEventoEnumMap, json['formato']),
    valorTexto: json['valorTexto'] as String,
    valorNumero: (json['valorNumero'] as num)?.toDouble(),
    valorData: json['valorData'] == null
        ? null
        : DateTime.parse(json['valorData'] as String),
    valorAnexo: json['valorAnexo'] == null
        ? null
        : Arquivo.fromJson(json['valorAnexo'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ValorInscricaoEventoToJson(
        ValorInscricaoEvento instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'formato': _$FormatoCampoEventoEnumMap[instance.formato],
      'valorTexto': instance.valorTexto,
      'valorNumero': instance.valorNumero,
      'valorData': instance.valorData?.toIso8601String(),
      'valorAnexo': instance.valorAnexo,
    };
