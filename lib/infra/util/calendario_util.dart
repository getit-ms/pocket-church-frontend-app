part of pocket_church.infra;

class CalendarioUtil {
  static DeviceCalendarPlugin _deviceCalendarPlugin =
      new DeviceCalendarPlugin();

  static addEvento(BuildContext context, {EventoCalendario evento}) async {
    bool confirmado = await showCupertinoModalPopup(
      context: context,
      builder: (context) => AlertDialog(
        title: const IntlText("calendario.salvar_evento"),
        content: IntlText(
          "mensagens.MSG-063",
          args: {
            'evento': evento.descricao,
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: const IntlText("global.sim"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: const IntlText("global.nao"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );

    if (!confirmado) {
      return;
    }

    Result<bool> result = await _deviceCalendarPlugin.requestPermissions();
    if (result.isSuccess && result.data) {
      try {
        Result<List<Calendar>> calendarios =
            await _deviceCalendarPlugin.retrieveCalendars();

        if (result.isSuccess) {
          if (calendarios.data.isEmpty) {
            MessageHandler.warn(
                Scaffold.of(context), const IntlText("mensagens.MSG-058"));
          } else if (calendarios.data.length == 1) {
            await _createEvent(calendarios.data[0], evento, context);
          } else {
            Calendar cal = await showModalBottomSheet<Calendar>(
              context: context,
              builder: (ctx) => BottomMenu(
                items: calendarios.data
                    .map((cal) => BottomMenuItem(
                          label: Text(cal.name),
                          action: () async {
                            Navigator.of(ctx).pop(cal);
                          },
                        ))
                    .toList(),
              ),
            );

            if (cal == null) {
              return;
            }

            await _createEvent(cal, evento, context);
          }
        } else {
          MessageHandler.error(
              Scaffold.of(context), const IntlText("mensagens.MSG-064"));
        }
      } catch (ex) {
        MessageHandler.error(
            Scaffold.of(context), const IntlText("mensagens.MSG-064"));
      }
    }
  }

  static Future _createEvent(
      Calendar cal, EventoCalendario evento, BuildContext context) async {
    Result<String> created =
        await _deviceCalendarPlugin.createOrUpdateEvent(Event(
      cal.id,
      start: evento.inicio,
      end: evento.termino,
      title: evento.descricao,
      description: evento.local,
    ));

    if (created.isSuccess) {
      MessageHandler.success(
          Scaffold.of(context), const IntlText("mensagens.MSG-001"));
    } else {
      MessageHandler.error(
          Scaffold.of(context), const IntlText("mensagens.MSG-064"));
    }
  }
}
