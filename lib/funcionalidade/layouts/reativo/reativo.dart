library pocket_church.layout_reativo;

import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocket_church/bloc/acesso_bloc.dart';
import 'package:pocket_church/bloc/institucional_bloc.dart';
import 'package:pocket_church/componentes/componentes.dart';
import 'package:pocket_church/funcionalidade/acesso/acesso.dart';
import 'package:pocket_church/funcionalidade/layouts/page_factory.dart';
import 'package:pocket_church/funcionalidade/layouts/reativo/widgets/widgets.dart';
import 'package:pocket_church/infra/infra.dart';
import 'package:pocket_church/model/geral/model.dart';
import 'package:pocket_church/model/institucional/model.dart';
import 'package:pocket_church/model/menu/model.dart';
import 'package:pocket_church/timeline/timeline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

part './layout.dart';
part './tab_home.dart';
part './tab_mais.dart';
part './tab_menu.dart';
