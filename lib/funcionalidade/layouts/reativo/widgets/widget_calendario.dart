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
        height: 250,
        child: InfiniteList(
          tamanhoPagina: 10,
          scrollDirection: Axis.horizontal,
          provider: (pagina, tamanho) async {
            return await calendarioApi.consulta(pagina, tamanho);
          },
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          builder: (context, itens, index) {
            return new _EventoAgenda(evento: itens[index]);
          },
          placeholderSize: 270,
          placeholderBuilder: (context) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
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
    bool mesmoDia =
        DateUtil.compareDateOnly(DateTime.now(), evento.inicio) >= 0 &&
            DateUtil.compareDateOnly(DateTime.now(), evento.termino) <= 0;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: CustomElevatedButton(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              )
            ],
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                mesmoDia ? tema.primary : const Color(0xFFFAFAFA),
                mesmoDia ? tema.secondary : const Color(0xFFFAFAFA),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    evento.inicio.day == evento.termino.day
                        ? evento.inicio.day.toString()
                        : evento.inicio.day.toString() +
                            " - " +
                            evento.termino.day.toString(),
                    style: TextStyle(
                      color: mesmoDia ? Colors.white : Colors.black54,
                      fontSize:
                          evento.inicio.day == evento.termino.day ? 40 : 30,
                      height: .75,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    _month.format(evento.inicio),
                    style: TextStyle(
                      color: mesmoDia ? Colors.white : Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _time.format(evento.inicio) +
                    " - " +
                    _time.format(evento.termino),
                style: TextStyle(
                  color: mesmoDia ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 120,
                child: Text(
                  evento.descricao ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    color: mesmoDia ? Colors.white : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
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
