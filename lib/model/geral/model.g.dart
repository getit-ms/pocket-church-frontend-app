// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.geral;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Arquivo _$ArquivoFromJson(Map<String, dynamic> json) {
  return Arquivo(
    id: json['id'] as int,
    nome: json['nome'] as String,
    filename: json['filename'] as String,
  );
}

Map<String, dynamic> _$ArquivoToJson(Arquivo instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'filename': instance.filename,
    };

Endereco _$EnderecoFromJson(Map<String, dynamic> json) {
  return Endereco(
    id: json['id'] as int,
    descricao: json['descricao'] as String,
    cep: json['cep'] as String,
    cidade: json['cidade'] as String,
    estado: json['estado'] as String,
  );
}

Map<String, dynamic> _$EnderecoToJson(Endereco instance) => <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'cep': instance.cep,
      'cidade': instance.cidade,
      'estado': instance.estado,
    };

Membro _$MembroFromJson(Map<String, dynamic> json) {
  return Membro(
    id: json['id'] as int,
    nome: json['nome'] as String,
    email: json['email'] as String,
    dataNascimento: json['dataNascimento'] == null
        ? null
        : DateTime.parse(json['dataNascimento'] as String),
    telefones: (json['telefones'] as List)?.map((e) => e as String)?.toList(),
    pastor: json['pastor'] as bool,
    visitante: json['visitante'] as bool,
    endereco: json['endereco'] == null
        ? null
        : Endereco.fromJson(json['endereco'] as Map<String, dynamic>),
    foto: json['foto'] == null
        ? null
        : Arquivo.fromJson(json['foto'] as Map<String, dynamic>),
    diaAniversario: json['diaAniversario'] as int,
  );
}

Map<String, dynamic> _$MembroToJson(Membro instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'email': instance.email,
      'dataNascimento': instance.dataNascimento?.toIso8601String(),
      'telefones': instance.telefones,
      'pastor': instance.pastor,
      'visitante': instance.visitante,
      'endereco': instance.endereco,
      'foto': instance.foto,
      'diaAniversario': instance.diaAniversario,
    };
