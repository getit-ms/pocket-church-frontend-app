part of pocket_church.inicio;

class BodyVideo extends StatelessWidget {
  final ItemEvento item;

  const BodyVideo({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return InkWell(
      onTap: () async {
        LaunchUtil.youtube(item.id);
      },
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: item.urlIlustracao,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black12,
                          Colors.white12,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    ),
                    child: Icon(
                      FontAwesomeIcons.youtube,
                      size: 80,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.titulo,
                  style: TextStyle(
                    color: tema.primary,
                    fontSize: 18,
                  ),
                ),
                if (item.apresentacao != null)
                  const SizedBox(height: 10),
                if (item.apresentacao != null)
                  Text(
                    item.apresentacao ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
