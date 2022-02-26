part of pocket_church.componentes;

const double kSelecaoCalendarioMinHeight = 120;
const double kSelecaoCalendarioMaxHeight = 350;

typedef DateSelectCallback = Function(DateTime date);
typedef PeriodChangeCallback = Function(DateTime from, DateTime to);

typedef DateBuilder = Widget Function(DateTime date,
    {bool selected, bool currentSlide});

class SelecaoCalendario extends StatefulWidget {
  final double width;
  final DateTime selectedDate;
  final Curve indicatorAnimationCurve;
  final Duration indicatorAnimationDuration;
  final Color indicatorColor;
  final Decoration indicator;
  final DateSelectCallback onDateSelect;
  final PeriodChangeCallback onPeriodChange;
  final ValueChanged<ViewType> onViewTypeChange;
  final ViewType viewType;
  final DateBuilder dateBuilder;

  const SelecaoCalendario({
    this.width,
    this.selectedDate,
    this.viewType = ViewType.week,
    this.dateBuilder,
    this.indicator,
    this.indicatorColor,
    this.onDateSelect,
    this.onPeriodChange,
    this.onViewTypeChange,
    this.indicatorAnimationDuration = const Duration(milliseconds: 300),
    this.indicatorAnimationCurve = Curves.easeInOut,
  });

  @override
  _SelecaoCalendarioState createState() => _SelecaoCalendarioState();
}

