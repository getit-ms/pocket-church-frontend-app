// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.boletim;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Boletim _$BoletimFromJson(Map<String, dynamic> json) {
  return Boletim(
    id: json['id'] as int,
    titulo: json['titulo'] as String,
    data: json['data'] == null ? null : DateTime.parse(json['data'] as String),
    dataPublicacao: json['dataPublicacao'] == null
        ? null
        : DateTime.parse(json['dataPublicacao'] as String),
    boletim: json['boletim'] == null
        ? null
        : Arquivo.fromJson(json['boletim'] as Map<String, dynamic>),
    thumbnail: json['thumbnail'] == null
        ? null
        : Arquivo.fromJson(json['thumbnail'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BoletimToJson(Boletim instance) => <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'data': instance.data?.toIso8601String(),
      'dataPublicacao': instance.dataPublicacao?.toIso8601String(),
      'boletim': instance.boletim,
      'thumbnail': instance.thumbnail,
    };
