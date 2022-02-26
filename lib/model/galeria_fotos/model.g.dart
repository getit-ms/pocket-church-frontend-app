// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.galeria_fotos;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Foto _$FotoFromJson(Map<String, dynamic> json) {
  return Foto(
    id: json['id'] as String,
    server: json['server'] as String,
    farm: json['farm'] as String,
    secret: json['secret'] as String,
    titulo: json['titulo'] as String,
  );
}

Map<String, dynamic> _$FotoToJson(Foto instance) => <String, dynamic>{
      'id': instance.id,
      'server': instance.server,
      'farm': instance.farm,
      'secret': instance.secret,
      'titulo': instance.titulo,
    };

GaleriaFotos _$GaleriaFotosFromJson(Map<String, dynamic> json) {
  return GaleriaFotos(
    id: json['id'] as String,
    nome: json['nome'] as String,
    descricao: json['descricao'] as String,
    dataAtualizacao: json['dataAtualizacao'] == null
        ? null
        : DateTime.parse(json['dataAtualizacao'] as String),
    fotoPrimaria: json['fotoPrimaria'] == null
        ? null
        : Foto.fromJson(json['fotoPrimaria'] as Map<String, dynamic>),
    quantidadeFotos: json['quantidadeFotos'] as int,
  );
}

Map<String, dynamic> _$GaleriaFotosToJson(GaleriaFotos instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'dataAtualizacao': instance.dataAtualizacao?.toIso8601String(),
      'fotoPrimaria': instance.fotoPrimaria,
      'quantidadeFotos': instance.quantidadeFotos,
    };
