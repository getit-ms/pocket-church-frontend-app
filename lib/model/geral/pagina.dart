part of pocket_church.model.geral;

class Pagina<T> {
  List<T> resultados;
  int totalResultados;
  int totalPaginas;
  int pagina;
  bool hasProxima;

  Pagina({this.resultados, this.totalResultados, this.totalPaginas, this.pagina, this.hasProxima});

}