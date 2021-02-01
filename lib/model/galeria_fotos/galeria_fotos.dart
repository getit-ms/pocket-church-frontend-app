part of pocket_church.model.galeria_fotos;

@JsonSerializable()
class GaleriaFotos {
  String id;
  String nome;
  String descricao;
  DateTime dataAtualizacao;
  
  Foto fotoPrimaria;
  
  int quantidadeFotos;


  GaleriaFotos({this.id, this.nome, this.descricao, this.dataAtualizacao, this.fotoPrimaria, this.quantidadeFotos});

  factory GaleriaFotos.fromJson(Map<String, dynamic> json) => _$GaleriaFotosFromJson(json);

  Map<String, dynamic> toJson() => _$GaleriaFotosToJson(this);
}