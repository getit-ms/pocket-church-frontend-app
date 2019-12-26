part of pocket_church.infra;

class Configuracao {
  final String basePath;
  final String chaveIgreja;
  final String nomeAplicativo;
  final String nomeIgreja;
  final String chaveDispositivo;
  final String version;
  final String authorization;
  final String template;

  const Configuracao({
    this.basePath,
    this.chaveIgreja,
    this.nomeAplicativo,
    this.nomeIgreja,
    this.chaveDispositivo,
    this.version,
    this.authorization,
    this.template,
  });

  factory Configuracao.fromJson(Map<String, dynamic> json) {
    return Configuracao(
      // A URL base é fixa e não deve mudar
      basePath: defaultConfig.basePath,
      chaveIgreja: json['headers'] != null
          ? json['headers']['Igreja'] ?? defaultConfig.chaveIgreja
          : defaultConfig.chaveIgreja,
      nomeIgreja: json['nomeIgreja'] ?? defaultConfig.nomeIgreja,
      nomeAplicativo: json['nomeAplicativo'] ?? defaultConfig.nomeAplicativo,
      chaveDispositivo: json['headers'] != null
          ? json['headers']['Dispositivo'] ?? defaultConfig.chaveDispositivo
          : defaultConfig.chaveDispositivo,
      version: json['version'] ?? defaultConfig.version,
      authorization: json['headers'] != null
          ? json['headers']['Authorization'] ?? defaultConfig.authorization
          : defaultConfig.authorization,
      template: json['template'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'server': basePath,
      'nomeIgreja': nomeIgreja,
      'nomeAplicativo': nomeAplicativo,
      'headers': {
        'Igreja': chaveIgreja,
        'Dispositivo': chaveDispositivo,
        'Authorization': authorization,
      },
      'version': version,
      'template': template,
    };
  }

  Configuracao copyWith({
    String basePath,
    String chaveIgreja,
    String nomeAplicativo,
    String nomeIgreja,
    String chaveDispositivo,
    String version,
    String authorization,
    String template,
  }) =>
      Configuracao(
          basePath: defaultConfig.basePath,
          chaveIgreja: chaveIgreja ?? this.chaveIgreja,
          nomeAplicativo: nomeAplicativo ?? this.nomeAplicativo,
          nomeIgreja: nomeIgreja ?? this.nomeIgreja,
          chaveDispositivo: chaveDispositivo ?? this.chaveDispositivo,
          version: version ?? this.version,
          authorization: authorization ?? this.authorization,
          template: template ?? this.template);
}

class Tema {
  final Color primary;
  final Color secondary;
  final Color buttonBackground;
  final Color buttonText;

  final Color appBarBackground;
  final Color appBarTitle;
  final Color appBarIcons;

  final Color socialIconsBackground;
  final Color socialIconsForeground;
  final Color topContentBorder;
  final ImageProvider homeLogo;
  final ImageProvider homeBackground;

  final Color loginButtonBackground;
  final Color loginButtonText;
  final ImageProvider loginLogo;
  final ImageProvider loginBackground;

  final Color menuIcon;
  final Color menuActiveIcon;
  final Color menuUserBackground;
  final Color menuUserText;
  final Color badgeBackground;
  final Color badgeText;
  final ImageProvider menuLogo;
  final ImageProvider menuBackground;

  final Color dividerBackground;
  final Color dividerText;
  final Color iconBackground;
  final Color iconForeground;
  final ImageProvider institucionalLogo;
  final ImageProvider institucionalBackground;

  const Tema({
    this.primary,
    this.secondary,
    this.buttonBackground,
    this.buttonText,
    this.appBarBackground,
    this.appBarTitle,
    this.appBarIcons,
    this.socialIconsBackground,
    this.socialIconsForeground,
    this.topContentBorder,
    this.homeLogo,
    this.homeBackground,
    this.loginButtonBackground,
    this.loginButtonText,
    this.loginLogo,
    this.loginBackground,
    this.menuIcon,
    this.menuActiveIcon,
    this.menuUserBackground,
    this.menuUserText,
    this.badgeBackground,
    this.badgeText,
    this.menuLogo,
    this.menuBackground,
    this.dividerBackground,
    this.dividerText,
    this.iconBackground,
    this.iconForeground,
    this.institucionalLogo,
    this.institucionalBackground,
  });

