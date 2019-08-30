// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.institucional;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Institucional _$InstitucionalFromJson(Map<String, dynamic> json) {
  return Institucional(
    email: json['email'] as String,
    site: json['site'] as String,
    redesSociais: (json['redesSociais'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    divulgacao: json['divulgacao'] == null
        ? null
        : Arquivo.fromJson(json['divulgacao'] as Map<String, dynamic>),
    textoDivulgacao: json['textoDivulgacao'] as String,
    quemSomos: json['quemSomos'] as String,
    telefones: (json['telefones'] as List)?.map((e) => e as String)?.toList(),
    enderecos: (json['enderecos'] as List)
        ?.map((e) =>
            e == null ? null : Endereco.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$InstitucionalToJson(Institucional instance) =>
    <String, dynamic>{
      'email': instance.email,
      'site': instance.site,
      'redesSociais': instance.redesSociais,
      'divulgacao': instance.divulgacao,
      'textoDivulgacao': instance.textoDivulgacao,
      'quemSomos': instance.quemSomos,
      'telefones': instance.telefones,
      'enderecos': instance.enderecos,
    };
