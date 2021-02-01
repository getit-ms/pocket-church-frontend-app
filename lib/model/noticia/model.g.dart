// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.noticia;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Noticia _$NoticiaFromJson(Map<String, dynamic> json) {
  return Noticia(
    id: json['id'] as int,
    dataPublicacao: json['dataPublicacao'] == null
        ? null
        : DateTime.parse(json['dataPublicacao'] as String),
    titulo: json['titulo'] as String,
    texto: json['texto'] as String,
    resumo: json['resumo'] as String,
    ilustracao: json['ilustracao'] == null
        ? null
        : Arquivo.fromJson(json['ilustracao'] as Map<String, dynamic>),
    autor: json['autor'] == null
        ? null
        : Membro.fromJson(json['autor'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NoticiaToJson(Noticia instance) => <String, dynamic>{
      'id': instance.id,
      'dataPublicacao': instance.dataPublicacao?.toIso8601String(),
      'titulo': instance.titulo,
      'texto': instance.texto,
      'resumo': instance.resumo,
      'ilustracao': instance.ilustracao,
      'autor': instance.autor,
    };
