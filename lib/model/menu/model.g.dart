// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.menu;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) {
  return Menu(
    nome: json['nome'] as String,
    icone: json['icone'] as String,
    ordem: json['ordem'] as int,
    link: json['link'] as String,
    notificacoes: json['notificacoes'] as int,
    funcionalidade: json['funcionalidade'] as String,
    submenus: (json['submenus'] as List)
        ?.map(
            (e) => e == null ? null : Menu.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'nome': instance.nome,
      'icone': instance.icone,
      'ordem': instance.ordem,
      'link': instance.link,
      'notificacoes': instance.notificacoes,
      'funcionalidade': instance.funcionalidade,
      'submenus': instance.submenus,
    };
