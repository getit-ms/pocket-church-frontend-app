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
