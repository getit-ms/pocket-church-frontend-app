part of pocket_church.membro;

class PageContato extends StatelessWidget {
  final Membro membro;

  PageContato({this.membro});

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return PageTemplate(
      withAppBar: false,
      deveEstarAutenticado: true,
      title: const IntlText("contato.contato"),
      body: FutureBuilder<Membro>(
          future: membroApi.detalha(membro.id),
          builder: (context, snapshot) {
            Endereco endereco = snapshot.data?.endereco ?? membro.endereco;

            return CustomScrollView(
              slivers: <Widget>[
                SliverPersistentHeader(
                  pinned: true,
                  delegate: HeaderContato(
                      minExtent:
                          MediaQuery.of(context).padding.top + kToolbarHeight,
                      maxExtent: MediaQuery.of(context).padding.top + 350,
                      background: FotoMembro(
                        snapshot.data?.foto ?? membro.foto,
                        placeholder: tema.institucionalBackground,
                      ),
                      title: Text(StringUtil.nomeResumido(
                          snapshot.data?.nome ?? membro.nome))),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Card(
                    child: Column(
                      children: <Widget>[
                        new ItemContato(
                          icon: Icons.person,
                          text: snapshot.data?.nome ?? membro.nome,
                        ),
                        ItemContato(
                          icon: Icons.email,
                          text: snapshot.data?.email ?? membro.email,
                          onTap: () => LaunchUtil.mail(
                            snapshot.data?.email ?? membro.email,
                          ),
                        ),
                      ]
                          .followedBy(
                        (snapshot.data?.telefones ?? membro.telefones ?? [])
                            .map(
                          (tel) => ItemContato(
                            icon: Icons.phone,
                            text: StringUtil.formatTelefone(tel),
                            onTap: () => LaunchUtil.telefone(tel),
                          ),
                        ),
                      )
                          .followedBy(
                        [
                          ItemContato(
                            icon: Icons.location_on,
                            text: endereco != null
                                ? "${endereco.descricao} - ${endereco.cidade} - ${endereco.estado}"
                                : null,
                            onTap: endereco != null
                                ? () => LaunchUtil.endereco(
                                      "${endereco.descricao} - ${endereco.cidade} - ${endereco.estado}",
                                    )
                                : null,
                          ),
                        ],
                      ).toList(),
                    ),
                    margin: const EdgeInsets.all(5),
                  )
                ]))
              ],
            );
          }),
    );
  }
}

class ItemContato extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ItemContato({
    Key key,
    this.icon,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return ListTile(
        leading: IconBlock(icon),
        title: Text(text),
        onTap: onTap,
      );
    }

    return Container();
  }
}

class HeaderContato extends SliverPersistentHeaderDelegate {
  final List<Widget> actions;
  final Widget title;
  final double minExtent;
  final double maxExtent;
  final Widget background;

  const HeaderContato({
    this.title,
    this.background,
    this.actions,
    this.minExtent,
    this.maxExtent,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    var mediaQueryData = MediaQuery.of(context);

    double currentExtent = max(minExtent, maxExtent - shrinkOffset);
    double factor = min(
        1,
        (currentExtent - minExtent) /
            (min(minExtent + 120, maxExtent) - minExtent));

    return Container(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: lerpDouble(3, 0, factor),
                    color: Colors.black54,
                  ),
                ],
              ),
              child: background ?? Container(),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color.lerp(
                        tema.appBarBackground, Colors.transparent, factor),
                    Color.lerp(tema.appBarBackground, Colors.black54, factor),
                  ],
                  radius: 1.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: mediaQueryData.padding.top + 3,
            left: 5,
            child: BackButton(
              color: Color.lerp(
                tema.appBarIcons,
                Colors.white,
                factor,
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: lerpDouble(33, 3, factor),
            width: lerpDouble(
              mediaQueryData.size.width - 66,
              mediaQueryData.size.width - 6,
              factor,
            ),
            child: DefaultTextStyle(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: lerpDouble(21, 32, factor),
                color: Color.lerp(
                  tema.appBarTitle,
                  Colors.white,
                  factor,
                ),
              ),
              child: title ?? Container(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
