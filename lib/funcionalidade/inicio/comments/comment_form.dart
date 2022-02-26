part of pocket_church.inicio;

typedef CommentSentCallback = Function(Comentario comentario);

class CommentForm extends StatefulWidget {
  final ItemEvento itemEvento;
  final CommentSentCallback onCommentSent;

  const CommentForm({
    Key key,
    this.itemEvento,
    this.onCommentSent,
  }) : super(key: key);

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  GlobalKey<CommandButtonState<dynamic>> _button =
  GlobalKey<CommandButtonState<dynamic>>();

  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    var config = ConfiguracaoApp.of(context);

    return Form(
      key: _form,
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF222222) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                maxLines: 3,
                minLines: 1,
                onFieldSubmitted: (_) => _button.currentState.processCommand(),
                decoration: InputDecoration(
                  hintText: config.bundle['timeline.comentario.escreva_aqui'],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            CommandButton<Comentario>(
              key: _button,
              elevation: 0,
              background: Colors.transparent,
              onPressed: (loading) async {
                if (_controller.text
                    .trim()
                    .isNotEmpty) {
                  Comentario enviado = await loading(
                      itemEventoApi.comenta(widget.itemEvento.tipo,
                        widget.itemEvento.id, Comentario(
                          comentario: _controller.text,
                        ),));

                  if (widget.onCommentSent != null) {
                    widget.onCommentSent(enviado);
                  }

                  _controller.clear();
                }
              },
              child: Icon(
                Icons.send,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
