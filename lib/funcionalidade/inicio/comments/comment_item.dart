part of pocket_church.inicio;

class CommentItem extends StatelessWidget {
  final Comentario comentario;

  const CommentItem({
    Key key,
    this.comentario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    var config = ConfiguracaoApp.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: FotoMembro(
              comentario.membro.foto,
              size: 45,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            comentario.membro.nome,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          IntlText(
                            "timeline.comentario.data_hora",
                            args: {
                              'data': StringUtil.formatData(
                                comentario.dataHora,
                                pattern:
                                    config.bundle['config.pattern.dateHour'],
                              ),
                            },
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // TODO adicionar opções de excluir e denunciar
                    // IconButton(
                    //   icon: Icon(Icons.more_vert),
                    //   onPressed: () {},
                    //   color: isDark ? Colors.white70 : Colors.black54,
                    // ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    comentario.comentario,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
