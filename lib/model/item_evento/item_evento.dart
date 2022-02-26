part of pocket_church.model.item_evento;

enum TipoItemEvento {
  BOLETIM,
  ESTUDO,
  AUDIO,
  NOTICIA,
  EVENTO_CALENDARIO,
  EVENTO_INSCRICAO,
  VIDEO,
  FOTOS,
  EBD,
  CULTO,
  PUBLICACAO,
}

class TipoItemEventoSerializer {
  static tipoFromString(String tipo) {
    switch (tipo) {
      case "AUDIO":
        return TipoItemEvento.AUDIO;
      case "BOLETIM":
        return TipoItemEvento.BOLETIM;
      case "PUBLICACAO":
        return TipoItemEvento.PUBLICACAO;
      case "ESTUDO":
        return TipoItemEvento.ESTUDO;
      case "EVENTO_INSCRICAO":
        return TipoItemEvento.EVENTO_INSCRICAO;
      case "EVENTO_CALENDARIO":
        return TipoItemEvento.EVENTO_CALENDARIO;
      case "VIDEO":
        return TipoItemEvento.VIDEO;
      case "NOTICIA":
        return TipoItemEvento.NOTICIA;
      case "FOTOS":
        return TipoItemEvento.FOTOS;
      case "EBD":
        return TipoItemEvento.EBD;
      case "CULTO":
        return TipoItemEvento.CULTO;
    }

    return null;
  }

  static tipoToString(TipoItemEvento tipo) {
    switch (tipo) {
      case TipoItemEvento.AUDIO:
        return "AUDIO";
      case TipoItemEvento.BOLETIM:
        return "BOLETIM";
      case TipoItemEvento.ESTUDO:
        return "ESTUDO";
      case TipoItemEvento.EVENTO_INSCRICAO:
        return "EVENTO_INSCRICAO";
      case TipoItemEvento.EVENTO_CALENDARIO:
        return "EVENTO_CALENDARIO";
      case TipoItemEvento.VIDEO:
        return "VIDEO";
      case TipoItemEvento.NOTICIA:
        return "NOTICIA";
      case TipoItemEvento.FOTOS:
        return "FOTOS";
      case TipoItemEvento.EBD:
        return "EBD";
      case TipoItemEvento.CULTO:
        return "CULTO";
      case TipoItemEvento.PUBLICACAO:
        return "PUBLICACAO";
    }

    return null;
  }
}

class ItemEvento {
  String id;
  TipoItemEvento tipo;
  String titulo;
  String apresentacao;
  DateTime dataHoraPublicacao;
  DateTime dataHoraReferencia;
  Arquivo ilustracao;
  String urlIlustracao;
  Membro autor;

  bool curtido;
  int quantidadeCurtidas;
  int quantidadeComentarios;

  ItemEvento({
    this.id,
    this.tipo,
    this.titulo,
    this.apresentacao,
    this.dataHoraPublicacao,
    this.dataHoraReferencia,
    this.ilustracao,
    this.urlIlustracao,
    this.autor,
    this.curtido,
    this.quantidadeCurtidas,
    this.quantidadeComentarios,
  });

  factory ItemEvento.fromJson(Map<String, dynamic> json) => ItemEvento(
        id: json['id'],
        tipo: TipoItemEventoSerializer.tipoFromString(json['tipo']),
        titulo: json['titulo'],
        apresentacao: json['apresentacao']?.trim(),
        dataHoraPublicacao:
            DateTime.parse(json['dataHoraPublicacao']).toLocal(),
        dataHoraReferencia:
            DateTime.parse(json['dataHoraReferencia']).toLocal(),
        ilustracao: json['ilustracao'] != null
            ? Arquivo.fromJson(json['ilustracao'])
            : null,
        urlIlustracao: json['urlIlustracao'],
        autor: json['autor'] != null ? Membro.fromJson(json['autor']) : null,
        curtido: json['curtido'],
        quantidadeCurtidas: json['quantidadeCurtidas'],
        quantidadeComentarios: json['quantidadeComentarios'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'titulo': titulo,
        'apresentacao': apresentacao,
        'dataHoraPublicacao': dataHoraPublicacao?.toIso8601String(),
        'dataHoraReferencia': dataHoraReferencia?.toIso8601String(),
        'ilustracao': ilustracao?.toJson(),
        'urlIlustracao': urlIlustracao,
        'autor': autor?.toJson(),
        'tipo': TipoItemEventoSerializer.tipoToString(tipo),
        'curtido': curtido,
        'quantidadeCurtidas': quantidadeCurtidas,
        'quantidadeComentarios': quantidadeComentarios,
      };
}
