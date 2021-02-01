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
    ministeriosInteresse: (json['ministeriosInteresse'] as List)
        ?.map((e) =>
            e == null ? null : Ministerio.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    desejaReceberNotificacoesDevocionario:
        json['desejaReceberNotificacoesDevocionario'] as bool,
    horaNotificacoesDevocional: json['horaNotificacoesDevocional'] as String,
  );
}

Map<String, dynamic> _$PreferenciasToJson(Preferencias instance) =>
    <String, dynamic>{
      'desejaReceberVersiculosDiarios': instance.desejaReceberVersiculosDiarios,
      'horaVersiculoDiario': instance.horaVersiculoDiario,
      'dadosDisponiveis': instance.dadosDisponiveis,
      'desejaReceberNotificacoesVideos':
          instance.desejaReceberNotificacoesVideos,
      'desejaReceberNotificacoesDevocionario':
          instance.desejaReceberNotificacoesDevocionario,
      'horaNotificacoesDevocional': instance.horaNotificacoesDevocional,
      'desejaReceberLembreteLeitura': instance.desejaReceberLembreteLeitura,
      'horaLembreteLeitura': instance.horaLembreteLeitura,
      'ministeriosInteresse': instance.ministeriosInteresse,
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
