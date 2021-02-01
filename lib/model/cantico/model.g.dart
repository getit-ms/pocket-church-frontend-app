// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.cantico;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cantico _$CanticoFromJson(Map<String, dynamic> json) {
  return Cantico(
    id: json['id'] as int,
    autor: json['autor'] as String,
    titulo: json['titulo'] as String,
    cifra: json['cifra'] == null
        ? null
        : Arquivo.fromJson(json['cifra'] as Map<String, dynamic>),
    thumbnail: json['thumbnail'] == null
        ? null
        : Arquivo.fromJson(json['thumbnail'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CanticoToJson(Cantico instance) => <String, dynamic>{
      'id': instance.id,
      'autor': instance.autor,
      'titulo': instance.titulo,
      'cifra': instance.cifra,
      'thumbnail': instance.thumbnail,
    };
