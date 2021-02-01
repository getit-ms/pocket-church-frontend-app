part of pocket_church.infra;

class HinoDAO {
  Future<DateTime> findUltimaAlteracaoHinos() async {
    List<Map> rs = await pcDatabase.database.rawQuery(
        "SELECT max(ultima_atualizacao) as ultimaAtualizacao FROM hino");

    if (rs.isNotEmpty && rs[0]['ultimaAtualizacao'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(rs[0]['ultimaAtualizacao']);
    }

    return null;
  }

  mergeHino(Hino hino) async {
    await pcDatabase.database.transaction((txn) async {
      await txn.execute(
        "delete from hino where id = ?",
        [hino.id],
      );

      await txn.execute(
        "insert into hino(id, numero, assunto, autor, nome, texto, filename, ultima_atualizacao) values(?,?,?,?,?,?,?,?)",
        [hino.id, hino.numero, hino.assunto, hino.autor, hino.nome, hino.texto, hino.filename, hino.ultimaAlteracao.millisecondsSinceEpoch],
      );

    });
  }

  Future<Pagina<Hino>> findHinosByFiltro({String filtro, int pagina = 1, int tamanhoPagina}) async {
    List<Map> rs = await pcDatabase.database.rawQuery(
      "SELECT id, numero, nome FROM hino where (numero || nome || texto) like ? order by numero, nome limit ?, ?",
      ['%' + (filtro ?? "") + '%', (pagina - 1) * tamanhoPagina, tamanhoPagina + 1],
    );

    return Pagina(
      pagina: pagina,
      hasProxima: rs.length > tamanhoPagina,
      resultados: rs.map((item) => Hino(
        id: item['id'],
        numero: item['numero'],
        nome: item['nome'],
      )).toList().sublist(0, math.min(rs.length, tamanhoPagina))
    );
  }

  Future<Hino> findHino(int id) async {
    List<Map> rs = await pcDatabase.database.rawQuery(
        "SELECT id, numero, nome, assunto, texto, autor, filename FROM hino where id = ?",
        [id]
    );

    if (rs.isNotEmpty) {
      Map item = rs[0];

      return Hino(
        id: item['id'],
        numero: item['numero'],
        nome: item['nome'],
        texto: item['texto'],
        assunto: item['assunto'],
        autor: item['autor'],
        filename: item['filename'],
      );
    }

    return null;
  }

}

HinoDAO hinoDAO = HinoDAO();
