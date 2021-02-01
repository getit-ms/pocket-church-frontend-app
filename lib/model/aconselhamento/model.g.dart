// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.aconselhamento;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Aconselhamento _$AconselhamentoFromJson(Map<String, dynamic> json) {
  return Aconselhamento(
    id: json['id'] as int,
    membro: json['membro'] == null
        ? null
        : Membro.fromJson(json['membro'] as Map<String, dynamic>),
    status: json['status'] as String,
    concluido: json['concluido'] as bool,
    confirmado: json['confirmado'] as bool,
    calendario: json['calendario'] == null
        ? null
        : CalendarioAconselhamento.fromJson(
            json['calendario'] as Map<String, dynamic>),
    dataHoraInicio: json['dataHoraInicio'] == null
        ? null
        : DateTime.parse(json['dataHoraInicio'] as String),
    dataHoraFim: json['dataHoraFim'] == null
        ? null
        : DateTime.parse(json['dataHoraFim'] as String),
  );
}

Map<String, dynamic> _$AconselhamentoToJson(Aconselhamento instance) =>
    <String, dynamic>{
      'id': instance.id,
      'membro': instance.membro,
      'status': instance.status,
      'concluido': instance.concluido,
      'confirmado': instance.confirmado,
      'calendario': instance.calendario,
      'dataHoraInicio': instance.dataHoraInicio?.toIso8601String(),
      'dataHoraFim': instance.dataHoraFim?.toIso8601String(),
    };

CalendarioAconselhamento _$CalendarioAconselhamentoFromJson(
    Map<String, dynamic> json) {
  return CalendarioAconselhamento(
    id: json['id'] as int,
    pastor: json['pastor'] == null
        ? null
        : Membro.fromJson(json['pastor'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CalendarioAconselhamentoToJson(
        CalendarioAconselhamento instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pastor': instance.pastor,
    };

EventoCalendarioAconselhamento _$EventoCalendarioAconselhamentoFromJson(
    Map<String, dynamic> json) {
  return EventoCalendarioAconselhamento(
    dataInicio: json['dataInicio'] == null
        ? null
        : DateTime.parse(json['dataInicio'] as String),
    dataTermino: json['dataTermino'] == null
        ? null
        : DateTime.parse(json['dataTermino'] as String),
    horario: json['horario'] == null
        ? null
        : HorarioCalendarioAconselhamento.fromJson(
            json['horario'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EventoCalendarioAconselhamentoToJson(
        EventoCalendarioAconselhamento instance) =>
    <String, dynamic>{
      'dataInicio': instance.dataInicio?.toIso8601String(),
      'dataTermino': instance.dataTermino?.toIso8601String(),
      'horario': instance.horario,
    };

HorarioCalendarioAconselhamento _$HorarioCalendarioAconselhamentoFromJson(
    Map<String, dynamic> json) {
  return HorarioCalendarioAconselhamento(
    id: json['id'] as int,
    horaInicio: json['horaInicio'] as String,
    horaFim: json['horaFim'] as String,
  );
}

Map<String, dynamic> _$HorarioCalendarioAconselhamentoToJson(
        HorarioCalendarioAconselhamento instance) =>
    <String, dynamic>{
      'id': instance.id,
      'horaInicio': instance.horaInicio,
      'horaFim': instance.horaFim,
    };
