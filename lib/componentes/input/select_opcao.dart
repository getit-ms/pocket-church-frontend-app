part of pocket_church.componentes;

class Opcao<T> {
  final String intlLabel;
  final T valor;

  const Opcao({this.intlLabel, this.valor});
}

class SelectOpcao<T> extends StatelessWidget {
  final T value;
  final FormFieldSetter<T> onSaved;
  final List<Opcao<T>> opcoes;

  const SelectOpcao({this.value, this.opcoes, this.onSaved});

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: value,
      onSaved: onSaved,
      builder: (state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: opcoes.map((opcao) => IntlBuilder(
            text: opcao.intlLabel,
            builder: (context, snapshot) {
              return InputChip(
                label: Text(snapshot.data ?? ""),
                onPressed: () => state.didChange(opcao.valor),
                selected: state.value == opcao.valor,
                labelStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
                padding: const EdgeInsets.all(10),
              );
            },
          )).toList(),
        );
      },
    );
  }
}
