part of pocket_church.componentes;


class MenuBloc {
  final _menuFetcher = BehaviorSubject<Menu>();
  final _activeMenuFetcher = BehaviorSubject<Menu>(seedValue: null);

  Observable<Menu> get menu => _menuFetcher.stream;

  Observable<Menu> get activeMenu => _activeMenuFetcher.stream;

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