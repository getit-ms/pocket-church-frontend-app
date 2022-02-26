library pocket_church.componentes;

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pocket_church/api/api.dart';
import 'package:pocket_church/bloc/acesso_bloc.dart';
import 'package:pocket_church/bloc/calendario_bloc.dart';
import 'package:pocket_church/funcionalidade/acesso/acesso.dart';
import 'package:pocket_church/funcionalidade/inicio/inicio.dart';
import 'package:pocket_church/funcionalidade/notificacao/notificacao.dart';
import 'package:pocket_church/funcionalidade/page_factory.dart';
import 'package:pocket_church/infra/infra.dart';
import 'package:pocket_church/model/menu/model.dart';
import 'package:pocket_church/model/evento/model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:synchronized/synchronized.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_html/flutter_html.dart';

import '../infra/infra.dart';
import '../model/geral/model.dart';

part './acesso/icon_usuario.dart';

part './calendario/selecao_calendario.dart';

part './error/error_handler.dart';

part './file/progresso_upload_arquivo.dart';

part './input/input_anexo.dart';

part './input/input_campo_evento.dart';

part './input/input_data.dart';

part './input/input_numero.dart';

part './input/select_opcao.dart';

part './intl/intl_builder.dart';

part './intl/intl_text.dart';

part './item/info_divider.dart';

part './item/social_icon_button.dart';

part './list/infinite_list.dart';

part './list/sliver_infinite_list.dart';

part './menu/menu_bloc.dart';

part './menu/menu_drawer.dart';

part './menu/menu_item.dart';

part './menu/menu_item_usuario.dart';

part './menu/raiz_menu.dart';

part './message/message_handler.dart';

part './message/notificacao_interna.dart';

part './pdf/galeria_pdf.dart';

part './pdf/lista_paginas_pdf.dart';

part './pdf/pagina_pdf_image_provider.dart';

part './pdf/pdf_viewer_builder.dart';

part './player/audio_progress.dart';

part './player/bottom_player_control.dart';

part './player/detalhe_player.dart';

part './scaffold/page_template.dart';

part './util/arquivo_image_provider.dart';

part './util/bottom_menu.dart';

part './util/command_button.dart';

part './util/custom_html.dart';

part './util/download_progress.dart';

part './util/foto_membro.dart';

part './util/icon_block.dart';

part './util/icon_notificacoes.dart';

part './util/photo_view_page.dart';

part './util/share_util.dart';

part './util/shimmer_placeholder.dart';

part './util/widget_body.dart';
