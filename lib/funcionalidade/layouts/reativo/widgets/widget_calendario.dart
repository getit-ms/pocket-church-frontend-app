part of pocket_church.widgets_reativos;

class WidgetCalendario extends StatelessWidget {
  const WidgetCalendario();

  @override
  Widget build(BuildContext context) {
    return WidgetBody(
      title: const IntlText("calendario.agenda"),
      onMore: () {
        NavigatorUtil.navigate(
          context,
          builder: (context) => PageCalendario(),
        );
      },
      body: Container(
        height: 120,
        child: InfiniteList(
          tamanhoPagina: 10,
          scrollDirection: Axis.horizontal,
          provider: (pagina, tamanho) async {
            return await calendarioApi.consulta(pagina, tamanho);
          },
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
          builder: (context, itens, index) {
            return new _EventoAgenda(evento: itens[index]);
          },
          placeholderSize: 270,
          placeholderBuilder: (context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 260,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
            );
          },
        ),
      ),
    );
  }
}

final _month = DateFormat("MMM");
final _time = DateFormat("HH:mm");

class _EventoAgenda extends StatelessWidget {
  final EventoCalendario evento;

  const _EventoAgenda({this.evento});

  @override
  Widget build(BuildContext context) {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: RawMaterialButton(
        fillColor: Colors.white,
        padding: const EdgeInsets.all(10),
        shape: const RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: <Widget>[
            Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    color: tema.buttonBackground,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black54,
                        blurRadius: 2,
                      )
                    ]),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(
                      evento.inicio.day.toString(),
                      style: TextStyle(
                        color: tema.buttonText,
                        fontSize: 35,
                      ),
                    ),
                    Text(
                      _month.format(evento.inicio),
                      style: TextStyle(
                        color: tema.buttonText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              width: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _time.format(evento.inicio) +
                        " - " +
                        _time.format(evento.termino),
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      evento.descricao ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        onPressed: () {
          CalendarioUtil.addEvento(
            context,
            evento: evento,
          );
        },
      ),
    );
  }
}
