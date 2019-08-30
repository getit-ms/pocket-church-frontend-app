part of pocket_church.componentes;


class NotificacaoInterna extends StatefulWidget {

  final VoidCallback action;
  final VoidCallback onDismissed;
  final String titulo;
  final String mensagem;

  const NotificacaoInterna({this.titulo, this.mensagem, this.action, this.onDismissed});

  @override
  _NotificacaoInternaState createState() => _NotificacaoInternaState();
}

class _NotificacaoInternaState extends State<NotificacaoInterna> {
  final key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Dismissible(
      key: key,
      child: Material(
        elevation: 14,
        color: Colors.white,
        child: SafeArea(
            child: MaterialButton(
              onPressed: widget.action,
              padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.notifications,
                      size: 30,
                      color: tema.primary
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.titulo,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: tema.primary
                          ),
                        ),
                        const SizedBox(height: 3,),
                        Text(widget.mensagem),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: IntlText("global.clique_para_visualizar",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black45
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
        ),
        textStyle: TextStyle(
            color: Colors.black
        ),
      ),
      onDismissed: (_) => widget.onDismissed(),
    );
  }
}