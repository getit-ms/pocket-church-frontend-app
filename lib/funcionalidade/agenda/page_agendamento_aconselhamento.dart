part of pocket_church.agenda;

class PageAgendamentoAconselhamento extends StatefulWidget {
  @override
  _PageAgendamentoAconselhamentoState createState() =>
      _PageAgendamentoAconselhamentoState();
}

class _PageAgendamentoAconselhamentoState
    extends State<PageAgendamentoAconselhamento> {
  CalendarioAconselhamento _calendario;
  DateTime _dataSelecionada;
  List<HorarioCalendarioAconselhamento> _horarios;
  HorarioCalendarioAconselhamento _horarioSelecionado;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const IntlText("agenda.agendamentos"),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _header(),
              _pastor(),
              _diasCalendario(),
              _horariosDia(),
              _commandButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commandButton(BuildContext context) {
    if (_calendario != null &&
        _dataSelecionada != null &&
        _horarioSelecionado != null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: CommandButton<Aconselhamento>(
          child: const IntlText("agenda.agendar"),
          onPressed: (loading) async {
            await loading(agendaApi.agendar(
                calendario: _calendario.id,
                horario: _horarioSelecionado.id,
                data: _dataSelecionada));

            Navigator.of(context).pop();

            MessageHandler.success(
              Scaffold.of(context),
              const IntlText("mensagens.MSG-029"),
            );
          },
        ),
      );
    }

    return Container();
  }

  Widget _horariosDia() {
    if (_horarios != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonFormField<HorarioCalendarioAconselhamento>(
          value: _horarioSelecionado,
          onChanged: (val) {
            setState(() {
              _horarioSelecionado = val;
            });
          },
          hint: const IntlText("agenda.horario"),
          items: _horarios
              .map((hor) => DropdownMenuItem(
                    child: Text(hor.horaInicio.substring(0, 5) +
                        " - " +
                        hor.horaFim.substring(0, 5)),
                    value: hor,
                  ))
              .toList(),
        ),
      );
    }

    return Container();
  }

  Widget _diasCalendario() {
    Tema tema = ConfiguracaoApp.of(context).tema;

    if (_calendario != null) {
      return FutureBuilder<List<EventoCalendarioAconselhamento>>(
          key: ValueKey(_calendario),
          future: agendaApi.buscaHorarios(_calendario.id,
              inicio: DateTime.now(),
              termino: DateTime.now().add(const Duration(days: 90))),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CalendarCarousel<HorarioCalendarioAconselhamento>(
                width: double.infinity,
                height: 450,
                locale: "pt-br",
                headerTextStyle: TextStyle(
                  color: tema.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                weekDayFormat: WeekdayFormat.narrow,
                customGridViewPhysics: FixedExtentScrollPhysics(),
                inactiveWeekendTextStyle: TextStyle(
                  color: tema.secondary.withOpacity(.5),
                ),
                weekdayTextStyle: TextStyle(
                  color: tema.secondary,
                  fontWeight: FontWeight.bold,
                ),
                weekendTextStyle: TextStyle(
                  color: tema.secondary,
                  fontWeight: FontWeight.bold,
                ),
                markedDateShowIcon: true,
                markedDateIconBuilder: (horario) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black12,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 30,
                        left: 30,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tema.primary,
                      ),
                    ),
                  );
                },
                markedDatesMap: _markedDates(
                  eventos: snapshot.data,
                ),
                selectedDayButtonColor: tema.primary,
                selectedDateTime: _dataSelecionada,
                todayBorderColor: tema.secondary,
                daysHaveCircularBorder: true,
                todayButtonColor: Colors.white,
                minSelectedDate:
                    DateTime.now().subtract(const Duration(days: 1)),
                maxSelectedDate: DateTime.now().add(const Duration(days: 90)),
                todayTextStyle: TextStyle(
                  color: tema.secondary,
                ),
                onDayPressed: (date, horarios) {
                  setState(() {
                    _dataSelecionada = date;
                    _horarios = horarios;
                    _horarioSelecionado = null;
                  });
                },
                iconColor: tema.primary,
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: const IntlText("agenda.nenhum_horario"),
              );
            }

            return _buildLoading();
          });
    }

    return Container();
  }

  Padding _buildLoading() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _header() {
    Tema tema = ConfiguracaoApp.of(context).tema;

    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: IntlText(
          "agenda.novo_agendamento",
          style: TextStyle(
            color: tema.primary,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  Widget _pastor() {
    return FutureBuilder<List<CalendarioAconselhamento>>(
      future: agendaApi.buscaCalendarios(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty ?? true) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: IntlText("global.nenhum_registro_encontrado"),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButtonFormField<CalendarioAconselhamento>(
                value: _calendario,
                onChanged: (val) {
                  setState(() {
                    _calendario = val;
                    _dataSelecionada = null;
                    _horarioSelecionado = null;
                  });
                },
                hint: const IntlText("agenda.pastor"),
                items: snapshot.data
                    .map((cal) => DropdownMenuItem(
                          child: Text(cal.pastor.nome),
                          value: cal,
                        ))
                    .toList(),
              ),
            );
          }
        }

        return _buildLoading();
      },
    );
  }

  EventList<HorarioCalendarioAconselhamento> _markedDates({
    DateTime termino,
    List<EventoCalendarioAconselhamento> eventos,
  }) {
    Map<DateTime, List<HorarioCalendarioAconselhamento>> events = {};

    eventos.forEach((evento) {
      DateTime trunc = DateTime(evento.dataInicio.year, evento.dataInicio.month,
          evento.dataInicio.day);

      if (!events.containsKey(trunc)) {
        events[trunc] = [];
      }

      events[trunc].add(evento.horario);
    });

    return new EventList(events: events);
  }
}
