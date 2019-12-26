// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.preferencias;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferencias _$PreferenciasFromJson(Map<String, dynamic> json) {
  return Preferencias(
    horaVersiculoDiario: json['horaVersiculoDiario'] as String,
    dadosDisponiveis: json['dadosDisponiveis'] as bool,
    desejaReceberLembreteLeitura: json['desejaReceberLembreteLeitura'] as bool,
    desejaReceberNotificacoesVideos:
        json['desejaReceberNotificacoesVideos'] as bool,
    desejaReceberVersiculosDiarios:
        json['desejaReceberVersiculosDiarios'] as bool,
    horaLembreteLeitura: json['horaLembreteLeitura'] as String,
    desejaReceberNotificacoesDevocionario:
        json['desejaReceberNotificacoesDevocionario'] as bool,
    horaNotificacoesDevocional: json['horaNotificacoesDevocional'] as String,
    ministeriosInteresse: (json['ministeriosInteresse'] as List)
        ?.map((e) =>
            e == null ? null : Ministerio.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PreferenciasToJson(Preferencias instance) =>
    <String, dynamic>{
      'horaVersiculoDiario': instance.horaVersiculoDiario,
      'dadosDisponiveis': instance.dadosDisponiveis,
      'desejaReceberVersiculosDiarios': instance.desejaReceberVersiculosDiarios,
      'desejaReceberNotificacoesVideos':
          instance.desejaReceberNotificacoesVideos,
      'desejaReceberLembreteLeitura': instance.desejaReceberLembreteLeitura,
      'horaLembreteLeitura': instance.horaLembreteLeitura,
      'ministeriosInteresse': instance.ministeriosInteresse,
      'horaNotificacoesDevocional': instance.horaNotificacoesDevocional,
      'desejaReceberNotificacoesDevocionario':
          instance.desejaReceberNotificacoesDevocionario,
    };

Ministerio _$MinisterioFromJson(Map<String, dynamic> json) {
  return Ministerio(
    id: json['id'] as int,
    nome: json['nome'] as String,
  );
}

Map<String, dynamic> _$MinisterioToJson(Ministerio instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
    };
