part of pocket_church.componentes;

class Opcao<T> {
  final String intlLabel;
  final T valor;

  const Opcao({this.intlLabel, this.valor});
}

class SelectOpcao<T> extends StatelessWidget {
  final T value;
  final FormFieldValidator<T> validator;
  final FormFieldSetter<T> onSaved;
  final Function(T value) onChange;
  final List<Opcao<T>> opcoes;

  const SelectOpcao({
    this.value,
    this.opcoes,
    this.onSaved,
    this.onChange,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return FormField<T>(
      initialValue: value,
      validator: validator,
      onSaved: onSaved,
      builder: (state) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: opcoes
                .map((opcao) => IntlBuilder(
                      text: opcao.intlLabel,
                      builder: (context, snapshot) {
                        return InputChip(
                          label: Text(snapshot.data ?? ""),
                          onPressed: () {
                            state.didChange(opcao.valor);

                            if (onChange != null) {
                              onChange(opcao.valor);
                            }
                          },
                          selected: state.value == opcao.valor,
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                          padding: const EdgeInsets.all(10),
                        );
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
