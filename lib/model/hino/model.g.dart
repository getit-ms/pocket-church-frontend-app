// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.hino;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hino _$HinoFromJson(Map<String, dynamic> json) {
  return Hino(
    id: json['id'] as int,
    numero: json['numero'] as String,
    assunto: json['assunto'] as String,
    autor: json['autor'] as String,
    nome: json['nome'] as String,
    texto: json['texto'] as String,
    filename: json['fileName'] as String,
    ultimaAlteracao: json['ultimaAlteracao'] == null
        ? null
        : DateTime.parse(json['ultimaAlteracao'] as String),
  );
}

Map<String, dynamic> _$HinoToJson(Hino instance) => <String, dynamic>{
      'id': instance.id,
      'numero': instance.numero,
      'assunto': instance.assunto,
      'autor': instance.autor,
      'nome': instance.nome,
      'texto': instance.texto,
      'filename': instance.filename,
      'ultimaAlteracao': instance.ultimaAlteracao?.toIso8601String(),
    };
