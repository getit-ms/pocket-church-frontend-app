part of pocket_church.model.menu;

@JsonSerializable()
class Menu {
  String nome;
  String icone;
  int ordem;
  String link;
  int notificacoes;
  String funcionalidade;
  List<Menu> submenus;
  
  
  Menu({this.nome, this.icone, this.ordem, this.link, this.notificacoes, this.funcionalidade, this.submenus});

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  @override
  bool operator ==(other) {
    return other is Menu && other.nome == nome;
  }
}