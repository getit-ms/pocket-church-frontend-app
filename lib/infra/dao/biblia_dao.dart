part of pocket_church.infra;

class BibliaDAO {
  Future<DateTime> findUltimaAlteracaoLivroBiblia() async {
    List<Map> rs = await pcDatabase.database.rawQuery(
        "SELECT max(ultima_atualizacao) as ultimaAtualizacao FROM livro_biblia");

    if (rs.isNotEmpty && rs[0]['ultimaAtualizacao'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(rs[0]['ultimaAtualizacao']);
    }

    return null;
  }

  Future<int> findQuantidadeTotalLivros() async {
    List<Map> rs = await pcDatabase.database
        .rawQuery("SELECT count(*) as qtde FROM livro_biblia");

    if (rs.isNotEmpty && rs[0]['qtde'] != null) {
      return rs[0]['qtde'];
    }

    return 0;
  }

  mergeLivroBiblia(LivroBiblia livro) async {
    await pcDatabase.database.transaction((txn) async {
      await txn.execute(
        "delete from versiculo_biblia where id_livro = ?",
        [livro.id],
      );
      await txn.execute(
        "delete from livro_biblia where id = ?",
        [livro.id],
      );

      await txn.execute(
        "insert into livro_biblia(id, nome, ordem, abreviacao, ultima_atualizacao, testamento) values(?,?,?,?,?,?)",
        [
          livro.id,
          livro.nome,
          livro.ordem,
          livro.abreviacao,
          livro.ultimaAtualizacao.millisecondsSinceEpoch,
          livro.testamento
        ],
      );

      for (VersiculoBiblia versiculo in livro.versiculos) {
        await txn.execute(
          "insert into versiculo_biblia(id, capitulo, versiculo, texto, id_livro) values(?,?,?,?,?)",
          [
            versiculo.id,
            versiculo.capitulo,
            versiculo.versiculo,
            versiculo.texto,
            livro.id
          ],
        );
      }
    });
  }

  Future<List<LivroBiblia>> findLivrosBibliaByTestamento(
      String testamento) async {
    List<Map> rs = await pcDatabase.database.rawQuery(
      "SELECT id, nome, abreviacao FROM livro_biblia where testamento = ? order by ordem",
      [testamento],
    );

    return rs
        .map((item) => LivroBiblia(
              id: item['id'],
              nome: item['nome'],
              abreviacao: item['abreviacao'],
            ))
        .toList();
  }

  Future<LivroBiblia> findLivroById(int id) async {
    List<Map> rs = await pcDatabase.database.rawQuery(
        "SELECT id, nome, abreviacao FROM livro_biblia where id = ? order by ordem",
        [id]);

    if (rs.isNotEmpty) {
      Map item = rs[0];

      return LivroBiblia(
        id: item['id'],
        nome: item['nome'],
        abreviacao: item['abreviacao'],
      );
    }

    return null;
  }

  Future<LivroCapitulo> findPrimeiroLivro([String testamento = 'VELHO']) async {
    List<Map> rs = await pcDatabase.database.rawQuery(
        "SELECT id, nome, abreviacao FROM livro_biblia where ordem = 1 and testamento = ? order by ordem",
        [testamento]);

    if (rs.isNotEmpty) {
      Map item = rs[0];

      return LivroCapitulo(
        testamento: testamento,
        livro: LivroBiblia(
          id: item['id'],
          nome: item['nome'],
          abreviacao: item['abreviacao'],
        ),
        capitulo: 1,
      );
    }

    return null;
  }

  Future<List<int>> findCapitulosLivroBiblia(int livro) async {
    List<Map> rs = await pcDatabase.database.rawQuery(
      "SELECT capitulo as capitulo FROM versiculo_biblia where id_livro = ? group by capitulo order by capitulo",
      [livro],
    );

    return rs.map((item) => item['capitulo'] as int).toList();
  }

  Future<List<VersiculoBiblia>> findVersiculosByLivroCapituloBiblia(
      int livro, int capitulo) async {
    List<Map> rs = await pcDatabase.database.rawQuery(
      "SELECT * FROM versiculo_biblia where id_livro = ? and capitulo = ? order by versiculo",
      [livro, capitulo],
    );

    return rs
        .map((item) => VersiculoBiblia(
              id: item['id'],
              versiculo: item['versiculo'],
              texto: item['texto'].trim(),
            ))
        .toList();
  }

  Future<Pagina<VersiculoBiblia>> findVersiculosByFiltro({String filtro, int pagina = 1, int tamanhoPagina}) async {
    List<Map> rs = await pcDatabase.database.rawQuery(
      "SELECT v.id as idVersiculo, v.versiculo, v.texto, v.capitulo, lb.id as idLivro, lb.nome as nomeLivro, lb.abreviacao abreviacaoLivro, lb.testamento FROM versiculo_biblia v, livro_biblia lb where v.id_livro = lb.id and (v.texto || lb.nome || ' ' || v.capitulo || ':' || v.versiculo) like ? order by lb.testamento desc, lb.ordem, v.capitulo, v.versiculo limit ?, ?",
      ['%' + (filtro ?? "") + '%', (pagina - 1) * tamanhoPagina, tamanhoPagina + 1],
    );

    return Pagina(
        pagina: pagina,
        hasProxima: rs.length > tamanhoPagina,
        resultados: rs.map((item) => VersiculoBiblia(
          id: item['idVersiculo'],
          versiculo: item['versiculo'],
          texto: (item['texto'] as String).replaceAll(RegExp("(<[^>]+>|\\s)+"), " ").trim(),
          capitulo: item['capitulo'],
          livroCapitulo: LivroCapitulo(
            capitulo: item['capitulo'],
            testamento: item['testamento'],
            livro: LivroBiblia(
              id: item['idLivro'],
              nome: item['nomeLivro'],
              abreviacao: item['abreviacaoLivro']
            )
          )
        )).toList().sublist(0, math.min(rs.length, tamanhoPagina))
    );
  }

  Future<LivroCapitulo> findProximoCapitulo(
      String testamento, int id, int capitulo) async {
    List<int> capitulos = await findCapitulosLivroBiblia(id);

    if (capitulos.indexOf(capitulo) + 1 >= capitulos.length) {
      List<LivroBiblia> livros = await findLivrosBibliaByTestamento(testamento);

      if (livros.indexOf(LivroBiblia(id: id)) + 1 >= livros.length) {
        if (testamento == 'VELHO') {
          return await findPrimeiroLivro('NOVO');
        }

        return await findPrimeiroLivro('VELHO');
      }

      return LivroCapitulo(
          testamento: testamento,
          livro: livros[livros.indexOf(LivroBiblia(id: id)) + 1],
          capitulo: 1);
    }

    return LivroCapitulo(
        testamento: testamento,
        livro: await findLivroById(id),
        capitulo: capitulos[capitulos.indexOf(capitulo) + 1]);
  }

  Future<LivroCapitulo> findCapituloAnterior(
      String testamento, int id, int capitulo) async {
    if (capitulo - 1 < 1) {
      List<LivroBiblia> livros = await findLivrosBibliaByTestamento(testamento);

      if (livros.indexOf(LivroBiblia(id: id)) == 0) {
        if (testamento == 'NOVO') {
          List<LivroBiblia> livros =
              await findLivrosBibliaByTestamento('VELHO');
          List<int> capitulos =
              await findCapitulosLivroBiblia(livros[livros.length - 1].id);

          return LivroCapitulo(
              testamento: 'VELHO',
              livro: livros[livros.length - 1],
              capitulo: capitulos[capitulos.length - 1]);
        } else {
          List<LivroBiblia> livros = await findLivrosBibliaByTestamento('NOVO');
          List<int> capitulos =
              await findCapitulosLivroBiblia(livros[livros.length - 1].id);

          return LivroCapitulo(
              testamento: 'NOVO',
              livro: livros[livros.length - 1],
              capitulo: capitulos[capitulos.length - 1]);
        }
      }

      return LivroCapitulo(
          testamento: testamento,
          livro: livros[livros.indexOf(LivroBiblia(id: id)) - 1],
          capitulo: 1);
    }

    return LivroCapitulo(
        testamento: testamento,
        livro: await findLivroById(id),
        capitulo: capitulo - 1);
  }
}

class LivroCapitulo {
  final String testamento;
  final LivroBiblia livro;
  final int capitulo;

  const LivroCapitulo({
    this.testamento,
    this.livro,
    this.capitulo,
  });

  toJson() => {
        'testamento': testamento,
        'livro': livro.toJson(),
        'capitulo': capitulo,
      };

  LivroCapitulo.fromJson(Map<String, dynamic> json)
      : testamento = json['testamento'],
        livro = LivroBiblia.fromJson(json['livro']),
        capitulo = json['capitulo'];
}

BibliaDAO bibliaDAO = BibliaDAO();
