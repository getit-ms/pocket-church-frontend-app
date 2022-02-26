part of pocket_church.inicio;

class CommentPage extends StatefulWidget {
  final ItemEvento itemEvento;

  const CommentPage({Key key, this.itemEvento}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  GlobalKey<InfiniteListState> _list = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SizedBox(
      height: mediaQuery.size.height * 0.75,
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
        body: Column(
          children: [
            _header(context),
            Expanded(
              child: InfiniteList(
                key: _list,
                reverse: true,
                provider: (page, size) async {
                  return await itemEventoApi.buscaComentarios(
                      widget.itemEvento.tipo, widget.itemEvento.id, page, size);
                },
                builder: (context, itens, index) {
                  return CommentItem(comentario: itens[index]);
                },
              ),
            ),
            CommentForm(
              itemEvento: widget.itemEvento,
              onCommentSent: (comentario) {
                _list.currentState.insert(comentario, 0);
              },
            ),
          ],
        ),
      ),
    );
  }

  _header(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
          color: isDark ? const Color(0xFF222222) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
            )
          ]),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.comment,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                IntlText(
                  "timeline.comentario.comentarios",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 10),
                if (widget.itemEvento.quantidadeComentarios > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFCCCCCC),
                      shape: StadiumBorder(),
                    ),
                    child: Text(
                      widget.itemEvento.quantidadeComentarios.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  )
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ],
      ),
    );
  }
}
