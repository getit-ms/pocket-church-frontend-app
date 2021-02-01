// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.leitura_biblica;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanoLeitura _$PlanoLeituraFromJson(Map<String, dynamic> json) {
  return PlanoLeitura(
    id: json['id'] as int,
    descricao: json['descricao'] as String,
  );
}

Map<String, dynamic> _$PlanoLeituraToJson(PlanoLeitura instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
    };

Leitura _$LeituraFromJson(Map<String, dynamic> json) {
  return Leitura(
    dia: json['dia'] == null
        ? null
        : DiaLeitura.fromJson(json['dia'] as Map<String, dynamic>),
    ultimaAlteracao: json['ultimaAlteracao'] == null
        ? null
        : DateTime.parse(json['ultimaAlteracao'] as String),
    plano: json['plano'] as int,
    lido: json['lido'] as bool,
  );
}

Map<String, dynamic> _$LeituraToJson(Leitura instance) => <String, dynamic>{
      'dia': instance.dia,
      'ultimaAlteracao': instance.ultimaAlteracao?.toIso8601String(),
      'plano': instance.plano,
      'lido': instance.lido,
    };

DiaLeitura _$DiaLeituraFromJson(Map<String, dynamic> json) {
  return DiaLeitura(
    id: json['id'] as int,
    data: json['data'] == null ? null : DateTime.parse(json['data'] as String),
    descricao: json['descricao'] as String,
  );
}

Map<String, dynamic> _$DiaLeituraToJson(DiaLeitura instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data?.toIso8601String(),
      'descricao': instance.descricao,
    };
