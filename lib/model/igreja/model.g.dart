// GENERATED CODE - DO NOT MODIFY BY HAND

part of pocket_church.model.igreja;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemplateAplicativo _$TemplateAplicativoFromJson(Map<String, dynamic> json) {
  return TemplateAplicativo(
    androidIcon: json['androidIcon'] == null
        ? null
        : Arquivo.fromJson(json['androidIcon'] as Map<String, dynamic>),
    iosIcon: json['iosIcon'] == null
        ? null
        : Arquivo.fromJson(json['iosIcon'] as Map<String, dynamic>),
    splash: json['splash'] == null
        ? null
        : Arquivo.fromJson(json['splash'] as Map<String, dynamic>),
    pushIcon: json['pushIcon'] == null
        ? null
        : Arquivo.fromJson(json['pushIcon'] as Map<String, dynamic>),
    backgroundHome: json['backgroundHome'] == null
        ? null
        : Arquivo.fromJson(json['backgroundHome'] as Map<String, dynamic>),
    logoHome: json['logoHome'] == null
        ? null
        : Arquivo.fromJson(json['logoHome'] as Map<String, dynamic>),
    backgroundLogin: json['backgroundLogin'] == null
        ? null
        : Arquivo.fromJson(json['backgroundLogin'] as Map<String, dynamic>),
    logoLogin: json['logoLogin'] == null
        ? null
        : Arquivo.fromJson(json['logoLogin'] as Map<String, dynamic>),
    backgroundMenu: json['backgroundMenu'] == null
        ? null
        : Arquivo.fromJson(json['backgroundMenu'] as Map<String, dynamic>),
    logoMenu: json['logoMenu'] == null
        ? null
        : Arquivo.fromJson(json['logoMenu'] as Map<String, dynamic>),
    backgroundInstitucional: json['backgroundInstitucional'] == null
        ? null
        : Arquivo.fromJson(
            json['backgroundInstitucional'] as Map<String, dynamic>),
    logoInstitucional: json['logoInstitucional'] == null
        ? null
        : Arquivo.fromJson(json['logoInstitucional'] as Map<String, dynamic>),
    cores: json['cores'] as Map<String, dynamic>,
  );
}

Map<String, dynamic> _$TemplateAplicativoToJson(TemplateAplicativo instance) =>
    <String, dynamic>{
      'androidIcon': instance.androidIcon,
      'iosIcon': instance.iosIcon,
      'splash': instance.splash,
      'pushIcon': instance.pushIcon,
      'backgroundHome': instance.backgroundHome,
      'logoHome': instance.logoHome,
      'backgroundLogin': instance.backgroundLogin,
      'logoLogin': instance.logoLogin,
      'backgroundMenu': instance.backgroundMenu,
      'logoMenu': instance.logoMenu,
      'backgroundInstitucional': instance.backgroundInstitucional,
      'logoInstitucional': instance.logoInstitucional,
      'cores': instance.cores,
    };
