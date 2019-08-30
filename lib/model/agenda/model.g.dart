// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.agenda;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventoCalendario _$EventoCalendarioFromJson(Map<String, dynamic> json) {
  return EventoCalendario(
    id: json['id'] as String,
    inicio: json['inicio'] == null
        ? null
        : DateTime.parse(json['inicio'] as String),
    termino: json['termino'] == null
        ? null
        : DateTime.parse(json['termino'] as String),
    descricao: json['descricao'] as String,
    local: json['local'] as String,
  );
}

Map<String, dynamic> _$EventoCalendarioToJson(EventoCalendario instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inicio': instance.inicio?.toIso8601String(),
      'termino': instance.termino?.toIso8601String(),
      'descricao': instance.descricao,
      'local': instance.local,
    };