  factory Tema.fromTemplate(TemplateAplicativo template) {
    Map<String, dynamic> cores = template.cores ?? {};

    return Tema(
      appBarBackground:
          _parseColor(cores['appBarColor']) ?? defaultTema.appBarBackground,
      appBarIcons: _parseColor(cores['appBarIcons']) ?? defaultTema.appBarIcons,
      appBarTitle: _parseColor(cores['appBarTitle']) ?? defaultTema.appBarTitle,
      badgeBackground: _parseColor(cores['menuBadgeBackground']) ??
          defaultTema.badgeBackground,
      badgeText:
          _parseColor(cores['menuBadgeTextColor']) ?? defaultTema.badgeText,
      buttonBackground: _parseColor(cores['buttonBackground']) ??
          defaultTema.buttonBackground,
      buttonText:
          _parseColor(cores['buttonTextColor']) ?? defaultTema.buttonText,
      dividerText:
          _parseColor(cores['dividerTextColor']) ?? defaultTema.dividerText,
      dividerBackground: _parseColor(cores['dividerBackground']) ??
          defaultTema.dividerBackground,
      iconBackground:
          _parseColor(cores['iconBackground']) ?? defaultTema.iconBackground,
      iconForeground:
          _parseColor(cores['iconColor']) ?? defaultTema.iconForeground,
      loginButtonText: _parseColor(cores['loginButtonTextColor']) ??
          defaultTema.loginButtonText,
      loginButtonBackground: _parseColor(cores['loginButtonBackground']) ??
          defaultTema.loginButtonBackground,
      menuIcon: _parseColor(cores['menuIconColor']) ?? defaultTema.menuIcon,
      menuActiveIcon: _parseColor(cores['menuSelectedIconColor']) ??
          defaultTema.menuActiveIcon,
      menuUserText:
          _parseColor(cores['menuUserTextColor']) ?? defaultTema.menuUserText,
      menuUserBackground: _parseColor(cores['menuUserBackground']) ??
          defaultTema.menuUserBackground,
      primary: _parseColor(cores['primary']) ?? defaultTema.primary,
      secondary: _parseColor(cores['secondary']) ?? defaultTema.secondary,
      socialIconsForeground: _parseColor(cores['socialIconsColor']) ??
          defaultTema.socialIconsForeground,
      socialIconsBackground: _parseColor(cores['socialIconsBackground']) ??
          defaultTema.socialIconsBackground,
      topContentBorder: _parseColor(cores['topContentBorder']) ??
          defaultTema.topContentBorder,
      homeLogo: template.logoHome == null
          ? defaultTema.homeLogo
          : ArquivoImageProvider(template.logoHome.id),
      homeBackground: template.backgroundHome == null
          ? defaultTema.homeBackground
          : ArquivoImageProvider(template.backgroundHome?.id),
      institucionalLogo: template.logoInstitucional == null
          ? defaultTema.institucionalLogo
          : ArquivoImageProvider(template.logoInstitucional?.id),
      loginLogo: template.logoLogin == null
          ? defaultTema.loginLogo
          : ArquivoImageProvider(template.logoLogin?.id),
      menuLogo: template.logoMenu == null
          ? defaultTema.menuLogo
          : ArquivoImageProvider(template.logoMenu?.id),
      institucionalBackground: template.backgroundInstitucional == null
          ? defaultTema.institucionalBackground
          : ArquivoImageProvider(template.backgroundInstitucional?.id),
      loginBackground: template.backgroundLogin == null
          ? defaultTema.loginBackground
          : ArquivoImageProvider(template.backgroundLogin?.id),
      menuBackground: template.backgroundMenu == null
          ? defaultTema.menuBackground
          : ArquivoImageProvider(template.backgroundMenu?.id),
    );
  }

  static Color _parseColor(String hex) {
    if (hex == null) {
      return null;
    }

    hex = hex.replaceFirst("#", "");

    switch (hex.length) {
      case 3:
        var r = hex[0];
        var g = hex[1];
        var b = hex[2];

        return Color(int.parse("FF$r$r$g$g$b$b", radix: 16));
      case 4:
        var r = hex[0];
        var g = hex[1];
        var b = hex[2];
        var a = hex[3];

        return Color(int.parse("$a$a$r$r$g$g$b$b", radix: 16));
      case 6:
        var r = hex.substring(0, 2);
        var g = hex.substring(2, 4);
        var b = hex.substring(4, 6);

        return Color(int.parse("FF$r$g$b", radix: 16));
      case 8:
        var r = hex.substring(0, 2);
        var g = hex.substring(2, 4);
        var b = hex.substring(4, 6);
        var a = hex.substring(6);

        return Color(int.parse("$a$r$g$b", radix: 16));

      default:
        print('Unparseable color: #$hex');
        return null;
    }
  }
}

final String CONFIG = "config";
final String TEMA = "tema";
final String BUNDLE = "bundle";

class ConfiguracaoBloc {
  BehaviorSubject<Configuracao> _config = new BehaviorSubject<Configuracao>();
  BehaviorSubject<Tema> _tema = new BehaviorSubject<Tema>.seeded(defaultTema);
  BehaviorSubject<Bundle> _bundle = new BehaviorSubject<Bundle>();

