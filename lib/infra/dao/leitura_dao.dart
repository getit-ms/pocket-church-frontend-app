part of pocket_church.infra;

class LeituraDAO {
  _toPersistedDate(DateTime data) {
    return data.year * 10000 + data.month * 100 + data.day;
  }

  _fromPersistedDate(int data) {
    return DateTime(
      (data / 10000).floor(),
      ((data % 10000) / 100).floor(),
      data % 100,
    );
  }

  _ontem() {
    return DateTime.now().subtract(Duration(days: 1));
  }

  Future<DateTime> findUltimaAlteracao() async {
    List<Map> list = await pcDatabase.database.rawQuery(
      'SELECT max(ultima_atualizacao) AS ultimaAtualizacao FROM leitura_biblica2 WHERE remoto = ?',
      [true],
    );

    if (list.isNotEmpty && list[0]['ultimaAtualizacao'] != null) {
      return new DateTime.fromMillisecondsSinceEpoch(
        list[0]['ultimaAtualizacao'],
      );
    }

    return null;
  }

  mergePlano(PlanoLeitura planoLeitura) async {
    PlanoLeitura salvo = await findPlano();

    await pcDatabase.database.transaction((txn) async {
      if (salvo?.id == planoLeitura.id) {
        await txn.execute(
          "UPDATE plano_leitura SET descricao = ?",
          [
            planoLeitura.descricao,
          ],
        );
      } else {
        await txn.execute("DELETE FROM plano_leitura");
        await txn.execute("DELETE FROM leitura_biblica2");

        await txn.execute(
          "INSERT INTO plano_leitura(id, descricao) VALUES(?,?)",
          [
            planoLeitura.id,
            planoLeitura.descricao,
          ],
        );
      }
    });
  }

  mergeLeitura(Leitura leitura) async {
    await pcDatabase.database.transaction((txn) async {
      List<Map> rs = await txn.rawQuery(
        "SELECT ultima_atualizacao AS ultimaAtualizacao FROM leitura_biblica2 WHERE id = ?",
        [leitura.dia.id],
      );

      if (rs.isEmpty ||
          leitura.ultimaAlteracao.isAfter(DateTime.fromMillisecondsSinceEpoch(
              rs[0]['ultimaAtualizacao']))) {
        await txn.execute(
          "DELETE FROM leitura_biblica2 WHERE id = ?",
          [
            leitura.dia.id,
          ],
        );

        await txn.execute(
          "INSERT INTO leitura_biblica2(id, descricao, data, ultima_atualizacao, lido, sincronizado, remoto) VALUES(?,?,?,?,?,?,?)",
          [
            leitura.dia.id,
            leitura.dia.descricao,
            _toPersistedDate(leitura.dia.data),
            leitura.ultimaAlteracao.millisecondsSinceEpoch,
            leitura.lido ? 1 : 0,
            1,
            1,
          ],
        );
      }
    });
  }

  Future<PlanoLeitura> findPlano() async {
    List<Map> rs = await pcDatabase.database
        .rawQuery("SELECT id, descricao FROM plano_leitura");

    if (rs.isNotEmpty) {
      return PlanoLeitura(
        id: rs[0]['id'],
        descricao: rs[0]['descricao'],
      );
    }

    return null;
  }

  Future<List<Leitura>> findNaoSincronizados() async {
    List<Map> rs = await pcDatabase.database.rawQuery(
        "SELECT id, lido FROM leitura_biblica2 where sincronizado = ?", [0]);

    return rs
        .map(
          (item) => Leitura(
            dia: DiaLeitura(
              id: item['id'],
            ),
            lido: item['lido'] == 1,
          ),
        )
        .toList();
  }

  Future<PeriodoDatas> findRangeDatas() async {
    List<Map> rs = await pcDatabase.database.rawQuery(
      "SELECT min(data) as dataInicio, max(data) as dataTermino FROM leitura_biblica2",
    );

    if (rs.isNotEmpty &&
        rs[0]['dataInicio'] != null &&
        rs[0]['dataTermino'] != null) {
      return PeriodoDatas(
        dataInicio: _fromPersistedDate(rs[0]['dataInicio']),
        dataTermino: _fromPersistedDate(rs[0]['dataTermino']),
      );
    }

    return null;
  }

