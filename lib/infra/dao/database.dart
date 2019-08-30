part of pocket_church.infra;

class PCDatabase {
  Database database;

  init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, 'pocket-church.db');

    database = await openDatabase(path);

    await database.transaction((tx) async {
      // When creating the db, create the table
      await tx.execute('CREATE TABLE IF NOT EXISTS livro_biblia(id, nome, ordem, abreviacao, ultima_atualizacao, testamento)');
      await tx.execute('CREATE INDEX IF NOT EXISTS idx_id_livro_biblia ON livro_biblia(id)');
      await tx.execute('CREATE INDEX IF NOT EXISTS idx_testamento_livro_biblia ON livro_biblia(testamento)');

      await tx.execute('CREATE TABLE IF NOT EXISTS versiculo_biblia(id, capitulo, versiculo, texto, id_livro)');
      await tx.execute('CREATE INDEX IF NOT EXISTS idx_id_livro_versiculo_biblia ON versiculo_biblia(id_livro)');

      await tx.execute('CREATE TABLE IF NOT EXISTS hino(id, nome, assunto, autor, texto, numero, filename, ultima_atualizacao)');
      await tx.execute('CREATE INDEX IF NOT EXISTS idx_id_hino ON hino(id)');

      await tx.execute('CREATE TABLE IF NOT EXISTS plano_leitura(id, descricao)');

      await tx.execute('CREATE TABLE IF NOT EXISTS leitura_biblica2(id, descricao, data, lido, sincronizado, ultima_atualizacao, id_plano, remoto)');
      await tx.execute('CREATE INDEX IF NOT EXISTS idx_id_leitura_biblia2 ON leitura_biblica2(id)');
      await tx.execute('CREATE INDEX IF NOT EXISTS idx_data_leitura_biblia2 ON leitura_biblica2(data)');

      await tx.execute('CREATE TABLE IF NOT EXISTS config(value)');

      await tx.execute('CREATE TABLE IF NOT EXISTS cache_pdf(tipo, id, pagina, hash, scale, ultimo_acesso)');

      await tx.execute('DROP INDEX IF EXISTS idx_id_leitura_biblia');
      await tx.execute('DROP INDEX IF EXISTS idx_data_leitura_biblia');
      await tx.execute('DROP TABLE IF EXISTS leitura_biblica');
    });
  }

}

PCDatabase pcDatabase = PCDatabase();