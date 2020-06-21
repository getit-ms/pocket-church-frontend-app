part of pocket_church.componentes;

class InputData extends StatefulWidget {
  const InputData({
    Key key,
    this.hintText,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autofocus = false,
    this.controller,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode, this.decoration,
  }) : super(key: key);

  final String hintText;
  final DateTime initialValue;
  final bool autofocus;
  final FormFieldValidator<DateTime> validator;
  final ValueChanged<DateTime> onSaved;
  final ValueChanged<DateTime> onChanged;
  final ValueChanged<DateTime> onFieldSubmitted;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final InputDecoration decoration;

  @override
  _InputDataState createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ??
        TextEditingController(
          text: widget.initialValue != null
              ? StringUtil.formatData(
                  widget.initialValue,
                  pattern: "dd/MM/yyyy",
                )
              : "",
        );
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.controller == null) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: widget.initialValue,
      validator: widget.validator,
      onSaved: widget.onSaved,
      builder: (field) {
        return TextField(
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          keyboardType: TextInputType.datetime,
          onSubmitted: (value) {
            DateTime date;
            if (value?.length == 10) {
              date = StringUtil.parseData(value, pattern: "dd/MM/yyyy");
            }

            widget.onFieldSubmitted(date);
          },
          inputFormatters: [
            services.TextInputFormatter.withFunction(TextFormatUtil.formataData)
          ],
          controller: _controller,
          autofocus: widget.autofocus,
          onChanged: (value) {
            DateTime date;
            if (value?.length == 10) {
              date = StringUtil.parseData(value, pattern: "dd/MM/yyyy");
            }

            field.didChange(date);
            field.validate();
            if (widget.onChanged != null) {
              widget.onChanged(date);
            }
          },
          decoration: (widget.decoration ?? InputDecoration()).copyWith(
            hintText: widget.hintText,
            errorText: field.errorText,
            suffixIcon: IconButton(
              onPressed: () async {
                DateTime escolha = await showDatePicker(
                  context: context,
                  locale: Locale('pt', 'BR'),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2900),
                  initialDate: field.value ?? DateTime.now(),
                  initialDatePickerMode: DatePickerMode.year,
                );

                if (escolha != null) {
                  field.didChange(escolha);
                  _controller.text =
                      StringUtil.formatData(escolha, pattern: "dd/MM/yyyy");
                }
              },
              icon: Icon(Icons.calendar_today),
            ),
          ),
        );
      },
    );
  }
}
