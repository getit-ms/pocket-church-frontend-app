// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.video;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) {
  return Video(
    id: json['id'] as String,
    titulo: json['titulo'] as String,
    descricao: json['descricao'] as String,
    thumbnail: json['thumbnail'] as String,
    publicacao: json['publicacao'] == null
        ? null
        : DateTime.parse(json['publicacao'] as String),
    agendamento: json['agendamento'] == null
        ? null
        : DateTime.parse(json['agendamento'] as String),
    aoVivo: json['aoVivo'] as bool,
    streamUrl: json['streamUrl'] as String,
    agendado: json['agendado'] as bool,
  );
}

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descricao': instance.descricao,
      'thumbnail': instance.thumbnail,
      'publicacao': instance.publicacao?.toIso8601String(),
      'agendamento': instance.agendamento?.toIso8601String(),
      'aoVivo': instance.aoVivo,
      'streamUrl': instance.streamUrl,
      'agendado': instance.agendado,
    };