class _SelecaoCalendarioState extends State<SelecaoCalendario>
    with TickerProviderStateMixin {
  ViewType _viewType = ViewType.week;

  Offset _verticalPosition;
  double _currentHeight = kSelecaoCalendarioMinHeight;

  Offset _horizontalPosition;
  double _currentSlidePosition = 0;

  AnimationController _heightController;
  Animation<double> _height;

  AnimationController _nextSlideController;
  Animation<double> _nextSlide;

  AnimationController _previewsSlideController;
  Animation<double> _previewsSlide;

  DateTime _selectedDate;

  List<List<DateTime>> _previewsMonth;
  List<List<DateTime>> _currentMonth;
  List<List<DateTime>> _nextMonth;

  List<DateTime> _currentWeek;

  @override
  void initState() {
    super.initState();

    _heightController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() => setState(() {
          _currentHeight = _height.value;
        }));

    _height = Tween<double>(
      begin: kSelecaoCalendarioMinHeight,
      end: kSelecaoCalendarioMaxHeight,
    ).animate(CurvedAnimation(
      curve: Curves.easeOut,
      parent: _heightController,
    ));

    _nextSlideController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() => setState(() {
          _currentSlidePosition = _nextSlide.value;
        }));

    _nextSlide = Tween<double>(
      begin: 0,
      end: -1,
    ).animate(CurvedAnimation(
      curve: Curves.easeOut,
      parent: _nextSlideController,
    ));

    _previewsSlideController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() => setState(() {
          _currentSlidePosition = _previewsSlide.value;
        }));

    _previewsSlide = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      curve: Curves.easeOut,
      parent: _previewsSlideController,
    ));

    _viewType = widget.viewType;

    _selectedDate = widget.selectedDate ?? DateTime.now();
    _currentMonth = _preparaMonth(reference: _selectedDate);
    _previewsMonth = _preparaMonth(
        reference: DateTime(_selectedDate.year, _selectedDate.month - 1, 1));
    _nextMonth = _preparaMonth(
        reference: DateTime(_selectedDate.year, _selectedDate.month + 1, 1));
    _currentWeek = _currentMonth.firstWhere(_selectedWeek);

    if (widget.onPeriodChange != null) {
      if (_viewType == ViewType.week) {
        widget.onPeriodChange(
          _currentWeek[0],
          _currentWeek[6],
        );
      } else {
        widget.onPeriodChange(
          DateTime(_selectedDate.year, _selectedDate.month, 1),
          DateTime(_selectedDate.year, _selectedDate.month + 1, 0),
        );
      }
    }
  }

  _selectDate(DateTime date) async {
    bool periodChange = false;
    int current = _currentMonth[2][0].year * 100 + _currentMonth[2][0].month;
    int selected = date.year * 100 + date.month;
    if (current != selected) {
      periodChange = true;

      if (_viewType == ViewType.month) {
        if (current < selected) {
          _nextMonth = _preparaMonth(reference: date);

          await _nextSlideController.forward(from: 0);
        } else if (current > selected) {
          _previewsMonth = _preparaMonth(reference: date);

          await _previewsSlideController.forward(from: 0);
        }
      }

      _currentMonth = _preparaMonth(reference: date);
      _previewsMonth =
          _preparaMonth(reference: DateTime(date.year, date.month - 1, 1));
      _nextMonth =
          _preparaMonth(reference: DateTime(date.year, date.month + 1, 1));
    } else if (!_currentWeek.any(_equals(date)) && _viewType == ViewType.week) {
      periodChange = true;

      if (current < selected) {
        await _nextSlideController.forward(from: 0);
      } else if (current > selected) {
        await _previewsSlideController.forward(from: 0);
      }
    }

    _currentWeek = _currentMonth.firstWhere((w) => w.any(_equals(date)));

    setState(() {
      _currentSlidePosition = 0;
      _selectedDate = date;
    });

    if (widget.onDateSelect != null) {
      widget.onDateSelect(_selectedDate);
    }

    if (periodChange && widget.onPeriodChange != null) {
      if (_viewType == ViewType.week) {
        widget.onPeriodChange(
          _currentWeek[0],
          _currentWeek[6],
        );
      } else {
        widget.onPeriodChange(
          DateTime(_selectedDate.year, _selectedDate.month, 1),
          DateTime(_selectedDate.year, _selectedDate.month + 1, 0),
        );
      }
    }
  }

  _changeCurrentWeek(List<DateTime> week) {
    if (!_currentMonth.contains(week)) {
      if (_previewsMonth.contains(week)) {
        _nextMonth = _currentMonth;
        _currentMonth = _previewsMonth;
        _previewsMonth =
            _preparaMonth(reference: DateTime(week[0].year, week[0].month - 1));
      } else {
        _previewsMonth = _currentMonth;
        _currentMonth = _nextMonth;
        _nextMonth =
            _preparaMonth(reference: DateTime(week[0].year, week[0].month + 1));
      }
    }

    setState(() {
      _currentSlidePosition = 0;
      _currentWeek = week;
    });

    if (widget.onPeriodChange != null) {
      widget.onPeriodChange(
        _currentWeek[0],
        _currentWeek[6],
      );
    }
  }

  _changeCurrentMonth(List<List<DateTime>> month) {
    if (month == _previewsMonth) {
      _nextMonth = _currentMonth;
      _previewsMonth = _preparaMonth(
          reference: DateTime(month[2][0].year, month[2][0].month - 1));
    } else if (month == _nextMonth) {
      _previewsMonth = _currentMonth;
      _nextMonth = _preparaMonth(
          reference: DateTime(month[2][0].year, month[2][0].month + 1));
    }

    _currentWeek = month[0];

    setState(() {
      _currentSlidePosition = 0;
      _currentMonth = month;
    });

    if (widget.onPeriodChange != null) {
      widget.onPeriodChange(
        DateTime(_currentMonth[2][0].year, _currentMonth[2][0].month, 1),
        DateTime(_currentMonth[2][0].year, _currentMonth[2][0].month + 1, 0),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();

    _heightController.dispose();
    _nextSlideController.dispose();
    _previewsSlideController.dispose();
  }

  get _previewsWeek {
    int indexCurrent = _currentMonth.indexOf(_currentWeek);

    if (indexCurrent == 0) {
      return _previewsMonth.lastWhere((w) =>
          w[6].millisecondsSinceEpoch < _currentWeek[0].millisecondsSinceEpoch);
    }

    return _currentMonth[indexCurrent - 1];
  }

  get _nextWeek {
    int indexCurrent = _currentMonth.indexOf(_currentWeek);

    if (indexCurrent == 5) {
      return _nextMonth.firstWhere((w) =>
          w[0].millisecondsSinceEpoch > _currentWeek[6].millisecondsSinceEpoch);
    }

    return _currentMonth[indexCurrent + 1];
  }

  get _heightProportion =>
      (_currentHeight - kSelecaoCalendarioMinHeight) /
      (kSelecaoCalendarioMaxHeight - kSelecaoCalendarioMinHeight);

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onHorizontalDragStart: (details) {
        _horizontalPosition = details.localPosition;
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _currentSlidePosition =
              (details.localPosition.dx - _horizontalPosition.dx) /
                  widget.width;
        });
      },
      onHorizontalDragEnd: (details) async {
        if (_currentSlidePosition > 0) {
          if (_currentSlidePosition > .3 ||
              details.velocity.pixelsPerSecond.dx > 600) {
            await _previewsSlideController.forward(from: _currentSlidePosition);

            if (_viewType == ViewType.week) {
              _changeCurrentWeek(_previewsWeek);
            } else {
              _changeCurrentMonth(_previewsMonth);
            }
          } else {
            await _previewsSlideController.reverse(from: _currentSlidePosition);
          }
        } else if (_currentSlidePosition < 0) {
          if (_currentSlidePosition < -.3 ||
              details.velocity.pixelsPerSecond.dx < 600) {
            await _nextSlideController.forward(from: -_currentSlidePosition);

            if (_viewType == ViewType.week) {
              _changeCurrentWeek(_nextWeek);
            } else {
              _changeCurrentMonth(_nextMonth);
            }
          } else {
            await _nextSlideController.reverse(from: -_currentSlidePosition);
          }
        }
      },
      onVerticalDragStart: (details) {
        _verticalPosition = details.localPosition;
      },
      onVerticalDragUpdate: (details) {
        setState(() {
          _currentHeight = math.min(
            math.max(
              _currentHeight + details.localPosition.dy - _verticalPosition.dy,
              kSelecaoCalendarioMinHeight,
            ),
            kSelecaoCalendarioMaxHeight,
          );
          _verticalPosition = details.localPosition;
        });
      },
      onVerticalDragEnd: (details) {
        if (_viewType == ViewType.week) {
          if (_heightProportion > .5 ||
              details.velocity.pixelsPerSecond.dy > 600) {
            _viewType = ViewType.month;
            widget.onViewTypeChange(_viewType);

            if (_currentHeight != kSelecaoCalendarioMinHeight) {
              _heightController.forward(from: _heightProportion);
            }

            if (widget.onPeriodChange != null) {
              widget.onPeriodChange(
                DateTime(_selectedDate.year, _selectedDate.month, 1),
                DateTime(_selectedDate.year, _selectedDate.month + 1, 0),
              );
            }
          } else if (_currentHeight != kSelecaoCalendarioMaxHeight) {
            _heightController.reverse(from: _heightProportion);
          }
        } else {
          if (_heightProportion < .5 ||
              details.velocity.pixelsPerSecond.dy < 600) {
            _viewType = ViewType.week;
            widget.onViewTypeChange(_viewType);

            if (_currentHeight != kSelecaoCalendarioMinHeight) {
              _heightController.reverse(from: _heightProportion);
            }

            if (widget.onPeriodChange != null) {
              widget.onPeriodChange(
                _currentWeek[0],
                _currentWeek[6],
              );
            }
          } else if (_currentHeight != kSelecaoCalendarioMaxHeight) {
            _heightController.forward(from: _heightProportion);
          }
        }
      },
      child: Container(
        width: widget.width,
        height: _currentHeight,
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
          ),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              if (_currentSlidePosition > 0)
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: (_currentSlidePosition - 1) * widget.width,
                  width: widget.width,
                  child: _buildSlide(
                    context,
                    week: _previewsWeek,
                    month: _viewType == ViewType.week &&
                            _currentMonth.contains(_previewsWeek)
                        ? _currentMonth
                        : _previewsMonth,
                  ),
                ),
              Positioned(
                top: 0,
                bottom: 0,
                left: _currentSlidePosition * widget.width,
                width: widget.width,
                child: _buildSlide(
                  context,
                  week: _currentWeek,
                  month: _currentMonth,
                ),
              ),
              if (_currentSlidePosition < 0)
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: (1 + _currentSlidePosition) * widget.width,
                  width: widget.width,
                  child: _buildSlide(
                    context,
                    week: _nextWeek,
                    month: _viewType == ViewType.week &&
                            _currentMonth.contains(_nextWeek)
                        ? _currentMonth
                        : _nextMonth,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _equals(DateTime d1) => (DateTime d2) =>
      d1.day == d2.day && d1.month == d2.month && d1.year == d2.year;

  Widget _buildSlide(BuildContext context,
      {List<DateTime> week, List<List<DateTime>> month}) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    bool containsSelectedDate =
        (_viewType == ViewType.week && week.any(_equals(_selectedDate))) ||
            (_viewType == ViewType.month &&
                month[2][0].year == _selectedDate.year &&
                month[2][0].month == _selectedDate.month);

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        if (containsSelectedDate)
          AnimatedPositioned(
            curve: widget.indicatorAnimationCurve,
            duration: widget.indicatorAnimationDuration,
            top: lerpDouble(
                4,
                lerpDouble(
                    68,
                    68 + (kSelecaoCalendarioMaxHeight - 70) / 6 * 5,
                    month.indexWhere((w) => w.any(_equals(_selectedDate))) /
                        5.0),
                _heightProportion),
            left: lerpDouble(5, widget.width / 7 * 6 + 5,
                (_selectedDate.weekday % DateTime.daysPerWeek) / 6.0),
            child: Container(
              height: lerpDouble(kSelecaoCalendarioMinHeight - 8,
                  (kSelecaoCalendarioMaxHeight - 70) / 6, _heightProportion),
              width: widget.width / 7 - 10,
              decoration: widget.indicator ??
                  ShapeDecoration(
                    color:
                        widget.indicatorColor ?? Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(45)),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 5,
                      ),
                    ],
                  ),
            ),
          ),
        if (_currentHeight > kSelecaoCalendarioMinHeight)
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: _heightProportion,
              child: Text(DateFormat("MMMM yyyy").format(month[2][0])),
            ),
          ),
        Positioned(
          top: lerpDouble(10, 40, _heightProportion),
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (DateTime date in _currentWeek)
                AnimatedDefaultTextStyle(
                  duration: widget.indicatorAnimationDuration,
                  style: TextStyle(
                    color: _viewType == ViewType.week &&
                            _equals(_selectedDate)(date)
                        ? Theme.of(context).primaryTextTheme.headline6.color
                        : isDark
                            ? Colors.white54
                            : Colors.black54,
                  ),
                  child: _itemCalendario(
                    context,
                    child: Text(DateFormat("EE").format(date)),
                    height: lerpDouble(kSelecaoCalendarioMinHeight * .25, 20,
                        _heightProportion),
                  ),
                ),
            ],
          ),
        ),
        ...(_buildMatrix(
          context,
          month: month,
          focuesedWeek: week,
        )),
        if (_currentHeight < kSelecaoCalendarioMaxHeight)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 1 - _heightProportion,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  for (DateTime data in week)
                    _itemCalendario(
                      context,
                      child: AnimatedDefaultTextStyle(
                        duration: widget.indicatorAnimationDuration,
                        style: TextStyle(
                          color: _equals(_selectedDate)(data)
                              ? Theme.of(context).primaryTextTheme.headline6.color
                              : isDark
                                  ? Colors.white54
                                  : Colors.black54,
                        ),
                        child: Text(
                          DateFormat("MMM").format(data),
                        ),
                      ),
                      height: kSelecaoCalendarioMinHeight * .25,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildMatrix(BuildContext context,
      {List<List<DateTime>> month, List<DateTime> focuesedWeek}) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    List<Widget> weeks = [];

    for (int i = 0; i < month.length; i++) {
      List<DateTime> week = month[i];

      if (_currentHeight > kSelecaoCalendarioMinHeight ||
          week == focuesedWeek) {
        weeks.add(
          Positioned(
            top: lerpDouble(
                kSelecaoCalendarioMinHeight * .25,
                70 + (kSelecaoCalendarioMaxHeight - 70) / 6 * i,
                _heightProportion),
            left: 0,
            right: 0,
            child: _itemCalendario(
              context,
              child: Opacity(
                opacity: week == focuesedWeek ? 1 : _heightProportion,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    for (DateTime date in week)
                      AnimatedDefaultTextStyle(
                        duration: widget.indicatorAnimationDuration,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: _equals(_selectedDate)(date)
                              ? Theme.of(context).primaryTextTheme.headline6.color
                              : _currentHeight == kSelecaoCalendarioMinHeight ||
                                      date.month == month[2][0].month
                                  ? isDark
                                      ? Colors.white54
                                      : Colors.black54
                                  : isDark
                                      ? Colors.white24
                                      : Colors.black26,
                        ),
                        child: InkWell(
                          onTap: () {
                            _selectDate(date);
                          },
                          child: _itemCalendario(context,
                              child: _buildDate(
                                date,
                                selected: _equals(_selectedDate)(date),
                                currentSlide: _currentHeight ==
                                        kSelecaoCalendarioMinHeight ||
                                    date.month == month[2][0].month,
                              ),
                              height: lerpDouble(
                                  kSelecaoCalendarioMinHeight * .5,
                                  (kSelecaoCalendarioMaxHeight - 70) / 6,
                                  _heightProportion)),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    return weeks;
  }

  Widget _buildDate(DateTime date, {bool selected, bool currentSlide}) {
    if (widget.dateBuilder != null) {
      return widget.dateBuilder(date,
          selected: selected, currentSlide: currentSlide);
    }

    return Text(DateFormat("dd").format(date));
  }

  Widget _itemCalendario(BuildContext context, {Widget child, double height}) {
    return Container(
      alignment: Alignment.center,
      width: widget.width / 7,
      height: height,
      child: child,
    );
  }

  _preparaMonth({DateTime reference}) {
    DateTime inicio = DateTime(
        reference.year,
        reference.month,
        1 -
            DateTime(reference.year, reference.month, 1).weekday %
                DateTime.daysPerWeek);

    List<List<DateTime>> matrix = [];

    List<DateTime> currentWeek = [];
    for (DateTime current = inicio;
        matrix.length < 6;
        current = DateTime(current.year, current.month, current.day + 1)) {
      currentWeek.add(current);

      if (currentWeek.length == 7) {
        matrix.add(currentWeek);
        currentWeek = [];
      }
    }

    return matrix;
  }

  bool _selectedWeek(List<DateTime> week) {
    return week.any((date) =>
        date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day);
  }

  @override
  void didUpdateWidget(SelecaoCalendario oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedDate != null &&
        !_equals(_selectedDate)(widget.selectedDate)) {
      _selectDate(widget.selectedDate);
    }

    if (_viewType != widget.viewType) {
      if (widget.viewType == ViewType.week) {
        _heightController.reverse(from: 1).then((_) {
          _viewType = widget.viewType;
        });
      } else {
        _heightController.forward(from: 0).then((_) {
          _viewType = widget.viewType;
        });
      }
    }
  }
}
