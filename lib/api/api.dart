library pocket_church.api;

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart' as dio;
import 'package:pocket_church/infra/infra.dart';
import 'package:pocket_church/model/aconselhamento/model.dart';
import 'package:pocket_church/model/agenda/model.dart';
import 'package:pocket_church/model/audio/model.dart';
import 'package:pocket_church/model/biblia/model.dart';
import 'package:pocket_church/model/cantico/model.dart';
import 'package:pocket_church/model/devocionario/model.dart';
import 'package:pocket_church/model/enquete/model.dart';
import 'package:pocket_church/model/evento/model.dart';
import 'package:pocket_church/model/galeria_fotos/model.dart';

import 'package:pocket_church/model/geral/model.dart';
import 'package:pocket_church/model/hino/model.dart';
import 'package:pocket_church/model/igreja/model.dart';
import 'package:pocket_church/model/institucional/model.dart';
import 'package:pocket_church/model/leitura_biblica/model.dart';
import 'package:pocket_church/model/menu/model.dart';
import 'package:pocket_church/model/boletim/model.dart';
import 'package:pocket_church/model/notificacao/model.dart';
import 'package:pocket_church/model/pedido_oracao/model.dart';
import 'package:pocket_church/model/preferencias/model.dart';
import 'package:pocket_church/model/sugestao/model.dart';
import 'package:pocket_church/model/termo-aceite/model.dart';
import 'package:pocket_church/model/video/model.dart';
import 'package:pocket_church/model/noticia/model.dart';
import 'package:pocket_church/model/estudo/model.dart';
import 'package:pocket_church/model/banner/model.dart';
import 'package:pocket_church/model/item_evento/model.dart';

part 'api_base.dart';
part 'service/institucional_api.dart';
part 'service/arquivo_api.dart';
part 'service/acesso_api.dart';
part 'service/boletim_api.dart';
part 'service/video_api.dart';
part 'service/noticia_api.dart';
part 'service/estudo_api.dart';
part 'service/calendario_api.dart';
part 'service/audio_api.dart';
part 'service/igreja_api.dart';
part 'service/assets_api.dart';
part 'service/membro_api.dart';
part 'service/notificacao_api.dart';
part 'service/evento_api.dart';
part 'service/agenda_api.dart';
part 'service/foto_api.dart';
part 'service/leitura_api.dart';
part 'service/biblia_api.dart';
part 'service/hino_api.dart';
part 'service/cantico_api.dart';
part 'service/pedido_oracao_api.dart';
part 'service/enquete_api.dart';
part 'service/chamado_api.dart';
part 'service/devocionario_api.dart';
part 'service/termo_aceite_api.dart';
part 'service/banner_api.dart';
part 'service/item_evento_api.dart';
