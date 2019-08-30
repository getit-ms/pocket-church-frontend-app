part of pocket_church.infra;

class LaunchUtil {

  static endereco(String endereco) async {
    if (Platform.isIOS){
      launch("maps://maps.apple.com/?daddr='$endereco'");
    }else{
      launch("geo:0,0?q=$endereco");
    }
  }

  static telefone(String telefone) async {
    launch("tel:0$telefone");
  }

  static site(String site) async {
    if (site.startsWith("http")) {
      launch(site);
    } else {
      launch("http://$site");
    }
  }

  static mail(String email) async {
    launch("mailto:$email");
  }


}