  final IgrejaApi _igrejaApi = new IgrejaApi();
  final AssetsApi _assetsApi = new AssetsApi();

  Stream<Configuracao> get config => _config.stream;

  Configuracao get currentConfig => _config.value;

  Stream<Tema> get tema => _tema.stream;

  Tema get currentTema => _tema.value;

  Stream<Bundle> get bundle => _bundle.stream;

  Bundle get currentBundle => _bundle.value;

  init() async {
    await _initConfig();

    _loadTema();

    await _initBundle();
  }

  _addBundle(Bundle bundle) => _bundle.add(bundle);

  _addTema(Tema tema) => _tema.add(tema);

  _addConfiguracao(Configuracao config) {
    apiConfig.basePath = config.basePath;
    apiConfig.defaultHeaders['Igreja'] = config.chaveIgreja;
    apiConfig.defaultHeaders['Dispositivo'] = config.chaveDispositivo;

    if (config.authorization != null) {
      apiConfig.defaultHeaders['Authorization'] = config.authorization;
    } else {
      apiConfig.defaultHeaders.remove('Authorization');
    }

    _config.add(config);
  }

  close() {
    _config.close();
    _tema.close();
    _bundle.close();
  }

  _initBundle() async {
    String data =
        await services.rootBundle.loadString("assets/bundle/pt-br.json");

    _addBundle(new Bundle(json.decode(data)));

    refreshBundle();
  }

  refreshBundle() async {
    var sprefs = await SharedPreferences.getInstance();

    if (sprefs.containsKey(BUNDLE)) {
      try {
        _addBundle(new Bundle(json.decode(sprefs.get(BUNDLE))));
      } catch (ex) {
        sprefs.remove(BUNDLE);
      }
    }

    var base = new Bundle(await _assetsApi.buscaPorLocale("pt-br"));
    var igreja =
        new Bundle(await _assetsApi.buscaPorIgreja(_config.value.chaveIgreja));

    Bundle bundle = base.mergeWith(igreja);

    _addBundle(bundle);

    sprefs.setString(BUNDLE, json.encode(bundle.toJson()));
  }

  _initConfig() async {
    try {
      var sprefs = await SharedPreferences.getInstance();

      if (sprefs.containsKey(CONFIG)) {
        await _initFromSharedPreferences(sprefs);
      } else {
        await _initFromDB();
      }

      Configuracao config = _config.value ?? defaultConfig;

      if (config.chaveDispositivo == null) {
        config = config.copyWith(
          chaveDispositivo: Uuid().v4(),
          chaveIgreja: defaultConfig.chaveIgreja,
        );
      }

      config = config.copyWith(
        version: defaultConfig.version,
        chaveIgreja: defaultConfig.chaveIgreja,
      );

      _addConfiguracao(config);

      await configDAO.set(config);

      sprefs.setString(CONFIG, json.encode(config.toJson()));
    } catch (ex, stack) {
      print("Não foi possível carregar as configurações: $ex\n$stack");

      if (_config.value == null) {
        print("Configuração não foi carregada com sucesso. Aplicando valores padrões.");

        _config.add(defaultConfig.copyWith(
          chaveDispositivo: Uuid().v4(),
        ));
      }
    }
  }

  Future _initFromSharedPreferences(SharedPreferences sprefs) async {
    try {
      _addConfiguracao(Configuracao.fromJson(json.decode(sprefs.get(CONFIG))));
    } catch (ex, stack) {
      print("Falha ao carregar configuração de SharedPreferences: " + ex.toString() + "\n" + stack.toString());

      sprefs.remove(CONFIG);

      await _initFromDB();
    }
  }

  Future _initFromDB() async {
    try {
      Configuracao saved = await configDAO.get();

      if (saved != null) {
        _addConfiguracao(saved);
      }
    } catch (ex, stack) {
      print("Falha ao carregar configuração de banco de dados: " + ex.toString() + "\n" + stack.toString());
    }
  }

  _loadTema() async {
    var sprefs = await SharedPreferences.getInstance();

    if (sprefs.containsKey(TEMA)) {
      try {
        await _addTemplateTema(
            sprefs, TemplateAplicativo.fromJson(json.decode(sprefs.get(TEMA))));
      } catch (ex) {
        sprefs.remove(TEMA);
      }
    }

    await _addTemplateTema(sprefs, await _igrejaApi.buscaTemplate());
  }

  _addTemplateTema(
      SharedPreferences sprefs, TemplateAplicativo template) async {
    // Só adicionar o tema após todos os assetes serem carregados, dessa forma
    // se a internet do usuário for lenta ou não responder rápido,
    await _carregaAssets(template);

    _addTema(Tema.fromTemplate(template));

    sprefs.setString(TEMA, json.encode(template.toJson()));
  }

