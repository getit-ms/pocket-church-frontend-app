part of pocket_church.infra;

class ProgressoSincronismo {
  final double porcentagem;
  final bool sincronizando;

  const ProgressoSincronismo(
      {this.porcentagem = 0, this.sincronizando = false});
}

typedef ProgressoObserver = Function(ProgressoSincronismo progresso);
