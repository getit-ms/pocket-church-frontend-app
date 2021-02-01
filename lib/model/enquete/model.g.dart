// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.enquete;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enquete _$EnqueteFromJson(Map<String, dynamic> json) {
  return Enquete(
    id: json['id'] as int,
    nome: json['nome'] as String,
    descricao: json['descricao'] as String,
    dataInicio: json['dataInicio'] == null
        ? null
        : DateTime.parse(json['dataInicio'] as String),
    dataTermino: json['dataTermino'] == null
        ? null
        : DateTime.parse(json['dataTermino'] as String),
    questoes: (json['questoes'] as List)
        ?.map((e) =>
            e == null ? null : Questao.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    respondido: json['respondido'] as bool,
    encerrado: json['encerrado'] as bool,
  );
}

Map<String, dynamic> _$EnqueteToJson(Enquete instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'dataInicio': instance.dataInicio?.toIso8601String(),
      'dataTermino': instance.dataTermino?.toIso8601String(),
      'questoes': instance.questoes,
      'respondido': instance.respondido,
      'encerrado': instance.encerrado,
    };

Questao _$QuestaoFromJson(Map<String, dynamic> json) {
  return Questao(
    id: json['id'] as int,
    questao: json['questao'] as String,
    quantidadeVotos: json['quantidadeVotos'] as int,
    opcoes: (json['opcoes'] as List)
        ?.map(
            (e) => e == null ? null : Opcao.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$QuestaoToJson(Questao instance) => <String, dynamic>{
      'id': instance.id,
      'questao': instance.questao,
      'quantidadeVotos': instance.quantidadeVotos,
      'opcoes': instance.opcoes,
    };

Opcao _$OpcaoFromJson(Map<String, dynamic> json) {
  return Opcao(
    id: json['id'] as int,
    opcao: json['opcao'] as String,
  );
}

Map<String, dynamic> _$OpcaoToJson(Opcao instance) => <String, dynamic>{
      'id': instance.id,
      'opcao': instance.opcao,
    };

RespostaEnquete _$RespostaEnqueteFromJson(Map<String, dynamic> json) {
  return RespostaEnquete(
    votacao: json['votacao'] == null
        ? null
        : Enquete.fromJson(json['votacao'] as Map<String, dynamic>),
    respostas: (json['respostas'] as List)
        ?.map((e) => e == null
            ? null
            : RespostaQuestao.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$RespostaEnqueteToJson(RespostaEnquete instance) =>
    <String, dynamic>{
      'votacao': instance.votacao,
      'respostas': instance.respostas,
    };

RespostaQuestao _$RespostaQuestaoFromJson(Map<String, dynamic> json) {
  return RespostaQuestao(
    questao: json['questao'] == null
        ? null
        : Questao.fromJson(json['questao'] as Map<String, dynamic>),
    opcoes: (json['opcoes'] as List)
        ?.map((e) => e == null
            ? null
            : RespostaOpcao.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    brancos: json['brancos'] as int,
    nulos: json['nulos'] as int,
  );
}

Map<String, dynamic> _$RespostaQuestaoToJson(RespostaQuestao instance) =>
    <String, dynamic>{
      'questao': instance.questao,
      'opcoes': instance.opcoes,
      'brancos': instance.brancos,
      'nulos': instance.nulos,
    };

RespostaOpcao _$RespostaOpcaoFromJson(Map<String, dynamic> json) {
  return RespostaOpcao(
    opcao: json['opcao'] == null
        ? null
        : Opcao.fromJson(json['opcao'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RespostaOpcaoToJson(RespostaOpcao instance) =>
    <String, dynamic>{
      'opcao': instance.opcao,
    };

ResultadoEnquete _$ResultadoEnqueteFromJson(Map<String, dynamic> json) {
  return ResultadoEnquete(
    id: json['id'] as int,
    nome: json['nome'] as String,
    descricao: json['descricao'] as String,
    questoes: (json['questoes'] as List)
        ?.map((e) => e == null
            ? null
            : ResultadoQuestao.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ResultadoEnqueteToJson(ResultadoEnquete instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'questoes': instance.questoes,
    };

ResultadoQuestao _$ResultadoQuestaoFromJson(Map<String, dynamic> json) {
  return ResultadoQuestao(
    questao: json['questao'] as String,
    validos: (json['validos'] as List)
        ?.map((e) => e == null
            ? null
            : ResultadoOpcao.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totais: (json['totais'] as List)
        ?.map((e) => e == null
            ? null
            : ResultadoOpcao.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ResultadoQuestaoToJson(ResultadoQuestao instance) =>
    <String, dynamic>{
      'questao': instance.questao,
      'validos': instance.validos,
      'totais': instance.totais,
    };

ResultadoOpcao _$ResultadoOpcaoFromJson(Map<String, dynamic> json) {
  return ResultadoOpcao(
    opcao: json['opcao'] as String,
    resultado: json['resultado'] as int,
  );
}

Map<String, dynamic> _$ResultadoOpcaoToJson(ResultadoOpcao instance) =>
    <String, dynamic>{
      'opcao': instance.opcao,
      'resultado': instance.resultado,
    };
