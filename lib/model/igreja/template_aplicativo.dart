part of pocket_church.model.igreja;

@JsonSerializable()
class TemplateAplicativo {
  Arquivo androidIcon;
  Arquivo iosIcon;
  Arquivo splash;
  Arquivo pushIcon;
  Arquivo backgroundHome;
  Arquivo logoHome;
  Arquivo backgroundLogin;
  Arquivo logoLogin;
  Arquivo backgroundMenu;
  Arquivo logoMenu;
  Arquivo backgroundInstitucional;
  Arquivo logoInstitucional;
  Map<String, dynamic> cores;


  TemplateAplicativo({
    this.androidIcon,
    this.iosIcon,
    this.splash,
    this.pushIcon,
    this.backgroundHome,
    this.logoHome,
    this.backgroundLogin,
    this.logoLogin,
    this.backgroundMenu,
    this.logoMenu,
    this.backgroundInstitucional,
    this.logoInstitucional,
    this.cores
  });

  factory TemplateAplicativo.fromJson(Map<String, dynamic> json) => _$TemplateAplicativoFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateAplicativoToJson(this);

}