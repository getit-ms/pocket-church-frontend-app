// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.devocionario;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaDevocionario _$DiaDevocionarioFromJson(Map<String, dynamic> json) {
  return DiaDevocionario(
    id: json['id'] as int,
    data: json['data'] == null ? null : DateTime.parse(json['data'] as String),
    arquivo: json['arquivo'] == null
        ? null
        : Arquivo.fromJson(json['arquivo'] as Map<String, dynamic>),
    thumbnail: json['thumbnail'] == null
        ? null
        : Arquivo.fromJson(json['thumbnail'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DiaDevocionarioToJson(DiaDevocionario instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data': instance.data?.toIso8601String(),
      'arquivo': instance.arquivo,
      'thumbnail': instance.thumbnail,
    };
