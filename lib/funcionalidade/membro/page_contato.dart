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
      title: IntlText("contato.contato"),
      body: FutureBuilder<Membro>(
          future: membroApi.detalha(membro.id),
          builder: (context, snapshot) {
            Endereco endereco = snapshot.data?.endereco ?? membro.endereco;

            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  expandedHeight: MediaQuery.of(context).size.width,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(StringUtil.nomeResumido(snapshot.data?.nome ?? membro.nome)),
                    background: Stack(
                      children: <Widget>[
                        SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: FotoMembro(
                            snapshot.data?.foto ?? membro.foto,
                            placeholder: tema.institucionalBackground,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                                colors: [Colors.transparent, Colors.black],
                                radius: 2),
                          ),
                        )
                      ],
                    ),
                  ),
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
                        (snapshot.data?.telefones ?? membro.telefones ?? []).map(
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
