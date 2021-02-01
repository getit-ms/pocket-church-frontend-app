library pocket_church.funcionalidade_acesso;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:pocket_church/api/api.dart';
import 'package:pocket_church/bloc/acesso_bloc.dart';
import 'package:pocket_church/componentes/componentes.dart';
import 'package:pocket_church/model/geral/model.dart';
import 'package:pocket_church/model/preferencias/model.dart';
import 'package:pocket_church/page_apresentacao.dart';

import '../../infra/infra.dart';
import '../../componentes/componentes.dart' as comp;

part './page_login.dart';
part './page_perfil.dart';
part './page_preferencias.dart';