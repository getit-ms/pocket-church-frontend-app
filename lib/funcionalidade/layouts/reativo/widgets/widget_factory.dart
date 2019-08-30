part of pocket_church.widgets_reativos;

Map<Funcionalidade, WidgetBuilder>_widgets = {
  Funcionalidade.NOTICIAS: (context) => const WidgetNoticias(),
  Funcionalidade.INSTITUCIONAL: (context) => const WidgetInstitucional(),
  Funcionalidade.CONSULTAR_CONTATOS_IGREJA: (context) => const WidgetContatos(),
  Funcionalidade.ANIVERSARIANTES: (context) => const WidgetAniversariantes(),
  Funcionalidade.AGENDA: (context) => const WidgetCalendario(),
  Funcionalidade.REALIZAR_INSCRICAO_EVENTO: (context) => const WidgetEventos(),
  Funcionalidade.AGENDAR_ACONSELHAMENTO: (context) => const WidgetAconselhamento(),
  Funcionalidade.GALERIA_FOTOS: (context) => const WidgetFotos(),
  Funcionalidade.REALIZAR_INSCRICAO_EBD: (context) => const WidgetEBD(),
  Funcionalidade.CONSULTAR_PLANOS_LEITURA_BIBLICA: (context) => const WidgetLeituraBiblica(),
  Funcionalidade.LISTAR_ESTUDOS: (context) => const WidgetEstudos(),
  Funcionalidade.AUDIOS: (context) => const WidgetAudios(),
  Funcionalidade.YOUTUBE: (context) => const WidgetVideos(),
  Funcionalidade.LISTAR_BOLETINS: (context) => const WidgetBoletins(),
  Funcionalidade.CONSULTAR_HINARIO: (context) => const WidgetHinario(),
  Funcionalidade.LISTAR_PUBLICACOES: (context) => const WidgetPublicacoes(),
  Funcionalidade.CONSULTAR_CIFRAS: (context) => const WidgetCifras(),
  Funcionalidade.CONSULTAR_CANTICOS: (context) => const WidgetCanticos(),
};

class WidgetFuncionalidade extends StatelessWidget {

  final Funcionalidade funcionalidade;

  const WidgetFuncionalidade({this.funcionalidade});

  @override
  Widget build(BuildContext context) {
    if (funcionalidade != null &&
        _widgets.containsKey(funcionalidade) &&
        acessoBloc.temAcesso(funcionalidade)) {
      return _widgets[funcionalidade](context);
    }

    return Container();
  }

}
