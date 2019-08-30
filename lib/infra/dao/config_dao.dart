part of pocket_church.infra;

class ConfigDAO {

  Future<Configuracao> get() async {
    List<Map> list = await pcDatabase.database.rawQuery('SELECT value FROM config');

    if (list.isNotEmpty) {
      return Configuracao.fromJson(jsonDecode(list[0]['value']));
    }

    return null;
  }

  Future<dynamic> set(Configuracao configuracao) async {

    await pcDatabase.database.transaction((tx) async {
      await tx.execute('delete from config');
      await tx.execute('insert into config(value) values(?)', [
        jsonEncode(configuracao.toJson())
      ]);
    });

  }

}

ConfigDAO configDAO = ConfigDAO();