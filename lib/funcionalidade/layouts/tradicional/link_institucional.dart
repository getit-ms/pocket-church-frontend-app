part of pocket_church.layout_tradicional;

class LinksInstitucional extends StatelessWidget {
  final Map<String, IconData> redesSociais = {
    'facebook': FontAwesomeIcons.facebookF,
    'instagram': FontAwesomeIcons.instagram,
    'youtube': FontAwesomeIcons.youtube,
    'foursquare': FontAwesomeIcons.foursquare,
    'twitter': FontAwesomeIcons.twitter
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: StreamBuilder<Institucional>(
        stream: institucionalBloc.institucional,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _parseLinks(snapshot.data),
            );
          }

          return Container();
        },
      ),
    );
  }

  List<Widget> _parseLinks(Institucional institucional) {
    List<Widget> links = [];

    if (institucional.site != null) {
      links.add(IconButton(
        icon: Icon(
          FontAwesomeIcons.globe,
        ),
        onPressed: () {
          LaunchUtil.site(institucional.site);
        },
        color: Colors.white,
        padding: EdgeInsets.all(2),
      ));
    }

    if (institucional.redesSociais != null &&
        institucional.redesSociais.isNotEmpty) {
      redesSociais.keys.forEach((rs) {
        if (institucional.redesSociais[rs] != null) {
          links.add(IconButton(
            icon: Icon(
              redesSociais[rs],
            ),
            onPressed: () {
              LaunchUtil.site(institucional.redesSociais[rs]);
            },
            color: Colors.white,
            padding: EdgeInsets.all(2),
          ));
        }
      });
    }

    return links;
  }
}
