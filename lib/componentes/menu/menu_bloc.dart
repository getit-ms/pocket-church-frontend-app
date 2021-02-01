part of pocket_church.componentes;


class MenuBloc {
  final _menuFetcher = BehaviorSubject<Menu>();
  final _activeMenuFetcher = BehaviorSubject<Menu>.seeded(null);

  ValueStream<Menu> get menu => _menuFetcher.stream;

  ValueStream<Menu> get activeMenu => _activeMenuFetcher.stream;

  MenuBloc() {
    acessoBloc.menu.listen(_menuFetcher.sink.add);
  }

  activateMenu(Menu menu) {
    _activeMenuFetcher.sink.add(menu);
  }

  deactivateMenu() {
    _activeMenuFetcher.sink.add(null);
  }

  dispose() {
    _menuFetcher.close();
    _activeMenuFetcher.close();
  }

}

final MenuBloc menuBloc = MenuBloc();
