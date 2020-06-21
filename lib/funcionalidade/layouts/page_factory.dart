import 'package:flutter/material.dart';
import 'package:pocket_church/funcionalidade/acesso/acesso.dart';
import 'package:pocket_church/funcionalidade/agenda/agenda.dart';
import 'package:pocket_church/funcionalidade/audio/audio.dart';
import 'package:pocket_church/funcionalidade/biblia/biblia.dart';
import 'package:pocket_church/funcionalidade/boletim/boletim.dart';
import 'package:pocket_church/funcionalidade/calendario/calendario.dart';
import 'package:pocket_church/funcionalidade/cantico/cantico.dart';
import 'package:pocket_church/funcionalidade/cifra/cifra.dart';
import 'package:pocket_church/funcionalidade/culto/culto.dart';
import 'package:pocket_church/funcionalidade/devocionario/devocionario.dart';
import 'package:pocket_church/funcionalidade/ebd/edb.dart';
import 'package:pocket_church/funcionalidade/enquete/enquete.dart';
import 'package:pocket_church/funcionalidade/estudo/estudo.dart';
import 'package:pocket_church/funcionalidade/evento/evento.dart';
import 'package:pocket_church/funcionalidade/fotos/fotos.dart';
import 'package:pocket_church/funcionalidade/hino/hino.dart';
import 'package:pocket_church/funcionalidade/institucional/institucional.dart';
import 'package:pocket_church/funcionalidade/leitura/leitura.dart';
import 'package:pocket_church/funcionalidade/membro/membro.dart';
import 'package:pocket_church/funcionalidade/noticia/noticia.dart';
import 'package:pocket_church/funcionalidade/notificacao/notificacao.dart';
import 'package:pocket_church/funcionalidade/pedido_oracao/pedido_oracao.dart';
import 'package:pocket_church/funcionalidade/publicacao/publicacao.dart';
import 'package:pocket_church/funcionalidade/sugestao/sugestao.dart';
import 'package:pocket_church/funcionalidade/video/video.dart';
import 'package:pocket_church/infra/infra.dart';

Map<Funcionalidade, WidgetBuilder> _pages = {
  Funcionalidade.NOTICIAS: (context) => PageListaNoticias(),
  Funcionalidade.NOTIFICACOES: (context) => PageListaNotificacoes(),
  Funcionalidade.INSTITUCIONAL: (context) => PageInstitucional(),
  Funcionalidade.CONSULTAR_CONTATOS_IGREJA: (context) => PageListaContatos(),
  Funcionalidade.ANIVERSARIANTES: (context) => PageListaAniversariantes(),
  Funcionalidade.AGENDA: (context) => PageCalendario(),
  Funcionalidade.REALIZAR_INSCRICAO_EBD: (context) => PageListaEBDs(),
  Funcionalidade.REALIZAR_INSCRICAO_EVENTO: (context) => PageListaEventos(),
  Funcionalidade.AGENDAR_ACONSELHAMENTO: (context) =>
      PageListaAconselhamentos(),
  Funcionalidade.GALERIA_FOTOS: (context) => PageListaGalerias(),
  Funcionalidade.CONSULTAR_PLANOS_LEITURA_BIBLICA: (context) => PageLeitura(),
  Funcionalidade.LISTAR_ESTUDOS: (context) => PageListaCategoriasEstudos(),
  Funcionalidade.BIBLIA: (context) => PageBiblia(),
  Funcionalidade.AUDIOS: (context) => PageListaCategoriasAudios(),
  Funcionalidade.YOUTUBE: (context) => PageListaVideos(),
  Funcionalidade.LISTAR_BOLETINS: (context) => PageListaBoletins(),
  Funcionalidade.LISTAR_PUBLICACOES: (context) => PageListaPublicacoes(),
  Funcionalidade.CONSULTAR_HINARIO: (context) => PageListaHinos(),
  Funcionalidade.CONSULTAR_CIFRAS: (context) => PageListaCifras(),
  Funcionalidade.CONSULTAR_CANTICOS: (context) => PageListaCanticos(),
  Funcionalidade.PEDIR_ORACAO: (context) => PagePedidoOracao(),
  Funcionalidade.REALIZAR_VOTACAO: (context) => PageListaEnquetes(),
  Funcionalidade.CHAMADOS: (context) => PageSugestao(),
  Funcionalidade.PREFERENCIAS: (context) => PagePreferencias(),
  Funcionalidade.DEVOCIONARIO: (context) => PageDevocionario(),
  Funcionalidade.REALIZAR_INSCRICAO_CULTO: (context) => PageListaCultos(),

};

class PageFactory {
  static Widget createPage(BuildContext context, Funcionalidade func) {
    if (func != null && _pages.containsKey(func)) {
      return _pages[func](context);
    }

    return Container();
  }
}
