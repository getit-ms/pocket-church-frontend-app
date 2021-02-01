// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.biblia;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LivroBiblia _$LivroBibliaFromJson(Map<String, dynamic> json) {
  return LivroBiblia(
    id: json['id'] as int,
    nome: json['nome'] as String,
    ordem: json['ordem'] as int,
    abreviacao: json['abreviacao'] as String,
    ultimaAtualizacao: json['ultimaAtualizacao'] == null
        ? null
        : DateTime.parse(json['ultimaAtualizacao'] as String),
    testamento: json['testamento'] as String,
    versiculos: (json['versiculos'] as List)
        ?.map((e) => e == null
            ? null
            : VersiculoBiblia.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LivroBibliaToJson(LivroBiblia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'ordem': instance.ordem,
      'abreviacao': instance.abreviacao,
      'ultimaAtualizacao': instance.ultimaAtualizacao?.toIso8601String(),
      'testamento': instance.testamento,
      'versiculos': instance.versiculos,
    };

VersiculoBiblia _$VersiculoBibliaFromJson(Map<String, dynamic> json) {
  return VersiculoBiblia(
    id: json['id'] as int,
    capitulo: json['capitulo'] as int,
    versiculo: json['versiculo'] as int,
    texto: json['texto'] as String,
  );
}

Map<String, dynamic> _$VersiculoBibliaToJson(VersiculoBiblia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'capitulo': instance.capitulo,
      'versiculo': instance.versiculo,
      'texto': instance.texto,
    };