  Future<DateTime> findProximaDataNaoLida() async {
    List<Map> rs = await pcDatabase.database.rawQuery(
      "SELECT min(data) as data FROM leitura_biblica2 where lido = ?",
      [0],
    );

    if (rs.isNotEmpty && rs[0]['data'] != null) {
      return _fromPersistedDate(rs[0]['data']);
    }

    return null;
  }

  Future<Leitura> findByData(DateTime data) async {
    List<Map> rs = await pcDatabase.database.rawQuery(
        "SELECT id, descricao, lido, data FROM leitura_biblica2 where data = ?",
        [_toPersistedDate(data)]);

    if (rs.isNotEmpty) {
      return Leitura(
        dia: DiaLeitura(
          id: rs[0]['id'],
          descricao: rs[0]['descricao'],
          data: _fromPersistedDate(rs[0]['data']),
        ),
        lido: rs[0]['lido'] == 1,
      );
    }

    return null;
  }

  Future<List<DateTime>> findDatasLidas() async {
    List<Map> rs = await pcDatabase.database.rawQuery(
      "SELECT data FROM leitura_biblica2 where lido = ? order by data",
      [true],
    );

    return rs.map((item) => _fromPersistedDate(item['data'])).toList();
  }

  Future<ProgressoLeitura> findPorcentagem() async {
    List<Map> totalGeral = await pcDatabase.database.rawQuery(
        "SELECT count(*) as count FROM leitura_biblica2 where descricao is not null");

    if (totalGeral.isNotEmpty && totalGeral[0]['count'] != null) {
      List<Map> totalLido = await pcDatabase.database.rawQuery(
          "SELECT count(*) as count FROM leitura_biblica2 where lido = ? and descricao is not null",
          [1]);

      if (totalLido.isNotEmpty && totalLido[0]['count'] != null) {
        double porcentagem = totalLido[0]['count'].toDouble() *
            100 /
            math.max<double>(1, totalGeral[0]['count'].toDouble());

        List<Map> totalHoje = await pcDatabase.database.rawQuery(
            "SELECT count(*) as count FROM leitura_biblica2 where data <= ? and descricao is not null",
            [_toPersistedDate(_ontem())]);

        double porcentagemHoje = totalHoje[0]['count'].toDouble() *
            100 /
            math.max<double>(1, totalGeral[0]['count'].toDouble());

        if (totalHoje.isNotEmpty && totalHoje[0]['count'] != null) {
          List<Map> totalOntem = await pcDatabase.database.rawQuery(
              "SELECT count(*) as count FROM leitura_biblica2 where lido = ? and data <= ? and descricao is not null",
              [1, _toPersistedDate(_ontem())]);

          if (totalOntem.isNotEmpty && totalOntem[0]['count'] != null) {
            bool emDia = totalHoje[0]['count'] - totalOntem[0]['count'] <= 0;

            return ProgressoLeitura(
              porcentagem: porcentagem,
              porcentagemHoje: porcentagemHoje,
              emDia: emDia,
            );
          }
        }

        return ProgressoLeitura(
          porcentagem: porcentagem,
          porcentagemHoje: porcentagemHoje,
        );
      }
    }

    return ProgressoLeitura();
  }

  atualizaLeitura(int id, bool lido) async {
    await pcDatabase.database.execute(
      "update leitura_biblica2 set lido = ?, remoto = ? where id = ?",
      [lido ? 1 : 0, 0, id],
    );
  }

  atualizaSincronizacao(int id, bool sincronizado) async {
    await pcDatabase.database.execute(
      "update leitura_biblica2 set sincronizado = ?, ultima_atualizacao = ? where id = ?",
      [sincronizado, DateTime.now(), id],
    );
  }
}

class ProgressoLeitura {
  final double porcentagem;
  final double porcentagemHoje;
  final bool emDia;

  const ProgressoLeitura({
    this.porcentagem = 0,
    this.porcentagemHoje = 0,
    this.emDia = false,
  });

  bool get concluido => porcentagem == 100;
}

class PeriodoDatas {
  final DateTime dataInicio;
  final DateTime dataTermino;

  const PeriodoDatas({
    this.dataInicio,
    this.dataTermino,
  });
}

LeituraDAO leituraDAO = LeituraDAO();