  update(Configuracao config) async {
    var sprefs = await SharedPreferences.getInstance();

    _addConfiguracao(config);

    await configDAO.set(config);

    sprefs.setString(CONFIG, json.encode(config.toJson()));
  }

  // Garante que os auquivos de assets serão carregados logo de início
  _carregaAssets(TemplateAplicativo template) async {
    await arquivoService.getFile(template.backgroundHome.id);
    await arquivoService.getFile(template.backgroundMenu.id);
    await arquivoService.getFile(template.backgroundLogin.id);
    await arquivoService.getFile(template.backgroundInstitucional.id);
    await arquivoService.getFile(template.logoMenu.id);
    await arquivoService.getFile(template.logoLogin.id);
    await arquivoService.getFile(template.logoInstitucional.id);
    await arquivoService.getFile(template.logoHome.id);
  }
}

class ConfiguracaoApp extends StatefulWidget {
  final Widget child;

  const ConfiguracaoApp({this.child});

  static ConfiguracaoAppState of(BuildContext context) {
    return context.ancestorStateOfType(new TypeMatcher<ConfiguracaoAppState>());
  }

  @override
  State<StatefulWidget> createState() => ConfiguracaoAppState();
}

class ConfiguracaoAppState extends State<ConfiguracaoApp> {
  Tema _tema;

  Configuracao _config;

  Menu _menu;

  Bundle _bundle;

  Tema get tema => _tema;

  Configuracao get config => _config;

  Menu get menu => _menu;

  Bundle get bundle => _bundle;

  StreamSubscription<Tema> _subscriptionoTema;
  StreamSubscription<Configuracao> _subscriptionoConfig;
  StreamSubscription<Menu> _subscriptionoMenu;
  StreamSubscription<Bundle> _subscriptionoBundle;

  @override
  void initState() {
    super.initState();

    _subscriptionoMenu = acessoBloc.menu.listen((menu) => setState(() {
          _menu = menu;
        }));

    _subscriptionoTema = configuracaoBloc.tema.listen((tema) => setState(() {
          _tema = tema;
        }));

    _subscriptionoConfig =
        configuracaoBloc.config.listen((config) => setState(() {
              _config = config;
            }));

    _subscriptionoBundle =
        configuracaoBloc.bundle.listen((bundle) => setState(() {
              _bundle = bundle;
            }));
  }

  @override
  void dispose() {
    super.dispose();

    _subscriptionoConfig.cancel();
    _subscriptionoTema.cancel();
    _subscriptionoMenu.cancel();
    _subscriptionoBundle.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (menu != null && config != null && tema != null) {
      return Theme(
        data: ThemeData(
          brightness: Brightness.light,
          accentColor: tema.primary,
          primaryColor: tema.primary,
          buttonColor: tema.buttonBackground,
          appBarTheme: AppBarTheme.of(context).copyWith(
            color: tema.appBarBackground,
            textTheme: Theme.of(context).primaryTextTheme.apply(
                  bodyColor: tema.appBarTitle,
                ),
            iconTheme: Theme.of(context)
                .primaryIconTheme
                .copyWith(color: tema.appBarIcons),
          ),
          dividerColor: tema.dividerBackground,
          iconTheme: Theme.of(context).primaryIconTheme.copyWith(
                color: tema.iconForeground,
              ),
        ),
        child: widget.child,
      );
    }

    return Container();
  }
}

class Bundle {
  final Map<String, dynamic> _data;

  const Bundle(this._data);

  Bundle mergeWith(Bundle bundle) {
    return new Bundle(_merge(_data, bundle._data));
  }

  get(String chave, {Map<String, dynamic> args}) {
    return _parsePath(bundle: _data, path: chave.split("."), args: args);
  }

  String operator [](String chave) {
    return get(chave);
  }

  static String _parsePath(
      {dynamic bundle, List<String> path, Map<String, Object> args}) {
    if (bundle != null) {
      if (path.length == 1) {
        String val = bundle[path[0]] ?? "";

        if (args != null) {
          args.forEach((k, v) => val = val.replaceAll("{$k}", v));
        }

        return val;
      } else {
        return _parsePath(
            bundle: bundle[path[0]], path: path.sublist(1), args: args);
      }
    }

    return path.join(".");
  }

  static Map<String, dynamic> _merge(
      Map<String, dynamic> map, Map<String, dynamic> map2) {
    Map<String, dynamic> merged = {};

    if (map != null && map2 != null) {
      map.forEach((k, v) {
        if (map2.containsKey(k)) {
          var v2 = map2[k];

          if (v2 is Map) {
            merged[k] = _merge(v as Map, v2);
          } else {
            merged[k] = v2;
          }
        } else {
          merged[k] = v;
        }
      });
    }

    return merged;
  }

  Map<String, dynamic> toJson() => _data;
}

ConfiguracaoBloc configuracaoBloc = new ConfiguracaoBloc();
