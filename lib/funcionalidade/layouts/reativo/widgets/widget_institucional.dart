part of pocket_church.widgets_reativos;

class WidgetInstitucional extends StatelessWidget {
  const WidgetInstitucional();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText(
        "institucional.institucional",
      ),
      onMore: () {
        NavigatorUtil.navigate(context,
            builder: (context) => PageInstitucional());
      },
      body: Container(
          child: StreamBuilder<Institucional>(
              stream: institucionalBloc.institucional,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      _buildItem(
                        icon: FontAwesomeIcons.globe,
                        onPressed: _site(context, snapshot.data),
                        label: const IntlText("institucional.site"),
                      ),
                      _buildItem(
                        icon: FontAwesomeIcons.envelope,
                        onPressed: _email(context, snapshot.data),
                        label: const IntlText("institucional.email"),
                      ),
                      _buildItem(
                        icon: FontAwesomeIcons.phone,
                        onPressed: _telefone(context, snapshot.data),
                        label: const IntlText("institucional.telefones"),
                      ),
                      _buildItem(
                        icon: FontAwesomeIcons.mapMarker,
                        onPressed: _endereco(context, snapshot.data),
                        label: const IntlText("institucional.endereco"),
                      ),
                      _buildItem(
                        icon: FontAwesomeIcons.facebookF,
                        onPressed:
                            _redesSociais(context, snapshot.data, 'facebook'),
                        label: const IntlText(
                            "institucional.redes_sociais.facebook"),
                      ),
                      _buildItem(
                        icon: FontAwesomeIcons.instagram,
                        onPressed:
                            _redesSociais(context, snapshot.data, 'instagram'),
                        label: const IntlText(
                            "institucional.redes_sociais.instagram"),
                      ),
                      _buildItem(
                        icon: FontAwesomeIcons.twitter,
                        onPressed:
                            _redesSociais(context, snapshot.data, 'twitter'),
                        label: const IntlText(
                            "institucional.redes_sociais.twitter"),
                      ),
                      _buildItem(
                        icon: FontAwesomeIcons.pinterest,
                        onPressed:
                            _redesSociais(context, snapshot.data, 'pinterest'),
                        label: const IntlText(
                            "institucional.redes_sociais.pinterest"),
                      ),
                      _buildItem(
                        icon: FontAwesomeIcons.googlePlus,
                        onPressed: _redesSociais(
                            context, snapshot.data, 'google-plus'),
                        label: const IntlText(
                            "institucional.redes_sociais.google_plus"),
                      ),
                      _buildItem(
                        icon: FontAwesomeIcons.youtube,
                        onPressed:
                            _redesSociais(context, snapshot.data, 'youtube'),
                        label: const IntlText(
                            "institucional.redes_sociais.youtube"),
                      ),
                    ].where((w) => w != null).toList(),
                  ),
                );
              })),
    );
  }

  Widget _buildItem({IconData icon, VoidCallback onPressed, Widget label}) {
    if (onPressed != null) {
      return _OpcaoItem(
        icon: icon,
        onPressed: onPressed,
        label: label,
      );
    }

    return null;
  }

  VoidCallback _redesSociais(
      BuildContext context, Institucional institucional, String name) {
    if (institucional?.redesSociais != null &&
        institucional.redesSociais.containsKey(name)) {
      return () {
        LaunchUtil.site(institucional.redesSociais[name]);
      };
    }

    return null;
  }

  VoidCallback _email(BuildContext context, Institucional institucional) {
    if (institucional?.email != null) {
      return () {
        LaunchUtil.mail(institucional.email);
      };
    }

    return null;
  }

  VoidCallback _site(BuildContext context, Institucional institucional) {
    if (institucional?.site != null) {
      return () {
        LaunchUtil.site(institucional.site);
      };
    }

    return null;
  }

  VoidCallback _endereco(BuildContext context, Institucional institucional) {
    if (institucional?.enderecos?.isNotEmpty ?? false) {
      if (institucional.enderecos.length == 1) {
        return () {
          LaunchUtil.endereco(
            StringUtil.formatEndereco(institucional.enderecos[0]),
          );
        };
      }

      return () => showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                title: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.location_on,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const IntlText("institucional.endereco")
                  ],
                ),
                children: institucional.enderecos
                    .map((endereco) => RawMaterialButton(
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(20),
                          child: Text(StringUtil.formatEndereco(endereco)),
                        ),
                        onPressed: () {
                          LaunchUtil.endereco(
                              StringUtil.formatEndereco(endereco));
                          Navigator.of(context).pop();
                        }))
                    .toList(),
              ));
    }

    return null;
  }

  VoidCallback _telefone(BuildContext context, Institucional institucional) {
    if (institucional?.telefones?.isNotEmpty ?? false) {
      if (institucional.telefones.length == 1) {
        return () {
          LaunchUtil.telefone(institucional.telefones[0]);
          Navigator.of(context).pop();
        };
      }

      return () => showDialog(
          context: context,
          builder: (context) => SimpleDialog(
                title: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.location_on,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const IntlText("institucional.telefones")
                  ],
                ),
                children: institucional.telefones
                    .map((telefone) => RawMaterialButton(
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(20),
                          child: Text(StringUtil.formatTelefone(telefone)),
                        ),
                        onPressed: () {
                          LaunchUtil.telefone(telefone);
                          Navigator.of(context).pop();
                        }))
                    .toList(),
              ));
    }

    return null;
  }
}

class _OpcaoItem extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Widget label;

  const _OpcaoItem({
    this.icon,
    this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (onPressed == null) {
      return Container();
    }

    Tema tema = ConfiguracaoApp.of(context).tema;

    return RawMaterialButton(
      fillColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: tema.primary,
            size: 40,
          ),
          const SizedBox(
            height: 10,
          ),
          label
        ],
      ),
      onPressed: onPressed,
    );
  }
}
