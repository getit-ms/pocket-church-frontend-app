// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.audio;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Audio _$AudioFromJson(Map<String, dynamic> json) {
  return Audio(
    id: json['id'] as int,
    nome: json['nome'] as String,
    autor: json['autor'] as String,
    descricao: json['descricao'] as String,
    tamamnhoArquivo: json['tamamnhoArquivo'] as int,
    tempoAudio: json['tempoAudio'] as int,
    capa: json['capa'] == null
        ? null
        : Arquivo.fromJson(json['capa'] as Map<String, dynamic>),
    audio: json['audio'] == null
        ? null
        : Arquivo.fromJson(json['audio'] as Map<String, dynamic>),
    dataCadastro: json['dataCadastro'] == null
        ? null
        : DateTime.parse(json['dataCadastro'] as String),
  );
}

Map<String, dynamic> _$AudioToJson(Audio instance) => <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'autor': instance.autor,
      'descricao': instance.descricao,
      'tamamnhoArquivo': instance.tamamnhoArquivo,
      'tempoAudio': instance.tempoAudio,
      'capa': instance.capa,
      'audio': instance.audio,
      'dataCadastro': instance.dataCadastro?.toIso8601String(),
    };

CategoriaAudio _$CategoriaAudioFromJson(Map<String, dynamic> json) {
  return CategoriaAudio(
    id: json['id'] as int,
    nome: json['nome'] as String,
  );
}

Map<String, dynamic> _$CategoriaAudioToJson(CategoriaAudio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
    };
