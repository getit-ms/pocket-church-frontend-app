part of pocket_church.model.banner;

class Banner {
  int id;
  int ordem;
  Arquivo banner;
  String linkExterno;
  Funcionalidade funcionalidade;
  String referenciaInterna;

  Banner({
    this.id,
    this.ordem,
    this.banner,
    this.linkExterno,
    this.funcionalidade,
    this.referenciaInterna,
  });

  operator ==(other) {
    return other is Banner && id == other.id;
  }

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'] as int,
      ordem: json['ordem'] as int,
      banner: json['banner'] != null ? Arquivo.fromJson(json['banner']) : null,
      linkExterno: json['linkExterno'] as String,
      funcionalidade: json['funcionalidade'] != null
          ? Funcionalidade.values.firstWhere(
              (f) => f.toString() == 'Funcionalidade.${json['funcionalidade']}')
          : null,
      referenciaInterna: json['referenciaInterna'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ordem': ordem,
      'banner': banner?.toJson(),
      'linkExterno': linkExterno,
      'funcionalidade':
          funcionalidade?.toString()?.replaceAll('Funcionalidade.', ''),
      'referenciaInterna': referenciaInterna,
    };
  }
}
