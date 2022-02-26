part of pocket_church.institucional;

class PageInstitucional extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    return PageTemplate(
      key: Key("page_institucional"),
      title: const IntlText("institucional.institucional"),
      body: ListView(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: tema.institucionalBackground,
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Image(
              image: tema.institucionalLogo,
              height: 70,
            ),
          ),
          StreamBuilder<Institucional>(
            stream: institucionalBloc.institucional,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  (snapshot.data.quemSomos?.isNotEmpty ?? false)) {
                return Column(
                  children: <Widget>[
                    InfoDivider(
                      child: const IntlText("institucional.quem_somos"),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: Theme.of(context).cardColor,
                      child: Text(
                        snapshot.data.quemSomos,
                        style: TextStyle(
                          height: 1.6,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Container();
            },
          ),
          StreamBuilder<Institucional>(
            stream: institucionalBloc.institucional,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  (snapshot.data.site != null ||
                      snapshot.data.email != null ||
                      snapshot.data.enderecos != null ||
                      snapshot.data.telefones != null)) {
                return Material(
                  child: Column(
                    children: <Widget>[
                      InfoDivider(
                        child: const IntlText("institucional.contatos"),
                      ),
                      snapshot.data.email != null
                          ? _buildEmail(snapshot.data.email)
                          : Container(),
                      snapshot.data.site != null
                          ? _buildSite(snapshot.data.site)
                          : Container(),
                    ]
                        .followedBy(
                            (snapshot.data.telefones ?? []).map(_buildTelefone))
                        .followedBy(
                            (snapshot.data.enderecos ?? []).map(_buildEndereco))
                        .toList(),
                  ),
                );
              }

              return Container();
            },
          )
        ],
      ),
    );
  }

  Widget _buildEndereco(Endereco endereco) {
    if (endereco == null || endereco.descricao == null) {
      return Container();
    }

    var strEndereco =
        "${endereco.descricao} - ${endereco.cidade} - ${endereco.estado} - ${StringUtil.formataCep(endereco.cep)}";

    return ItemInstitucional(
      icon: Icons.location_on,
      text: strEndereco,
      onTap: () => LaunchUtil.endereco(strEndereco),
    );
  }

  Widget _buildTelefone(String telefone) {
    return ItemInstitucional(
      icon: Icons.phone,
      text: StringUtil.formatTelefone(telefone),
      onTap: () => LaunchUtil.telefone(telefone),
    );
  }

  Widget _buildEmail(String email) {
    return ItemInstitucional(
      icon: Icons.email,
      text: email,
      onTap: () => LaunchUtil.mail(email),
    );
  }

  Widget _buildSite(String site) {
    return ItemInstitucional(
      icon: FontAwesomeIcons.globe,
      text: site,
      onTap: () => LaunchUtil.site(site),
    );
  }
}

class ItemInstitucional extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ItemInstitucional({
    this.icon,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconBlock(icon),
      title: Text(text),
      onTap: onTap,
    );
  }
}
