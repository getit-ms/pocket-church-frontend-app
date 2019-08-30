// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.estudo;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Estudo _$EstudoFromJson(Map<String, dynamic> json) {
  return Estudo(
    id: json['id'] as int,
    titulo: json['titulo'] as String,
    texto: json['texto'] as String,
    data: json['data'] == null ? null : DateTime.parse(json['data'] as String),
    pdf: json['pdf'] == null
        ? null
        : Arquivo.fromJson(json['pdf'] as Map<String, dynamic>),
    thumbnail: json['thumbnail'] == null
        ? null
        : Arquivo.fromJson(json['thumbnail'] as Map<String, dynamic>),
    autor: json['autor'] as String,
    filename: json['filename'] as String,
    tipo: json['tipo'] as String,
  );
}

Map<String, dynamic> _$EstudoToJson(Estudo instance) => <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'texto': instance.texto,
      'data': instance.data?.toIso8601String(),
      'pdf': instance.pdf,
      'thumbnail': instance.thumbnail,
      'autor': instance.autor,
      'filename': instance.filename,
      'tipo': instance.tipo,
    };

CategoriaEstudo _$CategoriaEstudoFromJson(Map<String, dynamic> json) {
  return CategoriaEstudo(
    id: json['id'] as int,
    nome: json['nome'] as String,
  );
}

Map<String, dynamic> _$CategoriaEstudoToJson(CategoriaEstudo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
    };
